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

#ifndef INSENSITIVEGRAPH_H
#define INSENSITIVEGRAPH_H

#include "StateGraph.h"
#include "Util/Graph.h"
#include "Util/Util.h"

#include "../MicroarchitecturalAnalysis/MicroArchitecturalState.h"

#include <string>
#include <unordered_map>

namespace TimingAnalysisPass {

/**
 * Class representing the insensitive graph - w.r.t states and contexts. This
 * gives the simplest ILP. This can be feed as input to the path analysis.
 */
template <class MicroArchDom>
class InsensitiveGraph : public MuStateGraph<typename MicroArchDom::State> {
public:
  typedef AnalysisInformation<PartitioningDomain<MicroArchDom, MachineInstr>,
                              MachineInstr>
      MuAnaInfo;

  typedef typename MicroArchDom::State State;

  /**
   * Constructor
   */
  InsensitiveGraph(const MuAnaInfo &mai) : mai(mai), graph() {}

  void buildGraph();

  virtual void freeMuStates() { states.clear(); }

  typename State::StateSet getStatesForId(unsigned id) {
    return states.at(id).getStates();
  }

  const Graph &getGraph() const { return graph; }

  std::vector<unsigned> getInStates(const MachineBasicBlock *mbb) const {
    std::vector<unsigned> result;
    if (inVertexPerMBB.count(mbb) > 0) {
      result.push_back(inVertexPerMBB.at(mbb));
    }
    return result;
  }

  std::vector<unsigned> getOutStates(const MachineBasicBlock *mbb) const {
    std::vector<unsigned> result;
    if (outVertexPerMBB.count(mbb) > 0) {
      result.push_back(outVertexPerMBB.at(mbb));
    }
    return result;
  }

  std::vector<unsigned> getCallStates(const MachineInstr *mi) const {
    assert(mi->isCall() && "Call States only at calls");
    std::vector<unsigned> res;
    if (callVertices.count(mi) > 0) {
      res.push_back(callVertices.at(mi));
    }
    return res;
  }

  std::vector<unsigned> getReturnStates(const MachineInstr *mi) const {
    assert(mi->isCall() && "Return States only at calls");
    std::vector<unsigned> res;
    if (returnVertices.count(mi) > 0) {
      res.push_back(returnVertices.at(mi));
    }
    return res;
  }

  void dump(std::ostream &mystream,
            const std::map<std::string, double> *optTimesTaken) const;

  void deleteMuArchInfo();

private:
  void buildInterBasicBlockEdges();
  void buildIntraBasicBlockEdges();
  void addExternalFunctionToGraph(std::string functionName);

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
   * All Microarchitectural states for vertices, represented by ids.
   */
  std::map<unsigned, MicroArchDom> states;

  /**
   * A map containing the incoming vertex id per basic block.
   * These represent the incoming state at the beginning of a basic block.
   */
  std::map<const MachineBasicBlock *, unsigned, mbbComp> inVertexPerMBB;

  /**
   * A map containing the outgoing vertex id per basic block.
   */
  std::map<const MachineBasicBlock *, unsigned, mbbComp> outVertexPerMBB;

  /**
   * Map which contains all call vertices, separated by basic block and callsite
   * (MI).
   */
  std::map<const MachineInstr *, unsigned, instrptrcomp> callVertices;

  std::map<const MachineInstr *, unsigned, instrptrcomp> returnVertices;

  /**
   * A map containing the in- and out-Vertex for all external functions.
   */
  std::map<std::string, GraphEdge> extFuncVertices;
};

template <class MicroArchDom>
void InsensitiveGraph<MicroArchDom>::buildGraph() {
  // The special Vertex
  graph.addVertex();

  buildIntraBasicBlockEdges();
  buildInterBasicBlockEdges();
}

template <class MicroArchDom>
void InsensitiveGraph<MicroArchDom>::buildIntraBasicBlockEdges() {
  // For each basic block in the program,
  // collect states at the start, the end, and before/after each call
  // instruction
  for (auto currFunc : machineFunctionCollector->getAllMachineFunctions()) {
    for (auto &currBB : *currFunc) {
      if (isBasicBlockEmpty(&currBB)) {
        continue;
      }

      // First: no states anywhere
      MicroArchDom inStates(AnaDomInit::BOTTOM);
      auto firstInstr = getFirstInstrInBB(&currBB);
      auto &ctxStateInfoBefore = mai.getAnaInfoBefore(firstInstr);
      // Start information is collected states for all contexts
      if (!ctxStateInfoBefore.isBottom()) {
        for (auto &ctx2ana : ctxStateInfoBefore.getAnalysisInfoPerContext()) {
          MicroArchDom tmp = ctx2ana.second;
          inStates.join(tmp);
        }
      }
      if (inStates.isBottom()) {
        continue; // If this basic block is not reachable, we will skip it
      }
      unsigned inStatesId = graph.addVertex();
      states.insert(std::make_pair(inStatesId, inStates));
      inVertexPerMBB.insert(std::make_pair(&currBB, inStatesId));

      // The out state will be filled in the following
      unsigned outStatesId = graph.addVertex();
      MicroArchDom outStates(AnaDomInit::BOTTOM);

      for (auto &currMI : currBB) {
        if (currMI.isCall()) {
          // Insert call state
          MicroArchDom callStates(AnaDomInit::BOTTOM);
          auto &ctxStateInfoBefore = mai.getAnaInfoBefore(&currMI);
          if (!ctxStateInfoBefore.isBottom()) {
            for (auto &ctx2ana :
                 ctxStateInfoBefore.getAnalysisInfoPerContext()) {
              MicroArchDom tmp = ctx2ana.second;
              Context beforeCallCtx(ctx2ana.first);
              if (DirectiveHeuristicsPassInstance->hasDirectiveBeforeInstr(
                      &currMI)) {
                beforeCallCtx.update(
                    DirectiveHeuristicsPassInstance->getDirectiveBeforeInstr(
                        &currMI));
              }
              auto &cg = CallGraph::getGraph();
              auto anaDeps = mai.getAnaDepsInfo();
              // Call transferCall to cycle the callee-in information
              if (cg.callsExternal(&currMI)) {
                MicroArchDom notneeded(AnaDomInit::BOTTOM); // Discarded anyway
                // transferCall also accounts for the sync instruction cycling
                // on external functions
                tmp.transferCall(&currMI, &beforeCallCtx, anaDeps, nullptr,
                                 notneeded);
                callStates.join(tmp);
              } else {
                for (auto callee : cg.getPotentialCallees(&currMI)) {
                  MicroArchDom notneeded(
                      AnaDomInit::BOTTOM); // Discarded anyway
                  tmp.transferCall(&currMI, &beforeCallCtx, anaDeps, callee,
                                   notneeded);
                  callStates.join(tmp);
                }
              }
            }
          }
          unsigned callStateId = graph.addVertex();
          states.insert(std::make_pair(callStateId, callStates));
          callVertices.insert(std::make_pair(&currMI, callStateId));

          graph.addEdge(inStatesId, callStateId);
          for (auto cb : this->constructionCallbacks) {
            cb->addEdge(inStatesId, callStateId);
          }
          // Insert return state
          MicroArchDom returnStates(AnaDomInit::BOTTOM);
          auto &ctxStateInfoAfter = mai.getAnaInfoAfter(&currMI);
          if (!ctxStateInfoAfter.isBottom()) {
            for (auto &ctx2ana :
                 ctxStateInfoAfter.getAnalysisInfoPerContext()) {
              MicroArchDom tmp = ctx2ana.second;
              returnStates.join(tmp);
            }
          }
          inStatesId = graph.addVertex(); // Start anew from return vertex
          states.insert(std::make_pair(inStatesId, returnStates));
          returnVertices.insert(std::make_pair(&currMI, inStatesId));
        }
        if (isEndInstr(*(currMI.getParent()), &currMI)) {
          // Do necessary guarding
          bool needGuarded = currMI.isConditionalBranch() ||
                             isJumpTableBranch(&currMI) || currMI.isReturn();
          bool needBothGuards =
              needGuarded && (&currMI == getLastInstrInBB(currBB));
          auto ctxStateInfoAfter =
              needGuarded
                  ? mai.getAnaInfoAfterGuarded(&currMI, BranchOutcome::taken())
                  : mai.getAnaInfoAfter(&currMI);
          if (needBothGuards) {
            ctxStateInfoAfter.join(
                mai.getAnaInfoAfterGuarded(&currMI, BranchOutcome::nottaken()));
          }
          // End information is collected states for all contexts
          if (!ctxStateInfoAfter.isBottom()) {
            for (auto &ctx2ana :
                 ctxStateInfoAfter.getAnalysisInfoPerContext()) {
              MicroArchDom tmp = ctx2ana.second;
              outStates.join(tmp);
            }
          }
        }
      }

      states.insert(std::make_pair(outStatesId, outStates));
      outVertexPerMBB.insert(std::make_pair(&currBB, outStatesId));

      graph.addEdge(inStatesId, outStatesId);
      for (auto cb : this->constructionCallbacks) {
        cb->addEdge(inStatesId, outStatesId);
      }
    }
  }
}

template <class MicroArchDom>
void InsensitiveGraph<MicroArchDom>::buildInterBasicBlockEdges() {
  // Add call edges to the graph
  for (auto &callsite2states : callVertices) {
    auto instr = callsite2states.first;
    assert(instr->isCall() && "Callsite is not a call instruction");
    // external symbol, no call to a function in the program
    if (CallGraph::getGraph().callsExternal(instr)) {
      const auto &funcName = CallGraph::getGraph().getExternalCalleeName(instr);
      if (extFuncVertices.count(funcName) == 0) {
        addExternalFunctionToGraph(funcName);
      }
      unsigned calleeInId = extFuncVertices.at(funcName).first;
      graph.addEdge(callsite2states.second, calleeInId);
      assert(returnVertices.count(instr) > 0 && "Call but unreachable return");
      unsigned calleeOutId = extFuncVertices.at(funcName).second;
      graph.addEdge(calleeOutId, returnVertices.at(instr));
    } else { // real call to another function
      auto mfs = CallGraph::getGraph().getPotentialCallees(instr);
      assert(mfs.size() == 1 && "Not exactly one function found for call");
      // get first basic block of that function
      const MachineBasicBlock *pMbb = &*(mfs.front()->begin());
      auto callId = callsite2states.second;
      auto calleeId = inVertexPerMBB.at(pMbb);
      graph.addEdge(callId, calleeId);
    }
  }

  // Add inter basic-block and return edges
  for (MachineFunction *currFunc :
       machineFunctionCollector->getAllMachineFunctions()) {
    for (auto &currMBB : *currFunc) {
      // If basic block is empty or unreachable, pass no edge there
      if (isBasicBlockEmpty(&currMBB) || outVertexPerMBB.count(&currMBB) == 0) {
        continue;
      }
      auto outId = outVertexPerMBB.at(&currMBB);
      for (auto succMBB : getNonEmptySuccessorBasicBlocks(currMBB)) {
        unsigned targetId = inVertexPerMBB.at(succMBB);
        graph.addEdge(outId, targetId);
      }
      bool canReturn = false;
      for (auto currMI = currMBB.begin(); currMI != currMBB.end(); ++currMI) {
        canReturn |= currMI->isReturn();
      }
      if (canReturn) {
        if (currFunc == getAnalysisEntryPoint()) {
          graph.addEdge(outId, 0);
        } else {
          for (auto callsite : CallGraph::getGraph().getCallSites(currFunc)) {
            if (callVertices.count(callsite) == 0) {
              continue; // Skip the unreachable calls
            }
            unsigned targetId = returnVertices.at(callsite);
            graph.addEdge(outId, targetId);
          }
        }
      }
    }
  }

  auto startFunc = getAnalysisEntryPoint();
  MachineBasicBlock *startMbb = &*(startFunc->begin());
  assert(startMbb->getNumber() == 0 &&
         "First Basic block of function did not have number 0.");
  auto inState = inVertexPerMBB.at(startMbb);
  graph.addEdge(0, inState);

  // add idle cycle as self-loop to the special vertex
  graph.addEdge(0, 0);
}

template <class MicroArchDom>
void InsensitiveGraph<MicroArchDom>::addExternalFunctionToGraph(
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
void InsensitiveGraph<MicroArchDom>::dump(
    std::ostream &mystream,
    const std::map<std::string, double> *optTimesTaken) const {
  if (!DumpVcgGraph) {
    int clusterNr = 0;
    mystream << "digraph WCET {\n    label = \"Microarchitectural State "
                "Graph\"\n    color=blue;\n    node [color=black, "
                "shape=square];\n  subgraph cluster_"
             << clusterNr++ << " {";

    // Build nodes for all states in functions and basic blocks
    for (MachineFunction *currFunc :
         machineFunctionCollector->getAllMachineFunctions()) {
      std::string funcName = currFunc->getName().str();
      mystream << "subgraph cluster_" << clusterNr++ << " {\n	label = \""
               << funcName << "\"\n";
      for (auto &currMBB : *currFunc) {
        std::string mbbName = currMBB.getFullName();
        mystream << "subgraph cluster_" << clusterNr++ << "{\n	label =  \""
                 << mbbName << "\"\n";

        if (inVertexPerMBB.count(&currMBB) > 0) {
          auto inSts = inVertexPerMBB.at(&currMBB);
          mystream << inSts << "[ label = \"In-" << inSts << "\", tooltip = <"
                   << states.at(inSts).print() << ">];\n";
        }
        if (outVertexPerMBB.count(&currMBB) > 0) {
          auto outSts = outVertexPerMBB.at(&currMBB);
          mystream << outSts << "[ label = \"Out-" << outSts
                   << "\", tooltip = <" << states.at(outSts).print() << ">];\n";
        }
        const auto &callsites =
            CallGraph::getGraph().getCallSitesInMBB(&currMBB);
        for (auto callsite : callsites) {
          if (callVertices.count(callsite) > 0) {
            assert(returnVertices.count(callsite) > 0 &&
                   "Calling states but no return states");
            auto cSt = callVertices.at(callsite);
            mystream << cSt << "[ label = \"Call-" << cSt << "\", tooltip = <"
                     << states.at(cSt).print() << ">];\n";
            auto rSt = returnVertices.at(callsite);
            mystream << rSt << "[ label = \"Return-" << rSt << "\", tooltip = <"
                     << states.at(rSt).print() << ">];\n";
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
    for (auto &vtpair : graph.getVertices()) {
      // skip special vertex and its edges
      if (vtpair.first == 0)
        continue;
      auto &vt = vtpair.second;
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
            weight += ",\n";
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
            weight += "Frequency: " + std::to_string(frequency->second) + "\n";
            onWCETPath = true;
          }
        }

        this->dumpEdge(mystream, edge, weight, onWCETPath);
      }
    }
    mystream << "}\n}";
  } else {
    mystream
        << "graph : { \n	layoutalgorithm : hierarchic\n	graph : "
           "{\n	title "
           ": \"State Graph\"\n	label : \"Microarchitectural State Graph\"\n";

    // Build nodes for all states in functions and basic blocks
    for (MachineFunction *currFunc :
         machineFunctionCollector->getAllMachineFunctions()) {
      std::string funcName = currFunc->getName().str();
      mystream << "graph : {\n	title : \"" << funcName
               << "\"\n	label : \"" << funcName << "\"\n";
      for (auto &currMBB : *currFunc) {
        std::string mbbName = currMBB.getFullName();
        mystream << "graph : {\n	title : \"" << mbbName
                 << "\"\n	label : \"" << mbbName << "\"\n";

        if (inVertexPerMBB.count(&currMBB) > 0) {
          auto inSts = inVertexPerMBB.at(&currMBB);
          mystream << "node : {\n	title : \"" << inSts
                   << "\"\n	label : \"In-" << inSts << "\"\n";
          mystream << "info1 : \"" << states.at(inSts).print() << "\"\n}\n";
        }
        if (outVertexPerMBB.count(&currMBB) > 0) {
          auto outSts = outVertexPerMBB.at(&currMBB);
          mystream << "node : {\n	title : \"" << outSts
                   << "\"\n	label : \"Out-" << outSts << "\"\n";
          mystream << "info1 : \"" << states.at(outSts).print() << "\"\n}\n";
        }
        const auto &callsites =
            CallGraph::getGraph().getCallSitesInMBB(&currMBB);
        for (auto callsite : callsites) {
          if (callVertices.count(callsite) > 0) {
            assert(returnVertices.count(callsite) > 0 &&
                   "Calling states but no return states");
            auto cSt = callVertices.at(callsite);
            mystream << "node : {\n	title : \"" << cSt
                     << "\"\n	label : \"Call-" << cSt << "\"\n";
            mystream << "info1 : \"" << states.at(cSt).print() << "\"\n}\n";
            auto rSt = returnVertices.at(callsite);
            mystream << "node : {\n	title : \"" << rSt
                     << "\"\n	label : \"Return-" << rSt << "\"\n";
            mystream << "info1 : \"" << states.at(rSt).print() << "\"\n}\n";
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
    for (auto &vtpair : graph.getVertices()) {
      // skip special vertex and its edges
      if (vtpair.first == 0)
        continue;
      auto &vt = vtpair.second;
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
            weight += ",\n";
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
            weight += "Frequency: " + std::to_string(frequency->second) + "\n";
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
void InsensitiveGraph<MicroArchDom>::deleteMuArchInfo() {
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
