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

#ifndef LRUMAXAGEARRAYANALYSIS_H_
#define LRUMAXAGEARRAYANALYSIS_H_

#include <algorithm>
#include <ostream>

#include "Memory/ArrayAwareMustAges.h"
#include "Memory/Classification.h"
#include "Memory/progana/Lattice.h"
#include "Memory/util/CacheUtils.h"
#include "Memory/util/ImplicitSet.h"

#include "Util/PersistenceScope.h"

namespace TimingAnalysisPass {

namespace dom {
namespace cache {

/**
 * \tparam T Cache traits
 *
 * \brief   Implements a must analysis for an LRU cache set.
 */
template <CacheTraits *T>
class LruMaxAgeArrayAwareCache : public progana::JoinSemiLattice {
  typedef LruMaxAgeArrayAwareCache<T> Self;

public:
  unsigned ASSOCIATIVITY = T->ASSOCIATIVITY;
  const CacheTraits *CacheConfig = T;

protected:
  typedef typename CacheTraits::WayType WayType;
  typedef typename CacheTraits::TagType TagType;
  typedef typename CacheTraits::PosType PosType;

  std::map<TagType, std::unique_ptr<MustAge<T>>> ages;

public:
  using AnaDeps = std::tuple<>;

  explicit LruMaxAgeArrayAwareCache(bool assumeAnEmptyCache = false);
  LruMaxAgeArrayAwareCache(const Self &other) {
    for (const auto &entry : other.ages) {
      this->ages.emplace(entry.first, entry.second->clone());
    }
  }
  Self &operator=(const Self &other) {
    this->ages.clear();
    for (const auto &entry : other.ages) {
      this->ages.emplace(entry.first, entry.second->clone());
    }
    return *this;
  }

  Classification classify(const AbstractAddress addr) const;

  LruMaxAgeUpdateReport<TagType> *
  update(const AbstractAddress addr, AccessType load_store, AnaDeps *,
         bool wantReport = false, const Classification assumption = CL_UNKNOWN);
  LruMaxAgeUpdateReport<TagType> *potentialUpdate(AbstractAddress addr,
                                                  AccessType load_store,
                                                  bool wantReport = false);

  void join(const Self &y);
  bool lessequal(const Self &y) const;
  void enterScope(const PersistenceScope &) {}
  void leaveScope(const PersistenceScope &) {}
  std::set<PersistenceScope> getPersistentScopes(const TagType tag) const {
    return std::set<PersistenceScope>();
  }
  std::set<PersistenceScope>
  getPersistentScopes(const GlobalVariable *var) const {
    return std::set<PersistenceScope>();
  }
  bool operator==(const Self &y) const;
  bool operator<(const Self &y) const;
  std::ostream &dump(std::ostream &os) const;

  unsigned getMaxAge(const TagType tag) const;
};

///\see dom::cache::CacheSetAnalysis<T>::CacheSetAnalysis(bool
///assumeAnEmptyCache)
template <CacheTraits *T>
inline LruMaxAgeArrayAwareCache<T>::LruMaxAgeArrayAwareCache(
    bool assumeAnEmptyCache __attribute__((unused))) {}

///\see dom::cache::CacheSetAnalysis<T>::classify(const TagType tag) const
template <CacheTraits *T>
Classification
LruMaxAgeArrayAwareCache<T>::classify(const AbstractAddress addr) const {
  TagType tag = getTag<T>(addr);
  unsigned size = ages.size();
  assert(size <= ASSOCIATIVITY);

  if (ages.count(tag)) {
    return CL_HIT;
  }
  /* if the MUST cache is full we can prove misses */
  return size == ASSOCIATIVITY ? CL_MISS : CL_UNKNOWN;
}

template <CacheTraits *T>
LruMaxAgeUpdateReport<typename CacheTraits::TagType> *
LruMaxAgeArrayAwareCache<T>::potentialUpdate(AbstractAddress addr,
                                             AccessType load_store,
                                             bool wantReport) {
  LruMaxAgeUpdateReport<TagType> *report = nullptr;
  if (wantReport)
    report = new LruMaxAgeUpdateReport<TagType>;

  const GlobalVariable *arr = addr.getArray();

  /* age all elements */
  auto it = ages.begin();
  while (it != ages.end()) {
    /* give names to the entries to improve readability */
    const TagType tag = it->first;
    std::unique_ptr<MustAge<T>> &age = it->second;

    if (arr) {
      age->ageBy(arr);
    } else {
      age->ageBy(1);
    }

    if (age->isAssociativity()) {
      if (wantReport) {
        report->evictedElements.insert(tag);
      }
      it = ages.erase(it);
    } else {
      ++it;
    }
  }

  return report;
}

///\see dom::cache::CacheSetAnalysis<T>::update(const TagType tag, const
///Classification assumption)
template <CacheTraits *T>
LruMaxAgeUpdateReport<typename CacheTraits::TagType> *
LruMaxAgeArrayAwareCache<T>::update(const AbstractAddress addr,
                                    AccessType load_store, AnaDeps *,
                                    bool wantReport,
                                    const Classification assumption) {
  TagType tag = getTag<T>(addr);

  LruMaxAgeUpdateReport<TagType> *report = nullptr;
  if (wantReport)
    report = new LruMaxAgeUpdateReport<TagType>;

  auto entry = ages.find(tag);
  PosType accessedAge;
  if (entry != ages.end()) {
    accessedAge = entry->second->getAge();
  } else if (assumption == CL_HIT) {
    accessedAge = ASSOCIATIVITY - 1;
  } else {
    accessedAge = ASSOCIATIVITY;
  }

  /* Now age all entries that are younger than accessedAge */

  auto it = ages.begin();
  while (it != ages.end()) {
    /* give names to the entries to improve readability */
    const TagType tag = it->first;
    std::unique_ptr<MustAge<T>> &age = it->second;

    if (age->getAge() >= accessedAge) {
      ++it;
      continue;
    }
    age->ageBy(1);
    if (age->isAssociativity()) {
      if (wantReport) {
        report->evictedElements.insert(tag);
      }
      it = ages.erase(it);
    } else {
      ++it;
    }
  }

  /* the accessed element is completely reset */
  /* tblass: possible future optimization: if addr is part of array A we might
   * start with an initial conflict set of {A} */
  ages[tag] = MustAge<T>::make();

  return report;
}

///\see dom::cache::CacheSetAnalysis<T>::join(const Self& y)
template <CacheTraits *T>
void LruMaxAgeArrayAwareCache<T>::join(const Self &y) {
  auto xit = ages.begin();
  auto yit = y.ages.begin();
  while (xit != ages.end() && yit != y.ages.end()) {
    if (xit->first < yit->first) {
      xit = ages.erase(xit);
      continue;
    }
    if (xit->first > yit->first) {
      yit++;
      continue;
    }

    xit->second->join(*yit->second);
    /* with conflict union, joining might evict an
     * element from the cache */
    if (xit->second->isAssociativity()) {
      xit = ages.erase(xit);
      continue;
    }
    xit++;
  }
  while (xit != ages.end()) {
    xit = ages.erase(xit);
  }
}

template <CacheTraits *T>
inline bool LruMaxAgeArrayAwareCache<T>::lessequal(const Self &y) const {
  /* TODO this is probably inefficient */
  Self copy(*this);
  copy.join(y);
  return copy == y;
}

///\see dom::cache::CacheSetAnalysis<T>::operator==(const Self& y) const
template <CacheTraits *T>
inline bool LruMaxAgeArrayAwareCache<T>::operator==(const Self &y) const {
  /* Since we have to compare the *dereferenced* values we cannot use
     the equality operation on the map itself. Do it by hand instead */
  auto xit = ages.cbegin();
  auto yit = y.ages.cbegin();

  while (xit != ages.cend() && yit != y.ages.cend()) {
    if (xit->first != yit->first) {
      return false;
    }

    if (!(*xit->second == *yit->second)) {
      return false;
    }
    ++xit;
    ++yit;
  }
  return xit == ages.cend() && yit == y.ages.cend();
}

///\see dom::cache::CacheSetAnalysis<T>::operator<(const Self& y) const
template <CacheTraits *T>
inline bool LruMaxAgeArrayAwareCache<T>::operator<(const Self &y) const {
  /* Since we have to compare the *dereferenced* values we cannot use
     the < operation on the map itself. Do it by hand instead */
  auto xIt = ages.cbegin();
  auto yIt = y.ages.cbegin();

  while (xIt != ages.cend() && yIt != y.ages.cend()) {
    if (xIt->first != yIt->first) {
      return xIt->first < yIt->first;
    }
    if (!(*xIt->second == *yIt->second)) {
      return *xIt->second < *yIt->second;
    }

    xIt++;
    yIt++;
  }
  /* if yIt is not at the end ages was shorter that y.ages */
  return yIt != y.ages.cend();
}

///\see dom::cache::CacheSetAnalysis<T>::dump(std::ostream& os) const
template <CacheTraits *T>
std::ostream &LruMaxAgeArrayAwareCache<T>::dump(std::ostream &os) const {
  os << "[";
  for (const auto &entry : ages) {
    printHex(os, entry.first);
    os << " -> ";
    entry.second->dump(os);
    os << ", ";
  }
  os << "]";

  return os;
}

///\see std::ostream& operator<<(std::ostream& os, const CacheSetAnalysis<T>& x)
template <CacheTraits *T>
inline std::ostream &operator<<(std::ostream &os,
                                const LruMaxAgeArrayAwareCache<T> &x) {
  return x.dump(os);
}

/**
 * Returns an upper bound on the age of \c tag
 */
template <CacheTraits *T>
unsigned LruMaxAgeArrayAwareCache<T>::getMaxAge(const TagType tag) const {
  auto it = ages.find(tag);
  if (it != ages.end()) {
    return it->second->getAge();
  }
  return ASSOCIATIVITY; // TODO Should this return \infty?
}

} // namespace cache
} // namespace dom

} // namespace TimingAnalysisPass

#endif /*LRUMAXAGEANALYSIS_H_*/
