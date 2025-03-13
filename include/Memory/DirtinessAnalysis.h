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

#ifndef DIRTYNESS_ANALYSIS_H_
#define DIRTYNESS_ANALYSIS_H_

#include <algorithm>
#include <assert.h>
#include <iterator>
#include <ostream>

#include "Memory/Classification.h"
#include "Memory/DirtinessClassification.h"
#include "Memory/progana/Lattice.h"
#include "Memory/util/CacheSetAnalysisConcept.h"
#include "Memory/util/CacheUtils.h"

#define DEBUG_TYPE "dirtiness"
namespace TimingAnalysisPass {

namespace dom {
namespace cache {

/**
 * \tparam MayAna MAY cache analysis
 * \tparam MustAna MUST cache analysis
 *
 * \brief   Combines a MAY and a MUST cache analysis and uses them to compute
 * dirtiness information
 */
template <CacheTraits *T, class MustAna, class MayAna>
class DirtinessAnalysis : public progana::JoinSemiLattice {
  typedef DirtinessAnalysis<T, MustAna, MayAna> Self;

protected:
  typedef typename CacheTraits::TagType TagType;

  BOOST_CONCEPT_ASSERT((concepts::CacheSetAnalysis<MayAna>));
  BOOST_CONCEPT_ASSERT((concepts::CacheSetAnalysis<MustAna>));

  MustAna must;
  MayAna may;
  /* True if there was a store we were not able to map to specific blocks.
   * This means that any element we don't know anything about might be
   * dirty */
  bool implicitDirty;
  std::map<TagType, DirtinessClassification> dirtiness;

public:
  typedef std::tuple<> AnaDeps;

  explicit DirtinessAnalysis(bool assumeAnEmptyCache = false);
  Classification classify(const AbstractAddress addr) const;
  UpdateReport *update(const AbstractAddress addr, AccessType load_store,
                       AnaDeps *, bool wantReport = false,
                       const Classification assumption = CL_UNKNOWN);
  UpdateReport *potentialUpdate(AbstractAddress addr, AccessType load_store,
                                bool wantReport);
  void join(const Self &y);
  bool lessequal(const Self &y) const;
  void enterScope(const PersistenceScope &scope);
  void leaveScope(const PersistenceScope &scope);
  std::set<PersistenceScope> getPersistentScopes(const TagType tag) const;
  std::set<PersistenceScope> getPersistentScopes(const GlobalVariable *) const;
  bool operator==(const Self &y) const;
  bool operator<(const Self &y) const;
  std::ostream &dump(std::ostream &os) const;

private:
  void deleteDirtiness(DirtinessClassification todel) {
    auto it = dirtiness.begin();
    while (it != dirtiness.end()) {
      if (it->second == todel)
        it = dirtiness.erase(it);
      else
        ++it;
    }
  }

  /* Asserts certain (expensive) invariants */
  void checkInvariants() const {
    for (auto entry : dirtiness) {
      if (entry.second == DCL_DIRTY &&
          must.getMaxAge(entry.first) == T->ASSOCIATIVITY) {
        std::cerr << *this << "\n";
        std::cerr << "The above dirtiness state contains a dirty block that is "
                     "not guaranteed to be cached! This is impossible\n";
        abort();
      }
      if (entry.second != DCL_CLEAN &&
          may.getMinAge(entry.first) == T->ASSOCIATIVITY) {
        std::cerr << *this << "\n";
        std::cerr << "The above dirtiness state contains a block that cannot "
                     "be cached but is not clean anyway. This is impossible\n";
        abort();
      }
    }
  }
  /* returns true if there is an evict candidate (i.e. a tagline not in
   * the must-cache) that is not certainly clean. */
  bool existsDirtyVictim() const;
  void incorporateMustMayUpdates(LruMaxAgeUpdateReport<TagType> *mustReport,
                                 LruMinAgeUpdateReport<TagType> *mayReport);
};

/* assuming a clean cache is a reasonable and advisable condition.
 * Advisable: Without this assumption our analysis will probably not find
 * anything useful. Assuming the entire (unknown) cache might be dirty means
 * that we have to classify everything we load as "UNKNOWN" until we completely
 * know the cache(which probably never happens in real programs).
 *
 * Reasonable: Impact of existing dirty blocks can be bounded. TODO mention
 * paper */
template <CacheTraits *T, class MustAna, class MayAna>
inline DirtinessAnalysis<T, MustAna, MayAna>::DirtinessAnalysis(
    bool assumeAnEmptyCache)
    : must(assumeAnEmptyCache), may(assumeAnEmptyCache),
      implicitDirty(!AssumeCleanCache) {}

///\see dom::cache::CacheSetAnalysis<T>::classify(const TagType tag) const
template <CacheTraits *T, class MustAna, class MayAna>
Classification DirtinessAnalysis<T, MustAna, MayAna>::classify(
    const AbstractAddress addr) const {
  Classification cl = must.classify(addr);
  if (cl != CL_UNKNOWN)
    return cl;
  return may.classify(addr);
}

/* This function checks whether there is a dirty cacheline not in the must-cache
 */
template <CacheTraits *T, class MustAna, class MayAna>
bool DirtinessAnalysis<T, MustAna, MayAna>::existsDirtyVictim() const {
  if (implicitDirty) {
    return true;
  }
  /* check if any of our dirty elements might not be cached. This means
   * that it might have been written back just now */
  for (auto entry : dirtiness) {
    if (entry.second == DCL_CLEAN) {
      continue;
    }
    /* XXX in Daniel Grund's MUST implementation this is not
     * efficient. */
    if (must.getMaxAge(entry.first) == T->ASSOCIATIVITY) {
      return true;
    }
  }
  return false;
}

template <CacheTraits *T, class MustAna, class MayAna>
void DirtinessAnalysis<T, MustAna, MayAna>::incorporateMustMayUpdates(
    LruMaxAgeUpdateReport<typename CacheTraits::TagType> *mustReport,
    LruMinAgeUpdateReport<typename CacheTraits::TagType> *mayReport) {
  /* If we evicted the unknown element the target of the unknown store has
   * either left the cache or was refreshed in the meantime and is now in
   * our dirtiness map. */
  if (mayReport->justEvictedUnknowns) {
    implicitDirty = false;
    auto it = dirtiness.begin();
    while (it != dirtiness.end()) {
      if (it->second == DCL_CLEAN) {
        /* There is no reason to remember clean
         * elements. If another unknown store
         * happens it takes all the clean elements with it */
        it = dirtiness.erase(it);
        continue;
      }

      if (may.getMinAge(it->first) == T->ASSOCIATIVITY) {
        /* If the dirtiness analysis's maxWorthwhileTags
         * value is higher than the May analysis's, we
         * have to handle the eviction of the unknown
         * element "by hand" */
        it = dirtiness.erase(it);
        continue;
      }
      ++it;
    }
  }

  for (TagType evTag : mustReport->evictedElements) {
    if (dirtiness.count(evTag) && dirtiness.at(evTag) == DCL_DIRTY) {
      dirtiness.at(evTag) = DCL_UNKNOWN;
    }
  }

  /* Evicted elements are clean. if there is an implicitDirty roaming
   * around, remember this (else it's implicitly assumed anyway) */
  for (TagType evTag : mayReport->evictedElements) {
    if (implicitDirty) {
      assert(0 && "UNREACHABLE");
      dirtiness[evTag] = DCL_CLEAN;
    } else {
      dirtiness.erase(evTag);
    }
  }
}

///\see dom::cache::CacheSetAnalysis<T>::update(const TagType tag, const
///Classification assumption)
template <CacheTraits *T, class MustAna, class MayAna>
UpdateReport *DirtinessAnalysis<T, MustAna, MayAna>::update(
    const AbstractAddress addr, AccessType load_store, AnaDeps *deps,
    bool wantReport, const Classification assumption) {
  TagType tag = getTag<T>(addr);

  LLVM_DEBUG(checkInvariants());
  LLVM_DEBUG(std::cerr << load_store << " " << addr << "\n");

  /* track the accessed tag explicitly if we haven't yet */
  if (dirtiness.count(tag) == 0) {
    dirtiness[tag] = implicitDirty ? DCL_UNKNOWN : DCL_CLEAN;
  }

  /* A STORE turns the tag dirty. */
  bool dirtifyingStore = false;
  if (load_store == AccessType::STORE) {
    dirtifyingStore = dirtiness.at(tag) != DCL_DIRTY;
    dirtiness.at(tag) = DCL_DIRTY;
  }

  LruMaxAgeUpdateReport<TagType> *mustReport;
  LruMinAgeUpdateReport<TagType> *mayReport;

  mustReport = must.update(addr, load_store, deps, true, assumption);
  mayReport = may.update(addr, load_store, deps, true, assumption);

  LLVM_DEBUG(std::cerr << *mustReport << "\n" << *mayReport << "\n");
  bool canWriteback = existsDirtyVictim();

  incorporateMustMayUpdates(mustReport, mayReport);

  LLVM_DEBUG(checkInvariants());

  delete mustReport;
  delete mayReport;
  return wantReport ? new WritebackReport(canWriteback, dirtifyingStore)
                    : nullptr;
}

template <CacheTraits *T, class MustAna, class MayAna>
UpdateReport *DirtinessAnalysis<T, MustAna, MayAna>::potentialUpdate(
    AbstractAddress addr, AccessType load_store, bool wantReport) {

  LLVM_DEBUG(checkInvariants());
  LLVM_DEBUG(std::cerr << load_store << " " << addr << "\n");
  LruMaxAgeUpdateReport<TagType> *mustReport;
  LruMinAgeUpdateReport<TagType> *mayReport;

  mustReport = must.potentialUpdate(addr, load_store, true);
  mayReport = may.potentialUpdate(addr, load_store, true);

  LLVM_DEBUG(std::cerr << *mustReport << "\n" << *mayReport << "\n");

  bool canWriteback = existsDirtyVictim();
  incorporateMustMayUpdates(mustReport, mayReport);

  bool dirtifyingStore = false;

  auto itv = addr.getAsInterval();
  TagType lowTag = getTag<T>(itv.lower());
  TagType highTag = getTag<T>(itv.upper());
  unsigned numTags = highTag - lowTag + 1;
  /* arbitrary constant, might be tuned. */
  const unsigned maxWorthwhileTags = 4;

  if (numTags > maxWorthwhileTags) {
    if (!may.getTagsWithMaxMinAge(T->ASSOCIATIVITY - 1).containsAll()) {
      std::cerr << "[WARNING] Dirtiness Analysis gave up on finding the target "
                   "of the store while MAY tracks it - this makes no sense "
                   "(it's gonna be really hard to recover from this)\n";
    }

    if (load_store == AccessType::STORE) {
      implicitDirty = true;
      dirtifyingStore = true;
      /* Any formerly clean element might have been
       * overwritten by the store. Turn those elements
       * implicit */
      deleteDirtiness(DCL_CLEAN);
    }
  } else {
    /* perform a potential update for all tags. This is
     * identical to an update but just joins DCL_DIRTY to the
     * previous classification on store */
    for (TagType t = lowTag; t <= highTag; t++) {
      if (dirtiness.count(t) == 0) {
        dirtiness[t] = implicitDirty ? DCL_UNKNOWN : DCL_CLEAN;
      }
      if (load_store == AccessType::STORE) {
        dirtifyingStore |= dirtiness.at(t) != DCL_DIRTY;
        dirtiness.at(t).join(DCL_DIRTY);
      }
    }
  }

  LLVM_DEBUG(checkInvariants());
  delete mustReport;
  delete mayReport;
  return wantReport ? new WritebackReport(canWriteback, dirtifyingStore)
                    : nullptr;
}

///\see dom::cache::CacheSetAnalysis<T>::join(const Self& y)
template <CacheTraits *T, class MustAna, class MayAna>
inline void DirtinessAnalysis<T, MustAna, MayAna>::join(const Self &y) {
  LLVM_DEBUG(checkInvariants(); y.checkInvariants());

  auto xit = dirtiness.begin();
  auto yit = y.dirtiness.begin();
  std::map<TagType, DirtinessClassification> newmap;

  /* Since there is an order on the tags we can do the join using one pass only
   */
  while (xit != dirtiness.end() || yit != y.dirtiness.end()) {

    bool xTakesPart = yit == y.dirtiness.end() ||
                      (xit != dirtiness.end() && xit->first <= yit->first);
    bool yTakesPart = xit == dirtiness.end() ||
                      (yit != y.dirtiness.end() && yit->first <= xit->first);

    TagType tag = xTakesPart ? xit->first : yit->first;
    auto xelem =
        xTakesPart ? xit++->second : (implicitDirty ? DCL_UNKNOWN : DCL_CLEAN);
    auto yelem = yTakesPart ? yit++->second
                            : (y.implicitDirty ? DCL_UNKNOWN : DCL_CLEAN);

    xelem.join(yelem);
    newmap[tag] = xelem;
  }

  dirtiness = std::move(newmap);

  implicitDirty = implicitDirty || y.implicitDirty;
  must.join(y.must);
  may.join(y.may);

  LLVM_DEBUG(checkInvariants());
}

template <CacheTraits *T, class MustAna, class MayAna>
inline bool
DirtinessAnalysis<T, MustAna, MayAna>::lessequal(const Self &y) const {
  Self copy(*this);
  copy.join(y);
  return copy == y;
}

template <CacheTraits *T, class MustAna, class MayAna>
inline void DirtinessAnalysis<T, MustAna, MayAna>::enterScope(
    const PersistenceScope &scope) {
  must.enterScope(scope);
  may.enterScope(scope);
}

template <CacheTraits *T, class MustAna, class MayAna>
inline void DirtinessAnalysis<T, MustAna, MayAna>::leaveScope(
    const PersistenceScope &scope) {
  must.leaveScope(scope);
  may.leaveScope(scope);
}

template <CacheTraits *T, class MustAna, class MayAna>
std::set<PersistenceScope>
DirtinessAnalysis<T, MustAna, MayAna>::getPersistentScopes(
    const TagType tag) const {
  auto res1 = must.getPersistentScopes(tag);
  auto res2 = may.getPersistentScopes(tag);
  res1.insert(res2.begin(), res2.end());
  return res1;
}
template <CacheTraits *T, class MustAna, class MayAna>
std::set<PersistenceScope>
DirtinessAnalysis<T, MustAna, MayAna>::getPersistentScopes(
    const GlobalVariable *var) const {
  auto res1 = must.getPersistentScopes(var);
  auto res2 = may.getPersistentScopes(var);
  res1.insert(res2.begin(), res2.end());
  return res1;
}

///\see dom::cache::CacheSetAnalysis<T>::operator==(const Self& y) const
template <CacheTraits *T, class MustAna, class MayAna>
inline bool
DirtinessAnalysis<T, MustAna, MayAna>::operator==(const Self &y) const {
  return implicitDirty == y.implicitDirty && dirtiness == y.dirtiness &&
         must == y.must && may == y.may;
}

///\see dom::cache::CacheSetAnalysis<T>::operator<(const Self& y) const
template <CacheTraits *T, class MustAna, class MayAna>
inline bool
DirtinessAnalysis<T, MustAna, MayAna>::operator<(const Self &y) const {

  if (implicitDirty != y.implicitDirty) {
    return implicitDirty < y.implicitDirty;
  }
  // Cacheset analyses only define the == operator, not the != operator
  if (!(dirtiness == y.dirtiness)) {
    return dirtiness < y.dirtiness;
  }
  if (!(must == y.must)) {
    return must < y.must;
  }

  return may < y.may;
}

/////\see dom::cache::CacheSetAnalysis<T>::hash() const
// template <CacheTraits* T, class MustAna, class MayAna>
// inline std::size_t DirtinessAnalysis<T, MustAna, MayAna>::hash() const
//{
//	return analysis1.hash() ^ analysis2.hash();
// }

template <CacheTraits *T, class MustAna, class MayAna>
std::ostream &
DirtinessAnalysis<T, MustAna, MayAna>::dump(std::ostream &os) const {
  /* TODO find a suitable output format. */
  os << must << " " << may << ":";

  os << "Dirtiness (implicit dirty: " << (implicitDirty ? "yes" : "no")
     << "): ";
  for (auto it = dirtiness.begin(); it != dirtiness.end(); ++it) {
    if (it != dirtiness.begin()) {
      os << ", ";
    }
    printHex(os, it->first);
    os << ": " << it->second;
  }
  return os;
}

///\see std::ostream& operator<<(std::ostream& os, const CacheSetAnalysis<T>& x)
template <CacheTraits *T, class MustAna, class MayAna>
inline std::ostream &
operator<<(std::ostream &os, const DirtinessAnalysis<T, MustAna, MayAna> &x) {
  return x.dump(os);
}

} // namespace cache
} // namespace dom

} // namespace TimingAnalysisPass
#undef DEBUG_TYPE
#endif /*COMPOSITIONALANALYSIS_H_*/
