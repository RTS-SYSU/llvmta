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

#ifndef STATEGRAPHNUMERICWEIGHTPROVIDER_H
#define STATEGRAPHNUMERICWEIGHTPROVIDER_H

#include "Memory/SimpleSDRAMCyclingMemory.h"
#include "PathAnalysis/StateGraphEdgeWeightProvider.h"

#include "Util/Options.h"

namespace TimingAnalysisPass {

/**
 * Provides numeric information as edge weight in the stategraph.
 * This information can later be used to obtain the objective function.
 */
template <class MuState, typename NumericType = unsigned>
class StateGraphNumericWeightProvider
    : public StateGraphEdgeWeightProvider<MuState, NumericType> {
public:
  /**
   * Constructor. Call parent constructor with appropriate parameters.
   */
  StateGraphNumericWeightProvider(
      MuStateGraph<MuState> *stgr,
      const std::function<NumericType(const typename MuState::LocalMetrics &)>
          extractor,
      const std::string wName)
      //		@User You can also use non-closure lambdas: [] (const
      //NumericType& a, const NumericType&b) -> const NumericType& {return
      //std::max(a,b);} )
      : StateGraphEdgeWeightProvider<MuState, NumericType>(stgr),
        extractor(extractor), weightName(wName) {}

  virtual ~StateGraphNumericWeightProvider() {}

  /// See Superclass
  virtual bool isEdgeJoinable(unsigned p, unsigned t, unsigned nt) const;
  /// See Superclass
  virtual void addExternalEdge(std::string extfun, unsigned s, unsigned e);
  /// See Superclass
  virtual std::string getWeightDescr(unsigned a, unsigned b) const;

  /**
   * Allow to set a function that checks if two weights are joinable.
   */
  void setAreWeightsJoinable(
      std::function<bool(const NumericType &, const NumericType &)>
          areWeightsJoinable) {
    this->areWeightsJoinable = areWeightsJoinable;
  }
  /**
   * Allow to set a specific weight to the idle cycle that is
   * added as a self-loop to the special vertex.
   * If not set here, the idle cycle will be assigned the
   * neutral weight 0 by default.
   * @User: It is not necessary to set this value if you
   * only consider path that correspond to program runs.
   */
  void setIdleCycleWeight(NumericType idleCycleWeight);
  /**
   * Setting the function that joins two weights.
   */
  void setWeightJoiner(std::function<const NumericType &(const NumericType &,
                                                         const NumericType &)>
                           joiner) {
    this->joiner = joiner;
  }
  /**
   * Iterate over all edges and create a vector of pairs of variable and
   * coefficient.
   */
  VarCoeffVector getVarCoeffVector(
      std::function<void(const std::map<GraphEdge, NumericType> &,
                         VarCoeffVector &,
                         const std::pair<const GraphEdge, NumericType> &)>
          edgeTreatment) const;
  /**
   * Return a vector in which for each edge the corresponding times-
   * taken-variable is multiplied with the edge's weight.
   * The parameter allows to optionally leave out the weight of the
   * start and the end edge of the considered path from this sum.
   */
  VarCoeffVector
  getEdgeWeightTimesTakenVector(bool omitPathStartAndEndWeight = false) const;

protected:
  typedef typename MuState::LocalMetrics LocalMetrics;

  virtual NumericType extractWeight(const LocalMetrics &metrics);

  virtual void joinWeight(NumericType &weight1, const NumericType &weight2);

  virtual void concatWeight(NumericType &weight1, const NumericType &weight2);

  virtual NumericType getNeutralWeight();

  virtual NumericType advanceWeight(const NumericType &weight,
                                    const LocalMetrics &curr,
                                    const LocalMetrics &succ);

private:
  /**
   * Extract the weight from LocalMetrics.
   */
  const std::function<NumericType(const LocalMetrics &)> extractor;
  /**
   * Do a non-inplace join of weights.
   * By default it takes the maximum of the two values.
   */
  std::function<const NumericType &(const NumericType &, const NumericType &)>
      joiner = static_cast<const NumericType &(*)(const NumericType &,
                                                  const NumericType &)>(
          std::max<NumericType>);
  /**
   * The name of the weight. It is used for edges' descriptions.
   */
  const std::string weightName;
  /**
   * Function that checks if two weights are joinable.
   * The default function allows to join arbitrary weights.
   */
  std::function<bool(const NumericType &, const NumericType &)>
      areWeightsJoinable =
          [](const NumericType &, const NumericType &) { return true; };
};

template <class MuState, typename NumericType>
NumericType
StateGraphNumericWeightProvider<MuState, NumericType>::extractWeight(
    const LocalMetrics &metrics) {
  return extractor(metrics);
}

template <class MuState, typename NumericType>
bool StateGraphNumericWeightProvider<MuState, NumericType>::isEdgeJoinable(
    unsigned p, unsigned t, unsigned nt) const {
  assert(this->edge2weight.count(std::make_pair(p, t)) > 0 &&
         this->edge2weight.count(std::make_pair(p, nt)) > 0 &&
         "Test non-existing edges to join");
  // Check if the weights are joinable
  return areWeightsJoinable(this->edge2weight.at(std::make_pair(p, t)),
                            this->edge2weight.at(std::make_pair(p, nt)));
}

template <class MuState, typename NumericType>
void StateGraphNumericWeightProvider<MuState, NumericType>::joinWeight(
    NumericType &weight1, const NumericType &weight2) {
  weight1 = joiner(weight1, weight2);
}

template <class MuState, typename NumericType>
void StateGraphNumericWeightProvider<MuState, NumericType>::concatWeight(
    NumericType &weight1, const NumericType &weight2) {
  weight1 += weight2;
}

template <class MuState, typename NumericType>
NumericType
StateGraphNumericWeightProvider<MuState, NumericType>::getNeutralWeight() {
  return 0;
}

template <class MuState, typename NumericType>
NumericType
StateGraphNumericWeightProvider<MuState, NumericType>::advanceWeight(
    const NumericType &weight, const LocalMetrics &curr,
    const LocalMetrics &succ) {
  return extractWeight(succ) - extractWeight(curr) + weight;
}

template <class MuState, typename NumericType>
void StateGraphNumericWeightProvider<MuState, NumericType>::addExternalEdge(
    std::string extfun, unsigned s, unsigned e) {
  // FIXME This is a hotfix! Should do the right thing for the moment.
  // But on the long run (after mergin in Sebastians changes to this topic)
  // we should also come up with a better solution here:
  // - also lambda stuff
  // - or better labeled annotations in the existing file
  // with different labels for different weights
  NumericType weight = 0;
  if (weightName == "UB Time") {
    weight = CallGraph::getGraph().getExtFuncBound(extfun);
  }
  this->edge2weight.insert(std::make_pair(std::make_pair(s, e), weight));
}

template <class MuState, typename NumericType>
std::string
StateGraphNumericWeightProvider<MuState, NumericType>::getWeightDescr(
    unsigned a, unsigned b) const {
  NumericType res = 0;
  if (this->edge2weight.count(std::make_pair(a, b)) > 0) {
    res = this->edge2weight.at(std::make_pair(a, b));
  }
  return weightName + ": " + std::to_string(res);
}

template <class MuState, typename NumericType>
void StateGraphNumericWeightProvider<MuState, NumericType>::setIdleCycleWeight(
    NumericType idleCycleWeight) {
  this->edge2weight[std::make_pair(0, 0)] = idleCycleWeight;
}

template <class MuState, typename NumericType>
VarCoeffVector
StateGraphNumericWeightProvider<MuState, NumericType>::getVarCoeffVector(
    std::function<void(const std::map<GraphEdge, NumericType> &,
                       VarCoeffVector &,
                       const std::pair<const GraphEdge, NumericType> &)>
        edgeTreatment) const {
  VarCoeffVector result;
  for (auto &e2t : this->edge2weight) {
    edgeTreatment(this->edge2weight, result, e2t);
  }
  return result;
}

template <class MuState, typename NumericType>
VarCoeffVector StateGraphNumericWeightProvider<MuState, NumericType>::
    getEdgeWeightTimesTakenVector(bool omitPathStartAndEndWeight) const {
  return getVarCoeffVector(
      [omitPathStartAndEndWeight](
          const std::map<GraphEdge, NumericType> &edge2weight,
          VarCoeffVector &result,
          const std::pair<const GraphEdge, NumericType> &currEdgeWeight) {
        auto edgeTimesTakenVar = Variable::getEdgeVar(
            Variable::Type::timesTaken, currEdgeWeight.first);
        result.push_back(
            std::make_pair(edgeTimesTakenVar, currEdgeWeight.second));
        if (omitPathStartAndEndWeight) {
          // For the first and the last edge in the path subtract the weight
          // again.
          auto edgeIsStartVar = Variable::getEdgeVar(Variable::Type::isStart,
                                                     currEdgeWeight.first);
          result.push_back(
              std::make_pair(edgeIsStartVar, -1.0 * currEdgeWeight.second));
          auto edgeIsEndVar =
              Variable::getEdgeVar(Variable::Type::isEnd, currEdgeWeight.first);
          result.push_back(
              std::make_pair(edgeIsEndVar, -1.0 * currEdgeWeight.second));
        }
      });
}

template <class MuState>
class StateGraphCompBaseTimeWeightProvider
    : public StateGraphNumericWeightProvider<MuState, int> {
public:
  /**
   * Constructor. Call parent constructor with appropriate parameters.
   */
  StateGraphCompBaseTimeWeightProvider(
      MuStateGraph<MuState> *stgr,
      const std::function<unsigned(const typename MuState::LocalMetrics &)>
          extractor,
      const std::string wName)
      : StateGraphNumericWeightProvider<MuState, int>(stgr, extractor, wName) {}

  virtual ~StateGraphCompBaseTimeWeightProvider() {}

protected:
  typedef typename MuState::LocalMetrics LocalMetrics;

  virtual int advanceWeight(const int &weight, const LocalMetrics &curr,
                            const LocalMetrics &succ) {
    // TODO this is hardcoded for the DRAM refresh case, make it more generic
    auto sdrammetrics =
        dynamic_cast<SimpleSDRAMCyclingMemory::LocalMetrics *>(bgMemMetr(succ));
    assert(sdrammetrics && "Called DRAM weight provider when no DRAM was used");
    auto refresh = sdrammetrics->justRefreshed;
    int compbasepenalty = 0;
    if (refresh) {
      compbasepenalty = DRAMRefreshLatency;
    }
    return this->extractWeight(succ) - this->extractWeight(curr) -
           compbasepenalty + weight;
  }
};

} // namespace TimingAnalysisPass

#endif
