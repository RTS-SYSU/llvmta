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

#ifndef CACHERELATEDPREEMPTIONDELAY_H
#define CACHERELATEDPREEMPTIONDELAY_H

#include <ostream>

#include "llvm/Support/Debug.h"

#include "Memory/AbstractCache.h"
#include "Memory/CacheTraits.h"
#include "Memory/LruMaxAgeAbstractCache.h"
#include "Memory/LruMinAgeAbstractCache.h"
#include "Memory/crpd/ConstrainedAges.h"
#include "PathAnalysis/EdgeWeightProvider.h"

namespace TimingAnalysisPass {

/**
 * \tparam CacheConfig Cache traits
 *
 * \brief Provides methods for cache related preemption delay analyses.
 */

template <dom::cache::CacheTraits *CacheConfig>
class CacheRelatedPreemptionDelay {

protected:
  using TagType = typename dom::cache::CacheTraits::TagType;

  const unsigned N_SETS = CacheConfig->N_SETS;
  const unsigned ASSOCIATIVITY = CacheConfig->ASSOCIATIVITY;

public:
  /**
   * Program point
   */
  using PP = unsigned;

  /**
   * Type for evicting cache blocks per cache set
   */
  using ECBInfo = std::vector<unsigned>;
  using UCBInfo = std::vector<unsigned>;

  CacheRelatedPreemptionDelay(
      const Graph &SimpleGraph,
      const EdgeWeightProvider<std::vector<AbstractAddress>> *Provider)
      : SimpleGraph(SimpleGraph), Provider(Provider) {
    assert(Provider);
  }

  /**
   * \brief Computes the cost of the additional cache misses caused by a
   *        preempting task.
   *
   * \param ECBs Number of additional cache accesses per cache set made by a
   *        preempting task
   * \param CRT Cache reload time
   */
  auto runResilienceAnalysis(const ECBInfo &ECBs, unsigned CRT = 1) const
      -> unsigned;

  /**
   * \brief Computes the number of Useful Cache Blocks per set
   *
   * The UCB includes at most ASSOCIATIVITY-many cache blcoks for a cache
   * set.
   */
  auto computeUCBsPerSet() const -> UCBInfo;
  auto computeDCUCBsPerSet() const -> UCBInfo;

  /**
   * \brief Computes the number of cache blocks per set that may be replaced
   * when the given program is the preempting task.
   *
   * The ECB includes at most ASSOCIATIVITY-many cache blocks for a cache set.
   */
  auto computeECBsPerSet() const -> ECBInfo;

  /**
   * \brief Computes the number of cache blocks that may be replaced
   * when the given program is the preempting task.
   *
   */
  auto computeECBs() const -> unsigned;

  /**
   * Useful cache blocks of the program (PP and set insensitive).
   */
  using UsefulBlocks = ImplicitSet<TagType>;

  /**
   * Cache set sensitive information type for UCBs
   */
  using UCBsSetWise = std::vector<UsefulBlocks>;

  /**
   * Program point and cache set sensitive information type for UCBs
   */
  using UCBsPerPP = std::map<PP, UCBsSetWise>;

  /**
   * \brief Compute the useful cache blocks per program point using
   * the edge weights given by the provider for the graph.
   *
   * The useful cache blocks are computed by first applying a may analysis
   * on the graph, once with the edge direction and once against the edge
   * direction. Cache blocks that are contained in both may-caches at a program
   * point are considered useful at this point.
   *
   */
  auto computeUCBsPerPP() const -> UCBsPerPP;
  auto computeDCUCBsPerPP() const -> UCBsPerPP;

  /**
   * \brief Compute the useful cache blocks per cache set.
   *
   * First compute a program point sensitive information, then summarize the
   * results to only cache set sensitive information by assuming that all
   * cache blocks useful that have been useful at some program point.
   *
   */
  auto computeUCBsSetWise() const -> UCBsSetWise;

  /**
   * \brief Compute the useful cache blocks of the program.
   *
   */
  auto computeUCBs() const -> UsefulBlocks;

  /**
   * Program point and cache set sensitive information type for Resilience
   */
  using ResInfo = std::map<PP, std::vector<std::map<TagType, unsigned>>>;

  /**
   * \brief Computes program point sensitive resilience information
   *
   * \param UCBs The useful cache blocks for the task (per PP + cache set).
   *
   */
  auto computeResiliencePerPP(const UCBsPerPP &UCBs) const -> ResInfo;

  /**
   * \brief Computes cache set sensitive resilience information, the minimal
   *        resilience of a block over all program points.
   *
   * \param UCBs The useful cache blocks for the task (per PP + cache set).
   *
   */
  auto computeResiliencePerSet(const UCBsPerPP &UCBs) const
      -> std::vector<std::map<TagType, unsigned>>;

  /**
   * \brief Computes a map that contains all blocks for a resilience
   *
   * \param UCBs The useful cache blocks for the task (per PP + cache set).
   *
   */
  auto computeTagsForResilience(const UCBsPerPP &UCBs) const
      -> std::map<unsigned, ImplicitSet<TagType>>;

  /**
   * \brief Adds the UCB count provided to the Analysis Results for later
   * dumping
   *
   * \param UCBs The number of UCBs per set
   *
   */
  void dumpUCBs(UCBInfo UCBs, std::string prefix = "UCB") const;

  /**
   * \brief Computes ECB information per cache set and dumps them into the file
   *        with the given name. Generates a CSV file.
   *
   * \param filename The file to write the information into.
   * \param ECBs The number of ECBs per set
   *
   */
  void dumpECBs(std::string filename, ECBInfo ECBs) const;

  /**
   * \brief Reads ECB information out of a CSV file. Reads exactly N_SETS many
   *        ecbs (more are ignored, less cause an abort).
   *
   * \param filename The file to read.
   *
   */
  auto readECBs(std::string filename) const -> ECBInfo;

  ~CacheRelatedPreemptionDelay() {}

private:
  // Min and Max age analysis types for a single set
  using LRUMinAge = dom::cache::LruMinAgeAbstractCache<CacheConfig>;
  using LRUMaxAge = dom::cache::LruMaxAgeAbstractCache<CacheConfig>;

  // Min and Max age analysis types for multiple sets
  using LRUMay = dom::cache::AbstractCacheImpl<CacheConfig, LRUMinAge>;
  using LRUMust = dom::cache::AbstractCacheImpl<CacheConfig, LRUMaxAge>;

  // Constrained age analysis type
  using ConstrainedAgeType =
      dom::cache::AbstractCacheImpl<CacheConfig,
                                    dom::cache::ConstrainedAges<CacheConfig>>;

  /**
   * SimpleGraph The graph of the program under analysis.
   */
  const Graph &SimpleGraph;

  /**
   * Describes address accesses on the edges of the given graph
   */
  const EdgeWeightProvider<std::vector<AbstractAddress>> *Provider;

  /**
   * \brief Computes Must LRU Cache information for every program point.
   * \param backwards Indicates whether the cache analysis should be applied
   *        backwards on the graph.
   * \return LRU Must Cache information per program point.
   */
  auto computeUnconstrainedAges(bool backwards) const
      -> std::unique_ptr<std::map<unsigned, LRUMust>>;

  /**
   * \brief Computes constrained ages for every program point.
   *
   * \param UCBs The useful cache blocks for the task (per PP + cache set).
   * \param backwards Indicates whether the cache analysis should be applied
   *        backwards on the graph.
   * \param UnconstrainedAges Must information for cache content.
   *
   */
  auto computeConstrainedAges(
      const UCBsPerPP &UCBs, bool backwards,
      std::unique_ptr<std::map<unsigned, LRUMust>> UnconstrainedAges) const
      -> std::unique_ptr<std::map<unsigned, ConstrainedAgeType>>;

  /**
   * \brief Computes all elements that occur in both sets.
   */
  auto computeCommonElements(const LRUMay &, const LRUMay &) const
      -> std::vector<ImplicitSet<TagType>>;
};

} // namespace TimingAnalysisPass

#endif /*CACHERELATEDPREEMPTIONDELAY_H*/
