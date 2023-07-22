////////////////////////////////////////////////////////////////////////////////
//
//   LLVMTA - Timing Analyser performing worst-case execution time analysis
//     using the LLVM backend intermediate representation
//
// Copyright (C) 2013-2022  Saarland University
// Copyright (C) 2014-2015  Claus Faymonville
//
// This file is distributed under the Saarland University Software Release
// License. See LICENSE.TXT for details.
//
// THIS SOFTWARE IS PROVIDED "AS IS", WITHOUT ANY EXPRESSED OR IMPLIED
// WARRANTIES, INCLUDING BUT NOT LIMITED TO, THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE SAARLAND UNIVERSITY, THE
// CONTRIBUTORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DIRECT,
// INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING BUT NOT LIMITED TO PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
// HOWEVER CAUSED OR OTHER LIABILITY, WHETHER IN CONTRACT, STRICT
// LIABILITY, TORT OR OTHERWISE, ARISING IN ANY WAY FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS WITH THE
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH A DAMAGE.
//
////////////////////////////////////////////////////////////////////////////////

#include "Util/Options.h"

#include "PathAnalysis/GetEdges.h"

using namespace llvm;

// Global options
/* for now, this is also the category for all options not yet sorted into a
 * category */
cl::OptionCategory LLVMTACat("0. LLVMTA General Options");
cl::OptionCategory ContextSensitivityCat("1. Context Sensitivity Options");
cl::OptionCategory
    HardwareDescrCat("2. Hardware Platform Configuration Options");
cl::OptionCategory CacheConfigCat("3. Cache Configuration");
cl::OptionCategory WritebackCat("4. Writeback Analysis");
cl::OptionCategory ArrayCat("5. Array-aware Cache Analysis");
cl::OptionCategory
    CoRunnerSensitiveCat("6. Multi-Core Corunner-sensitive Analysis");

cl::opt<bool>
    QuietMode("ta-quiet", cl::init(false),
              cl::desc("Quiet mode: do not report on progress and do not dump "
                       "detailed analysis information to files; should be used "
                       "for performance measurements (default 'false')"),
              cl::cat(LLVMTACat));

cl::opt<bool>
    DumpVcgGraph("ta-dumpb-vcg-graph",
                 cl::desc("Dumps the StateGraph in .vcg format (default:.dot)"),
                 cl::init(false), cl::cat(LLVMTACat));

cl::opt<std::string> AnalysisEntryPoint(
    "ta-analysis-entry-point", cl::init("main"),
    cl::desc("The entry point for the analysis (default 'main')"),
    cl::cat(LLVMTACat));

cl::opt<MicroArchitecturalType> MuArchType(
    "ta-muarch-type",
    cl::desc(
        "Choose the microarchitecture to analyse (default 'fixedlatency')"),
    cl::init(MicroArchitecturalType::FIXEDLATENCY),
    cl::values(
        clEnumValN(MicroArchitecturalType::FIXEDLATENCY, "fixedlatency",
                   "Pipeline with fixed latency per instruction"),
        clEnumValN(
            MicroArchitecturalType::PRET, "pret",
            "Single thread of a four-way thread-interleaved PRET pipeline"),
        clEnumValN(MicroArchitecturalType::INORDER, "inorder",
                   "Simple in-order 5-stage pipeline"),
        clEnumValN(MicroArchitecturalType::STRICTINORDER, "strictlyinorder",
                   "Strictly in-order 5-stage pipeline"),
        clEnumValN(MicroArchitecturalType::OUTOFORDER, "outoforder",
                   "Out-of-order pipeline")),
    cl::Required, cl::cat(HardwareDescrCat));

cl::opt<MemoryTopologyType> MemTopType(
    "ta-memory-type",
    cl::desc("Choose the memory topology used in microarchitectural analysis "
             "(default 'single')"),
    cl::init(MemoryTopologyType::SINGLEMEM),
    cl::values(
        clEnumValN(MemoryTopologyType::NONE, "none",
                   "No external memory (only valid for fixed-latency pipeline"),
        clEnumValN(MemoryTopologyType::SINGLEMEM, "single",
                   "One unified single (potentially shared) background memory"),
        clEnumValN(MemoryTopologyType::SEPARATECACHES, "separatecaches",
                   "Separate instruction and data caches in front of unified "
                   "background memory"),
        clEnumValN(MemoryTopologyType::PRIVINSTRSPMDATASHARED,
                   "priv-instr-spm-data-shared",
                   "Private instruction SPM, potentially shared data memory.")),
    cl::Required, cl::cat(HardwareDescrCat));

cl::opt<SharedBusType> SharedBus(
    "ta-shared-bus", cl::desc("Select which type of shared bus is assumed."),
    cl::init(SharedBusType::NONE),
    cl::values(
        clEnumValN(
            SharedBusType::NONE, "none",
            "Dedicated bus: each access request is granted immediately."),
        clEnumValN(SharedBusType::ROUNDROBIN, "roundRobin",
                   "Shared bus with Round-Robin arbitration.")),
    cl::cat(HardwareDescrCat));

cl::opt<bool>
    CoRunnerSensitive("ta-co-runner-sensitive", cl::init(false),
                      cl::desc("Enables the co-runner-sensitive analysis. By "
                               "default, is is disabled (false)."),
                      cl::cat(CoRunnerSensitiveCat));

cl::bits<CompositionalAnalysisType> CompAnaType(
    "ta-comp-type",
    cl::desc("Choose which caches are supposed to be analysed compositional."),
    cl::CommaSeparated,
    cl::values(clEnumValN(CompositionalAnalysisType::ICACHE, "icache",
                          "Instruction cache separated"),
               clEnumValN(CompositionalAnalysisType::DCACHE, "dcache",
                          "Data cache separated"),
               clEnumValN(CompositionalAnalysisType::DRAMREFRESH, "dramrefresh",
                          "DRAM refreshes separated"),
               clEnumValN(CompositionalAnalysisType::SHAREDBUSBLOCKING,
                          "sharedbusblocking", "Blocking on the shared bus")),
    cl::cat(LLVMTACat));

cl::bits<LocalWorstCaseType> FollowLocalWorstType(
    "ta-follow-localwc",
    cl::desc("Choose which local worst cases should be followed exclusively."),
    cl::CommaSeparated,
    cl::values(clEnumValN(LocalWorstCaseType::ICMISS, "icmiss",
                          "Instruction cache miss"),
               clEnumValN(LocalWorstCaseType::DCMISS, "dcmiss",
                          "Data cache miss"),
               clEnumValN(LocalWorstCaseType::WRITEBACK, "writeback",
                          "Writeback upon eviction of dirty line"),
               clEnumValN(LocalWorstCaseType::DRAMREFRESH, "dramrefresh",
                          "DRAM refresh"),
               clEnumValN(LocalWorstCaseType::BUSBLOCKING, "busblocking",
                          "Blocking cycles on the shared bus")),
    cl::cat(LLVMTACat));

cl::bits<LocalWorstCaseType> StallOnLocalWorstType(
    "ta-stall-on",
    cl::desc("Choose on which local worst cases the pipeline should stall. "
             "(Default None)"),
    cl::CommaSeparated,
    cl::values(
        //			clEnumValN(LocalWorstCaseType::ICMISS, "icmiss",
        //"Instruction cache miss"),
        //clEnumValN(LocalWorstCaseType::DCMISS, "dcmiss", "Data cache miss"),
        //			clEnumValN(LocalWorstCaseType::WRITEBACK,
        //"writeback", "Writeback upon eviction of dirty line"),
        clEnumValN(LocalWorstCaseType::DRAMREFRESH, "dramrefresh",
                   "DRAM refresh"),
        clEnumValN(LocalWorstCaseType::BUSBLOCKING, "busblocking",
                   "Blocking cycles on the shared bus")),
    cl::cat(HardwareDescrCat));

cl::opt<bool> CompAnaJointILP(
    "ta-compana-joint-ilp", cl::init(false),
    cl::desc("Enables the joint ILP mode for compositional analyses where "
             "applicable. Default is off (false)"),
    cl::cat(LLVMTACat));

cl::opt<CacheReplPolicyType> InstrCacheReplPolType(
    "ta-icache-replpol",
    cl::desc("Choose which replacement policy should be used for the "
             "instruction cache. (Default: LRU)"),
    cl::init(CacheReplPolicyType::LRU),
    cl::values(clEnumValN(CacheReplPolicyType::LRU, "lru",
                          "Least-recently-used policy"),
               clEnumValN(CacheReplPolicyType::FIFO, "fifo",
                          "First-in First-out policy"),
               clEnumValN(CacheReplPolicyType::ALHIT, "alwayshit",
                          "Always Hit cache (i.e. preloaded scratchpad)"),
               clEnumValN(CacheReplPolicyType::ALMISS, "alwaysmiss",
                          "Always Miss cache (i.e. no cache)")),

    cl::cat(CacheConfigCat));

cl::opt<PersistenceType> InstrCachePersType(
    "ta-icache-persistence",
    cl::desc("Choose the type of persistence analysis for the instruction "
             "cache (default 'none')"),
    cl::init(PersistenceType::NONE),
    cl::values(
        clEnumValN(PersistenceType::NONE, "none", "No persistence analysis"),
        clEnumValN(PersistenceType::SETWISE, "setwise",
                   "Set-wise conflict counting persistence analysis"),
        clEnumValN(PersistenceType::ELEWISE, "elementwise",
                   "Element-wise conflict counting persistence analysis"),
        clEnumValN(PersistenceType::CONDMUST, "conditionalmust",
                   "Conditional must persistence analysis")),
    cl::cat(LLVMTACat));

cl::opt<unsigned> Ilinesize(
    "ta-icache-linesize", cl::init(16),
    cl::desc(
        "The linesize of the instruction cache in bytes. The default is 16"),
    cl::cat(CacheConfigCat));

cl::opt<unsigned> Iassoc(
    "ta-icache-assoc", cl::init(2),
    cl::desc("The associativity of the instruction cache. The default is 2"),
    cl::cat(CacheConfigCat));

cl::opt<unsigned> Insets(
    "ta-icache-nsets", cl::init(32),
    cl::desc(
        "The number of cache sets of the instruction cache. The default is 32"),
    cl::cat(CacheConfigCat));

cl::opt<CacheReplPolicyType> DataCacheReplPolType(
    "ta-dcache-replpol",
    cl::desc("Choose which replacement policy should be used for the data "
             "cache. (Default: LRU)"),
    cl::init(CacheReplPolicyType::LRU),
    cl::values(clEnumValN(CacheReplPolicyType::LRU, "lru",
                          "Least-recently-used policy"),
               clEnumValN(CacheReplPolicyType::FIFO, "fifo",
                          "First-in First-out policy"),
               clEnumValN(CacheReplPolicyType::ALHIT, "alwayshit",
                          "Always Hit cache (i.e. preloaded scratchpad)"),
               clEnumValN(CacheReplPolicyType::ALMISS, "alwaysmiss",
                          "Always Miss cache (i.e. no cache)")),
    cl::cat(CacheConfigCat));

cl::opt<PersistenceType> DataCachePersType(
    "ta-dcache-persistence",
    cl::desc("Choose the type of persistence analysis for the data cache "
             "(default 'none')"),
    cl::init(PersistenceType::NONE),
    cl::values(
        clEnumValN(PersistenceType::NONE, "none", "No persistence analysis"),
        clEnumValN(PersistenceType::SETWISE, "setwise",
                   "Set-wise conflict counting persistence analysis"),
        clEnumValN(PersistenceType::ELEWISE, "elementwise",
                   "Element-wise conflict counting persistence analysis"),
        clEnumValN(PersistenceType::CONDMUST, "conditionalmust",
                   "Conditional must persistence analysis")),
    cl::cat(LLVMTACat));

cl::opt<unsigned> Dlinesize(
    "ta-dcache-linesize", cl::init(16),
    cl::desc("The linesize of the data cache in bytes. The default is 16"),
    cl::cat(CacheConfigCat));

cl::opt<unsigned>
    Dassoc("ta-dcache-assoc", cl::init(2),
           cl::desc("The associativity of the data cache. The default is 2"),
           cl::cat(CacheConfigCat));

cl::opt<unsigned> Dnsets(
    "ta-dcache-nsets", cl::init(32),
    cl::desc("The number of cache sets of the data cache. The default is 32"),
    cl::cat(CacheConfigCat));

cl::opt<bool>
    DataCacheWriteBack("ta-dcache-write-back", cl::init(false),
                       cl::desc("Enables write-back mode of the cache. The "
                                "default is write-through (false)"),
                       cl::cat(CacheConfigCat));

cl::opt<bool> DataCacheWriteAllocate(
    "ta-dcache-write-allocate", cl::init(false),
    cl::desc("Enables write-allocate mode of the cache. The default is =false "
             "to use write-non-allocate mode"),
    cl::cat(CacheConfigCat));

cl::opt<bool> UnblockStores(
    "ta-unblock-stores", cl::init(false),
    cl::desc("Enables unblocking of stores, i.e. they finish directly and do "
             "not wait for background memory to complete. Default disabled."),
    cl::cat(HardwareDescrCat));

cl::opt<BgMemType> BackgroundMemoryType(
    "ta-bgmem-type",
    cl::desc("Choose the type of background memory to use (default 'sram')"),
    cl::init(BgMemType::SRAM),
    cl::values(
        clEnumValN(BgMemType::SRAM, "sram",
                   "Fixed latency SRAM background memory"),
        clEnumValN(
            BgMemType::SIMPLEDRAM, "simpledram",
            "DRAM background memory with simple controller. Always closed-rows "
            "with fixed access latency. Refreshes in fixed intervals")),
    cl::cat(HardwareDescrCat));

cl::opt<unsigned>
    Latency("ta-mem-latency", cl::init(9),
            cl::desc("The latency of the background memory. (default '9', i.e. "
                     "transferring a single word takes 10 cycles)"),
            cl::cat(HardwareDescrCat));
cl::opt<unsigned>
    PerWordLatency("ta-mem-per-word-latency", cl::init(1),
                   cl::desc("The additional latency of the background memory "
                            "for each transferred word. (default '1')"),
                   cl::cat(HardwareDescrCat));

/* aliases provided for backwards compatibility */
cl::alias SRAMLatency("ta-sram-latency", cl::desc("Alias for ta-mem-latency"),
                      cl::aliasopt(Latency), cl::cat(HardwareDescrCat));
cl::alias DRAMLatency("ta-dram-latency", cl::desc("Alias for ta-mem-latency"),
                      cl::aliasopt(Latency), cl::cat(HardwareDescrCat));

cl::opt<unsigned> DRAMRefreshLatency(
    "ta-dram-refresh-latency", cl::init(7),
    cl::desc("The latency of one refresh of the DRAM background memory. Option "
             "only applies to DRAM background memory. (default '7')"),
    cl::cat(HardwareDescrCat));

cl::bits<CRPDAnalysisType> CRPDAnaType(
    "ta-crpdana-type",
    cl::desc("Choose type of CRPD analyses to run. Only valid when passed with "
             "--ta-ana-type=crpd (default 'ecb,ucb,resilience')"),
    cl::CommaSeparated,
    cl::values(clEnumValN(CRPDAnalysisType::ECB, "ecb", "Perform ECB analysis"),
               clEnumValN(CRPDAnalysisType::UCB, "ucb", "Perform UCB analysis"),
               clEnumValN(CRPDAnalysisType::DCUCB, "dcucb",
                          "Perform DC-UCB analysis"),
               clEnumValN(CRPDAnalysisType::RESILIENCE, "resilience",
                          "Perform Resilience analysis")),
    cl::cat(LLVMTACat));

cl::opt<bool>
    UCBClever("ta-ucb-clever", cl::init(false),
              cl::desc("Enables the clever UCB mode that handles spatial "
                       "locality in a more precise way. (default false)"),
              cl::cat(LLVMTACat));

cl::bits<AnalysisType> AnaType(
    "ta-ana-type",
    cl::desc("Choose the type of analysis to run (default 'timing')"),
    cl::CommaSeparated,
    cl::values(
        clEnumValN(AnalysisType::VALANA, "value",
                   "Perform value and address analysis"),
        clEnumValN(AnalysisType::TIMING, "timing",
                   "Compute execution time bound"),
        clEnumValN(AnalysisType::CRPD, "crpd",
                   "Compute cache-related preemption delay (characterisation)"),
        clEnumValN(AnalysisType::L1ICACHE, "l1icache",
                   "Calculate a bound on the number of L1-Instruction Cache "
                   "hits and misses"),
        clEnumValN(AnalysisType::L1DCACHE, "l1dcache",
                   "Calculate a bound on the number of L1-Data Cache hits and "
                   "misses")),
    cl::cat(LLVMTACat));

llvm::cl::bits<MetricType> MetricsOnWCEP(
    "ta-metric-wcep",
    cl::desc("Which metrics should be maximised on a worst-case timing path "
             "(default none)"),
    cl::CommaSeparated,
    cl::values(
        clEnumValN(MetricType::L1DMISSES, "l1dmisses", "L1-Data-Cache misses"),
        clEnumValN(MetricType::L1IMISSES, "l1imisses",
                   "L1-Instruction-Cache misses"),
        clEnumValN(MetricType::BUSACCESSES, "busaccesses",
                   "Accesses to the shared bus"),
        clEnumValN(MetricType::BUSSTORES, "busstores",
                   "Stores to the shared bus"),
        clEnumValN(MetricType::WRITEBACKS, "writebacks",
                   "Writebacks (only makes sense on write-back caches)")),
    cl::cat(LLVMTACat));

llvm::cl::bits<MetricType> MetricsToMax(
    "ta-metric-max",
    cl::desc("Which metrics should be maximised additional to the timing "
             "(default none)"),
    cl::CommaSeparated,
    cl::values(
        clEnumValN(MetricType::L1DMISSES, "l1dmisses", "L1-Data-Cache misses"),
        clEnumValN(MetricType::L1IMISSES, "l1imisses",
                   "L1-Instruction-Cache misses"),
        clEnumValN(MetricType::BUSACCESSES, "busaccesses",
                   "Accesses to the shared bus"),
        clEnumValN(MetricType::BUSSTORES, "busstores",
                   "Stores to the shared bus"),
        clEnumValN(MetricType::WRITEBACKS, "writebacks",
                   "Writebacks (only makes sense on write-back caches)")),
    cl::cat(LLVMTACat));

cl::opt<bool> StrictMode("ta-strict", cl::init(true),
                         cl::desc("Enables the strict mode: assert when "
                                  "unknown situation arises (default true)"),
                         cl::cat(LLVMTACat));

cl::opt<AnaInfoPolicy> AnaInfoPol(
    "ta-anainfo-policy",
    cl::desc("Choose the policy to store analysis information (default "
             "'precompreq')"),
    cl::init(AnaInfoPolicy::PRECOMPREQ),
    cl::values(
        clEnumValN(AnaInfoPolicy::PRECOMPALL, "precompall",
                   "Holds precomputed information at each program point"),
        clEnumValN(AnaInfoPolicy::PRECOMPREQ, "precompreq",
                   "Holds precomputed information at required program points. "
                   "Fast lookup while using less memory."),
        clEnumValN(AnaInfoPolicy::LOWMEM, "lowmem",
                   "Holds information per basic-block, recomputation on "
                   "the-fly - memory-saving")),
    cl::cat(LLVMTACat));

// Value Analysis Options

cl::opt<unsigned> CodeStartAddress(
    "ta-start-address-code", cl::init(0x00800000),
    cl::desc("The start address of the code section in the binary"),
    cl::cat(LLVMTACat));

cl::opt<unsigned>
    InitialStackPointer("ta-initial-stack-pointer", cl::init(0x08000000),
                        cl::desc("The initial stack pointer when entry point "
                                 "is invoked (default 0x08000000)"),
                        cl::cat(LLVMTACat));

cl::opt<unsigned>
    InitialLinkRegister("ta-initial-link-register", cl::init(0x00000000),
                        cl::desc("The initial link register, i.e. where the "
                                 "final return target (default 0x00000000)"),
                        cl::cat(LLVMTACat));

// Microarchitectural Analysis Options

cl::opt<bool>
    MuJoinEnabled("ta-enable-muarchjoin", cl::init(true),
                  cl::desc("Enable joining of similar microarchitectural "
                           "states for efficiency (default true)"),
                  cl::cat(LLVMTACat));

// Path Analysis Options

cl::opt<PathAnalysisType> PathAnaType(
    "ta-pathana-type",
    cl::desc("Choose the type of path analysis to run (default 'simpleilp')"),
    cl::init(PathAnalysisType::GRAPHILP),
    cl::values(clEnumValN(PathAnalysisType::SIMPLEILP, "simpleilp",
                          "Simple ILP solution"),
               clEnumValN(PathAnalysisType::GRAPHILP, "graphilp",
                          "Graph ILP solution (prediction file)")),
    cl::cat(LLVMTACat));

cl::opt<LpSolverType> LpSolver(
    "ta-lpsolver",
    cl::desc("Choose the tool to solve the lp within the path analysis "
             "(default 'gurobi')"),
#ifdef GUROBIINSTALLED
    cl::init(LpSolverType::GUROBI),
#else
#ifdef CPLEXINSTALLED
    cl::init(LpSolverType::CPLEX),
#else
    cl::init(LpSolverType::LPSOLVE),
#endif
#endif
    cl::values(
#ifdef GUROBIINSTALLED
        clEnumValN(LpSolverType::GUROBI, "gurobi",
                   "Commercial Gurobi LP solver"),
#endif
#ifdef CPLEXINSTALLED
        clEnumValN(LpSolverType::CPLEX, "cplex", "Commercial CPLEX LP solver"),
#endif
        clEnumValN(LpSolverType::LPSOLVE, "lpsolve", "Open-source lp_solve")),
    cl::cat(LLVMTACat));

cl::opt<LpSolverEffortType> LpSolverEffort(
    "ta-lpsolver-effort",
    cl::desc("Choose which effort should be taken by the lp solver to reach an "
             "exact solution (default 'limited')"),
    cl::init(LpSolverEffortType::LIMITED),
    cl::values(
        clEnumValN(LpSolverEffortType::MINIMAL, "minimal",
                   "Solve with default MIPGAP"),
        clEnumValN(
            LpSolverEffortType::LIMITED, "limited",
            "Solve with default MIPGAP first, then try exact with time limit"),
        clEnumValN(LpSolverEffortType::MAXIMAL, "maximal",
                   "Solve with MIPGAP of 0.0 without time limit")),
    cl::cat(LLVMTACat));

cl::opt<bool> CheckFixPoint("ta-enable-fixpoint-checks", cl::init(false),
                            cl::desc("Enable explicit fixpoint checks after "
                                     "each analysis run (default false)"),
                            cl::cat(LLVMTACat));

// Options for context sensitivity

cl::opt<int> NumberCalleeTokens(
    "ta-num-callee-tokens", cl::init(0),
    cl::desc("The maximal number of callee tokens in contexts that are "
             "distinguished during trace partitioning upon calls. -1 indicates "
             "unlimited length. Default 0."),
    cl::cat(ContextSensitivityCat));

cl::opt<int> NumberCallsiteTokens(
    "ta-num-callsite-tokens", cl::init(1),
    cl::desc("The maximal number of callsite tokens in contexts that are "
             "distinguished during trace partitioning upon calls. -1 indicates "
             "unlimited length. Default 1."),
    cl::cat(ContextSensitivityCat));

cl::opt<int> NumberLoopTokens(
    "ta-num-loop-tokens", cl::init(0),
    cl::desc("The maximal number of loop-related tokens (LoopIter, LoopPeel) "
             "in contexts that are distinguished during trace partitioning "
             "upon calls. -1 indicates unlimited length. Default 0."),
    cl::cat(ContextSensitivityCat));

cl::opt<unsigned>
    LoopPeel("ta-loop-peel", cl::init(1),
             cl::desc("The number of initial loop iterations to distinguish "
                      "(peel) during trace partitioning"),
             cl::cat(ContextSensitivityCat));

// User-provided annotations

cl::list<std::string> ManualLoopBounds(
    "ta-loop-bounds-file", cl::ZeroOrMore,
    cl::desc("Takes the file with the given name and uses the loop bounds in "
             "it for the analysis (default: no file given)"),
    cl::cat(LLVMTACat));

cl::opt<bool> OutputLoopAnnotationFile(
    "ta-output-unknown-loops", cl::init(false),
    cl::desc("Outputs a file 'LoopAnnotations.csv' which enables the user to "
             "annotate loop bounds himself (default false)"),
    cl::cat(LLVMTACat));

cl::opt<std::string> ExtFuncAnnotations(
    "ta-extfunc-annotation-file", cl::init(""),
    cl::desc("Reads user-provided annotations for external functions from the "
             "given file (default: no file given)"),
    cl::cat(LLVMTACat));

cl::opt<bool> OutputExtFuncAnnotationFile(
    "ta-output-unknown-extfuncs", cl::init(false),
    cl::desc("Outputs a template file 'ExtFuncAnnotations.csv' to provide "
             "annotations about external functions (default false)"),
    cl::cat(LLVMTACat));

cl::opt<bool> RestartAfterExternal(
    "ta-restart-after-external", cl::init(false),
    cl::desc("Resume with empty microarchitectural state after external "
             "function call (default false)"),
    cl::cat(LLVMTACat));

// Options for the blocking enabled pipeline

cl::opt<unsigned>
    NumConcurrentCores("ta-num-concurrent-cores", cl::init(0),
                       cl::desc("The number of concurrent processor cores, "
                                "only relevant for shared memory (default 0)"),
                       cl::cat(HardwareDescrCat));

cl::opt<std::string> ConcAccCycBounds(
    "ta-conc-acc-cyc-bounds", cl::init(""),
    cl::desc("Expects a list of natural numbers with semicolon as delimeter. "
             "The number of elements in the list must be a multiple of "
             "-ta-num-concurrent-cores and must not be 0."),
    cl::cat(CoRunnerSensitiveCat));

cl::opt<unsigned> BlockingJoinablePartitionSize(
    "ta-blocking-joinable-partition-size", cl::init(0),
    cl::desc(
        "Size of the partitions that are used to decide if two lower blocking "
        "bounds should be joined. Only has an effect in combination with "
        "-ta-shared-memory-blocking-type=roundrobin+UBconcurrentaccesscycles. "
        "By default, all lower blocking bounds are joined. A value of 1 means "
        "only join identical bounds. A value of X means only join bounds that "
        "result in the same number if they are both integer divided by X."),
    cl::cat(CoRunnerSensitiveCat));

cl::opt<ArrivalCurveCalculationMethod> SelectedArrivalCurveCalculationMethod(
    "ta-arrival-curve-calculation-method",
    cl::desc("Method used for the calculation of the arrival curve values used "
             "in co-runner-sensitive analysis. (default 'ilpbased')"),
    cl::init(ArrivalCurveCalculationMethod::ILPBASED),
    cl::values(
        clEnumValN(ArrivalCurveCalculationMethod::PROGRAM_GRANULARITY,
                   "programGranularity",
                   "Based on a minimum period and an upper bound on the number "
                   "of accesses per program run. (potentially less precise)"),
        clEnumValN(ArrivalCurveCalculationMethod::ILPBASED, "ilpbased",
                   "Based on an ILP implicit path enumeration.")),
    cl::cat(CoRunnerSensitiveCat));

cl::opt<unsigned> ProgramPeriod(
    "ta-program-period", cl::init(0),
    cl::desc("How many cycles at least have to pass between two starts of the "
             "program under a periodic scheduling. The default value 0 means "
             "that no periodic scheduling is assumed to lower bound the time "
             "between two program starts."),
    cl::cat(CoRunnerSensitiveCat));

cl::opt<double> ProgramPeriodRel(
    "ta-program-period-rel",
    cl::desc("value >= 1 means period is value * wcetAssumingMaxInterference. "
             "value < 1 means period is wcetAssumingNoInterference + value * "
             "(wcetAssumingMaxInterference - wcetAssumingNoInterference). "
             "Negative factor values are OK. If the resulting absolute period "
             "would be negative, it is assumed as 0. If the relative period is "
             "specified, it overwrites a possible absolute period."),
    cl::cat(CoRunnerSensitiveCat));

cl::opt<unsigned> AccessCyclesJoinablePartitionSize(
    "ta-access-cycles-joinable-partition-size", cl::init(0),
    cl::desc("Size of the partitions that are used to decide if two upper "
             "bounds on the number of access cycles should be joined. Only has "
             "an effect for the arrival curve calculation. By default, all "
             "bounds are joined. A value of 1 means only join identical "
             "bounds. A value of X means only join bounds that result in the "
             "same number if they are both integer divided by X."),
    cl::cat(CoRunnerSensitiveCat));

cl::opt<bool> ProgramPeriodSubpathMethod(
    "ta-program-period-subpath-method", cl::init(false),
    cl::desc("Use the subpath method for more precision when taking into "
             "account the program period."),
    cl::cat(CoRunnerSensitiveCat));

cl::opt<double> ArrivalCurveIlpTimeLimit(
    "ta-arrival-curve-ilp-time-limit", cl::init(0.0),
    cl::desc(
        "The time limit in seconds for one arrival curve value calculation via "
        "ILP. 0.0 is the default value. 0.0 means there is no time limit. Note "
        "that we strongly recommend using a time limit for the calculation of "
        "arrival curve values as it is significantly more complex than the "
        "calculation of per-execution-run event bounds."),
    cl::cat(CoRunnerSensitiveCat));

cl::opt<int> UntilIterationMeasurement(
    "ta-until-iteration-measurement", cl::init(-1),
    cl::desc("Perform dedicated measurements from the start until the end of "
             "the iteration for as many iterations as this parameter states. "
             "Note that there is also an iteration 0. A negative value "
             "disables this dedicated measurements. This parameter is ignored "
             "in co-runner-insensitive analysis."),
    cl::cat(CoRunnerSensitiveCat));

cl::opt<GetEdges_method> ArrivalCurveLoopGetInnerEdgesMethod(
    "ta-arrival-curve-loop-get-inner-edges-method",
    cl::desc("Which method to use to detect the inner edges of loops in the "
             "calculation of values on an arrival curve. (default "
             "'insideProgramRuns')"),
    cl::init(GetEdges_method::insideProgramRuns),
    cl::values(clEnumValN(GetEdges_method::all, "all", "all"),
               clEnumValN(GetEdges_method::insideProgramRuns,
                          "insideProgramRuns", "insideProgramRuns"),
               clEnumValN(GetEdges_method::betweenInOutReachableSimple,
                          "betweenInOutReachableSimple",
                          "betweenInOutReachableSimple"),
               clEnumValN(GetEdges_method::betweenInOutReachableSimplePlus,
                          "betweenInOutReachableSimplePlus",
                          "betweenInOutReachableSimplePlus"),
               clEnumValN(GetEdges_method::betweenInOutReachableDetailed,
                          "betweenInOutReachableDetailed",
                          "betweenInOutReachableDetailed")),
    cl::cat(CoRunnerSensitiveCat));

cl::opt<GetEdges_method> ArrivalCurveCallSiteGetInnerEdgesMethod(
    "ta-arrival-curve-call-site-get-inner-edges-method",
    cl::desc("Which method to use to detect the inner edges of call sites in "
             "the calculation of values on an arrival curve. (default "
             "'insideProgramRuns')"),
    cl::init(GetEdges_method::insideProgramRuns),
    cl::values(clEnumValN(GetEdges_method::all, "all", "all"),
               clEnumValN(GetEdges_method::insideProgramRuns,
                          "insideProgramRuns", "insideProgramRuns"),
               clEnumValN(GetEdges_method::betweenInOutReachableSimple,
                          "betweenInOutReachableSimple",
                          "betweenInOutReachableSimple"),
               clEnumValN(GetEdges_method::betweenInOutReachableSimplePlus,
                          "betweenInOutReachableSimplePlus",
                          "betweenInOutReachableSimplePlus"),
               clEnumValN(GetEdges_method::betweenInOutReachableDetailed,
                          "betweenInOutReachableDetailed",
                          "betweenInOutReachableDetailed")),
    cl::cat(CoRunnerSensitiveCat));

cl::opt<bool> CoRunnerSensitiveNoWcetBound(
    "ta-co-runner-sensitive-no-wcet-bound",
    cl::desc("Do not perform a WCET bound calculation in co-runner-sensitive "
             "analysis. A value true is not allowed if a relative period is "
             "specified. (default false)"),
    cl::init(false), cl::cat(CoRunnerSensitiveCat));

cl::opt<bool> CoRunnerSensitiveNoArrivalCurveValues(
    "ta-co-runner-sensitive-no-arrival-curve-values",
    cl::desc("Do not perform an arrival curve value calculation in "
             "co-runner-sensitive analysis. (default false)"),
    cl::init(false), cl::cat(CoRunnerSensitiveCat));

cl::opt<FixedPointType> CoRunnerSensitiveAnalysisFixedPointType(
    "ta-co-runner-sensitive-analysis-fixed-point-type",
    cl::desc("Determines which type of fixed point the iterative "
             "co-runner-sensitive analysis pursues (default 'greatest')"),
    cl::init(FixedPointType::GREATEST),
    cl::values(clEnumValN(FixedPointType::LEAST, "least",
                          "Obtain least fixed point."),
               clEnumValN(FixedPointType::GREATEST, "greatest",
                          "Obtain greatest fixed point.")),
    cl::cat(CoRunnerSensitiveCat));

cl::opt<bool> ProgramPeriodRelEvalWrtWcetIgnoringInterference(
    "ta-program-period-rel-eval-wrt-wcet-ignoring-interference",
    cl::init(false),
    cl::desc("If this is true, the relative period is multiplied with a wcet "
             "bound ignoring the interference to obtain the absolute period."),
    cl::cat(CoRunnerSensitiveCat));

cl::opt<ArrivalCurveIlpObjectiveType> ArrivalCurveIlpObjective(
    "ta-arrival-curve-ilp-objective",
    cl::desc("Use one of two orthogonal objectives. Or use a combined version "
             "that is at least as precise as each variant, but potentially "
             "more precise than each one. (default 'variant1')"),
    cl::init(ArrivalCurveIlpObjectiveType::VARIANT1),
    cl::values(
        clEnumValN(ArrivalCurveIlpObjectiveType::VARIANT1, "variant1",
                   "Sum up upper bound on event occurrences for each edge."),
        clEnumValN(ArrivalCurveIlpObjectiveType::VARIANT2, "variant2",
                   "Sum up upper bound on event occurrences for each edge that "
                   "is not first or the last of the path. For every remaining "
                   "clock cycle of the time window, assume an event."),
        clEnumValN(ArrivalCurveIlpObjectiveType::COMBINED, "combined",
                   "For each ILP valuation, use the minimum of above two "
                   "variants as objective.")),
    cl::cat(CoRunnerSensitiveCat));

cl::bits<InterferenceSource> CompositionalBaseBound(
    "ta-compositional-base-bound",
    cl::desc("Enables the computation of a compositional base bound. Requires "
             "an integrated analysis. (default none)"),
    cl::CommaSeparated,
    cl::values(clEnumValN(InterferenceSource::DRAMREFRESH, "dramrefresh",
                          "DRAM refreshes"),
               clEnumValN(InterferenceSource::BUSBLOCKING, "busblocking",
                          "Shared bus blocking"),
               clEnumValN(InterferenceSource::ICMPREEMPTION, "icmpreemption",
                          "Instr Cache Misses due to preemption"),
               clEnumValN(InterferenceSource::DCMPREEMPTION, "dcmpreemption",
                          "Data Cache Misses due to preemption"),
               clEnumValN(InterferenceSource::WRITEBACK, "writeback",
                          "Writeback")),
    cl::cat(LLVMTACat));

cl::bits<InterferenceSource> DumpInterferenceResponseCurve(
    "ta-dump-interference-response-curve",
    cl::desc("Choose for which interference source we want to dump an "
             "interference response curve. (default none)"),
    cl::CommaSeparated,
    cl::values(clEnumValN(InterferenceSource::DRAMREFRESH, "dramrefresh",
                          "DRAM refreshes"),
               clEnumValN(InterferenceSource::BUSBLOCKING, "busblocking",
                          "Shared bus blocking"),
               clEnumValN(InterferenceSource::ICMPREEMPTION, "icmpreemption",
                          "Instr Cache Misses due to preemption"),
               clEnumValN(InterferenceSource::DCMPREEMPTION, "dcmpreemption",
                          "Data Cache Misses due to preemption"),
               clEnumValN(InterferenceSource::WRITEBACK, "writeback",
                          "Writeback")),
    cl::cat(LLVMTACat));

cl::opt<bool> CoRunnerSensitiveDumpedBlockedCyclesScaledToAccesses(
    "ta-co-runner-sensitive-dumped-blocked-cycles-scaled-to-accesses",
    cl::desc("Dump the impact of the number of concurrently interfering "
             "accesses on the WCET bound instead of the concurrently "
             "interfering access cycles (default false)."),
    cl::init(false), cl::cat(CoRunnerSensitiveCat));

cl::bits<InterferenceSource> CalculateSlopeInterferenceCurve(
    "ta-calculate-slope-interference-curve",
    cl::desc("Calculate the slope of a linear approximation of the "
             "interference response curve if starting in bound without "
             "interference. (default none)"),
    cl::CommaSeparated,
    cl::values(clEnumValN(InterferenceSource::DRAMREFRESH, "dramrefresh",
                          "DRAM refreshes"),
               clEnumValN(InterferenceSource::BUSBLOCKING, "busblocking",
                          "Shared bus blocking"),
               clEnumValN(InterferenceSource::ICMPREEMPTION, "icmpreemption",
                          "Instr Cache Misses due to preemption"),
               clEnumValN(InterferenceSource::DCMPREEMPTION, "dcmpreemption",
                          "Data Cache Misses due to preemption"),
               clEnumValN(InterferenceSource::WRITEBACK, "writeback",
                          "Writeback")),
    cl::cat(LLVMTACat));

cl::opt<bool>
    AssumeCleanCache("ta-assume-clean-cache",
                     cl::desc("Assumes an initially clean cache in the "
                              "writeback analyses (default:true)"),
                     cl::init(true), cl::cat(WritebackCat));

/* All these options are mostly here for evaluation purposes. You generally wnat
 * all of them enabled */
cl::opt<WBBoundType> WBBound(
    "ta-wb-bound",
    cl::desc("Selects the bound enforced on the writebacks in the program. "
             "There is no reason to change this except for evaluation purposes "
             "(default:dfs)"),
    cl::init(WBBoundType::DIRTIFYING_STORE),
    cl::values(clEnumValN(WBBoundType::NONE, "none",
                          "Do not bound the number of writebacks (rely on "
                          "Dirtiness analysis only)"),
               clEnumValN(WBBoundType::STORE, "store",
                          "Bound the number of writebacks by the number of "
                          "stores in the program."),
               clEnumValN(WBBoundType::DIRTIFYING_STORE, "dfs",
                          "Bound the number of writebacks by the number of "
                          "dirtifying stores. If DirtinessAnalysis is "
                          "disabled, this falls back to \"store\"")),
    cl::cat(WritebackCat));

cl::opt<bool>
    AnalyseDirtiness("ta-dirtiness-analysis",
                     cl::desc("Toggles the dirtiness analysis (default: on)"),
                     cl::init(true), cl::cat(WritebackCat));

cl::opt<bool> StaticallyRefuteWritebacks(
    "ta-statically-refute-writebacks",
    cl::desc("Whether to use the may-dirtyness analysis to refute write backs "
             "(default: true)"),
    cl::init(true), cl::cat(WritebackCat));

cl::opt<bool> DFSPersistence(
    "ta-dfs-persistence",
    cl::desc("Whether to emit dfs-persistence constraints (default: true)"),
    cl::init(true), cl::cat(WritebackCat));
/* Writeback evaluation options end here */

cl::opt<bool>
    ArrayAnalysis("ta-array-analysis",
                  cl::desc("Toggles the array-aware analysis (default: off)"),
                  cl::init(false), cl::cat(ArrayCat));

cl::opt<ArrayMustAnaType> ArrayMustAnalysis(
    "ta-array-must",
    cl::desc("Chooses the array extension for the MUST analysis (default: "
             "none, since it might be expensive)"),
    cl::init(ArrayMustAnaType::NONE),
    cl::values(
        clEnumValN(ArrayMustAnaType::NONE, "none",
                   "No special datastructure handling"),
        clEnumValN(
            ArrayMustAnaType::CONFLICT_SET_INTERSECT, "conflict-set-intersect",
            "Simple per-block conflict sets. Choose intersection on join"),
        clEnumValN(ArrayMustAnaType::CONFLICT_SET_UNION, "conflict-set-union",
                   "Simple per-block conflict sets. Choose union on join"),
        clEnumValN(
            ArrayMustAnaType::CONFLICT_POWERSET, "conflict-powerset",
            "Most powerful analysis: One bound per conflictset per block")),
    cl::cat(ArrayCat));

cl::opt<ArrayPersistenceAnaType> ArrayPersistenceAnalysis(
    "ta-array-persis",
    cl::desc("Chooses the array extension for the persistence analysis "
             "(default: none)"),
    cl::init(ArrayPersistenceAnaType::NONE),
    cl::values(clEnumValN(ArrayPersistenceAnaType::NONE, "none",
                          "No special datastructure handling"),
               clEnumValN(ArrayPersistenceAnaType::SETWISE, "setwise",
                          "Only relevant for elementwise persistence: Run a "
                          "setwise persistence in parallel in an attempt to "
                          "prove array accesses persistent")),
    cl::cat(ArrayCat));

cl::opt<bool>
    PreemptiveExecution("ta-preemptive",
                        cl::desc("Can the execution of the program under "
                                 "analysis be preempted? (default false)"),
                        cl::init(false), cl::cat(LLVMTACat));

cl::opt<unsigned> PreemptionICacheBudget(
    "ta-preemption-icache-budget",
    cl::desc("How many additional instruction cache misses can occur due to "
             "preemption? (default 0)"),
    cl::init(0), cl::cat(LLVMTACat));

cl::opt<unsigned>
    PreemptionDCacheBudget("ta-preemption-dcache-budget",
                           cl::desc("How many additional data cache misses can "
                                    "occur due to preemption? (default 0)"),
                           cl::init(0), cl::cat(LLVMTACat));
