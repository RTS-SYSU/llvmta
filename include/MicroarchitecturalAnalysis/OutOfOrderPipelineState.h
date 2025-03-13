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

#ifndef OUTOFORDERPIPELINESTATE_H
#define OUTOFORDERPIPELINESTATE_H

#include "MicroarchitecturalAnalysis/ConvergenceDetection.h"
#include "MicroarchitecturalAnalysis/ConvergenceType.h"
#include "MicroarchitecturalAnalysis/MicroArchitecturalState.h"
#include "MicroarchitecturalAnalysis/OutOfOrderPipelineComponents/BranchFunctionalUnit.h"
#include "MicroarchitecturalAnalysis/OutOfOrderPipelineComponents/InstructionQueue.h"
#include "MicroarchitecturalAnalysis/OutOfOrderPipelineComponents/LoadStoreFunctionalUnit.h"
#include "MicroarchitecturalAnalysis/OutOfOrderPipelineComponents/RegisterStatusTable.h"
#include "MicroarchitecturalAnalysis/OutOfOrderPipelineComponents/ReservationStation.h"
#include "MicroarchitecturalAnalysis/OutOfOrderPipelineComponents/SimpleFunctionalUnit.h"

namespace TimingAnalysisPass {

/**
 * Template class describing an out-of-order pipeline state.
 * It implements the Tomasulo algorithm for dynamic scheduling.
 * It features several functional units and interconnects all relevant
 * components. The memory-subsystem is chosen via the template parameter.
 */
template <class MemoryTopology>
class OutOfOrderPipelineState
    : public MicroArchitecturalState<
          OutOfOrderPipelineState<MemoryTopology>,
          std::tuple<InstrContextMapping &, AddressInformation &>> {
public:
  // define SuperClass for convenience
  typedef MicroArchitecturalState<
      OutOfOrderPipelineState<MemoryTopology>,
      std::tuple<InstrContextMapping &, AddressInformation &>>
      SuperClass;

  typedef typename SuperClass::StateSet StateSet;

  template <typename T>
  using MapFromStates = typename SuperClass::template MapFromStates<T>;

  explicit OutOfOrderPipelineState(ProgramLocation &pl);

  explicit OutOfOrderPipelineState(const OutOfOrderPipelineState &ooops);

  virtual ~OutOfOrderPipelineState();

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
    LocalMetrics(const OutOfOrderPipelineState &outerClassInstance)
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

  virtual bool isWaitingForJoin() const {
    return memory.isWaitingForJoin() || this->commonDataBus.isSet();
  }

  /**
   * Wrapper to call handleBranching in MicroArchitecturalState
   */
  void earlyBranch(const ExecutionElement ee, InstrContextMapping &ins2ctx);

  StateSet checkForBranches(ExecutionElement ee, InstrContextMapping &ins2ctx);

  /// All the getter functioncs for the individual pipeline components.
  MemoryTopology &getMemory();

  ReOrderBuffer &getReOrderBuffer();

  RegisterStatusTable &getRegisterStatusTable();

  std::vector<ReservationStation> &getResStations();

  CommonDataBus &getCDB();

  ProgramCounter &getPc();

  std::unordered_map<ExecutionElement,
                     std::pair<unsigned, std::set<PersistenceScope>>> &
  getSpeculativeScopeEntrances();

  /// \see superclass
  bool operator==(const OutOfOrderPipelineState &ds) const;

  /// \see superclass
  virtual size_t hashcode() const;

  /// \see superclass
  virtual bool isJoinable(const OutOfOrderPipelineState &ds) const;

  /// \see superclass
  virtual void join(const OutOfOrderPipelineState &ds);

  // Output operation
  template <class MT>
  friend std::ostream &operator<<(std::ostream &stream,
                                  const OutOfOrderPipelineState<MT> &ooops);

#ifdef AUTO_CONVERGENCE_DETECTION
  ConvergenceType isConvergedAfterCycleFrom(
      const OutOfOrderPipelineState<MemoryTopology> &origin,
      ConvergenceType convergenceTypeOfSibling) const;

#else
  ConvergenceType getConvergenceType() const {
    return POTENTIALLY_NOT_CONVERGED;
  }

#endif
private:
  /**
   * Assigns pointers to all components.
   * This includes functional units to reservation stations as well as
   * reOrderBuffer and registerStatusTable pointers to everything else (where
   * its needed). This includes splitting functional units s.t. each reservation
   * station only serves some units.
   */
  void assignPointersToComponents();

  /**
   * Flushes the pipeline and all connected components respectively.
   * This is due to the committed instruction represented by committedInstr.
   */
  void emptyPipeline(const llvm::MachineInstr *committedInstr);

  std::list<OutOfOrderPipelineState<MemoryTopology>> cycleMemoryTopology();

  /// Helper function, that checks which scopes are to leave between "from" and
  /// "to".
  void leavePersistenceScope(ExecutionElement from, ExecutionElement to);

  /**
   * Asserts that the reorder buffer executing tags match the tags
   * of the executing entities of this outoforder pipeline.
   */
  bool checkTagValidity() const;

  // join-ability check that leaves out the memory topology
  virtual bool isJoinableUpToMemory(const OutOfOrderPipelineState &ds) const;

  /**
   * Helper function that tries to fast-forward an abstract
   * state before putting it into a state set.
   */
  void fastForwardAndInsert(const OutOfOrderPipelineState &ooops,
                            StateSet &prePersSuccessors
#ifdef AUTO_CONVERGENCE_DETECTION
                            ,
                            ConvergenceType &soFarDetectedConvergence
#endif
  ) const;

  /**
   * Some kind of memory topology.
   */
  MemoryTopology memory;

  /**
   * Instruction queue to buffer instructions
   */
  InstructionQueue<OutOfOrderPipelineState, 4> instructionQueue;

  /**
   * List of final instructions.
   * Elements are removed from the list when the outer framework asks for this
   * element.
   */
  std::list<ExecutionElement> finalInstructions;

  RegisterStatusTable regStatTabl;

  ReOrderBuffer reOrderBuffer;

  /**
   * Vector containing all connected reservation stations.
   */
  std::vector<ReservationStation> resStations;

  /**
   * Vector containing all connected functional units
   * Only parts of this vector are passed to the reservation stations.
   */
  std::vector<FunctionalUnit *> funcUnits;

  /**
   * represents the common data bus (CDB).
   * Contains a rob-tag if an instruction finished and is currently transferred
   * from a functional unit to the register/rob/reservation stations. Can be
   * accessed / snooped by all reservation stations and the rob.
   */
  CommonDataBus commonDataBus;

  /**
   * Remember for each execution element in the pipeline which scopes it entered
   * (potentially speculatively). On each fetch that enters a scope, the scope
   * is put into this map. In case we need to flush the pipeline due to
   * speculation, we leave all scopes in this map. The unsigned models how often
   * we speculatively entered these scopes. This is important for long
   * speculation chains and correct scope handling.
   */
  std::unordered_map<ExecutionElement,
                     std::pair<unsigned, std::set<PersistenceScope>>>
      speculativeScopeEntrances;
};

template <class MemoryTopology>
OutOfOrderPipelineState<MemoryTopology>::OutOfOrderPipelineState(
    ProgramLocation &pl)
    : SuperClass(pl), memory(), instructionQueue(this), finalInstructions(),
      regStatTabl(), reOrderBuffer(), resStations(), commonDataBus(),
      speculativeScopeEntrances() {
  // create functional units
  funcUnits.push_back(new SimpleFunctionalUnit());
  funcUnits.push_back(new SimpleFunctionalUnit());
  funcUnits.push_back(new BranchFunctionalUnit());
  funcUnits.push_back(new LoadStoreFunctionalUnit<MemoryTopology>(&memory));

  // create reservation stations
  resStations.push_back(ReservationStation(2));
  resStations.push_back(ReservationStation(1));
  resStations.push_back(ReservationStation(1));

  // notify reservation stations of new functional units
  assignPointersToComponents();
}

template <class MemoryTopology>
OutOfOrderPipelineState<MemoryTopology>::OutOfOrderPipelineState(
    const OutOfOrderPipelineState &ooops)
    : SuperClass(ooops), memory(ooops.memory),
      instructionQueue(ooops.instructionQueue),
      finalInstructions(ooops.finalInstructions),
      regStatTabl(ooops.regStatTabl), reOrderBuffer(ooops.reOrderBuffer),
      resStations(ooops.resStations), commonDataBus(ooops.commonDataBus),
      speculativeScopeEntrances(ooops.speculativeScopeEntrances) {
  // Deep copy of functional units
  for (auto fu : ooops.funcUnits) {
    FunctionalUnit *newFu = fu->clone();
    // DEBUG_WITH_TYPE("split", dbgs() << "Fu clone, new fu addr: " << newFu <<
    // "\n");
    funcUnits.push_back(newFu);
  }

  // notify reservation stations of new functional units
  assignPointersToComponents();
}

template <class MemoryTopology>
OutOfOrderPipelineState<MemoryTopology>::~OutOfOrderPipelineState() {
  // need to delete all functional units explicitly
  for (auto fu : funcUnits) {
    delete fu;
  }
}

// TODO clear up terminology dispatch/issue
template <class MemoryTopology>
typename OutOfOrderPipelineState<MemoryTopology>::StateSet
OutOfOrderPipelineState<MemoryTopology>::cycle(
    std::tuple<InstrContextMapping &, AddressInformation &> &dep) const {
  // init result set
  StateSet prePersSuccessors;
  StateSet successors;

  // copy this state to succ (which will be worked on)
  OutOfOrderPipelineState succ(*this);

  DEBUG_WITH_TYPE("ooo", std::cerr << *this);

  // increase timing of the succ
  ++succ.time;

  // reset CDB on successor
  succ.commonDataBus.reset();

#ifdef AUTO_CONVERGENCE_DETECTION
  ConvergenceType soFarDetectedConvergence = POTENTIALLY_NOT_CONVERGED;
#endif

  std::list<OutOfOrderPipelineState<MemoryTopology>> intermediateStates =
      succ.cycleMemoryTopology();

  // Sort out the successor states that need to stall and insert them into the
  // result set
  for (auto it = intermediateStates.begin(); it != intermediateStates.end();) {
    if (it->memory.shouldPipelineStall()) {
      if (needPersistenceScopes()) {
        fastForwardAndInsert(*it, successors
#ifdef AUTO_CONVERGENCE_DETECTION
                             ,
                             soFarDetectedConvergence
#endif
        );
      } else {
        fastForwardAndInsert(*it, prePersSuccessors
#ifdef AUTO_CONVERGENCE_DETECTION
                             ,
                             soFarDetectedConvergence
#endif
        );
      }
      it = intermediateStates.erase(it);
    } else {
      ++it;
    }
  }

  // cycle functional units
  for (unsigned i = 0; i < succ.funcUnits.size(); i++) {
    std::list<OutOfOrderPipelineState<MemoryTopology>> tempIntermediateStates;
    // cycle the functional unit for each current states
    for (auto &ooops : intermediateStates) {
      // cycle returns at least itself
      std::list<FunctionalUnit *> cycleResults =
          ooops.funcUnits.at(i)->cycle(dep);
      for (auto fu : cycleResults) {
        // copy ooops accordingly
        OutOfOrderPipelineState<MemoryTopology> tempSucc(ooops);
        // set the returned functional unit
        // replace functional unit
        FunctionalUnit *oldFu = tempSucc.funcUnits.at(i);
        delete oldFu;
        tempSucc.funcUnits[i] = fu;
        tempSucc.assignPointersToComponents();
        tempIntermediateStates.push_back(tempSucc);
      }
    }
    intermediateStates.clear();
    // set common data bus if the functional unit was finished and it is not set
    // already and move the states to intermediateStates to handle the next
    // functional unit
    for (auto &ooops : tempIntermediateStates) {
      auto finTag = ooops.funcUnits[i]->getFinishedInstructionTag();
      if (finTag && !ooops.commonDataBus.isSet()) {
        ooops.commonDataBus.set(finTag.get());
        ooops.funcUnits[i]->clearFinishedInstruction();
      }
      intermediateStates.push_back(ooops);
    }
  }

  for (auto &ooops : intermediateStates) {
    assert(!ooops.memory.shouldPipelineStall() &&
           "Should not cycle a stalling state");

    // cycle reservation stations
    for (auto &rS : ooops.resStations) {
      rS.cycle();
    }

    // register status table does not need to be cycled

    InstrContextMapping &ins2ctx = std::get<0>(dep);

    // cycle reorder buffer
    // TODO FIXME handle multiple branches finishing in the same cycle by
    // calling checkForBranches one after the other (only for the first branch
    // in the taken case)
    auto tempFi = ooops.reOrderBuffer.cycle(ooops.commonDataBus);

    ooops.finalInstructions.insert(ooops.finalInstructions.end(),
                                   tempFi.begin(), tempFi.end());

    // cycle instruction queue
    // branchInstr indicates whether there was a branch to be handled
    ooops.instructionQueue.cycle(&ooops, ins2ctx);

    // For all final instructions
    for (auto &fi : tempFi) {
      if (needPersistenceScopes()) {
        // If we opened a scope speculatively, it can be committed now
        if (ooops.speculativeScopeEntrances.count(fi) > 0) {
          if (--ooops.speculativeScopeEntrances.at(fi).first == 0) {
            ooops.speculativeScopeEntrances.erase(fi);
          }
        }
      }
      // Check for branches
      // Note that there can only be one branch getting committed in one cycle
      auto tempList = ooops.checkForBranches(fi, ins2ctx);
      // insert elements of tempList into prePersSuccessors
      for (auto &tempItem : tempList) {
        fastForwardAndInsert(tempItem, prePersSuccessors
#ifdef AUTO_CONVERGENCE_DETECTION
                             ,
                             soFarDetectedConvergence
#endif
        );
      }
    }

    // insert ooops into prePersSuccessors
    fastForwardAndInsert(ooops, prePersSuccessors
#ifdef AUTO_CONVERGENCE_DETECTION
                         ,
                         soFarDetectedConvergence
#endif
    );

    // Close persistence scopes if needed
    if (needPersistenceScopes()) {
      if (tempFi.size() > 0) {
        for (auto &succStateConst : prePersSuccessors) {
          OutOfOrderPipelineState succState(succStateConst);
          for (auto fiIter = tempFi.begin(); fiIter != tempFi.end(); ++fiIter) {
            /*	Check whether some edge starting from *fiIter should end
               persistence scopes: We need to check what the next instruction is
               to find out whether there is a "leave scope" directive. Next is
               either the next completed one, or the next in the reorder-buffer
               or in the instruction queue or in the pc.
            */
            auto nextfiIter = fiIter;
            ++nextfiIter;
            if (nextfiIter == tempFi.end()) {
              // Try reorder buffer next
              auto robHeadElement = succState.reOrderBuffer.getHeadElement();
              if (robHeadElement) {
                succState.leavePersistenceScope(*fiIter, robHeadElement.get());
              } else {
                // Try instruction queue next
                auto lastInstrQueueElement =
                    succState.instructionQueue.getNextExecutionElement();
                if (lastInstrQueueElement) {
                  succState.leavePersistenceScope(*fiIter,
                                                  lastInstrQueueElement.get());
                } else {
                  // Use pc next (last choice)
                  succState.leavePersistenceScope(*fiIter,
                                                  succState.getPc().getPc());
                }
              }
            } else {
              succState.leavePersistenceScope(*fiIter, *nextfiIter);
            }
          }
          successors.insert(succState);
        }
      } else {
        successors.insert(prePersSuccessors.begin(), prePersSuccessors.end());
      }
      // All relevant successor states arising from ooops are copied (with scope
      // handling) to successors. Clear the prePersSuccessors to not be
      // considered again when considering the next successor state ooops.
      // Otherwise, the same successor state would be considered multiple times
      // and for different(!) final instructions for scope handling.
      prePersSuccessors.clear();
    }
  }

  DEBUG_WITH_TYPE(
      "ooo",
      std::cerr << "---------------\nEnd states start here\n--------------\n");

  // return successor stateset
  if (needPersistenceScopes()) {
    for (auto &succ : successors) {
      DEBUG_WITH_TYPE("ooo", std::cerr << succ);
      assert(succ.checkTagValidity() && "Validity assumption violated");
    }
    assert(successors.size() > 0 && "Empty successor set");
    return successors;
  } else {
    for (auto &succ : prePersSuccessors) {
      DEBUG_WITH_TYPE("ooo", std::cerr << succ);
      assert(succ.checkTagValidity() && "Validity assumption violated");
    }
    assert(prePersSuccessors.size() > 0 && "Empty successor set");
    return prePersSuccessors;
  }
}

template <class MemoryTopology>
bool OutOfOrderPipelineState<MemoryTopology>::isFinal(ExecutionElement &ee) {
  if (StaticAddrProvider->goesExternal(ee.first)) {
    // we are no longer inside our program
    return reOrderBuffer.isEmpty() && instructionQueue.isEmpty() &&
           !memory.hasUnfinishedAccesses();
  } else {
    assert(StaticAddrProvider->hasMachineInstrByAddr(ee.first) &&
           "isFinal asked for some unknown address.");
    // check whether the instruction is final
    for (auto fi = finalInstructions.begin(); fi != finalInstructions.end();) {
      if (ee.first == fi->first && ee.second == fi->second) {
        // delete from final instructions
        fi = finalInstructions.erase(fi);
        return true;
      } else {
        ++fi;
      }
    }
    return false;
  }
}

template <class MemoryTopology>
void OutOfOrderPipelineState<MemoryTopology>::earlyBranch(
    const ExecutionElement ee, InstrContextMapping &ins2ctx) {
  // this does not cause splits
  assert(StaticAddrProvider->hasMachineInstrByAddr(ee.first) &&
         "No instruction.");
  auto exInstr = StaticAddrProvider->getMachineInstrByAddr(ee.first);
  assert((exInstr->isUnconditionalBranch() ||
          (exInstr->isCall() && !isPredicated(exInstr))) &&
         "Instruction was not an unconditional branch or call.");
  // do not flush the pipeline or instruction queue here, since all preceding
  // instructions have to be executed
  auto resultSet = this->handleBranching(ee, ins2ctx);
  assert(resultSet.size() == 0 &&
         "Early branching caused a split! Take care of that!");
}

template <class MemoryTopology>
typename OutOfOrderPipelineState<MemoryTopology>::StateSet
OutOfOrderPipelineState<MemoryTopology>::checkForBranches(
    ExecutionElement ee, InstrContextMapping &ins2ctx) {
  StateSet res;
  // In case of misspeculation, we need to flush the reorder-buffer, the
  // reservation stations and the instruction queue
  // TODO change here for "real" speculation
  assert(StaticAddrProvider->hasMachineInstrByAddr(ee.first) &&
         "No machine instruction for address.");

  auto exInstr = StaticAddrProvider->getMachineInstrByAddr(ee.first);
  if (exInstr->isConditionalBranch() ||
      (exInstr->isCall() && isPredicated(exInstr)) || exInstr->isReturn() ||
      isJumpTableBranch(exInstr)) {
    DEBUG_WITH_TYPE("ooo",
                    dbgs() << "OOO: Handle branching for instr: " << *exInstr);
    auto alternativeSucc = this->handleBranching(ee, ins2ctx);

    // state "this" was always altered concerning the program counter.
    // if "this" was altered, empty/flush the pipeline of this
    this->emptyPipeline(exInstr);
    // TODO Note: If the ooo-pipeline would continue fetching upon predicated
    // returns, there would be no need to flush

    // if we have a return, also empty the pipeline for all successor states and
    // add them to the result
    if (exInstr->isReturn() || isJumpTableBranch(exInstr)) {
      for (auto altSucc = alternativeSucc.begin();
           altSucc != alternativeSucc.end(); ++altSucc) {
        OutOfOrderPipelineState copy(*altSucc);
        copy.emptyPipeline(exInstr);
        res.insert(copy);
      }
    } else {
      // add alternative successors to the result set
      res.insert(alternativeSucc.begin(), alternativeSucc.end());
    }
  }

  return res;
}

template <class MemoryTopology>
void OutOfOrderPipelineState<MemoryTopology>::emptyPipeline(
    const llvm::MachineInstr *committedInstr) {
  if (needPersistenceScopes()) {
    // All speculatively opened scopes should be closed now, the map itself is
    // obsolete later on
    for (auto &ex2scopes : speculativeScopeEntrances) {
      for (unsigned i = 0; i < ex2scopes.second.first; ++i) {
        for (auto &scope : ex2scopes.second.second) {
          memory.leaveScope(scope);
        }
      }
    }
    speculativeScopeEntrances.clear();
  }

  instructionQueue.flush(this, committedInstr);
  reOrderBuffer.flush();
  for (auto &rs : resStations) {
    rs.flush();
  }
  commonDataBus.reset();
  regStatTabl.flush();
  for (auto fu : funcUnits) {
    fu->flush();
  }
}

template <class MemoryTopology>
std::list<OutOfOrderPipelineState<MemoryTopology>>
OutOfOrderPipelineState<MemoryTopology>::cycleMemoryTopology() {
  std::list<MemoryTopology> res = memory.cycle(false);
  std::list<OutOfOrderPipelineState<MemoryTopology>> resultList;
  for (auto &mt : res) {
    OutOfOrderPipelineState<MemoryTopology> ooops(*this);
    ooops.memory = mt;
    resultList.push_back(ooops);
  }
  return resultList;
}

template <class MemoryTopology>
void OutOfOrderPipelineState<MemoryTopology>::leavePersistenceScope(
    ExecutionElement from, ExecutionElement to) {
  if (StaticAddrProvider->hasMachineInstrByAddr(from.first) &&
      StaticAddrProvider->hasMachineInstrByAddr(to.first)) {
    auto frominstr = StaticAddrProvider->getMachineInstrByAddr(from.first);
    auto toinstr = StaticAddrProvider->getMachineInstrByAddr(to.first);
    auto edge = std::make_pair(frominstr->getParent(), toinstr->getParent());
    if (edge.first != edge.second &&
        PersistenceScopeInfo::getInfo().leavesScope(edge)) {
      const auto &scopes =
          PersistenceScopeInfo::getInfo().getLeavingScopes(edge);
      for (auto scope : scopes) {
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

template <class MemoryTopology>
MemoryTopology &OutOfOrderPipelineState<MemoryTopology>::getMemory() {
  return memory;
}

template <class MemoryTopology>
ReOrderBuffer &OutOfOrderPipelineState<MemoryTopology>::getReOrderBuffer() {
  return reOrderBuffer;
}

template <class MemoryTopology>
RegisterStatusTable &
OutOfOrderPipelineState<MemoryTopology>::getRegisterStatusTable() {
  return regStatTabl;
}

template <class MemoryTopology>
std::vector<ReservationStation> &
OutOfOrderPipelineState<MemoryTopology>::getResStations() {
  return resStations;
}

template <class MemoryTopology>
CommonDataBus &OutOfOrderPipelineState<MemoryTopology>::getCDB() {
  return commonDataBus;
}

template <class MemoryTopology>
ProgramCounter &OutOfOrderPipelineState<MemoryTopology>::getPc() {
  return this->pc;
}

template <class MemoryTopology>
std::unordered_map<ExecutionElement,
                   std::pair<unsigned, std::set<PersistenceScope>>> &
OutOfOrderPipelineState<MemoryTopology>::getSpeculativeScopeEntrances() {
  return this->speculativeScopeEntrances;
}

template <class MemoryTopology>
bool OutOfOrderPipelineState<MemoryTopology>::operator==(
    const OutOfOrderPipelineState<MemoryTopology> &ooops) const {
  for (unsigned i = 0; i < this->funcUnits.size(); i++) {
    if (!(this->funcUnits.at(i)->equals(*ooops.funcUnits.at(i))))
      return false;
  }
  bool result = SuperClass::operator==(ooops) &&
                this->instructionQueue == ooops.instructionQueue &&
                this->finalInstructions == ooops.finalInstructions &&
                this->regStatTabl == ooops.regStatTabl &&
                this->reOrderBuffer == ooops.reOrderBuffer &&
                this->resStations == ooops.resStations &&
                this->commonDataBus == ooops.commonDataBus &&
                this->memory == ooops.memory;
  assert((!result ||
          speculativeScopeEntrances == ooops.speculativeScopeEntrances) &&
         "Speculative scope entrances do not respect equality");
  return result;
}

#ifdef AUTO_CONVERGENCE_DETECTION
template <class MemoryTopology>
ConvergenceType
OutOfOrderPipelineState<MemoryTopology>::isConvergedAfterCycleFrom(
    const OutOfOrderPipelineState<MemoryTopology> &origin,
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
    const bool cornerCase =
        reOrderBuffer.isEmpty() && instructionQueue.isEmpty();
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

template <class MemoryTopology>
size_t OutOfOrderPipelineState<MemoryTopology>::hashcode() const {
  size_t result = SuperClass::hashcode();

  hash_combine_hashcode(result, memory);

  hash_combine_hashcode(result, instructionQueue);
  for (auto fi : finalInstructions) {
    hash_combine(result, fi);
  }

  hash_combine_hashcode(result, regStatTabl);
  hash_combine_hashcode(result, reOrderBuffer);

  for (auto &rs : resStations) {
    hash_combine_hashcode(result, rs);
  }

  for (auto fu : funcUnits) {
    hash_combine_hashcode(result, *fu);
  }

  hash_combine_hashcode(result, commonDataBus);

  return result;
}

template <class MemoryTopology>
bool OutOfOrderPipelineState<MemoryTopology>::isJoinableUpToMemory(
    const OutOfOrderPipelineState<MemoryTopology> &ooops) const {
  for (unsigned i = 0; i < this->funcUnits.size(); i++) {
    if (!(this->funcUnits.at(i)->equals(*ooops.funcUnits.at(i))))
      return false;
  }
  bool result = SuperClass::isJoinable(ooops) &&
                this->instructionQueue == ooops.instructionQueue &&
                this->finalInstructions == ooops.finalInstructions &&
                this->regStatTabl == ooops.regStatTabl &&
                this->reOrderBuffer == ooops.reOrderBuffer &&
                this->resStations == ooops.resStations &&
                this->commonDataBus == ooops.commonDataBus;
  assert((!result ||
          speculativeScopeEntrances == ooops.speculativeScopeEntrances) &&
         "Speculative scope entrances do not respect join");
  return result;
}

template <class MemoryTopology>
bool OutOfOrderPipelineState<MemoryTopology>::isJoinable(
    const OutOfOrderPipelineState<MemoryTopology> &ooops) const {
  return isJoinableUpToMemory(ooops) && this->memory.isJoinable(ooops.memory);
}

template <class MemoryTopology>
void OutOfOrderPipelineState<MemoryTopology>::join(
    const OutOfOrderPipelineState<MemoryTopology> &ooops) {
  assert(isJoinable(ooops) &&
         "Tried joining non-joinable OutOfOrderPipelineStates.");
  assert(ooops.isJoinable(*this) && "isJoinable not commutative.");
  SuperClass::join(ooops);
  memory.join(ooops.memory);
}

template <class MemoryTopology>
void OutOfOrderPipelineState<MemoryTopology>::fastForwardAndInsert(
    const OutOfOrderPipelineState<MemoryTopology> &ooops,
    OutOfOrderPipelineState<MemoryTopology>::StateSet &prePersSuccessors
#ifdef AUTO_CONVERGENCE_DETECTION
    ,
    ConvergenceType &soFarDetectedConvergence
#endif
) const {
#ifdef AUTO_CONVERGENCE_DETECTION
  // auto detect the convergence
  ConvergenceType succConverged =
      ooops.isConvergedAfterCycleFrom(*this, soFarDetectedConvergence);
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
  ConvergenceType succConverged = ooops.getConvergenceType();
#endif

  // trigger the actual fast-forwarding at
  // the memory topology
  if (succConverged != POTENTIALLY_NOT_CONVERGED) {
    auto fastForwardingResult = ooops.memory.fastForward();
    for (auto &forwardedInnerMem : fastForwardingResult) {
      OutOfOrderPipelineState copy(ooops);
      copy.memory = forwardedInnerMem;
      prePersSuccessors.insert(copy);
    }
  }

  // insert unchanged into the pre-persistence successor stateset
  else {
    prePersSuccessors.insert(ooops);
  }
}

template <class MT>
std::ostream &operator<<(std::ostream &stream,
                         const OutOfOrderPipelineState<MT> &ooops) {
  stream << "++++++++++++++++++++++\n";
  stream << "----------------------\n";
  stream << "Out of order pipeline: \n";

  auto &base = (const MicroArchitecturalState<
                OutOfOrderPipelineState<MT>,
                typename OutOfOrderPipelineState<MT>::StateDep> &)ooops;
  stream << base << "\n";

  stream << "----------------------\n";
  stream << ooops.memory;

  stream << "----------------------\n";
  stream << ooops.instructionQueue;
  stream << "----------------------\n";
  stream << ooops.regStatTabl;
  stream << "----------------------\n";
  stream << ooops.reOrderBuffer;
  stream << "----------------------\n";

  for (auto &rs : ooops.resStations) {
    stream << rs;
    stream << "----------------------\n";
  }

  stream << "Common data bus ";
  if (ooops.commonDataBus.isSet()) {
    stream << "contains tag "
           << ooops.reOrderBuffer.getRelativeToHead(
                  ooops.commonDataBus.getCdb())
           << "\n";
  } else {
    stream << "empty.\n";
  }

  stream << "----------------------\n";
  stream << "Finalized instructions: \n";
  for (auto &fi : ooops.finalInstructions) {
    stream << " + " << fi << "\n";
  }
  stream << "----------------------\n";
  return stream;
}

template <class MemoryTopology>
void OutOfOrderPipelineState<MemoryTopology>::assignPointersToComponents() {
  regStatTabl.reassignPointers(&reOrderBuffer);

  reOrderBuffer.reassignPointers(&regStatTabl);

  for (auto fu : funcUnits) {
    assert(funcUnits.size() == 4 && "Some functional unit was not present.");
    fu->reassignPointers(&reOrderBuffer);
  }

  LoadStoreFunctionalUnit<MemoryTopology> *lsfu =
      dynamic_cast<LoadStoreFunctionalUnit<MemoryTopology> *>(funcUnits[3]);
  lsfu->reassignMemory(&memory);

  commonDataBus.reassignPointers(&reOrderBuffer);

  // assign simple functional units to the first reservation station
  std::vector<FunctionalUnit *> simpleFuncUnits(funcUnits.begin(),
                                                funcUnits.begin() + 2);
  resStations[0].reassignPointers(simpleFuncUnits, &reOrderBuffer,
                                  &commonDataBus);

  // assign branch functional units to the second reservation station
  std::vector<FunctionalUnit *> branchFuncUnits(funcUnits.begin() + 2,
                                                funcUnits.begin() + 3);
  resStations[1].reassignPointers(branchFuncUnits, &reOrderBuffer,
                                  &commonDataBus);

  // assign load/store functional units to the third reservation station
  std::vector<FunctionalUnit *> loadStoreFuncUnits(funcUnits.begin() + 3,
                                                   funcUnits.begin() + 4);
  resStations[2].reassignPointers(loadStoreFuncUnits, &reOrderBuffer,
                                  &commonDataBus);
}

template <class MemoryTopology>
bool OutOfOrderPipelineState<MemoryTopology>::checkTagValidity() const {
  auto res1 = reOrderBuffer.getExecutingRobTags();

  std::set<unsigned> res2;
  for (auto fu : funcUnits) {
    const auto &tmp = fu->getExecutingRobTags();
    res2.insert(tmp.begin(), tmp.end());
  }
  for (auto &resSt : resStations) {
    const auto &tmp = resSt.getExecutingRobTags();
    res2.insert(tmp.begin(), tmp.end());
  }

  return res1 == res2;
}

} // namespace TimingAnalysisPass

#endif /* OUTOFORDERPIPELINESTATE_H */
