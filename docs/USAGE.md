# 使用

> 请确保已经按照[安装文档](INSTALL.md)成功安装了本项目，然后再继续阅读本文档。

## 环境变量的设置

### 容器用户

对于使用容器构建的，请确保已经进入了容器环境，容器在构建时已经设置了环境变量，无需再次设置。

### 本地用户

而对于本地用户，有关的环境变量参考[安装文档](INSTALL.md)中的说明，需要注意的是，终端中的环境变量设置仅对当前终端有效，如果需要永久设置，可以将环境变量写入到 `~/.bashrc` 或者 `~/.zshrc` 中。

## 使用前准备

### 循环描述文件

由于本项目对循环的解算无法做到完全的精确，因而为了确保测量的准确，请提供循环描述文件，文件格式如下：

```text
ndes_init|Loop in file ndes.c near line 75|BB#5:for.cond2<header><exiting>_BB#6:for.body4_BB#7:for.inc7<latch>|49
```

具体来说，格式为

```text
<函数名>|<循环描述>|<循环的基本块描述>|<循环的迭代次数>
```

### 循环描述文件的生成
由于上述文件全部手动编写是非常繁琐的，因而本项目提供了一个自动生成的脚本，使用方法如下

```shell
cd testcases
./run.py -s <源代码所在目录> -o <输出文件目录> -p
其中 -s 为源代码所在目录，-o 为输出文件目录，-p 为是否打印循环描述文件。
```

这样生成的循环描述文件有两个，分别是 LoopAnnotations.csv 和 LLoopAnnotations.csv，前者表示循环上界，后者表示循环下界，请根据实际情况，将两个描述文件分别填写完成，具体来说，检查循环的边界是否设置正确，同时对于那些标注为 -1 的循环，将其修改为正确的循环边界。修改完成后，将这两个文件放置到和测试用例同一目录下。

## 系统信息获取

### 核心描述文件
由于本项目针对的是多核处理器，因而需要提供核心描述文件，文件格式如下：

```
[
    {
        "core": 0,
        "tasks": [
            {
                "function": "<函数名>"
            },
            {
                "function": "<函数名>"
            }
        ]
    },
    {
        "core": 1,
        "tasks": [
            {
                "function": "<函数名>"
            },
            {
                "function": "<函数名>"
            }
        ]
    },
    ...
]
```
其中，core 表示核心编号，tasks 表示该核心上的任务，function 表示任务所在的函数名。


### 缓存大小信息

对于类 Unix 系统，大部分情况下都可以通过 `lscpu -C` 命令来获取系统的 Cache 信息，例如

```bash
$ lscpu -C
NAME ONE-SIZE ALL-SIZE WAYS TYPE        LEVEL SETS PHY-LINE COHERENCY-SIZE
L1d       32K     128K    8 Data            1   64        1             64
L1i       64K     256K    8 Instruction     1  128        1             64
L2         2M       2M   16 Unified         2 2048        1             64
```

表示当前的 CPU 有三级缓存，其中 L1-Cache 分为 D-Cache(数据缓存) 和 I-Cache(指令缓存)，L2-Cache 和 L3-Cache 为统一缓存，即数据和指令共享。

其中的 `COHERENCY-SIZE` 表示缓存的一致性大小，即缓存行的大小，单位为字节，`WAYS` 表示组相联度，`SETS` 表示该级缓存的组数。

在运行的时候，请在 `run.py` 的运行参数中加入对应的参数，例如对于上述的 Cache 信息，可以用 

```bash
./run.py -s <源代码所在目录> -o <输出文件目录> --icache_line_size 64 --dcache_line_size 64 --l2cache_line_size 64 --icache_assoc 8 --dcache_assoc 8 --l2cache_assoc 16 --icache_sets 128 --dcache_sets 64 --l2cache_sets 2048
```

如果 `lscpu -C` 无法获取 Cache 信息，可以通过查看 `/sys/devices/system/cpu/cpu0/cache` 目录下的文件来获取，如下

```bash
$ ls -l /sys/devices/system/cpu/cpu0/cache
total 0
drwxr-xr-x 2 root root    0 Sep  9 15:14 index0
drwxr-xr-x 2 root root    0 Sep  9 15:14 index1
drwxr-xr-x 2 root root    0 Sep  9 15:14 index2
-rw-r--r-- 1 root root 4096 Sep  9 15:40 uevent
```

通常来说，对应的 `index0` 和 `index1` 目录下的文件为 L1-Cache 的信息，`index2` 为 L2-Cache 的信息，以此类推，具体查看文件内容如下

```bash
$ ls -l /sys/devices/system/cpu/cpu0/cache/index0
total 0
-r--r--r-- 1 root root 4096 Sep  9 15:14 coherency_line_size
-r--r--r-- 1 root root 4096 Sep  9 15:14 id
-r--r--r-- 1 root root 4096 Sep  9 15:14 level
-r--r--r-- 1 root root 4096 Sep  9 15:14 number_of_sets
-r--r--r-- 1 root root 4096 Sep  9 15:14 physical_line_partition
-r--r--r-- 1 root root 4096 Sep  9 15:41 shared_cpu_list
-r--r--r-- 1 root root 4096 Sep  9 15:14 shared_cpu_map
-r--r--r-- 1 root root 4096 Sep  9 15:14 size
-r--r--r-- 1 root root 4096 Sep  9 15:14 type
-rw-r--r-- 1 root root 4096 Sep  9 15:41 uevent
-r--r--r-- 1 root root 4096 Sep  9 15:14 ways_of_associativity
```

对应的 `size` 为缓存大小，`coherency_line_size` 为缓存行大小，`ways_of_associativity` 为组相联度，`number_of_sets` 为组数吗，`type` 为缓存类型。

## 使用

为方便使用，本项目提供了一个脚本，使用方法如下

```shell
cd testcases
./run.py -s <源代码所在目录> -o <输出文件目录> [-t <临时文件目录>]
```
其中，-t 参数为可选参数，用于指定临时文件目录，如果不指定，则默认为 dirforgdb。

脚本默认会在源代码目录下搜索所需要的文件，包括循环描述文件和核心描述文件，如果找不到，则会报错。

### GDB调试运行

可以使用vscode remote explorer打开项目，然后使用`Run and Debug`、选择prelaunch task为`run gdb`的进行运行。运行的机制是调用`runBeforeGDB`进行源码编译后传入`args`中的参数运行。可以更改`--ta-analysis-entry-point`以切换被分析程序的入口函数名。被分析程序需要放置在`./testcases/test/`中。

## 结果

运行完成后，会在终端输出结果各核心任务的执行时间上界，如:  

```txt
Timing Analysis for entry point: fdct_start
 -> Finished Preprocessing Phase
 -> Finished Value & Address Analysis
 -> Starting Microarchitectural Analysis:
N18TimingAnalysisPass30StateExplorationWithJoinDomainINS_20InOrderPipelineStateINS_31JJYSeparateCachesMemoryTopologyIXadL_ZNS_12CacheFactory21makeOptionsInstrCacheEbEEXadL_ZNS3_20makeOptionsDataCacheEbEEXadL_ZNS3_18makeOptionsL2CacheEbEENS_20SingleMemoryTopologyIXadL_ZNS_24makeOptionsBackgroundMemEvEEEEEEEEEE
 -> Finished Microarchitectural Analysis
 -> Finished Microarchitectural State Graph Construction
 -> No valid Gurobi License found!
 -> Using Solver: LPsolve
 -> Finished Path Analysis
Calculated Timing Bound: 98884
```