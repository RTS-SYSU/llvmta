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

#ifndef STATEGRAPHDRAMREFRESHPROVIDER_H
#define STATEGRAPHDRAMREFRESHPROVIDER_H

#include "Memory/SimpleSDRAMCyclingMemory.h"
#include "PathAnalysis/StateGraphEdgeWeightProvider.h"
#include "Util/Util.h"

#include <list>

namespace TimingAnalysisPass {

/**
 * Provides DRAM refresh information as edge weight in the stategraph.
 * This information can later be used to obtain the objective function or to
 * formulate constraints.
 */
template <class MuState>
class StateGraphDRAMRefreshProvider
    : public StateGraphEdgeWeightProvider<MuState, unsigned> {
public:
  // The weight is the number of refreshes happening on a given edge.
  // In general, a lower bound is sufficient, but we keep it exact for best
  // precision.
  typedef unsigned WeightType;

  /**
   * Constructor. Call parent constructor with appropriate parameters.
   */
  StateGraphDRAMRefreshProvider(MuStateGraph<MuState> *stgr)
      : StateGraphEdgeWeightProvider<MuState, WeightType>(stgr) {}

  virtual ~StateGraphDRAMRefreshProvider() {}

  /// See Superclass
  virtual bool isEdgeJoinable(unsigned p, unsigned t, unsigned nt) const;
  /// See Superclass
  virtual void addExternalEdge(std::string extfun, unsigned s, unsigned e);
  /// See Superclass
  virtual std::string getWeightDescr(unsigned a, unsigned b) const;

  /**
   * Use the collected DRAM refresh information together with DRAM specification
   * to generate additional constraints.
   */
  std::list<GraphConstraint> getDRAMRefreshConstraints() const;

protected:
  typedef typename MuState::LocalMetrics LocalMetrics;

  virtual WeightType extractWeight(const LocalMetrics &metrics);

  virtual void joinWeight(WeightType &weight1, const WeightType &weight2);

  virtual void concatWeight(WeightType &weight1, const WeightType &weight2);

  virtual WeightType getNeutralWeight();

  virtual WeightType advanceWeight(const WeightType &weight,
                                   const LocalMetrics &curr,
                                   const LocalMetrics &succ);
};

template <class MuState>
typename StateGraphDRAMRefreshProvider<MuState>::WeightType
StateGraphDRAMRefreshProvider<MuState>::extractWeight(
    const LocalMetrics &metrics) {
  // We cannot decide locally to have a DRAM refresh
  WeightType result = 0;
  return result;
}

template <class MuState>
bool StateGraphDRAMRefreshProvider<MuState>::isEdgeJoinable(unsigned p,
                                                            unsigned t,
                                                            unsigned nt) const {
  assert(this->edge2weight.count(std::make_pair(p, t)) > 0 &&
         this->edge2weight.count(std::make_pair(p, nt)) > 0 &&
         "Test non-existing edges to join");
  // We consider sets of DRAM refreshes only to be joinable if they are indeed
  // equal
  return this->edge2weight.at(std::make_pair(p, t)) ==
         this->edge2weight.at(std::make_pair(p, nt));
}

template <class MuState>
void StateGraphDRAMRefreshProvider<MuState>::joinWeight(
    WeightType &weight1, const WeightType &weight2) {
  assert((weight1 == weight2) && "Cannot join unequal stuff here");
}

template <class MuState>
void StateGraphDRAMRefreshProvider<MuState>::concatWeight(
    WeightType &weight1, const WeightType &weight2) {
  weight1 += weight2;
}

template <class MuState>
typename StateGraphDRAMRefreshProvider<MuState>::WeightType
StateGraphDRAMRefreshProvider<MuState>::getNeutralWeight() {
  // Return a zero as neutral element
  WeightType result = 0;
  return result;
}

template <class MuState>
typename StateGraphDRAMRefreshProvider<MuState>::WeightType
StateGraphDRAMRefreshProvider<MuState>::advanceWeight(
    const WeightType &weight, const LocalMetrics &curr,
    const LocalMetrics &succ) {
  // Add a miss if possible
  WeightType result(weight);
  // If we saw a refresh event here, then we should add it to our weight
  auto sdrammetrics =
      dynamic_cast<SimpleSDRAMCyclingMemory::LocalMetrics *>(bgMemMetr(succ));
  assert(sdrammetrics && "Called DRAM weight provider when no DRAM was used");
  auto refresh = sdrammetrics->justRefreshed;
  if (refresh) {
    result += 1;
  }
  return result;
}

template <class MuState>
void StateGraphDRAMRefreshProvider<MuState>::addExternalEdge(std::string extfun,
                                                             unsigned s,
                                                             unsigned e) {
  WeightType weight = 0; // Only zero refreshes for external function
  this->edge2weight.insert(std::make_pair(std::make_pair(s, e), weight));
}

template <class MuState>
std::string
StateGraphDRAMRefreshProvider<MuState>::getWeightDescr(unsigned a,
                                                       unsigned b) const {
  std::stringstream res;
  res << "Refreshes ";
  if (this->edge2weight.count(std::make_pair(a, b)) > 0) {
    res << this->edge2weight.at(std::make_pair(a, b));
  } else {
    res << "0";
  }
  return res.str();
}

template <class MuState>
std::list<GraphConstraint>
StateGraphDRAMRefreshProvider<MuState>::getDRAMRefreshConstraints() const {
  /* Refresh on the same row
  unsigned refreshInterArrivalTime = SDRAMConfig.getRefreshInterArrivalCycles();
  std::cerr << "Refresh needs to happen at least every: " <<
  refreshInterArrivalTime << " cycles\n"; std::cerr << "That many refreshes: "
  << result/refreshInterArrivalTime + (result % refreshInterArrivalTime > 0 ? 1
  : 0) << " should happen\n";
  */

  std::list<GraphConstraint> constraints;

  // Constraint maxRefreshes <= (maxTime + (refreshInterArrivalTime - 1)) /
  // refreshInterArrivalTime Calculate how many refreshes are possible within
  // time currentWCETbound
  /* We have to refresh the memory every period*freq cycles. We refresh
   * one row at a time. In addition, we leave a buffer of one access
   * latency because we cannot interrupt an ongoing access */
  unsigned refreshInterArrivalTime = SDRAMConfig.getRefreshInterArrivalCycles();
  std::cerr << "Refresh needs to happen at least every: "
            << refreshInterArrivalTime << " cycles\n";
  VarCoeffVector numRefreshes;
  numRefreshes.push_back(
      std::make_pair(Variable::getGlobalVar(Variable::Type::maxNumRefreshes),
                     refreshInterArrivalTime));
  numRefreshes.push_back(
      std::make_pair(Variable::getGlobalVar(Variable::Type::maxTime), -1.0));
  GraphConstraint numRefreshesConstr = std::make_tuple(
      numRefreshes, ConstraintType::LessEqual, refreshInterArrivalTime - 1.0);
  constraints.push_back(numRefreshesConstr);

  // Build the constraint that at most that many refreshes could occur: Sum
  // refreshes <= maxNumRefreshes
  VarCoeffVector edgeTakenRefreshCount;
  for (auto &e2t : this->edge2weight) {
    auto edgeTimesTakenVar =
        Variable::getEdgeVar(Variable::Type::timesTaken, e2t.first);
    edgeTakenRefreshCount.push_back(
        std::make_pair(edgeTimesTakenVar, e2t.second));
  }
  edgeTakenRefreshCount.push_back(std::make_pair(
      Variable::getGlobalVar(Variable::Type::maxNumRefreshes), -1.0));
  GraphConstraint dramRefreshConstr =
      std::make_tuple(edgeTakenRefreshCount, ConstraintType::LessEqual, 0.0);

  // Return the constraint
  constraints.push_back(dramRefreshConstr);
  return constraints;
}

} // namespace TimingAnalysisPass

#endif
