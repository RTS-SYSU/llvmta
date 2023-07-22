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

#ifndef STATESENSITIVEGRAPH_H
#define STATESENSITIVEGRAPH_H

#include "Util/Graph.h"
#include "Util/Util.h"

#include "MicroarchitecturalAnalysis/MicroArchitecturalState.h"
#include "PathAnalysis/StateGraph.h"

#include <fstream>
#include <string>
#include <unordered_map>

//#define STOP_MOVE_MIDSTATES_THRESHOLD 100
#define STOP_MOVE_MIDSTATES_THRESHOLD 0

namespace TimingAnalysisPass {

/**
 * Class representing the context- and microarchitectural-state-sensitive graph.
 * This is feed as input to the path analysis.
 *
 * Important Implementation details:
 *
 * When we consider multiple different weights per edge, we run into trouble
 * when using joining. Why? For a (simple) pipeline, after a certain number of
 * steps the states converge, thus also leading to edges joined. These edges
 * might now have different weights and joining can lead to significant
 * precision loss, e.g. when counting definite misses. Thus, in certain cases we
 * do not want to join edges, but keep them separate. This decision should be
 * met solely be the individual weight providers. If edges are now considered
 * non-joinable, we have several options. 1) Between two vertices, keep several
 * weight tuples, thus several edges. However, e.g. when considering definite
 * misses again, this might lead to an exponential blowup of edges when several
 *  such non-joining decisions are met within one basicblock.
 * 2) Keep one edge per vertex-pair, but keep the intermediate states that are
 * joined into one. From these states add a neutral-weight edge to the joined
 * one. This is described in a similar way in the dissertation of Ingmar Stein,
 * page 44, as "subsume edges". This does not directly lead to an exponential
 * blowup - it is basically left for the later ILP solver.
 */
template <class MicroArchDom>
class StateSensitiveGraph : public MuStateGraph<typename MicroArchDom::State> {
public:
  typedef AnalysisInformation<PartitioningDomain<MicroArchDom, MachineInstr>,
                              MachineInstr>
      MuAnaInfo;

  typedef typename MicroArchDom::State State;

  /**
   * Constructor
   */
  StateSensitiveGraph(const MuAnaInfo &mai)
      : mai(mai), graph(), currentBasicBlock(nullptr) {
    debugDumpNo++;
  }

  void buildGraph();

  virtual void freeMuStates() { id2state.clear(); }

  typename State::StateSet getStatesForId(unsigned id) {
    typename State::StateSet res;
    res.insert(id2state.at(id));
    return res;
  }

  const Graph &getGraph() const { return graph; }

  std::vector<unsigned> getInStates(const MachineBasicBlock *mbb) const {
    std::vector<unsigned> result;
    for (auto &ctx2ids : inStatesPerMBBPerContext.at(mbb)) {
      result.insert(result.end(), ctx2ids.second.begin(), ctx2ids.second.end());
    }
    return result;
  }

  std::vector<unsigned> getOutStates(const MachineBasicBlock *mbb) const {
    std::vector<unsigned> result;
    for (auto &ctx2ids : outStatesPerMBBPerContext.at(mbb)) {
      result.insert(result.end(), ctx2ids.second.begin(), ctx2ids.second.end());
    }
    return result;
  }

  std::vector<unsigned> getCallStates(const MachineInstr *mi) const {
    assert(mi->isCall() && "Call States only at calls");
    if (callStates.count(mi) > 0) {
      return callStates.at(mi);
    }
    std::vector<unsigned> res;
    return res;
  }

  std::vector<unsigned> getReturnStates(const MachineInstr *mi) const {
    assert(mi->isCall() && "Return States only at calls");
    std::vector<unsigned> res;
    if (returnStates.count(mi) > 0) {
      for (auto &ctx2retid : returnStates.at(mi)) {
        res.insert(res.end(), ctx2retid.second.begin(), ctx2retid.second.end());
      }
    }
    return res;
  }

  const Context *getContextOfState(unsigned stateid) const {
    return &id2context.at(stateid);
  }

  void dump(std::ostream &mystream,
            const std::map<std::string, double> *optTimesTaken) const;

  void deleteMuArchInfo();

private:
  /**
   * Collects all In- and Out-States for all basic blocks.
   * For all States, creates a vertex in the graph.
   */
  void collectInOutStatesPerBB();

  /**
   * Adds one in-state and one out-state for the given function and
   * adds an edge in between them.
   */
  void addExternalFunctionToGraph(std::string functionName);

  /**
   * Cycles through all basic blocks and builds connections from in- to
   * out-states. Remembers the callStates and the call edges to insert them
   * later. Remembers the returnStates. (And later add edges to them from the
   * outs of callee)
   */
  void buildIntraBasicBlockEdges();

  std::set<unsigned>
  progressStatesForProgLoc(std::set<unsigned> workingSetOfStates,
                           ProgramLocation progLoc);

  void
  cycleUntilFinal(std::set<unsigned> &finalStates,
                  std::set<unsigned> *
                      waitingForJoinStates, // If null, then compute up to final
                  unsigned currWorkingState, ExecutionElement execLoc);

  /**
   * Pushes mid states (that are used to handle non-joinable edges),
   * down the graph to the current instruction-level.
   * This allows the joining later on to join more identical edges.
   */
  void moveMidStatesDown(const std::set<unsigned> &finalStatesIds,
                         std::set<unsigned> &dupFinalStatesIds);

  /**
   * Join joinable states. If there are non-joinable edges, use duplicate states
   * to represent these multiple edges. The duplicates are stored in
   * succ2alternatives.
   */
  void joinFinalStates(const std::set<unsigned> &finalStatesIds,
                       std::set<unsigned> &successorSet,
                       std::multimap<unsigned, unsigned> &succ2alternatives);

  void handleCallInstructions(const MachineInstr *MI, const Context &Ctx,
                              std::set<unsigned> &workingSet);

  void filterExitingStates(const MachineInstr *MI, const Context &Ctx,
                           std::set<unsigned> &workingSet);

  // Virtual helper functions for manipulating the weighted edges
  /**
   * Add an initial self-edge while intra-basic-block weights are constructed.
   */
  void addInitialEdge(unsigned s);
  /**
   * Advance all incoming edges of curr towards each state of succs.
   * This does *NOT* involve updating the weights. This has to be triggered
   * separately. Finally delete the curr state.
   */
  void advanceEdges(unsigned curr, std::list<unsigned> succs);
  /**
   * Move the edge targets of all edges p->t from t to nt.
   * If the edge p->nt already existed, join weights.
   * If joining is not allowed on at least one edge, then keep t and the
   * non-joinable edges separate and return true.
   * Otherwise, if all joining went well, remove t (if not selfedge before) and
   * return false.
   */
  bool updateEdgeTarget(unsigned t, unsigned nt);

  /**
   * Adds edges between all states from end of basic blocks to the succeeding
   *basic block. Also adds edges from the last basic block of a function to the
   *corresponding state in the calling function. Furthermore, it adds the call
   *edges.
   */
  void buildInterBasicBlockEdges();

  void buildExternalSymbolReturnEdges();

  /**
   * Adds given States as vertices to the graph.
   * Returns all added ids in a set.
   */
  void addStatesToGraph(
      std::unordered_map<Context, std::vector<unsigned>> &stateIds,
      const std::unordered_map<Context, std::vector<State>> &states);

  void extractStatesFromAnaInfo(
      std::unordered_map<Context, std::vector<State>> *result,
      std::unordered_map<Context, MicroArchDom> ctx2anaInfoMap);

  std::unordered_map<Context, std::vector<State>>
  getIncomingStates(MachineBasicBlock &mbb);

  std::unordered_map<Context, std::vector<State>>
  getOutgoingStates(MachineBasicBlock &mbb);

  /**
   * Checks whether second is a direct successor state of first.
   * This represents the "less-equal" operator for states.
   */
  bool isDirectSuccessor(const State &state1, const State &state2) const;

  /**
   * Microarchitectural analysis information given by the calling class.
   */
  const MuAnaInfo &mai;

  /**
   * The Graph, represented by vertices.
   * All vertices know their incoming and outgoing edges.
   */
  Graph graph;

  /**
   * All Microarchitectural states and contexts for vertices, represented by
   * ids.
   */
  std::map<unsigned, Context> id2context;
  std::map<unsigned, State> id2state;

  /**
   * A map containing all incoming vertex ids per basic block.
   * These represent incoming states at the beginning of a basic block.
   */
  std::map<const MachineBasicBlock *,
           std::unordered_map<Context, std::vector<unsigned>>, mbbComp>
      inStatesPerMBBPerContext;

  /**
   * A map containing all outgoing vertex ids per basic block.
   */
  std::map<const MachineBasicBlock *,
           std::unordered_map<Context, std::vector<unsigned>>, mbbComp>
      outStatesPerMBBPerContext;

  /**
   * Map containing additional states we need for dumping purposes.
   */
  std::map<const MachineBasicBlock *, std::set<unsigned>> additionalStates;

  /**
   * Map which contains all call states, separated by basic block and callsite
   * (MI).
   */
  std::map<const MachineInstr *, std::vector<unsigned>, instrptrcomp>
      callStates;

  std::map<const MachineInstr *,
           std::unordered_map<Context, std::vector<unsigned>>, instrptrcomp>
      returnStates;

  /**
   * A map containing the in- and out-Vertex for all external functions.
   */
  std::map<std::string, GraphEdge> extFuncVertices;

  const MachineBasicBlock *currentBasicBlock;

  std::ofstream debugDump;

  /**
   * Remember the IDs of states that should be marked
   * as persistent in the construction of the graph.
   * This means they will not be moved or optimized
   * away in the construction of the graph.
   */
  std::set<unsigned> persistStates;
};

template <class MicroArchDom>
void StateSensitiveGraph<MicroArchDom>::buildGraph() {
  // add special vertex with id 0 which is used to connect all start and return
  // states
  graph.addVertex();

  collectInOutStatesPerBB();

  buildIntraBasicBlockEdges();

  buildInterBasicBlockEdges();

  buildExternalSymbolReturnEdges();
}

template <class MicroArchDom>
void StateSensitiveGraph<MicroArchDom>::collectInOutStatesPerBB() {
  for (MachineFunction *currFunc :
       machineFunctionCollector->getAllMachineFunctions()) {
    for (auto &currMBB : *currFunc) {
      // collect incoming states and add them
      auto incSts = getIncomingStates(currMBB);
      addStatesToGraph(inStatesPerMBBPerContext[&currMBB], incSts);

      // collect outgoing states and add them
      auto outSts = getOutgoingStates(currMBB);
      addStatesToGraph(outStatesPerMBBPerContext[&currMBB], outSts);
    }
  }
}

template <class MicroArchDom>
void StateSensitiveGraph<MicroArchDom>::addExternalFunctionToGraph(
    std::string functionName) {
  unsigned inState = graph.addVertex();
  unsigned outState = graph.addVertex();
  graph.addEdge(inState, outState);
  extFuncVertices[functionName] = std::make_pair(inState, outState);
  // Handle callbacks
  for (auto cb : this->constructionCallbacks) {
    cb->addExternalEdge(functionName, inState, outState);
  }
}

template <class MicroArchDom>
void StateSensitiveGraph<MicroArchDom>::cycleUntilFinal(
    std::set<unsigned> &finalStates, std::set<unsigned> *waitingForJoinStates,
    unsigned currWorkingState, ExecutionElement execLoc) {
  // If we do not need any cycling for this state to become final
  State start(id2state.at(currWorkingState));
  bool startfinal = start.isFinal(execLoc);
  if (startfinal) {
    // We create a new id for, with new context, etc.
    // We update all edge weights to move ones further without changing the
    // weight. Later on, do the normal advanceEdges stuff on the graph
    unsigned freshId = graph.addVertex();
    id2context.insert(std::make_pair(freshId, execLoc.second));
    id2state.insert(std::make_pair(freshId, start));
    finalStates.insert(freshId);
    std::list<unsigned> succStateIds;
    succStateIds.push_back(freshId);
    for (auto cb : this->constructionCallbacks) {
      for (auto pred : graph.getPredecessors(currWorkingState)) {
        cb->updateEdgeTarget(pred, currWorkingState, freshId, true);
      }
    }
    advanceEdges(currWorkingState, succStateIds);
    // transfer persistence to the edge target if edge join was successful
    const bool currPersist = persistStates.count(currWorkingState) > 0;
    if (currPersist) {
      persistStates.erase(currWorkingState);
      persistStates.insert(freshId);
    }

    DEBUG_WITH_TYPE("detailedStateGraph",
                    debugDump << "node : {\n	title : \"" << freshId
                              << "\"\n	label : \"Mid-" << freshId << "\"\n";
                    debugDump << "info1 : \"" << id2state.at(freshId)
                              << "\"\n}\n";);

    // nothing left to do in this case
    return;
  }

  // MJa: we explicitly ignore if currWorkingState is waiting
  // for join.
  // - for the initial states entering the instruction,
  //   this is done by the micro-ach anal in the same way.
  // - if currWorkingState was spit out by an earlier call
  //   to cycleUntilFinal as element of waitingForJoinStates,
  //   we avoid an infinite loop.

  // init current states (still having to be cycled)
  std::list<unsigned> currStates;
  currStates.push_back(currWorkingState);

  // make sure to not cycle identical abstract states
  // over and over again
  typename State::template MapFromStates<unsigned> knownState2id;
  // std::unordered_map<State, unsigned> knownState2id; // this was missing the
  // state hash type...
  knownState2id.emplace(start, currWorkingState);

  // immediate successor state ids discovered so far for a state id
  std::map<unsigned, std::list<unsigned>> successors;

  // number of remaining predecessor ids per state id
  std::map<unsigned, unsigned> numRemainingPredecessors;

  // cycle all states from currStates until the set is empty
  // -> assign ids to all successors discovered
  // -> remember successor relation between ids
  // -> remember per successor how many predecessors it has
  while (!currStates.empty()) {
    DEBUG_WITH_TYPE("graphilp", dbgs() << "Cycle until final: #states "
                                       << currStates.size() << "\n");
    auto currStateId = currStates.front();
    auto &currState = id2state.at(currStateId);

    auto anaDeps = mai.getAnaDepsInfo();
    // cycle the state. this might lead to a split and multiple resulting states
    for (auto &succ : currState.cycle(anaDeps)) {
      if (knownState2id.count(succ) > 0) {
        unsigned succId = knownState2id[succ];
        successors[currStateId].push_back(succId);
        assert(numRemainingPredecessors.count(succId) > 0);
        ++numRemainingPredecessors[succId];
        continue;
      }
      State st(succ);
      bool stfinal = st.isFinal(execLoc);
      unsigned stId = graph.addVertex();
      id2context.insert(std::make_pair(stId, execLoc.second));
      id2state.insert(std::make_pair(stId, st));
      successors[currStateId].push_back(stId);
      assert(numRemainingPredecessors.count(stId) == 0);
      numRemainingPredecessors.emplace(stId, 1);
      if (stfinal) {
        finalStates.insert(stId);
      } else if (waitingForJoinStates != nullptr && succ.isWaitingForJoin()) {
        // handle it like a final state, just
        // store it into a different set
        waitingForJoinStates->insert(stId);
      } else {
        currStates.push_back(stId);
      }
      knownState2id.emplace(succ, stId);

      DEBUG_WITH_TYPE(
          "detailedStateGraph", debugDump << "node : {\n	title : \""
                                          << stId << "\"\n	label : \"Mid-"
                                          << stId << "\"\n";
          debugDump << "info1 : \"" << id2state.at(stId) << "\"\n}\n";);
    }

    // delete current state (before cycling) from the list
    currStates.pop_front();
  }

  // cycling is finished, the mapping from
  // known states to ids is no longer needed
  knownState2id.clear();

  // iterate over the state ids in topological order
  // -> topol. order is guaranteed by always drawing from
  // nodeIdsWithoutPredecessors
  // -> reset the edges and manipulate the respective weights
  std::list<unsigned> &nodeIdsWithoutPredecessors = currStates;
  nodeIdsWithoutPredecessors.push_back(currWorkingState);
  while (!nodeIdsWithoutPredecessors.empty()) {
    DEBUG_WITH_TYPE("graphilp",
                    dbgs() << "Create edges after cycling until final: #states "
                           << nodeIdsWithoutPredecessors.size() << "\n");
    auto currStateId = nodeIdsWithoutPredecessors.front();

    // if currStateId is persistent, we first need
    // to clone it and add an empty edge to it
    // MJa: TODO: this might be a problem for
    // persistent midstates in the middle of a
    // instruction because similar ones of them
    // are never joined. So far, however, we only
    // get persistent states that are in/out states
    // of instructions...
    // Possible solution:
    // Currently, states are only marked as persistent
    // by the graph construction itself, in order to
    // avoid a too high runtime for the construction.
    // Later, the states should maybe also be able
    // to decide for themselves whether they should
    // be persistent. Maybe we should then implement
    // isWaitingForJoin in a way that is always true
    // for states that want to be persistent. In this
    // way, the joining would automatically also
    // happen...
    if (persistStates.count(currStateId) > 0) {
      assert(currStateId == currWorkingState &&
             "So far, only the input state should be persistent.");
      unsigned freshId = graph.addVertex();
      id2context.insert(std::make_pair(freshId, id2context.at(currStateId)));
      id2state.insert(std::make_pair(freshId, id2state.at(currStateId)));
      // establish neutral edge weights
      for (auto cb : this->constructionCallbacks) {
        cb->updateEdgeTarget(currStateId, currStateId, freshId, false);
      }
      graph.addEdge(currStateId, freshId);

      DEBUG_WITH_TYPE(
          "detailedStateGraph", debugDump << "node : {\n	title : \""
                                          << freshId << "\"\n	label : \"Mid-"
                                          << freshId << "\"\n";
          debugDump << "info1 : \"" << id2state.at(freshId) << "\"\n}\n";
          debugDump << "edge : {\n	sourcename : \"" << currStateId
                    << "\" targetname : \"" << freshId
                    << "\"\n	label : \"epsilon (due to persist)\"\n}\n";);

      successors.emplace(freshId, successors[currStateId]);
      successors.erase(currStateId);
      currStateId = freshId;
    }

    // only reset the edges if there are successors
    if (successors.count(currStateId) > 0) {
      std::list<unsigned> &succStateIds = successors[currStateId];
      assert(!succStateIds.empty());

      // for each construction callback, prepare the
      // advancing of the edges. at the same time,
      // accumulate a set of failed successors.
      std::set<unsigned> failedSuccessors;
      for (auto cb : this->constructionCallbacks) {
        auto failed = cb->advanceEdgesPrepare(currStateId, succStateIds);
        failedSuccessors.insert(failed.begin(), failed.end());
      }

      if (failedSuccessors.empty()) {
        // there were no failed successors.
        // so go on and commit the advancement of
        // the edges in the construction callbacks.
        for (auto cb : this->constructionCallbacks) {
          cb->advanceEdgesCommit();
        }
        // finally, change the edges in the graph
        advanceEdges(currStateId, succStateIds);
      } else {
        // roll back the prepared changes
        for (auto cb : this->constructionCallbacks) {
          cb->advanceEdgesRollBack();
        }
        // create a new list of successors
        std::list<unsigned> repairedSuccessors;
        // take care of each failed successor
        for (auto failedSucc : failedSuccessors) {
          // clone it
          unsigned freshId = graph.addVertex();
          id2context.insert(std::make_pair(freshId, id2context.at(failedSucc)));
          id2state.insert(std::make_pair(freshId, id2state.at(failedSucc)));
          // if the original is final or waiting for join,
          // the fresh node has to be the same
          if (finalStates.count(failedSucc) > 0) {
            finalStates.insert(freshId);
          } else if (waitingForJoinStates != nullptr &&
                     waitingForJoinStates->count(failedSucc) > 0) {
            waitingForJoinStates->insert(freshId);
          }
          // if the original should be persisted,
          // the fresh node should also be persisted
          if (persistStates.count(failedSucc) > 0) {
            persistStates.insert(freshId);
          }
          // the fresh node has no unprocessed predecessors
          nodeIdsWithoutPredecessors.push_back(freshId);
          // if the original node has successors, the fresh
          // node has the same successors.
          if (successors.count(failedSucc) > 0) {
            auto successorsUpdated =
                successors.emplace(freshId, successors[failedSucc]);
            assert(successorsUpdated.second);
            // each successor of the failed successor now
            // has one predecessor more, namely the fresh node
            for (auto succId : successorsUpdated.first->second) {
              assert(numRemainingPredecessors.count(succId) > 0);
              ++numRemainingPredecessors[succId];
            }
          }
          // add the fresh id to the successors
          repairedSuccessors.push_back(freshId);
        }
        // now create an updated successor list
        for (auto succId : succStateIds) {
          if (failedSuccessors.count(succId) == 0) {
            repairedSuccessors.push_back(succId);
          }
        }
        // finally perform the edge advancement.
        // this time, we know it cannot fail.
        for (auto cb : this->constructionCallbacks) {
          cb->advanceEdges(currStateId, repairedSuccessors);
        }
        advanceEdges(currStateId, repairedSuccessors);
      }

      // for each successor, remove the current state
      // from the number of predecessors
      for (auto succId : succStateIds) {
        assert(numRemainingPredecessors.count(succId) > 0);
        unsigned &numRemPred = numRemainingPredecessors[succId];
        assert(numRemPred > 0);
        // decrement number of remaining predecessors
        --numRemPred;
        if (numRemPred == 0) {
          // successor has no remaining predecessors
          nodeIdsWithoutPredecessors.push_back(succId);
        }
      }
    }

    // delete current state (before cycling) from the list
    nodeIdsWithoutPredecessors.pop_front();
  }
}

template <class MicroArchDom>
void StateSensitiveGraph<MicroArchDom>::buildIntraBasicBlockEdges() {
  DEBUG_WITH_TYPE("graphilp", dbgs()
                                  << "Entering buildIntraBasicBlockEdges()\n");
  for (MachineFunction *currFunc :
       machineFunctionCollector->getAllMachineFunctions()) {
    for (auto &currMBB : *currFunc) {
      DEBUG_WITH_TYPE("graphilp", dbgs() << "Process new BB: "
                                         << currMBB.getFullName() << "\n");
      this->currentBasicBlock = &currMBB; // Remember current basic block

      DEBUG_WITH_TYPE(
          "detailedStateGraph", std::string filename("StateGraph_");
          filename += std::to_string(debugDumpNo) + "_";
          filename += this->currentBasicBlock->getParent()->getName().str();
          filename += "_BB";
          filename += std::to_string(this->currentBasicBlock->getNumber());
          filename += ".vcg"; debugDump.open(filename);
          debugDump << "graph : { \n layoutalgorithm : hierarchic\n	graph "
                       ": {\n	title : \"State Graph\"\n	label : "
                       "\"Microarchitectural State Graph\"\n";
          debugDump << "graph : {\n	title : \"BB"
                    << this->currentBasicBlock->getNumber()
                    << "\"\n	label : \"BB"
                    << this->currentBasicBlock->getNumber() << "\"\n";);

      // During the creation of the subgraph for a given basic block, we build
      // mid-states. After the basic block graph is built, we do not need
      // information stored for these nodes any more.
      std::set<unsigned> midStatesToFree;

      // for each context in this basic block (empty basic blocks iterate over
      // empty set)
      for (auto &ctxStatesMap : inStatesPerMBBPerContext.at(&currMBB)) {
        Context Ctx = ctxStatesMap.first;
        // all incoming states for this basic block and context are now in
        // ctxStatesMap.second do not process empty context (basic blocks)
        if (ctxStatesMap.second.empty())
          continue;

        // init working set with all states of this context
        std::set<unsigned> workingSetOfStates;
        workingSetOfStates.insert(ctxStatesMap.second.begin(),
                                  ctxStatesMap.second.end());

        // add initial self-edges for incoming states
        for (auto elem : workingSetOfStates) {
          addInitialEdge(elem);

          DEBUG_WITH_TYPE(
              "detailedStateGraph", debugDump << "node : {\n	title : \""
                                              << elem << "\"\n	label : \"In-"
                                              << elem << "\"\n";
              debugDump << "info1 : \"" << id2state.at(elem) << "\"\n}\n";);
        }

        // We insert all nodes into the midStatesToFree set, but in-, out-,
        // call-, and return-states. This is achieved automatically for call-
        // and out- states, but requires an explicit skip for the first
        // instruction of a basic block as well as after each call.
        bool skip = true;

        // process one instruction after the other
        for (auto &instr : currMBB) {
          DEBUG_WITH_TYPE("graphilp", dbgs() << "Process next instruction: "
                                             << instr << "\n");

          // update context with directives before instruction
          if (DirectiveHeuristicsPassInstance->hasDirectiveBeforeInstr(
                  &instr)) {
            Ctx.update(DirectiveHeuristicsPassInstance->getDirectiveBeforeInstr(
                &instr));
          }

          // Remember the current states
          std::set<unsigned> oldMidStates = workingSetOfStates;

          // If non-transient instruction, do cycling, otherwise skip
          if (!instr.isTransient()) {
            // construct program location to check for final in the
            // microarchitecture
            ProgramLocation progLoc = std::make_pair(&instr, Ctx);
            // Progress the workingset for this progloc, i.e. cycle all states
            // until final
            workingSetOfStates =
                progressStatesForProgLoc(workingSetOfStates, progLoc);

            if (!skip) {
              // Remember to free information for the midStates arised from the
              // previous cycle
              midStatesToFree.insert(oldMidStates.begin(), oldMidStates.end());
            } else {
              skip = false;
            }
          }

          // Handle potential call instruction,
          // i.e. save the workingset to the callStates and restore the return
          // states
          if (instr.isCall()) {
            handleCallInstructions(&instr, Ctx, workingSetOfStates);
            // We have a call instruction and we need the state/context for the
            // return states later, so don't free them
            skip = true;
          }

          // Context changes have to be accounted for
          if (DirectiveHeuristicsPassInstance->hasDirectiveAfterInstr(&instr)) {
            Ctx.update(DirectiveHeuristicsPassInstance->getDirectiveAfterInstr(
                &instr));
          }

          // remove from working set, if this is a final instruction of a basic
          // block
          if (isEndInstr(currMBB, &instr)) {
            filterExitingStates(&instr, Ctx, workingSetOfStates);
          }
        }

        assert(workingSetOfStates.size() == 0 &&
               "At the end of a basic block, no state can survive");
      }
      DEBUG_WITH_TYPE("detailedStateGraph", debugDump << "}\n}\n}";
                      debugDump.close(););

      // If we are in quiet mode, we do not need state/context information about
      // midStates, so free it
      if (QuietMode) {
        for (auto mId : midStatesToFree) {
          id2context.erase(mId);
          id2state.erase(mId);
        }
      }
    }
  }
}

template <class MicroArchDom>
void StateSensitiveGraph<MicroArchDom>::buildInterBasicBlockEdges() {
  DEBUG_WITH_TYPE("graphilp", dbgs()
                                  << "Entering buildInterBasicBlockEdges()\n");

  // Add call edges to the graph (determined earlier)
  for (auto &callsite2states : callStates) {
    auto instr = callsite2states.first;
    assert(instr->isCall() && "Callsite is not a call instruction");
    // external symbol, no call to a function in the program
    DEBUG_WITH_TYPE("graphilp", dbgs() << "StateSensitiveGraph, Line: "
                                       << __LINE__ << "\n");
    if (CallGraph::getGraph().callsExternal(instr)) {
      const auto &funcName = CallGraph::getGraph().getExternalCalleeName(instr);
      if (extFuncVertices.count(funcName) == 0) {
        addExternalFunctionToGraph(funcName);
      }
      unsigned calleeInId = std::get<0>(extFuncVertices.at(funcName));
      for (auto callId : callsite2states.second) {
        graph.addEdge(callId, calleeInId);
      }
    } else { // real call to another function
      auto mfs = CallGraph::getGraph().getPotentialCallees(instr);
      assert(mfs.size() == 1 && "Not exactly one function found for call");
      DEBUG_WITH_TYPE("graphilp",
                      dbgs() << "StateSensitiveGraph: Building call edge from "
                             << *instr << " to function "
                             << mfs.front()->getName().str() << "\n");
      // get first (non-empty) basic block of that function
      std::list<MBBedge> initialedgelist;
      const MachineBasicBlock *pMbb =
          getFirstInstrInFunction(mfs.front(), initialedgelist)->getParent();
      assert(!isBasicBlockEmpty(pMbb));

      for (auto callId : callsite2states.second) {
        DEBUG_WITH_TYPE("graphilp", dbgs() << "StateSensitiveGraph, Line: "
                                           << __LINE__ << ", callstates size: "
                                           << callsite2states.second.size()
                                           << ", callId: " << callId << "\n");
        DEBUG_WITH_TYPE("graphilp", dbgs() << "StateSensitiveGraph, Line: "
                                           << __LINE__ << "\n");
        bool foundSucc = false;
        // Our context before calling must be reduced and updated to match the
        // context on callee site
        Context calleeCtx = id2context.at(callId);
        DEBUG_WITH_TYPE("graphilp", std::cerr << "Callee ctx: " << calleeCtx
                                              << ", State: "
                                              << id2state.at(callId) << "\n");
        calleeCtx.reduceOnCall();
        if (DirectiveHeuristicsPassInstance->hasDirectiveOnCall(mfs.front())) {
          calleeCtx.update(
              DirectiveHeuristicsPassInstance->getDirectiveOnCall(mfs.front()));
        }
        // Potentially saw a context edge if the first BB in callee was empty
        for (auto &edge : initialedgelist) {
          if (DirectiveHeuristicsPassInstance->hasDirectiveOnEdgeEnter(edge)) {
            for (auto direc :
                 *DirectiveHeuristicsPassInstance->getDirectiveOnEdgeEnter(
                     edge)) {
              calleeCtx.update(direc);
            }
          }
          calleeCtx.transfer(edge);
          if (DirectiveHeuristicsPassInstance->hasDirectiveOnEdgeLeave(edge)) {
            for (auto direc :
                 *DirectiveHeuristicsPassInstance->getDirectiveOnEdgeLeave(
                     edge)) {
              calleeCtx.update(direc);
            }
          }
        }
        DEBUG_WITH_TYPE("graphilp", dbgs() << "StateSensitiveGraph, Line: "
                                           << __LINE__ << "\n");
        DEBUG_WITH_TYPE("graphilp", dbgs() << "InStatesPerMBBPerContext size: "
                                           << inStatesPerMBBPerContext.size()
                                           << "\n");
        DEBUG_WITH_TYPE("graphilp",
                        dbgs() << "InStatesPerMBBPerContext.at(Mbb).size(): "
                               << inStatesPerMBBPerContext.at(pMbb).size()
                               << "\n");
        for (auto ctx : inStatesPerMBBPerContext.at(pMbb)) {
          DEBUG_WITH_TYPE("graphilp",
                          std::cerr << "ctx: " << ctx.first << "\n");
          // for (auto st : inStatesPerMBBPerContext)
        }
        DEBUG_WITH_TYPE("graphilp",
                        std::cerr << "Callee ctx: " << calleeCtx << "\n");
        DEBUG_WITH_TYPE(
            "graphilp",
            dbgs() << "InStates.at(mbb).at(ctx).size(): "
                   << inStatesPerMBBPerContext.at(pMbb).at(calleeCtx).size()
                   << "\n");
        for (unsigned calleeId :
             inStatesPerMBBPerContext.at(pMbb).at(calleeCtx)) {
          DEBUG_WITH_TYPE("graphilp", dbgs() << "StateSensitiveGraph, Line: "
                                             << __LINE__ << "\n");
          if (isDirectSuccessor(id2state.at(callId), id2state.at(calleeId))) {
            // corresponding state in other function found!
            graph.addEdge(callId, calleeId);
            foundSucc = true;
            break;
          }
        }
        assert(foundSucc && "Calling state does not match states at callee");
      }
    }
  }
  DEBUG_WITH_TYPE("graphilp",
                  dbgs() << "StateSensitiveGraph, Line: " << __LINE__ << "\n");

  // Add inter basic-block and return edges
  for (MachineFunction *currFunc :
       machineFunctionCollector->getAllMachineFunctions()) {
    for (auto &currMBB : *currFunc) {
      for (auto outCtxStMap : outStatesPerMBBPerContext.at(&currMBB)) {
        for (auto vtId : outCtxStMap.second) {
          // for each out state of a basic block, find a corresponding successor
          DEBUG_WITH_TYPE("graphilp", dbgs() << "Searching for successor to "
                                             << vtId << "(F "
                                             << currFunc->getName() << ", BB "
                                             << currMBB.getFullName() << ")\n");
          bool found = false;
          auto &state = id2state.at(vtId);
          // check whether there is a successor basic block whose in states
          // matched this state
          if (!currMBB.succ_empty()) {
            for (auto succMBB : getNonEmptySuccessorBasicBlocks(currMBB)) {
              // The current context must be updated along the edges of the
              // paths to the beginning of the next basic-block
              std::set<std::list<MBBedge>> *edgesSet = nullptr;
              // If self-loop
              if (&currMBB == succMBB) {
                std::list<MBBedge> singletonlist;
                singletonlist.push_back(std::make_pair(&currMBB, succMBB));
                edgesSet = new std::set<std::list<MBBedge>>();
                edgesSet->insert(singletonlist);
              }
              // otherwise, get real path between the two basic blocks
              else {
                edgesSet = getEdgesBetween(&currMBB, succMBB);
              }
              assert(edgesSet != nullptr && edgesSet->size() > 0 &&
                     "Couldnt find path between subsequent basic blocks!");
              Context inCtx;
              for (auto list : *edgesSet) {
                Context imContext(id2context.at(vtId));
                for (auto edge : list) {
                  if (DirectiveHeuristicsPassInstance->hasDirectiveOnEdgeEnter(
                          edge)) {
                    for (auto direc : *DirectiveHeuristicsPassInstance
                                           ->getDirectiveOnEdgeEnter(edge)) {
                      imContext.update(direc);
                    }
                  }
                  imContext.transfer(edge);
                  if (DirectiveHeuristicsPassInstance->hasDirectiveOnEdgeLeave(
                          edge)) {
                    for (auto direc : *DirectiveHeuristicsPassInstance
                                           ->getDirectiveOnEdgeLeave(edge)) {
                      imContext.update(direc);
                    }
                  }
                }
                if (inCtx.isEmpty()) {
                  inCtx = imContext;
                } else {
                  assert(inCtx == imContext &&
                         "Contexts of different paths were different as well!");
                }
              }
              // We do not need edgesSet any more, free it
              delete edgesSet;

              // The contexts must also match
              for (auto vtId2 :
                   inStatesPerMBBPerContext.at(succMBB).at(inCtx)) {
                DEBUG_WITH_TYPE("graphilp", dbgs() << "Trying " << vtId2
                                                   << " as a successor\n");
                auto &state2 = id2state.at(vtId2);
                if (isDirectSuccessor(state, state2)) {
                  DEBUG_WITH_TYPE(
                      "graphilp",
                      dbgs() << "Found a successor, adding an edge from "
                             << vtId << " to " << vtId2 << ".\n");
                  found = true;
                  graph.addEdge(vtId, vtId2);
                }
              }
            }
          }
          // No match in successor basic block found. Must be a returning state.
          // Check match there.
          if (!found) {
            // Get assumed callsite + call context to find states that might
            // match at all
            auto expectedCallsite = state.assumedCallSite();
            // nullptr means no callsite instruction which is the case for
            // returns from main
            if (expectedCallsite.first) {
              DEBUG_WITH_TYPE("graphilp", dbgs() << "Potential callsite: "
                                                 << *expectedCallsite.first
                                                 << "\n");
              // Get context after call instruction
              Context afterCallCtx(expectedCallsite.second);
              if (DirectiveHeuristicsPassInstance->hasDirectiveAfterInstr(
                      expectedCallsite.first)) {
                afterCallCtx.update(
                    DirectiveHeuristicsPassInstance->getDirectiveAfterInstr(
                        expectedCallsite.first));
              }
              // We only consider reachable callsites
              if (callStates.count(expectedCallsite.first) > 0) {
                // Try to match state for the right callsite and call-context
                for (auto vtId2 : returnStates.at(expectedCallsite.first)
                                      .at(expectedCallsite.second)) {
                  // For each callsites and possible return state there
                  DEBUG_WITH_TYPE("graphilp",
                                  dbgs() << "Comparing with state id: " << vtId2
                                         << "\n");
                  // Remove return assumption
                  auto state_copy(state);
                  bool returnedTo =
                      state_copy.assumedReturnedTo(expectedCallsite);
                  assert(returnedTo &&
                         "returnedTo says no to expected callsite");
                  // Check for consistent contexts
                  assert(afterCallCtx == id2context.at(vtId2) &&
                         "Expected context and context of state do not match");
                  // Check for successor state
                  if (isDirectSuccessor(state_copy, id2state.at(vtId2))) {
                    DEBUG_WITH_TYPE("graphilp",
                                    dbgs() << "Found a successor to return to, "
                                              "adding an edge from "
                                           << vtId << " to " << vtId2 << ".\n");
                    found = true;
                    graph.addEdge(vtId, vtId2);
                  }
                }
              }
            }
          }
          // Still, no match. Last option: We return from main. Check: Is this
          // indeed a returning state?
          if (!found) {
            auto state_copy(state);
            if (state_copy.assumedReturnedFromMain()) {
              found = true; // In this case, there is a match

              // Add edge to the special vertex 0
              graph.addEdge(vtId, 0);
            }
          }
          assert(found && "Not found any successor to a basic block!");
        }
      }
    }
  }

  auto startFunc = getAnalysisEntryPoint();
  auto startMbb = &*(startFunc->begin());
  assert(startMbb->getNumber() == 0 &&
         "First Basic block of function did not have number 0.");

  // get possible start states
  MicroArchDom mad(AnaDomInit::START);
  auto madStartStates = mad.getStates();

  for (auto &ctx2states : inStatesPerMBBPerContext.at(startMbb)) {
    for (auto stId : ctx2states.second) {
      // compare whether this is a start state
      if (madStartStates.count(id2state.at(stId)) > 0) {
        // add an edge from the special vertex
        graph.addEdge(0, stId);
      }
    }
  }

  // add idle cycle as self-loop to the special vertex
  graph.addEdge(0, 0);

  DEBUG_WITH_TYPE("graphilp", dbgs()
                                  << "Exiting buildInterBasicBlockEdges()\n");
}

template <class MicroArchDom>
void StateSensitiveGraph<MicroArchDom>::buildExternalSymbolReturnEdges() {
  CallGraph &cg = CallGraph::getGraph();
  for (auto extFunc : cg.getAllExternalFunctions()) {
    for (auto callsite : cg.getExtFuncCallSites(extFunc)) {
      if (returnStates.count(callsite) > 0) {
        assert(callStates.count(callsite) > 0 &&
               "Having return states, but no call states");
        for (auto &ctx2retIds : returnStates.at(callsite)) {
          for (auto retId : ctx2retIds.second) {
            unsigned outId = std::get<1>(extFuncVertices[extFunc]);
            graph.addEdge(outId, retId);
          }
        }
      } else {
        assert(callStates.count(callsite) == 0 &&
               "Having no return states, but call states");
      }
    }
  }
}

template <class MicroArchDom>
std::set<unsigned> StateSensitiveGraph<MicroArchDom>::progressStatesForProgLoc(
    std::set<unsigned> workingSetOfStates, ProgramLocation progLoc) {
  auto MI = progLoc.first;
  DEBUG_WITH_TYPE("instructions", dbgs()
                                      << "State-sensitive graph construction "
                                         "currently processes instruction:\n"
                                      << *MI << "\n");
  auto progAddr = StaticAddrProvider->getAddr(MI);

  // Initialize successor set
  std::set<unsigned> successorSet;

  // Map from state in successorSet to joinable states with non-joinable edges
  std::multimap<unsigned, unsigned> succ2alternatives;

  // and the same two sets again for the intermediate states
  // waiting to be joined
  std::set<unsigned> waiterSet;
  std::multimap<unsigned, unsigned> wait2alternatives;

  /* repeat for all elements of working set
           cycle states until they are final for the current instruction
           possibly join final states together */
  while (!workingSetOfStates.empty()) {
    // pick one state from the working set and delete it from the set
    unsigned currWorkingState = *workingSetOfStates.begin();
    workingSetOfStates.erase(workingSetOfStates.begin());

    std::set<unsigned> finalStatesIds;
    std::set<unsigned> waitingForJoinStatesIds;
    cycleUntilFinal(finalStatesIds, &waitingForJoinStatesIds, currWorkingState,
                    std::make_pair(progAddr, progLoc.second));

    auto &cg = CallGraph::getGraph();
    // If the program endes, i.e. final State returned from main to the initial
    // link register, cycle for a "sync" instruction.
    if (progLoc.first->getParent()->getParent()->getName().str() ==
            AnalysisEntryPoint &&
        progLoc.first->getParent()->succ_empty() && progLoc.first->isReturn()) {
      assert((progLoc.first ==
              (const MachineInstr *)&progLoc.first->getParent()->back()) &&
             "Return to external is not last instruction");
      std::set<unsigned> endprogWorkingSet;
      for (auto stateit = finalStatesIds.begin();
           stateit != finalStatesIds.end();) {
        typename MicroArchDom::State copy(id2state.at(*stateit));
        if (copy.assumedReturnedFromMain()) {
          endprogWorkingSet.insert(*stateit);
          stateit = finalStatesIds.erase(stateit);
        } else {
          ++stateit;
        }
      }
      // Further cycle those states that are assumed to return from main to
      // external Those states MUST be cycled until FINAL, not to
      // waitingForJoin: Otherwise, we would later insert this state again into
      // the workingSet and wait for it to become final for progAddr, although
      // it was already.
      for (auto endprogstate : endprogWorkingSet) {
        cycleUntilFinal(
            finalStatesIds, nullptr, endprogstate,
            std::make_pair(getInitialLinkRegister(), progLoc.second));
      }
    } else if (progLoc.first->isCall() && cg.callsExternal(progLoc.first)) {
      // We call an external function, cycle once further for a "sync"
      // instruction
      assert(!isPredicated(progLoc.first) &&
             "External call should not be predicated");
      std::set<unsigned> extcallWorkingSet;
      extcallWorkingSet.insert(finalStatesIds.begin(), finalStatesIds.end());
      finalStatesIds.clear();
      auto extsyncAddr =
          cg.getExtFuncStartAddress(cg.getExternalCalleeName(progLoc.first));
      // Those states MUST be cycled until FINAL, not to waitingForJoin:
      // Otherwise, we would later insert this state again into the workingSet
      // and wait for it to become final for progAddr, although it was already.
      for (auto extcallstate : extcallWorkingSet) {
        cycleUntilFinal(finalStatesIds, nullptr, extcallstate,
                        std::make_pair(extsyncAddr, progLoc.second));
      }
    }

    // If we enabled joining of states, do so
    if (MuJoinEnabled) {
      // We eliminate all mid-States such that similar edges can be joined
      if (!finalStatesIds.empty()) {
        std::set<unsigned> dupFinalStatesIds;
        moveMidStatesDown(finalStatesIds, dupFinalStatesIds);
        joinFinalStates(dupFinalStatesIds, successorSet, succ2alternatives);
      }
      if (!waitingForJoinStatesIds.empty()) {
        std::set<unsigned> dupWaitingForJoinStatesIds;
        moveMidStatesDown(waitingForJoinStatesIds, dupWaitingForJoinStatesIds);
        joinFinalStates(dupWaitingForJoinStatesIds, waiterSet,
                        wait2alternatives);
      }
    } else {
      // If joining is disabled, just copy the states
      successorSet.insert(finalStatesIds.begin(), finalStatesIds.end());
      waiterSet.insert(waitingForJoinStatesIds.begin(),
                       waitingForJoinStatesIds.end());
    }

    // if the working set is empty but we have some
    // potentially joined states waiting to continue
    // their travel through the transfer jungle.
    if (workingSetOfStates.empty() && !waiterSet.empty()) {
      workingSetOfStates.insert(waiterSet.begin(), waiterSet.end());
      waiterSet.clear();
      wait2alternatives.clear();
    }
  }
  return successorSet;
}

template <class MicroArchDom>
void StateSensitiveGraph<MicroArchDom>::moveMidStatesDown(
    const std::set<unsigned> &finalStatesIds,
    std::set<unsigned> &dupFinalStatesIds) {
  for (auto &fSId : finalStatesIds) {
    auto predecessorSet = graph.getPredecessors(fSId);
    // if the number of predecessor states is too high:
    if (predecessorSet.size() > STOP_MOVE_MIDSTATES_THRESHOLD) {
      // mark the state as persistent
      persistStates.insert(fSId);
      // do not move the midstates of this state
      dupFinalStatesIds.insert(fSId);
      continue;
    }
    // otherwise move the midstates
    for (auto pred : predecessorSet) {
      // If we detected a non-mid state (self-loop, or no predecessors) or
      // a persisted mid state, keep it
      if (pred == fSId || graph.getPredecessors(pred).size() == 0 ||
          persistStates.count(pred) > 0) {
        dupFinalStatesIds.insert(fSId);
      } else { // mid State
        unsigned freshId = graph.addVertex();
        id2context.insert(std::make_pair(freshId, id2context.at(fSId)));
        id2state.insert(std::make_pair(freshId, id2state.at(fSId)));
        DEBUG_WITH_TYPE(
            "detailedStateGraph", debugDump << "node : {\n	title : \""
                                            << freshId << "\"\n	label : \"Mid-"
                                            << freshId << "\"\n";
            debugDump << "info1 : \"" << id2state.at(freshId) << "\"\n}\n";);
        dupFinalStatesIds.insert(freshId);
        // Replace p' -> pred and pred -> fSId by p' -> freshId
        for (auto &cb : this->constructionCallbacks) {
          cb->concatEdges(pred, fSId, freshId);
        }
        DEBUG_WITH_TYPE("detailedStateGraph",
                        debugDump
                            << "edge : {\n	sourcename : \"" << pred
                            << "\"	targetname : \"" << freshId
                            << "\"\n	label : \"moveMidStates\"\n}\n";);
        for (auto prePred : graph.getPredecessors(pred)) {
          // MJa: Need to relax this because of persistStates
          assert((graph.getPredecessors(prePred).size() == 0 ||
                  persistStates.count(prePred) > 0) &&
                 "No non-persistent prePred should have another predecessor.");
          graph.addEdge(prePred, freshId);
        }
        graph.removeEdge(pred, fSId);
        if (graph.getSuccessors(pred).size() == 0) {
          for (auto prePred : graph.getPredecessors(pred)) {
            graph.removeEdge(prePred, pred);
          }
          additionalStates[currentBasicBlock].erase(pred);
          graph.removeVertex(pred);
          id2state.erase(pred);
          id2context.erase(pred);
        }
      }
    }
  }
}

template <class MicroArchDom>
void StateSensitiveGraph<MicroArchDom>::joinFinalStates(
    const std::set<unsigned> &finalStatesIds, std::set<unsigned> &successorSet,
    std::multimap<unsigned, unsigned> &succ2alternatives) {
  for (auto &fSId : finalStatesIds) {
    // Put final states into successor set, join if needed
    auto &fS = id2state.at(fSId);
    bool inserted = false;
    for (unsigned succId : successorSet) {
      auto &succState = id2state.at(succId);
      if (succState.isJoinable(fS)) {
        const bool fSIdPersist = persistStates.count(fSId) > 0;
        // join both states here, adjust graph accordingly
        succState.join(fS);
        inserted = true;
        // Join all edges to fsId with edges to succId that are joinable
        bool notdone = this->updateEdgeTarget(fSId, succId);
        // transfer persistence to the edge target if edge join was successful
        if (fSIdPersist && !notdone) {
          persistStates.erase(fSId);
          persistStates.insert(succId);
        }
        // If this joining was not completely possible, try with the remaining
        // alternatives
        if (notdone) {
          auto altrange = succ2alternatives.equal_range(succId);
          for (auto altit = altrange.first; altit != altrange.second; ++altit) {
            bool notdonealt = this->updateEdgeTarget(fSId, altit->second);
            // All edges are reset to somewhere
            if (!notdonealt) {
              // transfer persistence to the edge target
              // if edge join was successful
              if (fSIdPersist) {
                persistStates.erase(fSId);
                persistStates.insert(altit->second);
              }
              notdone = false;
              break;
            }
          }
        }
        // If there are still edges remaining that are not joinable to any
        // alternative, keep state
        if (notdone) {
          // All remaining edges should be adjusted with non-joinable property
          for (auto p : graph.getPredecessors(fSId)) {
            for (auto cb : this->constructionCallbacks) {
              cb->updateEdgeTarget(p, fSId, succId, false);
            }
          }
          // We introduce this dummy edge
          graph.addEdge(fSId, succId);
          // Keep fSId in mind for dumping
          additionalStates[currentBasicBlock].insert(fSId);
          // fSId now became an alternative to succId
          succ2alternatives.insert(std::make_pair(succId, fSId));

          DEBUG_WITH_TYPE("detailedStateGraph",
                          debugDump << "edge : {\n	sourcename : \"" << fSId
                                    << "\" targetname : \"" << succId
                                    << "\"\n	label : \"subsume\"\n}\n";);
        }
        break; // state is inserted, no more joins possible
      }
    }
    if (!inserted) { // no join partner found, just insert it
      successorSet.insert(fSId);
    }
  }
}

template <class MicroArchDom>
void StateSensitiveGraph<MicroArchDom>::handleCallInstructions(
    const MachineInstr *MI, const Context &Ctx,
    std::set<unsigned> &workingSet) {
  auto &ins2cst = callStates[MI];
  ins2cst.insert(ins2cst.begin(), workingSet.begin(), workingSet.end());
  workingSet.clear();

  // add return state of this function to the working set
  auto &anaInfoAfter = mai.getAnaInfoAfter(MI);
  assert(!anaInfoAfter.isBottom() &&
         "Should not have bottom after reachable call!");
  Context afterCallCtx(Ctx);
  // Context changes have to be simulated here to find the correct state for the
  // working set
  if (DirectiveHeuristicsPassInstance->hasDirectiveAfterInstr(MI)) {
    afterCallCtx.update(
        DirectiveHeuristicsPassInstance->getDirectiveAfterInstr(MI));
  }
  auto ctx2statesAfterCall = anaInfoAfter.findAnalysisInfo(afterCallCtx);
  assert(!ctx2statesAfterCall.isBottom() &&
         "Should not have bottom after reachable call-context!");
  auto statesAfterCall = ctx2statesAfterCall.getStates();
  for (auto &state : statesAfterCall) {
    unsigned stId = graph.addVertex();
    DEBUG_WITH_TYPE("graphbuild",
                    dbgs() << "Adding vertex with id " << stId << "\n");
    DEBUG_WITH_TYPE("graphilp", std::cerr << state << "\n");
    // return state can be out state as well, so take context after the call
    id2context.insert(std::make_pair(stId, afterCallCtx));
    id2state.insert(std::make_pair(stId, state));

    DEBUG_WITH_TYPE("detailedStateGraph",
                    debugDump << "node : {\n	title : \"" << stId
                              << "\"\n	label : \"Return-" << stId << "\"\n";
                    debugDump << "info1 : \"" << id2state.at(stId)
                              << "\"\n}\n";);

    workingSet.insert(stId);
    this->addInitialEdge(stId);
    // Use context during the call to find return state later on
    returnStates[MI][Ctx].push_back(stId);
  }
  DEBUG_WITH_TYPE("ilp", dbgs() << "Size of returnsite map for instruction "
                                << *MI << ": "
                                << returnStates.at(MI).at(Ctx).size() << "\n");
}

template <class MicroArchDom>
void StateSensitiveGraph<MicroArchDom>::filterExitingStates(
    const MachineInstr *MI, const Context &Ctx,
    std::set<unsigned> &workingSet) {
  DEBUG_WITH_TYPE("graphbuild", dbgs() << "Final instruction " << *MI << "\n");
  ProgramLocation progLoc = std::make_pair(MI, Ctx);

  for (auto i = workingSet.begin(); i != workingSet.end();) {
    auto stateId = *i;
    bool isStateExiting = true;
    if (MI->isConditionalBranch()) {
      bool assumedNotTaken = id2state.at(stateId).assumedBranchOutcome(
          progLoc, BranchOutcome::nottaken());
      // If the branch is not taken and is not the last instruction by accident
      if (assumedNotTaken && (MI != &(MI->getParent()->back()))) {
        isStateExiting = false;
      }
    } else if (isJumpTableBranch(MI)) {
      // Do not forget to clean branch assumptions before checking
      bool assumedTaken = id2state.at(stateId).assumedBranchOutcome(
          progLoc, BranchOutcome::taken());
      assert(assumedTaken &&
             "A jump table branch is always assumed to be taken");
    } else if (MI->isReturn()) {
      // Do not forget to clean branch assumptions before checking
      bool assumedTaken = id2state.at(stateId).assumedBranchOutcome(
          progLoc, BranchOutcome::taken());
      assert((isPredicated(MI) || assumedTaken) &&
             "A non-predicated return is always assumed to be taken");
      // Not taken predicated return which is not at the end
      if (!assumedTaken && (MI != &(MI->getParent()->back()))) {
        assert(isPredicated(MI) && "Only predicated return can be not-taken");
        isStateExiting = false; // Predicated return, not taken
      }
    }
    if (isStateExiting) {
      bool foundMatch = false;
      // A matching output-state must have the same context as we have at the
      // end of the basic block
      for (auto sId : outStatesPerMBBPerContext.at(MI->getParent())
                          .at(id2context.at(stateId))) {
        if (id2state.at(stateId) == id2state.at(sId)) {
          DEBUG_WITH_TYPE(
              "detailedStateGraph",
              debugDump << "node : {\n	title : \"" << sId
                        << "\"\n	label : \"Out-" << sId << "\"\n";
              debugDump << "info1 : \"" << id2state.at(sId) << "\"\n}\n";);
          bool kept = this->updateEdgeTarget(stateId, sId);
          assert(!kept && "When filtering exiting states, cannot keep state");
          i = workingSet.erase(i);
          foundMatch = true;
          break;
        }
      }
      if (!foundMatch) {
        errs() << "Wanted to match state " << stateId
               << " but did not find partner\n";
        abort();
      }
    } else {
      ++i;
    }
  }
  DEBUG_WITH_TYPE(
      "graphilp",
      dbgs() << "This was the final instruction, size of working set is: "
             << workingSet.size() << "\n");
}

template <class MicroArchDom>
void StateSensitiveGraph<MicroArchDom>::addInitialEdge(unsigned s) {
  // Handle call-backs
  for (auto cb : this->constructionCallbacks) {
    cb->addEdge(s, s);
  }

  DEBUG_WITH_TYPE("graphbuild",
                  dbgs() << "Adding self-edge for vertex id " << s << ".\n");
  graph.addEdge(s, s);
}

template <class MicroArchDom>
void StateSensitiveGraph<MicroArchDom>::advanceEdges(
    unsigned curr, std::list<unsigned> succs) {
  bool selfedge = false;
  for (auto pred : graph.getPredecessors(curr)) {
    selfedge |= (pred == curr);
    for (auto succ : succs) {
      graph.addEdge(pred, succ);
      DEBUG_WITH_TYPE("graphbuild", dbgs() << "Advance: Resetting edge ("
                                           << pred << "," << curr << ") to ("
                                           << pred << "," << succ << ").\n");
      DEBUG_WITH_TYPE(
          "detailedStateGraph",
          debugDump << "edge : {\n	sourcename : \"" << curr
                    << "\"	targetname : \"" << succ
                    << "\"\n	label : \"tick from state " << pred;
          for (auto &cb
               : this->constructionCallbacks) {
            debugDump << "\n" << cb->getWeightDescr(pred, succ);
          } debugDump
          << "\"\n}\n";);
    }
    graph.removeEdge(pred, curr);
  }
  if (!selfedge) {
    DEBUG_WITH_TYPE("graphbuild",
                    dbgs() << "Removing vertex with id " << curr << "\n");
    graph.removeVertex(curr);
    id2state.erase(curr);
    id2context.erase(curr);
  }
}

template <class MicroArchDom>
bool StateSensitiveGraph<MicroArchDom>::updateEdgeTarget(unsigned t,
                                                         unsigned nt) {
  bool keept = false;
  bool selfedge = false;
  for (unsigned p : graph.getPredecessors(t)) {
    DEBUG_WITH_TYPE("graphbuild", dbgs() << "UpdateTarget: Resetting edge ("
                                         << p << "," << t << ") to (" << p
                                         << "," << nt << ").\n");
    selfedge |=
        (p == t); // Keep vertex t if this is a self-edge, we will need t
    // Should we join the edge p->t , or keep it?
    bool edgeJoinable = true;
    if (graph.hasEdge(p, nt)) {
      for (auto cb : this->constructionCallbacks) {
        edgeJoinable &= cb->isEdgeJoinable(p, t, nt);
      }
      for (auto cb : this->isEdgeJoinableCallbacks) {
        edgeJoinable &= cb->isEdgeJoinable(p, t, nt);
      }
    }
    if (edgeJoinable) {
      // Handle the call-backs before manipulating the graph itself
      for (auto cb : this->constructionCallbacks) {
        cb->updateEdgeTarget(p, t, nt, true);
      }
      // We can join the edge, do so
      if (!graph.hasEdge(p, nt)) {
        graph.addEdge(p, nt);
      }
      graph.removeEdge(p, t);

      DEBUG_WITH_TYPE("detailedStateGraph",
                      debugDump << "edge : {\n	sourcename : \"" << t
                                << "\" targetname : \"" << nt
                                << "\"\n	label : \"subsume\"\n}\n";);
    } else {        // Non joinable edge
      keept = true; // We need vertex t afterwards
                    // Leave edge untouched, this is handled one layer above
    }
  }
  if (!keept && !selfedge) {
    graph.removeVertex(t);
    id2state.erase(t);
    id2context.erase(t);
  }
  return keept;
}

template <class MicroArchDom>
std::unordered_map<
    Context, std::vector<typename StateSensitiveGraph<MicroArchDom>::State>>
StateSensitiveGraph<MicroArchDom>::getIncomingStates(MachineBasicBlock &mbb) {
  // init result set
  std::unordered_map<Context, std::vector<State>> result;

  // skip empty basic blocks
  if (!isBasicBlockEmpty(&mbb)) {
    auto firstInstr = getFirstInstrInBB(&mbb);
    // get analysis info before the next
    auto &ctxStateInfoBefore = mai.getAnaInfoBefore(firstInstr);
    if (!ctxStateInfoBefore.isBottom()) {
      // for each context
      extractStatesFromAnaInfo(&result,
                               ctxStateInfoBefore.getAnalysisInfoPerContext());
    }
  }
  return result;
}

template <class MicroArchDom>
std::unordered_map<
    Context, std::vector<typename StateSensitiveGraph<MicroArchDom>::State>>
StateSensitiveGraph<MicroArchDom>::getOutgoingStates(MachineBasicBlock &mbb) {
  std::unordered_map<Context, std::vector<State>> result;
  if (!isBasicBlockEmpty(&mbb)) {
    for (auto endInstr : getAllEndInstrInMBB(&mbb)) {
      bool needGuarded = endInstr->isConditionalBranch() ||
                         isJumpTableBranch(endInstr) || endInstr->isReturn();
      bool needBothGuards = needGuarded && endInstr == &mbb.back();
      auto ctxStateInfoAfter =
          needGuarded
              ? mai.getAnaInfoAfterGuarded(endInstr, BranchOutcome::taken())
              : mai.getAnaInfoAfter(endInstr);
      if (needBothGuards) {
        ctxStateInfoAfter.join(
            mai.getAnaInfoAfterGuarded(endInstr, BranchOutcome::nottaken()));
      }
      if (!ctxStateInfoAfter.isBottom()) {
        extractStatesFromAnaInfo(&result,
                                 ctxStateInfoAfter.getAnalysisInfoPerContext());
      }
    }
  }
  return result;
}

template <class MicroArchDom>
void StateSensitiveGraph<MicroArchDom>::extractStatesFromAnaInfo(
    std::unordered_map<Context, std::vector<State>> *result,
    std::unordered_map<Context, MicroArchDom> ctx2anaInfoMap) {
  for (auto &ctx2anaInfo : ctx2anaInfoMap) {
    const auto &extractedStates = ctx2anaInfo.second.getStates();
    for (auto &state : extractedStates) {
      (*result)[ctx2anaInfo.first].push_back(state);
    }
  }
}

template <class MicroArchDom>
void StateSensitiveGraph<MicroArchDom>::addStatesToGraph(
    std::unordered_map<Context, std::vector<unsigned>> &stateIds,
    const std::unordered_map<Context, std::vector<State>> &newStates) {
  for (auto &ctxMap : newStates) {
    // init a vector for the context
    std::vector<unsigned> verticesCurrCtx;

    // collect all states with the current context
    for (auto &st : ctxMap.second) {
      // add a vertex
      unsigned vtId = graph.addVertex();
      // store the vertex -> state relationship in the states map
      id2context.insert(std::make_pair(vtId, ctxMap.first));
      id2state.insert(std::make_pair(vtId, st));
      // store the id for the result vector for this context
      verticesCurrCtx.push_back(vtId);
    }

    // insert into stateIds map
    stateIds.insert(std::make_pair(ctxMap.first, verticesCurrCtx));
  }
}

template <class MicroArchDom>
bool StateSensitiveGraph<MicroArchDom>::isDirectSuccessor(
    const State &state1, const State &state2) const {
  // copy state1 because we need to manipulate it
  typename MicroArchDom::State state1Copy(state1);
  // reset basicblock-relative metrics as it will be non-zero
  state1Copy.resetLocalMetrics();
  // state2 is either an in- or return-state, both should have resetted local
  // metrics, no need to copy
  typedef typename MicroArchDom::State::LocalMetrics MyLocalMetrics;
  assert(
      (MyLocalMetrics(state2).time == IntervalCounter<true, true, true>(0)) &&
      "In state has time non-zero");

  // If we are allowed to join, then we check successor as x \lessequal y
  // which is equivalent to "x joinable y" AND "x join y == y"
  if (MuJoinEnabled) {
    // try the join with state2Copy
    if (!state1Copy.isJoinable(state2))
      return false;
    state1Copy.join(state2);
  }
  // Either x == y (no-join) or x join y == y (join). Otherwise no successor.
  return state1Copy == state2;
}

template <class MicroArchDom>
void StateSensitiveGraph<MicroArchDom>::dump(
    std::ostream &mystream,
    const std::map<std::string, double> *optTimesTaken) const {
  if (!DumpVcgGraph) {
    int clusterNr = 0;
    mystream << "digraph WCET {\n    label = \"Microarchitectural State "
                "Graph\"\n    color=blue;\n    node [color=black, "
                "shape=square];\n  subgraph cluster_"
             << clusterNr++ << " {";

    std::set<unsigned> persistStatesAlreadyDumped;
    const std::function<void(unsigned, const std::set<unsigned> &)>
        dumpPersistSuccessors = [this, &persistStatesAlreadyDumped, &mystream,
                                 &dumpPersistSuccessors](
                                    unsigned currId,
                                    const std::set<unsigned> &statesLeavingBB) {
          for (unsigned succId : graph.getSuccessors(currId)) {
            if (persistStates.count(succId) > 0 &&
                persistStatesAlreadyDumped.count(succId) == 0) {
              mystream << succId << " [ label = \"Mid-" << succId
                       << "\", tooltip = <" << id2state.at(succId) << ">];\n";
              persistStatesAlreadyDumped.insert(succId);
              if (statesLeavingBB.count(succId) == 0) {
                // if succId is a leaving state of the current BB,
                // then its successors belong to a different BB
                // and, thus, must not be dumped into the current BB
                dumpPersistSuccessors(succId, statesLeavingBB);
              }
            }
          }
        };

    // Build nodes for all states in functions and basic blocks
    for (MachineFunction *currFunc :
         machineFunctionCollector->getAllMachineFunctions()) {
      std::string funcName = currFunc->getName().str();
      mystream << "subgraph cluster_" << clusterNr++ << " {\n	label = \""
               << funcName << "\"\n";
      for (auto &currMBB : *currFunc) {
        std::string mbbName = currMBB.getFullName();
        mystream << "subgraph cluster_" << clusterNr++ << " {\n	label = \""
                 << mbbName << "\"\n";
        // dump call states of the BB and collect their ids as leaving at
        // the same time
        std::set<unsigned> statesLeavingBB;
        const auto &callsites =
            CallGraph::getGraph().getCallSitesInMBB(&currMBB);
        for (auto callsite : callsites) {
          if (callStates.count(callsite) > 0) {
            assert(returnStates.count(callsite) > 0 &&
                   "Calling states 	but no return states");
            auto &currentCallStates = callStates.at(callsite);
            statesLeavingBB.insert(currentCallStates.begin(),
                                   currentCallStates.end());
            for (auto cSt : currentCallStates) {
              mystream << cSt << " [ label = \"Call-" << cSt
                       << "\", tooltip = <" << id2state.at(cSt) << ">];\n";
            }
          }
        }
        // dump out states of the BB and collect their ids as leaving at
        // the same time
        for (auto ctxStMap : outStatesPerMBBPerContext.at(&currMBB)) {
          auto &currentStates = ctxStMap.second;
          statesLeavingBB.insert(currentStates.begin(), currentStates.end());
          for (auto outSts : currentStates) {
            mystream << outSts << " [ label = \"Out-" << outSts
                     << "\" , tooltip = <" << id2state.at(outSts) << ">];\n";
          }
        }
        // dump in states of the basic block
        for (auto ctxStMap : inStatesPerMBBPerContext.at(&currMBB)) {
          for (auto inSts : ctxStMap.second) {
            mystream << inSts << " [ label = \"In-" << inSts
                     << "\" , tooltip = <" << id2state.at(inSts) << ">];\n";
            dumpPersistSuccessors(inSts, statesLeavingBB);
          }
        }
        // dump additional states of the basic block
        if (additionalStates.count(&currMBB) > 0) {
          for (auto addSt : additionalStates.at(&currMBB)) {
            mystream << addSt << " [ label = \"Mid-" << addSt
                     << "\" , tooltip = <" << id2state.at(addSt) << ">];\n";
            dumpPersistSuccessors(addSt, statesLeavingBB);
          }
        }
        // dump return states of the basic block
        for (auto callsite : callsites) {
          if (callStates.count(callsite) > 0) {
            for (auto &ctx2cSts : returnStates.at(callsite)) {
              for (auto cSt : ctx2cSts.second) {
                mystream << cSt << " [ label = \"Return-" << cSt
                         << "\" , tooltip = <" << id2state.at(cSt) << ">];\n";
                dumpPersistSuccessors(cSt, statesLeavingBB);
              }
            }
          }
        }
        mystream << "}\n";
      }
      mystream << "}\n";
    }

    for (auto &extFunc : extFuncVertices) {
      mystream << "subgraph cluster_" << clusterNr++ << " {\n	label = \""
               << extFunc.first << "\"\n";
      mystream << extFunc.second.first << "[ label = \"In-"
               << extFunc.second.first
               << "\" , tooltip = \"No information about state in external "
                  "	function.\"]\n";
      mystream << extFunc.second.second << "[ label = \"Out-"
               << extFunc.second.second
               << "\" , tooltip = \"No information about state in external "
                  "	function.\"]\n";
      mystream << "}\n";
    }

    /* TODO we probably can pull this entire code into super->dumpEdge */
    // add all edges with weight from graph
    auto &completeGraph = graph.getVertices();
    for (auto &vtpair : completeGraph) {
      // skip special vertex and its edges
      if (vtpair.first == 0)
        continue;
      auto &vt = std::get<1>(vtpair);
      for (auto &vt_succ : vt.getSuccessors()) {
        // skip edges to the special vertex
        if (vt_succ == 0)
          continue;
        std::string weight;
        bool emitComma = false;
        std::pair<unsigned, unsigned> edge =
            std::make_pair(vt.getId(), vt_succ);
        for (auto &ccb : this->constructionCallbacks) {
          if (emitComma) {
            weight += ",\\n";
          }
          weight += ccb->getWeightDescr(edge.first, edge.second);
          emitComma = true;
        }

        bool onWCETPath = false;
        if (optTimesTaken) {
          Variable edgeVar =
              Variable::getEdgeVar(Variable::Type::timesTaken, edge);
          auto frequency = optTimesTaken->find(edgeVar.getName());
          if (frequency != optTimesTaken->end() && frequency->second > 0) {
            weight +=
                ",\\nFrequency: " + std::to_string(frequency->second) + "\\n";
            onWCETPath = true;
          }
        }

        this->dumpEdge(mystream, edge, weight, onWCETPath);
      }
    }
    mystream << "}\n}";

  } else {
    /*Normal .vcg Dump*/
    mystream
        << "graph : { \n	layoutalgorithm : hierarchic\n	graph : "
           "{\n	title "
           ": \"State Graph\"\n	label : \"Microarchitectural State Graph\"\n";

    std::set<unsigned> persistStatesAlreadyDumped;
    const std::function<void(unsigned, const std::set<unsigned> &)>
        dumpPersistSuccessors =
            [this, &persistStatesAlreadyDumped, &mystream,
             &dumpPersistSuccessors](
                unsigned currId, const std::set<unsigned> &statesLeavingBB) {
              for (unsigned succId : graph.getSuccessors(currId)) {
                if (persistStates.count(succId) > 0 &&
                    persistStatesAlreadyDumped.count(succId) == 0) {
                  mystream << "node : {\n	title : \"" << succId
                           << "\"\n	label : \"Mid-" << succId << "\"\n";
                  mystream << "info1 : \"" << id2state.at(succId) << "\"\n}\n";
                  persistStatesAlreadyDumped.insert(succId);
                  if (statesLeavingBB.count(succId) == 0) {
                    // if succId is a leaving state of the current BB,
                    // then its successors belong to a different BB
                    // and, thus, must not be dumped into the current BB
                    dumpPersistSuccessors(succId, statesLeavingBB);
                  }
                }
              }
            };

    // Build nodes for all states in functions and basic blocks
    for (MachineFunction *currFunc :
         machineFunctionCollector->getAllMachineFunctions()) {
      std::string funcName = currFunc->getName().str();
      mystream << "graph : {\n	title : \"" << funcName << "\"\n	label : \""
               << funcName << "\"\n";
      for (auto &currMBB : *currFunc) {
        std::string mbbName = currMBB.getFullName();
        mystream << "graph : {\n	title : \"" << mbbName
                 << "\"\n	label : \"" << mbbName << "\"\n";
        // dump call states of the BB and collect their ids as leaving at the
        // same time
        std::set<unsigned> statesLeavingBB;
        const auto &callsites =
            CallGraph::getGraph().getCallSitesInMBB(&currMBB);
        for (auto callsite : callsites) {
          if (callStates.count(callsite) > 0) {
            assert(returnStates.count(callsite) > 0 &&
                   "Calling states but no return states");
            auto &currentCallStates = callStates.at(callsite);
            statesLeavingBB.insert(currentCallStates.begin(),
                                   currentCallStates.end());
            for (auto cSt : currentCallStates) {
              mystream << "node : {\n	title : \"" << cSt
                       << "\"\n	label : \"Call-" << cSt << "\"\n";
              mystream << "info1 : \"" << id2state.at(cSt) << "\"\n}\n";
            }
          }
        }
        // dump out states of the BB and collect their ids as leaving at the
        // same time
        for (auto ctxStMap : outStatesPerMBBPerContext.at(&currMBB)) {
          auto &currentStates = ctxStMap.second;
          statesLeavingBB.insert(currentStates.begin(), currentStates.end());
          for (auto outSts : currentStates) {
            mystream << "node : {\n	title : \"" << outSts
                     << "\"\n	label : \"Out-" << outSts << "\"\n";
            mystream << "info1 : \"" << id2state.at(outSts) << "\"\n}\n";
          }
        }
        // dump in states of the basic block
        for (auto ctxStMap : inStatesPerMBBPerContext.at(&currMBB)) {
          for (auto inSts : ctxStMap.second) {
            mystream << "node : {\n	title : \"" << inSts
                     << "\"\n	label : \"In-" << inSts << "\"\n";
            mystream << "info1 : \"" << id2state.at(inSts) << "\"\n}\n";
            dumpPersistSuccessors(inSts, statesLeavingBB);
          }
        }
        // dump additional states of the basic block
        if (additionalStates.count(&currMBB) > 0) {
          for (auto addSt : additionalStates.at(&currMBB)) {
            mystream << "node : {\n	title : \"" << addSt
                     << "\"\n	label : \"Mid-" << addSt << "\"\n";
            mystream << "info1 : \"" << id2state.at(addSt) << "\"\n}\n";
            dumpPersistSuccessors(addSt, statesLeavingBB);
          }
        }
        // dump return states of the basic block
        for (auto callsite : callsites) {
          if (callStates.count(callsite) > 0) {
            for (auto &ctx2cSts : returnStates.at(callsite)) {
              for (auto cSt : ctx2cSts.second) {
                mystream << "node : {\n	title : \"" << cSt
                         << "\"\n	label : \"Return-" << cSt << "\"\n";
                mystream << "info1 : \"" << id2state.at(cSt) << "\"\n}\n";
                dumpPersistSuccessors(cSt, statesLeavingBB);
              }
            }
          }
        }
        mystream << "}\n";
      }
      mystream << "}\n";
    }

    for (auto &extFunc : extFuncVertices) {
      mystream << "graph : {\n	title : \"" << extFunc.first
               << "\"\n	label : \"" << extFunc.first << "\"\n";
      mystream << "node : {\n	title : \"" << extFunc.second.first
               << "\"\n	label : \"In-" << extFunc.second.first << "\"\n";
      mystream << "info1 : \"No information about state in external "
                  "function.\"\n}\n";
      mystream << "node : {\n	title : \"" << extFunc.second.second
               << "\"\n	label : \"Out-" << extFunc.second.second << "\"\n";
      mystream << "info1 : \"No information about state in external "
                  "function.\"\n}\n";
      mystream << "}\n";
    }

    /* TODO we probably can pull this entire code into super->dumpEdge */
    // add all edges with weight from graph
    auto &completeGraph = graph.getVertices();
    for (auto &vtpair : completeGraph) {
      // skip special vertex and its edges
      if (vtpair.first == 0)
        continue;
      auto &vt = std::get<1>(vtpair);
      for (auto &vt_succ : vt.getSuccessors()) {
        // skip edges to the special vertex
        if (vt_succ == 0)
          continue;
        std::string weight;
        bool emitComma = false;
        std::pair<unsigned, unsigned> edge =
            std::make_pair(vt.getId(), vt_succ);
        for (auto &ccb : this->constructionCallbacks) {
          if (emitComma) {
            weight += ",\\n";
          }
          weight += ccb->getWeightDescr(edge.first, edge.second);
          emitComma = true;
        }

        bool onWCETPath = false;
        if (optTimesTaken) {
          Variable edgeVar =
              Variable::getEdgeVar(Variable::Type::timesTaken, edge);
          auto frequency = optTimesTaken->find(edgeVar.getName());
          if (frequency != optTimesTaken->end() && frequency->second > 0) {
            weight +=
                ",\\nFrequency: " + std::to_string(frequency->second) + "\\n";
            onWCETPath = true;
          }
        }

        this->dumpEdge(mystream, edge, weight, onWCETPath);
      }
    }
    mystream << "}\n}";
  }
}

template <class MicroArchDom>
void StateSensitiveGraph<MicroArchDom>::deleteMuArchInfo() {
  // Get rid of the instr context mapping generated during the
  // microarchitectural analysis
  auto anaDeps = mai.getAnaDepsInfo();
  delete &(std::get<0>(anaDeps));
  // Delete micro-architectural information, as it is not needed any more
  delete &mai;
  // TODO Value analysis information is also obsolete here, but we have no
  // handle to get it
}

} // namespace TimingAnalysisPass

#endif
