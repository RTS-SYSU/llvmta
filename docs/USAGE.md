# Usage

> Please make sure that you have successfully installed the project according to the [installation document](INSTALL.md) before continuing to read this document.

## Setting Environment Variables

### For Docker Users

For those who use the container to build, please make sure that you have entered the container environment, the container has set the environment variables during the build process, so there is no need to set them again.

### For non-Docker Users

As for those who do not use Docker, the relevant environment variables can be found in the [installation document](INSTALL.md), please note that the environment variables set in the terminal are only valid for the current terminal, if you need to set them permanently, you can write the environment variables to `~/.bashrc` or `~/.zshrc`.

If you are using the [compile script](../compile.sh) we provided, you can use `source setup_env.sh` to set the corresponding environment variables, please be noted that this command needs to be executed every time you reopen the terminal, and it have to be executed in the root directory of the project, so that the environment variables can be set correctly.

## Before Using

### Loop Annotation File

Due to the fact that the calculation of loops in this project cannot be completely accurate, in order to ensure the accuracy of the measurement, please provide a loop annotation file, the format is as follows:

```text
ndes_init|Loop in file ndes.c near line 75|BB#5:for.cond2<header><exiting>_BB#6:for.body4_BB#7:for.inc7<latch>|49
...
```

Specifically, the format is

```text
<Function Name>|<A Brief Description>|<Loop Description>|<Loop Bound>
```

### Generating Loop Annotation Files

It is very cumbersome to write all the above files manually, so this project provides an automatically generated [script](../testcases/run.py), the usage is as follows

```bash
cd testcases
./run.py -s <source_code_directory> -o <output_directory> -p
```

Please note that `-s` is the source code directory, `-o` is the output directory, and `-p` is whether to generate the loop description file.

By doing this, the script will generate two loop description files, `LoopAnnotations.csv` and `LLoopAnnotations.csv`, the former represents the upper bound of the loop, and the latter represents the lower bound of the loop. Please fill in these two description files separately according to the actual situation. Specifically, check whether the boundaries of the loops are set correctly, and modify those loops marked as `-1` to the correct loop boundaries. After modification, place these two files in the same directory as the test case.

### Core Description File

Since this project is aimed at multi-core processors, a core description file is required, the format is as follows:

```json
[
    {
        "core": 0,
        "tasks": [
            {
                "function": "<Function name>"
            },
            {
                "function": "<Function name>"
            }
        ]
    },
    {
        "core": 1,
        "tasks": [
            {
                "function": "<Function name>"
            },
            {
                "function": "<Function name>"
            }
        ]
    },
    ...
]
```

In the file, `core` represents the core number, `tasks` represents the tasks on that core, and `function` represents the function name of the task.

## System Information

### Cache Information

For Unix-like systems, you can usually get the system's cache information by using the `lscpu -C` command, for example

```bash
$ lscpu -C
NAME ONE-SIZE ALL-SIZE WAYS TYPE        LEVEL SETS PHY-LINE COHERENCY-SIZE
L1d       32K     128K    8 Data            1   64        1             64
L1i       64K     256K    8 Instruction     1  128        1             64
L2         2M       2M   16 Unified         2 2048        1             64
```

The above information indicates that the CPU has three levels of cache, where L1-Cache is divided into D-Cache (data cache) and I-Cache (instruction cache), and L2-Cache and L3-Cache are unified caches, that is, data and instructions are shared.

The `ONE-SIZE` and `ALL-SIZE` represent the size of the cache, the `COHERENCY-SIZE` represents the consistency size of the cache, that is, the size of the cache line in bytes, `WAYS` represents the associativity, `SETS` represents the number of groups of the cache.

When running, please add the corresponding parameters in the running parameters of `run.py`, for example, for the above Cache information, you can use

```bash
./run.py -s <source_code_directory> -o <output_directory> --icache_line_size 64 --dcache_line_size 64 --l2cache_line_size 64 --icache_assoc 8 --dcache_assoc 8 --l2cache_assoc 16 --icache_sets 128 --dcache_sets 64 --l2cache_sets 2048
```

In case `lscpu -C` cannot get the cache information, you can get it by viewing the files under `/sys/devices/system/cpu/cpu0/cache`, as follows

```bash
$ ls -l /sys/devices/system/cpu/cpu0/cache
total 0
drwxr-xr-x 2 root root    0 Sep  9 15:14 index0
drwxr-xr-x 2 root root    0 Sep  9 15:14 index1
drwxr-xr-x 2 root root    0 Sep  9 15:14 index2
-rw-r--r-- 1 root root 4096 Sep  9 15:40 uevent
```

Usually, the files under the `index0` and `index1` directories are the information of the L1-Cache, and the `index2` is the information of the L2-Cache, and so on, the specific content of the files is as follows

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

The `size` is the cache size, `coherency_line_size` is the cache line size, `ways_of_associativity` is the associativity, `number_of_sets` is the number of groups, and `type` is the cache type.

### Cache and Memory Latency Information

The latency information of the cache and memory can be tested using the [lmbench](https://lmbench.sourceforge.net/) tool, please refer to the official documentation for specific testing and usage methods, please note that the default unit of the test results of this tool is ns, while the unit required by this project is CPU cycle, so the test results need to be converted to CPU cycle, in order to ensure the accuracy of the conversion, please fix the CPU at the lowest frequency during the test, on Linux, you can set the CPU governor to `powersave` to achieve this, the specific method is as follows

```bash
$ sudo cpufreq-set -g powersave
```

After the setting is completed, you can check the CPU governor through the following file

```bash
$ cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
powersave
```

The result of the test will be printed in the terminal, please manually record and convert it to CPU cycle, then add the corresponding parameters when running, for example, if the memory latency is 150 CPU cycles, the L1 cache latency is 4 CPU cycles, and the L2 cache latency is 12 CPU cycles, you can run the following command

```bash
./run.py -s <source_code_directory> -o <output_directory> --icache_line_size 64 --dcache_line_size 64 --l2cache_line_size 64 --icache_assoc 8 --dcache_assoc 8 --l2cache_assoc 16 --icache_sets 128 --dcache_sets 64 --l2cache_sets 2048 --l1_latency 4 --l2_latency 12 --mem_latency 150
```


## Usage

We provide a [script](../testcases/run.py) for ease of use, the usage is as follows

```bash
cd testcases
./run.py -s <source_code_directory> -o <output_directory> [-t <temporary_directory>]
```

Where the `-t` parameter is optional, used to specify the temporary directory, if not specified, it defaults to `dirforgdb`.

The script will search for the required files in the source code directory by default, including the loop description file and the core description file, if not found, an error will be reported.

## Result

After the script is executed, a `WCET.json` file will be generated in the specified output directory, the format is as follows

```json
{
    "system": {
        "core_count": <Number of cores>
    },
    "tasks": [
        {
            "WCET": <Maximum execution time>,
            "function": "<Function name>",
            "id": 0,
            "partition": <Core number>
        },
        ...
    ]
}
```

Where `WCET` represents the maximum execution time, `function` represents the function name, `id` represents the task number, and `partition` represents the core number.
