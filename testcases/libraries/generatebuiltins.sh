#!/bin/bash

buildarmv4(){
  cd arm || exit
  rm -rf *
  cd ..
  cd builtinsfloat
  mkdir buildarmv4
  cd buildarmv4
  rm -rf *
  clang -march=armv4t --target=arm-unknown-unknown -mfloat-abi=soft -emit-llvm \
    -S -w -gline-tables-only -O0 -Xclang -disable-O0-optnone -fno-builtin \
    -fno-discard-value-names ../*.c
  llvm-link -S *.ll -o builtinfloat.ll
  mv builtinfloat.ll ../../arm/builtinfloat.ll
  cd ..
  rm -rf buildarmv4

  cd ../builtinsint || exit
  mkdir buildarmv4
  cd buildarmv4
  rm -rf *
  clang -march=armv4t --target=arm-unknown-unknown -mfloat-abi=soft -emit-llvm \
    -S -w -gline-tables-only -O0 -Xclang -disable-O0-optnone -fno-builtin \
    -fno-discard-value-names ../*.c
  llvm-link -S *.ll -o builtininteger.ll
  mv builtininteger.ll ../../arm/builtininteger.ll
  cd ..
  rm -rf buildarmv4

  cd ../builtinsstd || exit
  mkdir buildarmv4
  cd buildarmv4
  rm -rf *
  clang -march=armv4t --target=arm-unknown-unknown -mfloat-abi=soft -emit-llvm \
    -S -w -gline-tables-only -O0 -Xclang -disable-O0-optnone -fno-builtin \
    -fno-discard-value-names ../*.c
  llvm-link -S *.ll -o builtinstd.ll
  mv builtinstd.ll ../../arm/builtinstd.ll
  cd ..
  rm -rf buildarmv4

  cd ..
}

buildarmv7(){
  cd armv7 || exit
  rm -rf *
  cd ..
  cd builtinsfloat
  mkdir buildarmv7
  cd buildarmv7
  rm -rf *
  clang -march=armv7 --target=arm-unknown-unknown -mfloat-abi=soft -emit-llvm \
    -S -w -gline-tables-only -O0 -Xclang -disable-O0-optnone -fno-builtin \
    -fno-discard-value-names ../*.c
  llvm-link -S *.ll -o builtinfloat.ll
  mv builtinfloat.ll ../../armv7/builtinfloat.ll
  cd ..
  rm -rf buildarmv7

  cd ../builtinsint || exit
  mkdir buildarmv7
  cd buildarmv7
  rm -rf *
  clang -march=armv7 --target=arm-unknown-unknown -mfloat-abi=soft -emit-llvm \
    -S -w -gline-tables-only -O0 -Xclang -disable-O0-optnone -fno-builtin \
    -fno-discard-value-names ../*.c
  llvm-link -S *.ll -o builtininteger.ll
  mv builtininteger.ll ../../armv7/builtininteger.ll
  cd ..
  rm -rf buildarmv7

  cd ../builtinsstd || exit
  mkdir buildarmv7
  cd buildarmv7
  rm -rf *
  clang -march=armv7 --target=arm-unknown-unknown -mfloat-abi=soft -emit-llvm \
    -S -w -gline-tables-only -O0 -Xclang -disable-O0-optnone -fno-builtin \
    -fno-discard-value-names ../*.c
  llvm-link -S *.ll -o builtinstd.ll
  mv builtinstd.ll ../../armv7/builtinstd.ll
  cd ..
  rm -rf buildarmv7

  cd ..
}

buildriscv(){
  cd riscv || exit
  rm -rf *
  cd ..
  cd builtinsfloat
  mkdir buildriscv
  cd buildriscv
  rm -rf *
  clang --target=riscv32-unknown-unknown -mfloat-abi=soft -emit-llvm \
    -S -w -gline-tables-only -O0 -Xclang -disable-O0-optnone -fno-builtin \
    -fno-discard-value-names ../*.c
  llvm-link -S *.ll -o builtinfloat.ll
  mv builtinfloat.ll ../../riscv/builtinfloat.ll
  cd ..
  rm -rf buildriscv

  cd ../builtinsint || exit
  mkdir buildriscv
  cd buildriscv
  rm -rf *
  clang --target=riscv32-unknown-unknown -mfloat-abi=soft -emit-llvm \
    -S -w -gline-tables-only -O0 -Xclang -disable-O0-optnone -fno-builtin \
    -fno-discard-value-names ../*.c
  llvm-link -S *.ll -o builtininteger.ll
  mv builtininteger.ll ../../riscv/builtininteger.ll
  cd ..
  rm -rf buildriscv

  cd ../builtinsstd || exit
  mkdir buildriscv
  cd buildriscv
  rm -rf *
  clang --target=riscv32-unknown-unknown -mfloat-abi=soft -emit-llvm \
    -S -w -gline-tables-only -O0 -Xclang -disable-O0-optnone -fno-builtin \
    -fno-discard-value-names ../*.c
  llvm-link -S *.ll -o builtinstd.ll
  mv builtinstd.ll ../../riscv/builtinstd.ll
  cd ..
  rm -rf buildriscv

  cd ..
}

case $1 in
armv4)
  buildarmv4
  ;;
riscv)
  buildriscv
  ;;
armv7)
  buildarmv7
  ;;
*)
  if [ $1 ]; then
    echo "Unknown argument: $1"
  fi
  echo "Script to rebuild builtins:"
  echo "  armv4"
  echo "  armv7"
  echo "  riscv"
  exit
  ;;
esac