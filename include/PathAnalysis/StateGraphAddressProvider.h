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

#ifndef STATEGRAPHADDRESSPROVIDER_H
#define STATEGRAPHADDRESSPROVIDER_H

#include "PathAnalysis/StateGraphEdgeWeightProvider.h"
#include "Util/Util.h"

#include <set>

namespace TimingAnalysisPass {

/**
 * Provides address information as edge weight in the stategraph.
 * This information can later be used to perform preemption-costs analyses.
 */
template <class MuState>
class StateGraphAddressProvider
    : public StateGraphEdgeWeightProvider<MuState,
                                          std::vector<AbstractAddress>> {
public:
  // The weight is a vector (ordered!) of accessed address intervals.
  typedef std::vector<AbstractAddress> WeightType;

  /**
   * Constructor. Call parent constructor with appropriate parameters.
   */
  StateGraphAddressProvider(
      MuStateGraph<MuState> *stgr, bool dataCache,
      const std::function<boost::optional<AbstractAddress>(
          const typename MuState::LocalMetrics &)>
          getJustAccessed)
      : StateGraphEdgeWeightProvider<MuState, WeightType>(stgr),
        dataCache(dataCache), getJustAccessed(getJustAccessed) {}

  virtual ~StateGraphAddressProvider() {}

  /// See Superclass
  virtual bool isEdgeJoinable(unsigned p, unsigned t, unsigned nt) const;
  /// See Superclass
  virtual void addExternalEdge(std::string extfun, unsigned s, unsigned e);
  /// See Superclass
  virtual std::string getWeightDescr(unsigned a, unsigned b) const;

protected:
  typedef typename MuState::LocalMetrics LocalMetrics;

  virtual WeightType extractWeight(const LocalMetrics &metrics);

  virtual void joinWeight(WeightType &weight1, const WeightType &weight2);

  virtual void concatWeight(WeightType &weight1, const WeightType &weight2);

  virtual WeightType getNeutralWeight();

  virtual WeightType advanceWeight(const WeightType &weight,
                                   const LocalMetrics &curr,
                                   const LocalMetrics &succ);

  virtual bool equalWeight(const WeightType &w1, const WeightType &w2) const;

private:
  bool dataCache;

  const std::function<boost::optional<AbstractAddress>(const LocalMetrics &)>
      getJustAccessed;

  std::string printWeight(const WeightType &weight) const;
};

template <class MuState>
typename StateGraphAddressProvider<MuState>::WeightType
StateGraphAddressProvider<MuState>::extractWeight(const LocalMetrics &metrics) {
  // Accessed addresses are extracted from the (edge to the) successor
  WeightType result;
  return result;
}

template <class MuState>
bool StateGraphAddressProvider<MuState>::equalWeight(
    const WeightType &w1, const WeightType &w2) const {
  bool equal = (w1.size() == w2.size());
  if (!equal) {
    return false;
  }
  auto it1 = w1.begin();
  auto it2 = w2.begin();
  for (; it1 != w1.end(); ++it1, ++it2) {
    equal &= it1->isSameInterval(*it2);
  }
  return equal;
}

template <class MuState>
bool StateGraphAddressProvider<MuState>::isEdgeJoinable(unsigned p, unsigned t,
                                                        unsigned nt) const {
  assert(this->edge2weight.count(std::make_pair(p, t)) > 0 &&
         this->edge2weight.count(std::make_pair(p, nt)) > 0 &&
         "Test non-existing edges to join");
  // We consider sets of definite misses only to be joinable if they are indeed
  // equal
  auto &w1 = this->edge2weight.at(std::make_pair(p, t));
  auto &w2 = this->edge2weight.at(std::make_pair(p, nt));
  return equalWeight(w1, w2);
}

template <class MuState>
void StateGraphAddressProvider<MuState>::joinWeight(WeightType &weight1,
                                                    const WeightType &weight2) {
  // Only joinable when equal anyway
  assert(equalWeight(weight1, weight2) && "Can only join equal weights");
}

template <class MuState>
void StateGraphAddressProvider<MuState>::concatWeight(
    WeightType &weight1, const WeightType &weight2) {
  weight1.insert(weight1.end(), weight2.begin(), weight2.end());
}

template <class MuState>
typename StateGraphAddressProvider<MuState>::WeightType
StateGraphAddressProvider<MuState>::getNeutralWeight() {
  // Return a empty vector as neutral element
  WeightType result;
  return result;
}

template <class MuState>
typename StateGraphAddressProvider<MuState>::WeightType
StateGraphAddressProvider<MuState>::advanceWeight(const WeightType &weight,
                                                  const LocalMetrics &curr,
                                                  const LocalMetrics &succ) {
  // Add a miss if possible
  WeightType result(weight);
  const auto &justAccessed = getJustAccessed(succ);
  if (justAccessed) { // If we just accessed an element
    auto &addressitv = justAccessed.get();
    result.push_back(addressitv);
  }
  return result;
}

template <class MuState>
void StateGraphAddressProvider<MuState>::addExternalEdge(std::string extfun,
                                                         unsigned s,
                                                         unsigned e) {
  assert(0 && "We cannot yet deal with external functions here");
  WeightType weight; // Only empty set for external function
  this->edge2weight.insert(std::make_pair(std::make_pair(s, e), weight));
}

template <class MuState>
std::string
StateGraphAddressProvider<MuState>::getWeightDescr(unsigned a,
                                                   unsigned b) const {
  std::stringstream res;
  res << "Accesses " << (dataCache ? "Data " : "Instr ");
  if (this->edge2weight.count(std::make_pair(a, b)) > 0) {
    res << printWeight(this->edge2weight.at(std::make_pair(a, b)));
  } else {
    res << "<empty>";
  }
  return res.str();
}

template <class MuState>
std::string StateGraphAddressProvider<MuState>::printWeight(
    const WeightType &weight) const {
  std::stringstream res;
  res << "<";
  bool emitComma = false;
  for (auto it = weight.begin(); it != weight.end(); ++it) {
    if (emitComma)
      res << ",\\n";
    res << *it;
    emitComma = true;
  }
  res << ">";
  return res.str();
}

} // namespace TimingAnalysisPass

#endif
