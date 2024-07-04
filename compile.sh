#!/bin/bash

log_file=`pwd`/compile.log

echo "" > $log_file

echo "Time: $(date +%Y%m%d)" >> $log_file

sudo apt-get remove -y clang >> $log_file 2>&1 

echo "Installing dependencies"
sudo apt-get update >> $log_file 2>&1 

sudo apt-get -y install --no-install-recommends --fix-missing \
    lldb gcc gdb cmake make ninja-build libboost-all-dev git clangd \
    htop wget fish zsh lld time parallel lp-solve liblpsolve55-dev \
    icecc icecream-sundae libcolamd2 clang-tidy gcc-multilib \
    build-essential ccache python3-pip >> $log_file 2>&1 

pip3 install numpy >> $log_file 2>&1 

echo "Setting up LPSolve"
sudo ln -s /usr/lib/lp_solve/liblpsolve55.so /usr/lib/liblpsolve55.so >> $log_file 2>&1 

echo "Installing Gurobi"
if [ ! -d thirdParty ]; then
    mkdir -p thirdParty
fi
pushd thirdParty
    wget -nv \
    https://packages.gurobi.com/9.5/gurobi9.5.2_linux64.tar.gz >> $log_file 2>&1 ; \
    tar xfz *.tar.gz >> $log_file 2>&1  ; 
popd

echo "Setting environment variables"
export GUROBI_HOME=`pwd`/thirdParty/gurobi952/linux64
export PATH=`pwd`/llvmta/build/bin:`pwd`/llvm/build/bin:${GUROBI_HOME}/bin:$PATH
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${GUROBI_HOME}/lib"
export CPLUS_INCLUDE_PATH="$CPLUS_INCLUDE_PATH:${GUROBI_HOME}/include"
export GRB_LICENSE_FILE=/workspaces/llvmta/dependencies/gurobi.lic
# To check if libgurobi.so exists
if [ -f /usr/lib/libgurobi.so ]; then
    echo "libgurobi.so exists, removing it" >> $log_file
    sudo rm /usr/lib/libgurobi.so >> $log_file 2>&1 
fi
sudo ln -s $GUROBI_HOME/lib/libgurobi95.so /usr/lib/libgurobi.so >> $log_file 2>&1 

CLANG_VER="clang-14.0.6"
LLVM_VER="llvm-14.0.6"

pushd dependencies || exit
echo "Downloading $LLVM_VER"
wget https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.6/$LLVM_VER.src.tar.xz >> $log_file 2>&1 
tar -xf $LLVM_VER.src.tar.xz >> $log_file 2>&1
rm $LLVM_VER.src.tar.xz >> $log_file 2>&1
pushd $LLVM_VER.src || exit
patch -p1 < ../../dependencies/patches/$LLVM_VER.llvmta.diff >> $log_file 2>&1 
popd
popd

pushd dependencies || exit
wget https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.6/$CLANG_VER.src.tar.xz >> $log_file 2>&1 
tar -xf $CLANG_VER.src.tar.xz >> $log_file 2>&1
rm $CLANG_VER.src.tar.xz >> $log_file 2>&1
popd

if [ ! -d build ]; then
    mkdir -p build >> $log_file 2>&1
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
    ../dependencies/$LLVM_VER.src
mv compile_commands.json ../compile_commands.json
popd