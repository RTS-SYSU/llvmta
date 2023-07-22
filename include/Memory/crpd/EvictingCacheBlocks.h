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

#ifndef EVICTINGCACHEBLOCKS_H
#define EVICTINGCACHEBLOCKS_H

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
class EvictingCacheBlocks : public progana::JoinSemiLattice {
  typedef EvictingCacheBlocks<T> Self;

protected:
  unsigned ASSOCIATIVITY = T->ASSOCIATIVITY;

  typedef typename CacheTraits::WayType WayType;
  typedef typename CacheTraits::TagType TagType;
  typedef typename CacheTraits::PosType PosType;

  /**
   * If top is set we were not able to compute the accessed tags.
   */
  bool top;
  /**
   * Contains tags seen in the update.
   */
  std::set<TagType> accessedTags;

public:
  /* Implement the interface */
  explicit EvictingCacheBlocks(bool assumeAnEmptyCache = false);

  using AnaDeps = std::tuple<>;

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

  /* ECB specific functions */

  /**
   * \brief Returns true if there may have been more than ASSOCIATIVITY many
   * accesses to this cache set.
   */
  bool isTop() const;

  /**
   * \brief Returns the tags that were accessed in this set, if the information
   * is not top.
   */
  auto getAccessedTags() const -> std::set<TagType>;
};

/**
 * \see dom::cache::CacheSetAnalysis<T>::CacheSetAnalysis(bool
 * assumeAnEmptyCache)
 */
template <CacheTraits *T>
inline EvictingCacheBlocks<T>::EvictingCacheBlocks(bool)
    : top(false), accessedTags() {}
/**
 * \see  dom::cache::CacheSetAnalysis<T>::classify(const TagType tag) const
 */
template <CacheTraits *T>
Classification EvictingCacheBlocks<T>::classify(const AbstractAddress) const {
  return CL_UNKNOWN; // Not the use case for this analysis
}

/**
 * \brief Simulates an update to an unknown cache element, increase the age of
 * all elements
 */
template <CacheTraits *T>
UpdateReport *EvictingCacheBlocks<T>::potentialUpdate(AbstractAddress addr,
                                                      AccessType load_store,
                                                      bool wantReport) {

  DEBUG_WITH_TYPE("ecb", dbgs() << "Update Unknown\n";);
  top = true;
  accessedTags.clear();
  return wantReport ? new UpdateReport : nullptr;
}

/**
 * \see dom::cache::CacheSetAnalysis<T>::update(const TagType tag, const
 * Classification assumption)
 */
template <CacheTraits *T>
UpdateReport *EvictingCacheBlocks<T>::update(const AbstractAddress addr,
                                             AccessType load_store, AnaDeps *,
                                             bool wantReport,
                                             const Classification) {
  TagType tag = getTag<T>(addr);

  DEBUG_WITH_TYPE("ecb", dbgs() << "Update with Address " << tag << "\n";);

  UpdateReport *report = wantReport ? new UpdateReport : nullptr;

  if (top)
    return report;
  accessedTags.insert(tag);
  if (accessedTags.size() > ASSOCIATIVITY) {
    top = true;
    accessedTags.clear();
  }
  return report;
}

/**
 * \see dom::cache::CacheSetAnalysis<T>::join(const Self& y)
 */
template <CacheTraits *T> void EvictingCacheBlocks<T>::join(const Self &y) {
  this->top |= y.top;
  this->accessedTags.insert(y.accessedTags.begin(), y.accessedTags.end());
}

template <CacheTraits *T>
inline bool EvictingCacheBlocks<T>::lessequal(const Self &y) const {
  if (y.top) // y is top
    return true;
  if (this->top) // self ist top, y is not top
    return false;
  // Both not top
  return std::includes(y.accessedTags.begin(), y.accessedTags.end(),
                       this->accessedTags.begin(), this->accessedTags.end());
}

template <CacheTraits *T>
auto EvictingCacheBlocks<T>::getPersistentScopes(const Address) const
    -> std::set<PersistenceScope> {
  return {};
}

template <CacheTraits *T>
auto EvictingCacheBlocks<T>::getPersistentScopes(
    const GlobalVariable *var) const -> std::set<PersistenceScope> {
  return {};
}

/**
 * \see dom::cache::CacheSetAnalysis<T>::operator==(const Self& y) const
 */
template <CacheTraits *T>
inline bool EvictingCacheBlocks<T>::operator==(const Self &y) const {
  return this->top == y.top &&
         this->accessedTags.size() == y.accessedTags.size() &&
         std::equal(this->accessedTags.begin(), this->accessedTags.end(),
                    y.accessedTags.begin());
}

/**
 * \see dom::cache::CacheSetAnalysis<T>::operator<(const Self& y) const
 */
template <CacheTraits *T>
inline bool EvictingCacheBlocks<T>::operator<(const Self &y) const {
  if (this->top != y.top)
    return !this->top & y.top;

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
std::ostream &EvictingCacheBlocks<T>::dump(std::ostream &os) const {
  if (this->top) {
    os << "T";
  } else {
    os << "{";
    bool emitComma = false;
    for (int tag : this->accessedTags) {
      if (emitComma)
        os << ", ";
      os << tag;
      emitComma = true;
    }
    os << "}";
  }
  return os;
}

/**
 * \see std::ostream& operator<<(std::ostream& os, const CacheSetAnalysis<T>& x)
 */
template <CacheTraits *T>
inline std::ostream &operator<<(std::ostream &os,
                                const EvictingCacheBlocks<T> &x) {
  return x.dump(os);
}

template <CacheTraits *T> bool EvictingCacheBlocks<T>::isTop() const {
  return top;
}

template <CacheTraits *T>
auto EvictingCacheBlocks<T>::getAccessedTags() const -> std::set<TagType> {
  assert(!isTop());
  return accessedTags;
}

} // namespace cache
} // namespace dom

} // namespace TimingAnalysisPass

#endif /*EVICTINGCACHEBLOCKS_H*/
