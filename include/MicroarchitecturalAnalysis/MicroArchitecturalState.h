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

#ifndef MICROARCHITECTURALSTATE_H
#define MICROARCHITECTURALSTATE_H

#include "AnalysisFramework/CallGraph.h"
#include "LLVMPasses/MachineFunctionCollector.h"
#include "LLVMPasses/TimingAnalysisMain.h"
#include "MicroarchitecturalAnalysis/ProgramCounter.h"
#include "PreprocessingAnalysis/AddressInformation.h"
#include "Util/IntervalCounter.h"

#include "ARM.h"
#include "llvm/CodeGen/MachineJumpTableInfo.h"

#include <boost/optional/optional.hpp>
#include <boost/static_assert.hpp>
#include <boost/type_traits.hpp>

#include <set>
#include <unordered_set>

namespace TimingAnalysisPass {

// Needed forward declaration due to cyclic dependency of
// MicroArchitecturalState and StateHash
template <class T, class D> class StateHash;

/// typedef for argument passing
typedef std::pair<const llvm::MachineInstr *, Context> ProgramLocation;

/**
 * Class implementing a cycle-based microarchitectural semantics.
 *
 * This abstract class defines the interface that any microarchitectural state
 * has to fulfill. (See ASSERT in StateExplorationDomain.h). At the same time,
 * it provides some state information that is common to all states, such as e.g.
 * information about the current time. It might also provide some auxiliary
 * method that is used in the subclasses, e.g. to realise fetching policies and
 * similar things.
 */
template <class DerivedState, class Dependencies>
class MicroArchitecturalState {
public:
  /**
   * Typedef an unordered hash-set of microarchitectural states with specific
   * hashing capabilities.
   */
  typedef std::unordered_set<DerivedState,
                             StateHash<DerivedState, Dependencies>>
      StateSet;

  template <typename T>
  using MapFromStates =
      std::unordered_map<DerivedState, T,
                         StateHash<DerivedState, Dependencies>>;

  typedef Dependencies StateDep;

  typedef IntervalCounter<true, true, true> TimeType;

  /**
   * Constructor. Store the program counter.
   */
  MicroArchitecturalState(ProgramLocation &progloc)
      : time(0),
        pc(StaticAddrProvider->getAddr(progloc.first), progloc.second) {}
  /**
   * Copy constructor
   */
  MicroArchitecturalState(const MicroArchitecturalState &st)
      : time(st.time), pc(st.pc),
        condBranchAssumptions(st.condBranchAssumptions),
        returnAssumptions(st.returnAssumptions) {}

  /**
   * Virtual destructor
   */
  virtual ~MicroArchitecturalState() {
    // Cleanup is done automatically by object destruction as only non-pointer
    // types
  }

  /**
   * Container used to make the local metrics of this class
   * available to the world outside.
   */
  struct LocalMetrics {
    // the fields added to the local metrics used as base
    TimeType time;

    /**
     * Creates the local metrics based on the
     * outer class' content.
     */
    LocalMetrics(const MicroArchitecturalState &outerClassInstance)
        : time(outerClassInstance.time) {}

    /**
     * Checks for equality between local metrics.
     */
    bool operator==(const LocalMetrics &anotherInstance) {
      return time == anotherInstance.time;
    }
  };

  /**
   * Resets the local metrics to their initial values.
   */
  void resetLocalMetrics() { this->time = 0; }

  /**
   * Evolve one cycle on current state. This defines a cycle-based semantics of
   * the microarchitecture. Potential non-determinism might lead to splits and
   * thus multiple successor states. These possible successor states are
   * returned. ins2ctx contains the contexts that are alive at certain
   * instruction such as calls.
   */
  virtual StateSet cycle(StateDep &dep) const = 0;

  /**
   * Checks whether this is a final state for the given instruction.
   * This is used to map states back to instructions and thus to store them.
   * One possibility is to call a state final if the oldest instance of MI
   * has left the pipeline in the previous cycle.
   *
   * If isFinal returns true, the state can be changed in a way, that a second
   * isFinal-call can yield false. This is up to the concrete implementation. So
   * call isFinal only once on a state.
   */
  virtual bool isFinal(ExecutionElement &pl) = 0;

  /**
   * Is the micro-architectural state waiting to be joined with similar states?
   *
   * The default value is false if not overwritten by something else.
   */
  virtual bool isWaitingForJoin() const { return false; }

  /**
   * Return true if the given state ds can be joined with this state.
   * This operation should be an equivalence relation, especially commutative
   * and transitive. Note that if they are equal they are joined anyway. The
   * implementation below is for unjoinable states. Attention: If overridden,
   * you have to override join as well.
   */
  virtual bool isJoinable(const DerivedState &ds) const {
    return time.isJoinable(ds.time) && pc == ds.pc &&
           condBranchAssumptions == ds.condBranchAssumptions &&
           returnAssumptions == ds.returnAssumptions;
  }

  /**
   * Join this state with the given one, ds.
   * Assert if they are not joinable.
   * Attention: If overridden, you should also override isJoinable as well to
   * have an effect.
   */
  virtual void join(const DerivedState &ds) {
    assert(isJoinable(ds) && "Cannot join unjoinable states");

    time.join(ds.time);
  }

  /**
   * Returns true if the given program location (which must be a branch) was
   * assumed to be according to the branch outcome bo. Return false if this is
   * not the case. Assert if the state assumed nothing about this branch. This
   * function changes the state as the requested branch is deleted from the
   * assumption list.
   */
  bool assumedBranchOutcome(const ProgramLocation &pl, const BranchOutcome &bo);

  /**
   * Returns true of this state evolved under the assumption that control-flow
   * returned to the given ProgramLocation (Instruction and Context). Return
   * false otherwise. If true is returned, this function changes the state as
   * the assumed return is delete from the corresponding assumption list.
   */
  bool assumedReturnedTo(const ProgramLocation &pl);
  std::pair<const llvm::MachineInstr *, Context> assumedCallSite() const;
  bool assumedReturnedFromMain();

  /**
   * We require every microarchitectural state to define an equality in order to
   * use if for unordered_(set|map|...) operations
   */
  virtual bool operator==(const DerivedState &ds) const {
    return time == ds.time && pc == ds.pc &&
           condBranchAssumptions == ds.condBranchAssumptions &&
           returnAssumptions == ds.returnAssumptions;
  }
  /**
   * We require a hash function for every microarchitectural state to be used
   * with unordered_(set|map|...). Must be consistent with operator==, i.e.
   * equal values have same hashes.
   */
  virtual size_t hashcode() const {
    size_t res = 0;
    hash_combine_hashcode(res, this->time);
    hash_combine_hashcode(res, this->pc);
    return res;
  };

protected:
  /**
   * Time potentially elapsed since the last basic block beginning.
   */
  TimeType time;

  /**
   * Storing the current pc, i.e. the address (together with the context if any)
   * to fetch next. Typically the address belongs to a fixed MachineInstr* with
   * a well-defined context. However due to prefetching techniques, we might see
   * addresses that do not belong to known instructions, and/or addresses with
   * an invalid context (i.e. if reaching dead-code).
   */
  ProgramCounter pc;

  /**
   * Vector storing some "context" this state was reached, more precisely
   * which branches show which outcome such that this state is reachable.
   * This is used to sharpen analysis information on branches - from front() to
   * back(). First branches should be handled first. If a branch was used once
   * to sharpen information, forget about it to save space.
   */
  std::vector<std::pair<ExecutionElement, BranchOutcome>> condBranchAssumptions;

  /**
   * Vector storing some "context" this state was reached, more precisely
   * where the latest return instructions returned to.
   * This is used to filter analysis information on returns - from front() to
   * back(); First returns should be handled first. If a return was used once
   * for filtering, forget about it to save space.
   */
  std::vector<ExecutionElement> returnAssumptions;

  /**
   * Handle control-flow changing instructions (branching, calling, and
   * returning). If ee is not ca control-flow changing instruction, assert.
   *
   * Adjust the internal pc accordingly as if the branch would have been taken.
   * This involves context and address updates.
   *
   * In case there is an alternative branch outcome, or several additional
   * possible successor states (as in case of return), the alternative
   * possibilities are returned. Otherwise, an empty set is returned.
   *
   * The parameter ins2ctx is a map from instructions to valid contexts at that
   * point. This is useful to resolve return instructions, as we need to know
   * the contexts at the callsite.
   */
  StateSet handleBranching(const ExecutionElement &ee,
                           InstrContextMapping &ins2ctx);

  // Output operation
  friend std::ostream &operator<<(std::ostream &stream,
                                  const MicroArchitecturalState &mas) {
    stream << "[ Branch Vector: ";
    for (auto it = mas.condBranchAssumptions.begin();
         it != mas.condBranchAssumptions.end(); ++it) {
      stream << "(" << it->first << ", " << it->second << ")";
    }
    stream << " ]\n";
    stream << "[ Return Vector: ";
    for (auto it = mas.returnAssumptions.begin();
         it != mas.returnAssumptions.end(); ++it) {
      stream << *it;
    }
    stream << " ]\n";
    stream << "[ " << mas.pc;
    stream << "| Time in this BB: " << mas.time << " ]";
    return stream;
  }

private:
  /**
   * Split: taken and non-taken case
   * Remember what assumed on the split (taken or nottaken) to later do the
   * correct "sharpening"
   */
  StateSet handleBranch(const ExecutionElement &ee);
  /**
   * Handles the PC update that becomes necessary as we branched from source to
   * targetMBB.
   */
  void handlePCUpdate(const ExecutionElement &source,
                      const MachineBasicBlock *targetMBB);
  /**
   * On call, redirect pc to first instruction in the callee and adjust the
   * contexts
   */
  void handleCall(const ExecutionElement &ee);
  /**
   * On return, redirect the pc to the instruction after (+4) the last call
   * instruction. The possible call-sites are retrieved from the callgraph,
   * contexts from ins2ctx
   */
  StateSet handleReturn(const ExecutionElement &ee,
                        InstrContextMapping &ins2ctx);
  /**
   * Takes an execution element ee that represents the new pc after the return.
   * However, its context needs to be adjusted for the things that happen after
   * the return until the execution of the instruction to return to. The context
   * updates includes after callsite (ee.first-4), between callsite and
   * ee.first, and before ee.first.
   */
  Context updateContextOnReturn(const llvm::MachineInstr *callsite,
                                const Context &ctx) const;
};

template <class DerivedState, class Dependencies>
typename MicroArchitecturalState<DerivedState, Dependencies>::StateSet
MicroArchitecturalState<DerivedState, Dependencies>::handleBranching(
    const ExecutionElement &ee, InstrContextMapping &ins2ctx) {
  auto branchInstr = StaticAddrProvider->getMachineInstrByAddr(ee.first);
  assert((branchInstr->isBranch() || branchInstr->isCall() ||
          branchInstr->isReturn()) &&
         "No control-flow changing instruction");

  StateSet alternativeStates;

  if (branchInstr->isBranch()) {
    return handleBranch(ee);
  } else if (branchInstr->isCall()) {
    handleCall(ee);
  } else if (branchInstr->isReturn()) {
    return handleReturn(ee, ins2ctx);
  }

  // On default no alternative state arises
  assert(alternativeStates.empty() &&
         "Branch handling should not have alternative successors");
  return alternativeStates;
}

template <class DerivedState, class Dependencies>
typename MicroArchitecturalState<DerivedState, Dependencies>::StateSet
MicroArchitecturalState<DerivedState, Dependencies>::handleBranch(
    const ExecutionElement &ee) {
  StateSet alternativeStates;

  auto branchInstr = StaticAddrProvider->getMachineInstrByAddr(ee.first);
  assert(branchInstr->isBranch() && "No branch instruction found");

  // Make a copy
  DerivedState *thisRef = dynamic_cast<DerivedState *>(this);
  assert(
      thisRef &&
      "[Internal error] We could not cast a microarch state to its subclass.");
  DerivedState thisCopy(*thisRef);

  if (isJumpTableBranch(branchInstr)) {
    // Jump table branch
    auto JTindex = getJumpTableIndex(branchInstr);
    auto &MJTEs = branchInstr->getParent()
                      ->getParent()
                      ->getJumpTableInfo()
                      ->getJumpTables();
    auto &targetMBBs = MJTEs[JTindex].MBBs;
    assert(targetMBBs.size() >= 1 && "Empty jump table");
    // We always jump
    auto tgtmbbit = targetMBBs.begin();
    this->handlePCUpdate(ee, *tgtmbbit);
    this->condBranchAssumptions.push_back(
        std::make_pair(ee, BranchOutcome::taken(*tgtmbbit)));
    ++tgtmbbit;
    for (; tgtmbbit != targetMBBs.end(); ++tgtmbbit) {
      DerivedState alternative(thisCopy);
      alternative.handlePCUpdate(ee, *tgtmbbit);
      alternative.condBranchAssumptions.push_back(
          std::make_pair(ee, BranchOutcome::taken(*tgtmbbit)));
      alternativeStates.insert(alternative);
    }
  } else if (branchInstr->isConditionalBranch()) {
    // Normal branch
    DerivedState notTaken(thisCopy);
    notTaken.condBranchAssumptions.push_back(
        std::make_pair(ee, BranchOutcome::nottaken()));
    alternativeStates.insert(notTaken);

    assert(getBranchTargetOperand(branchInstr).isMBB() &&
           "First operand of a branch should be MBB");
    auto targetMBB = getBranchTargetOperand(branchInstr).getMBB();
    this->condBranchAssumptions.push_back(
        std::make_pair(ee, BranchOutcome::taken(targetMBB)));
    this->handlePCUpdate(ee, targetMBB);
  } else {
    assert(branchInstr->isUnconditionalBranch() &&
           "Expected non-conditional branch");
    // Unconditional branch, set unreachable
    assert(getBranchTargetOperand(branchInstr).isMBB() &&
           "First operand of a branch should be MBB");
    auto targetMBB = getBranchTargetOperand(branchInstr).getMBB();
    this->handlePCUpdate(ee, targetMBB);
  }

  return alternativeStates;
}

template <class DerivedState, class Dependencies>
void MicroArchitecturalState<DerivedState, Dependencies>::handlePCUpdate(
    const ExecutionElement &source, const MachineBasicBlock *targetMBB) {
  auto branchInstr = StaticAddrProvider->getMachineInstrByAddr(source.first);
  assert(branchInstr->isBranch() && "No branch instruction found");
  // For the taken case (represented by this) adjust the pc to the jump target
  std::list<MBBedge> edges;
  edges.push_back(std::make_pair(branchInstr->getParent(), targetMBB));
  while (
      isBasicBlockEmpty(targetMBB)) { // This is a empty MBB, jump to next one
    assert(targetMBB->succ_size() == 1 &&
           "Empty BB can only have one successor");
    assert(targetMBB->isLayoutSuccessor(*targetMBB->succ_begin()) &&
           "Empty BB non layout succ");
    edges.push_back(std::make_pair(targetMBB, *targetMBB->succ_begin()));
    targetMBB = *targetMBB->succ_begin();
  }
  auto targetInstr = getFirstInstrInBB(targetMBB);

  // Target context updates
  unsigned targetPCaddr = StaticAddrProvider->getAddr(targetInstr);
  Context targetPCctx(source.second);
  if (DirectiveHeuristicsPassInstance->hasDirectiveAfterInstr(branchInstr)) {
    targetPCctx.update(
        DirectiveHeuristicsPassInstance->getDirectiveAfterInstr(branchInstr));
  }
  for (auto edgeit = edges.begin(); edgeit != edges.end(); ++edgeit) {
    if (DirectiveHeuristicsPassInstance->hasDirectiveOnEdgeEnter(*edgeit)) {
      for (auto direc :
           *DirectiveHeuristicsPassInstance->getDirectiveOnEdgeEnter(*edgeit)) {
        targetPCctx.update(direc);
      }
    }
    targetPCctx.transfer(*edgeit);
    if (DirectiveHeuristicsPassInstance->hasDirectiveOnEdgeLeave(*edgeit)) {
      for (auto direc :
           *DirectiveHeuristicsPassInstance->getDirectiveOnEdgeLeave(*edgeit)) {
        targetPCctx.update(direc);
      }
    }
  }
  if (DirectiveHeuristicsPassInstance->hasDirectiveBeforeInstr(targetInstr)) {
    targetPCctx.update(
        DirectiveHeuristicsPassInstance->getDirectiveBeforeInstr(targetInstr));
  }
  this->pc.setPc(std::make_pair(targetPCaddr, targetPCctx));
}

template <class DerivedState, class Dependencies>
void MicroArchitecturalState<DerivedState, Dependencies>::handleCall(
    const ExecutionElement &ee) {
  auto branchInstr = StaticAddrProvider->getMachineInstrByAddr(ee.first);
  assert(branchInstr->isCall() && "No call instruction found");

  CallGraph &cg = CallGraph::getGraph();
  if (cg.callsExternal(branchInstr)) {
    auto functionName = cg.getExternalCalleeName(branchInstr);
    unsigned nextpc = cg.getExtFuncStartAddress(functionName);
    this->pc.setAddress(nextpc);
  } else {
    // Collect some stuff
    auto callTarget = branchInstr->getOperand(0);
    std::string functionName = cg.getCalleeNameFromOperand(callTarget);
    auto callee = machineFunctionCollector->getFunctionByName(functionName);
    std::list<MBBedge> initialedgelist;
    const MachineInstr *calleeFirstInstr =
        getFirstInstrInFunction(callee, initialedgelist);

    // Set target pc addr
    unsigned targetPCaddr = StaticAddrProvider->getAddr(calleeFirstInstr);

    // Set Target pc context: Reduction on Call and handling of following
    // directives
    Context targetPCctx(ee.second);
    targetPCctx.reduceOnCall();
    if (DirectiveHeuristicsPassInstance->hasDirectiveOnCall(callee)) {
      targetPCctx.update(
          DirectiveHeuristicsPassInstance->getDirectiveOnCall(callee));
    }
    // Potentially saw a context edge if the first BB in callee was empty
    for (auto &edge : initialedgelist) {
      if (DirectiveHeuristicsPassInstance->hasDirectiveOnEdgeEnter(edge)) {
        for (auto direc :
             *DirectiveHeuristicsPassInstance->getDirectiveOnEdgeEnter(edge)) {
          targetPCctx.update(direc);
        }
      }
      targetPCctx.transfer(edge);
      if (DirectiveHeuristicsPassInstance->hasDirectiveOnEdgeLeave(edge)) {
        for (auto direc :
             *DirectiveHeuristicsPassInstance->getDirectiveOnEdgeLeave(edge)) {
          targetPCctx.update(direc);
        }
      }
    }
    if (DirectiveHeuristicsPassInstance->hasDirectiveBeforeInstr(
            calleeFirstInstr)) {
      targetPCctx.update(
          DirectiveHeuristicsPassInstance->getDirectiveBeforeInstr(
              calleeFirstInstr));
    }

    // Set the new pc
    this->pc.setPc(std::make_pair(targetPCaddr, targetPCctx));
  }
}

template <class DerivedState, class Dependencies>
typename MicroArchitecturalState<DerivedState, Dependencies>::StateSet
MicroArchitecturalState<DerivedState, Dependencies>::handleReturn(
    const ExecutionElement &ee, InstrContextMapping &ins2ctx) {
  StateSet alternativeStates;

  auto branchInstr = StaticAddrProvider->getMachineInstrByAddr(ee.first);
  assert(branchInstr->isReturn() && "No return instruction found");

  Context returnCtx(ee.second);
  if (DirectiveHeuristicsPassInstance->hasDirectiveAfterInstr(branchInstr)) {
    returnCtx.update(
        DirectiveHeuristicsPassInstance->getDirectiveAfterInstr(branchInstr));
  }
  auto currFunc = branchInstr->getParent()->getParent();
  if (DirectiveHeuristicsPassInstance->hasDirectiveOnReturn(currFunc)) {
    returnCtx.update(
        DirectiveHeuristicsPassInstance->getDirectiveOnReturn(currFunc));
  }

  // New program counter to contexts (1st: where to continue after return, 2nd:
  // where to return to)
  std::multimap<unsigned, std::pair<Context, Context>> returnLocations;
  // For all call sites compute possible return locations
  auto callsites =
      CallGraph::getGraph().getCallSites(branchInstr->getParent()->getParent());
  for (auto callsite : callsites) {
    if (ins2ctx.count(callsite) > 0) { // Callsite has contexts
      for (auto &ctx : ins2ctx[callsite]) {
        Context reducedCtx(ctx);
        reducedCtx.reduceOnCall();
        if (returnCtx ==
            reducedCtx) { // We found a valid predecessor context, use it
          auto targetAddr = StaticAddrProvider->getAddr(callsite) + 4;
          Context contCtx = updateContextOnReturn(callsite, ctx);
          returnLocations.insert(
              std::make_pair(targetAddr, std::make_pair(contCtx, ctx)));
        }
      }
    }
  }
  // The entry function might return to its lr register
  if (branchInstr->getParent()->getParent() == getAnalysisEntryPoint()) {
    returnLocations.insert(std::make_pair(
        getInitialLinkRegister(), std::make_pair(Context(), Context())));
  }
  assert(returnLocations.size() > 0 &&
         "We saw a return but have no valid point to return to");

  // This state is just the first possible return locations
  std::pair<unsigned, std::pair<Context, Context>> firstRetLoc;
  if (!isPredicated(branchInstr)) { // Non-predicated return?
    firstRetLoc = *(returnLocations.begin());
    returnLocations.erase(returnLocations.begin());
  }

  // All other possible return locations are handled separately
  for (auto &returnLoc : returnLocations) {
    DerivedState *this_sub = dynamic_cast<DerivedState *>(this);
    assert(this_sub && "[Internal error] We could not cast a microarch state "
                       "to its subclass.");
    DerivedState copyState(*this_sub);
    copyState.pc.setPc(std::make_pair(returnLoc.first, returnLoc.second.first));
    copyState.returnAssumptions.push_back(
        std::make_pair(returnLoc.first, returnLoc.second.second));
    copyState.condBranchAssumptions.push_back(
        std::make_pair(ee, BranchOutcome::taken()));
    alternativeStates.insert(copyState);
  }

  if (!isPredicated(branchInstr)) { // Non-predicated return? Then return first
                                    // return location.
    // Update this current state for the first return location
    this->pc.setPc(std::make_pair(firstRetLoc.first, firstRetLoc.second.first));
    this->returnAssumptions.push_back(
        std::make_pair(firstRetLoc.first, firstRetLoc.second.second));
    this->condBranchAssumptions.push_back(
        std::make_pair(ee, BranchOutcome::taken()));
  } else {
    // Predicated return, keep this unmodified, except branch assumption
    this->condBranchAssumptions.push_back(
        std::make_pair(ee, BranchOutcome::nottaken()));
  }

  return alternativeStates;
}

template <class DerivedState, class Dependencies>
Context
MicroArchitecturalState<DerivedState, Dependencies>::updateContextOnReturn(
    const llvm::MachineInstr *callsite, const Context &ctx) const {
  Context resCtx(ctx);
  assert(callsite->isCall() && "Expected this instruction to be a call");
  auto targetAddr = StaticAddrProvider->getAddr(callsite) + 4;
  auto targetInstr = StaticAddrProvider->getMachineInstrByAddr(targetAddr);
  if (DirectiveHeuristicsPassInstance->hasDirectiveAfterInstr(callsite)) {
    resCtx.update(
        DirectiveHeuristicsPassInstance->getDirectiveAfterInstr(callsite));
  }
  auto srcMBB = callsite->getParent();
  auto targetMBB = targetInstr->getParent();
  if (srcMBB != targetMBB) { // We also have a Basicblock edge to take on return
    auto edgelistset = getEdgesBetween(srcMBB, targetMBB);
    assert(edgelistset->size() == 1 &&
           "More paths from source to target basicblock");
    for (auto &mbbedge : *(edgelistset->begin())) {
      if (DirectiveHeuristicsPassInstance->hasDirectiveOnEdgeEnter(mbbedge)) {
        for (auto &direc :
             *DirectiveHeuristicsPassInstance->getDirectiveOnEdgeEnter(
                 mbbedge)) {
          resCtx.update(direc);
        }
      }
      resCtx.transfer(mbbedge);
      if (DirectiveHeuristicsPassInstance->hasDirectiveOnEdgeLeave(mbbedge)) {
        for (auto &direc :
             *DirectiveHeuristicsPassInstance->getDirectiveOnEdgeLeave(
                 mbbedge)) {
          resCtx.update(direc);
        }
      }
    }
    delete edgelistset;
  }
  if (DirectiveHeuristicsPassInstance->hasDirectiveBeforeInstr(targetInstr)) {
    resCtx.update(
        DirectiveHeuristicsPassInstance->getDirectiveBeforeInstr(targetInstr));
  }
  return resCtx;
}

template <class DerivedState, class Dependencies>
bool MicroArchitecturalState<DerivedState, Dependencies>::assumedBranchOutcome(
    const ProgramLocation &pl, const BranchOutcome &bo) {
  unsigned instrAddr = StaticAddrProvider->getAddr(pl.first);
  assert(!condBranchAssumptions.empty() &&
         "This state has no branch assumptions");
  auto oldestBranchAssumption = condBranchAssumptions.front();
  condBranchAssumptions.erase(condBranchAssumptions.begin());
  assert(oldestBranchAssumption.first.first == instrAddr &&
         oldestBranchAssumption.first.second == pl.second &&
         "No valid assumption about given branch");
  if (bo.btaken) {
    if (bo.target == boost::none) {
      return oldestBranchAssumption.second.btaken;
    } else {
      return oldestBranchAssumption.second == bo;
    }
  } else {
    return !oldestBranchAssumption.second.btaken;
  }
}

template <class DerivedState, class Dependencies>
std::pair<const llvm::MachineInstr *, Context>
MicroArchitecturalState<DerivedState, Dependencies>::assumedCallSite() const {
  auto oldestReturnAssumption = returnAssumptions.front();
  // -4 of the target instruction must be the original callsite
  if (StaticAddrProvider->hasMachineInstrByAddr(oldestReturnAssumption.first -
                                                4)) {
    return std::make_pair(StaticAddrProvider->getMachineInstrByAddr(
                              oldestReturnAssumption.first - 4),
                          oldestReturnAssumption.second);
  } else {
    return std::make_pair(nullptr, Context());
  }
}

template <class DerivedState, class Dependencies>
bool MicroArchitecturalState<DerivedState, Dependencies>::assumedReturnedTo(
    const ProgramLocation &pl) {
  // Latest return
  assert(!returnAssumptions.empty() && "This state has no return assumptions");
  auto oldestReturnAssumption = returnAssumptions.front();
  returnAssumptions.erase(returnAssumptions.begin());
  // Compute return location from given callsite
  auto returnedtoExecEle =
      std::make_pair(StaticAddrProvider->getAddr(pl.first) + 4, pl.second);
  // If return to same callsite in same context
  return oldestReturnAssumption == returnedtoExecEle;
}

template <class DerivedState, class Dependencies>
bool MicroArchitecturalState<DerivedState,
                             Dependencies>::assumedReturnedFromMain() {
  auto oldestReturnAssumption = returnAssumptions.front();
  returnAssumptions.erase(returnAssumptions.begin());

  ExecutionElement returnPoint =
      std::make_pair(getInitialLinkRegister(), Context());
  return oldestReturnAssumption == returnPoint;
}

/**
 * Class wrapping the hashcode() function, that each micorarchitectural state
 * class has to implement, to be used with unordered_(set|map|...). It
 * statically asserts that T must be a subclass of MicroArchitecturalState.
 */
template <class T, class D> class StateHash {
  BOOST_STATIC_ASSERT_MSG(
      (boost::is_base_of<MicroArchitecturalState<T, D>, T>::value),
      "T must be a descendant of MicroArchitecturalState");

public:
  size_t operator()(const T &t) const { return t.hashcode(); }
};

} // namespace TimingAnalysisPass

#endif
