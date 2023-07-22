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

#ifndef STATEGRAPHDFSPROVIDER_H
#define STATEGRAPHDFSPROVIDER_H

#include "Memory/AbstractCache.h"
#include "Memory/PersistenceScopeInfo.h"
#include "PathAnalysis/StateGraphEdgeWeightProvider.h"
#include "Util/Util.h"

#include <set>

#define DEBUG_TYPE "persconstr"
namespace TimingAnalysisPass {

#define WEIGHT_TYPE std::multimap<AbstractAddress, std::set<PersistenceScope>>
/**
 * Provides cache miss information as edge weight in the stategraph.
 * This information can later be used to obtain the objective function or to
 * formulate constraints.
 */
template <class MuState>
class StateGraphDirtifyingStoreProvider
    : public StateGraphEdgeWeightProvider<MuState, WEIGHT_TYPE> {
public:
  // The weight is an adress that definitely missed the cache and is persistent
  // for a set of scopes
  typedef WEIGHT_TYPE WeightType;
#undef WEIGHT_TYPE

  /**
   * Constructor. Call parent constructor with appropriate parameters.
   */
  StateGraphDirtifyingStoreProvider(
      MuStateGraph<MuState> *stgr,
      const std::function<const dom::cache::AbstractCache *(
          const typename MuState::LocalMetrics &)>
          extractCache,
      const std::function<boost::optional<AbstractAddress>(
          const typename MuState::LocalMetrics &)>
          getJustDirtified)
      : StateGraphEdgeWeightProvider<MuState, WeightType>(stgr),
        extractCache(extractCache), getJustDirtified(getJustDirtified) {}

  virtual ~StateGraphDirtifyingStoreProvider() {}

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
  std::list<GraphConstraint> getPersistentDFSConstraints() const;

  virtual VarCoeffVector getEdgeWeightTimesTakenVector();

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
      getJustDirtified;

  std::string printWeight(const WeightType &weight) const;
};

template <class MuState>
typename StateGraphDirtifyingStoreProvider<MuState>::WeightType
StateGraphDirtifyingStoreProvider<MuState>::extractWeight(
    const LocalMetrics &metrics) {
  // We cannot decide this locally
  WeightType result;
  return result;
}

template <class MuState>
bool StateGraphDirtifyingStoreProvider<MuState>::isEdgeJoinable(
    unsigned p, unsigned t, unsigned nt) const {
  assert(this->edge2weight.count(std::make_pair(p, t)) > 0 &&
         this->edge2weight.count(std::make_pair(p, nt)) > 0 &&
         "Test non-existing edges to join");
  // We consider sets of dirtifying stores only to be joinable if they are
  // indeed equal
  return this->edge2weight.at(std::make_pair(p, t)) ==
         this->edge2weight.at(std::make_pair(p, nt));
}

template <class MuState>
void StateGraphDirtifyingStoreProvider<MuState>::joinWeight(
    WeightType &weight1, const WeightType &weight2) {
  assert(weight1 == weight2 && "Cannot join unequal stuff here");
}

template <class MuState>
void StateGraphDirtifyingStoreProvider<MuState>::concatWeight(
    WeightType &weight1, const WeightType &weight2) {
  for (auto addr2scopeset : weight2) {
    weight1.insert(addr2scopeset);
  }
}

template <class MuState>
typename StateGraphDirtifyingStoreProvider<MuState>::WeightType
StateGraphDirtifyingStoreProvider<MuState>::getNeutralWeight() {
  // Return a empty set as neutral element
  WeightType result;
  return result;
}

template <class MuState>
typename StateGraphDirtifyingStoreProvider<MuState>::WeightType
StateGraphDirtifyingStoreProvider<MuState>::advanceWeight(
    const WeightType &weight, const LocalMetrics &curr,
    const LocalMetrics &succ) {
  // Add a miss if possible
  WeightType result(weight);
  auto justDirtified = getJustDirtified(succ);
  auto currCache = extractCache(curr);

  /* assert that the command-line linesize option is actually the linesize
   * used by the cache. */
  assert(currCache->alignToCacheline(~0) == ~(Dlinesize - 1));
  if (justDirtified) {
    AbstractAddress address = justDirtified.get();
    std::set<PersistenceScope> persScopes;
    // Get the scopes in which address is persistent
    if (address.isPrecise() || address.isArray()) {
      persScopes = currCache->getPersistentScopes(address);
    }
    result.insert(std::make_pair(address, persScopes));
  }
  return result;
}

template <class MuState>
void StateGraphDirtifyingStoreProvider<MuState>::addExternalEdge(
    std::string extfun, unsigned s, unsigned e) {
  WeightType weight; // Only empty set for external function
  this->edge2weight.insert(std::make_pair(std::make_pair(s, e), weight));
}

template <class MuState>
std::string
StateGraphDirtifyingStoreProvider<MuState>::getWeightDescr(unsigned a,
                                                           unsigned b) const {
  std::stringstream res;
  res << "Dirtifying stores: ";
  if (this->edge2weight.count(std::make_pair(a, b)) > 0) {
    res << printWeight(this->edge2weight.at(std::make_pair(a, b)));
  } else {
    res << "{}";
  }
  return res.str();
}

template <class MuState>
std::string StateGraphDirtifyingStoreProvider<MuState>::printWeight(
    const WeightType &weight) const {
  std::stringstream res;
  res << "{";
  bool emitComma = false;
  for (auto it = weight.begin(); it != weight.end(); ++it) {
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
template <class MuState>
std::map<PersistenceScope, std::map<AbstractAddress, VarCoeffVector>>
StateGraphDirtifyingStoreProvider<MuState>::getPerScopePersistenceEdges()
    const {
  std::map<PersistenceScope, std::map<AbstractAddress, VarCoeffVector>>
      scope2addr2edges;
  std::map<PersistenceScope, std::map<const GlobalVariable *, VarCoeffVector>>
      scope2array2edges;

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
        for (auto &addr2scopes : weight) {
          /* note that the addresses are cache-aligned */
          AbstractAddress addr = addr2scopes.first;
          for (auto &scope : addr2scopes.second) {
            LLVM_DEBUG(std::cerr << "[DFS]Adding edge (" << edge.first << ", "
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

  return scope2addr2edges;
}

template <class MuState>
std::list<GraphConstraint>
StateGraphDirtifyingStoreProvider<MuState>::getPersistentDFSConstraints()
    const {
  std::map<PersistenceScope, std::map<AbstractAddress, VarCoeffVector>>
      scope2addr2edges;

  scope2addr2edges = std::move(getPerScopePersistenceEdges());

  auto &graph = this->stgr->getGraph();
  // Find all state->state edges that enter a persistence scope.
  // Subtract them from the sum of definite-miss edges.
  for (auto &persScope :
       PersistenceScopeInfo::getInfo().getAllPersistenceScopes()) {
    assert(persScope.getEntryBasicBlocks().size() == 1 &&
           "For the moment a scope should have one entry block");
    for (auto entryBB : persScope.getEntryBasicBlocks()) {
      // If the loop (i.e. the header) is not reachable at all, we do not need
      // any constraints here
      if (this->stgr->getInStates(entryBB).size() == 0) {
        break;
      }
      std::set<unsigned> outStatesWithinScope;
      std::set<unsigned> outStatesOutsideScope;
      for (auto predBB : getNonEmptyPredecessorBasicBlocks(entryBB)) {
        if (entryBB->getParent() == predBB->getParent()) {
          auto outStates = this->stgr->getOutStates(predBB);
          assert(outStates.size() > 0 && "Non empty BB should have out states");
          if (persScope.containsBasicBlock(predBB)) {
            outStatesWithinScope.insert(outStates.begin(), outStates.end());
          } else {
            outStatesOutsideScope.insert(outStates.begin(), outStates.end());
          }
        } else {
          CallGraph &cg = CallGraph::getGraph();
          for (auto cs : cg.getCallSitesInMBB(predBB)) {
            const auto &potCallees = cg.getPotentialCallees(cs);
            if (std::find(potCallees.begin(), potCallees.end(),
                          entryBB->getParent()) != potCallees.end()) {
              auto callStates = this->stgr->getCallStates(cs);
              outStatesOutsideScope.insert(callStates.begin(),
                                           callStates.end());
            }
          }
        }
      }

      for (unsigned inState : this->stgr->getInStates(entryBB)) {
        for (auto predState : graph.getPredecessors(inState)) {
          if (outStatesOutsideScope.count(predState) > 0) {
            auto edge = std::make_pair(predState, inState);
            auto edgeTimesTakenVar =
                Variable::getEdgeVar(Variable::Type::timesTaken, edge);
            for (auto &addr2edges : scope2addr2edges[persScope]) {
              auto varCoeff = std::make_pair(edgeTimesTakenVar, -1.0);
              auto addrItv = addr2edges.first.getAsInterval();
              unsigned distance = (addrItv.upper() & ~(Dlinesize - 1)) -
                                  (addrItv.lower() & ~(Dlinesize - 1));
              assert(distance % Dlinesize == 0);
              unsigned width = distance / Dlinesize + 1;
              varCoeff.second *= width;
              addr2edges.second.push_back(varCoeff);
            }
          } else {
            assert(outStatesWithinScope.count(predState) > 0 &&
                   "Predecessor state not in in pred basic block");
          }
        }
      }
    }
  }

  std::list<GraphConstraint> constraints;
  // Third step: sum of persistent DFS edges - sum of entry edges should be <=
  // 0.
  for (auto &scope2x : scope2addr2edges) {
    for (auto &addr2edges : scope2x.second) {
      GraphConstraint persConstr =
          std::make_tuple(addr2edges.second, ConstraintType::LessEqual, 0);
      constraints.push_back(persConstr);
    }
  }

  auto &ar = AnalysisResults::getInstance();
  std::string ident("PersistentDFSConstraints");
  if (!ar.hasResult(ident)) {
    ar.registerResult(ident, constraints.size());
  }

  return constraints;
}

template <class MuState>
VarCoeffVector
StateGraphDirtifyingStoreProvider<MuState>::getEdgeWeightTimesTakenVector() {
  VarCoeffVector result;
  for (auto e2t : this->edge2weight) {
    auto edge = e2t.first;
    auto weight = e2t.second;

    if (weight.size() == 0) {
      continue;
    }
    auto edgeTimesTakenVar =
        Variable::getEdgeVar(Variable::Type::timesTaken, edge);
    result.push_back(std::make_pair(edgeTimesTakenVar, weight.size()));
  }
  return result;
}

} // namespace TimingAnalysisPass
#undef DEBUG_TYPE
#endif
