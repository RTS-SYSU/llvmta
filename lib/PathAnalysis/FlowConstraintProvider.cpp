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

#include "PathAnalysis/FlowConstraintProvider.h"

#include "PathAnalysis/LoopBoundInfo.h"

namespace TimingAnalysisPass {

FlowConstraintProvider::FlowConstraintProvider(
    const StateGraph *sg, bool programRunMode, bool allowSeveralRuns,
    typename GetEdges::method loopGetInnerEdgesMethod,
    typename GetEdges::method callSiteGetInnerEdgesMethod)
    : graph(sg), programRunMode(programRunMode),
      allowSeveralRuns(allowSeveralRuns),
      getEdges(isGeneralMode() ? new GetEdges(sg) : nullptr),
      loopGetInnerEdgesImpl(
          initializeGetInnerEdgesImpl(loopGetInnerEdgesMethod)),
      callSiteGetInnerEdgesImpl(
          initializeGetInnerEdgesImpl(callSiteGetInnerEdgesMethod)) {}

FlowConstraintProvider::~FlowConstraintProvider() {
  if (getEdges) {
    delete getEdges;
  }
}

void FlowConstraintProvider::buildConstraints() {
  buildInFlowEqualsOutFlowConstraints();
  buildLoopConstraints(true);
  buildLoopConstraints(false);
  buildCallReturnConstraints();
  buildStartConstraint();
}

void FlowConstraintProvider::buildUpperConstraints() {
  buildInFlowEqualsOutFlowConstraints();
  buildLoopConstraints(true);
  buildCallReturnConstraints();
  buildStartConstraint();
}

void FlowConstraintProvider::buildLowerConstraints() {
  buildInFlowEqualsOutFlowConstraints();
  buildLoopConstraints(false);
  buildCallReturnConstraints();
  buildStartConstraint();
}

std::list<GraphConstraint> FlowConstraintProvider::getConstraints() const {
  std::list<GraphConstraint> constraints(inFlowEqualsOutFlowConstraints);
  constraints.insert(constraints.end(), upperLoopConstraints.begin(),
                     upperLoopConstraints.end());
  constraints.insert(constraints.end(), lowerLoopConstraints.begin(),
                     lowerLoopConstraints.end());
  constraints.insert(constraints.end(), callReturnConstraints.begin(),
                     callReturnConstraints.end());
  constraints.insert(constraints.end(), startConstraints.begin(),
                     startConstraints.end());
  return constraints;
}

std::list<GraphConstraint> FlowConstraintProvider::getUpperConstraints() const {
  std::list<GraphConstraint> constraints(inFlowEqualsOutFlowConstraints);
  constraints.insert(constraints.end(), upperLoopConstraints.begin(),
                     upperLoopConstraints.end());
  constraints.insert(constraints.end(), callReturnConstraints.begin(),
                     callReturnConstraints.end());
  constraints.insert(constraints.end(), startConstraints.begin(),
                     startConstraints.end());
  return constraints;
}

std::list<GraphConstraint> FlowConstraintProvider::getLowerConstraints() const {
  std::list<GraphConstraint> constraints(inFlowEqualsOutFlowConstraints);
  constraints.insert(constraints.end(), lowerLoopConstraints.begin(),
                     lowerLoopConstraints.end());
  constraints.insert(constraints.end(), callReturnConstraints.begin(),
                     callReturnConstraints.end());
  constraints.insert(constraints.end(), startConstraints.begin(),
                     startConstraints.end());
  return constraints;
}

void FlowConstraintProvider::buildInFlowEqualsOutFlowConstraints() {
  DEBUG_WITH_TYPE("flowConstraints",
                  dbgs() << "Start building inFlow=outFlow constraints.\n");

  // adding flow-constraints
  for (const auto &vertex : graph->getGraph().getVertices()) {
    // skip special vertex
    if (vertex.first != 0) {
      DEBUG_WITH_TYPE("flowConstraints",
                      dbgs() << "Vertex No: " << vertex.first << "\n");
      if (FollowLocalWorstType.getBits() ==
          0) { // If != 0, the transfer is not monotonic, thus pending states
               // might arise
        assert(vertex.second.getPredecessors().size() > 0 &&
               "Vertex has no predecessors!");
      }
      assert(vertex.second.getSuccessors().size() > 0 &&
             "Vertex has no successors!");
    }

    VarCoeffVector variables;

    for (const auto &vt_pred : vertex.second.getPredecessors()) {
      auto edge = std::make_pair(vt_pred, vertex.first);
      auto edgeTimesTakenVar = Variable::getEdgeVar(timesTakenType, edge);
      variables.push_back(std::make_pair(edgeTimesTakenVar, -1));
      if (isGeneralMode()) {
        auto edgeIsEndVar = Variable::getEdgeVar(isEndType, edge);
        variables.push_back(std::make_pair(edgeIsEndVar, 1));
        // any edge needs to be taken at least once in order
        // to be able to be the start edge or the end edge
        // of a path.
        VarCoeffVector vars2;
        vars2.push_back(std::make_pair(edgeTimesTakenVar, 1));
        vars2.push_back(std::make_pair(edgeIsEndVar, -1));
        GraphConstraint constr =
            std::make_tuple(vars2, ConstraintType::GreaterEqual, 0);
        inFlowEqualsOutFlowConstraints.push_back(constr);
        vars2.clear();
        auto edgeIsStartVar = Variable::getEdgeVar(isStartType, edge);
        vars2.push_back(std::make_pair(edgeTimesTakenVar, 1));
        vars2.push_back(std::make_pair(edgeIsStartVar, -1));
        constr = std::make_tuple(vars2, ConstraintType::GreaterEqual, 0);
        inFlowEqualsOutFlowConstraints.push_back(constr);
      }
    }

    for (const auto &vt_succ : vertex.second.getSuccessors()) {
      auto edge = std::make_pair(vertex.first, vt_succ);
      auto edgeTimesTakenVar = Variable::getEdgeVar(timesTakenType, edge);
      variables.push_back(std::make_pair(edgeTimesTakenVar, 1));
      if (isGeneralMode()) {
        auto edgeIsStartVar = Variable::getEdgeVar(isStartType, edge);
        variables.push_back(std::make_pair(edgeIsStartVar, -1));
      }
    }

    // add constraint with constraint type 3 (equality) and right hand value of
    // 0
    GraphConstraint constr =
        std::make_tuple(variables, ConstraintType::Equal, 0);
    inFlowEqualsOutFlowConstraints.push_back(constr);
  }

  DEBUG_WITH_TYPE("flowConstraints", dbgs() << "Finished constraints.\n");
}

void FlowConstraintProvider::buildLoopConstraints(bool upper) {
  // use different function pointers depending on upper or lower bounding
  // constraints
  auto hasLoopBoundFkt =
      upper ? &TimingAnalysisPass::LoopBoundInfoPass::hasUpperLoopBound
            : &TimingAnalysisPass::LoopBoundInfoPass::hasLowerLoopBound;
  auto getLoopBoundFkt =
      upper ? &TimingAnalysisPass::LoopBoundInfoPass::getUpperLoopBound
            : &TimingAnalysisPass::LoopBoundInfoPass::getLowerLoopBound;
  std::list<GraphConstraint> &loopConstraints =
      upper ? upperLoopConstraints : lowerLoopConstraints;

  CallGraph &cg = CallGraph::getGraph();

  // for each loop, add loop constraint
  for (const MachineLoop *loop : LoopBoundInfo->getAllLoops()) {

    auto entryBB = loop->getHeader();
    // If the loop (i.e. the header) is not reachable at all, we do not need any
    // constraints here
    if (graph->getInStates(entryBB).size() == 0) {
      continue;
    }

    std::set<unsigned> outStatesWithinScope;
    std::set<unsigned> outStatesOutsideScope;
    for (auto predBB : getNonEmptyPredecessorBasicBlocks(entryBB)) {
      if (entryBB->getParent() == predBB->getParent()) {
        auto outStates = graph->getOutStates(predBB);
        assert(outStates.size() > 0 && "Non empty BB should have out states");
        if (loop->contains(
                predBB)) { // Predecessor in loop -> this is a backedge
          outStatesWithinScope.insert(outStates.begin(), outStates.end());
        } else { // Otherwise, this is an entry edge
          outStatesOutsideScope.insert(outStates.begin(), outStates.end());
        }
      } else {
        for (auto cs : cg.getCallSitesInMBB(predBB)) {
          const auto &potCallees = cg.getPotentialCallees(cs);
          if (std::find(potCallees.begin(), potCallees.end(),
                        entryBB->getParent()) != potCallees.end()) {
            auto callStates = graph->getCallStates(cs);
            outStatesOutsideScope.insert(callStates.begin(), callStates.end());
          }
        }
      }
    }

    // Collect the list of states that correspond to each context
    std::unordered_map<Context, std::list<unsigned>> ctxStateMap;
    for (auto stateId : graph->getInStates(entryBB)) {
      auto context = graph->getContextOfState(stateId);
      if (context == nullptr) {
        ctxStateMap[Context()].push_back(stateId);
      } else {
        Context c(*context);
        c.cleanToFunCall();
        ctxStateMap[c].push_back(stateId);
      }
    }

    std::set<GraphEdge> loopInEdges;
    bool collectLoopInEdges = std::get<1>(loopGetInnerEdgesImpl);

    for (const auto &ctxMapElement : ctxStateMap) {
      // First check if the loop bounds are available for this context
      if (!(LoopBoundInfo->*hasLoopBoundFkt)(loop, ctxMapElement.first)) {
        if (upper &&
            cg.reachableFromEntryPoint(loop->getHeader()->getParent())) {
          errs() << "[Warning Path Analysis] No loop bound found for:\n"
                 << LoopBoundInfo->getLoopDesc(loop) << "\n";
          errs() << "Context: " << ctxMapElement.first.serialize() << "\n";
          if (ManualLoopBounds.getNumOccurrences() == 0) {
            errs() << "Use --ta-output-unknown-loops to autogenerate a "
                      "suitable loopbounds file\n";
          }
        }
        continue;
      }

      VarCoeffVector variables;
      auto loopBound =
          (LoopBoundInfo->*getLoopBoundFkt)(loop, ctxMapElement.first);
      DEBUG_WITH_TYPE("loopbound",
                      dbgs() << "Loop: " << LoopBoundInfo->getLoopDesc(loop)
                             << "\nContext: " << ctxMapElement.first.serialize()
                             << "\n");
      DEBUG_WITH_TYPE("loopbound", dbgs() << "The bound being used is "
                                          << loopBound << "\n");

      std::vector<std::set<std::pair<unsigned, unsigned>>> iter2backedges(
          LoopPeel + 1); // idx 0 -> zero-th iteration ,... last idx ->
                         // Cumulative iteration
      bool skipConstraints = false;

      // Build the constraint equation considering each state that is a
      // part of the current context
      for (const auto &stateId : ctxMapElement.second) {
        // for all predecessors / edges predId -> stateId
        for (unsigned predId : graph->getGraph().getPredecessors(stateId)) {
          auto edge = std::make_pair(predId, stateId);
          auto edgeTimesTakenVar = Variable::getEdgeVar(timesTakenType, edge);
          if (outStatesOutsideScope.count(predId) > 0) {
            // This is an incoming edge from somewhere outside of the loop
            variables.push_back(std::make_pair(edgeTimesTakenVar, loopBound));
            if (collectLoopInEdges) {
              loopInEdges.insert(edge);
            }
            // MJa: Are we sure that there are not possibly
            // in edges to different basic blocks within the
            // loop? Or would such loops not even be
            // considered as loops at this point?
          } else {
            // This is a back edge of the loop
            assert(outStatesWithinScope.count(predId) > 0 &&
                   "Predecessor state not in in pred basic block");
            variables.push_back(std::make_pair(edgeTimesTakenVar, -1));

            /**
             * For non-general mode (normal WCET) and upper bounds,
             * we identified infeasible paths where parts were actually not
             * connected. In the following, we generate a constraint that aims
             * at reducing the resulting overestimation: A backedge of a context
             * that describes a higher number of iteration can only be taken if
             * a corresponding number of backedges of preceding contexts (lower
             * iteration count) has been taken. It might also not be perfectly
             * precise for the upper bound case.
             */
            if (!isGeneralMode() && upper && LoopPeel > 0) {
              auto predCtx = graph->getContextOfState(predId);
              if (predCtx == nullptr) {
                skipConstraints = true;
                continue;
              }
              auto predCtxTokenList = predCtx->getTokenList();
              bool whilesuccess = false;
              while (!whilesuccess && predCtxTokenList.size() > 0) {
                // Get current topmost token
                auto lastToken = predCtxTokenList.back();
                predCtxTokenList.pop_back();
                if (auto loopPeelToken =
                        dynamic_cast<PartitionTokenLoopPeel *>(lastToken)) {
                  // If the loops do not match (this might be due to nesting and
                  // optimizations), try the next token
                  if (loopPeelToken->getLoop()->getBlocks() ==
                      loop->getBlocks()) {
                    assert(loopPeelToken->backedgeTakenCount() < LoopPeel &&
                           "Unexpected iteration count in context");
                    iter2backedges.at(loopPeelToken->backedgeTakenCount())
                        .insert(edge);
                    whilesuccess = true;
                  }
                } else if (auto loopIterToken =
                               dynamic_cast<PartitionTokenLoopIter *>(
                                   lastToken)) {
                  // If the loops do not match (this might be due to nesting and
                  // optimizations), try the next token
                  if (loopIterToken->getLoop()->getBlocks() ==
                      loop->getBlocks()) {
                    assert(loopIterToken->backedgeLeastTakenCount() ==
                               LoopPeel &&
                           "Unexpected iteration count in context");
                    iter2backedges.at(loopIterToken->backedgeLeastTakenCount())
                        .insert(edge);
                    whilesuccess = true;
                  }
                } else {
                  assert(0 && "Topmost tokens in context within loop were not "
                              "loop-related");
                }
              }
              assert(whilesuccess && "None of the topmost tokens of a context "
                                     "in a loop did match the expected loop.");
            }
          }
        }
      }

      if (isGeneralMode()) {
        std::set<GraphEdge> loopOutEdges;
        bool collectLoopOutEdges = std::get<2>(loopGetInnerEdgesImpl);
        if (collectLoopOutEdges) {
          // iterate over all basic blocks of the loop
          for (auto &loopBB : loop->blocks()) {
            // find successor basic blocks outside of the loop
            std::set<MachineBasicBlock *> successorsBlocksOutsideLoop;
            for (auto succBB : getNonEmptySuccessorBasicBlocks(*loopBB)) {
              if (!loop->contains(succBB)) {
                successorsBlocksOutsideLoop.insert(succBB);
              }
            }
            // if there are some, look for edges connecting the
            // current block to those successors
            if (!successorsBlocksOutsideLoop.empty()) {
              auto outStates = graph->getOutStates(loopBB);
              for (auto succBB : successorsBlocksOutsideLoop) {
                auto inStates = graph->getInStates(succBB);
                assert(inStates.size() > 0 &&
                       "Non empty BB should have in states");
                for (auto outState : outStates) {
                  for (auto inState : inStates) {
                    if (graph->getGraph().hasEdge(outState, inState)) {
                      auto edge = std::make_pair(outState, inState);
                      loopOutEdges.insert(edge);
                    }
                  }
                }
              }
            }
          }
        }

        // overapproximate edges inside loop
        auto &loopGetInnerEdges = std::get<0>(loopGetInnerEdgesImpl);
        auto edgesInsideLoop =
            loopGetInnerEdges(loopInEdges, loopOutEdges, entryBB);

        // overapproximate maximal nesting depth of this
        // loop in any possible call stack.
        assert(loop->getNumBlocks() > 0 &&
               "There should be no loop without basic blocks!");
        const MachineFunction *startFunction =
            (*loop->block_begin())->getParent();
        std::vector<const MachineBasicBlock *> loopBlocks;
        loopBlocks.insert(loopBlocks.end(), loop->block_begin(),
                          loop->block_end());
        // TODO: so far we only guarantee a bound in the
        // absence of any kind of recursion...
        const double UBNestingLoop =
            isFunctionPotentiallyReachableFrom(startFunction, loopBlocks)
                ? std::numeric_limits<double>::infinity()
                : 1.0;
        loopBlocks.clear();
        assert(UBNestingLoop >= 1.0 && "Values smaller than 1 make no sense.");
        if (UBNestingLoop == std::numeric_limits<double>::infinity()) {
          // TODO: For now we cannot create a loop
          // constraint with unbounded UBNestingLoop.
          // At least not in general mode.
          // But maybe we can find an alternative
          // constraint in such cases that is only
          // triggered in case the path does not start
          // in the loop (upper) / does not end in the
          // loop (!upper)...
          // MJa: see my notes from 11th Feb 2015
          continue;
        }
        double correctionCoeff = UBNestingLoop * loopBound;

        for (auto &edge : edgesInsideLoop) {
          if (upper) {
            // the upper bound on the number of
            // times the back edges can be taken
            // has to be increased if the considered
            // path starts inside the loop in order
            // to still be sound
            auto edgeIsStartVar = Variable::getEdgeVar(isStartType, edge);
            variables.push_back(
                std::make_pair(edgeIsStartVar, correctionCoeff));
          } else {
            // the lower bound on the number of
            // times the back edges can be taken
            // has to be decreased if the considered
            // path ends inside the loop in order
            // to still be sound
            auto edgeIsEndVar = Variable::getEdgeVar(isEndType, edge);
            variables.push_back(std::make_pair(edgeIsEndVar, -correctionCoeff));
          }
        }
      }

      // build constraint with the variables as defined before
      // Use greater equal(2) [for upper bound] or less equal (1) [for lower
      // bound] with 0
      GraphConstraint la = std::make_tuple(
          variables,
          upper ? ConstraintType::GreaterEqual : ConstraintType::LessEqual, 0);
      // add them to the correct set of constraints
      loopConstraints.push_back(la);

      if (!isGeneralMode() && upper && LoopPeel > 0 && !skipConstraints) {
        for (unsigned i = 0; i < LoopPeel; ++i) {
          // If the loop bound is not large enough, we do not want to build the
          // extended constraints as it is unreachable anyway but creates an
          // overflow in the subtraction below which is irritating
          if (loopBound <= i) {
            continue;
          }
          VarCoeffVector evariables;
          for (auto edge : iter2backedges[i]) {
            auto edgeTimesTakenVar = Variable::getEdgeVar(timesTakenType, edge);
            evariables.push_back(std::make_pair(
                edgeTimesTakenVar,
                (i == LoopPeel - 1) ? (loopBound - LoopPeel) : 1));
          }
          for (auto edge : iter2backedges[i + 1]) {
            auto edgeTimesTakenVar = Variable::getEdgeVar(timesTakenType, edge);
            evariables.push_back(std::make_pair(edgeTimesTakenVar, -1));
          }
          GraphConstraint extendedLoopConstr =
              std::make_tuple(evariables, ConstraintType::GreaterEqual, 0);
          // add them to the correct set of constraints
          loopConstraints.push_back(extendedLoopConstr);
        }
      }
    }
  }
}

void FlowConstraintProvider::buildCallReturnConstraints() {
  // Build nodes for all states in functions and basic blocks
  for (MachineFunction *currFunc :
       machineFunctionCollector->getAllMachineFunctions()) {
    for (auto &currMBB : *currFunc) {
      for (auto callsite : CallGraph::getGraph().getCallSitesInMBB(&currMBB)) {
        auto callStates = graph->getCallStates(callsite);
        auto returnStates = graph->getReturnStates(callsite);

        // we track the number of times we call
        // minus the number of times we return
        VarCoeffVector callsMinusReturns;

        std::set<GraphEdge> callEdges;
        bool collectCallEdges = std::get<1>(callSiteGetInnerEdgesImpl);
        std::set<GraphEdge> returnEdges;
        bool collectReturnEdges = std::get<2>(callSiteGetInnerEdgesImpl);

        for (auto vert : callStates) {
          for (auto succ : graph->getGraph().getSuccessors(vert)) {
            auto edge = std::make_pair(vert, succ);
            auto edgeTimesTakenVar = Variable::getEdgeVar(timesTakenType, edge);
            callsMinusReturns.push_back(std::make_pair(edgeTimesTakenVar, 1));
            if (collectCallEdges) {
              callEdges.insert(edge);
            }
          }
        }

        for (auto vert : returnStates) {
          for (auto pred : graph->getGraph().getPredecessors(vert)) {
            auto edge = std::make_pair(pred, vert);
            auto edgeTimesTakenVar = Variable::getEdgeVar(timesTakenType, edge);
            callsMinusReturns.push_back(std::make_pair(edgeTimesTakenVar, -1));
            if (collectReturnEdges) {
              returnEdges.insert(edge);
            }
          }
        }

        if (!isGeneralMode()) {
          // add constraint with equality (3) and 0
          GraphConstraint fc =
              std::make_tuple(callsMinusReturns, ConstraintType::Equal, 0);
          callReturnConstraints.push_back(fc);
        } else {
          // In the general case we can only generate two
          // less restrictive constraints.
          // But each one needs to be added different
          // coefficients from this point on.
          VarCoeffVector &varsEndSensitiveConstr = callsMinusReturns;
          VarCoeffVector varsStartSensitiveConstr(callsMinusReturns);

          // and for each of them we need an upper bound
          // on the number of possibly nested calls from
          // this call site
          const MachineFunction *startFunction =
              callsite->getParent()->getParent();
          std::vector<const MachineBasicBlock *> potCalleeBlocks;
          bool startFunctionPotentialCallee = false;
          for (auto potCallee :
               CallGraph::getGraph().getPotentialCallees(callsite)) {
            if (startFunction == potCallee) {
              startFunctionPotentialCallee = true;
              break;
            }
            for (auto &block : *potCallee) {
              potCalleeBlocks.insert(potCalleeBlocks.end(), &block);
            }
          }
          // TODO: so far be only guarantee a bound in the
          // absence of any kind of recursion...
          const double UBNestingCallSite =
              startFunctionPotentialCallee ||
                      isFunctionPotentiallyReachableFrom(startFunction,
                                                         potCalleeBlocks)
                  ? std::numeric_limits<double>::infinity()
                  : 1.0;
          potCalleeBlocks.clear();
          assert(UBNestingCallSite >= 1.0 &&
                 "Values smaller than 1 make no sense.");
          if (UBNestingCallSite == std::numeric_limits<double>::infinity()) {
            // TODO: For now we cannot create call-
            // return-constraints with unbounded
            // UBNestingCallSite.
            // At least not in general mode.
            // But maybe we can find alternative
            // constraints in such cases that are only
            // triggered in case the path does not start
            // inside the call site / does not end
            // inside the call site...
            // MJa: see my notes from 11th Feb 2015
            continue;
          }

          auto callSiteGetInnerEdges = std::get<0>(callSiteGetInnerEdgesImpl);
          auto edgesInsideCallSite =
              callSiteGetInnerEdges(callEdges, returnEdges, callsite);

          for (auto &edge : edgesInsideCallSite) {
            // a path ending inside the call site
            // may contain up to UBNestingCallSite
            // more calls than returns at this
            // call site
            auto edgeIsEndVar = Variable::getEdgeVar(isEndType, edge);
            varsEndSensitiveConstr.push_back(
                std::make_pair(edgeIsEndVar, -UBNestingCallSite));
            // a path starting inside the call site
            // may contain up to UBNestingCallSite
            // more returns than calls at this
            // call site
            auto edgeIsStartVar = Variable::getEdgeVar(isStartType, edge);
            varsStartSensitiveConstr.push_back(
                std::make_pair(edgeIsStartVar, UBNestingCallSite));
          }

          // a path ending inside the call site
          // may contain more calls than returns
          GraphConstraint endSensitiveConstr = std::make_tuple(
              varsEndSensitiveConstr, ConstraintType::LessEqual, 0);
          callReturnConstraints.push_back(endSensitiveConstr);

          // a path starting inside the call site
          // may contain more returns than calls
          GraphConstraint startSensitiveConstr = std::make_tuple(
              varsStartSensitiveConstr, ConstraintType::GreaterEqual, 0);
          callReturnConstraints.push_back(startSensitiveConstr);
        }
      }
    }
  }
}

void FlowConstraintProvider::buildStartConstraint() {
  // In program run mode we start by taking exactly one
  // outgoing edge from the special node 0.
  // Additionally, we have to specify that the
  // idle cycle between runs is never taken.
  if (programRunMode && !allowSeveralRuns) {
    // exactly one program start edge taken
    auto startEdgeTargets = graph->getGraph().getSuccessors(0);
    VarCoeffVector variables;
    for (auto edgeTarget : startEdgeTargets) {
      if (edgeTarget == 0) {
        continue;
      }
      auto edge = std::make_pair(0, edgeTarget);
      auto edgeTimesTakenVar = Variable::getEdgeVar(timesTakenType, edge);
      variables.push_back(std::make_pair(edgeTimesTakenVar, 1));
    }
    startConstraints.push_back(
        std::make_tuple(variables, ConstraintType::Equal, 1));

    // idle cycle never taken
    variables.clear();
    auto edge = std::make_pair(0, 0);
    auto edgeTimesTakenVar = Variable::getEdgeVar(timesTakenType, edge);
    variables.push_back(std::make_pair(edgeTimesTakenVar, 1));
    startConstraints.push_back(
        std::make_tuple(variables, ConstraintType::Equal, 0));
  }
  // in the general case, we only have to make sure
  // that there is at most one start edge and
  // at most one end edge of the path
  if (isGeneralMode()) {
    VarCoeffVector startVars;
    VarCoeffVector endVars;
    for (const auto &vertex : graph->getGraph().getVertices()) {
      const auto source = vertex.first;
      for (const auto &sink : vertex.second.getSuccessors()) {
        auto edge = std::make_pair(source, sink);
        auto edgeIsStartVar = Variable::getEdgeVar(isStartType, edge);
        startVars.push_back(std::make_pair(edgeIsStartVar, 1));
        auto edgeIsEndVar = Variable::getEdgeVar(isEndType, edge);
        endVars.push_back(std::make_pair(edgeIsEndVar, -1));
      }
    }
    // there is at most one start edge of the path
    startConstraints.push_back(
        std::make_tuple(startVars, ConstraintType::LessEqual, 1));
    // there is at most one end edge of the path
    startConstraints.push_back(
        std::make_tuple(endVars, ConstraintType::GreaterEqual, -1));
    // there are as many start edges as end edges
    VarCoeffVector startMinusEndVars(startVars);
    startMinusEndVars.insert(startMinusEndVars.end(), endVars.begin(),
                             endVars.end());
    startConstraints.push_back(
        std::make_tuple(startMinusEndVars, ConstraintType::Equal, 0));

    // If the program run mode is simulated by the
    // general mode, we say that an outgoing edge
    // of 0 starts the path and an incoming edge
    // of 0 ends it.
    if (programRunMode) {
      auto startEdgeTargets = graph->getGraph().getSuccessors(0);
      VarCoeffVector variables;
      for (auto edgeTarget : startEdgeTargets) {
        if (edgeTarget == 0) {
          continue;
        }
        auto edge = std::make_pair(0, edgeTarget);
        auto edgeIsStartVar = Variable::getEdgeVar(isStartType, edge);
        variables.push_back(std::make_pair(edgeIsStartVar, 1));
      }
      startConstraints.push_back(
          std::make_tuple(variables, ConstraintType::Equal, 1));
      variables.clear();
      auto endEdgeOrigins = graph->getGraph().getPredecessors(0);
      for (auto edgeOrigin : endEdgeOrigins) {
        if (edgeOrigin == 0) {
          continue;
        }
        auto edge = std::make_pair(edgeOrigin, 0);
        auto edgeIsEndVar = Variable::getEdgeVar(isEndType, edge);
        variables.push_back(std::make_pair(edgeIsEndVar, 1));
      }
      startConstraints.push_back(
          std::make_tuple(variables, ConstraintType::Equal, 1));
    }
  }
}

bool FlowConstraintProvider::isGeneralMode() const {
  return !programRunMode || simulateProgramRunModeByGeneralMode;
}

std::tuple<std::function<std::set<GraphEdge>(
               const std::set<GraphEdge> &inEdges,
               const std::set<GraphEdge> &outEdges, const void *cacheId)>,
           bool, bool>
FlowConstraintProvider::initializeGetInnerEdgesImpl(
    typename GetEdges::method method) {
  if (isGeneralMode()) {
    assert(getEdges && "Did you forget to initialize the GetEdges-object?");
    switch (method) {
    case GetEdges::method::all: {
      auto function = [this](const std::set<GraphEdge> &inEdges,
                             const std::set<GraphEdge> &outEdges,
                             const void *cacheId) { return getEdges->all(); };
      return std::make_tuple(function, false, false);
    } break;
    case GetEdges::method::insideProgramRuns: {
      auto function = [this](const std::set<GraphEdge> &inEdges,
                             const std::set<GraphEdge> &outEdges,
                             const void *cacheId) {
        return getEdges->insideProgramRuns();
      };
      return std::make_tuple(function, false, false);
    } break;
    case GetEdges::method::betweenInOutReachableSimple: {
      auto function = [this](const std::set<GraphEdge> &inEdges,
                             const std::set<GraphEdge> &outEdges,
                             const void *cacheId) {
        return getEdges->betweenInOutReachableSimple(inEdges, outEdges,
                                                     cacheId);
      };
      return std::make_tuple(function, true, true);
    } break;
    case GetEdges::method::betweenInOutReachableSimplePlus: {
      auto function = [this](const std::set<GraphEdge> &inEdges,
                             const std::set<GraphEdge> &outEdges,
                             const void *cacheId) {
        return getEdges->betweenInOutReachableSimplePlus(inEdges, outEdges,
                                                         cacheId);
      };
      return std::make_tuple(function, true, true);
    } break;
    case GetEdges::method::betweenInOutReachableDetailed: {
      auto function = [this](const std::set<GraphEdge> &inEdges,
                             const std::set<GraphEdge> &outEdges,
                             const void *cacheId) {
        return getEdges->betweenInOutReachableDetailed(inEdges, outEdges,
                                                       cacheId);
      };
      return std::make_tuple(function, true, true);
    } break;
    default:
      assert(false && "Unsupported get-edges-method!");
      break;
    }
  } else {

    auto function = [](const std::set<GraphEdge> &inEdges,
                       const std::set<GraphEdge> &outEdges,
                       const void *cacheId) {
      assert(false &&
             "This method is not implemented in case isGeneralMode() == false");
      std::set<GraphEdge> emptySet;
      return emptySet;
    };
    return std::make_tuple(function, false, false);
  }
}

} // namespace TimingAnalysisPass
