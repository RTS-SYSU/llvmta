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
