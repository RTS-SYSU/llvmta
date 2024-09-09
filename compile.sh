#!/bin/bash

log_file=`pwd`/compile.log

echo "" > $log_file

echo "Build Date: $(date +%Y%m%d)" | tee -a $log_file

sudo apt-get remove -y clang | tee -a $log_file

echo "Installing dependencies" | tee -a $log_file
sudo apt-get update | tee -a $log_file

sudo apt-get -y install --no-install-recommends --fix-missing \
    lldb gcc gdb cmake make ninja-build libboost-all-dev git clangd \
    htop wget fish zsh lld time parallel lp-solve liblpsolve55-dev \
    icecc icecream-sundae libcolamd2 clang-tidy gcc-multilib \
    build-essential ccache python3-pip | tee -a $log_file

pip3 install numpy | tee -a $log_file

echo "Setting up LPSolve" | tee -a $log_file
sudo ln -s /usr/lib/lp_solve/liblpsolve55.so /usr/lib/liblpsolve55.so | tee -a $log_file

echo "Installing Gurobi" | tee -a $log_file
if [ ! -d thirdParty ]; then
    mkdir -p thirdParty
fi
pushd thirdParty
    wget -nv \
    https://packages.gurobi.com/9.5/gurobi9.5.2_linux64.tar.gz | tee -a $log_file; \
    tar xfz *.tar.gz | tee -a $log_file ; 
popd

echo "Setting environment variables" | tee -a $log_file
export GUROBI_HOME=`pwd`/thirdParty/gurobi952/linux64
export PATH=`pwd`/llvmta/build/bin:`pwd`/llvm/build/bin:${GUROBI_HOME}/bin:$PATH
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${GUROBI_HOME}/lib"
export CPLUS_INCLUDE_PATH="$CPLUS_INCLUDE_PATH:${GUROBI_HOME}/include"
export GRB_LICENSE_FILE=/workspaces/llvmta/dependencies/gurobi.lic
# To check if libgurobi.so exists
if [ -f /usr/lib/libgurobi.so ]; then
    echo "libgurobi.so exists, removing it" | tee -a $log_file
    sudo rm /usr/lib/libgurobi.so | tee -a $log_file
fi
sudo ln -s $GUROBI_HOME/lib/libgurobi95.so /usr/lib/libgurobi.so | tee -a $log_file

CLANG_VER="clang-14.0.6"
LLVM_VER="llvm-14.0.6"
CLANG_VER_HASH='2b5847b6a63118b9efe5c85548363c81ffe096b66c3b3675e953e26342ae4031'
LLVM_VER_HASH='050922ecaaca5781fdf6631ea92bc715183f202f9d2f15147226f023414f619a'

pushd dependencies || exit
echo "Downloading $LLVM_VER"
wget https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.6/$LLVM_VER.src.tar.xz | tee -a $log_file
llvm_hash=$(sha256sum $LLVM_VER.src.tar.xz | awk '{print $1}')
if [ $llvm_hash != $(LLVM_VER_HASH) ]; then
    echo "Hash value of $LLVM_VER.src.tar.xz is not correct" | tee -a $log_file
    echo "Expected: $(LLVM_VER_HASH)" | tee -a $log_file
    echo "Actual: $llvm_hash" | tee -a $log_file
    exit 1
fi
tar -xf $LLVM_VER.src.tar.xz | tee -a $log_file
rm $LLVM_VER.src.tar.xz | tee -a $log_file
pushd $LLVM_VER.src || exit
patch -p1 < ../../dependencies/patches/$LLVM_VER.llvmta.diff | tee -a $log_file
popd
popd

pushd dependencies || exit
wget https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.6/$CLANG_VER.src.tar.xz | tee -a $log_file
clang_hash=$(sha256sum $CLANG_VER.src.tar.xz | awk '{print $1}')
if [ $clang_hash != $(CLANG_VER_HASH) ]; then
    echo "Hash value of $CLANG_VER.src.tar.xz is not correct" | tee -a $log_file
    echo "Expected: $(CLANG_VER_HASH)" | tee -a $log_file
    echo "Actual: $clang_hash" | tee -a $log_file
    exit 1
fi
tar -xf $CLANG_VER.src.tar.xz | tee -a $log_file
rm $CLANG_VER.src.tar.xz | tee -a $log_file
popd

if [ ! -d build ]; then
    mkdir -p build | tee -a $log_file
fi

pushd build || exit

cmake \
    -DCMAKE_C_COMPILER=gcc \
    -DCMAKE_CXX_COMPILER=g++ \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
    -Wno-dev \
    -Wno-suggest-override \
    -DLLVM_USE_LINKER=lld \
    -DLLVM_ENABLE_RTTI=ON \
    -DLLVM_ENABLE_EH=ON \
    -DLLVM_ENABLE_ASSERTIONS=ON \
    -DLLVM_INCLUDE_BENCHMARKS=OFF \
    -DLLVM_TARGETS_TO_BUILD="ARM;RISCV;X86" \
    -DLLVM_EXTERNAL_CLANG_SOURCE_DIR=../dependencies/$CLANG_VER.src \
    -DLLVM_EXTERNAL_LLVMTA_SOURCE_DIR=.. \
    -DLLVM_EXTERNAL_PROJECTS="llvmta" \
    -GNinja \
    ../dependencies/$LLVM_VER.src | tee -a $log_file
mv compile_commands.json ../compile_commands.json
popd

echo "Please run 'source setup_env.sh' to set up the environment variables"
echo "Then enter 'build' directory and run 'ninja' to build the project"