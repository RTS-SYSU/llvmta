# LLVM-TA+

<p align="center">
    <img src="./assets/LLVM-TA+.png" alt="LLVM-TA+" width=30%></>
</p>

<p align="center">
    <a href="https://github.com/RTS-SYSU" rel="nofollow">
        <img src="https://img.shields.io/badge/RTS-SYSU-brightgreen.svg">
    </a>
    <a href="https://github.com/RTS-SYSU/llvmta" rel="nofollow">
        <img src="https://img.shields.io/badge/LLVM-TA+-blue.svg">
    </a>
    <a href="https://github.com/RTS-SYSU/llvmta" rel="nofollow">
        <img src="https://img.shields.io/badge/Multi_Core-WCET_Analysis-yellowgreen.svg">
    </a>
</p>

<p align="center">
    <a href="README.md">English</a> | <a href="README_zh.md">中文</a>
</p>

[LLVM-TA+](https://github.com/RTS-SYSU/llvmta) is a static analysis tool for WCET(Worst Case Execution Time) of multi-core real-time systems based on LLVM.

## Introduction

For the static analysis method of WCET in real-time systems, there are many research results, such as commercial tools [aiT](https://www.absint.com/ait/index.htm), and open-source tools in academia, such as [OTAWA](https://www.tracesgroup.net/otawa/), [Chronos](https://www.comp.nus.edu.sg/~rpembed/chronos/), [Heptane](https://team.inria.fr/pacap/software/heptane/), [LLVMTA](https://gitlab.cs.uni-saarland.de/reineke/llvmta), etc., but most of these analysis tools only support single-core systems. Compared with single-core systems, multi-core systems are generally configured with shared resources to meet high-performance requirements, which leads to complex resource contention situations, making it difficult for single-core analysis tools to be directly applied to multi-core systems. Based on this, this project extends the open-source WCET analysis tool [LLVMTA](https://gitlab.cs.uni-saarland.de/reineke/llvmta) for single-core systems to support multi-core systems and analyze shared cache, and further tighten the upper bound of WCET, named as LLVM-TA+.

## Design Goal

Our goal is to provide a static analysis tool for WCET of multi-core real-time systems based on LLVM, which can effectively analyze the WCET of multi-core systems and tighten the WCET upper bound.

To achieve this, we combine the existing LLVM-TA with the multi-core analysis method, and further improve the analysis accuracy and efficiency. The whole process can be divided into the following steps:

1. Value Analysis: Analyze the data of registers and memory at each position of the program, and use it as the input of the subsequent processor behavior analysis.
2. Control Flow Analysis: Analyze the control flow of the program to obtain the constraint conditions of the possible execution paths of the program, such as the number of iterations of the loop, etc. LLVM-TA+ uses source code-based control flow analysis, that is, analyzing the control flow of the program through the SSA representation of LLVM(LLVM-IR).
3. Processor Behavior Analysis: Through control flow analysis, we can get multiple possible execution paths of the program, and processor behavior analysis is to analyze the execution situation of these paths on the processor, such as the cache hit situation, etc., and calculate the execution time limit of the basic block in the path.
4. Bound Calculation: Based on the results of control flow analysis and processor behavior analysis, we can get the bound of the program on a specific execution path, and then calculate the WCET of the program.
5. Life Time Analysis: For multi-core systems, it is necessary to analyze the life cycle of tasks to determine the resource contention that may be involved in the execution of program fragments on the processor.
6. Iterative Analysis: Since the life cycle of tasks cannot be determined initially, this is a challenge for WCET analysis of multi-core systems, so iterative analysis is needed to gradually determine the life cycle of tasks and determine the resource contention between program fragments.
7. Shared Cache Analysis: The shared cache in multi-core systems is an important resource, and for WCET analysis, it is necessary to analyze the access situation of tasks on the shared cache, combined with the previously obtained resource contention, to determine the access situation of tasks on the shared cache.
8. Persistent Analysis of Shared Cache: The shared cache is a shared resource, and the access situation of tasks on the shared cache is related to the execution of other tasks, so it is necessary to analyze the persistent access situation of tasks on the shared cache to determine the WCET of the program.

## Evaluation

### WCET Static Analysis for Multi-core

To evaluate the LLVM-TA+ on multi-core analysis, we conducted experiments on Raspberry Pi 4B, which has a quad-core ARM Cortex-A72 processor with shared L2 cache. Details of the system configuration are shown in the following table:

<table align="center">
<thead>
<tr>
<th align="center">Configuration</th>
<th align="center">Value</th>
</tr>
</thead>
<tbody>
<tr>
<td align="center">L1 I-Cache Line Size</td>
<td align="center">64B</td>
</tr>
<tr>
<td align="center">L1 D-Cache Line Size</td>
<td align="center">64B</td>
</tr>
<tr>
<td align="center">L1 I-Cache Associativity</td>
<td align="center">3</td>
</tr>
<tr>
<td align="center">L1 D-Cache Associativity</td>
<td align="center">2</td>
</tr>
<tr>
<td align="center">L1 I-Cache Size</td>
<td align="center">48KB</td>
</tr>
<tr>
<td align="center">L1 D-Cache Size</td>
<td align="center">32KB</td>
</tr>
<tr>
<td align="center">L2 Cache Line Size</td>
<td align="center">64B</td>
</tr>
<tr>
<td align="center">L2 Cache Associativity</td>
<td align="center">16</td>
</tr>
<tr>
<td align="center">L2 Cache Size</td>
<td align="center">1MB</td>
</tr>
<tr>
<td align="center">Cache Replacement Policy</td>
<td align="center">LRU</td>
</tr>
<tr>
<td align="center">L1 Cache Latency</td>
<td align="center">4 Cycles</td>
</tr>
<tr>
<td align="center">L2 Cache Latency</td>
<td align="center">10 Cycles</td>
</tr>
<tr>
<td align="center">Memory Latency</td>
<td align="center">130 Cycles</td>
</tr>
</tbody>
</table>

We use [TACLeBench](https://github.com/tacle/tacle-bench) as our test benchmark, which contains multiple test cases for WCET analysis. And in our experiment, we ran a fixed `ndes` task on core 1 as an inference item, which has a large amount of L2 cache access, so that we can evaluate the impact of shared cache on WCET analysis. All the test cases are run on core 2, and the results are shown in the following table:

<table align="center">
<thead>
<tr>
<th align="center">Task</th>
<th align="center">WCET analyzed by LLVM-TA+(Cycle)</th>
<th align="center">Value obtained from Raspi 4B(Cycle)</th>
<th align="center">Ratio of WCET/Actual</th>
</tr>
</thead>
<tbody>
<tr>
<td align="center">jfdctint</td>
<td align="center">10055</td>
<td align="center">7261</td>
<td align="center">1.385</td>
</tr>
<tr>
<td align="center">st</td>
<td align="center">421293</td>
<td align="center">249868</td>
<td align="center">1.686</td>
</tr>
<tr>
<td align="center">insertsort</td>
<td align="center">3356</td>
<td align="center">2166</td>
<td align="center">1.549</td>
</tr>
<tr>
<td align="center">ludcmp</td>
<td align="center">9194</td>
<td align="center">7127</td>
<td align="center">1.290</td>
</tr>
<tr>
<td align="center">cover</td>
<td align="center">19926</td>
<td align="center">11836</td>
<td align="center">1.684</td>
</tr>
<tr>
<td align="center">matmul</td>
<td align="center">176059</td>
<td align="center">134862</td>
<td align="center">1.305</td>
</tr>
<tr>
<td align="center">ndes</td>
<td align="center">142202</td>
<td align="center">102740</td>
<td align="center">1.384</td>
</tr>
<tr>
<td align="center">fdct</td>
<td align="center">11390</td>
<td align="center">6590</td>
<td align="center">1.728</td>
</tr>
</tbody>
</table>

We can see that the WCET analyzed by LLVM-TA+ is close to the actual value obtained from the Raspberry Pi 4B, the ratio of WCET to the actual value is between 1.29 and 1.73, which indicates that LLVM-TA+ can effectively analyze the WCET of multi-core systems.

### WCET Tightening compared with LLVMTA

To further verify that [LLVM-TA+](https://github.com/RTS-SYSU/llvmta) can tighten the WCET upper bound, we compared the analysis results of LLVM-TA+ and [LLVMTA](https://gitlab.cs.uni-saarland.de/reineke/llvmta) on the above tasks, and the experimental results are as follows:

<table align="center">
<thead>
<tr>
<th align="center">Tasks</th>
<th align="center">LLVM-TA+</th>
<th align="center">LLVMTA</th>
<th align="center">Ratio LLVM-TA+/LLVMTA</th>
</tr>
</thead>
<tbody>
<tr>
<td align="center">jfdctint</td>
<td align="center">10055</td>
<td align="center">105783</td>
<td align="center">0.095</td>
</tr>
<tr>
<td align="center">st</td>
<td align="center">421293</td>
<td align="center">2979227</td>
<td align="center">0.141</td>
</tr>
<tr>
<td align="center">insertsort</td>
<td align="center">3356</td>
<td align="center">209482</td>
<td align="center">0.016</td>
</tr>
<tr>
<td align="center">ludcmp</td>
<td align="center">9194</td>
<td align="center">722084</td>
<td align="center">0.013</td>
</tr>
<tr>
<td align="center">cover</td>
<td align="center">19926</td>
<td align="center">61630</td>
<td align="center">0.323</td>
</tr>
<tr>
<td align="center">matmul</td>
<td align="center">176059</td>
<td align="center">1394651</td>
<td align="center">0.126</td>
</tr>
<tr>
<td align="center">ndes</td>
<td align="center">142202</td>
<td align="center">2378500</td>
<td align="center">0.060</td>
</tr>
<tr>
<td align="center">fdct</td>
<td align="center">11390</td>
<td align="center">75868</td>
<td align="center">0.150</td>
</tr>
</tbody>
</table>

It is clearly that the analysis value of LLVM-TA+ is much smaller than that of LLVMTA, which indicates that LLVM-TA+ can tighten the WCET upper bound.

## Scripts

For easy evaluation of this project, we provide some scripts to help evaluate the project. The scripts are located in the `scripts` directory, and the usage of each script can be found in the [README](scripts/README.md) file.

## Installation

For installation of the project, please refer to the [installation document](docs/INSTALL.md).

## Usage

For the usage of the project, please refer to the [usage document](docs/USAGE.md).

# Acknowledgement

1. [LLVMTA](https://gitlab.cs.uni-saarland.de/reineke/llvmta)
2. [TACLeBench](https://github.com/tacle/tacle-bench)