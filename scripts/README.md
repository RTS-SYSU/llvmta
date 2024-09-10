# Evaluation Scripts

<p align="center">
    <a href="README.md">English</a> | <a href="README_zh.md">中文</a>
</p>


## Description

This directory contains some usefule scripts for evaluating the performance of the [LLVM-TA+](https://github.com/RTS-SYSU/LLVM-TA).

## Usage

### Directory Structure

Please place all test cases in one directory(for example `src`), considering the followingg structure

```text
src
├── adpcm_dec
│   ├── ChangeLog.txt
│   └── adpcm_dec.c
├── adpcm_enc
│   ├── ChangeLog.txt
│   └── adpcm_enc.c
...
```

Where each folder is a test case, which contains several `c` files and some `h` files. All entry functions are `main` functions and have not been modified, so they can be compiled and run directly.

> Note: Please make sure that the `main` function is declared as `int main(void)` and the return value is `0` when the program runs successfully.

### Scripts

#### compile.py

This script is used to compile test cases and generate corresponding dynamic link libraries or executable files as needed. The possible parameters are as follows

```text
usage: llvmta benchmark suite compiler [-h] [-w] [-m MAIN] [-l] [-f FLAGS] [-lf LDFLAGS] [-c COMPILER] [-s SRC] [-o OUTPUT]

options:
  -h, --help            show this help message and exit
  -w, --wrap            Wrap the main function
  -m MAIN, --main MAIN  Where the real main function is located
  -l, --lib             Compile as a library
  -f FLAGS, --flags FLAGS
                        Compiler flags to pass to the compiler, default is "-O0 -fPIC" if -l is set, otherwise "-O0"
  -lf LDFLAGS, --ldflags LDFLAGS
                        Compiler flags to pass to the linker, default is "-shared" if -l is set, otherwise ""
  -c COMPILER, --compiler COMPILER
                        Compiler to use, default is "gcc"
  -s SRC, --src SRC     Directory to compile, default is "src"
  -o OUTPUT, --output OUTPUT
                        Output directory, default is "bin" if -l is not set, otherwise "lib"
```

For example, if you would like to use our multi-core testing framework [Execution_Counter](https://github.com/RTS-SYSU/Execution_Counter), you need to compile it into a dynamic link library and wrap the `main` function into `<name>_start` function. You can use the following command

```bash
./compile.py -l -s <dir_to_src> -o <dir_to_lib>
```

Where the `<dir_to_src>` is the directory containing all the test cases, which has been described above, and the `<dir_to_lib>` is the directory where the dynamic link libraries will be stored.

And in other cases, if you need to compile it into an executable file, but you want to use a performance counter to count some performance metrics, one easy way is to wrap the `main` function with a new function, our script can help you with that, please run the following command

```bash
./compile.py -w -m <real_main_file> -s <dir_to_src> -o <dir_to_bin>
```

To understand how it works and how to use it, please refer to this example:

```c
// FILE: main.c, you can find the exact file in the src/main.c 
#include <stdio.h>

int __wrap_main(void);

int main() {
  printf("Before wrap main\n");
  __wrap_main();
  printf("After wrap main\n");
  return 0;
}
```

In this example, the `__wrap_main` function is the real entry function, and the `main` function is just a wrapper. The `-m` parameter in the script is used to specify the implementation file of the `__wrap_main` function, which is `main.c` here.

So, one example of the command is

```bash
./compile.py -w -m main.c -s src -o bin
```

This will compile all the test cases in the `src` directory, and wrap the `main` function of each test cases into the `__wrap_main` function in the `main.c` file, and generate the executable files in the `bin` directory.

#### generate_json.py

This script is used to generate the `json` file for the test cases, which can later be used for [Execution_Counter](https://github.com/RTS-SYSU/Execution_Counter). It will traverse the `src` directory and use the task name as the entry function. Generally, place it in the same directory as the `src` directory, and then run it.

`generate_json.py` 用于生成测试用例的 `json` 文件，其会遍历 `src` 目录将其中的任务名作为启动函数，一般来说，将其放到与 `src` 同一级的目录下，然后运行即可

>Note: Please run `compile.py` to compile all the test cases before running `generate_json.py`, and then run `generate_json.py` to generate the `json` file

```bash
./generate_json.py
```

