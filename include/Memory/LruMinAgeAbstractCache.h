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

#ifndef LRUMINAGEANALYSIS_H_
#define LRUMINAGEANALYSIS_H_

#include <algorithm>
#include <limits>
#include <ostream>
#include <set>
#include <vector>

#include "Memory/CacheTraits.h"
#include "Memory/Classification.h"
#include "Memory/UpdateReports.h"
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
 * \brief   Implements a may analysis for an LRU cache set.
 */
template <CacheTraits *T>
class LruMinAgeAbstractCache : public progana::JoinSemiLattice {
  typedef LruMinAgeAbstractCache<T> Self;

protected:
  typedef typename CacheTraits::WayType WayType;
  typedef typename CacheTraits::TagType TagType;
  typedef typename CacheTraits::PosType PosType;

  struct MayInfo {
    unsigned tag : CacheTraits::TAG_BITS;
    unsigned age : CacheTraits::WAY_BITS_DECL;

    bool operator==(const MayInfo &y) const {
      return tag == y.tag && age == y.age;
    }

    bool operator<(const MayInfo &y) const {
      return age < y.age || (age == y.age && tag < y.tag);
    }
  };
  typedef typename std::vector<MayInfo>::const_iterator ConstIterType;

  // Elements in the vector are sorted.
  // First by age, ascendingly. Then by tag, ascendingly.
  std::vector<MayInfo> explicitTags;
  PosType ageOfImplicitTags;

  void removeRedundantTags();

public:
  using AnaDeps = std::tuple<>;

  explicit LruMinAgeAbstractCache(bool assumeAnEmptyCache = false);
  Classification classify(const AbstractAddress addr) const;

  LruMinAgeUpdateReport<TagType> *
  update(const AbstractAddress addr, AccessType load_store, AnaDeps *,
         bool wantReport = false, const Classification assumption = CL_UNKNOWN);
  LruMinAgeUpdateReport<TagType> *potentialUpdate(AbstractAddress addr,
                                                  AccessType load_store,
                                                  bool wantReport = false);

  void join(const Self &y);
  bool lessequal(const Self &y) const;
  void enterScope(const PersistenceScope &) {}
  void leaveScope(const PersistenceScope &) {}
  std::set<PersistenceScope> getPersistentScopes(const TagType tag) const {
    return std::set<PersistenceScope>();
  }
  std::set<PersistenceScope> getPersistentScopes(const GlobalVariable *) const {
    return std::set<PersistenceScope>();
  }
  bool operator==(const Self &y) const;
  bool operator<(const Self &y) const;
  std::ostream &dump(std::ostream &os) const;

  unsigned getMinAge(const TagType tag) const;
  ImplicitSet<TagType> getTagsWithMaxMinAge(int minAge) const;
  unsigned getNTagsWithMaxMinAge(int minAge) const;
};

///\see dom::cache::CacheSetAnalysis<T>::CacheSetAnalysis(bool
///assumeAnEmptyCache)
template <CacheTraits *T>
inline LruMinAgeAbstractCache<T>::LruMinAgeAbstractCache(
    bool assumeAnEmptyCache)
    : explicitTags(),
      ageOfImplicitTags(assumeAnEmptyCache ? T->ASSOCIATIVITY : 0) {}

///\see dom::cache::CacheSetAnalysis<T>::classify(const TagType tag) const
template <CacheTraits *T>
Classification
LruMinAgeAbstractCache<T>::classify(const AbstractAddress addr) const {
  TagType tag = getTag<T>(addr);
  if (ageOfImplicitTags < T->ASSOCIATIVITY)
    return CL_UNKNOWN;

  for (unsigned i = 0; i < explicitTags.size(); ++i)
    if (explicitTags[i].tag == tag)
      return CL_UNKNOWN;

  return CL_MISS;
}

template <CacheTraits *T>
void LruMinAgeAbstractCache<T>::removeRedundantTags() {
  int size = explicitTags.size();
  while (size > 0 && explicitTags[size - 1].age >= ageOfImplicitTags)
    --size;
  explicitTags.resize(size);
}

///\see dom::cache::CacheSetAnalysis<T>::update(const TagType tag, const
///Classification assumption)
template <CacheTraits *T>
LruMinAgeUpdateReport<typename CacheTraits::TagType> *
LruMinAgeAbstractCache<T>::update(const AbstractAddress addr,
                                  AccessType load_store, AnaDeps *,
                                  bool wantReport,
                                  const Classification assumption
                                  __attribute__((unused))) {
  TagType tag = getTag<T>(addr);
  int size = explicitTags.size();
  LruMinAgeUpdateReport<TagType> *report = nullptr;

  if (wantReport) {
    report = new LruMinAgeUpdateReport<TagType>;
    report->justEvictedUnknowns = false;
    report->justIntroducedUnknowns = false;
  }

  // Search element
  int pos;
  for (pos = 0; pos < size; ++pos)
    if (explicitTags[pos].tag == tag)
      break;

  bool found = pos != size && size > 0;
  PosType accessedAge = found ? explicitTags[pos].age : ageOfImplicitTags;

  // 1. Update implicitly modelled elements
  if (ageOfImplicitTags <= accessedAge &&
      ageOfImplicitTags < T->ASSOCIATIVITY) {
    ++ageOfImplicitTags;
    if (wantReport)
      report->justEvictedUnknowns = ageOfImplicitTags == T->ASSOCIATIVITY;
  }

  // 2. Update explicitly modelled elements
  int simpleUpdatePos;

  // a1) Not found in explicitTags or found at age ASSOC-1
  if (!found || (found && accessedAge == T->ASSOCIATIVITY - 1)) {
    // Determine new size
    while (size - 1 >= 0 &&
           explicitTags[size - 1].age == T->ASSOCIATIVITY - 1) {
      if (wantReport && pos != size - 1 &&
          ageOfImplicitTags == T->ASSOCIATIVITY) {
        report->evictedElements.insert(explicitTags[size - 1].tag);
      }
      --size;
    }
    ++size;

    explicitTags.resize(size);
    simpleUpdatePos = size - 1;
  }
  // a2) Found at other ages
  else {

    // Age elements with same age, which are left of the accessed element
    int i = pos - 1;
    while (i >= 0 && explicitTags[i].age == accessedAge) {
      explicitTags[i + 1].tag = explicitTags[i].tag;
      explicitTags[i + 1].age = accessedAge + 1;
      --i;
    }
    int lowerDelimiter = i + 1;

    // Age elements with same age, which are right of the accessed element
    i = pos + 1;
    while (i < size && explicitTags[i].age == accessedAge) {
      explicitTags[i].age = accessedAge + 1;
      ++i;
    }
    int upperDelimiter = i - 1;

    // Merge elements in the interval (lowerDelimiter, upperDelimiter] with the
    // tag set of age (accessedAge+1)
    for (int i = upperDelimiter; i > lowerDelimiter; --i) {
      unsigned currentTag = explicitTags[i].tag;

      // move current tag to correct position, shifting the others in between
      int p = i;
      while (p < size - 1 && explicitTags[p + 1].age <= accessedAge + 1 &&
             explicitTags[p + 1].tag < currentTag) {
        explicitTags[p].tag = explicitTags[p + 1].tag;
        ++p;
      }
      explicitTags[p].tag = currentTag;
    }

    simpleUpdatePos = lowerDelimiter;
  }

  // b) Update ages of, and shift remaining elements by one to the right
  for (int i = simpleUpdatePos; i > 0; --i) {
    explicitTags[i].tag = explicitTags[i - 1].tag;
    explicitTags[i].age = explicitTags[i - 1].age + 1;
  }

  // c) Insert accessed element at the front
  explicitTags[0].tag = tag;
  explicitTags[0].age = 0;
  removeRedundantTags();
  return report;
}

template <CacheTraits *T>
LruMinAgeUpdateReport<typename CacheTraits::TagType> *
LruMinAgeAbstractCache<T>::potentialUpdate(AbstractAddress addr,
                                           AccessType load_store,
                                           bool wantReport) {
  LruMinAgeUpdateReport<TagType> *report = nullptr;

  if (ageOfImplicitTags == 0) {
    /* already at top */
    assert(explicitTags.empty());
    return wantReport ? new LruMinAgeUpdateReport<TagType> : nullptr;
  }

  /* arbitary constant, might need to be tweaked.
   * How many tags may an address interval span before we just give up and go
   * to top? */
  const unsigned maxWorthwhileTags = 4;

  auto itv = addr.getAsInterval();
  TagType lowTag = getTag<T>(itv.lower());
  TagType highTag = getTag<T>(itv.upper());
  unsigned numTags = highTag - lowTag + 1;

  if (numTags > maxWorthwhileTags) {
    // Any element might be at front position now
    // Remove content of explicitTags, and set ageOfImplicitTags to 0
    ageOfImplicitTags = 0;

    if (wantReport) {
      report = new LruMinAgeUpdateReport<TagType>;
      report->justIntroducedUnknowns = true;
      /* we cannot evict any element */
    }

    explicitTags.resize(0);
    return report;
  }

  /* We must not age any element, because the cache might not change at
   * all. Set all potentially reached elements to zero and leave all the
   * rest */
  std::vector<MayInfo> newTags;
  newTags.reserve(explicitTags.size() + numTags);

  bool inserted = false;
  for (MayInfo info : explicitTags) {
    if (!inserted && (info.age > 0 || info.tag >= lowTag)) {
      for (TagType t = lowTag; t <= highTag; t++) {
        newTags.push_back(MayInfo{t, 0});
      }
      inserted = true;
    }

    if (info.tag < lowTag || info.tag > highTag) {
      /* only copy elements not in the datastructure */
      newTags.push_back(info);
    }
  }
  if (!inserted) {
    for (TagType t = lowTag; t <= highTag; t++) {
      newTags.push_back(MayInfo{t, 0});
    }
  }
  explicitTags = std::move(newTags);
  return wantReport ? new LruMinAgeUpdateReport<TagType> : nullptr;
}

///\see dom::cache::CacheSetAnalysis<T>::join(const Self& y)
template <CacheTraits *T> void LruMinAgeAbstractCache<T>::join(const Self &y) {
  // 1. Join implicitly modeled elements
  ageOfImplicitTags = std::min(ageOfImplicitTags, y.ageOfImplicitTags);

  // 2. Join explicitly modeled elements
  // Elements are sorted by age. Hence we can directly construct a
  // sorted output by visiting _all_ elements (of both inputs) in ascending
  // order.
  ConstIterType xBegin = explicitTags.begin();
  ConstIterType yBegin = y.explicitTags.begin();
  ConstIterType xIt = xBegin;
  ConstIterType yIt = yBegin;
  ConstIterType xEnd = explicitTags.end();
  ConstIterType yEnd = y.explicitTags.end();

  std::vector<MayInfo> res;
  std::set<TagType> processed;
  while (xIt != xEnd || yIt != yEnd) {
    // Which element is the lesser?
    bool xElemIsLesser =
        (xIt != xEnd) && (yIt == yEnd || xIt->age < yIt->age ||
                          (xIt->age == yIt->age && xIt->tag <= yIt->tag));

#if 0
		ConstIterType& lesser = xElemIsLesser ? xIt : yIt;

		if (processed.insert(lesser->tag).second)
			res.push_back(*lesser);

		++lesser;

#else
    // Determine what and where to search
    ConstIterType first;
    ConstIterType last;
    ConstIterType joined;

    if (xElemIsLesser) {
      joined = xIt;
      first = yIt;
      last = yBegin;
      ++xIt;
    } else {
      joined = yIt;
      first = xIt;
      last = xBegin;
      ++yIt;
    }

    // Search backwards within [last, first). If the tag is not found,
    // we have not seen it before. Hence add it to output.
    // a) Empty interval
    if (first == last) {
      res.push_back(*joined);
      continue;
    }

    // b) Real search
    do {
      --first;
    } while (first != last && first->tag != joined->tag);

    if (first->tag != joined->tag)
      res.push_back(*joined);
#endif
  }

  // Move result to member variable
  swap(explicitTags, res);
  explicitTags.resize(explicitTags.size());
  removeRedundantTags();
}

template <CacheTraits *T>
inline bool LruMinAgeAbstractCache<T>::lessequal(const Self &y) const {
  Self copy(*this);
  copy.join(y);
  return copy == y;
}

///\see dom::cache::CacheSetAnalysis<T>::operator==(const Self& y) const
template <CacheTraits *T>
inline bool LruMinAgeAbstractCache<T>::operator==(const Self &y) const {
  return ageOfImplicitTags == y.ageOfImplicitTags &&
         explicitTags == y.explicitTags;
}

///\see dom::cache::CacheSetAnalysis<T>::operator<(const Self& y) const
template <CacheTraits *T>
inline bool LruMinAgeAbstractCache<T>::operator<(const Self &y) const {
  return ageOfImplicitTags < y.ageOfImplicitTags ||
         (ageOfImplicitTags == y.ageOfImplicitTags &&
          explicitTags < y.explicitTags);
}

/////\see dom::cache::CacheSetAnalysis<T>::hash() const
// template <CacheTraits* T>
// std::size_t LruMinAgeAbstractCache<T>::hash() const
//{
//	std::size_t res = static_cast<std::size_t>(2166136261UL);
//	for (ConstIterType it = explicitTags.begin(); it != explicitTags.end();
//++it) { 		res ^= (it->tag << CacheTraits::WAY_BITS) | it->age; 		res *=
//static_cast<std::size_t>(16777619UL);
//	}
//	res += ageOfImplicitTags;
//	return res;
// }

///\see dom::cache::CacheSetAnalysis<T>::dump(std::ostream& os) const
template <CacheTraits *T>
std::ostream &LruMinAgeAbstractCache<T>::dump(std::ostream &os) const {
  unsigned pos = 0;

  os << "[";
  for (unsigned age = 0; age < T->ASSOCIATIVITY; ++age) {
    if (age != 0)
      os << ", ";

    os << "{";
    bool emitComma = false;
    if (ageOfImplicitTags == age) {
      os << "*";
      emitComma = true;
    }

    while (pos < explicitTags.size() && explicitTags[pos].age == age) {
      if (emitComma)
        os << ", ";
      printHex(os, explicitTags[pos].tag);
      ++pos;
      emitComma = true;
    }
    os << "}";
  }
  return os << "]";
}

///\see std::ostream& operator<<(std::ostream& os, const CacheSetAnalysis<T>& x)
template <CacheTraits *T>
inline std::ostream &operator<<(std::ostream &os,
                                const LruMinAgeAbstractCache<T> &x) {
  return x.dump(os);
}

/**
 * Returns a lower bound an the age of \c tag
 */
template <CacheTraits *T>
unsigned LruMinAgeAbstractCache<T>::getMinAge(const TagType tag) const {
  for (unsigned i = 0; i < explicitTags.size(); ++i)
    if (explicitTags[i].tag == tag)
      return explicitTags[i].age;
  return ageOfImplicitTags;
}

template <CacheTraits *T>
ImplicitSet<typename CacheTraits::TagType>
LruMinAgeAbstractCache<T>::getTagsWithMaxMinAge(int minAge) const {
  if (ageOfImplicitTags <= minAge)
    return ImplicitSet<TagType>(true);

  ImplicitSet<TagType> res;
  for (unsigned i = 0; i < explicitTags.size(); ++i) {
    if (explicitTags[i].age > minAge)
      break;
    res.insert(explicitTags[i].tag);
  }
  return res;
}

template <CacheTraits *T>
unsigned LruMinAgeAbstractCache<T>::getNTagsWithMaxMinAge(int minAge) const {
  if (ageOfImplicitTags <= minAge)
    return std::numeric_limits<unsigned>::max();

  unsigned res = 0;
  for (unsigned i = 0; i < explicitTags.size(); ++i) {
    if (explicitTags[i].age > minAge)
      break;
    ++res;
  }
  return res;
}

} // namespace cache
} // namespace dom

} // namespace TimingAnalysisPass

#endif /*LRUMINAGEANALYSIS_H_*/
