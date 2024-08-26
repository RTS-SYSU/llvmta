# LLVM-TA+

[![](https://img.shields.io/badge/RTS-SYSU-brightgreen.svg)](https://github.com/RTS-SYSU)
[![](https://img.shields.io/badge/LLVM-TA+-blue.svg)](https://github.com/RTS-SYSU/llvmta)
[![](https://img.shields.io/badge/Multi_Core-WCET_Analysis-yellowgreen.svg)](https://github.com/RTS-SYSU/llvmta)

本项目 [LLVM-TA+](https://github.com/RTS-SYSU/llvmta) 是一个基于 LLVM 的多核实时系统 WCET(Worst Case Execution Time, 最坏情况执行时间) 静态分析工具。

## 项目简介

### 项目背景

目前，对于实时系统的 WCET 静态分析方法，已有较多的研究成果，例如商业化工具 [aiT](https://www.absint.com/ait/index.htm)，以及学术界的开源工具，如 [OTAWA](https://www.tracesgroup.net/otawa/)，[Chronos](https://www.comp.nus.edu.sg/~rpembed/chronos/)，[Heptane](https://team.inria.fr/pacap/software/heptane/)，[LLVMTA](https://gitlab.cs.uni-saarland.de/reineke/llvmta) 等，但是这些分析工具大部分仅支持单核系统。相较于单核系统，多核系统普遍配置有共享资源以满足高性能需求，这导致了复杂的资源竞争情况，这使得单核的分析工具难以直接应用到多核系统中。基于此，本项目将开源的针对单核系统的 WCET 分析同居 [LLVMTA](https://gitlab.cs.uni-saarland.de/reineke/llvmta) 进行拓展，使其支持多核系统并支持分析共享缓存，并进一步收紧 WCET 的上届，将其命名为 LLVM-TA+。

### 设计目标

LLVM-TA+ 的设计目标是支持多核实时系统的 WCET 静态分析，具体包括：

1. 值分析(Value Analysis)：通过分析计算得到程序各个位置的寄存器以及内存的数据，并作为后续处理器行为缓存分析的输入。
2. 控制流分析(Control Flow Analysis)：通过分析程序的控制流，得到程序可能的执行路径的约束条件，例如循环的迭代次数等。LLVM-TA+ 使用的是基于源代码的控制流分析，即通过 LLVM 的 SSA 表示来分析程序的控制流。
3. 处理器行为分析(Processor Behavior Analysis)：通过控制流分析，可以得到程序的多个可能执行路径，而处理器行为分析则是分析这些路径在处理器上的执行情况，例如缓存的命中情况等，并根据这些计算出路径中基本块(Basic Block)的执行时间界限。
4. 边界计算(Bound Calculation)：基于控制流分析以及处理器行为分析的结果，能够得到程序的 WCET。
5. 生命周期分析(Life Cycle Analysis)：对于多核系统，需要分析任务的生命周期，以确定程序片段在处理器上执行的过程中可能涉及到的资源竞争情况。
6. 迭代分析(Iterative Analysis)：由于初始情况下无法判断任务的生命周期，这对于多核系统的 WCET 分析是一个挑战，因此需要进行迭代分析，以逐步确定任务的生命周期，并确定程序片段之间的资源竞争情况。
7. 共享缓存分析(Shared Cache Analysis)：多核系统中的共享缓存是一个重要的资源，对于 WCET 分析来说，需要分析任务在共享缓存上的访问情况，结合先前得到的资源竞争情况，以确定任务在共享缓存上的访问情况。
8. 共享缓存的持久性分析(Persistent Analysis)

## 实现结果

### 多核 WCET 静态分析

为了验证项目实现效果，我们使用了 [TACLeBench](https://github.com/tacle/tacle-bench) 作为我们的测试基准，其中包含了多个多核实时系统的测试用例，我们使用 LLVM-TA+ 对这些测试用例进行了分析，并在树莓派 4B 上进行了验证，实验结果表明 LLVM-TA+ 能够成功的对多核实时系统进行 WCET 静态分析，有关的参数设置如下：

<p align="center">

| 参数 | 参数值 |
| :-: | :-: |
| L1 I-Cache 块大小 | 64B |
| L1 D-Cache 块大小 | 64B |
| L1 I-Cache 关联度 | 3 |
| L1 D-Cache 关联度 | 2 |
| L1 I-Cache 大小 | 48KB |
| L1 D-Cache 大小 | 32KB |
| L2 Cache 块大小 | 64B |
| L2 Cache 关联度 | 16 |
| L2 Cache 大小 | 1MB |
| Cache 替换策略 | LRU |
| L1 Cache 命中延迟 | 4 Cycles |
| L2 Cache 命中延迟 | 10 Cycles |
| L2 Cache 未命中延迟 | 130 Cycles |

</p>

为了评估 LLVM-TA+ 在多核上的分析，我们在树莓派 4B 上进行了试验，实验中在核心 1 上运行了一个固定的 ndes 任务作为干扰项，而在核心 2 上运行了我们的测试用例，实验结果如下：

<p align="center">

| 任务 | LLVM-TA+ 分析值(Cycle) | 树莓派测量值(Cycle) | 分析/测量 |
| :-: | :-: | :-: | :-: |
| jfdctint | 10055 | 7261 | 1.385 |
| st |421293 | 249868 | 1.686 |
| insertsort | 3356 | 2166 | 1.549 |
| ludcmp | 9194 | 7127 | 1.290 |
| cover | 19926 | 11836 | 1.684 |
| matmul | 176059 | 134862 | 1.305 |
| ndes | 142202 | 102740 | 1.384 |
| fdct | 11390 | 6590 | 1.728 |

</p>

可以看到，LLVM-TA+ 的分析值与树莓派测量值的比值在 1.3 到 1.7 之间，这表明 LLVM-TA+ 能够较为准确的对多核实时系统进行 WCET 静态分析。

### 对 WCET 上界的收紧

为了验证 LLVM-TA+ 能够对 WCET 上界进行收紧，我们在上面任务中，同时对比了 LLVM-TA+ 和 [LLVMTA](https://gitlab.cs.uni-saarland.de/reineke/llvmta) 的分析结果，实验结果如下：

<p align="center">

| 任务 | LLVM-TA+ | LLVMTA | LLVM-TA+/LLVMTA |
| :-: | :-: | :-: | :-: |
| jfdctint | 10055 | 105783 | 0.095 |
| st | 421293 | 2979227 | 0.141 |
| insertsort | 3356 | 209482 | 0.016 |
| ludcmp | 9194 | 722084 | 0.013 |
| cover | 19926 | 61630 | 0.323 |
| matmul | 176059 | 1394651 | 0.126 |
| ndes | 142202 | 2378500 | 0.060 |
| fdct | 11390 | 75868 | 0.150 |

</p>

可以发现，LLVM-TA+ 的分析值与 LLVMTA 的分析值相比，LLVM-TA+ 的分析值要小得多，这表明 LLVM-TA+ 能够对 WCET 上界进行收紧。

## 项目构建安装

有关项目的构建请参考[安装文档](docs/INSTALL_zh.md)。

## 项目使用

有关项目的使用请参考[使用文档](docs/USAGE_zh.md)。

## 项目开发

请开发人员参考[开发文档](docs/DEVELOP_zh.md)。