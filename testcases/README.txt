- regressionTest: Check whether a change in llvmta has changed the analysis results on any testcase (regression)

- checkForAsserts: Check whether llvmta crashed on any of the testcases

- cleanBuildDirs: Remove all (temporary) result files that a llvmta-run can produce.

- eval: Runs the evaluation for all testcases for the given parameters setting

- determineNeededCtx:
A util script that helps to determine the minimal context sensitivity needed to precisely keep track of the stack pointer in the value analysis of LLVMTA.

- Benchmarks: Contains all our benchmarks, ordered into folders.

- runTestcase
Script for running a single testcase inside LLVMTA.

