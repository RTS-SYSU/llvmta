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

#ifndef STATEGRAPHCACHEMISSPROVIDER_H
#define STATEGRAPHCACHEMISSPROVIDER_H

#include "Memory/AbstractCache.h"
#include "Memory/PersistenceScopeInfo.h"
#include "PathAnalysis/StateGraphEdgeWeightProvider.h"
#include "Util/Util.h"

#include <set>

#define DEBUG_TYPE "persconstr"
namespace TimingAnalysisPass {

/**
 * Provides cache miss information as edge weight in the stategraph.
 * This information can later be used to obtain the objective function or to
 * formulate constraints.
 */
template <class MuState, CacheType CT>
class StateGraphCacheMissProvider
    : public StateGraphEdgeWeightProvider<
          MuState, std::pair<std::set<PersistenceScope>,
                             std::set<std::pair<AbstractAddress,
                                                std::set<PersistenceScope>>>>> {
public:
  // The weight is an adress that definitely missed the cache and is persistent
  // for a set of scopes
  typedef std::pair<
      std::set<PersistenceScope>,
      std::set<std::pair<AbstractAddress, std::set<PersistenceScope>>>>
      WeightType;

  /**
   * Constructor. Call parent constructor with appropriate parameters.
   */
  StateGraphCacheMissProvider(
      MuStateGraph<MuState> *stgr,
      const std::function<const dom::cache::AbstractCache *(
          const typename MuState::LocalMetrics &)>
          extractCache,
      const std::function<boost::optional<AbstractAddress>(
          const typename MuState::LocalMetrics &)>
          getJustMissed,
      const std::function<boost::optional<std::set<PersistenceScope>>(
          const typename MuState::LocalMetrics &)>
          getJustEntered)
      : StateGraphEdgeWeightProvider<MuState, WeightType>(stgr),
        extractCache(extractCache), getJustMissed(getJustMissed),
        getJustEntered(getJustEntered) {}

  virtual ~StateGraphCacheMissProvider() {}

  /// See Superclass
  virtual bool isEdgeJoinable(unsigned p, unsigned t, unsigned nt) const;
  /// See Superclass
  virtual void addExternalEdge(std::string extfun, unsigned s, unsigned e);
  /// See Superclass
  virtual std::string getWeightDescr(unsigned a, unsigned b) const;

  std::map<PersistenceScope, std::map<AbstractAddress, VarCoeffVector>>
  getPerScopePersistenceEdges() const;
  /**
   * Use the collected cache miss information together with persistence
   * to generate additional constraints.
   */
  std::list<GraphConstraint> getPersistenceConstraints() const;

protected:
  typedef typename MuState::LocalMetrics LocalMetrics;

  virtual WeightType extractWeight(const LocalMetrics &metrics);

  virtual void joinWeight(WeightType &weight1, const WeightType &weight2);

  virtual void concatWeight(WeightType &weight1, const WeightType &weight2);

  virtual WeightType getNeutralWeight();

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

  const std::function<boost::optional<std::set<PersistenceScope>>(
      const LocalMetrics &)>
      getJustEntered;

  std::string printWeight(const WeightType &weight) const;
};

template <class MuState, CacheType CT>
typename StateGraphCacheMissProvider<MuState, CT>::WeightType
StateGraphCacheMissProvider<MuState, CT>::extractWeight(
    const LocalMetrics &metrics) {
  // We cannot decide locally to have a relevant miss, i.e. definite miss known
  // to be persistent,
  WeightType result;
  return result;
}

template <class MuState, CacheType CT>
bool StateGraphCacheMissProvider<MuState, CT>::isEdgeJoinable(
    unsigned p, unsigned t, unsigned nt) const {
  assert(this->edge2weight.count(std::make_pair(p, t)) > 0 &&
         this->edge2weight.count(std::make_pair(p, nt)) > 0 &&
         "Test non-existing edges to join");
  // We consider sets of definite misses only to be joinable if they are indeed
  // equal
  return this->edge2weight.at(std::make_pair(p, t)) ==
         this->edge2weight.at(std::make_pair(p, nt));
}

template <class MuState, CacheType CT>
void StateGraphCacheMissProvider<MuState, CT>::joinWeight(
    WeightType &weight1, const WeightType &weight2) {
  assert(weight1 == weight2 && "Cannot join unequal stuff here");
  // Do intersection
  /*for (auto it = weight1.begin(); it != weight1.end();) {
          if (weight2.count(*it) > 0) {
                  ++it;
          } else {
                  it = weight1.erase(it);
          }
  }*/
}

template <class MuState, CacheType CT>
void StateGraphCacheMissProvider<MuState, CT>::concatWeight(
    WeightType &weight1, const WeightType &weight2) {
  weight1.first.insert(weight2.first.begin(), weight2.first.end());
  weight1.second.insert(weight2.second.begin(), weight2.second.end());
}

template <class MuState, CacheType CT>
typename StateGraphCacheMissProvider<MuState, CT>::WeightType
StateGraphCacheMissProvider<MuState, CT>::getNeutralWeight() {
  // Return a empty set as neutral element
  WeightType result;
  return result;
}

template <class MuState, CacheType CT>
typename StateGraphCacheMissProvider<MuState, CT>::WeightType
StateGraphCacheMissProvider<MuState, CT>::advanceWeight(
    const WeightType &weight, const LocalMetrics &curr,
    const LocalMetrics &succ) {
  // Add a miss if possible
  WeightType result(weight);
  auto justMissed = getJustMissed(succ);
  auto currCache = extractCache(curr);
  auto justEntered = getJustEntered(succ);

  /* assert that the command-line linesize option is actually the linesize
   * used by the cache. */
  assert(CT == CacheType::INSTRUCTION ||
         currCache->alignToCacheline(~0) == ~(Dlinesize - 1));
  if (justMissed) { // If we just missed an element
    AbstractAddress address = justMissed.get();
    // Get the scopes in which address is persistent
    auto persScopes = currCache->getPersistentScopes(address);
    if (!persScopes.empty()) {
      result.second.insert(std::make_pair(address, persScopes));
    }
  }
  if (justEntered) {
    auto &scopes = justEntered.get();
    result.first.insert(scopes.begin(), scopes.end());
  }
  return result;
}

template <class MuState, CacheType CT>
void StateGraphCacheMissProvider<MuState, CT>::addExternalEdge(
    std::string extfun, unsigned s, unsigned e) {
  WeightType weight; // Only empty set for external function
  this->edge2weight.insert(std::make_pair(std::make_pair(s, e), weight));
}

template <class MuState, CacheType CT>
std::string
StateGraphCacheMissProvider<MuState, CT>::getWeightDescr(unsigned a,
                                                         unsigned b) const {
  std::stringstream res;
  res << "Ent. Sc./Pers. Misses: ";
  if (this->edge2weight.count(std::make_pair(a, b)) > 0) {
    res << printWeight(this->edge2weight.at(std::make_pair(a, b)));
  } else {
    res << "{}/{}";
  }
  return res.str();
}

template <class MuState, CacheType CT>
std::string StateGraphCacheMissProvider<MuState, CT>::printWeight(
    const WeightType &weight) const {
  std::stringstream res;
  res << "{";
  bool emitComma = false;
  for (auto &scope : weight.first) {
    if (emitComma)
      res << ", ";
    res << scope.getId();
    emitComma = true;
  }
  res << "}/{";
  emitComma = false;
  for (auto it = weight.second.begin(); it != weight.second.end(); ++it) {
    if (emitComma)
      res << ", ";
    res << it->first;
    res << " (";
    bool emitSpace = false;
    for (auto scit = it->second.begin(); scit != it->second.end(); ++scit) {
      if (emitSpace)
        res << " ";
      res << scit->getId();
    }
    res << ")";
    emitComma = true;
  }
  res << "}";
  return res.str();
}

/* Returns the address->persistent edges mapping for each persistence scope */
template <class MuState, CacheType CT>
std::map<PersistenceScope, std::map<AbstractAddress, VarCoeffVector>>
StateGraphCacheMissProvider<MuState, CT>::getPerScopePersistenceEdges() const {
  std::map<PersistenceScope, std::map<AbstractAddress, VarCoeffVector>>
      scope2addr2edges;
  std::map<PersistenceScope, std::map<const GlobalVariable *, VarCoeffVector>>
      scope2array2edges;
  std::map<PersistenceScope, VarCoeffVector> scope2enteredges;

  // Iterate over all graph edges an collect the definite miss edges
  // Sort them by PersistenceScope and Address.
  auto &graph = this->stgr->getGraph();
  for (auto &vtPair : graph.getVertices()) {
    unsigned vertexId = vtPair.first;
    if (vertexId == 0)
      continue; // Skip special edge
    for (auto &succVertexId : vtPair.second.getSuccessors()) {
      if (succVertexId == 0)
        continue; // Skip special edge
      auto edge = std::make_pair(vertexId, succVertexId);
      if (this->edge2weight.count(edge) > 0) {
        auto weight = this->edge2weight.at(edge);
        auto edgeTimesTakenVar =
            Variable::getEdgeVar(Variable::Type::timesTaken, edge);
        for (auto &scope : weight.first) {
          scope2enteredges[scope].push_back(
              std::make_pair(edgeTimesTakenVar, -1.0));
        }
        for (auto &addr2scopes : weight.second) {
          /* note that the addresses are cache-aligned */
          AbstractAddress addr = addr2scopes.first;
          for (auto &scope : addr2scopes.second) {
            LLVM_DEBUG(std::cerr << "Adding edge (" << edge.first << ", "
                                 << edge.second << ") for address " << addr;
                       std::cerr << " in scope " << scope.getId() << "\n";);
            auto varCoeff = std::make_pair(edgeTimesTakenVar, 1.0);
            if (addr.isArray()) {
              scope2array2edges[scope][addr.getArray()].push_back(varCoeff);
            } else {
              assert(addr.isPrecise());
              scope2addr2edges[scope][addr].push_back(varCoeff);
            }
          }
        }
      }
    }
  }

  /* Add all per-element constraints to the array constraints */
  for (auto &scope2x : scope2array2edges) {
    for (auto &array2edges : scope2x.second) {
      /* align the array address to cache lines.
       * TODO There should be a better way to do this than
       * using the command-line option */
      Address base =
          StaticAddrProvider->getGlobalVarAddress(array2edges.first) &
          ~(Dlinesize - 1);
      Address end =
          (base + StaticAddrProvider->getArraySize(array2edges.first)) &
          ~(Dlinesize - 1);
      for (auto &addr2edges : scope2addr2edges[scope2x.first]) {
        assert(addr2edges.first.isPrecise());
        Address addr = addr2edges.first.getAsInterval().lower();
        if (addr < base || addr > end) {
          continue;
        }

        VarCoeffVector &vcv = array2edges.second;
        vcv.insert(vcv.end(), addr2edges.second.begin(),
                   addr2edges.second.end());
      }
    }
  }

  /* Insert the per-array constraints into the concrete block constraints list
   */
  for (auto &scope2x : scope2array2edges) {
    for (auto &array2edges : scope2x.second) {
      scope2addr2edges[scope2x.first][AbstractAddress(array2edges.first)] =
          array2edges.second;
    }
  }

  // Subtract all enter edges them from the sum of definite-miss edges.
  for (auto &scope2varcoeff : scope2enteredges) {
    auto &persScope = scope2varcoeff.first;
    VarCoeffVector varCoeffVec = scope2varcoeff.second; // Copy

    for (auto &addr2edges : scope2addr2edges[persScope]) {
      auto addrItv = addr2edges.first.getAsInterval();
      unsigned linesize = (CT == CacheType::DATA) ? Dlinesize : Ilinesize;
      unsigned distance = (addrItv.upper() & ~(linesize - 1)) -
                          (addrItv.lower() & ~(linesize - 1));
      assert(distance % linesize == 0);
      unsigned width = distance / linesize + 1;
      scaleVarCoeffVector(varCoeffVec, width);
      addr2edges.second.insert(addr2edges.second.end(), varCoeffVec.begin(),
                               varCoeffVec.end());
    }
  }

  return scope2addr2edges;
}

template <class MuState, CacheType CT>
std::list<GraphConstraint>
StateGraphCacheMissProvider<MuState, CT>::getPersistenceConstraints() const {
  std::map<PersistenceScope, std::map<AbstractAddress, VarCoeffVector>>
      scope2addr2edges;

  scope2addr2edges = std::move(getPerScopePersistenceEdges());

  std::list<GraphConstraint> constraints;
  // Third step: sum of persistent and definite miss edges - sum of entry edges
  // should be <= 0.
  for (auto &scope2x : scope2addr2edges) {
    for (auto &addr2edges : scope2x.second) {
      GraphConstraint persConstr =
          std::make_tuple(addr2edges.second, ConstraintType::LessEqual, 0);
      constraints.push_back(persConstr);
    }
  }

  auto &ar = AnalysisResults::getInstance();
  std::string ident("PersistenceConstraints");
  ident += CT == CacheType::INSTRUCTION ? "Instr" : "Data";
  ident += "Cache";
  if (!ar.hasResult(ident)) {
    ar.registerResult(ident, constraints.size());
  }

  return constraints;
}

} // namespace TimingAnalysisPass
#undef DEBUG_TYPE
#endif
