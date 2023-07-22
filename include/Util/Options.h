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

#ifndef UTIL_OPTIONS_H
#define UTIL_OPTIONS_H

//#define CPLEXINSTALLED
#define GUROBIINSTALLED

#include "llvm/Support/CommandLine.h"

// the following include would have closed
// in include cycle.
// Thus, we need a forward declaration.
//#include "PathAnalysis/GetEdges.h"
namespace TimingAnalysisPass {
enum class GetEdges_method : char;
}
using TimingAnalysisPass::GetEdges_method;

/**
 * The available analysis types
 */
enum class AnalysisType {
  VALANA,   /// Perform value & address analysis
  TIMING,   /// Compute worst-case execution time bound
  CRPD,     /// Compute cache-related preemption
  L1ICACHE, /// Count the number of (Level-1) instruction cache hits and misses
  L1DCACHE  /// Count the number of (Level-1) data cache hits and misses
};

/**
 * The available additional metrics that can be either maximised
 * on the timing stategraph, or maximised on the worst-case path (WCEP).
 */
enum class MetricType {
  L1DMISSES,   // Number of L1-Data-Cache misses
  L1IMISSES,   // Number of L1-Instruction-Cache misses
  BUSACCESSES, // Number of accesses to the (shared) bus
  BUSSTORES,   // Number of stores to the (shared) bus
  WRITEBACKS   // Number of writebacks. Only makes sense on write-back caches
};

/**
 * The available microarchitectures
 */
enum class MicroArchitecturalType {
  FIXEDLATENCY, /// Analyse timing of fixed latency processor
  PRET, /// Analyse timign of a single hardware thread of a thread-interleaved
        /// pipeline
  INORDER,       /// Analyse timing of a 5-stage in-order pipelined processor
  STRICTINORDER, /// Analyse timing of a 5-stage strictly in-order pipelined
                 /// processor
  OUTOFORDER     /// Analyse timing of a out-of-order pielined processor
};

/**
 * The available memory topologies
 */
enum class MemoryTopologyType {
  NONE,           /// No memory at all (only valid for fixedlatency)
  SINGLEMEM,      /// Memory topology with one background memory
  SEPARATECACHES, /// Memory topology with separate instruction and data caches
                  /// in front
  PRIVINSTRSPMDATASHARED /// Private instruction scratchpad for core,
                         /// potentially shared data memory
};

/**
 * The currently possible ways to consider bus blocking for a shared memory
 */
enum class SharedBusType {
  NONE,      /// Every access request is granted immediately
  ROUNDROBIN /// Round-Robin bus arbitration
};

/**
 * Possible types of background memories
 */
enum class BgMemType {
  SRAM,      // Fixed latency SRAM memory
  SIMPLEDRAM // Simple DRAM controller, always closed-row, refreshes in fixed
             // intervals
};

/**
 * The available compositional types
 */
enum class CompositionalAnalysisType {
  ICACHE, /// Timing Analysis uses an always hit cache for the instruction
          /// cache. This Cache is not analysed.
  DCACHE, /// Timing Analysis uses an always hit cache for the data cache. This
          /// Cache is not analysed.
  DRAMREFRESH,      /// Timing Analysis should analyse DRAM refreshes in a
                    /// compositional way.
  SHAREDBUSBLOCKING /// Timing Analysis should analysis the blocking on the
                    /// shared bus in a compositional way.
};

/**
 * The available types of CRPD analyses to perform
 */
enum class CRPDAnalysisType {
  ECB,   /// Perform CRPD analysis for Evicting Cache Blocks.
  UCB,   /// Perform CRPD analysis for Useful Cache Blocks.
  DCUCB, /// Perform CRPD analysis for definitely-cached Useful Cache Blocks.
  RESILIENCE /// Perform Resilience analysis.
};

/**
 * The available types for "local reducibility", i.e. to follow the local worst
 * case, and stalling
 */
enum class LocalWorstCaseType {
  ICMISS,      /// Instruction cache miss is considered locally worse than a hit
  DCMISS,      /// Data cache miss is considered locally worse than a hit
  WRITEBACK,   /// Writeback on cache eviction is considered locally worse than
               /// not writing-back
  DRAMREFRESH, /// DRAM refresh is considered locally worse than not refreshing
  BUSBLOCKING  /// Blocking on the shared bus is considered locally worse than
               /// not being blocked
};

/**
 * Sources of interference that can be used for ir-curve dumping, comp base
 * bound, etc.
 */
enum class InterferenceSource {
  DRAMREFRESH,   // refresh prolongs access
  BUSBLOCKING,   // bus blocking prolongs access
  ICMPREEMPTION, // additional ic-misses due to preemption
  DCMPREEMPTION, // additional dc-misses due to preemption
  WRITEBACK      // writeback prolongs access
};

/**
 * Which replacement policy should the cache have.
 */
enum class CacheReplPolicyType {
  LRU,   /// LRU cache replacement policy
  FIFO,  /// FIFO cache replacement policy
  ALHIT, /// Always-Hit cache (no replacement), Can be used to simulate
         /// scratchpad memories
  ALMISS /// Always-Miss cache, used to simulate no cache
};

/**
 * Which cache persistence analysis to use
 */
enum class PersistenceType {
  NONE,    /// No cache persistence analysis
  SETWISE, /// Set-wise access counting persistence analysis
  ELEWISE, /// Element-wise conflict counting persistence analysis
  CONDMUST /// Conditional must analysis
};

/**
 * The available path analysis types
 */
enum class PathAnalysisType {
  SIMPLEILP, /// Use the simple ILP approach with one timing per basic block
  GRAPHILP   /// Use a context sensitive ILP approach with timings per different
             /// context per basic block
};

/**
 * The store policy for analysis information.
 */
enum class AnaInfoPolicy {
  PRECOMPALL, /// Precompute the analysis information at each program point to
              /// speed up lookups
  PRECOMPREQ, /// Precompute the analysis information at all strictly required
              /// program points for fast lookups
  LOWMEM /// Only remember basic-block analysis information, recompute on the
         /// fly, save memory
};

/**
 * The lp-solver to be used for the path analysis
 */
enum class LpSolverType {
#ifdef CPLEXINSTALLED
  CPLEX, /// Use the commercial cplex tool
#endif
#ifdef GUROBIINSTALLED
  GUROBI, /// Use the commercial gurobi tool
#endif
  LPSOLVE /// Use the open-source solver lp_solve
};

enum class LpSolverEffortType {
  MINIMAL, /// Solve ILP with default MIPGAP of 10e-4
  LIMITED, /// Do Minimal first, but then try MIPGAP of 0.0 with time limit
  MAXIMAL  /// Solve ILP with MIPGAP of 0.0 without time limit
};

/**
 * Method used for calculation of arrival curve
 * values for interval lengths.
 */
enum class ArrivalCurveCalculationMethod { PROGRAM_GRANULARITY, ILPBASED };

/**
 * The two types of fixed points that we
 * typically consider in analysis.
 */
enum class FixedPointType { LEAST, GREATEST };

/**
 * Use one of two orthogonal objectives.
 * Or use a combined version that is at
 * least as precise as each variant, but
 * potentially more precise than each one.
 */
enum class ArrivalCurveIlpObjectiveType { VARIANT1, VARIANT2, COMBINED };

// Global options

/**
 * Quiet mode: No output on console and no file output, except for the
 * necessary.
 */
extern llvm::cl::opt<bool> QuietMode;

/**
 * Dumps the state graph in .vcg instead of .dot
 */
extern llvm::cl::opt<bool> DumpVcgGraph;

/**
 * Define the entry point of the analysis.
 */
extern llvm::cl::opt<std::string> AnalysisEntryPoint;

/**
 * Which microarchitectural analysis should be run
 */
extern llvm::cl::opt<MicroArchitecturalType> MuArchType;

/**
 * Which memory topology to use
 */
extern llvm::cl::opt<MemoryTopologyType> MemTopType;

/**
 * What to assume about the shared bus
 */
extern llvm::cl::opt<SharedBusType> SharedBus;

/**
 * Indicates if a co-runner-sensitive analysis is wanted
 */
extern llvm::cl::opt<bool> CoRunnerSensitive;

/**
 * Which components should be analysed separately
 */
extern llvm::cl::bits<CompositionalAnalysisType> CompAnaType;

/**
 * Which local worst cases should be followed exclusively, i.e. without a split.
 */
extern llvm::cl::bits<LocalWorstCaseType> FollowLocalWorstType;

/**
 * On which local worst cases should the pipeline stall to allow for
 * compositionality.
 */
extern llvm::cl::bits<LocalWorstCaseType> StallOnLocalWorstType;

/**
 * Determines whether for compositional analysis a joint ILP analysis should be
 * performed. This can reduce overestimation. By default it is off.
 */
extern llvm::cl::opt<bool> CompAnaJointILP;

/**
 * Which cache replacement policy type for the instruction cache
 */
extern llvm::cl::opt<CacheReplPolicyType> InstrCacheReplPolType;

/**
 * Which persistence analysis to use for the instruction cache
 */
extern llvm::cl::opt<PersistenceType> InstrCachePersType;

/**
 * Linesize of the instruction cache
 */
extern llvm::cl::opt<unsigned> Ilinesize;

/**
 * Associativity of the instruction cache
 */
extern llvm::cl::opt<unsigned> Iassoc;

/**
 * Number of cache sets of the instruction cache
 */
extern llvm::cl::opt<unsigned> Insets;

/**
 * Which cache replacement policy type for the data cache
 */
extern llvm::cl::opt<CacheReplPolicyType> DataCacheReplPolType;

/**
 * Which persistence analysis to use for the data cache
 */
extern llvm::cl::opt<PersistenceType> DataCachePersType;

/**
 * Linesize of the data cache
 */
extern llvm::cl::opt<unsigned> Dlinesize;

/**
 * Associativity of the data cache
 */
extern llvm::cl::opt<unsigned> Dassoc;

/**
 * Number of cache sets of the data cache
 */
extern llvm::cl::opt<unsigned> Dnsets;

/**
 * Is the data cache in write-back mode? Otherwise it is write-through which is
 * default.
 */
extern llvm::cl::opt<bool> DataCacheWriteBack;

/**
 * Is the data cache in write-allocate mode (default)? Otherwise it is in
 * write-non-allocate mode.
 */
extern llvm::cl::opt<bool> DataCacheWriteAllocate;

/**
 * Should stores finish directly or should they wait for the background memory
 * to complete.
 */
extern llvm::cl::opt<bool> UnblockStores;

/**
 * The type of background memory.
 */
extern llvm::cl::opt<BgMemType> BackgroundMemoryType;

/**
 * The latency of the background memory. Each access has a fixed cost of Latency
 * and a variable cost of PerWordLatency per word transferred.
 */
extern llvm::cl::opt<unsigned> Latency;
extern llvm::cl::opt<unsigned> PerWordLatency;

/**
 * The latency of one refresh of the DRAM background memory. The option only
 * applies for DRAM background memory.
 */
extern llvm::cl::opt<unsigned> DRAMRefreshLatency;

/**
 * Which analysis type to run and which results are of interest
 */
extern llvm::cl::bits<AnalysisType> AnaType;

/**
 * Which CRPD analyses to run.
 */
extern llvm::cl::bits<CRPDAnalysisType> CRPDAnaType;

/**
 * Should the ucb analysis be run in "clever" mode, i.e. ignore spatial localiyt
 * effects by subtracting the last accessed address from the UCB-set. This
 * requires to add 1*BRT in the schedulability analysis.
 */
extern llvm::cl::opt<bool> UCBClever;

/**
 * Which metrics should be evaluated on the WCEP.
 */
extern llvm::cl::bits<MetricType> MetricsOnWCEP;

/**
 * Which metrics should be maximised, additional to timing.
 */
extern llvm::cl::bits<MetricType> MetricsToMax;

/**
 * Enables the strict checking mode. Assert when unknown situation arises.
 */
extern llvm::cl::opt<bool> StrictMode;

/**
 * Chooses the policy of the analysis information module w.r.t. memory/time
 * optimizations
 */
extern llvm::cl::opt<AnaInfoPolicy> AnaInfoPol;

// Value Analysis Options

/**
 * Address where code is located.
 */
extern llvm::cl::opt<unsigned> CodeStartAddress;

/**
 * Initial stack pointer.
 */
extern llvm::cl::opt<unsigned> InitialStackPointer;

/**
 * Initial link register. Where to branch after this program is executed.
 */
extern llvm::cl::opt<unsigned> InitialLinkRegister;

// Microarchitectural Analysis Options

/**
 * Should we enable joining for efficiency
 */
extern llvm::cl::opt<bool> MuJoinEnabled;

// Path Analysis Options

/**
 * Choose the path analysis type to use
 */
extern llvm::cl::opt<PathAnalysisType> PathAnaType;

/**
 * Choose the lp solver
 */
extern llvm::cl::opt<LpSolverType> LpSolver;

/**
 * Choose which effort should be taken to obtain a precise bound.
 */
extern llvm::cl::opt<LpSolverEffortType> LpSolverEffort;

/**
 * Option to enable/disable explicit fix-point checks when dumping analysis
 * information.
 */
extern llvm::cl::opt<bool> CheckFixPoint;

// Options for context sensitivity

/**
 * The maximal number of Callee-tokens in a context upon call.
 * Negative number indicates unlimited.
 */
extern llvm::cl::opt<int> NumberCalleeTokens;

/**
 * The maximal number of Callsite-tokens in a context upon call.
 * Negative number indicates unlimited.
 */
extern llvm::cl::opt<int> NumberCallsiteTokens;

/**
 * The maximal number of Loop-related tokens (LoopIter, LoopPeel) in a context
 * upon call. Negative number indicates unlimited.
 */
extern llvm::cl::opt<int> NumberLoopTokens;

/**
 * The number of peeled loop iterations.
 */
extern llvm::cl::opt<unsigned> LoopPeel;

// User-provided annotations

/**
 * The file path(s) for manual loop bounds.
 */
extern llvm::cl::list<std::string> ManualLoopBounds;

/**
 * Says whether a loop annotation file should be generated or not.
 */
extern llvm::cl::opt<bool> OutputLoopAnnotationFile;

/**
 * The file path for external function annotations.
 */
extern llvm::cl::opt<std::string> ExtFuncAnnotations;

/**
 * Says whether a external function annotation file should be generated or not.
 */
extern llvm::cl::opt<bool> OutputExtFuncAnnotationFile;

/**
 * Should we restart with an empty pipeline state (not TOP) after an external
 * function call.
 */
extern llvm::cl::opt<bool> RestartAfterExternal;

// Options for the blocking enabled pipeline

/**
 * The maximal number of blocking cycles before an access is granted
 */
extern llvm::cl::opt<unsigned> NumConcurrentCores;

/**
 * The maximal number of blocking cycles for the considered core
 */
extern llvm::cl::opt<std::string> ConcAccCycBounds;

/**
 * Should we join the blocking counter of BlockingCounterCyclingMemory
 */
extern llvm::cl::opt<unsigned> BlockingJoinablePartitionSize;

/**
 * Method used for the calculation of the arrival
 * curves used in co-runner-sensitive analysis.
 */
extern llvm::cl::opt<ArrivalCurveCalculationMethod>
    SelectedArrivalCurveCalculationMethod;

/**
 * How many cycles at least have to pass between two starts of the program
 * under a periodic scheduling.
 */
extern llvm::cl::opt<unsigned> ProgramPeriod;

/**
 * A variant that specifies the program period as relative factor
 * w.r.t. the pessimistic WCET bound or
 * the pessimistic and the optimistic one.
 */
extern llvm::cl::opt<double> ProgramPeriodRel;

/**
 * Should we join the lower bound time counter
 */
extern llvm::cl::opt<unsigned> AccessCyclesJoinablePartitionSize;

/**
 * Use the subpath method for more precision when
 * taking into account the program period.
 */
extern llvm::cl::opt<bool> ProgramPeriodSubpathMethod;

/**
 * The time limit in seconds for one arrival curve value
 * calculation via ILP.
 */
extern llvm::cl::opt<double> ArrivalCurveIlpTimeLimit;

/**
 * Do we need to handle scopes, i.e. have we instruction or data cache
 * persistence enabled?
 */
inline bool needPersistenceScopes() {
  return DataCachePersType != PersistenceType::NONE ||
         InstrCachePersType != PersistenceType::NONE;
}

/**
 * Do we need the instruction addresses we access? E.g. if we want to compute
 * ECBs or Preemption Costs.
 */
inline bool needAccessedInstructionAddresses() {
  return AnaType.isSet(AnalysisType::CRPD);
}
/**
 * Do we need the data addresses we access? E.g. if we want to compute ECBs or
 * Preemption Costs.
 */
inline bool needAccessedDataAddresses() {
  return AnaType.isSet(AnalysisType::CRPD);
}

/**
 * This global variable is used to decide whether a strictly in-order
 * arbitration of data fetch misses and instruction fetch misses is demanded.
 */
inline bool enableStrictInorderDataInstrArbitration() {
  return MuArchType == MicroArchitecturalType::STRICTINORDER;
}

/**
 * Until which iteration do we need dedicated measurements?
 */
extern llvm::cl::opt<int> UntilIterationMeasurement;

/**
 * Which method to use to detect the inner edges of loops
 * in the calculation of values on an arrival curve.
 */
extern llvm::cl::opt<GetEdges_method> ArrivalCurveLoopGetInnerEdgesMethod;

/**
 * Which method to use to detect the inner edges of call sites
 * in the calculation of values on an arrival curve.
 */
extern llvm::cl::opt<GetEdges_method> ArrivalCurveCallSiteGetInnerEdgesMethod;

/**
 * Do not perform a WCET bound calculation in co-runner-sensitive analysis.
 */
extern llvm::cl::opt<bool> CoRunnerSensitiveNoWcetBound;

/**
 * Do not perform an arrival curve value calculation in co-runner-sensitive
 * analysis.
 */
extern llvm::cl::opt<bool> CoRunnerSensitiveNoArrivalCurveValues;

/**
 * Choose the lp solver
 */
extern llvm::cl::opt<FixedPointType> CoRunnerSensitiveAnalysisFixedPointType;

/**
 * In this case, the effective period is obtained as rel *
 * WcetIgnoringInterference
 */
extern llvm::cl::opt<bool> ProgramPeriodRelEvalWrtWcetIgnoringInterference;

/**
 * Use a simple objective or the minimum
 * over two orthogonal objectives.
 */
extern llvm::cl::opt<ArrivalCurveIlpObjectiveType> ArrivalCurveIlpObjective;

/**
 * Enables the mode to compute a compositional base bound, although the
 * architecture does not support compositionality. Requires an expensive
 * integrated analysis first. So far only bus blocking is supported.
 */
extern llvm::cl::bits<InterferenceSource> CompositionalBaseBound;

/**
 * Additionally dump a mapping of all possible numbers of blocked
 * cycles in a program run to the corresponding WCET bounds.
 */
extern llvm::cl::bits<InterferenceSource> DumpInterferenceResponseCurve;

/**
 * Dump the impact of the number of concurrently interfering
 * accesses on the WCET bound instead of the concurrently
 * interfering access cycles.
 */
extern llvm::cl::opt<bool> CoRunnerSensitiveDumpedBlockedCyclesScaledToAccesses;

/**
 * We have an interference response curve.
 * We want to know the slope of a correct linear approximation with
 * bound without interference as y-intercept.
 */
extern llvm::cl::bits<InterferenceSource> CalculateSlopeInterferenceCurve;

/* Disable parts of the writeback-analysis. Used for evaluation purposes only */
enum class WBBoundType { NONE, STORE, DIRTIFYING_STORE };
extern llvm::cl::opt<WBBoundType> WBBound;
extern llvm::cl::opt<bool> AnalyseDirtiness;
extern llvm::cl::opt<bool> AssumeCleanCache;
extern llvm::cl::opt<bool> StaticallyRefuteWritebacks;
extern llvm::cl::opt<bool> DFSPersistence;

enum class ArrayMustAnaType {
  NONE,
  CONFLICT_SET_INTERSECT,
  CONFLICT_SET_UNION,
  CONFLICT_POWERSET
};
enum class ArrayPersistenceAnaType { NONE, SETWISE };

/* Enables recognition of array accesses. Prerequisite for the more complex
 * array analyses */
extern llvm::cl::opt<bool> ArrayAnalysis;
/* datastructure extension for the MUST analysis */
extern llvm::cl::opt<ArrayMustAnaType> ArrayMustAnalysis;
/* datastructure extension for the persistence analysis */
extern llvm::cl::opt<ArrayPersistenceAnaType> ArrayPersistenceAnalysis;

// Options for possible preemptions

/**
 * Can the execution of the program under analysis be preempted? Default: false.
 */
extern llvm::cl::opt<bool> PreemptiveExecution;

/**
 * How many additional instruction cache misses can the program incurr due to
 * preemption.
 */
extern llvm::cl::opt<unsigned> PreemptionICacheBudget;
/**
 * How many additional data cache misses can the program incurr due to
 * preemption.
 */
extern llvm::cl::opt<unsigned> PreemptionDCacheBudget;

#endif
