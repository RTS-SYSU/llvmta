////////////////////////////////////////////////////////////////////////////////
//
//   LLVMTA - Timing Analyser performing worst-case execution time analysis
//     using the LLVM backend intermediate representation
//
// Copyright (C) 2013-2022  Saarland University
// Copyright (C) 2016			 Tina Jung
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

#ifndef GRAPHITERTAOR_H
#define GRAPHITERTAOR_H

#include <queue>

#include "Memory/AbstractCache.h"
#include "Memory/CacheTraits.h"
#include "Memory/LruMinAgeAbstractCache.h"
#include "Memory/crpd/EvictingCacheBlocks.h"
#include "PathAnalysis/StateGraphAddressProvider.h"
#include "boost/range/adaptor/reversed.hpp"

#define DEBUG_TYPE "graphit"
// Use a set as the worklist datastructure in the fixpoint iteration (queue
// if UseQueue is defined)
// Set: No duplicates, more chaotic iteration
// Queue: FIFO and therefore possibly less iterations, no duplicate check (or
//				expensive one)
//#define UseQueue

namespace TimingAnalysisPass {

/**
 * \tparam CacheType The cache type the graph iterator should work on. The
 *         interface of AbstractCacheImpl needs to be implemented by the given
 *         cache.
 *
 * \brief Provides methods to apply analyses on a program graph taking edge
 *        weights into account.
 */
template <class CacheType> class GraphIterator {

  /*	BOOST_STATIC_ASSERT((boost::is_base_of<
                          dom::cache::AbstractCacheImpl<typename
     CacheType::Traits, typename CacheType::SetType>, CacheType>::value));*/

public:
  using PP = unsigned;
  using SetWiseAnaDeps = typename CacheType::SetWiseAnaDeps;
  using AdditionalInfo = std::map<PP, SetWiseAnaDeps *>;

  GraphIterator(
      const Graph &SimpleGraph,
      const EdgeWeightProvider<std::vector<AbstractAddress>> *Provider)
      : SimpleGraph(SimpleGraph), Provider(Provider) {}

  /**
   * \brief Update the given cache once for each annotated edge.
   *
   * \param Analysis The cache that should be updated with the edge effects.
   *
   * Does not take control flow into account and returns an accumulated result
   * for the whole graph.
   */
  void runSimpleAccumulatedEdgeEffectAnalysis(CacheType &Analysis) const;

  /**
   * \brief Apply updates with the given edge weights on the abstract cache and
   *        apply a fixpoint iteration.
   * \param AddInfo Additional information for the update function that is
   *        program point sensitive.
   * \param Apply the analysis contrary to the edge direction.
   * \return Information for every cache set at every program point.
   */
  auto runFixpointAnalysis(const AdditionalInfo *AddInfo,
                           bool backwards = false) const
      -> std::unique_ptr<std::map<unsigned, CacheType>>;

private:
  const Graph &SimpleGraph;
  const EdgeWeightProvider<std::vector<AbstractAddress>> *Provider;

public:
  ~GraphIterator();
  GraphIterator(GraphIterator &&) = delete;
  GraphIterator(const GraphIterator &) = delete;
};

template <class CacheType>
void GraphIterator<CacheType>::runSimpleAccumulatedEdgeEffectAnalysis(
    CacheType &Analysis) const {

  // Iterate over the graph and update with address weigths
  auto Vertices = SimpleGraph.getVertices();

  // For every vertex all outgoing edges need to be considered once
  for (const auto &kv : Vertices) {
    auto &Node = kv.first;
    const auto &V = kv.second;
    const auto &Succ = V.getSuccessors();
    for (auto S : Succ) {
      LLVM_DEBUG(std::cout << "Current Edge " << Node << " to " << S << "\n";);

      if (Provider->hasWeight(Node, S)) {
        auto Addresses = Provider->getWeight(Node, S);
        LLVM_DEBUG(if (Addresses.size() == 0) std::cout << "No Access.\n";);
        for (auto A : Addresses) {
          /* FIXME: This is only correct for instruction caches.
           * For data caches we need to expose the accessType in
           * the graph and extract it here */
          Analysis.update(A, AccessType::LOAD, nullptr);
        }
      } else {
        LLVM_DEBUG(std::cout << "Does not have a weight.\n";);
      }
    }
  }
}

template <class CacheType>
auto GraphIterator<CacheType>::runFixpointAnalysis(
    const AdditionalInfo *AddInfo, bool backwards) const
    -> std::unique_ptr<std::map<unsigned, CacheType>> {

  LLVM_DEBUG(std::cout << "Applying Fixpoint Analysis. Additional Info null: "
                       << (AddInfo ? "true" : "false") << std::endl;);

  // Contains cache state for every node
  std::unique_ptr<std::map<unsigned, CacheType>> CacheStates(
      new std::map<unsigned, CacheType>);

#ifdef UseQueue
  std::queue<unsigned, std::deque<unsigned>> Worklist;
#else
  std::set<unsigned> Worklist;
#endif

  // Start with the initial node "0" (has successors which are the actual start
  // states and predecessors are the end states)

#ifdef UseQueue
  Worklist.push(0);
#else
  Worklist.insert(0);
#endif

  auto CInit = new CacheType(true);
  CacheStates->insert(std::make_pair(0, CInit));

  // Process the worklist. It contains elements whose predecessors have changed
  // and therefore need to be considered again.
  while (!Worklist.empty()) {

#ifdef UseQueue
    unsigned Next = Worklist.front();
#else
    unsigned Next = *Worklist.begin();
#endif

    LLVM_DEBUG(std::cout << "Working on element: " << Next << std::endl;);

// Remove next from the queue
#ifdef UseQueue
    Worklist.pop();
#else
    Worklist.erase(Worklist.begin());
#endif

    std::set<unsigned> AdjacentNodes;
    if (backwards) {
      AdjacentNodes = SimpleGraph.getPredecessors(Next);
    } else {
      AdjacentNodes = SimpleGraph.getSuccessors(Next);
    }

    for (auto N : AdjacentNodes) {

      LLVM_DEBUG(std::cout << "Neighbor:	" << N << std::endl;);

      // If 0 is the successor we have reached the end (or beginning) of the
      // program again
      if (N == 0)
        continue;

      // Use the cache information from the current node
      CacheType Cache = CacheStates->at(Next);

      if (Provider->hasWeight(backwards ? N : Next, backwards ? Next : N)) {
        auto Addresses =
            Provider->getWeight(backwards ? N : Next, backwards ? Next : N);

        // Currently the information for N should be updated, so use N's
        // additional info
        SetWiseAnaDeps *Info = nullptr;
        if (AddInfo) {
          Info = AddInfo->at(N);
          assert(Info);
        }

        // Apply the updates of the edge
        /* FIXME: this does not work for data caches
         * because they might store!
         * Extract the accessType out of the graph */
        if (backwards) {
          for (const auto &A : boost::adaptors::reverse(Addresses)) {
            Cache.update(A, AccessType::LOAD, Info);
          }
        } else {
          for (const auto &A : Addresses) {
            Cache.update(A, AccessType::LOAD, Info);
          }
        }
      }

      // Add the computed information if we haven't visited the node yet
      if (CacheStates->find(N) == CacheStates->end()) {
        (*CacheStates)[N] = Cache;
#ifdef UseQueue
        Worklist.push(N);
#else
        Worklist.insert(N);
#endif

        LLVM_DEBUG(std::cout << "First visit\n";
                   std::cout << "Stored information: " << Cache << std::endl;);
        continue;
      }

      LLVM_DEBUG(std::cout << "Compare: "; Cache.dump(std::cout);
                 std::cout << "\nand\n"; CacheStates->at(N).dump(std::cout);
                 std::cout << std::endl;);

      // Check if the information changed
      if (!Cache.equals(CacheStates->at(N))) {

        LLVM_DEBUG(std::cout << "Change\n";);

        // Update cache info
        (*CacheStates)[N].join(Cache);

        LLVM_DEBUG(std::cout << "Change result: ";
                   CacheStates->at(N).dump(std::cout); std::cout << std::endl;);

// Queue it to ensure the update of the neighbors with the new information
#ifdef UseQueue
        Worklist.push(N);
#else
        Worklist.insert(N);
#endif

      } else {
        LLVM_DEBUG(std::cout << "No Change\n";);
      }
    }
  }

  return std::move(CacheStates);
}

template <class CacheType> GraphIterator<CacheType>::~GraphIterator() {}
} // namespace TimingAnalysisPass
#undef DEBUG_TYPE
#endif // GRAPHITERATOR_H
