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

#ifndef DCUSEFULCACHEBLOCKS_H
#define DCUSEFULCACHEBLOCKS_H

#include <ostream>

#include "llvm/Support/Debug.h"

#include "Memory/CacheTraits.h"
#include "Memory/Classification.h"
#include "Memory/progana/Lattice.h"
#include "Util/PersistenceScope.h"
#include "Util/Util.h"

namespace TimingAnalysisPass {

namespace dom {
namespace cache {

/**
 * \tparam T Cache traits
 *
 * \brief Implements a simple analysis that collects all accessed blocks.
 */
template <CacheTraits *T>
class DCUsefulCacheBlocks : public progana::JoinSemiLattice {
  typedef DCUsefulCacheBlocks<T> Self;

protected:
  unsigned ASSOCIATIVITY = T->ASSOCIATIVITY;

  typedef typename CacheTraits::WayType WayType;
  typedef typename CacheTraits::TagType TagType;
  typedef typename CacheTraits::PosType PosType;

  /**
   * Contains tags seen in the update.
   */
  std::set<TagType> accessedTags;

public:
  /* Implement the interface */
  explicit DCUsefulCacheBlocks(bool assumeAnEmptyCache = false);

  using LruMust = LruMaxAgeAbstractCache<T>;
  using AnaDeps = std::tuple<const LruMust &>;

  auto classify(const AbstractAddress addr) const -> Classification;
  UpdateReport *update(const AbstractAddress addr, AccessType load_store,
                       AnaDeps *deps = nullptr, bool wantReport = false,
                       const Classification assumption = CL_UNKNOWN);
  UpdateReport *potentialUpdate(AbstractAddress addr, AccessType load_store,
                                bool wantReport = false);
  void join(const Self &y);
  bool lessequal(const Self &y) const;
  void enterScope(const PersistenceScope &) {}
  void leaveScope(const PersistenceScope &) {}
  auto getPersistentScopes(const Address addr) const
      -> std::set<PersistenceScope>;
  auto getPersistentScopes(const GlobalVariable *var) const
      -> std::set<PersistenceScope>;
  bool operator==(const Self &y) const;
  bool operator<(const Self &y) const;
  std::ostream &dump(std::ostream &os) const;
  ImplicitSet<TagType> getDCUsefulBlocks() const;
};

/**
 * \see dom::cache::CacheSetAnalysis<T>::CacheSetAnalysis(bool
 * assumeAnEmptyCache)
 */
template <CacheTraits *T>
inline DCUsefulCacheBlocks<T>::DCUsefulCacheBlocks(bool) : accessedTags() {}
/**
 * \see  dom::cache::CacheSetAnalysis<T>::classify(const TagType tag) const
 */
template <CacheTraits *T>
Classification DCUsefulCacheBlocks<T>::classify(const AbstractAddress) const {
  return CL_UNKNOWN; // Not the use case for this analysis
}

/**
 * \brief Simulates an update to an unknown cache element, increase the age of
 * all elements
 */
template <CacheTraits *T>
UpdateReport *DCUsefulCacheBlocks<T>::potentialUpdate(AbstractAddress addr,
                                                      AccessType load_store,
                                                      bool wantReport) {
  assert(0 && "DC useful does not support imprecise updates");
  return nullptr;
}

/**
 * \see dom::cache::CacheSetAnalysis<T>::update(const TagType tag, const
 * Classification assumption)
 */
template <CacheTraits *T>
UpdateReport *DCUsefulCacheBlocks<T>::update(const AbstractAddress addr,
                                             AccessType load_store,
                                             AnaDeps *AddInfo, bool wantReport,
                                             const Classification) {
  assert(AddInfo);
  const auto &MustCache =
      std::get<0>(*AddInfo).getTagsWithMaxMaxAge(ASSOCIATIVITY - 1);

  TagType tag = getTag<T>(addr);

  DEBUG_WITH_TYPE("dcucb", dbgs() << "Update with Address " << tag << "\n";);

  UpdateReport *report = wantReport ? new UpdateReport : nullptr;

  // Add
  accessedTags.insert(tag);
  // Intersect with must cache
  for (auto it = accessedTags.begin(); it != accessedTags.end();) {
    if (MustCache.count(*it) > 0) {
      ++it;
    } else {
      it = accessedTags.erase(it);
    }
  }

  return report;
}

/**
 * \see dom::cache::CacheSetAnalysis<T>::join(const Self& y)
 */
template <CacheTraits *T> void DCUsefulCacheBlocks<T>::join(const Self &y) {
  // Union
  this->accessedTags.insert(y.accessedTags.begin(), y.accessedTags.end());
}

template <CacheTraits *T>
inline bool DCUsefulCacheBlocks<T>::lessequal(const Self &y) const {
  // set inclusion
  return std::includes(y.accessedTags.begin(), y.accessedTags.end(),
                       this->accessedTags.begin(), this->accessedTags.end());
}

template <CacheTraits *T>
auto DCUsefulCacheBlocks<T>::getPersistentScopes(const Address) const
    -> std::set<PersistenceScope> {
  return {};
}

template <CacheTraits *T>
auto DCUsefulCacheBlocks<T>::getPersistentScopes(
    const GlobalVariable *var) const -> std::set<PersistenceScope> {
  return {};
}

/**
 * \see dom::cache::CacheSetAnalysis<T>::operator==(const Self& y) const
 */
template <CacheTraits *T>
inline bool DCUsefulCacheBlocks<T>::operator==(const Self &y) const {
  return this->accessedTags.size() == y.accessedTags.size() &&
         std::equal(this->accessedTags.begin(), this->accessedTags.end(),
                    y.accessedTags.begin());
}

/**
 * \see dom::cache::CacheSetAnalysis<T>::operator<(const Self& y) const
 */
template <CacheTraits *T>
inline bool DCUsefulCacheBlocks<T>::operator<(const Self &y) const {
  if (this->accessedTags.size() != y.accessedTags.size())
    return this->accessedTags.size() < y.accessedTags.size();

  auto it1 = this->accessedTags.begin();
  auto it2 = y.accessedTags.begin();
  for (; it1 != this->accessedTags.end(); ++it1, ++it2) {
    if (*it1 != *it2) {
      return *it1 < *it2;
    }
  }

  return false;
}

/**
 * \see dom::cache::CacheSetAnalysis<T>::dump(std::ostream& os) const
 */
template <CacheTraits *T>
std::ostream &DCUsefulCacheBlocks<T>::dump(std::ostream &os) const {
  os << "{";
  bool emitComma = false;
  for (int tag : this->accessedTags) {
    if (emitComma)
      os << ", ";
    os << tag;
    emitComma = true;
  }
  os << "}";

  return os;
}

template <CacheTraits *T>
ImplicitSet<typename CacheTraits::TagType>
DCUsefulCacheBlocks<T>::getDCUsefulBlocks() const {
  ImplicitSet<TagType> res(this->accessedTags);
  return res;
}

/**
 * \see std::ostream& operator<<(std::ostream& os, const CacheSetAnalysis<T>& x)
 */
template <CacheTraits *T>
inline std::ostream &operator<<(std::ostream &os,
                                const DCUsefulCacheBlocks<T> &x) {
  return x.dump(os);
}

} // namespace cache
} // namespace dom

} // namespace TimingAnalysisPass

#endif /*DCUSEFULCACHEBLOCKS_H*/
