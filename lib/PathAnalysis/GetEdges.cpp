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

#include "PathAnalysis/GetEdges.h"

namespace TimingAnalysisPass {

GetEdges::GetEdges(const StateGraph *stateGraph) : stateGraph(stateGraph) {}

GetEdges::~GetEdges() {}

std::set<GraphEdge> GetEdges::all() {
  if (allCache.count(stateGraph) > 0) {
    return allCache[stateGraph];
  }

  auto &result = allCache[stateGraph];
  for (const auto &v1 : stateGraph->getGraph().getVertices()) {
    for (const auto &v2 : v1.second.getSuccessors()) {
      result.insert(std::make_pair(v1.first, v2));
    }
  }
  return result;
}

std::set<GraphEdge> GetEdges::insideProgramRuns() {
  if (insideProgramRunsCache.count(stateGraph) > 0) {
    return insideProgramRunsCache[stateGraph];
  }

  auto &result = insideProgramRunsCache[stateGraph];
  for (const auto &v1 : stateGraph->getGraph().getVertices()) {
    if (v1.first == 0) {
      continue;
    }
    for (const auto &v2 : v1.second.getSuccessors()) {
      if (v2 == 0) {
        continue;
      }
      result.insert(std::make_pair(v1.first, v2));
    }
  }
  return result;
}

namespace { // make helper function invisible to other compilation units
void getEdgesBetween(const StateGraph *stateGraph,
                     const std::set<GraphEdge> &inEdges,
                     const std::set<GraphEdge> &outEdges,
                     std::set<GraphEdge> &reachableBetweenEdges,
                     std::set<GraphEdge> &reachableInEdges,
                     std::set<GraphEdge> &reachableOutEdges,
                     bool allowProgramRestart = false) {
  // needed data structures
  std::list<unsigned> workList;
  std::set<unsigned> alreadyListed;

  // initialize with target ids of in edges
  for (auto inEdge : inEdges) {
    unsigned inEdgeTarget = inEdge.second;
    if (alreadyListed.count(inEdgeTarget) == 0) {
      workList.push_back(inEdgeTarget);
      alreadyListed.insert(inEdgeTarget);
    }
  }

  // iterate until the work list is empty
  while (!workList.empty()) {
    unsigned current = workList.front();
    workList.pop_front();
    for (auto succ : stateGraph->getGraph().getSuccessors(current)) {
      if (!allowProgramRestart && succ == 0u) {
        // the special node id 0u stands for a program restart
        continue;
      }
      auto edge = std::make_pair(current, succ);
      if (inEdges.count(edge) > 0) {
        // in edge: mark as reachable
        assert(outEdges.count(edge) == 0 &&
               "The in edges and out edges should not overlap.");
        reachableInEdges.insert(edge);
      } else if (outEdges.count(edge) > 0) {
        // out edge: mark as reachable
        reachableOutEdges.insert(edge);
      } else {
        // between edge: mark as reachable
        reachableBetweenEdges.insert(edge);
        // continue exploration from here if not yet listed
        if (alreadyListed.count(succ) == 0) {
          workList.push_back(succ);
          alreadyListed.insert(succ);
        }
      }
    }
  }
}
} // namespace

std::set<GraphEdge> GetEdges::betweenInOutReachableSimple(
    const std::set<GraphEdge> &inEdges, const std::set<GraphEdge> &outEdges,
    const void *cacheId, bool allowProgramRestart) {
  if (betweenInOutReachableSimpleCache.count(cacheId) > 0) {
    return betweenInOutReachableSimpleCache[cacheId];
  }

  auto &result = betweenInOutReachableSimpleCache[cacheId];
  // do not distinguish between edges, in edges and out edges
  getEdgesBetween(stateGraph, inEdges, outEdges, result, result, result);
  return result;
}

std::set<GraphEdge> GetEdges::betweenInOutReachableSimplePlus(
    const std::set<GraphEdge> &inEdges, const std::set<GraphEdge> &outEdges,
    const void *cacheId, bool allowProgramRestart) {
  if (betweenInOutReachableSimplePlusCache.count(cacheId) > 0) {
    return betweenInOutReachableSimplePlusCache[cacheId];
  }

  auto &result = betweenInOutReachableSimplePlusCache[cacheId];
  // distinguish between edges, in edges and out edges
  std::set<GraphEdge> reachableInEdges;
  std::set<GraphEdge> reachableOutEdges;
  getEdgesBetween(stateGraph, inEdges, outEdges, result, reachableInEdges,
                  reachableOutEdges);
  if (!reachableInEdges.empty()) {
    // as soon as some in edges are reachable, add all
    // reachable in edges and out edges to the result
    result.insert(reachableInEdges.begin(), reachableInEdges.end());
    result.insert(reachableOutEdges.begin(), reachableOutEdges.end());
  }
  return result;
}

std::set<GraphEdge> GetEdges::betweenInOutReachableDetailed(
    const std::set<GraphEdge> &inEdges, const std::set<GraphEdge> &outEdges,
    const void *cacheId, bool allowProgramRestart) {
  if (betweenInOutReachableDetailedCache.count(cacheId) > 0) {
    return betweenInOutReachableDetailedCache[cacheId];
  }

  auto &result = betweenInOutReachableDetailedCache[cacheId];
  // distinguish between edges, in edges and out edges
  std::set<GraphEdge> reachableInEdges;
  std::set<GraphEdge> reachableOutEdges;
  getEdgesBetween(stateGraph, inEdges, outEdges, result, reachableInEdges,
                  reachableOutEdges);
  if (!reachableInEdges.empty()) {
    // as soon as some in edges are reachable,
    // add them to the result
    result.insert(reachableInEdges.begin(), reachableInEdges.end());
    // look for the out edges reachable from the reachable in edges
    std::set<GraphEdge> dummy;
    reachableOutEdges.clear();
    getEdgesBetween(stateGraph, reachableInEdges, outEdges, result, dummy,
                    reachableOutEdges);
    // also add them to the result
    result.insert(reachableOutEdges.begin(), reachableOutEdges.end());
  }
  return result;
}

void GetEdges::clearCaches() {
  allCache.clear();
  insideProgramRunsCache.clear();
  betweenInOutReachableSimpleCache.clear();
  betweenInOutReachableSimplePlusCache.clear();
  betweenInOutReachableDetailedCache.clear();
}

} // namespace TimingAnalysisPass
