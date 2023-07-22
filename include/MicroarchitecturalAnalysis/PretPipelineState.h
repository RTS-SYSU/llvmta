////////////////////////////////////////////////////////////////////////////////
//
//   LLVMTA - Timing Analyser performing worst-case execution time analysis
//     using the LLVM backend intermediate representation
//
// Copyright (C) 2013-2022  Saarland University
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

#ifndef PRETPIPELINESTATE_H
#define PRETPIPELINESTATE_H

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

namespace TimingAnalysisPass {

/**
 * Class implementing the cycle-based semantics of a simple processor with
 * a five-stage pipeline.
 * The resulting analysis is basically a counter-based microarchitectural
 * analysis.
 */
template <class MemoryTopology>
class PretPipelineState
    : public MicroArchitecturalState<
          PretPipelineState<MemoryTopology>,
          std::tuple<InstrContextMapping &, AddressInformation &>> {

  // ensure that MemoryTopology is a class derived from MemoryTopologyInterface
  BOOST_STATIC_ASSERT(boost::is_base_of<MemoryTopologyInterface<MemoryTopology>,
                                        MemoryTopology>::value);

public:
  // define SuperClass for convenience
  typedef MicroArchitecturalState<
      PretPipelineState<MemoryTopology>,
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
  explicit PretPipelineState(ProgramLocation &pl);
  /**
   * Copy Constructor
   */
  explicit PretPipelineState(const PretPipelineState &iops);

  /**
   * Virtual destructor
   */
  virtual ~PretPipelineState();

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
    LocalMetrics(const PretPipelineState &outerClassInstance)
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
  bool operator==(const PretPipelineState &ds) const;

  /// \see superclass
  virtual size_t hashcode() const;

  /// \see superclass
  virtual bool isJoinable(const PretPipelineState &ds) const;

  /// \see superclass
  virtual void join(const PretPipelineState &ds);

  // Output operation
  template <class Mem>
  friend std::ostream &operator<<(std::ostream &stream,
                                  const PretPipelineState<Mem> &iops);

#ifdef AUTO_CONVERGENCE_DETECTION
  ConvergenceType
  isConvergedAfterCycleFrom(const PretPipelineState<MemoryTopology> &origin,
                            ConvergenceType convergenceTypeOfSibling) const;

#else
  ConvergenceType getConvergenceType() const {
    return POTENTIALLY_NOT_CONVERGED;
  }

#endif
private:
  void accessDataFromMemoryTopology(AddressInformation &addrInfo);

  std::list<PretPipelineState<MemoryTopology>> cycleMemoryTopology();

  // proceeding the write back stage
  void processWriteBackStage();

  // proceeding the memory stage
  std::list<PretPipelineState> processMemoryStage(
      std::tuple<InstrContextMapping &, AddressInformation &> &dep) const;

  // proceeding the execution stage
  std::list<PretPipelineState> processExecuteStage(
      std::tuple<InstrContextMapping &, AddressInformation &> &dep) const;

  /**
   * Helper function that check whether an instruction is a branch,
   * and if so, perform branch.
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
  virtual bool isJoinableUpToMemory(const PretPipelineState &ds) const;

  /**
   * Helper function that tries to fast-forward an abstract
   * state before putting it into a state set.
   */
  void fastForwardAndInsert(const PretPipelineState &ooops, StateSet &successors
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
   * Some attached memory which is accessed for data.
   */
  MemoryTopology memory;

  /**
   * Temporary storage of the accessId for the instruction access
   * There can only be one instruction access at a time.
   */
  boost::optional<unsigned> instructionAccessId;

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
PretPipelineState<MemoryTopology>::PretPipelineState(ProgramLocation &pl)
    : SuperClass(pl), currMemoryAccess(0) {
  int i;
  for (i = 0; i < NUMBEROFSTAGES; i++) {
    inflightInstruction[i] = boost::none;
  }

  // Make pc available for memory topology to get the first instruction
  instructionAccessId = memory.accessInstr(this->pc.getPc().first, 1);
}

template <class MemoryTopology>
PretPipelineState<MemoryTopology>::PretPipelineState(
    const PretPipelineState &iops)
    : SuperClass(iops),
      // the booleans are internal for each state
      memory(iops.memory), instructionAccessId(iops.instructionAccessId),
      currMemoryAccess(iops.currMemoryAccess),
      dataAccessIds(iops.dataAccessIds) {
  for (unsigned i = 0; i < NUMBEROFSTAGES; ++i) {
    inflightInstruction[i] = iops.inflightInstruction[i];
  }
}

template <class MemoryTopology>
PretPipelineState<MemoryTopology>::~PretPipelineState() {}

template <class MemoryTopology>
typename PretPipelineState<MemoryTopology>::StateSet
PretPipelineState<MemoryTopology>::cycle(
    std::tuple<InstrContextMapping &, AddressInformation &> &dep) const {
  // Copy this state for the successor
  PretPipelineState succ(*this);

  // Consistency check
  unsigned inflights = instructionAccessId ? 1 : 0;
  for (unsigned i = 0; i < MEM_WB_IND; ++i) {
    if (inflightInstruction[i]) {
      ++inflights;
    }
  }
  assert(inflights <= 1 &&
         "More than one instruction live in the PRET pipeline");

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
    assert(!iopsSucc.memory.shouldPipelineStall() &&
           "Pret pipeline does not support stalling technique");

    // process Pipeline stages in reverse order
    iopsSucc.processWriteBackStage();

    for (auto &iopsMemSucc : iopsSucc.processMemoryStage(dep)) {
      for (auto &iopsExecSucc : iopsMemSucc.processExecuteStage(dep)) {
        PretPipelineState copy(iopsExecSucc);
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

  DEBUG_WITH_TYPE(
      "driverSED", for (auto &succ
                        : res) { std::cerr << succ; });
  return res;
}

template <class MemoryTopology>
void PretPipelineState<MemoryTopology>::fastForwardAndInsert(
    const PretPipelineState<MemoryTopology> &iops, StateSet &successors
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
      PretPipelineState copy(iops);
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
bool PretPipelineState<MemoryTopology>::isFinal(ExecutionElement &ee) {
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
  // * inflight[final_index] == ee
  bool isfinal = this->inflightInstruction[WB_FIN_IND].get() == ee;
  if (isfinal) { // If it really is final, then we don't need it anymore
    this->inflightInstruction[WB_FIN_IND] = boost::none;
  }
  return isfinal;
}

template <class MemoryTopology>
bool PretPipelineState<MemoryTopology>::operator==(
    const PretPipelineState &ds) const {
  bool result = SuperClass::operator==(ds) &&
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
                this->currMemoryAccess == ds.currMemoryAccess &&
                this->memory == ds.memory;
  return result;
}

#ifdef AUTO_CONVERGENCE_DETECTION
template <class MemoryTopology>
ConvergenceType PretPipelineState<MemoryTopology>::isConvergedAfterCycleFrom(
    const PretPipelineState<MemoryTopology> &origin,
    ConvergenceType convergenceTypeOfSibling) const {
  // MJa: if this assert fails, the following value of converged
  // would be guaranteed to always be false. That means we would
  // disable all forwarding. If one ever should want to disable
  // the joining of time counters, one should implement a custom
  // variant of isJoinable in MicroArchitecturalState that leaves
  // out time from the comparison...
  assert(this->time.isJoinable(origin.time) &&
         "We can only effectively use isJoinableUpToMemory here if the "
         "join-ability bool flag of the interval counter behind time is true!");

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
                         const PretPipelineState<Mem> &iops) {
  auto &base =
      (const MicroArchitecturalState<
          PretPipelineState<Mem>, typename PretPipelineState<Mem>::StateDep> &)
          iops;
  stream << base << "\n";
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

template <class MemoryTopology>
size_t PretPipelineState<MemoryTopology>::hashcode() const {
  // Initial hash by superclass
  size_t val = SuperClass::hashcode();
  for (unsigned i = 0; i < NUMBEROFSTAGES; ++i) {
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
bool PretPipelineState<MemoryTopology>::isJoinable(
    const PretPipelineState &ds) const {
  return isJoinableUpToMemory(ds) && memory.isJoinable(ds.memory);
}

template <class MemoryTopology>
bool PretPipelineState<MemoryTopology>::isJoinableUpToMemory(
    const PretPipelineState &ds) const {
  return SuperClass::isJoinable(ds) &&
         inflightInstruction[IF_ID_IND] == ds.inflightInstruction[IF_ID_IND] &&
         inflightInstruction[ID_EX_IND] == ds.inflightInstruction[ID_EX_IND] &&
         inflightInstruction[EX_MEM_IND] ==
             ds.inflightInstruction[EX_MEM_IND] &&
         inflightInstruction[MEM_WB_IND] ==
             ds.inflightInstruction[MEM_WB_IND] &&
         inflightInstruction[WB_FIN_IND] ==
             ds.inflightInstruction[WB_FIN_IND] &&
         currMemoryAccess == ds.currMemoryAccess;
  // instructionAccessId and dataAccessIds are checked for joinable by memory
}

template <class MemoryTopology>
void PretPipelineState<MemoryTopology>::join(const PretPipelineState &ds) {
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

template <class MemoryTopology>
std::list<PretPipelineState<MemoryTopology>>
PretPipelineState<MemoryTopology>::cycleMemoryTopology() {
  std::list<MemoryTopology> res = memory.cycle(false);
  std::list<PretPipelineState<MemoryTopology>> resultList;
  for (auto &mt : res) {
    PretPipelineState<MemoryTopology> iops(*this);
    iops.memory = mt;
    resultList.push_back(iops);
  }
  return resultList;
}

/**
 * This function represents all processing done in the write back stage.
 * The resulting instruction will be stored to be able to answer which
 * instruction was finished. Input: MEM_WB_IND instruction, output: WB_FIN_IND
 */
template <class MemoryTopology>
void PretPipelineState<MemoryTopology>::processWriteBackStage() {
  // if there is an input instruction for this stage
  if (this->inflightInstruction[MEM_WB_IND]) {
    inflightInstruction[WB_FIN_IND] = inflightInstruction[MEM_WB_IND];
    inflightInstruction[MEM_WB_IND] = boost::none;
  }
}

/**
 * Accesses Memory Topology.
 */
template <class MemoryTopology>
void PretPipelineState<MemoryTopology>::accessDataFromMemoryTopology(
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
      if (currMemInst->mayLoad()) {
        // TODO this might be a bit too simplistic
        assert(!currMemInst->mayStore() &&
               "Instruction found that loads and stores");
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
std::list<PretPipelineState<MemoryTopology>>
PretPipelineState<MemoryTopology>::processMemoryStage(
    std::tuple<InstrContextMapping &, AddressInformation &> &dep) const {
  std::list<PretPipelineState> result;

  // Successor state
  PretPipelineState succ(*this);

  // Get components of dependencies
  AddressInformation &addrInfo = std::get<1>(dep);
  auto &ins2ctx = std::get<0>(dep);

  // make sure there is something to process
  if (succ.inflightInstruction[EX_MEM_IND]) {
    auto currMemInst = StaticAddrProvider->getMachineInstrByAddr(
        succ.inflightInstruction[EX_MEM_IND].get().first);
    bool moveOn = true;
    // in case of loads and stores, we need to finish the accesses first
    if (currMemInst->mayLoad() || currMemInst->mayStore()) {
      moveOn = false;
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
        moveOn = true;
      }
    }
    if (moveOn) {
      // check whether the following stage is free
      assert(!succ.inflightInstruction[MEM_WB_IND]);
      // Move on to next stage:
      succ.inflightInstruction[MEM_WB_IND] =
          succ.inflightInstruction[EX_MEM_IND];

      // Check for branches by load to pc, will use inflight instruction at
      // EX_MEM
      StateSet branch_res = succ.checkForBranches(ins2ctx, true);
      // Clear current stage
      for (auto &altsucc : branch_res) {
        PretPipelineState succ_copy(altsucc);
        succ_copy.inflightInstruction[EX_MEM_IND] = boost::none;
        result.push_back(succ_copy);
      }
      succ.inflightInstruction[EX_MEM_IND] = boost::none;
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
std::list<PretPipelineState<MemoryTopology>>
PretPipelineState<MemoryTopology>::processExecuteStage(
    std::tuple<InstrContextMapping &, AddressInformation &> &dep) const {
  std::list<PretPipelineState> result;

  // check whether there is an instruction
  if (inflightInstruction[ID_EX_IND]) {
    if (!(StaticAddrProvider->hasMachineInstrByAddr(
            this->inflightInstruction[ID_EX_IND].get().first))) {
      // this code will be executed when the pipeline runs empty at the end of a
      // program
      Context ctx = inflightInstruction[ID_EX_IND].get().second;
      assert(ctx.isEmpty() &&
             "No Machine Instruction for address, but context available");
      PretPipelineState succ(*this);
      succ.inflightInstruction[ID_EX_IND] = boost::none;
      result.push_back(succ);
    } else {
      // advance to memory stage here which must always be possible
      assert(!this->inflightInstruction[EX_MEM_IND]);

      PretPipelineState succ(*this);

      succ.inflightInstruction[EX_MEM_IND] =
          succ.inflightInstruction[ID_EX_IND];
      // initialize the next stage
      succ.dataAccessIds.clear();
      succ.currMemoryAccess = 0;

      AddressInformation &addrInfo = std::get<1>(dep);
      // prepare memory accesses
      succ.accessDataFromMemoryTopology(addrInfo);

      // Check branches
      auto &ins2ctx = std::get<0>(dep);
      StateSet temp_res = succ.checkForBranches(ins2ctx, false);
      // clear for processing the decoding stage
      for (auto &altsucc : temp_res) {
        PretPipelineState succ_copy(altsucc);
        succ_copy.inflightInstruction[ID_EX_IND] = boost::none;
        result.push_back(succ_copy);
      }
      succ.inflightInstruction[ID_EX_IND] = boost::none;
      result.push_back(succ);
    }
  } else {
    result.push_back(*this);
  }
  // All successor states
  return result;
}

template <class MemoryTopology>
typename PretPipelineState<MemoryTopology>::StateSet
PretPipelineState<MemoryTopology>::checkForBranches(
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
                exInstr->getOpcode() == ARM::BR_JTm_i12) &&
               "Unexpected opcode");
        return res;
      }
      // Skip normal branches in memory stage as they happened already
      if (memory && !exInstr->mayLoad()) {
        return res;
      }
      auto alternativeSucc = this->handleBranching(
          inflightInstruction[memory ? EX_MEM_IND : ID_EX_IND].get(), ins2ctx);
      // if memory, always check that ID_EX is empty becuase flush won't empty
      // it
      assert((!memory || !inflightInstruction[ID_EX_IND]) &&
             "Internal: Should be empty");
      res.insert(alternativeSucc.begin(), alternativeSucc.end());
    }
  }
  return res;
}

/**
 * Decodes an instruction and puts it ready for the execution stage
 * Input: IF_ID_IND, Output: ID_EX_IND
 */
template <class MemoryTopology>
void PretPipelineState<MemoryTopology>::processInstructionDecodeStage() {
  if (this->inflightInstruction[IF_ID_IND]) {
    assert(!inflightInstruction[ID_EX_IND]);
    // check for flush is implicitly here already
    if (StaticAddrProvider->hasMachineInstrByAddr(
            this->inflightInstruction[IF_ID_IND].get().first)) {
      // check that it is actually an instruction (not the end of the program)
      inflightInstruction[ID_EX_IND] = inflightInstruction[IF_ID_IND];
    }
    inflightInstruction[IF_ID_IND] = boost::none;
  }
}

template <class MemoryTopology>
void PretPipelineState<MemoryTopology>::processInstructionFetchStage() {
  if (instructionAccessId) {
    if (memory.finishedInstrAccess(*instructionAccessId)) {
      DEBUG_WITH_TYPE("indv",
                      std::cerr << "Instruction access finished from memory.");
      instructionAccessId = boost::none;
      assert(!inflightInstruction[IF_ID_IND]);
      // fetch the next instruction
      auto fetchedElement = this->pc.fetchNextInstruction();
      inflightInstruction[IF_ID_IND] = fetchedElement;
    }
  } else if (!inflightInstruction[IF_ID_IND] &&
             !inflightInstruction[ID_EX_IND] &&
             !inflightInstruction[EX_MEM_IND]) {
    // If pipeline is empty and we are not currently fetching
    // and if we are not going external
    if (StaticAddrProvider->hasMachineInstrByAddr(this->pc.getPc().first)) {
      // Start new access
      instructionAccessId = memory.accessInstr(this->pc.getPc().first, 1);
    }
  }
}

} // namespace TimingAnalysisPass

#endif
