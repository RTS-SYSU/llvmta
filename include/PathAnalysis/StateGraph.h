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

#ifndef STATEGRAPH_H
#define STATEGRAPH_H

#include "Util/Graph.h"
#include "Util/Util.h"

#include "MicroarchitecturalAnalysis/MicroArchitecturalState.h"
#include "PathAnalysis/StateGraphConstrCallback.h"
#include "PathAnalysis/Variable.h"

#include <string>
#include <unordered_map>

namespace TimingAnalysisPass {

/**
 * Interface for all state graphs, the state-sensitive as well as the
 * insensitive ones. The structural part of the state graph is later passed to
 * the Path Analysis to build the ILP model.
 */
class StateGraph {
public:
  /**
   * Register stategraph construction callbacks.
   *
   * We inherently rely on the construction callbacks
   * being iterated over in the exactly same order
   * as they were registered. Make sure to not violate
   * this hypothesis.
   */
  void registerCallback(StateGraphConstrCallback *cb) {
    constructionCallbacks.push_back(cb);
  }

  /**
   * Register stategraph is-edge-joinable callbacks
   */
  void registerIsEdgeJoinableCallback(StateGraphIsEdgeJoinableCallback *cb) {
    isEdgeJoinableCallbacks.push_back(cb);
  }

  virtual void buildGraph() = 0;

  virtual const Graph &getGraph() const = 0;

  virtual std::vector<unsigned>
  getInStates(const MachineBasicBlock *mbb) const = 0;

  virtual std::vector<unsigned>
  getOutStates(const MachineBasicBlock *mbb) const = 0;

  virtual std::vector<unsigned> getCallStates(const MachineInstr *mi) const = 0;

  virtual std::vector<unsigned>
  getReturnStates(const MachineInstr *mi) const = 0;

  /**
   * Return, if possible, the context of the given state.
   * This is possible for state- or context-sensitive graph,
   * but hardly possible for the insensitive graph version.
   * If not supported, return null on default.
   */
  virtual const Context *getContextOfState(unsigned stateid) const {
    return nullptr;
  }

  /* dumps the StateGraph in .vcg format. If optTimesTaken is not NULL it
   * is assumed to be a mapping from LP-variable names to edge
   * frequencies. All variables with frequency > 0 (i.e. the worst-case
   * path) are colored in "this->longestPathColor" */
  virtual void dump(std::ostream &mystream,
                    const std::map<std::string, double> *optTimesTaken,
                    bool f = true) const = 0;

  virtual ~StateGraph() {}

protected:
  /* helper function: dumps a single edge definition. If onWCETPath is set
   * the edge is considered part of the WCET-path and layouted according to
   * the WCETPathStyle */
  virtual void dumpEdge(std::ostream &stream,
                        std::pair<unsigned, unsigned> edge, std::string &label,
                        bool onWCETPath, bool onBCETPath) const {
    if (!DumpVcgGraph) {
      stream << edge.first << "->" << edge.second << "[ label = \"" << label
             << "\"\n";

      if (onWCETPath) {
        stream << ", color = " << this->WCETPathStyle.color
               << ", penwidth = " << this->WCETPathStyle.thickness << " ";
      } else if (onBCETPath) {
        stream << ", color = " << this->BCETPathStyle.color
               << ", penwidth = " << this->BCETPathStyle.thickness << " ";
      }
      stream << "]\n";
    } else {
      stream << "edge : {\n";
      stream << "\tsourcename : \"" << edge.first << "\" ";
      stream << "targetname : \"" << edge.second << "\"\n";
      stream << "\tlabel : \"" << label << "\"\n";

      if (onWCETPath) {
        stream << "\tcolor : " << this->WCETPathStyle.color << "\n";
        stream << "\tthickness: " << this->WCETPathStyle.thickness << "\n";
      } else if (onBCETPath) {
        stream << ", color = " << this->BCETPathStyle.color
               << ", penwidth = " << this->BCETPathStyle.thickness << " ";
      }
      stream << "}\n";
    }
  }

  std::list<StateGraphConstrCallback *> constructionCallbacks;
  std::list<StateGraphIsEdgeJoinableCallback *> isEdgeJoinableCallbacks;
  const struct {
    std::string color = "red";
    int thickness = 3;
  } WCETPathStyle;
  const struct {
    std::string color = "green";
    int thickness = 3;
  } BCETPathStyle;
};

template <class MuState> class MuStateGraph : public StateGraph {
public:
  typedef MuState State;

  virtual void freeMuStates() = 0;
  virtual typename MuState::StateSet getStatesForId(unsigned id) = 0;
  virtual void deleteMuArchInfo() = 0;

  //   inline void dump_graph(std::ostream &mystream,
  //                          const std::map<std::string, double> *WCETPath,
  //                          const std::map<std::string, double> *BCETPath,
  //                          const Graph &graph,
  //                          const std::set<unsigned> &persistStates,
  //                          const std::map<unsigned, State>
  //                          &id2state,std::map<const MachineInstr *,
  //                          std::vector<unsigned>, instrptrcomp>
  //       callStates;

  //   std::map<const MachineInstr *,
  //            std::unordered_map<Context, std::vector<unsigned>>,
  //            instrptrcomp>
  //       returnStates;) const {
  //     if (!DumpVcgGraph) {
  //       int clusterNr = 0;
  //       mystream << "digraph WCET {\n    label = \"Microarchitectural State "
  //                   "Graph\"\n    color=blue;\n    node [color=black, "
  //                   "shape=square];\n  subgraph cluster_"
  //                << clusterNr++ << " {";

  //       std::set<unsigned> persistStatesAlreadyDumped;
  //       const std::function<void(unsigned, const std::set<unsigned> &)>
  //           dumpPersistSuccessors =
  //               [&graph, &persistStates, &id2state,
  //               &persistStatesAlreadyDumped,
  //                &mystream, &dumpPersistSuccessors](
  //                   unsigned currId, const std::set<unsigned>
  //                   &statesLeavingBB) {
  //                 for (unsigned succId : graph.getSuccessors(currId)) {
  //                   if (persistStates.count(succId) > 0 &&
  //                       persistStatesAlreadyDumped.count(succId) == 0) {
  //                     mystream << succId << " [ label = \"Mid-" << succId
  //                              << "\", tooltip = <" << id2state.at(succId)
  //                              << ">];\n";
  //                     persistStatesAlreadyDumped.insert(succId);
  //                     if (statesLeavingBB.count(succId) == 0) {
  //                       // if succId is a leaving state of the current BB,
  //                       // then its successors belong to a different BB
  //                       // and, thus, must not be dumped into the current BB
  //                       dumpPersistSuccessors(succId, statesLeavingBB);
  //                     }
  //                   }
  //                 }
  //               };

  //       // Build nodes for all states in functions and basic blocks
  //       for (MachineFunction *currFunc :
  //            machineFunctionCollector->getAllMachineFunctions()) {
  //         std::string funcName = currFunc->getName().str();
  //         mystream << "subgraph cluster_" << clusterNr++ << " {\n	label =
  //         \""
  //                  << funcName << "\"\n";
  //         for (auto &currMBB : *currFunc) {
  //           std::string mbbName = currMBB.getFullName();
  //           mystream << "subgraph cluster_" << clusterNr++
  //                    << " {\n	label = \"" << mbbName << "\"\n";
  //           // dump call states of the BB and collect their ids as leaving at
  //           // the same time
  //           std::set<unsigned> statesLeavingBB;
  //           const auto &callsites =
  //               CallGraph::getGraph().getCallSitesInMBB(&currMBB);
  //           for (auto callsite : callsites) {
  //             if (callStates.count(callsite) > 0) {
  //               assert(returnStates.count(callsite) > 0 &&
  //                      "Calling states 	but no return states");
  //               auto &currentCallStates = callStates.at(callsite);
  //               statesLeavingBB.insert(currentCallStates.begin(),
  //                                      currentCallStates.end());
  //               for (auto cSt : currentCallStates) {
  //                 mystream << cSt << " [ label = \"Call-" << cSt
  //                          << "\", tooltip = <" << id2state.at(cSt) <<
  //                          ">];\n";
  //               }
  //             }
  //           }
  //           // dump out states of the BB and collect their ids as leaving at
  //           // the same time
  //           for (auto ctxStMap : outStatesPerMBBPerContext.at(&currMBB)) {
  //             auto &currentStates = ctxStMap.second;
  //             statesLeavingBB.insert(currentStates.begin(),
  //             currentStates.end()); for (auto outSts : currentStates) {
  //               mystream << outSts << " [ label = \"Out-" << outSts
  //                        << "\" , tooltip = <" << id2state.at(outSts) <<
  //                        ">];\n";
  //             }
  //           }
  //           // dump in states of the basic block
  //           for (auto ctxStMap : inStatesPerMBBPerContext.at(&currMBB)) {
  //             for (auto inSts : ctxStMap.second) {
  //               mystream << inSts << " [ label = \"In-" << inSts
  //                        << "\" , tooltip = <" << id2state.at(inSts) <<
  //                        ">];\n";
  //               dumpPersistSuccessors(inSts, statesLeavingBB);
  //             }
  //           }
  //           // dump additional states of the basic block
  //           if (additionalStates.count(&currMBB) > 0) {
  //             for (auto addSt : additionalStates.at(&currMBB)) {
  //               mystream << addSt << " [ label = \"Mid-" << addSt
  //                        << "\" , tooltip = <" << id2state.at(addSt) <<
  //                        ">];\n";
  //               dumpPersistSuccessors(addSt, statesLeavingBB);
  //             }
  //           }
  //           // dump return states of the basic block
  //           for (auto callsite : callsites) {
  //             if (callStates.count(callsite) > 0) {
  //               for (auto &ctx2cSts : returnStates.at(callsite)) {
  //                 for (auto cSt : ctx2cSts.second) {
  //                   mystream << cSt << " [ label = \"Return-" << cSt
  //                            << "\" , tooltip = <" << id2state.at(cSt) <<
  //                            ">];\n";
  //                   dumpPersistSuccessors(cSt, statesLeavingBB);
  //                 }
  //               }
  //             }
  //           }
  //           mystream << "}\n";
  //         }
  //         mystream << "}\n";
  //       }

  //       for (auto &extFunc : extFuncVertices) {
  //         mystream << "subgraph cluster_" << clusterNr++ << " {\n	label =
  //         \""
  //                  << extFunc.first << "\"\n";
  //         mystream << extFunc.second.first << "[ label = \"In-"
  //                  << extFunc.second.first
  //                  << "\" , tooltip = \"No information about state in
  //                  external "
  //                     "	function.\"]\n";
  //         mystream << extFunc.second.second << "[ label = \"Out-"
  //                  << extFunc.second.second
  //                  << "\" , tooltip = \"No information about state in
  //                  external "
  //                     "	function.\"]\n";
  //         mystream << "}\n";
  //       }

  //       /* TODO we probably can pull this entire code into super->dumpEdge */
  //       // add all edges with weight from graph
  //       auto &completeGraph = graph.getVertices();
  //       for (auto &vtpair : completeGraph) {
  //         // skip special vertex and its edges
  //         if (vtpair.first == 0)
  //           continue;
  //         auto &vt = std::get<1>(vtpair);
  //         for (auto &vt_succ : vt.getSuccessors()) {
  //           // skip edges to the special vertex
  //           if (vt_succ == 0)
  //             continue;
  //           std::string weight;
  //           bool emitComma = false;
  //           std::pair<unsigned, unsigned> edge =
  //               std::make_pair(vt.getId(), vt_succ);
  //           for (auto &ccb : this->constructionCallbacks) {
  //             if (emitComma) {
  //               weight += ",\\n";
  //             }
  //             weight += ccb->getWeightDescr(edge.first, edge.second);
  //             emitComma = true;
  //           }

  //           bool onWCETPath = false;
  //           if (optTimesTaken) {
  //             Variable edgeVar =
  //                 Variable::getEdgeVar(Variable::Type::timesTaken, edge);
  //             auto frequency = optTimesTaken->find(edgeVar.getName());
  //             if (frequency != optTimesTaken->end() && frequency->second > 0)
  //             {
  //               weight +=
  //                   ",\\nFrequency: " + std::to_string(frequency->second) +
  //                   "\\n";
  //               onWCETPath = true;
  //             }
  //           }

  //           this->dumpEdge(mystream, edge, weight, onWCETPath);
  //         }
  //       }
  //       mystream << "}\n}";

  //     } else {
  //       /*Normal .vcg Dump*/
  //       mystream << "graph : { \n	layoutalgorithm : hierarchic\n graph : "
  //                   "{\n	title "
  //                   ": \"State Graph\"\n	label : \"Microarchitectural State
  //                   " "Graph\"\n";

  //       std::set<unsigned> persistStatesAlreadyDumped;
  //       const std::function<void(unsigned, const std::set<unsigned> &)>
  //           dumpPersistSuccessors =
  //               [this, &persistStatesAlreadyDumped, &mystream,
  //                &dumpPersistSuccessors](
  //                   unsigned currId, const std::set<unsigned>
  //                   &statesLeavingBB) {
  //                 for (unsigned succId : graph.getSuccessors(currId)) {
  //                   if (persistStates.count(succId) > 0 &&
  //                       persistStatesAlreadyDumped.count(succId) == 0) {
  //                     mystream << "node : {\n	title : \"" << succId
  //                              << "\"\n	label : \"Mid-" << succId <<
  //                              "\"\n";
  //                     mystream << "info1 : \"" << id2state.at(succId)
  //                              << "\"\n}\n";
  //                     persistStatesAlreadyDumped.insert(succId);
  //                     if (statesLeavingBB.count(succId) == 0) {
  //                       // if succId is a leaving state of the current BB,
  //                       // then its successors belong to a different BB
  //                       // and, thus, must not be dumped into the current BB
  //                       dumpPersistSuccessors(succId, statesLeavingBB);
  //                     }
  //                   }
  //                 }
  //               };

  //       // Build nodes for all states in functions and basic blocks
  //       for (MachineFunction *currFunc :
  //            machineFunctionCollector->getAllMachineFunctions()) {
  //         std::string funcName = currFunc->getName().str();
  //         mystream << "graph : {\n	title : \"" << funcName
  //                  << "\"\n	label : \"" << funcName << "\"\n";
  //         for (auto &currMBB : *currFunc) {
  //           std::string mbbName = currMBB.getFullName();
  //           mystream << "graph : {\n	title : \"" << mbbName
  //                    << "\"\n	label : \"" << mbbName << "\"\n";
  //           // dump call states of the BB and collect their ids as leaving at
  //           the
  //           // same time
  //           std::set<unsigned> statesLeavingBB;
  //           const auto &callsites =
  //               CallGraph::getGraph().getCallSitesInMBB(&currMBB);
  //           for (auto callsite : callsites) {
  //             if (callStates.count(callsite) > 0) {
  //               assert(returnStates.count(callsite) > 0 &&
  //                      "Calling states but no return states");
  //               auto &currentCallStates = callStates.at(callsite);
  //               statesLeavingBB.insert(currentCallStates.begin(),
  //                                      currentCallStates.end());
  //               for (auto cSt : currentCallStates) {
  //                 mystream << "node : {\n	title : \"" << cSt
  //                          << "\"\n	label : \"Call-" << cSt << "\"\n";
  //                 mystream << "info1 : \"" << id2state.at(cSt) << "\"\n}\n";
  //               }
  //             }
  //           }
  //           // dump out states of the BB and collect their ids as leaving at
  //           the
  //           // same time
  //           for (auto ctxStMap : outStatesPerMBBPerContext.at(&currMBB)) {
  //             auto &currentStates = ctxStMap.second;
  //             statesLeavingBB.insert(currentStates.begin(),
  //             currentStates.end()); for (auto outSts : currentStates) {
  //               mystream << "node : {\n	title : \"" << outSts
  //                        << "\"\n	label : \"Out-" << outSts << "\"\n";
  //               mystream << "info1 : \"" << id2state.at(outSts) << "\"\n}\n";
  //             }
  //           }
  //           // dump in states of the basic block
  //           for (auto ctxStMap : inStatesPerMBBPerContext.at(&currMBB)) {
  //             for (auto inSts : ctxStMap.second) {
  //               mystream << "node : {\n	title : \"" << inSts
  //                        << "\"\n	label : \"In-" << inSts << "\"\n";
  //               mystream << "info1 : \"" << id2state.at(inSts) << "\"\n}\n";
  //               dumpPersistSuccessors(inSts, statesLeavingBB);
  //             }
  //           }
  //           // dump additional states of the basic block
  //           if (additionalStates.count(&currMBB) > 0) {
  //             for (auto addSt : additionalStates.at(&currMBB)) {
  //               mystream << "node : {\n	title : \"" << addSt
  //                        << "\"\n	label : \"Mid-" << addSt << "\"\n";
  //               mystream << "info1 : \"" << id2state.at(addSt) << "\"\n}\n";
  //               dumpPersistSuccessors(addSt, statesLeavingBB);
  //             }
  //           }
  //           // dump return states of the basic block
  //           for (auto callsite : callsites) {
  //             if (callStates.count(callsite) > 0) {
  //               for (auto &ctx2cSts : returnStates.at(callsite)) {
  //                 for (auto cSt : ctx2cSts.second) {
  //                   mystream << "node : {\n	title : \"" << cSt
  //                            << "\"\n	label : \"Return-" << cSt <<
  //                            "\"\n";
  //                   mystream << "info1 : \"" << id2state.at(cSt) <<
  //                   "\"\n}\n"; dumpPersistSuccessors(cSt, statesLeavingBB);
  //                 }
  //               }
  //             }
  //           }
  //           mystream << "}\n";
  //         }
  //         mystream << "}\n";
  //       }

  //       for (auto &extFunc : extFuncVertices) {
  //         mystream << "graph : {\n	title : \"" << extFunc.first
  //                  << "\"\n	label : \"" << extFunc.first << "\"\n";
  //         mystream << "node : {\n	title : \"" << extFunc.second.first
  //                  << "\"\n	label : \"In-" << extFunc.second.first
  //                  << "\"\n";
  //         mystream << "info1 : \"No information about state in external "
  //                     "function.\"\n}\n";
  //         mystream << "node : {\n	title : \"" << extFunc.second.second
  //                  << "\"\n	label : \"Out-" << extFunc.second.second
  //                  << "\"\n";
  //         mystream << "info1 : \"No information about state in external "
  //                     "function.\"\n}\n";
  //         mystream << "}\n";
  //       }

  //       /* TODO we probably can pull this entire code into super->dumpEdge */
  //       // add all edges with weight from graph
  //       auto &completeGraph = graph.getVertices();
  //       for (auto &vtpair : completeGraph) {
  //         // skip special vertex and its edges
  //         if (vtpair.first == 0)
  //           continue;
  //         auto &vt = std::get<1>(vtpair);
  //         for (auto &vt_succ : vt.getSuccessors()) {
  //           // skip edges to the special vertex
  //           if (vt_succ == 0)
  //             continue;
  //           std::string weight;
  //           bool emitComma = false;
  //           std::pair<unsigned, unsigned> edge =
  //               std::make_pair(vt.getId(), vt_succ);
  //           for (auto &ccb : this->constructionCallbacks) {
  //             if (emitComma) {
  //               weight += ",\\n";
  //             }
  //             weight += ccb->getWeightDescr(edge.first, edge.second);
  //             emitComma = true;
  //           }

  //           bool onWCETPath = false;
  //           if (optTimesTaken) {
  //             Variable edgeVar =
  //                 Variable::getEdgeVar(Variable::Type::timesTaken, edge);
  //             auto frequency = optTimesTaken->find(edgeVar.getName());
  //             if (frequency != optTimesTaken->end() && frequency->second > 0)
  //             {
  //               weight +=
  //                   ",\\nFrequency: " + std::to_string(frequency->second) +
  //                   "\\n";
  //               onWCETPath = true;
  //             }
  //           }

  //           this->dumpEdge(mystream, edge, weight, onWCETPath);
  //         }
  //       }
  //       mystream << "}\n}";
  //     }
  //   }
};

} // namespace TimingAnalysisPass

#endif
