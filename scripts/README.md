# 评估脚本


## 概述

该目录主要包含了用于评估 [TAM](https://github.com/RTS-SYSU/Timing-Analysis-Multicores) 的性能的一些脚本。

## 使用

### 目录结构

Please place all test cases in one directory(for example `src`), considering the followingg structure

请将所有的测试用例放在一个目录下（例如 `src`），并考虑如下的目录结构

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

其中每个文件夹是一个测试用例，包含了若干个 `c` 文件和一些 `h` 文件。所有的入口函数都是 `main` 函数，并且没有被修改过，所以可以直接编译和运行。

> 注意：请确保 `main` 函数声明为 `int main(void)`，并且程序正常运行时返回值为 `0`。

### 脚本

#### compile.py

该脚本用于编译测试用例，并根据需要生成相应的动态链接库或可执行文件。可能的参数如下

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

例如，如果您想使用我们的多核测试框架 [Execution_Counter](https://github.com/RTS-SYSU/Execution_Counter)，您需要将其编译为动态链接库，并将 `main` 函数包装成 `<name>_start` 函数。您可以使用以下命令

```bash
./compile.py -l -s <dir_to_src> -o <dir_to_lib>
```

其中 `<dir_to_src>` 是包含所有测试用例的目录，形式可以参考如上所述的目录结构，而 `<dir_to_lib>` 是存储动态链接库的目录。

而如果您需要将其编译为可执行文件，但是您想使用性能计数器来统计一些性能指标，一种简单的方法是将 `main` 函数包装成一个新的函数，我们的脚本可以帮助您实现这一点，请运行以下命令

```bash
./compile.py -w -m <real_main_file> -s <dir_to_src> -o <dir_to_bin>
```

为进一步说明其工作原理和如何使用，请参考下面的示例：

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

在这个示例中，`__wrap_main` 函数是真正的入口函数，而 `main` 函数只是一个包装器。脚本中的 `-m` 参数用于指定 `__wrap_main` 函数的实现文件，这里是 `main.c`。

从而，对于上面的例子，我们可以运行如下命令

```bash
./compile.py -w -m main.c -s src -o bin
```

这将会编译 `src` 目录下的所有测试用例，并将每个测试用例的 `main` 函数包装成 `main.c` 文件中的 `__wrap_main` 函数，然后生成可执行文件到 `bin` 目录中。

#### generate_json.py

这个脚本用于生成测试用例的 `json` 文件，其会遍历 `src` 目录将其中的任务名作为启动函数，一般来说，将其放到与 `src` 同一级的目录下，然后运行即可。

> 注意：请在运行 `generate_json.py` 之前运行 `compile.py` 编译所有的测试用例，然后运行 `generate_json.py` 生成 `json` 文件

```bash
./generate_json.py
```

