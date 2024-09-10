# 使用

> 请确保已经按照[安装文档](INSTALL_zh.md)成功安装了本项目，然后再继续阅读本文档。

## 环境变量的设置

### 容器用户

对于使用容器构建的，请确保已经进入了容器环境，容器在构建时已经设置了环境变量，无需再次设置。

### 本地用户

而对于本地用户，有关的环境变量参考[安装文档](INSTALL_zh.md)中的说明，需要注意的是，终端中的环境变量设置仅对当前终端有效，如果需要永久设置，可以将环境变量写入到 `~/.bashrc` 或者 `~/.zshrc` 中。

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

由于上述文件全部手动编写是非常繁琐的，因而本项目提供了一个自动生成的[脚本](../testcases/run.py)，使用方法如下

```bash
cd testcases
./run.py -s <源代码所在目录> -o <输出文件目录> -p
```

其中 `-s` 为源代码所在目录，`-o` 为输出文件目录，`-p` 为是否打印循环描述文件。

这样生成的循环描述文件有两个，分别是 `LoopAnnotations.csv` 和 `LLoopAnnotations.csv`，前者表示循环上界，后者表示循环下界，请根据实际情况，将两个描述文件分别填写完成，具体来说，检查循环的边界是否设置正确，同时对于那些标注为 `-1` 的循环，将其修改为正确的循环边界。修改完成后，将这两个文件放置到和测试用例同一目录下。

### 核心描述文件

由于本项目针对的是多核处理器，因而需要提供核心描述文件，文件格式如下：

```json
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

其中，`core` 表示核心编号，`tasks` 表示该核心上的任务，`function` 表示任务所在的函数名。

## 系统信息获取

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

### 缓存内存延迟信息

缓存以及内存的延迟信息可以 [lmbench](https://lmbench.sourceforge.net/) 工具来进行测试，具体的测试和使用方法请参考官方文档，这里需要注意的是，该工具默认测试结果的单位为 ns，而本项目需要的单位为 CPU 周期数，因而需要将测试结果转换为 CPU 周期数，为了确保转换的精准，请在测试时将 CPU 固定在最低频率，Linux 上可以通过设置 CPU 的 governor 为 `powersave` 来实现，具体方法如下

```bash
$ sudo cpufreq-set -g powersave
```

设置完成后，可以通过如下文件来查看 CPU 的 governor

```bash
$ cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
powersave
```

测试完成后，终端会打印对应的内存延迟，请手动记录并转换为 CPU 周期数，然后在运行时加入对应的参数，例如，得到的内存延迟为 150 个 CPU 周期数，L1 缓存延迟为 4 个 CPU 周期数，L2 缓存延迟为 12 个 CPU 周期数，可以用如下命令来运行

```bash
./run.py -s <源代码所在目录> -o <输出文件目录> --icache_line_size 64 --dcache_line_size 64 --l2cache_line_size 64 --icache_assoc 8 --dcache_assoc 8 --l2cache_assoc 16 --icache_sets 128 --dcache_sets 64 --l2cache_sets 2048 --l1_latency 4 --l2_latency 12 --mem_latency 150
```

## 使用

为方便使用，本项目提供了一个[脚本](../testcases/run.py)，使用方法如下

```bash
cd testcases
./run.py -s <源代码所在目录> -o <输出文件目录> [-t <临时文件目录>]
```

其中，`-t` 参数为可选参数，用于指定临时文件目录，如果不指定，则默认为 `dirforgdb`。

脚本默认会在源代码目录下搜索所需要的文件，包括循环描述文件和核心描述文件，如果找不到，则会报错。

## 结果

脚本运行完成后，会在指定的输出目录下生成 `WCET.json` 文件，格式如下

```json
{
    "system": {
        "core_count": <核心数量>
    },
    "tasks": [
        {
            "WCET": <最大执行时间>,
            "function": "<函数名>",
            "id": 0,
            "partition": <核心编号>
        },
        ...
    ]
}
```

其中，`WCET` 表示最大执行时间，`function` 表示函数名，`id` 表示任务编号，`partition` 表示核心编号。