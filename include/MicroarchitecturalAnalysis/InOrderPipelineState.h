////////////////////////////////////////////////////////////////////////////////
//
//   LLVMTA - Timing Analyser performing worst-case execution time analysis
//     using the LLVM backend intermediate representation
//
// Copyright (C) 2013-2022  Saarland University
// Copyright (C) 2014-2015 Claus Faymonville
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

#ifndef INORDERPIPELINESTATE_H
#define INORDERPIPELINESTATE_H

#include "Memory/MemoryTopologyInterface.h"
#include "MicroarchitecturalAnalysis/ConvergenceDetection.h"
#include "MicroarchitecturalAnalysis/ConvergenceType.h"
#include "MicroarchitecturalAnalysis/MicroArchitecturalState.h"
#include "PreprocessingAnalysis/AddressInformation.h"
#include "Util/Util.h"

#include "ARM.h"

#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/Support/Debug.h"
#include <iostream>

#include <boost/optional/optional.hpp>

#include <set>

/**
 * These stages mark the input to the stage between the underscores.
 * Example: IF_ID_IND has the output of the instruction fetch stage (some
 * instruction) which will be taken by the decode stage The WB_FIN_IND only
 * serves to see which instruction was finished in the last cycle (for isFinal)
 */
#define IF_ID_IND 0
#define ID_EX_IND 1
#define EX_MEM_IND 2
#define MEM_WB_IND 3
#define WB_FIN_IND 4
#define NUMBEROFSTAGES 5

/**
 * 0 means a variable-latency execution latency configuration
 * 1 means a one-cycle execution latency for each instruction
 * 2 means a two-cycles execution latency for each instruction
 */
#define IOEXECUTIONLATENCY 0

#if !defined IOEXECUTIONLATENCY
#error IOEXECUTIONLATENCY is not defined.
#endif

namespace TimingAnalysisPass {

/**
 * Class implementing the cycle-based semantics of a simple processor with
 * a five-stage pipeline.
 * The resulting analysis is basically a counter-based microarchitectural
 * analysis.
 */
template <class MemoryTopology>
class InOrderPipelineState
    : public MicroArchitecturalState<
          InOrderPipelineState<MemoryTopology>,
          std::tuple<InstrContextMapping &, AddressInformation &>> {

  // ensure that MemoryTopology is a class derived from MemoryTopologyInterface
  BOOST_STATIC_ASSERT(boost::is_base_of<MemoryTopologyInterface<MemoryTopology>,
                                        MemoryTopology>::value);

public:
  // define SuperClass for convenience
  typedef MicroArchitecturalState<
      InOrderPipelineState<MemoryTopology>,
      std::tuple<InstrContextMapping &, AddressInformation &>>
      SuperClass;

  typedef typename SuperClass::StateSet StateSet;

  template <typename T>
  using MapFromStates = typename SuperClass::template MapFromStates<T>;

  typedef MemoryTopology Memory;

  /**
   * Constructor. Creates an empty microarchitectural state (i.e. all
   * microarchitectural entities are empty - just as after reset) but with the
   * given program counter.
   */
  explicit InOrderPipelineState(ProgramLocation &pl);
  /**
   * Copy Constructor
   */
  explicit InOrderPipelineState(const InOrderPipelineState &iops);

  /**
   * Virtual destructor
   */
  virtual ~InOrderPipelineState();

  /**
   * Container used to make the local metrics of this class
   * available to the world outside.
   */
  struct LocalMetrics : SuperClass::LocalMetrics {
    // shorthand for the base class
    typedef typename SuperClass::LocalMetrics LocalMetricsBase;

    // the fields added to the local metrics used as base
    typename MemoryTopology::LocalMetrics memoryTopology;

    /**
     * Creates the local metrics based on the
     * outer class' content.
     */
    LocalMetrics(const InOrderPipelineState &outerClassInstance)
        : LocalMetricsBase(outerClassInstance),
          memoryTopology(outerClassInstance.memory) {}

    /**
     * Checks for equality between local metrics.
     */
    bool operator==(const LocalMetrics &anotherInstance) {
      return LocalMetricsBase::operator==(anotherInstance) &&
             memoryTopology == anotherInstance.memoryTopology;
    }
  };

  /**
   * Resets the local metrics to their initial values.
   */
  void resetLocalMetrics() {
    SuperClass::resetLocalMetrics();
    memory.resetLocalMetrics();
  }

  /**
   * See superclass first.
   * Produces all possible successor states.
   */
  virtual StateSet
  cycle(std::tuple<InstrContextMapping &, AddressInformation &> &dep) const;

  /**
   * See superclass first.
   * Checks whether a ProgramLocation left the pipeline after the last cycle.
   */
  virtual bool isFinal(ExecutionElement &pl);

  virtual bool isWaitingForJoin() const { return memory.isWaitingForJoin(); }

  /// \see superclass
  bool operator==(const InOrderPipelineState &ds) const;

  /// \see superclass
  virtual size_t hashcode() const;

  /// \see superclass
  virtual bool isJoinable(const InOrderPipelineState &ds) const;

  /// \see superclass
  virtual void join(const InOrderPipelineState &ds);

  // Output operation
  template <class Mem>
  friend std::ostream &operator<<(std::ostream &stream,
                                  const InOrderPipelineState<Mem> &iops);

#ifdef AUTO_CONVERGENCE_DETECTION
  ConvergenceType
  isConvergedAfterCycleFrom(const InOrderPipelineState<MemoryTopology> &origin,
                            ConvergenceType convergenceTypeOfSibling) const;

#else
  ConvergenceType getConvergenceType() const {
    return POTENTIALLY_NOT_CONVERGED;
  }

#endif
private:
  static std::map<int, std::set<unsigned>> instructionExecutionTimes;

  void initExecutionTimesMap();

  /**
   * Accesses both instruction and data memory if necessary.
   * Uses Instructions from EX_MEM_IND and the PC
   */
  void accessDataFromMemoryTopology(AddressInformation &addrInfo);

  std::list<InOrderPipelineState<MemoryTopology>> cycleMemoryTopology();

  // The following functions should only be called on the successor!
  // empty stages instruction fetch and instruction decode
  // The fetch stage was about accessing oldPc
  void emptyPipelineDueToBranching(unsigned oldPc);

  // proceeding the write back stage
  void processWriteBackStage();

  // proceeding the memory stage
  std::list<InOrderPipelineState> processMemoryStage(
      std::tuple<InstrContextMapping &, AddressInformation &> &dep) const;

  // proceeding the execution stage
  std::list<InOrderPipelineState> processExecuteStage(
      std::tuple<InstrContextMapping &, AddressInformation &> &dep) const;

  /**
   * Helper function that check whether an instruction is a branch,
   * and if so, perform branch with consecutive pipeline flush.
   * memory determines whether the function is called from the memory or from
   * execute stage. Depending on the flag only normal branches (execute) or
   * loads to the pc (memory) are performed.
   */
  StateSet checkForBranches(InstrContextMapping &ins2ctx, bool memory);

  // proceeding the decode stage
  void processInstructionDecodeStage();

  // proceeding the fetch stage
  void processInstructionFetchStage();

  // join-ability check that leaves out the memory topology
  virtual bool isJoinableUpToMemory(const InOrderPipelineState &ds) const;

  /**
   * Helper function that tries to fast-forward an abstract
   * state before putting it into a state set.
   */
  void fastForwardAndInsert(const InOrderPipelineState &ooops,
                            StateSet &successors
#ifdef AUTO_CONVERGENCE_DETECTION
                            ,
                            ConvergenceType &soFarDetectedConvergence
#endif
  ) const;

  /**
   * The execution elements (aka instructions) that are currently in the
   * pipeline.
   */
  boost::optional<ExecutionElement> inflightInstruction[5];
  /**
   * The time remaining until the current element in the execution stage (\see
   * inflightInstruction) is fully executed. This can be variable-latency.
   */
  std::set<unsigned> remainingExecutionTimes;

  /**
   * A flag indicating whether the memory has to stall, because an access is not
   * yet finished.
   */
  bool stallMemory;

  /**
   * A flag indicating whether the memory stage causes an interlock in the
   * execution stage, meaning that there is data which is not yet ready.
   */
  bool interlock;

  /**
   * A flag indicating that if and id stages were flushedFetchStage in this
   * state. Blocks processing of these stages.
   */
  bool flushedFetchStage;

  /**
   * Some attached memory which is accessed for data.
   */
  MemoryTopology memory;

  /**
   * Temporary storage of the accessId for the instruction access
   * There can only be one instruction access at a time.
   */
  boost::optional<unsigned> instructionAccessId;

  /**
   * Temporary flag which represents a register after the fetch stage for the
   * instruction, when the decode stage is still full.
   */
  bool instructionAccessFinished;

  /**
   * Temporary storage of a memory access index of an instruction
   * Used for load/store multiple to keep track of the current access index
   * being executed.
   */
  unsigned currMemoryAccess;

  /**
   * Temporary storage of accessIds for all accesses from the memory
   * instruction. In case of a load/store multiple, this is more than one
   * access.
   */
  std::map<unsigned, unsigned> dataAccessIds;
};

template <class MemoryTopology>
InOrderPipelineState<MemoryTopology>::InOrderPipelineState(ProgramLocation &pl)
    : SuperClass(pl), remainingExecutionTimes(), stallMemory(false),
      interlock(false), flushedFetchStage(false),
      instructionAccessFinished(false), currMemoryAccess(0) {
  initExecutionTimesMap();

  for (int i = 0; i < NUMBEROFSTAGES; ++i) {
    inflightInstruction[i] = boost::none;
  }

  // Make pc available for memory topology to get the first instruction
  instructionAccessId = memory.accessInstr(this->pc.getPc().first, 1);
}

template <class MemoryTopology>
InOrderPipelineState<MemoryTopology>::InOrderPipelineState(
    const InOrderPipelineState &iops)
    : SuperClass(iops), remainingExecutionTimes(iops.remainingExecutionTimes),
      // the booleans are internal for each state
      stallMemory(iops.stallMemory), interlock(iops.interlock),
      flushedFetchStage(iops.flushedFetchStage), memory(iops.memory),
      instructionAccessId(iops.instructionAccessId),
      instructionAccessFinished(iops.instructionAccessFinished),
      currMemoryAccess(iops.currMemoryAccess),
      dataAccessIds(iops.dataAccessIds) {
  int i;
  for (i = 0; i < NUMBEROFSTAGES; i++) {
    inflightInstruction[i] = iops.inflightInstruction[i];
  }
}

template <class MemoryTopology>
InOrderPipelineState<MemoryTopology>::~InOrderPipelineState() {}

template <class MemoryTopology>
void InOrderPipelineState<MemoryTopology>::initExecutionTimesMap() {
  // Fill execution time map
  if (instructionExecutionTimes.size() == 0) {
    auto arch =
        TimingAnalysisMain::getTargetMachine().getTargetTriple().getArch();
    if (arch == Triple::ArchType::arm) {
      instructionExecutionTimes =
#if (IOEXECUTIONLATENCY == 2) // two cycles each
#include "MicroarchitecturalAnalysis/ExecutionLatencies/Arm/TwoCyclesLatencies.def"
#elif (IOEXECUTIONLATENCY == 1) // one cycle each
#include "MicroarchitecturalAnalysis/ExecutionLatencies/Arm/OneCycleLatencies.def"
#elif (IOEXECUTIONLATENCY == 0) // variable-latency instructions
#include "MicroarchitecturalAnalysis/ExecutionLatencies/Arm/VariableInorderLatencies.def"
#else
#error Unsupported execution latencies.
#endif
          ;
    } else {
      assert(arch == Triple::ArchType::riscv32);
      instructionExecutionTimes =
#if (IOEXECUTIONLATENCY == 2) // two cycles each
#include "MicroarchitecturalAnalysis/ExecutionLatencies/Riscv/TwoCyclesLatencies.def"
#elif (IOEXECUTIONLATENCY == 1) // one cycle each
#include "MicroarchitecturalAnalysis/ExecutionLatencies/Riscv/OneCycleLatencies.def"
#elif (IOEXECUTIONLATENCY == 0) // variable-latency instructions
#include "MicroarchitecturalAnalysis/ExecutionLatencies/Riscv/VariableInorderLatencies.def"
#else
#error Unsupported execution latencies.
#endif
          ;
    }
  }
}

template <class MemoryTopology>
typename InOrderPipelineState<MemoryTopology>::StateSet
InOrderPipelineState<MemoryTopology>::cycle(
    std::tuple<InstrContextMapping &, AddressInformation &> &dep) const {

  // Copy this state for the successor
  InOrderPipelineState succ(*this);

  // Reset flags that only apply for one state
  succ.stallMemory = false;
  succ.interlock = false;

  // Increment the base time counter for the successor state
  ++succ.time;

  // result set for this cycle method
  StateSet res;

#ifdef AUTO_CONVERGENCE_DETECTION
  ConvergenceType soFarDetectedConvergence = POTENTIALLY_NOT_CONVERGED;
#endif

  for (auto &iopsSucc : succ.cycleMemoryTopology()) {
    // assert cleared final stage
    assert(iopsSucc.inflightInstruction[WB_FIN_IND] == boost::none &&
           "Final should be cleared");

    if (iopsSucc.memory.shouldPipelineStall()) {
      fastForwardAndInsert(iopsSucc, res
#ifdef AUTO_CONVERGENCE_DETECTION
                           ,
                           soFarDetectedConvergence
#endif
      );
    } else {
      // process Pipeline stages
      iopsSucc.processWriteBackStage();

      for (auto &iopsMemSucc : iopsSucc.processMemoryStage(dep)) {
        for (auto &iopsExecSucc : iopsMemSucc.processExecuteStage(dep)) {
          InOrderPipelineState copy(iopsExecSucc);
          copy.processInstructionDecodeStage();

          copy.processInstructionFetchStage();

          fastForwardAndInsert(copy, res
#ifdef AUTO_CONVERGENCE_DETECTION
                               ,
                               soFarDetectedConvergence
#endif
          );
        }
      }
    }
  }

  DEBUG_WITH_TYPE(
      "driverSED", for (auto &succ
                        : res) { std::cerr << succ; });
  return res;
}

template <class MemoryTopology>
void InOrderPipelineState<MemoryTopology>::fastForwardAndInsert(
    const InOrderPipelineState<MemoryTopology> &iops, StateSet &successors
#ifdef AUTO_CONVERGENCE_DETECTION
    ,
    ConvergenceType &soFarDetectedConvergence
#endif
) const {
#ifdef AUTO_CONVERGENCE_DETECTION
  // auto detect the convergence
  ConvergenceType succConverged =
      iops.isConvergedAfterCycleFrom(*this, soFarDetectedConvergence);
  if (succConverged != POTENTIALLY_NOT_CONVERGED) {
    if (soFarDetectedConvergence == POTENTIALLY_NOT_CONVERGED ||
        (soFarDetectedConvergence == CONVERGED_UNTIL_ANY_MEMORY_NON_BUSY &&
         succConverged != CONVERGED_UNTIL_ANY_MEMORY_NON_BUSY)) {
      soFarDetectedConvergence = succConverged;
    }
    assert(
        !(succConverged == CONVERGED_UNTIL_INSTR_MEMORY_NON_BUSY &&
          soFarDetectedConvergence == CONVERGED_UNTIL_DATA_MEMORY_NON_BUSY) &&
        "Inconsistent convergence situation.");
    assert(
        !(succConverged == CONVERGED_UNTIL_DATA_MEMORY_NON_BUSY &&
          soFarDetectedConvergence == CONVERGED_UNTIL_INSTR_MEMORY_NON_BUSY) &&
        "Inconsistent convergence situation.");
  }
#else
  ConvergenceType succConverged = iops.getConvergenceType();
#endif

  // trigger the actual fast-forwarding at
  // the memory topology
  if (succConverged != POTENTIALLY_NOT_CONVERGED) {
    for (auto &forwardedInnerMem : iops.memory.fastForward()) {
      InOrderPipelineState copy(iops);
      copy.memory = forwardedInnerMem;
      successors.insert(copy);
    }
  }

  // insert unchanged into the successor stateset
  else {
    successors.insert(iops);
  }
}

template <class MemoryTopology>
bool InOrderPipelineState<MemoryTopology>::isFinal(ExecutionElement &ee) {
  if (StaticAddrProvider->goesExternal(ee.first)) {
    return !this->inflightInstruction[WB_FIN_IND] &&
           !this->inflightInstruction[MEM_WB_IND] &&
           !this->inflightInstruction[EX_MEM_IND] &&
           !this->inflightInstruction[ID_EX_IND] &&
           !this->inflightInstruction[IF_ID_IND] &&
           !memory.hasUnfinishedAccesses();
  }
  assert(StaticAddrProvider->hasMachineInstrByAddr(ee.first) &&
         "isFinal asked for some unknown address.");
  // If we do not have an inflight-instruction in the final stage, we cannot be
  // final
  if (!this->inflightInstruction[WB_FIN_IND]) {
    return false;
  }
  // If we have an inflight element in the final stage, we are final if
  // * inflight[final_index] == pl
  auto x = this->inflightInstruction[WB_FIN_IND].get();
  bool isfinal = ee.first == x.first && ee.second == x.second;
  if (isfinal) { // If it really is final, then we don't need it anymore
    this->inflightInstruction[WB_FIN_IND] = boost::none;
  }
  return isfinal;
}

template <class MemoryTopology>
bool InOrderPipelineState<MemoryTopology>::operator==(
    const InOrderPipelineState &ds) const {
  bool result =
      SuperClass::operator==(ds) &&
      this->inflightInstruction[IF_ID_IND] ==
          ds.inflightInstruction[IF_ID_IND] &&
      this->inflightInstruction[ID_EX_IND] ==
          ds.inflightInstruction[ID_EX_IND] &&
      this->inflightInstruction[EX_MEM_IND] ==
          ds.inflightInstruction[EX_MEM_IND] &&
      this->inflightInstruction[MEM_WB_IND] ==
          ds.inflightInstruction[MEM_WB_IND] &&
      this->inflightInstruction[WB_FIN_IND] ==
          ds.inflightInstruction[WB_FIN_IND] &&
      this->remainingExecutionTimes == ds.remainingExecutionTimes &&
      this->flushedFetchStage == ds.flushedFetchStage &&
      this->stallMemory == ds.stallMemory && this->interlock == ds.interlock &&
      this->instructionAccessFinished == ds.instructionAccessFinished &&
      this->currMemoryAccess == ds.currMemoryAccess &&
      this->memory == ds.memory;
  return result;
}

#ifdef AUTO_CONVERGENCE_DETECTION
template <class MemoryTopology>
ConvergenceType InOrderPipelineState<MemoryTopology>::isConvergedAfterCycleFrom(
    const InOrderPipelineState<MemoryTopology> &origin,
    ConvergenceType convergenceTypeOfSibling) const {
  assert(this->time.isJoinable(origin.time) &&
         "We can only effectively use isJoinableUpToMemory here if the "
         "join-ability bool flag of the interval counter behind time is true!");
  // MJa: if this assert fails, the following value of converged
  // would be guaranteed to always be false. That means we would
  // disable all forwarding. If one ever should want to disable
  // the joining of time counters, one should implement a custom
  // variant of isJoinable in MicroArchitecturalState that leaves
  // out time from the comparison...
  const bool converged = isJoinableUpToMemory(origin);

  // read out the port busy states of
  // the memory topology
  const bool instrPortBusy = memory.isBusyAccessingInstr();
  const bool dataPortBusy = memory.isBusyAccessingData();

  if (converged && !UnblockStores) {
    // find out the convergence type as precise as possible:

    // intuitively, converged should only be true
    // if at least one of the memories (instr or data)
    // is busy:
    // MJa: However, in the corner case that the pipeline
    // is empty, it might also be detected as converged
    // if the memory topology is not busy at any of its
    // ports (e.g. in combination with unblocking stores)
    const bool cornerCase = !this->inflightInstruction[WB_FIN_IND] &&
                            !this->inflightInstruction[MEM_WB_IND] &&
                            !this->inflightInstruction[EX_MEM_IND] &&
                            !this->inflightInstruction[ID_EX_IND] &&
                            !this->inflightInstruction[IF_ID_IND];
    assert(instrPortBusy || dataPortBusy || cornerCase);

    // only instruction memory is busy
    if (!dataPortBusy) {
      return CONVERGED_UNTIL_INSTR_MEMORY_NON_BUSY;
    }

    // only data memory is busy
    if (!instrPortBusy) {
      return CONVERGED_UNTIL_DATA_MEMORY_NON_BUSY;
    }

    // here we have guaranteed: !instructionAccessFinished && stallMemory
    // or the corner case of an empty pipeline...
    return CONVERGED_UNTIL_ANY_MEMORY_NON_BUSY;
  } else if (converged) { // With UnblockStores you cannot distinguish the
                          // active port
    return CONVERGED_UNTIL_ANY_MEMORY_NON_BUSY;
  }

  return POTENTIALLY_NOT_CONVERGED;
}
#endif

template <class Mem>
std::ostream &operator<<(std::ostream &stream,
                         const InOrderPipelineState<Mem> &iops) {
  auto &base = (const MicroArchitecturalState<
                InOrderPipelineState<Mem>,
                typename InOrderPipelineState<Mem>::StateDep> &)iops;
  stream << base << "\n";
  stream << "Fetching instruction: "
         << (iops.instructionAccessFinished ? "No" : "Yes") << "\n";
  if (iops.flushedFetchStage) {
    stream << "Fetch stage was flushed.\n";
  }
  stream << "[ IF/ID stage: ";
  if (iops.inflightInstruction[IF_ID_IND]) {
    stream << iops.inflightInstruction[IF_ID_IND].get();
  } else {
    stream << "None";
  }
  stream << "\n| ID/EX stage: ";
  if (iops.inflightInstruction[ID_EX_IND]) {
    stream << iops.inflightInstruction[ID_EX_IND].get();
  } else {
    stream << "None";
  }
  stream << " | Completes execution stage in {";
  bool emitComma = false;
  for (auto extime : iops.remainingExecutionTimes) {
    if (emitComma) {
      stream << ", ";
    }
    stream << extime;
    emitComma = true;
  }
  stream << "}\n";
  stream << "| EX/MEM Stage: ";
  if (iops.inflightInstruction[EX_MEM_IND]) {
    stream << iops.inflightInstruction[EX_MEM_IND].get();
  } else {
    stream << "None";
  }
  stream << "\n| MEM/WB stage: ";
  if (iops.inflightInstruction[MEM_WB_IND]) {
    stream << iops.inflightInstruction[MEM_WB_IND].get();
  } else {
    stream << "None";
  }
  if (iops.stallMemory) {
    stream << " | Completes memory stage in this cycle ";
  } else {
    stream << " | Waiting for an access to finish ";
  }
  stream << "\n  Current memory access: " << iops.currMemoryAccess;
  stream << "\n| WB/Finalized instruction: ";
  if (iops.inflightInstruction[WB_FIN_IND]) {
    stream << iops.inflightInstruction[WB_FIN_IND].get();
  } else {
    stream << "None";
  }
  stream << "]\n";
  stream << iops.memory;
  return stream;
}

// TODO include new values here
template <class MemoryTopology>
size_t InOrderPipelineState<MemoryTopology>::hashcode() const {
  // Initial hash by superclass
  size_t val = SuperClass::hashcode();
  for (auto exTime : this->remainingExecutionTimes) {
    hash_combine(val, exTime);
  }
  int i;
  for (i = 0; i < NUMBEROFSTAGES; i++) {
    if (this->inflightInstruction[i]) {
      auto x = this->inflightInstruction[i].get();
      /*hash_combine(val, x.first);
      hash_combine(val, x.second);*/
      hash_combine(val, x);
    }
  }
  hash_combine_hashcode(val, this->memory);
  return val;
}

template <class MemoryTopology>
bool InOrderPipelineState<MemoryTopology>::isJoinable(
    const InOrderPipelineState &ds) const {
  return isJoinableUpToMemory(ds) && memory.isJoinable(ds.memory);
}

template <class MemoryTopology>
bool InOrderPipelineState<MemoryTopology>::isJoinableUpToMemory(
    const InOrderPipelineState &ds) const {
  return SuperClass::isJoinable(ds) &&
         remainingExecutionTimes == ds.remainingExecutionTimes &&
         stallMemory == ds.stallMemory &&
         inflightInstruction[IF_ID_IND] == ds.inflightInstruction[IF_ID_IND] &&
         inflightInstruction[ID_EX_IND] == ds.inflightInstruction[ID_EX_IND] &&
         inflightInstruction[EX_MEM_IND] ==
             ds.inflightInstruction[EX_MEM_IND] &&
         inflightInstruction[MEM_WB_IND] ==
             ds.inflightInstruction[MEM_WB_IND] &&
         inflightInstruction[WB_FIN_IND] ==
             ds.inflightInstruction[WB_FIN_IND] &&
         interlock == ds.interlock &&
         flushedFetchStage == ds.flushedFetchStage &&
         instructionAccessFinished == ds.instructionAccessFinished &&
         currMemoryAccess == ds.currMemoryAccess;
  // instructionAccessId and dataAccessIds are checked for joinable by memory
}

template <class MemoryTopology>
void InOrderPipelineState<MemoryTopology>::join(
    const InOrderPipelineState &ds) {
  // Safety check
  assert(isJoinable(ds) && "Cannot join non-joinable states.");

  SuperClass::join(ds);
  memory.join(ds.memory);

  // The following statements should hold by joinability of the memory. But
  // check them explicitly here again.
  assert(((instructionAccessId && ds.instructionAccessId) ||
          (!instructionAccessId && !ds.instructionAccessId)) &&
         "Not considered joinable.");
  assert(dataAccessIds.size() == ds.dataAccessIds.size() &&
         "Maps of unequal size are not considered joinable.");

  // Everything id related is just kept, as it is equal (relative to the
  // absolute id) anyway. Note that this makes the join non-symmetric w.r.t.
  // absolute id's but symmetric to relative id's.
}

/**
 * Accesses Memory Topology.
 */
template <class MemoryTopology>
void InOrderPipelineState<MemoryTopology>::accessDataFromMemoryTopology(
    AddressInformation &addrInfo) {
  // access data memory with next address from memory instruction
  assert(this->inflightInstruction[EX_MEM_IND] && "No instruction in EX_MEM!");
  auto currMemInst = StaticAddrProvider->getMachineInstrByAddr(
      this->inflightInstruction[EX_MEM_IND].get().first);
  if (currMemInst->mayLoad() || currMemInst->mayStore()) {
    unsigned numDataAccesses = addrInfo.getNumOfDataAccesses(currMemInst);
    if (currMemoryAccess < numDataAccesses) {
      auto currCtx = inflightInstruction[EX_MEM_IND].get().second;
      AccessType at;
      if (currMemInst->mayLoad()) { //|| isPrefetch(currMemInst)){
        // TODO this might be a bit too simplistic
        // TODO Prefetch instructions are all marked with load and store but
        // only PLDW should do both.
        at = AccessType::LOAD;
      } else {
        at = AccessType::STORE;
      }
      AbstractAddress addrItv = addrInfo.getDataAccessAddress(
          currMemInst, &currCtx, currMemoryAccess);
      boost::optional<unsigned> dataAccess = memory.accessData(addrItv, at, 1);
      assert(dataAccess &&
             "Data access could not be processed by the memory topology!");
      if (dataAccess) {
        dataAccessIds.insert(
            std::pair<unsigned, unsigned>(currMemoryAccess, *dataAccess));
        currMemoryAccess++;
      }
    }
  }
}

template <class MemoryTopology>
std::list<InOrderPipelineState<MemoryTopology>>
InOrderPipelineState<MemoryTopology>::cycleMemoryTopology() {
  bool potentialDataMissesPending = false;
  // If strictly in-order data und instr arbitration demanded, check for pending
  // potential misses
  if (enableStrictInorderDataInstrArbitration()) {
    if (this->inflightInstruction[IF_ID_IND]) {
      if (StaticAddrProvider->hasMachineInstrByAddr(
              this->inflightInstruction[IF_ID_IND].get().first)) {
        auto decodeInstr = StaticAddrProvider->getMachineInstrByAddr(
            this->inflightInstruction[IF_ID_IND].get().first);
        potentialDataMissesPending |=
            (decodeInstr->mayLoad() || decodeInstr->mayStore());
      } else {
        potentialDataMissesPending = true;
      }
    }
    if (this->inflightInstruction[ID_EX_IND]) {
      auto executeInstr = StaticAddrProvider->getMachineInstrByAddr(
          this->inflightInstruction[ID_EX_IND].get().first);
      potentialDataMissesPending |=
          (executeInstr->mayLoad() || executeInstr->mayStore());
    }
    if (this->inflightInstruction[EX_MEM_IND]) {
      auto memoryInstr = StaticAddrProvider->getMachineInstrByAddr(
          this->inflightInstruction[EX_MEM_IND].get().first);
      if (memoryInstr->mayLoad() || memoryInstr->mayStore()) {
        if (dataAccessIds.size() > 0 &&
            !memory.finishedDataAccess(std::begin(dataAccessIds)->second)) {
          potentialDataMissesPending = true;
        }
      }
    }
  }
  std::list<MemoryTopology> res = memory.cycle(potentialDataMissesPending);
  std::list<InOrderPipelineState<MemoryTopology>> resultList;
  for (auto &mt : res) {
    InOrderPipelineState<MemoryTopology> iops(*this);
    iops.memory = mt;
    resultList.push_back(iops);
  }
  return resultList;
}

/**
 * This function "flushes" any result from instruction fetch and instruction
 * decode stage
 */
template <class MemoryTopology>
void InOrderPipelineState<MemoryTopology>::emptyPipelineDueToBranching(
    unsigned oldPc) {
  if (needPersistenceScopes()) {
    // Do (speculative) persistence scope handling
    if (instructionAccessId ||
        instructionAccessFinished) { // We were accessing oldPc
      // Calculate the address in the next populated stage
      int nextPopulatedStage = IF_ID_IND;
      while (nextPopulatedStage < NUMBEROFSTAGES &&
             !inflightInstruction[nextPopulatedStage]) {
        ++nextPopulatedStage;
      }
      assert(nextPopulatedStage < NUMBEROFSTAGES &&
             "We flush pipe but have no flushing instr?");
      auto nextaddr = inflightInstruction[nextPopulatedStage].get().first;
      if (StaticAddrProvider->hasMachineInstrByAddr(oldPc) &&
          StaticAddrProvider->hasMachineInstrByAddr(nextaddr)) {
        auto fetchinstr = StaticAddrProvider->getMachineInstrByAddr(oldPc);
        auto nextinstr = StaticAddrProvider->getMachineInstrByAddr(nextaddr);
        auto edge =
            std::make_pair(nextinstr->getParent(), fetchinstr->getParent());
        if (edge.first != edge.second &&
            PersistenceScopeInfo::getInfo().entersScope(edge)) {
          for (auto scope :
               PersistenceScopeInfo::getInfo().getEnteringScopes(edge)) {
            DEBUG_WITH_TYPE(
                "persistence",
                dbgs() << "We are going to leave a scope due to speculation: "
                       << scope.getId() << "\n");
            memory.leaveScope(scope);
          }
        }
      }
    }

    if (inflightInstruction[IF_ID_IND]) {
      auto fetchaddr = inflightInstruction[IF_ID_IND].get().first;
      // Calculate the address in the next populated stage
      int nextPopulatedStage = ID_EX_IND;
      while (nextPopulatedStage < NUMBEROFSTAGES &&
             !inflightInstruction[nextPopulatedStage]) {
        ++nextPopulatedStage;
      }
      assert(nextPopulatedStage < NUMBEROFSTAGES &&
             "We flush pipe but have no flushing instr?");
      auto nextaddr = inflightInstruction[nextPopulatedStage].get().first;
      if (StaticAddrProvider->hasMachineInstrByAddr(fetchaddr) &&
          StaticAddrProvider->hasMachineInstrByAddr(nextaddr)) {
        auto fetchinstr = StaticAddrProvider->getMachineInstrByAddr(fetchaddr);
        auto nextinstr = StaticAddrProvider->getMachineInstrByAddr(nextaddr);
        auto edge =
            std::make_pair(nextinstr->getParent(), fetchinstr->getParent());
        if (edge.first != edge.second &&
            PersistenceScopeInfo::getInfo().entersScope(edge)) {
          for (auto scope :
               PersistenceScopeInfo::getInfo().getEnteringScopes(edge)) {
            DEBUG_WITH_TYPE(
                "persistence",
                dbgs() << "We are going to leave a scope due to speculation: "
                       << scope.getId() << "\n");
            memory.leaveScope(scope);
          }
        }
      }
    }
  }

  // Do flushing itself
  flushedFetchStage = true;
  inflightInstruction[IF_ID_IND] = boost::none;
}

/**
 * This function represents all processing done in the write back stage.
 * The resulting instruction will be stored to be able to answer which
 * instruction was finished. Input: MEM_WB_IND instruction, output: WB_FIN_IND
 */
template <class MemoryTopology>
void InOrderPipelineState<MemoryTopology>::processWriteBackStage() {
  // if there is an input instruction for this stage
  if (this->inflightInstruction[MEM_WB_IND]) {
    inflightInstruction[WB_FIN_IND] = inflightInstruction[MEM_WB_IND];
    inflightInstruction[MEM_WB_IND] = boost::none;

    if (needPersistenceScopes()) {
      // Do persistence scope handling
      auto compladdr = inflightInstruction[WB_FIN_IND].get().first;
      // Calculate the address in the next populated stage
      int nextPopulatedStage = EX_MEM_IND;
      while (nextPopulatedStage >= 0 &&
             !inflightInstruction[nextPopulatedStage]) {
        --nextPopulatedStage;
      }
      auto nextaddr = nextPopulatedStage >= 0
                          ? inflightInstruction[nextPopulatedStage].get().first
                          : this->pc.getPc().first;
      if (StaticAddrProvider->hasMachineInstrByAddr(compladdr) &&
          StaticAddrProvider->hasMachineInstrByAddr(nextaddr)) {
        auto complinstr = StaticAddrProvider->getMachineInstrByAddr(compladdr);
        auto nextinstr = StaticAddrProvider->getMachineInstrByAddr(nextaddr);
        auto edge =
            std::make_pair(complinstr->getParent(), nextinstr->getParent());
        if (edge.first != edge.second &&
            PersistenceScopeInfo::getInfo().leavesScope(edge)) {
          for (auto scope :
               PersistenceScopeInfo::getInfo().getLeavingScopes(edge)) {
            DEBUG_WITH_TYPE("persistence",
                            dbgs() << "(BB" << edge.first->getNumber() << ", BB"
                                   << edge.second->getNumber() << ") "
                                   << "We are going to leave a scope: "
                                   << scope.getId() << "\n");
            memory.leaveScope(scope);
          }
        }
      }
    }
  }
}

template <class MemoryTopology>
std::list<InOrderPipelineState<MemoryTopology>>
InOrderPipelineState<MemoryTopology>::processMemoryStage(
    std::tuple<InstrContextMapping &, AddressInformation &> &dep) const {
  std::list<InOrderPipelineState> result;

  // Successor state
  InOrderPipelineState succ(*this);

  // Get components of dependencies
  AddressInformation &addrInfo = std::get<1>(dep);
  auto &ins2ctx = std::get<0>(dep);

  // make sure there is something to process
  if (succ.inflightInstruction[EX_MEM_IND]) {
    auto currMemInst = StaticAddrProvider->getMachineInstrByAddr(
        succ.inflightInstruction[EX_MEM_IND].get().first);
    // in case of loads and stores, we need to finish the accesses first
    if (currMemInst->mayLoad() || currMemInst->mayStore()) {
      succ.stallMemory = true;
      auto access = std::begin(succ.dataAccessIds);
      while (access != std::end(succ.dataAccessIds)) {
        if (succ.memory.finishedDataAccess(access->second)) {
          access = succ.dataAccessIds.erase(access);
          succ.accessDataFromMemoryTopology(addrInfo);
        } else {
          ++access;
        }
      }
      unsigned numDataAccesses = addrInfo.getNumOfDataAccesses(currMemInst);
      // if the whole list is processed, and there are no accesses left, finish
      // the instruction
      if (succ.currMemoryAccess >= numDataAccesses &&
          succ.dataAccessIds.empty()) {
        // all accesses finished
        succ.stallMemory = false;
      }
    }
    if (!succ.stallMemory) {
      // check whether the following stage is free
      if (!succ.inflightInstruction[MEM_WB_IND]) {
        succ.interlock = false;
        auto currMemInst = StaticAddrProvider->getMachineInstrByAddr(
            succ.inflightInstruction[EX_MEM_IND].get().first);
        if (currMemInst->mayLoad()) {
          auto storedOperand = currMemInst->getOperand(0);
          // If target operand is a register (actually should always be for a
          // load), check whether there is a hazard and delay execute stage once
          if (storedOperand.isReg()) {
            // Check whether the next instruction uses exactly this register
            if (succ.inflightInstruction[ID_EX_IND]) {
              auto execInstr = StaticAddrProvider->getMachineInstrByAddr(
                  succ.inflightInstruction[ID_EX_IND].get().first);
              // Alternative: auto regInfo =
              // execInstr->getParent()->getParent()->getRegInfo().getTargetRegisterInfo();
              auto regInfo = execInstr->getParent()
                                 ->getParent()
                                 ->getSubtarget()
                                 .getRegisterInfo();
              if (execInstr->readsRegister(storedOperand.getReg(), regInfo)) {
                succ.interlock = true;
              }
            }
          }
        }
        // Move on to next stage:
        succ.inflightInstruction[MEM_WB_IND] =
            succ.inflightInstruction[EX_MEM_IND];

        // Check for branches by load to pc, will use inflight instruction at
        // EX_MEM
        StateSet branch_res = succ.checkForBranches(ins2ctx, true);
        // Clear current stage
        for (auto &altsucc : branch_res) {
          InOrderPipelineState succ_copy(altsucc);
          succ_copy.inflightInstruction[EX_MEM_IND] = boost::none;
          result.push_back(succ_copy);
        }
        succ.inflightInstruction[EX_MEM_IND] = boost::none;
      }
    }
  }

  // Successor state is always returned
  result.push_back(succ);
  return result;
}

/**
 * Process execution of an instruction.
 */
template <class MemoryTopology>
std::list<InOrderPipelineState<MemoryTopology>>
InOrderPipelineState<MemoryTopology>::processExecuteStage(
    std::tuple<InstrContextMapping &, AddressInformation &> &dep) const {
  std::list<InOrderPipelineState> result;

  // check whether there is an instruction and whether any data dependencies are
  // not ready yet
  if (inflightInstruction[ID_EX_IND] && !interlock) {
    bool couldFinish = false;
    std::set<unsigned> newRemExecTime;
    assert(remainingExecutionTimes.size() > 0 &&
           "Non-empty EX stage needs exec times");
    for (auto exTime : remainingExecutionTimes) {
      if (exTime == 0 ||
          exTime == 1) { // Already finished last cycle or will this cycle
        couldFinish = true;
      } else {
        --exTime;
        newRemExecTime.insert(exTime);
      }
    }
    assert((couldFinish || newRemExecTime.size() > 0) &&
           "No successor on execution?");

    if (couldFinish) { // The instruction could finish
      if (!(StaticAddrProvider->hasMachineInstrByAddr(
              this->inflightInstruction[ID_EX_IND].get().first))) {
        // this code will be executed when the pipeline runs empty at the end of
        // a program
        Context ctx = inflightInstruction[ID_EX_IND].get().second;
        assert(ctx.isEmpty() &&
               "No Machine Instruction for address, but context available");
        InOrderPipelineState succ(*this);
        succ.inflightInstruction[ID_EX_IND] = boost::none;
        succ.remainingExecutionTimes.clear();
        result.push_back(succ);
      } else {
        // advance to memory stage here if possible
        if (!this->inflightInstruction[EX_MEM_IND]) {
          InOrderPipelineState succ(*this);

          succ.inflightInstruction[EX_MEM_IND] =
              succ.inflightInstruction[ID_EX_IND];
          // initialize the next stage
          succ.dataAccessIds.clear();
          succ.currMemoryAccess = 0;

          AddressInformation &addrInfo = std::get<1>(dep);
          // prepare memory accesses
          succ.accessDataFromMemoryTopology(addrInfo);
          // TODO this can cause splits!

          auto &ins2ctx = std::get<0>(dep);
          StateSet temp_res = succ.checkForBranches(ins2ctx, false);
          // clear for processing the decoding stage
          for (auto &altsucc : temp_res) {
            InOrderPipelineState succ_copy(altsucc);
            succ_copy.inflightInstruction[ID_EX_IND] = boost::none;
            succ_copy.remainingExecutionTimes.clear();
            result.push_back(succ_copy);
          }
          succ.inflightInstruction[ID_EX_IND] = boost::none;
          succ.remainingExecutionTimes.clear();
          result.push_back(succ);
        } else { // Must wait for MEMORY to empty
          InOrderPipelineState succ(*this);
          succ.remainingExecutionTimes.clear();
          succ.remainingExecutionTimes.insert(0);
          result.push_back(succ);
        }
      }
    }
    // The instruction could still remain in the pipeline for longer
    if (newRemExecTime.size() > 0) {
      InOrderPipelineState succ(*this);
      succ.remainingExecutionTimes.clear();
      succ.remainingExecutionTimes.insert(newRemExecTime.begin(),
                                          newRemExecTime.end());
      result.push_back(succ);
    }
  } else { // We have an interlock or empty pipe, do nothing
    assert((inflightInstruction[ID_EX_IND] ||
            remainingExecutionTimes.size() == 0) &&
           "Exec times despite empty?");
    result.push_back(*this);
  }
  // All successor states
  return result;
}

// this is called from processExecuteStage
template <class MemoryTopology>
typename InOrderPipelineState<MemoryTopology>::StateSet
InOrderPipelineState<MemoryTopology>::checkForBranches(
    InstrContextMapping &ins2ctx, bool memory) {
  StateSet res;
  // check whether branching happens and alter the
  if (StaticAddrProvider->hasMachineInstrByAddr(
          inflightInstruction[memory ? EX_MEM_IND : ID_EX_IND].get().first)) {
    auto exInstr = StaticAddrProvider->getMachineInstrByAddr(
        inflightInstruction[memory ? EX_MEM_IND : ID_EX_IND].get().first);
    if (exInstr->isBranch() || exInstr->isCall() || exInstr->isReturn()) {
      // Skip branches that load to the pc in execute stage as they happen later
      if (!memory && exInstr->mayLoad()) {
        assert(TimingAnalysisMain::getTargetMachine()
                   .getTargetTriple()
                   .getArch() == Triple::ArchType::arm);
        assert((exInstr->getOpcode() == ARM::BR_JTm_rs ||
                exInstr->getOpcode() == ARM::BR_JTm_i12 ||
                exInstr->getOpcode() == ARM::LDMIA_RET) &&
               "Unexpected opcode");
        return res;
      }
      // Skip normal branches in memory stage as they happened already
      if (memory && !exInstr->mayLoad()) {
        return res;
      }
      unsigned oldPc = this->pc.getPc().first;
      auto alternativeSucc = this->handleBranching(
          inflightInstruction[memory ? EX_MEM_IND : ID_EX_IND].get(), ins2ctx);
      // for all branch operations, empty the pipeline
      // if memory, always check that ID_EX is empty becuase flush won't empty
      // it
      assert((!memory || !inflightInstruction[ID_EX_IND]) &&
             "Internal: Should be empty");
      emptyPipelineDueToBranching(oldPc);
#if 0
			// The following code might become relevant once the pipeline continues fetching on predicated returns
			// for predicated return in no-taken case, no need to flush if the pipeline kept on running
			if (!(exInstr->isReturn() && isPredicated(exInstr))) {
				assert ((!memory || !inflightInstruction[ID_EX_IND]) && "Internal: Should be empty");
				emptyPipelineDueToBranching(oldPc);
			}
#endif
      // if we have a return or a jumptable branch, also empty the pipeline for
      // all successor states and add them to the result
      if (exInstr->isReturn() || isJumpTableBranch(exInstr)) {
        for (auto altSucc = alternativeSucc.begin();
             altSucc != alternativeSucc.end(); ++altSucc) {
          InOrderPipelineState copy(*altSucc);
          assert((!memory || !copy.inflightInstruction[ID_EX_IND]) &&
                 "Internal: Should be empty");
          copy.emptyPipelineDueToBranching(oldPc);
          res.insert(copy);
        }
      } else if (MuArchType == MicroArchitecturalType::STRICTINORDER) {
        for (auto altSucc = alternativeSucc.begin();
             altSucc != alternativeSucc.end(); ++altSucc) {
          InOrderPipelineState copy(*altSucc);
          copy.instructionAccessId =
              copy.memory.accessInstr(copy.pc.getPc().first, 1);
          res.insert(copy);
        }
      } else {
        // add alternative successors to the result set
        res.insert(alternativeSucc.begin(), alternativeSucc.end());
      }
    }
  }
  return res;
}

/**
 * Decodes an instruction and puts it ready for the execution stage
 * Input: IF_ID_IND, Output: ID_EX_IND
 */
template <class MemoryTopology>
void InOrderPipelineState<MemoryTopology>::processInstructionDecodeStage() {
  if (this->inflightInstruction[IF_ID_IND] &&
      (!inflightInstruction[ID_EX_IND])) {
    // check for flush is implicitly here already
    if (StaticAddrProvider->hasMachineInstrByAddr(
            this->inflightInstruction[IF_ID_IND].get().first)) {
      // check that it is actually an instruction (not the end of the program
      inflightInstruction[ID_EX_IND] = inflightInstruction[IF_ID_IND];

      // TODO determine the remaining execution time here! - (mb put it in an
      // extra function)
      const MachineInstr *mi = StaticAddrProvider->getMachineInstrByAddr(
          this->inflightInstruction[IF_ID_IND].get().first);
      DEBUG_WITH_TYPE("missingexeclat", dbgs() << *mi << "\n");
      if (instructionExecutionTimes.count(mi->getOpcode()) == 0) {
        errs() << "MachineInstr:" << *mi;
      }

      assert(instructionExecutionTimes.count(mi->getOpcode()) > 0 &&
             "No timing for execution stage for some instruction.");
      remainingExecutionTimes = instructionExecutionTimes.at(mi->getOpcode());
    }
    inflightInstruction[IF_ID_IND] = boost::none;
  }
}

template <class MemoryTopology>
void InOrderPipelineState<MemoryTopology>::processInstructionFetchStage() {
  if (flushedFetchStage) {
    instructionAccessFinished = false;
    flushedFetchStage = false;
    if (needPersistenceScopes()) {
      // If we just enter a scope after a speculation flush, do so
      int nextPopulatedStage = IF_ID_IND;
      while (nextPopulatedStage < NUMBEROFSTAGES &&
             !inflightInstruction[nextPopulatedStage]) {
        ++nextPopulatedStage;
      }
      assert(nextPopulatedStage < NUMBEROFSTAGES &&
             "We flush pipe but have no flushing instr?");
      auto nextaddr = inflightInstruction[nextPopulatedStage].get().first;
      if (StaticAddrProvider->hasMachineInstrByAddr(this->pc.getPc().first) &&
          StaticAddrProvider->hasMachineInstrByAddr(nextaddr)) {
        auto fetchinstr =
            StaticAddrProvider->getMachineInstrByAddr(this->pc.getPc().first);
        auto nextinstr = StaticAddrProvider->getMachineInstrByAddr(nextaddr);
        auto edge =
            std::make_pair(nextinstr->getParent(), fetchinstr->getParent());
        if (edge.first != edge.second &&
            PersistenceScopeInfo::getInfo().entersScope(edge)) {
          for (auto scope :
               PersistenceScopeInfo::getInfo().getEnteringScopes(edge)) {
            DEBUG_WITH_TYPE(
                "persistence",
                dbgs() << "We are going to enter a scope after speculation: "
                       << scope.getId() << "\n");
            memory.enterScope(scope);
          }
        }
      }
    }
    instructionAccessId = memory.accessInstr(this->pc.getPc().first, 1);
  } else {
    if (instructionAccessId) {
      if (memory.finishedInstrAccess(*instructionAccessId)) {
        DEBUG_WITH_TYPE(
            "indv", std::cerr << "Instruction access finished from memory.");
        instructionAccessFinished = true;
        instructionAccessId = boost::none;
      }
    }
    if (!inflightInstruction[IF_ID_IND] && instructionAccessFinished) {
      // fetch the next instruction
      auto fetchedElement = this->pc.fetchNextInstruction();
      inflightInstruction[IF_ID_IND] = fetchedElement;
      instructionAccessFinished = false;
      if (needPersistenceScopes()) {
        // Persistence Scope handling
        if (StaticAddrProvider->hasMachineInstrByAddr(this->pc.getPc().first) &&
            StaticAddrProvider->hasMachineInstrByAddr(fetchedElement.first)) {
          auto fetchedinstr =
              StaticAddrProvider->getMachineInstrByAddr(fetchedElement.first);
          auto nextinstr =
              StaticAddrProvider->getMachineInstrByAddr(this->pc.getPc().first);
          auto edge =
              std::make_pair(fetchedinstr->getParent(), nextinstr->getParent());
          if (edge.first != edge.second &&
              PersistenceScopeInfo::getInfo().entersScope(edge)) {
            for (auto scope :
                 PersistenceScopeInfo::getInfo().getEnteringScopes(edge)) {
              DEBUG_WITH_TYPE("persistence",
                              dbgs()
                                  << "(BB" << edge.first->getNumber() << ", BB"
                                  << edge.second->getNumber() << ") "
                                  << "We are going to enter a scope: "
                                  << scope.getId() << "\n");
              memory.enterScope(scope);
            }
          }
        }
      }
      // If end of program or start of an external function
      if (StaticAddrProvider->goesExternal(fetchedElement.first)) {
        // No new memory access
      } else {
        if (StaticAddrProvider->hasMachineInstrByAddr(fetchedElement.first)) {
          auto instr =
              StaticAddrProvider->getMachineInstrByAddr(fetchedElement.first);
          if (instr->isCall() || instr->isReturn() ||
              isJumpTableBranch(instr) ||
              (instr->isBranch() &&
               MuArchType == MicroArchitecturalType::STRICTINORDER)) {
            return;
          }
        }
        instructionAccessId = memory.accessInstr(this->pc.getPc().first, 1);
      }
    }
  }
}

template <class MemoryTopology>
std::map<int, std::set<unsigned>>
    InOrderPipelineState<MemoryTopology>::instructionExecutionTimes;

} // namespace TimingAnalysisPass

#endif
