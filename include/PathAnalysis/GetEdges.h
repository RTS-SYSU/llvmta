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

#ifndef GETEDGES_H
#define GETEDGES_H

#include "PathAnalysis/StateGraph.h"

#include "Util/Util.h"

#include <set>

namespace TimingAnalysisPass {

/**
 * Lists all distinct names of member functions
 * used for selecting edges from the graph.
 * It can be used by other classes to specify
 * in which situations they should use which
 * method provided by this class.
 *
 * Using "enum class" is necessary to avoid
 * name clashing of the enum members with
 * the class members. Basically, enum class
 * has its own sub-scope.
 *
 * Had to be removed from the class in order
 * to allow a forward declaration of it in
 * Options.h (remember that c++ does not allow
 * the forward declaration of nested types).
 *
 * If we tried to just include this header in
 * Options.h, an include cycle seems to have
 * been closed. So I stick to this solution
 * for now...
 */
enum class GetEdges_method : char {
  all,
  insideProgramRuns,
  betweenInOutReachableSimple,
  betweenInOutReachableSimplePlus,
  betweenInOutReachableDetailed
};

/**
 * This class is intended to provide easy
 * access to various subsets of edges
 * of a state graph.
 */
class GetEdges {
public:
  GetEdges(const StateGraph *graph);

  ~GetEdges();

  typedef GetEdges_method method;

  /**
   * Return all edges of the graph.
   */
  std::set<GraphEdge> all();

  /**
   * Return all edges of the graph that do
   * not touch its special node.
   */
  std::set<GraphEdge> insideProgramRuns();

  /**
   * Return all edges between (excluding) the
   * specified in edges and out edges.
   * Furthermore, also return the subsets of in
   * and out edges that is recursively reachable
   * from the in edges.
   */
  std::set<GraphEdge> betweenInOutReachableSimple(
      const std::set<GraphEdge> &inEdges, const std::set<GraphEdge> &outEdges,
      const void *cacheId, bool allowProgramRestart = false);

  /**
   * Return all edges between (excluding) the
   * specified in edges and out edges.
   * Furthermore, also return the subset of in
   * edges that is recursively reachable from
   * the in edges.
   * If this subset is not empty, return the out
   * edges reachable by the in edges as well.
   */
  std::set<GraphEdge> betweenInOutReachableSimplePlus(
      const std::set<GraphEdge> &inEdges, const std::set<GraphEdge> &outEdges,
      const void *cacheId, bool allowProgramRestart = false);

  /**
   * Return all edges between (excluding) the
   * specified in edges and out edges.
   * Furthermore, also return the subset of in
   * edges that is recursively reachable from
   * the in edges.
   * Additionally, return the subset of the out
   * edges that is reachable by the recursively
   * reachable in edges.
   */
  std::set<GraphEdge> betweenInOutReachableDetailed(
      const std::set<GraphEdge> &inEdges, const std::set<GraphEdge> &outEdges,
      const void *cacheId, bool allowProgramRestart = false);

  /**
   * Make sure to clear the caches whenever
   * the information based on which the edge
   * sets were previously calculated might
   * have changed. E.g. when the graph
   * was changed outside of this class.
   *
   * Can also be used to free the memory as
   * soon as we know that there won't be any
   * profit from the currently cached
   * contents in the remainder of the
   * provider's lifespan.
   */
  void clearCaches();

private:
  /**
   * Reference to the graph from which
   * edges are returned.
   */
  const StateGraph *stateGraph;

  /**
   * Caches for certain of the edge returning
   * member functions.
   */
  std::map<const StateGraph *, std::set<GraphEdge>> allCache;
  std::map<const StateGraph *, std::set<GraphEdge>> insideProgramRunsCache;
  std::map<const void *, std::set<GraphEdge>> betweenInOutReachableSimpleCache;
  std::map<const void *, std::set<GraphEdge>>
      betweenInOutReachableSimplePlusCache;
  std::map<const void *, std::set<GraphEdge>>
      betweenInOutReachableDetailedCache;
};

} // namespace TimingAnalysisPass

#endif
