# Timing-Analysis-Multicores

<p align="center">
    <a href="https://github.com/RTS-SYSU" rel="nofollow">
        <img src="https://img.shields.io/badge/RTS-SYSU-brightgreen.svg">
    </a>
    <a href="https://github.com/RTS-SYSU/llvmta" rel="nofollow">
        <img src="https://img.shields.io/badge/Multi_Core-WCET_Analysis-yellowgreen.svg">
    </a>
</p>

<p align="center">
    <a href="README.md">English</a> | <a href="README_zh.md">中文</a>
</p>

本项目 [TAM](https://github.com/RTS-SYSU/Timing-Analysis-Multicores) 是一个基于 LLVM 的实时系统 WCET(Worst Case Execution Time, 最坏情况执行时间) 静态分析工具。

## 项目简介

### 设计目标

TAM 的设计目标是支持多核实时系统的 WCET 静态分析，具体包括：

1. 值分析(Value Analysis)：通过分析计算得到程序各个位置的寄存器以及内存的数据，并作为后续处理器行为缓存分析的输入。
2. 控制流分析(Control Flow Analysis)：通过分析程序的控制流，得到程序可能的执行路径的约束条件，例如循环的迭代次数等。TAM 使用的是基于源代码的控制流分析，即通过 LLVM 的 SSA 表示来分析程序的控制流。
3. 处理器行为分析(Processor Behavior Analysis)：通过控制流分析，可以得到程序的多个可能执行路径，而处理器行为分析则是分析这些路径在处理器上的执行情况，例如缓存的命中情况等，并根据这些计算出路径中基本块(Basic Block)的执行时间界限。
4. 边界计算(Bound Calculation)：基于控制流分析以及处理器行为分析的结果，能够得到程序的 WCET。
5. 共享缓存分析(Shared Cache Analysis)：多核系统中的共享缓存是一个重要的资源，对于 WCET 分析来说，需要分析任务在共享缓存上的访问情况，结合先前得到的资源竞争情况，以确定任务在共享缓存上的访问情况。  
6. 共享缓存的持久性分析(Persistent Analysis)

## 脚本使用

为了方便评估本项目，我们提供了一些脚本来帮助评估本项目，这些脚本位于 `scripts` 目录下，每个脚本的使用方法可以在 [README](scripts/README.md) 文件中找到。

## 项目构建安装

有关项目的构建请参考[安装文档](docs/INSTALL.md)。

## 项目使用

有关项目的使用请参考[使用文档](docs/USAGE.md)。

# 致谢

1. [LLVMTA](https://gitlab.cs.uni-saarland.de/reineke/llvmta)
2. [TACLeBench](https://github.com/tacle/tacle-bench)