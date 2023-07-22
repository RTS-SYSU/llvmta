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

#ifndef ANALYSISDRIVER_H
#define ANALYSISDRIVER_H

#include "ARM.h"
#include "ARMMachineFunctionInfo.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineJumpTableInfo.h"
#include "llvm/CodeGen/MachineModuleInfo.h"
#include "llvm/IR/Module.h"
#include "llvm/Support/Debug.h"

#include "AnalysisFramework/AnalysisDomain.h"
#include "AnalysisFramework/AnalysisInformation.h"
#include "AnalysisFramework/CollectingContextsDomain.h"
#include "AnalysisFramework/PartitioningDomain.h"
#include "LLVMPasses/MachineFunctionCollector.h"
#include "PartitionUtil/DirectiveHeuristics.h"

#include "Util/Statistics.h"

#include <boost/static_assert.hpp>
#include <boost/type_traits.hpp>

#include <iostream>
#include <list>

namespace TimingAnalysisPass {

// TODO We want to deal with predicated execution of instruction to allow more
// fancy optimizations... Each analysis domain gets PredOutcome = {ALWAYS,
// NEVER, POTENTIALLY} PredOutcome evalPredication(const MachineInstr* ..like
// transfer..) and do accordingly

/**
 * Abstract template class that describes the analysis driver.
 * The driver performs an analysis of given type AnalysisDom on the given
 * Granularity (e.g. machine instructions or basic blocks). The AnalysisDom
 * might depend on information of other analyses (AnalysisDom::AnaDeps). The
 * driver is responsible for providing access to this depend information during
 * the analysis. The analysis is in general interprocedurally.
 */
template <class AnalysisDom, typename Granularity> class AnalysisDriver {

  /**
   * This is a compile-time	assert that we only want this template to be
   * instantiated for classes inheriting and thereby implementing class
   * ContextAwareAnalysisDomain.
   */
  BOOST_STATIC_ASSERT(
      (boost::is_base_of<
          ContextAwareAnalysisDomain<AnalysisDom, Granularity,
                                     typename AnalysisDom::AnaDeps>,
          AnalysisDom>::value));

public:
  /**
   * Type of analysis information this driver computes.
   */
  typedef AnalysisInformation<PartitioningDomain<AnalysisDom, Granularity>,
                              Granularity>
      AnalysisInfo;

  // Make AnaDeps visible again
  typedef typename AnalysisDom::AnaDeps AnaDeps;

  /**
   * Constructor, takes the entry point for this analysis, and valid analysis
   * information for the analyses AnaDeps as AnalysisDom depends on them.
   */
  AnalysisDriver(std::string entrypoint, AnaDeps anaDeps)
      : entrypoint(entrypoint), analysisResults(anaDeps) {}

  /**
   * Perform the analysis of type AnalysisDom on function given by entrypoint on
   * granularity Granularity and provide analysis information at the end.
   * This computation will typically involve a fixed point iteration.
   * As the algorithm depends on the chosen granularity, this function is purely
   * virtual.
   */
  virtual AnalysisInfo *runAnalysis() = 0;

protected:
  /**
   * The entrypoint for which an analysis is about to be done
   * (interprocedurally).
   */
  std::string entrypoint;
  /**
   * References to the analyses information that are required by AnalysisDom.
   */
  AnaDeps analysisResults;
};

///////////////////////////////////////////
/// Granularity on Machine Instructions ///
///////////////////////////////////////////

/**
 * Analysis Driver in the granularity of machine instructions.
 * The iterator is context-aware, i.e. analysis is re-run only for those
 * contexts where information changed before, not for all contexts of a BB.
 * For general description, see the superclass.
 */
template <class AnalysisDom>
class AnalysisDriverInstr : public AnalysisDriver<AnalysisDom, MachineInstr> {
public:
  // Using already defined types
  typedef typename AnalysisDriver<AnalysisDom, MachineInstr>::AnalysisInfo
      AnalysisInfo;
  using typename AnalysisDriver<AnalysisDom, MachineInstr>::AnaDeps;

  /**
   * Constructor, calls the superclass constructor
   */
  AnalysisDriverInstr(std::string entrypoint, AnaDeps anaDeps)
      : AnalysisDriver<AnalysisDom, MachineInstr>(entrypoint, anaDeps),
        mbb2anainfo(new BB2AnaInfoType()), func2anainfo(new Func2AnaInfoType()),
        worklist() {}

  // see superclass
  virtual AnalysisInfo *runAnalysis() override;

private:
  /// Typedef to shorten type name
  typedef PartitioningDomain<AnalysisDom, MachineInstr> PartitionedAnalysisDom;
  /// Typedef: analysis information at entry and exit of a basic block
  typedef InfoInOut<PartitionedAnalysisDom> AnaInfoEntryExit;
  /// Typedef, local map type to store analysis information per basic block
  /// entry
  typedef std::map<const MachineBasicBlock *, PartitionedAnalysisDom>
      BB2AnaInfoType;
  /// Map each basic block entry to analysis information
  std::unique_ptr<BB2AnaInfoType> mbb2anainfo;
  /// Typedef, local map type to store analysis information per function
  typedef std::map<const MachineFunction *, AnaInfoEntryExit> Func2AnaInfoType;
  std::unique_ptr<Func2AnaInfoType> func2anainfo;

  /**
   * Initialize the analysis information maps by putting bottoms everywhere.
   * Puts the first basic block of the analysis entry point into the worklist.
   */
  void initialize();
  /**
   * Analyse one basic block.
   * Transfer functions for each instruction in the basic block are called in
   * the right order. The successor basic block + contexts that are affected by
   * new analysis information are put into the worklist.
   */
  void analyseMachineBasicBlock(const MachineBasicBlock *MBB,
                                const Context &ctx);
  /**
   * Analyse one machine instruction on analysis information newOut.
   * After the invocation, newOut is the analysis information after execution of
   * currentInstr. There are two variants: One that operates on AnlysisDom and
   * one operates on full context-tree.
   *
   * Context-tree:
   * Returns true if a call makes it necessary to recompute dependencies (i.e.
   * callees). The flag is used to check whether we reached a fixed point at the
   * end.
   *
   * AnalysisDom only (Leaf of context-tree):
   * Is used for the context-aware iteration. Puts basicblocks+contexts into
   * worklist if necessary.
   */
  bool analyseInstruction(const MachineInstr *currentInstr,
                          PartitionedAnalysisDom &newOut);
  void analyseInstruction(const MachineInstr *currentInstr, Context &ctx,
                          AnalysisDom &newOut);
  /**
   * Handles brnaching if necessary. This involve executing guard functions;
   * and pushing analysis information at the right places.
   * There are two variants: One that operates on AnlysisDom and one operates on
   * full context-tree.
   *
   * Context-tree:
   * The bool-flag is used to check whether we reached a fixed point at the end.
   *
   * AnalysisDom only (Leaf of context-tree):
   * Is used for the context-aware iteration. Puts basicblocks+contexts into
   * worklist if necessary.
   */
  bool handleBranchInstruction(const MachineInstr *branchInstr,
                               PartitionedAnalysisDom &newOut);
  void handleBranchInstruction(const MachineInstr *branchInstr, Context &ctx,
                               AnalysisDom &newOut);

  /**
   * Returns the AnaInfo object containing the information this analysis has
   * computed.
   */
  AnalysisInfo *getAnalysisResults();

  /**
   * The worklist contains basicblocks and context for which the analysis has to
   * be (re-)run.
   */
  std::map<const MachineBasicBlock *, std::set<Context, ctxcomp>, mbbComp>
      worklist;
};

template <class AnalysisDom>
typename AnalysisDriver<AnalysisDom, MachineInstr>::AnalysisInfo *
AnalysisDriverInstr<AnalysisDom>::runAnalysis() {
  DEBUG_WITH_TYPE("driver", dbgs() << "Start new analysis run\n");
  // Initialize analysis information and worklist
  initialize();

  while (!worklist.empty()) {
    // Get a new work item
    auto &bbCtxs = *(worklist.begin()); // Take reference to entry
    const auto *currentBB = bbCtxs.first;
    auto currentCtx = *(bbCtxs.second.begin());
    bbCtxs.second.erase(currentCtx); // Erase from the referenced set
    if (bbCtxs.second.empty()) {
      worklist.erase(currentBB);
    }
    DEBUG_WITH_TYPE("driver", std::cerr
                                  << "Work on BB" << currentBB->getNumber()
                                  << " of function "
                                  << currentBB->getParent()->getName().str()
                                  << " in context " << currentCtx << "\n");

    // Compute new incoming information
    // For function entry blocks, we have information available in func2anainfo
    if (currentBB->getNumber() == 0) {
      assert(currentBB->pred_empty() &&
             "Function entry block cannot have predecessors");
      const auto *currentFunc = currentBB->getParent();
      auto toklist = currentCtx.getTokenList();
      // Assert that the topmost token in context at beginning of function is
      // funcallee of this function
      assert(!currentCtx.isEmpty() &&
             toklist.back()->getType() == PartitionTokenType::FUNCALLEE);
      assert(dynamic_cast<PartitionTokenFunCallee *>(toklist.back())
                 ->getCallee() == currentFunc);
      toklist.pop_back();
      Context preCallCtx(toklist);
      AnalysisDom newIn(
          func2anainfo->at(currentFunc).in.findAnalysisInfo(preCallCtx));
      // Join (potentially new) incoming information for current basic block and
      // context
      mbb2anainfo->at(currentBB).addContext(currentCtx, newIn);
    }

    // Analyse current basic block by calling transfer functions per instruction
    analyseMachineBasicBlock(currentBB, currentCtx);
  }
  return getAnalysisResults();
}

template <class AnalysisDom>
void AnalysisDriverInstr<AnalysisDom>::initialize() {
  // Put analysis entry-point into worklist
  assert(worklist.empty());
  auto MF = machineFunctionCollector->getFunctionByName(this->entrypoint);
  const MachineBasicBlock *analysisStart = &*(MF->begin());
  Context initialCtx;
  // Directive handling on function called
  if (DirectiveHeuristicsPassInstance->hasDirectiveOnCall(MF)) {
    initialCtx.update(DirectiveHeuristicsPassInstance->getDirectiveOnCall(MF));
  }
  worklist[analysisStart].insert(initialCtx);

  // Initialize analysis information with bottom
  using std::make_pair;
  assert(mbb2anainfo && "Analysis Driver cannot be run multiple times");
  for (auto *currFunc : machineFunctionCollector->getAllMachineFunctions()) {
    for (auto &currBB : *currFunc) {
      mbb2anainfo->insert(
          make_pair(&currBB, PartitionedAnalysisDom(AnaDomInit::BOTTOM)));
    }
    // Function are in general unreachable at entry and exit
    AnaInfoEntryExit tmp((PartitionedAnalysisDom(AnaDomInit::BOTTOM)),
                         PartitionedAnalysisDom(AnaDomInit::BOTTOM));
    // If this is the (reachable) analysis entry point, use START analysis
    // information instead
    if (currFunc->getName() == this->entrypoint) {
      tmp.in = PartitionedAnalysisDom(AnaDomInit::START);
    }
    func2anainfo->insert(make_pair(currFunc, tmp));
  }
}

template <class AnalysisDom>
void AnalysisDriverInstr<AnalysisDom>::analyseMachineBasicBlock(
    const MachineBasicBlock *MBB, const Context &ctx) {
  // Clone input to get new output
  AnalysisDom newOut(mbb2anainfo->at(MBB).findAnalysisInfo(ctx));
  Context targetCtx(ctx);
  // For each instruction, call corresponding transfer function
  for (auto &currentInstr : *MBB) {
    // If effect-less instruction found, we should ignore it during analysis
    if (currentInstr.isTransient()) {
      continue; // ... to next instruction
    }
    analyseInstruction(&currentInstr, targetCtx, newOut);
    handleBranchInstruction(&currentInstr, targetCtx, newOut);
  }

  // Handle fallthrough cases to layout successor
  for (auto succit = MBB->succ_begin(); succit != MBB->succ_end(); ++succit) {
    if (!MBB->isLayoutSuccessor(*succit))
      continue;
    // get Target basic block
    MachineBasicBlock *targetMBB = *succit;

    // Handle directive on basicblock edges
    // Directives when edge is entered
    auto edge = std::make_pair(MBB, targetMBB);
    if (DirectiveHeuristicsPassInstance->hasDirectiveOnEdgeEnter(edge)) {
      auto *direclist =
          DirectiveHeuristicsPassInstance->getDirectiveOnEdgeEnter(edge);
      for (auto *direc : *direclist) {
        targetCtx.update(direc);
      }
    }
    // analysis info needs an "edge transfer" to adjust analysis information for
    // loops
    targetCtx.transfer(edge);
    // Directives when edge is left
    if (DirectiveHeuristicsPassInstance->hasDirectiveOnEdgeLeave(edge)) {
      auto *direclist =
          DirectiveHeuristicsPassInstance->getDirectiveOnEdgeLeave(edge);
      for (auto *direc : *direclist) {
        targetCtx.update(direc);
      }
    }
    newOut.enterBasicBlock(targetMBB);
    // Join incoming information, and check whether the join changed something
    auto &targetMBBAnaInfo = mbb2anainfo->at(targetMBB);
    bool changed = targetMBBAnaInfo.addContext(targetCtx, newOut);
    // Add potential affected contexts to worklist
    if (changed) {
      worklist[targetMBB].insert(targetCtx);
      DEBUG_WITH_TYPE("driver", std::cerr
                                    << "Added BB" << targetMBB->getNumber()
                                    << " of function "
                                    << targetMBB->getParent()->getName().str()
                                    << " and context " << targetCtx << "\n");
    }
  }
}

template <class AnalysisDom>
void AnalysisDriverInstr<AnalysisDom>::analyseInstruction(
    const MachineInstr *currentInstr, Context &ctx, AnalysisDom &newOut) {
  DEBUG_WITH_TYPE(AnalysisDom::analysisName("driver").c_str(),
                  std::cerr
                      << "Before:" << getMachineInstrIdentifier(currentInstr)
                      << " in context " << ctx << "\n"
                      << newOut.print() << "\n");

  // Directives before the instruction
  if (DirectiveHeuristicsPassInstance->hasDirectiveBeforeInstr(currentInstr)) {
    ctx.update(
        DirectiveHeuristicsPassInstance->getDirectiveBeforeInstr(currentInstr));
  }

  // We don't have a call
  if (!currentInstr->isCall()) {
    // Abstract transfer function
    newOut.transfer(currentInstr, &ctx, this->analysisResults);
  } else {
    auto &cg = CallGraph::getGraph();

    AnalysisDom preCallInfo(newOut);
    // Unreachable calls
    if (preCallInfo.isBottom()) {
      newOut = AnalysisDom(AnaDomInit::BOTTOM);
    } else if (cg.callsExternal(currentInstr)) {
      // The out out-information from external callee is top
      AnalysisDom calleeout(AnaDomInit::TOP);
      // Do a transfer call with external function.
      AnalysisDom afterCallInfo = newOut.transferCall(
          currentInstr, &ctx, this->analysisResults, nullptr, calleeout);
      newOut = afterCallInfo;
      // No need to propagate information to beginning of external function
      // No need to add something to the worklist
    } else { // Only analyzable calls
      // Set current analysis information to bottom
      newOut = AnalysisDom(AnaDomInit::BOTTOM);
      // Reduce context for call
      Context reducedCtx(ctx);
      reducedCtx.reduceOnCall();
      // For each potential callee do
      for (const auto *callee : cg.getPotentialCallees(currentInstr)) {
        AnalysisDom toCalleeInfo(preCallInfo);
        // Use early-variant here as callee might not be fully analysed yet
        AnalysisDom calleeout(
            func2anainfo->at(callee).out.findAnalysisInfoEarly(reducedCtx));
        AnalysisDom afterCallInfo = toCalleeInfo.transferCall(
            currentInstr, &ctx, this->analysisResults, callee, calleeout);
        newOut.join(afterCallInfo);
        // Propagate information to beginning of function
        const MachineBasicBlock *calleeBeginBB = &*callee->begin();
        assert(calleeBeginBB->getNumber() == 0 &&
               "The first basic block of a function should have number 0");
        toCalleeInfo.enterBasicBlock(calleeBeginBB);
        bool calleechanged =
            func2anainfo->at(callee).in.addContext(reducedCtx, toCalleeInfo);
        // Potentially add first BB of callee to worklist
        if (calleechanged) {
          // Directive handling on function called
          if (DirectiveHeuristicsPassInstance->hasDirectiveOnCall(callee)) {
            reducedCtx.update(
                DirectiveHeuristicsPassInstance->getDirectiveOnCall(callee));
          }
          worklist[calleeBeginBB].insert(reducedCtx);
          DEBUG_WITH_TYPE(
              "driver", std::cerr << "Added BB" << calleeBeginBB->getNumber()
                                  << " of function " << callee->getName().str()
                                  << " and context " << reducedCtx << "\n");
        }
      }
    }
  }

  // Directives after the instruction
  if (DirectiveHeuristicsPassInstance->hasDirectiveAfterInstr(currentInstr)) {
    ctx.update(
        DirectiveHeuristicsPassInstance->getDirectiveAfterInstr(currentInstr));
  }

  DEBUG_WITH_TYPE(AnalysisDom::analysisName("driver").c_str(),
                  std::cerr << "After:\n"
                            << newOut.print() << "\n");
}

template <class AnalysisDom>
void AnalysisDriverInstr<AnalysisDom>::handleBranchInstruction(
    const MachineInstr *branchInstr, Context &ctx, AnalysisDom &newOut) {
  if (branchInstr->isBranch()) {
    // Copy info for the taken case
    AnalysisDom branchOutInfo(newOut);

    // Determine branch targets, and adjust newOut
    std::set<const MachineBasicBlock *, mbbComp> branchTargets;
    if (isJumpTableBranch(branchInstr)) {
      // Jump table branch
      auto JTindex = getJumpTableIndex(branchInstr);
      auto &MJTEs = branchInstr->getParent()
                        ->getParent()
                        ->getJumpTableInfo()
                        ->getJumpTables();
      auto &targetMBBs = MJTEs[JTindex].MBBs;
      branchTargets.insert(targetMBBs.begin(), targetMBBs.end());
      // We always jump
      newOut = AnalysisDom(AnaDomInit::BOTTOM);
    } else {
      // Normal branch
      assert(getBranchTargetOperand(branchInstr).isMBB() &&
             "Conditional Branch to non basic-block");
      MachineBasicBlock *targetMBB =
          getBranchTargetOperand(branchInstr).getMBB();
      branchTargets.insert(targetMBB);
      if (branchInstr->isConditionalBranch()) {
        // We might have not taken the branch
        newOut.guard(branchInstr, &ctx, this->analysisResults,
                     BranchOutcome::nottaken());
      } else {
        assert(branchInstr->isUnconditionalBranch() &&
               "Expected non-conditional branch");
        // Unconditional branch, set unreachable
        newOut = AnalysisDom(AnaDomInit::BOTTOM);
      }
    }

    for (const auto *targetMBB : branchTargets) {
      // Duplicate
      AnalysisDom branchTakenInfo(branchOutInfo);
      // Do guard that we wanted to go to targetMBB, unless it was clear
      if (!branchInstr->isUnconditionalBranch()) {
        branchTakenInfo.guard(branchInstr, &ctx, this->analysisResults,
                              BranchOutcome::taken(targetMBB));
      }
      // Target MBB context, should be updated
      Context targetCtx(ctx);
      // Handle directive on basicblock edges
      // Directives when edge is entered
      auto edge = std::make_pair(branchInstr->getParent(), targetMBB);
      if (DirectiveHeuristicsPassInstance->hasDirectiveOnEdgeEnter(edge)) {
        auto *direclist =
            DirectiveHeuristicsPassInstance->getDirectiveOnEdgeEnter(edge);
        for (auto *direc : *direclist) {
          targetCtx.update(direc);
        }
      }
      // branchTakenInfo needs an "edge transfer" to adjust analysis information
      // for loops
      targetCtx.transfer(edge);
      // Directives when edge is left
      if (DirectiveHeuristicsPassInstance->hasDirectiveOnEdgeLeave(edge)) {
        auto *direclist =
            DirectiveHeuristicsPassInstance->getDirectiveOnEdgeLeave(edge);
        for (auto *direc : *direclist) {
          targetCtx.update(direc);
        }
      }
      branchTakenInfo.enterBasicBlock(targetMBB);
      // Join incoming information, and check whether the join changed something
      auto &targetMBBAnaInfo = mbb2anainfo->find(targetMBB)->second;
      bool changed = targetMBBAnaInfo.addContext(targetCtx, branchTakenInfo);
      // Add potential affected contexts to worklist
      if (changed) {
        worklist[targetMBB].insert(targetCtx);
        DEBUG_WITH_TYPE("driver", std::cerr
                                      << "Added BB" << targetMBB->getNumber()
                                      << " of function "
                                      << targetMBB->getParent()->getName().str()
                                      << " and context " << targetCtx << "\n");
      }
    }
  }

  // If this is a returning instruction, apply return directives, and merge to
  // func2anainfo
  if (branchInstr->isReturn()) {
    const auto *currentFunc = branchInstr->getParent()->getParent();
    AnalysisDom toJoin(newOut);
    toJoin.guard(branchInstr, &ctx, this->analysisResults,
                 BranchOutcome::taken());
    // If any directive, then apply it
    Context targetCtx(ctx);
    if (DirectiveHeuristicsPassInstance->hasDirectiveOnReturn(currentFunc)) {
      targetCtx.update(
          DirectiveHeuristicsPassInstance->getDirectiveOnReturn(currentFunc));
    }
    // Join this information to the function exit information
    auto &funcout = func2anainfo->at(currentFunc).out;
    bool changedFuncOut = funcout.addContext(targetCtx, toJoin);
    // New analysis info is what remains if we keep nottaken information
    if (isPredicated(branchInstr)) {
      newOut.guard(branchInstr, &ctx, this->analysisResults,
                   BranchOutcome::nottaken());
    } else {
      // Non-predicated return, set unreachable
      newOut = AnalysisDom(AnaDomInit::BOTTOM);
    }
    // Add the basic blocks of the affected callsites to the worklist
    if (changedFuncOut) {
      auto &cg = CallGraph::getGraph();
      for (auto &callsite : cg.getCallSites(currentFunc)) {
        const auto *callsiteMBB = callsite->getParent();
        // If callsite has not been reachable, go to next
        if (mbb2anainfo->at(callsiteMBB).isBottom()) {
          continue;
        }
        for (auto &ctx2anainfo :
             mbb2anainfo->at(callsiteMBB).getAnalysisInfoPerContext()) {
          Context callsiteCtx(ctx2anainfo.first);
          // Directives before the callsite
          if (DirectiveHeuristicsPassInstance->hasDirectiveBeforeInstr(
                  callsite)) {
            callsiteCtx.update(
                DirectiveHeuristicsPassInstance->getDirectiveBeforeInstr(
                    callsite));
          }
          callsiteCtx.reduceOnCall();
          // Only add callsiteMBB and ctx2anainfo.first into worklist, if
          // affected by the new funcout at targetCtx
          if (callsiteCtx == targetCtx) {
            worklist[callsiteMBB].insert(ctx2anainfo.first);
            DEBUG_WITH_TYPE("driver",
                            std::cerr << "Added BB" << callsiteMBB->getNumber()
                                      << " of function "
                                      << callsite->getParent()->getName().str()
                                      << " and context " << ctx2anainfo.first
                                      << "\n");
          }
        }
      }
    }
  }
}

template <class AnalysisDom>
bool AnalysisDriverInstr<AnalysisDom>::analyseInstruction(
    const MachineInstr *currentInstr, PartitionedAnalysisDom &newOut) {
  DEBUG_WITH_TYPE(AnalysisDom::analysisName("driver").c_str(),
                  dbgs() << "Before:" << getMachineInstrIdentifier(currentInstr)
                         << "\n"
                         << newOut.print() << "\n");

  bool changed = false;
  // Directives before the instruction
  if (DirectiveHeuristicsPassInstance->hasDirectiveBeforeInstr(currentInstr)) {
    newOut.updateContexts(
        DirectiveHeuristicsPassInstance->getDirectiveBeforeInstr(currentInstr));
  }

  // We don't have a call
  if (!currentInstr->isCall()) {
    // Abstract transfer function
    newOut.transfer(currentInstr, this->analysisResults);
  } else {
    auto &cg = CallGraph::getGraph();

    PartitionedAnalysisDom preCallInfo(newOut);
    // Unreachable calls
    if (preCallInfo.isBottom()) {
      newOut = PartitionedAnalysisDom(AnaDomInit::BOTTOM);
    } else if (cg.callsExternal(currentInstr)) {
      PartitionedAnalysisDom notneeded(AnaDomInit::BOTTOM); // Discarded anyway
      // Do a transfer call with external function.
      // The out out-information from external callee is ignored,
      // as well as the callee in-information.
      newOut.transferCall(currentInstr, this->analysisResults, nullptr,
                          notneeded, notneeded);
    } else {
      // Only analyzable calls
      // Set current analysis information to bottom
      newOut = PartitionedAnalysisDom(AnaDomInit::BOTTOM);
      // For each potential callee do
      for (const auto *callee : cg.getPotentialCallees(currentInstr)) {
        PartitionedAnalysisDom afterCallInfo(preCallInfo);
        changed |= afterCallInfo.transferCall(
            currentInstr, this->analysisResults, callee,
            func2anainfo->find(callee)->second.out,
            func2anainfo->find(callee)->second.in);
        newOut.join(afterCallInfo);
      }
    }
  }

  // Directives after the instruction
  if (DirectiveHeuristicsPassInstance->hasDirectiveAfterInstr(currentInstr)) {
    newOut.updateContexts(
        DirectiveHeuristicsPassInstance->getDirectiveAfterInstr(currentInstr));
  }

  DEBUG_WITH_TYPE(AnalysisDom::analysisName("driver").c_str(),
                  dbgs() << "After:\n"
                         << newOut.print() << "\n");

  return changed;
}

template <class AnalysisDom>
bool AnalysisDriverInstr<AnalysisDom>::handleBranchInstruction(
    const MachineInstr *branchInstr, PartitionedAnalysisDom &newOut) {
  /* TODO could llvm::TargetInstrInfo::AnalyzeBranch be used to simplify
   * this? */
  bool changed = false;
  if (branchInstr->isBranch()) {
    // Copy info for the taken case
    PartitionedAnalysisDom branchOutInfo(newOut);

    // Determine branch targets, and adjust newOut
    std::set<const MachineBasicBlock *, mbbComp> branchTargets;
    if (isJumpTableBranch(branchInstr)) {
      // Jump table branch
      auto JTindex = getJumpTableIndex(branchInstr);
      auto &MJTEs = branchInstr->getParent()
                        ->getParent()
                        ->getJumpTableInfo()
                        ->getJumpTables();
      auto &targetMBBs = MJTEs[JTindex].MBBs;
      branchTargets.insert(targetMBBs.begin(), targetMBBs.end());
      // We always jump
      newOut = PartitionedAnalysisDom(AnaDomInit::BOTTOM);
    } else {
      // Normal branch
      assert(getBranchTargetOperand(branchInstr).isMBB() &&
             "Conditional Branch to non basic-block");
      MachineBasicBlock *targetMBB =
          getBranchTargetOperand(branchInstr).getMBB();
      branchTargets.insert(targetMBB);
      if (branchInstr->isConditionalBranch()) {
        // We might have not taken the branch
        newOut.guard(branchInstr, this->analysisResults,
                     BranchOutcome::nottaken());
      } else {
        assert(branchInstr->isUnconditionalBranch() &&
               "Expected non-conditional branch");
        // Unconditional branch, set unreachable
        newOut = PartitionedAnalysisDom(AnaDomInit::BOTTOM);
      }
    }

    if (CheckFixPoint) {
      for (const auto *targetMBB : branchTargets) {
        // Duplicate
        PartitionedAnalysisDom branchTakenInfo(branchOutInfo);
        // Do guard that we wanted to go to targetMBB, unless it was clear
        if (!branchInstr->isUnconditionalBranch()) {
          branchTakenInfo.guard(branchInstr, this->analysisResults,
                                BranchOutcome::taken(targetMBB));
        }

        // Handle directive on basicblock edges
        // Directives when edge is entered
        auto edge = std::make_pair(branchInstr->getParent(), targetMBB);
        if (DirectiveHeuristicsPassInstance->hasDirectiveOnEdgeEnter(edge)) {
          auto *direclist =
              DirectiveHeuristicsPassInstance->getDirectiveOnEdgeEnter(edge);
          for (auto *direc : *direclist) {
            branchTakenInfo.updateContexts(direc);
          }
        }
        // branchTakenInfo needs an "edge transfer" to adjust analysis
        // information for loops
        branchTakenInfo.transferEdge(edge);
        // Directives when edge is left
        if (DirectiveHeuristicsPassInstance->hasDirectiveOnEdgeLeave(edge)) {
          auto *direclist =
              DirectiveHeuristicsPassInstance->getDirectiveOnEdgeLeave(edge);
          for (auto *direc : *direclist) {
            branchTakenInfo.updateContexts(direc);
          }
        }
        branchTakenInfo.enterBasicBlock(targetMBB);
        // Join incoming information, and check whether the join changed
        // something
        auto &targetMBBAnaInfo = mbb2anainfo->find(targetMBB)->second;
        PartitionedAnalysisDom oldIn(targetMBBAnaInfo);
        targetMBBAnaInfo.join(branchTakenInfo);
        changed |= !targetMBBAnaInfo.equals(&oldIn);
      }
    }
  }

  // If this is a returning instruction, apply return directives, and merge to
  // func2anainfo
  if (branchInstr->isReturn()) {
    if (CheckFixPoint) {
      const auto *currentFunc = branchInstr->getParent()->getParent();
      PartitionedAnalysisDom toJoin(newOut);
      toJoin.guard(branchInstr, this->analysisResults, BranchOutcome::taken());
      // If any directive, then apply it
      if (DirectiveHeuristicsPassInstance->hasDirectiveOnReturn(currentFunc)) {
        toJoin.updateContexts(
            DirectiveHeuristicsPassInstance->getDirectiveOnReturn(currentFunc));
      }
      // Join this information to the function exit information
      // TODO predication: toJoin.guard(branchInstr, this->analysisResults,
      // BranchOutcome::taken());
      auto &funcout = func2anainfo->find(currentFunc)->second.out;
      PartitionedAnalysisDom oldOut(funcout);
      funcout.join(toJoin);
      changed |= !funcout.equals(&oldOut);
    }
    // Nothing is reachable after a return, unless it might not have been taken
    // due to predication
    if (isPredicated(branchInstr)) {
      newOut.guard(branchInstr, this->analysisResults,
                   BranchOutcome::nottaken());
    } else {
      // Non-predicated return, set unreachable
      newOut = PartitionedAnalysisDom(AnaDomInit::BOTTOM);
    }
  }
  return changed;
}

template <class AnalysisDom>
typename AnalysisDriver<AnalysisDom, MachineInstr>::AnalysisInfo *
AnalysisDriverInstr<AnalysisDom>::getAnalysisResults() {
  DEBUG_WITH_TYPE("memusage", dbgs() << AnalysisDom::analysisName("")
                                     << "finished with " << getPeakRSS()
                                     << "MB peak mem usage, now dumping\n");

  if (AnaInfoPol == AnaInfoPolicy::LOWMEM) {
    errs() << "[Note:] The low-memory analysis information storage is "
              "currently not available.\n";
#if 0
		typedef AnalysisInformationMemOpt<PartitioningDomain<AnalysisDom, MachineInstr>, MachineInstr>
						AnaInfoMemOpt;
		auto res = new AnaInfoMemOpt(std::move(mbb2anainfo), std::move(func2anainfo),
																	this->analysisResults);

		DEBUG_WITH_TYPE("memusage", dbgs() << AnalysisDom::analysisName("") << "finished dumping with "
																		<< getPeakRSS() << "MB peak mem usage\n");
		return res;
#endif
  }

  // Then let us precompute analysis results per instruction
  assert((AnaInfoPol == AnaInfoPolicy::PRECOMPALL ||
          AnaInfoPol == AnaInfoPolicy::PRECOMPREQ) &&
         "Unknown analysis information policy");
  typedef std::map<const MachineInstr *, PartitionedAnalysisDom>
      InstrAnainfoMap;
  std::unique_ptr<InstrAnainfoMap> anaInfoIn(new InstrAnainfoMap());
  std::unique_ptr<InstrAnainfoMap> anaInfoOut(new InstrAnainfoMap());

  for (auto *currFunc : machineFunctionCollector->getAllMachineFunctions()) {
    for (auto &currBB : *currFunc) {
      PartitionedAnalysisDom blockIn(mbb2anainfo->find(&currBB)->second);
      for (auto &currInstr : currBB) {
        if (currInstr.isTransient()) {
          continue;
        }
        if (AnaInfoPol == AnaInfoPolicy::PRECOMPALL ||
            AnalysisDom::anainfoBeforeRequired(&currInstr)) {
          anaInfoIn->insert(std::make_pair(&currInstr, blockIn));
        }
        bool changed = analyseInstruction(&currInstr, blockIn);
        assert(!changed && "A: Should not change analysis info after iteration "
                           "while dumping.\n");
        if (AnaInfoPol == AnaInfoPolicy::PRECOMPALL ||
            AnalysisDom::anainfoAfterRequired(&currInstr)) {
          anaInfoOut->insert(std::make_pair(&currInstr, blockIn));
        }
        // Make from the current out-info the next in-info
        changed = handleBranchInstruction(&currInstr, blockIn);
        if (changed) {
          errs() << "\n";
          errs() << "ERROR: Analysis info changed after fixpoint was already "
                    "reached\n";
          errs() << "While joining information of " << currInstr
                 << "with its target\n";
          errs() << "In " << currInstr.getParent()->getFullName() << "\n";
          errs() << "\n";
          abort();
        }
      }
    }
  }
  typedef AnalysisInformationPrecomputed<
      PartitioningDomain<AnalysisDom, MachineInstr>, MachineInstr>
      AnaInfoPrecomp;
  auto res = new AnaInfoPrecomp(std::move(anaInfoIn), std::move(anaInfoOut),
                                this->analysisResults);

  // We do not need the internal analysis information any more, reset them
  mbb2anainfo.reset(nullptr);
  func2anainfo.reset(nullptr);

  DEBUG_WITH_TYPE("memusage", dbgs() << AnalysisDom::analysisName("")
                                     << "finished dumping with " << getPeakRSS()
                                     << "MB peak mem usage\n");
  return res;
}

///////////////////////////////////////////
/// Granularity on Machine Instructions ///
///////////////////////////////////////////

/**
 * Analysis Driver in the granularity of machine instructions.
 * For general description, see the superclass.
 * This wrapper computes, as additional analysis dependency,
 * a mapping from call-instruction to context such that we know
 * return contexts despite context reduction.
 */
template <class AnalysisDom>
class AnalysisDriverInstrContextMapping
    : public AnalysisDriverInstr<AnalysisDom> {
public:
  // Making AnaDeps visible again
  using typename AnalysisDriver<AnalysisDom, MachineInstr>::AnaDeps;

  /**
   * Constructor, calls the superclass constructor
   */
  template <class TailAnaDeps>
  AnalysisDriverInstrContextMapping(std::string entrypoint,
                                    TailAnaDeps tAnaDeps)
      : AnalysisDriverInstr<AnalysisDom>(
            entrypoint, std::tuple_cat(std::tuple<InstrContextMapping &>(
                                           *(new InstrContextMapping())),
                                       tAnaDeps))
  // Allocate the InstrContext-map on the heap as it is needed even after the
  // lifetime of the analysis-driver It is freed within the state graph
  // construction, once the microarchitectural information is no longer needed
  {
    std::tuple<> noDep;
    AnalysisDriverInstr<CollectingContextsDomain> collectCtxsAna(
        AnalysisEntryPoint, noDep);
    auto *ccAnaInfo = collectCtxsAna.runAnalysis();
    // ccAnaInfo->dump(std::cout);
    //  Get handle for the instr-context-mapping stored inside the analysis
    //  dependencies
    InstrContextMapping &callsite2contexts = std::get<0>(this->analysisResults);
    for (auto *currFunc : machineFunctionCollector->getAllMachineFunctions()) {
      for (auto &currBB : *currFunc) {
        for (auto &currInstr : currBB) {
          if (currInstr.isCall()) {
            auto ctxTree = ccAnaInfo->getAnaInfoBefore(&currInstr);
            // Directives before the call instruction
            if (DirectiveHeuristicsPassInstance->hasDirectiveBeforeInstr(
                    &currInstr)) {
              ctxTree.updateContexts(
                  DirectiveHeuristicsPassInstance->getDirectiveBeforeInstr(
                      &currInstr));
            }
            if (!ctxTree.isBottom()) {
              // We must put the contexts for each callsite in an ordered way
              std::set<Context, ctxcomp> ctx_sorted;
              for (auto &ctxana : ctxTree.getAnalysisInfoPerContext()) {
                ctx_sorted.insert(ctxana.first);
              }
              for (const Context &ctx : ctx_sorted) {
                callsite2contexts[&currInstr].insert(ctx);
              }
            }
          }
        }
      }
    }
    delete ccAnaInfo;
  }
};

///////////////////////////////////////////
/// Granularity on Machine Basic Blocks ///
///////////////////////////////////////////

} // namespace TimingAnalysisPass

#endif
