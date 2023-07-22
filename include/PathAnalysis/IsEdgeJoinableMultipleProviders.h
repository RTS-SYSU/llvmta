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

#ifndef ISEDGEJOINABLEMULTIPLEPROVIDERS_H
#define ISEDGEJOINABLEMULTIPLEPROVIDERS_H

#include "PathAnalysis/StateGraph.h"
#include "PathAnalysis/StateGraphEdgeWeightProvider.h"
#include "PathAnalysis/StateGraphIsEdgeJoinableCallback.h"

namespace TimingAnalysisPass {

/**
 * This class implements a generic way to argue about
 * the joinability of edges based on the weights of
 * multiple weight providers.
 */
template <typename MuState, typename... WeightTypes>
class IsEdgeJoinableMultipleProviders
    : public StateGraphIsEdgeJoinableCallback {
public:
  /**
   * Constructor. Register as a state graph is-edge-joinable callback.
   * Pass in references to multiple weight providers and
   * a function that makes a joinability decision for an edge
   * based on the weights given by the providers.
   */
  IsEdgeJoinableMultipleProviders(
      MuStateGraph<MuState> *stgr,
      std::function<bool(WeightTypes..., WeightTypes...)> isJoinable,
      const StateGraphEdgeWeightProvider<MuState, WeightTypes> &...providers)
      : isJoinable(isJoinable), providers(std::tie(providers...)) {
    stgr->registerIsEdgeJoinableCallback(this);
  }

  virtual ~IsEdgeJoinableMultipleProviders(){};

  /**
   * Check whether edges p->t and p->nt are compatible, i.e. joinable without
   * precision loss.
   */
  virtual bool isEdgeJoinable(unsigned p, unsigned t, unsigned nt) const {
    return internalHelper(p, t, nt,
                          std::make_index_sequence<sizeof...(WeightTypes)>());
  }

protected:
  std::function<bool(WeightTypes..., WeightTypes...)> isJoinable;
  std::tuple<const StateGraphEdgeWeightProvider<MuState, WeightTypes> &...>
      providers;

  template <std::size_t... I>
  bool internalHelper(unsigned p, unsigned t, unsigned nt,
                      std::index_sequence<I...>) const {
    return isJoinable((std::get<I>(providers).getWeight(p, t))...,
                      (std::get<I>(providers).getWeight(p, nt))...);
  }
};

} // namespace TimingAnalysisPass

#endif
