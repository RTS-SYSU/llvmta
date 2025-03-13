////////////////////////////////////////////////////////////////////////////////
//
//   LLVMTA - Timing Analyser performing worst-case execution time analysis
//     using the LLVM backend intermediate representation
//
// Copyright (C) 2013-2022  Saarland University
// Copyright (C) 2016			  Tina Jung
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

#ifndef STATEGRAPHEDGEWEIGHTPROVIDER_H
#define STATEGRAPHEDGEWEIGHTPROVIDER_H

#include "PathAnalysis/EdgeWeightProvider.h"
#include "PathAnalysis/InsensitiveGraph.h"
#include "PathAnalysis/StateGraphConstrCallback.h"
#include "PathAnalysis/StateSensitiveGraph.h"
#include "Util/Util.h"

#include <functional>

namespace TimingAnalysisPass {

/**
 * Provides generic information as edge weight in the stategraph.
 * This information can later be used to construct constraints
 * or an objective function.
 */
template <class MuState, typename WeightType>
class StateGraphEdgeWeightProvider : public EdgeWeightProvider<WeightType>,
                                     StateGraphConstrCallback {
public:
  /**
   * Constructor. Register as a state graph construction callback.
   */
  StateGraphEdgeWeightProvider(MuStateGraph<MuState> *stgr) : stgr(stgr) {
    stgr->registerCallback(this);
  }

  virtual ~StateGraphEdgeWeightProvider() {}

  /**
   * Add an edge s->e while intra-basic-block weights are constructed.
   * Take the joined weight for all states at e, weight for s should be zero.
   */
  virtual void addEdge(unsigned s, unsigned e);
  /**
   * Advance all incoming edges of curr towards each state of succs.
   * This involves updating the weights. Finally delete the curr state.
   */
  virtual void advanceEdges(unsigned curr, std::list<unsigned> succs);
  /**
   * This variant does the same as advanceEdges.
   * However, it first stores the results to some temporary
   * data structures. The changes are later only committed
   * to edge2weight if no weight provider detected any
   * failed successors in this first step.
   */
  virtual std::set<unsigned> advanceEdgesPrepare(unsigned curr,
                                                 std::list<unsigned> succs);
  /**
   * This can be used to commit the changes prepared
   * in the previous method.
   */
  virtual void advanceEdgesCommit();
  /**
   * This can be used to roll back the changes prepared
   * in advanceEdgesPrepare.
   */
  virtual void advanceEdgesRollBack();
  /**
   * Check whether edges p->t and p->nt are compatible, i.e. joinable without
   * precision loss.
   */
  virtual bool isEdgeJoinable(unsigned p, unsigned t, unsigned nt) const = 0;
  /**
   * If joinable is set:
   * Move the edge targets of edge p->t from t to nt.
   * If the edge p->nt already existed, join weights. Finally remove t.
   * If joinable is not set:
   * Add an edge between t and nt with neutral weight. Do not remove t.
   */
  virtual void updateEdgeTarget(unsigned p, unsigned t, unsigned nt,
                                bool joinable);
  /**
   * Concatenate edges, i.e. for all predecessor p of predold do:
   * weight of (p->fresh) = sum of weight of (p->predold) and weight of
   * (predold->old). The old weights p->predold and predold->old can be removed.
   */
  virtual void concatEdges(unsigned predold, unsigned old, unsigned fresh);
  /**
   * Add an edge s->e modelling the effects of external function extfun.
   */
  virtual void addExternalEdge(std::string extfun, unsigned s, unsigned e) = 0;
  /**
   * Give a string representation of the weights we are collecting via this
   * callback. Note @implementer: It might happen that (a,b) is not in the
   * edge2weight map due to an optimization. Please assume the neutral weight in
   * this case
   */
  virtual std::string getWeightDescr(unsigned a, unsigned b) const = 0;

protected:
  typedef typename MuState::LocalMetrics LocalMetrics;
  /**
   * A function extracting the weight from the local metrics.
   */
  virtual WeightType extractWeight(const LocalMetrics &metrics) = 0;
  /**
   * A function joining two weights.
   */
  virtual void joinWeight(WeightType &weight1, const WeightType &weight2) = 0;
  /**
   * Function to concatenate weights.
   */
  virtual void concatWeight(WeightType &weight1, const WeightType &weight2) = 0;
  /**
   * Get the neutral weight, e.g. initial weight on a new (initial) edge.
   */
  virtual WeightType getNeutralWeight() = 0;
  /**
   * Advance the weight valid at curr to a valid one at succ;
   */
  virtual WeightType advanceWeight(const WeightType &weight,
                                   const LocalMetrics &curr,
                                   const LocalMetrics &succ) = 0;
  /**
   * Check whether the two given weights are equal.
   */
  virtual bool equalWeight(const WeightType &w1, const WeightType &w2) const {
    return w1 == w2;
  }

  /**
   * Reference to the state graph itself.
   */
  MuStateGraph<MuState> *stgr;
  /**
   * Data structures used as temporary cache.
   */
  std::map<GraphEdge, WeightType> edge2weightInsert;
  std::list<GraphEdge> edgesToErase;
};

template <class MuState, typename WeightType>
void StateGraphEdgeWeightProvider<MuState, WeightType>::addEdge(unsigned s,
                                                                unsigned e) {
  typedef typename MuState::LocalMetrics LocalMetrics;
  // All incoming states should have initial weight
  for (const auto &st : stgr->getStatesForId(s)) {
    assert(extractWeight(LocalMetrics(st)) == getNeutralWeight() &&
           "New edge should start with valid initial weight");
  }
  // Join the weight for all ending states
  auto endStates = stgr->getStatesForId(e);
  assert(endStates.size() > 0 && "No metrics for bottom");
  auto stateIter = endStates.begin();
  auto result = extractWeight(LocalMetrics(*stateIter));
  ++stateIter;
  for (; stateIter != endStates.end(); ++stateIter) {
    joinWeight(result, extractWeight(LocalMetrics(*stateIter)));
  }
  this->edge2weight.insert(std::make_pair(std::make_pair(s, e), result));
}

template <class MuState, typename WeightType>
void StateGraphEdgeWeightProvider<MuState, WeightType>::advanceEdges(
    unsigned curr, std::list<unsigned> succs) {
  for (auto pred : stgr->getGraph().getPredecessors(curr)) {
    WeightType &weight = this->edge2weight.at(std::make_pair(pred, curr));
    for (auto succ : succs) {
      typedef typename MuState::LocalMetrics LocalMetrics;
      auto statesSucc = stgr->getStatesForId(succ);
      auto statesCurr = stgr->getStatesForId(curr);
      assert(statesSucc.size() == 1 && statesCurr.size() == 1 &&
             "AdvanceEdge only on single state");
      LocalMetrics succLocalMetrics(*statesSucc.begin());
      LocalMetrics currLocalMetrics(*statesCurr.begin());
      const WeightType &newweight =
          advanceWeight(weight, currLocalMetrics, succLocalMetrics);
      auto insertionResult = this->edge2weight.insert(
          std::make_pair(std::make_pair(pred, succ), newweight));
      assert((insertionResult.second ||
              equalWeight(newweight, insertionResult.first->second)) &&
             "There is already a different weight for the edge from pred to "
             "succ.");
    }
    this->edge2weight.erase(std::make_pair(pred, curr));
  }
}

template <class MuState, typename WeightType>
std::set<unsigned>
StateGraphEdgeWeightProvider<MuState, WeightType>::advanceEdgesPrepare(
    unsigned curr, std::list<unsigned> succs) {
  assert(edge2weightInsert.empty());
  assert(edgesToErase.empty());
  std::set<unsigned> failedSuccessors;
  for (auto pred : stgr->getGraph().getPredecessors(curr)) {
    WeightType &weight = this->edge2weight.at(std::make_pair(pred, curr));
    for (auto succ : succs) {
      typedef typename MuState::LocalMetrics LocalMetrics;
      auto statesSucc = stgr->getStatesForId(succ);
      auto statesCurr = stgr->getStatesForId(curr);
      assert(statesSucc.size() == 1 && statesCurr.size() == 1 &&
             "AdvanceEdge only on single state");
      LocalMetrics succLocalMetrics(*statesSucc.begin());
      LocalMetrics currLocalMetrics(*statesCurr.begin());
      const WeightType &newweight =
          advanceWeight(weight, currLocalMetrics, succLocalMetrics);
      auto predSuccEdge = std::make_pair(pred, succ);
      // check if insertion would succeed
      bool insertionWouldBeSuccessful =
          this->edge2weight.count(predSuccEdge) == 0 ||
          equalWeight(this->edge2weight[predSuccEdge], newweight);
      if (!insertionWouldBeSuccessful) {
        failedSuccessors.insert(succ);
      }
      // if no successor failed so far, remember the
      // new weight of the edge for the commit step
      if (failedSuccessors.empty()) {
        edge2weightInsert.insert(std::make_pair(predSuccEdge, newweight));
      }
    }
    // if no successor failed so far, remember the
    // edge from pred to curr is marked for deletion
    if (failedSuccessors.empty()) {
      edgesToErase.push_back(std::make_pair(pred, curr));
    }
  }
  return failedSuccessors;
}

template <class MuState, typename WeightType>
void StateGraphEdgeWeightProvider<MuState, WeightType>::advanceEdgesCommit() {
  // persist the changed prepared earlier.
  // this only happens neither this weight provider,
  // nor any other registered weight provider detected
  // any failed successor.
  this->edge2weight.insert(edge2weightInsert.begin(), edge2weightInsert.end());
  edge2weightInsert.clear();
  for (auto &edge : edgesToErase) {
    this->edge2weight.erase(edge);
  }
  edgesToErase.clear();
}

template <class MuState, typename WeightType>
void StateGraphEdgeWeightProvider<MuState, WeightType>::advanceEdgesRollBack() {
  // drop everything prepared
  edge2weightInsert.clear();
  edgesToErase.clear();
}

template <class MuState, typename WeightType>
void StateGraphEdgeWeightProvider<MuState, WeightType>::updateEdgeTarget(
    unsigned p, unsigned t, unsigned nt, bool joinable) {
  if (joinable) {
    WeightType weight = this->edge2weight.at(std::make_pair(p, t));
    if (stgr->getGraph().hasEdge(p, nt)) {
      const WeightType &weight2 = this->edge2weight.at(std::make_pair(p, nt));
      joinWeight(weight, weight2);
      this->edge2weight.erase(std::make_pair(p, nt));
    }
    this->edge2weight.insert(std::make_pair(std::make_pair(p, nt), weight));
    this->edge2weight.erase(std::make_pair(p, t));
  } else {
    this->edge2weight.insert(
        std::make_pair(std::make_pair(t, nt), getNeutralWeight()));
  }
}

template <class MuState, typename WeightType>
void StateGraphEdgeWeightProvider<MuState, WeightType>::concatEdges(
    unsigned predold, unsigned old, unsigned fresh) {
  auto weight2 = this->edge2weight.at(std::make_pair(predold, old));
  for (auto p : stgr->getGraph().getPredecessors(predold)) {
    auto weight = this->edge2weight.at(std::make_pair(p, predold));
    concatWeight(weight, weight2);
    this->edge2weight.insert(std::make_pair(std::make_pair(p, fresh), weight));
  }
  this->edge2weight.erase(std::make_pair(predold, old));
  auto successors = stgr->getGraph().getSuccessors(predold);
  successors.erase(old);
  if (successors.size() == 0) {
    for (auto p : stgr->getGraph().getPredecessors(predold)) {
      this->edge2weight.erase(std::make_pair(p, predold));
    }
  }
}

} // namespace TimingAnalysisPass

#endif
