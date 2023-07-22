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

#ifndef STATEGRAPHPREEMPTIONCACHEMISSPROVIDER_H
#define STATEGRAPHPREEMPTIONCACHEMISSPROVIDER_H

#include "Memory/AbstractCache.h"
#include "PathAnalysis/StateGraphEdgeWeightProvider.h"
#include "Util/Util.h"

namespace TimingAnalysisPass {

using namespace dom::cache;

/**
 * Provides information on incurred additional cache misses due to preemption as
 * edge weight in the stategraph.
 */
template <class MuState, CacheType CT>
class StateGraphPreemptionCacheMissProvider
    : public StateGraphNumericWeightProvider<MuState> {
public:
  // The weight is the lower bound on number of additional cache misses due to
  // preemption
  typedef unsigned WeightType;

  /**
   * Constructor. Call parent constructor with appropriate parameters.
   */
  StateGraphPreemptionCacheMissProvider(
      MuStateGraph<MuState> *stgr,
      const std::function<const dom::cache::AbstractCache *(
          const typename MuState::LocalMetrics &)>
          extractCache,
      const std::function<boost::optional<AbstractAddress>(
          const typename MuState::LocalMetrics &)>
          getJustMissed)
      : StateGraphNumericWeightProvider<MuState, WeightType>(
            stgr, [](const typename MuState::LocalMetrics &) { return 0; },
            std::string("LB ") +
                (CT == CacheType::INSTRUCTION ? "Instr" : "Data") +
                " Miss Preemption"),
        extractCache(extractCache), getJustMissed(getJustMissed) {
    // If we join, take the minimum
    this->setWeightJoiner(
        (const unsigned &(*)(const unsigned &, const unsigned &)) & std::min);
    // But actually we do not want to join
    this->setAreWeightsJoinable(
        [](const unsigned &a, const unsigned &b) { return a == b; });
  }

  virtual ~StateGraphPreemptionCacheMissProvider() {}

  GraphConstraint getInterferenceConstraint() const;

protected:
  typedef typename MuState::LocalMetrics LocalMetrics;

  virtual WeightType advanceWeight(const WeightType &weight,
                                   const LocalMetrics &curr,
                                   const LocalMetrics &succ);

private:
  /**
   * Extract the correct cache with type AbstractCache
   */
  const std::function<const dom::cache::AbstractCache *(const LocalMetrics &)>
      extractCache;

  const std::function<boost::optional<AbstractAddress>(const LocalMetrics &)>
      getJustMissed;
};

template <class MuState, CacheType CT>
typename StateGraphPreemptionCacheMissProvider<MuState, CT>::WeightType
StateGraphPreemptionCacheMissProvider<MuState, CT>::advanceWeight(
    const WeightType &weight, const LocalMetrics &curr,
    const LocalMetrics &succ) {
  // Add a miss if it was one due to preemption:
  // I.e. it was a hit in curr, but counted as miss in succ
  WeightType result(weight);
  auto justMissed = getJustMissed(succ);
  auto currCache = extractCache(curr);
  if (justMissed) { // If we just missed an element
    // Check the classification in curr
    auto cl = currCache->classify(justMissed.get());
    if (cl == CL_HIT) {
      ++result;
    }
  }
  return result;
}

template <class MuState, CacheType CT>
GraphConstraint
StateGraphPreemptionCacheMissProvider<MuState, CT>::getInterferenceConstraint()
    const {
  auto addcmvector = this->getEdgeWeightTimesTakenVector();
  auto intvar =
      (CT == CacheType::INSTRUCTION)
          ? Variable::getGlobalVar(Variable::Type::maxAddInstrMissPreemption)
          : Variable::getGlobalVar(Variable::Type::maxAddDataMissPreemption);
  addcmvector.push_back(std::make_pair(intvar, -1.0));
  return std::make_tuple(addcmvector, ConstraintType::LessEqual, 0);
}

} // namespace TimingAnalysisPass

#endif
