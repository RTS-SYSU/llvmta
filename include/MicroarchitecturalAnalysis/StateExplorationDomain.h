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

#ifndef STATEEXPLORATIONDOMAIN_H
#define STATEEXPLORATIONDOMAIN_H

#include "AnalysisFramework/AnalysisDomain.h"
#include "MicroarchitecturalAnalysis/MicroArchitecturalState.h"
#include "PartitionUtil/DirectiveHeuristics.h"
#include "Util/Util.h"

#include <boost/static_assert.hpp>
#include <boost/type_traits.hpp>

#include <sstream>
#include <unordered_set>

using namespace llvm;

namespace TimingAnalysisPass {

/**
 * Common base implementation of a state space exploration domain.
 * This template cannot be used directly, but by using its derived classes.
 * The derived classes can specialize the domain, e.g. according to the desired
 * joining behaviour.
 *
 * This means there are sets of states that are valid at the beginning and the
 * end of an instruction. These states are microarchitectural states and have to
 * fulfill a certain interface. To the outside, this domain behaves like a
 * context-sensitive analysis and wraps a cycle-based formulation of
 * microarchitecture to-analyse to the granularity of instructions.
 */
template <template <class> class StateExplorationDom, class MicroArchState>
class StateExplorationDomainBase
    : public ContextAwareAnalysisDomain<StateExplorationDom<MicroArchState>,
                                        MachineInstr,
                                        typename MicroArchState::StateDep> {
  /**
   * This is a compile-time	assert that we only want this template to be
   * instantiated for classes inheriting and thereby implementing class
   * MicroArchitecturalState.
   */
  BOOST_STATIC_ASSERT(
      boost::is_base_of<MicroArchitecturalState<
                            MicroArchState, typename MicroArchState::StateDep>,
                        MicroArchState>::value);
  // We require the operator<< for states
  BOOST_STATIC_ASSERT(
      boost::has_left_shift<std::ostream, MicroArchState>::value);

protected:
  /**
   * Initialise this analysis information according to init, i.e. either BOTTOM,
   * TOP, or START.
   */
  explicit StateExplorationDomainBase(AnaDomInit init);
  /**
   * Copy constructor.
   */
  StateExplorationDomainBase(const StateExplorationDomainBase &sed);
  /**
   * Assignment operator
   */
  StateExplorationDomainBase &
  operator=(const StateExplorationDomainBase &other);

public:
  /**
   * Identifier for debugging purposes
   */
  static std::string analysisName(const char *prefix) {
    return std::string(prefix) + "SED";
  }

  /// When is analysis information required by state graph construction
  static bool anainfoBeforeRequired(const MachineInstr *MI) {
    return (MI == getFirstInstrInBB(MI->getParent())) || MI->isCall();
  }
  static bool anainfoAfterRequired(const MachineInstr *MI) {
    return MI->isCall() || isEndInstr(*MI->getParent(), MI);
  }

  // Make StateDep usable again
  typedef typename MicroArchState::StateDep StateDep;

  typedef MicroArchState State;

  /**
   * See superclass first.
   * This transfer function should wrap the cycle-based microarchitectural
   * semantics of MicroArchState to a instruction-level behaviour on a CFG-like
   * structure.
   */
  void transfer(const MachineInstr *MI, Context *currentCtx, StateDep &anaInfo);
  /**
   * This is a helper function for transfer. It wraps the cycle-based
   * microarchitectural semantics of MicroArchState to a instruction-level
   * behaviour on a CFG-like structure.
   */
  void cycleUntilFinal(typename MicroArchState::StateSet &workingSet,
                       typename MicroArchState::StateSet &resultSet,
                       unsigned instrAddress, Context *currentCtx,
                       StateDep &anaInfo) const;
  /**
   * See superclass first.
   * This guard does the following:
   * If this analysis information is neither bottom nor top:
   * Remove those elements from the set of states whose branchAssumptions do not
   * coincide with the given branch outcome at the given branch.
   */
  void guard(const MachineInstr *MI, Context *currentCtx, StateDep &anaInfo,
             BranchOutcome bo);

  /**
   * See superclass first.
   * First cycle until the call instruction is final. This is then the callee-in
   * info. Then take the calleeOut information, filter on taking the correct
   * return instruction, and return it as afterCallInfo.
   */
  StateExplorationDom<MicroArchState>
  transferCall(const MachineInstr *callInstr, Context *ctx, StateDep &anaInfo,
               const MachineFunction *callee,
               StateExplorationDom<MicroArchState> &calleeOut);
  /**
   * See superclass first.
   * On entering a bsaic block, the basic-block related timings are reseted -
   * independent of mbb.
   */
  void enterBasicBlock(const MachineBasicBlock *mbb);
  /**
   * See superclass first.
   * Joins sets of states. This is typically set union.
   */
  void join(const StateExplorationDom<MicroArchState> &element);
  /**
   * See superclass first.
   * Checks for set inclusion.
   */
  bool lessequal(const StateExplorationDom<MicroArchState> &element) const;
  // see superclass
  std::string print() const;

  typename MicroArchState::StateSet getStates() const;

  // See superclass
  bool isBottom() const { return states.size() == 0; }

private:
  /**
   * The set of microarchitectural states that represents the analysis
   * information at the current program point.
   */
  typename MicroArchState::StateSet states;
  /**
   * We reached a top state. We cannot do any menaingful analysis anymore and
   * will crash on next opportunity. The analysis should try to not reach a top
   * state.
   */
  bool top;

  /**
   * Helper function for inserting (and possibly joining elements) on
   * instruction granularity
   */
  static inline void insertOnInstr(typename MicroArchState::StateSet &states,
                                   const MicroArchState &mas) {
    states.insert(mas);
  }
  /**
   * Helper function for inserting (and possibly joining elements) on cycle
   * granularity
   */
  static inline void insertOnCycle(typename MicroArchState::StateSet &states,
                                   const MicroArchState &mas) {
    states.insert(mas);
  }
  /**
   * Helper function for inserting (and possibly joining elements) on basic
   * block granularity
   */
  static inline void
  insertOnBasicBlock(typename MicroArchState::StateSet &states,
                     const MicroArchState &mas) {
    states.insert(mas);
  }
};

template <template <class> class StateExplorationDom, class MicroArchState>
StateExplorationDomainBase<StateExplorationDom, MicroArchState>::
    StateExplorationDomainBase(AnaDomInit init) {
  switch (init) {
  case AnaDomInit::BOTTOM: {
    // states should be empty as not state can reach and unreachable part
    top = false;
    assert(states.size() == 0 &&
           "Bottom element constructed has non-empty state set");
    break;
  }
  case AnaDomInit::START: {
    top = false;
    // Get initial program start as this is needed for setting the pc correctly
    // in MicroArchState
    auto MF = getAnalysisEntryPoint();
    std::list<MBBedge> initialedgelist;
    const MachineInstr *firstInstr =
        getFirstInstrInFunction(MF, initialedgelist);
    // Build the correct initial context
    Context ctx;
    if (DirectiveHeuristicsPassInstance->hasDirectiveOnCall(MF)) {
      ctx.update(DirectiveHeuristicsPassInstance->getDirectiveOnCall(MF));
    }
    for (auto edgeit = initialedgelist.begin(); edgeit != initialedgelist.end();
         ++edgeit) {
      if (DirectiveHeuristicsPassInstance->hasDirectiveOnEdgeEnter(*edgeit)) {
        for (auto direc :
             *DirectiveHeuristicsPassInstance->getDirectiveOnEdgeEnter(
                 *edgeit)) {
          ctx.update(direc);
        }
      }
      ctx.transfer(*edgeit);
      if (DirectiveHeuristicsPassInstance->hasDirectiveOnEdgeLeave(*edgeit)) {
        for (auto direc :
             *DirectiveHeuristicsPassInstance->getDirectiveOnEdgeLeave(
                 *edgeit)) {
          ctx.update(direc);
        }
      }
    }
    if (DirectiveHeuristicsPassInstance->hasDirectiveBeforeInstr(firstInstr)) {
      ctx.update(
          DirectiveHeuristicsPassInstance->getDirectiveBeforeInstr(firstInstr));
    }
    // Construct initial, empty MicroArchState with pc set to program beginning
    ProgramLocation progLoc(firstInstr, ctx);
    states.insert(MicroArchState(progLoc));
    break;
  }
  case AnaDomInit::TOP: {
    // We actually do not want to build top states as we cannot handle them
    top = true;
    break;
  }
  }
}

template <template <class> class StateExplorationDom, class MicroArchState>
StateExplorationDomainBase<StateExplorationDom, MicroArchState>::
    StateExplorationDomainBase(const StateExplorationDomainBase &sed) {
  top = sed.top;
  // Copy all states (deep copy) and insert them into our set
  for (auto &st : sed.states) {
    states.insert(MicroArchState(st));
  }
}

template <template <class> class StateExplorationDom, class MicroArchState>
StateExplorationDomainBase<StateExplorationDom, MicroArchState> &
StateExplorationDomainBase<StateExplorationDom, MicroArchState>::operator=(
    const StateExplorationDomainBase &other) {
  this->top = other.top;
  this->states.clear();
  for (auto &st : other.states) {
    this->states.insert(MicroArchState(st));
  }
  return *this;
}

template <template <class> class StateExplorationDom, class MicroArchState>
void StateExplorationDomainBase<StateExplorationDom, MicroArchState>::transfer(
    const MachineInstr *MI, Context *currentCtx, StateDep &anaInfo) {
  DEBUG_WITH_TYPE(
      "instructions",
      dbgs()
          << "Micro-architectural analysis currently processes instruction:\n"
          << *MI << "\n");
  typename MicroArchState::StateSet workingSet;
  workingSet.insert(this->states.begin(), this->states.end());
  this->states.clear();
  // Cycle until the given instruction is final
  cycleUntilFinal(workingSet, this->states, StaticAddrProvider->getAddr(MI),
                  currentCtx, anaInfo);

  // If the program ends, i.e. a state returned to the initial link register,
  // cycle until the following sync instruction is completed.
  if (MI->getParent()->getParent()->getName().str() == AnalysisEntryPoint &&
      MI->getParent()->succ_empty() && MI->isReturn()) {
    assert((MI == (const MachineInstr *)&MI->getParent()->back()) &&
           "Return to external should be last instruction.");
    typename MicroArchState::StateSet endprogWorkingSet;
    for (auto stateit = this->states.begin(); stateit != this->states.end();) {
      MicroArchState copy(*stateit);
      if (copy.assumedReturnedFromMain()) {
        endprogWorkingSet.insert(*stateit);
        stateit = this->states.erase(stateit);
      } else {
        ++stateit;
      }
    }
    Context emptyCtx;
    cycleUntilFinal(endprogWorkingSet, this->states, getInitialLinkRegister(),
                    &emptyCtx, anaInfo);
  }
}

#if 1
template <template <class> class StateExplorationDom, class MicroArchState>
void StateExplorationDomainBase<StateExplorationDom, MicroArchState>::
    cycleUntilFinal(typename MicroArchState::StateSet &workingSet,
                    typename MicroArchState::StateSet &resultSet,
                    unsigned instrAddress, Context *currentCtx,
                    StateDep &anaInfo) const {
  assert(!top &&
         "Analysis cannot update top states, it would diverge otherwise");
  // For each state in our set do cycle() updates until isFinal(MI, currentCtx)
  // is true

  typename MicroArchState::StateSet intermediateResults;

  auto ee = std::make_pair(instrAddress, *currentCtx);
  while (workingSet.size() > 0) {
    MicroArchState copy(*workingSet.begin());
    workingSet.erase(workingSet.begin());
    // If final, then insert it into (output) states
    if (copy.isFinal(ee)) {
      StateExplorationDom<MicroArchState>::insertOnInstr(resultSet, copy);
    } else {
      // Else compute successor and add them to the workingset
      for (auto &succ : copy.cycle(anaInfo)) {
        if (succ.isWaitingForJoin()) {
          // if the state recommends to try
          // joining it with others in a set
          // of intermediate results, do this
          StateExplorationDom<MicroArchState>::insertOnInstr(
              intermediateResults, succ);
        } else {
          StateExplorationDom<MicroArchState>::insertOnCycle(workingSet, succ);
        }
      }
    }

    // if the working set is empty, but we have some intermediate results,
    // use them to fill up the working set again.
    if (workingSet.empty() && !intermediateResults.empty()) {
      workingSet.insert(intermediateResults.begin(), intermediateResults.end());
      intermediateResults.clear();
    }
  }
}

#else
template <template <class> class StateExplorationDom, class MicroArchState>
void StateExplorationDomainBase<StateExplorationDom, MicroArchState>::
    cycleUntilFinal(typename MicroArchState::StateSet &workingSet,
                    typename MicroArchState::StateSet &resultSet,
                    unsigned instrAddress, Context *currentCtx,
                    StateDep &anaInfo) const {
  assert(!top &&
         "Analysis cannot update top states, it would diverge otherwise");
  // For each state in our set do cycle() updates until isFinal(MI, currentCtx)
  // is true

  // Set to implement the waitingForJoin-"Barrier"
  typename MicroArchState::StateSet intermediateResults;

  auto ee = std::make_pair(instrAddress, *currentCtx);
  // For all States
  while (workingSet.size() > 0) {
    // Take one state called <copy>
    // MicroArchState copy(*workingSet.begin());
    // workingSet.erase(workingSet.begin());

    typename MicroArchState::StateSet workingSetForCopy;
    // workingSetForCopy.insert(copy);
    workingSetForCopy.emplace(*workingSet.begin());
    workingSet.erase(workingSet.begin());

    // Used to prevent duplicates while cycling copy
    typename MicroArchState::StateSet alreadyKnown;

    // First handle all successors of copy until the barrier
    while (workingSetForCopy.size() > 0) {
      MicroArchState curr(*workingSetForCopy.begin());
      workingSetForCopy.erase(workingSetForCopy.begin());

      // If final, then insert it into (output) states
      if (curr.isFinal(ee)) {
        StateExplorationDom<MicroArchState>::insertOnInstr(resultSet, curr);
      } else {
        // Else compute successor and add them to the workingset
        for (auto &succ : curr.cycle(anaInfo)) {
          if (alreadyKnown.count(succ) == 0) {
            if (succ.isWaitingForJoin()) {
              // if the state recommends to try
              // joining it with others in a set
              // of intermediate results, do this
              StateExplorationDom<MicroArchState>::insertOnInstr(
                  intermediateResults, succ);
            } else {
              StateExplorationDom<MicroArchState>::insertOnCycle(
                  workingSetForCopy, succ);
            }
            // remember that we have already seen this successor
            alreadyKnown.insert(succ);
          }
        }
      }
    }

    // if the working set is empty, but we have some intermediate results,
    // use them to fill up the working set again.
    if (workingSet.empty() && !intermediateResults.empty()) {
      workingSet.insert(intermediateResults.begin(), intermediateResults.end());
      intermediateResults.clear();
    }
  }
}
#endif

template <template <class> class StateExplorationDom, class MicroArchState>
void StateExplorationDomainBase<StateExplorationDom, MicroArchState>::guard(
    const MachineInstr *MI, Context *currentCtx, StateDep &anaInfo,
    BranchOutcome bo) {
  // For branches and returns
  assert((MI->isBranch() || MI->isReturn()) &&
         "Guarding on non-(branch/pred return)");
  auto progLoc = std::make_pair(MI, *currentCtx);

  typename MicroArchState::StateSet workingSet = states;
  states.clear();

  for (auto stateIter = workingSet.begin(); stateIter != workingSet.end();
       ++stateIter) {
    MicroArchState copy(*stateIter);

    // When state assumed the same outcome as po, add it to the result set
    bool assumedTaken = copy.assumedBranchOutcome(progLoc, bo);
    if (assumedTaken) {
      states.insert(copy);
    }
  }
}

template <template <class> class StateExplorationDom, class MicroArchState>
StateExplorationDom<MicroArchState>
StateExplorationDomainBase<StateExplorationDom, MicroArchState>::transferCall(
    const MachineInstr *callInstr, Context *ctx, StateDep &anaInfo,
    const MachineFunction *callee,
    StateExplorationDom<MicroArchState> &calleeOut) {
  // FIXME handle predicated call instructions?

  assert(this->states.size() != 0 &&
         "No transfer Call on unreachable code allowed!");

  auto callTarget = callInstr->getOperand(0); // Get Call Target

  auto &cg = CallGraph::getGraph();
  if (cg.callsExternal(callInstr)) {
    if (callTarget.isSymbol()) {
      assert(callee == nullptr && "Cannot have function for external callee");
    } else {
      auto val = (const Value *)callTarget.getGlobal();
      std::string funcName = val->getName().str();
      assert(!machineFunctionCollector->hasFunctionByName(funcName) &&
             "Ext func is not external");
    }

    // First cycle until the call instruction is final. This is then the
    // callee-in info.
    this->transfer(callInstr, ctx, anaInfo);

    // Cycle sync instruction until final after the call instruction going
    // external
    typename MicroArchState::StateSet preSyncStates;
    preSyncStates.insert(this->states.begin(), this->states.end());
    this->states.clear();
    auto syncAddr =
        cg.getExtFuncStartAddress(cg.getExternalCalleeName(callInstr));
    cycleUntilFinal(preSyncStates, this->states, syncAddr, ctx, anaInfo);

    // Return value
    StateExplorationDom<MicroArchState> retVal(AnaDomInit::BOTTOM);

    if (RestartAfterExternal) {
      // Add one new MicroArchState with specific pc=(addr of callInstr +
      // 4,*ctx) and time set
      Context afterCallCtx(*ctx);
      if (DirectiveHeuristicsPassInstance->hasDirectiveAfterInstr(callInstr)) {
        afterCallCtx.update(
            DirectiveHeuristicsPassInstance->getDirectiveAfterInstr(callInstr));
      }
      auto addr = StaticAddrProvider->getAddr(callInstr);
      auto afterCallInstr = StaticAddrProvider->getMachineInstrByAddr(addr + 4);

      if (DirectiveHeuristicsPassInstance->hasDirectiveBeforeInstr(
              afterCallInstr)) {
        afterCallCtx.update(
            DirectiveHeuristicsPassInstance->getDirectiveBeforeInstr(
                afterCallInstr));
      }
      ProgramLocation progLoc(afterCallInstr, afterCallCtx);
      MicroArchState restartState(progLoc);
      restartState.resetLocalMetrics();
      retVal.states.insert(restartState);
    } else {
      retVal.top = true;
    }
    return retVal;
  } else {
    assert(callee != nullptr && "Cannot handle call to non-existing callee");
    // First cycle until the call instruction is final. This is then the
    // callee-in info.
    this->transfer(callInstr, ctx, anaInfo);
    // TODO do the filtering on the given callee being called (only needed for
    // multiple callees)

    // Take the calleeOut information, filter on taking the correct return
    // instruction and return it as afterCallInfo
    StateExplorationDom<MicroArchState> retVal(AnaDomInit::BOTTOM);
    for (auto &state : calleeOut.states) {
      MicroArchState copy(state);
      // If the state corresponds to the given return location, we use it
      if (copy.assumedReturnedTo(std::make_pair(callInstr, *ctx))) {
        copy.resetLocalMetrics();
        StateExplorationDom<MicroArchState>::insertOnInstr(retVal.states, copy);
      }
    }
    return retVal;
  }
}

template <template <class> class StateExplorationDom, class MicroArchState>
void StateExplorationDomainBase<StateExplorationDom, MicroArchState>::
    enterBasicBlock(const MachineBasicBlock *mbb) {
  // We currently reset the local metrics per basic block.
  typename MicroArchState::StateSet tmp;
  for (auto &st : states) {
    MicroArchState copy(st);
    copy.resetLocalMetrics();
    StateExplorationDom<MicroArchState>::insertOnBasicBlock(tmp, copy);
  }
  this->states = tmp;
}

template <template <class> class StateExplorationDom, class MicroArchState>
void StateExplorationDomainBase<StateExplorationDom, MicroArchState>::join(
    const StateExplorationDom<MicroArchState> &element) {
  // Top handling
  if (top) {
    return;
  }
  if (element.top) {
    errs() << "[Attention] We are setting states to top\n";
    top = true;
    return;
  } // set union (with potential merging of states) is join for this powerset
    // domains
  for (auto &state : element.states) {
    StateExplorationDom<MicroArchState>::insertOnInstr(this->states, state);
  }
}

template <template <class> class StateExplorationDom, class MicroArchState>
bool StateExplorationDomainBase<StateExplorationDom, MicroArchState>::lessequal(
    const StateExplorationDom<MicroArchState> &element) const {
  if (element.top) // Everything is less or equal than top
    return true;
  if (top) // We are top and element is not
    return false;
  // return false if any state is not included in element.states
  for (auto &st : states) {
    if (element.states.count(st) == 0)
      return false;
  }
  // all elements found
  return true;
}

template <template <class> class StateExplorationDom, class MicroArchState>
std::string
StateExplorationDomainBase<StateExplorationDom, MicroArchState>::print() const {
  std::stringstream stream;
  if (top) {
    stream << "TOP";
  } else if (states.empty()) {
    stream << "BOT";
  } else {
    stream << "[\n";
    // Dump the states
    unsigned i = 0;
    for (auto &st : states) {
      stream << "[STATE " << i++ << ":\n";
      stream << st << "\n";
    }
    stream << "]";
  }
  return stream.str();
}

template <template <class> class StateExplorationDom, class MicroArchState>
typename MicroArchState::StateSet
StateExplorationDomainBase<StateExplorationDom, MicroArchState>::getStates()
    const {
  return states;
}

//////////////////////////////////////////////
// State Exploration Domain Without Joining //
//////////////////////////////////////////////

/**
 * Template class that implements a state space exploration domain with joining.
 * First, see superclass description.
 * Additionally it implements joining of pipeline states, i.e. the set of states
 * never contains two states that could be joined. This invariant is
 * re-established after each transfer und join.
 */
template <class MicroArchState>
class StateExplorationDomain
    : public StateExplorationDomainBase<StateExplorationDomain,
                                        MicroArchState> {
private:
  typedef StateExplorationDomainBase<StateExplorationDomain, MicroArchState>
      Super;

public:
  /**
   * Initialise this analysis information according to init, i.e. either BOTTOM,
   * TOP, or START.
   */
  explicit StateExplorationDomain(AnaDomInit init) : Super(init) {}
};

//////////////////////////////////////
// Joining State Exploration Domain //
//////////////////////////////////////

/**
 * Template class that implements a state space exploration domain with joining.
 * First, see superclass description.
 * Additionally it implements joining of pipeline states, i.e. the set of states
 * never contains two states that could be joined. This invariant is
 * re-established after each transfer und join.
 */
template <class MicroArchState>
class StateExplorationWithJoinDomain
    : public StateExplorationDomainBase<StateExplorationWithJoinDomain,
                                        MicroArchState> {
private:
  typedef StateExplorationDomainBase<StateExplorationWithJoinDomain,
                                     MicroArchState>
      Super;

public:
  /**
   * Initialise this analysis information according to init, i.e. either BOTTOM,
   * TOP, or START.
   */
  explicit StateExplorationWithJoinDomain(AnaDomInit init) : Super(init) {}
  // Default copy constructor and default assignment operator are okay

  static inline void
  insertOnBasicBlock(typename MicroArchState::StateSet &states,
                     const MicroArchState &mas) {
    // Do the same joining procedure on bais block entries as doing for
    // instructions
    insertOnInstr(states, mas);
  }

  static inline void insertOnInstr(typename MicroArchState::StateSet &states,
                                   const MicroArchState &mas) {
    // do nothing if mas is already in states
    if (states.count(mas) == 0) {
      // Do the joining if possible
      for (auto &st : states) {
        assert(st.isJoinable(mas) == mas.isJoinable(st) &&
               "isJoinable is not commutative");
        // Found join partner
        if (st.isJoinable(mas)) {
          MicroArchState stCopy(st);
          states.erase(st);
          stCopy.join(mas);
          states.insert(stCopy);
          // There is only one element we can join, as states is minimal and
          // isJoinable is transitive
          return;
        }
      }
      // No join partner found (would have returned otherwise), thus normal
      // insertion
      states.insert(mas);
    }
  }
};

} // namespace TimingAnalysisPass

#endif
