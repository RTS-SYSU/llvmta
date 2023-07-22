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

#ifndef CACHEANALYSIS_H_
#define CACHEANALYSIS_H_

#include <boost/tuple/tuple.hpp>
#include <iterator>
#include <ostream>
#include <vector>

#include "Memory/CacheTraits.h"
#include "Memory/Classification.h"
#include "Memory/PersistenceScopeInfo.h"
#include "Memory/UpdateReports.h"
#include "Memory/progana/Lattice.h"
#include "Memory/util/CacheSetAnalysisConcept.h"
#include "Memory/util/CacheUtils.h"

#include "Util/SharedStorage.h"
#include "Util/Util.h"

namespace TimingAnalysisPass {

/**
 * \brief   Contains various cache (set) analyses.\n
 * \details The main interfacing class is AbstractCache.\n
 *          Individual cache set analyses adhere to the interface given in
 * CacheSetAnalysis.\n
 */
namespace dom {
namespace cache {

typedef struct {
  bool WriteBack;
  bool WriteAllocate;
} WritePolicy;

class AbstractCache {
public:
  virtual ~AbstractCache() {}
  virtual AbstractCache *clone() const = 0;
  virtual Classification classify(const AbstractAddress &addr) const = 0;
  /* Updates the underlying abstract cache for an access somewhere inside
   * addr. Iff wantReport is set the update returns an updateReport. The
   * caller is responsible for freeing it.
   * Note that the function must not return nullptr if wantReport is set,
   * even if it has nothing to report! Return an instance of UpdateReport
   * instead */
  virtual UpdateReport *
  update(const AbstractAddress &addr, AccessType load_store,
         bool wantReport = false,
         const Classification assumption = dom::cache::CL_UNKNOWN) = 0;

  virtual void join(const AbstractCache &y) = 0;
  virtual bool lessequal(const AbstractCache &y) const = 0;
  virtual void enterScope(const PersistenceScope &scope) = 0;
  virtual void leaveScope(const PersistenceScope &scope) = 0;
  virtual std::set<PersistenceScope>
  getPersistentScopes(const AbstractAddress addr) const = 0;
  virtual bool equals(const AbstractCache &y) const = 0;
  virtual std::ostream &dump(std::ostream &os) const = 0;

  virtual Address alignToCacheline(const Address addr) const = 0;
  virtual unsigned getHitLatency() const = 0;
  virtual WritePolicy getWritePolicy() const = 0;
};

/**
 * \brief Dumps a textual representation of an abstract cache state.
 * \param os The out-stream to write to.
 * \param x  The abstract cache state to dump.
 * \return   The possibly modified out-stream.
 */
std::ostream &operator<<(std::ostream &os, const AbstractCache &x);

/**
 * \tparam T  Cache traits
 * \tparam C  Cache set analysis
 *
 * \brief   Implements a cache analysis for a cache with the given dimensions.
 * \details Assumes standard modulo mapping of addresses to sets.
 */
template <CacheTraits *T, class C>
class AbstractCacheImpl : public progana::JoinSemiLattice,
                          public AbstractCache {
  //	BOOST_CONCEPT_ASSERT((concepts::CacheTraits<T>)); TODO
  BOOST_CONCEPT_ASSERT((concepts::CacheSetAnalysis<C>));

public:
  typedef C SetType;

private:
  typedef AbstractCacheImpl<T, C> Self;

  typedef typename CacheTraits::AddressType AddressType;
  typedef typename CacheTraits::WayType WayType;
  typedef typename CacheTraits::IndexType IndexType;
  typedef typename CacheTraits::TagType TagType;
  typedef util::SharedStorage<SetType> SharedStorage;
  typedef typename SharedStorage::SharedPtr SharedPtr;
  typedef typename std::vector<SharedPtr>::iterator IterType;
  typedef typename std::vector<SharedPtr>::const_iterator ConstIterType;
  typedef typename C::AnaDeps AnalysisDependencies;

public:
  using SetWiseAnaDeps = std::vector<AnalysisDependencies *>;

private:
  SharedStorage cacheSetStorage;
  std::vector<SharedPtr> cacheSets;

protected:
  std::pair<unsigned, unsigned> getTagAndIndex(AddressType addr) const;

public:
  virtual ~AbstractCacheImpl() {}

  AbstractCacheImpl(bool assumeAnEmptyCache = false);
  virtual AbstractCacheImpl *clone() const;
  virtual Classification classify(const AbstractAddress &itv) const;

  virtual UpdateReport *
  update(const AbstractAddress &addr, AccessType load_store,
         bool wantReport = false,
         const Classification assumption = dom::cache::CL_UNKNOWN);
  virtual UpdateReport *
  update(const AbstractAddress &addr, AccessType load_store, SetWiseAnaDeps *AD,
         bool wantReport = false,
         const Classification assumption = dom::cache::CL_UNKNOWN);

  virtual void join(const AbstractCache &y);
  virtual bool lessequal(const AbstractCache &y) const;
  virtual void enterScope(const PersistenceScope &scope);
  virtual void leaveScope(const PersistenceScope &scope);
  virtual std::set<PersistenceScope>
  getPersistentScopes(const AbstractAddress addr) const;
  virtual bool equals(const AbstractCache &y) const;
  virtual std::ostream &dump(std::ostream &os) const;

  /**
   * Returns the address aligned to cache linesize
   */
  virtual Address alignToCacheline(const Address addr) const;
  /**
   * Returns the hit latency of this cache
   */
  virtual unsigned getHitLatency() const;
  /**
   * Return the write-policy of the underlying cache
   */
  virtual WritePolicy getWritePolicy() const;
  /**
   * Returns the vector of individual cache sets
   */
  auto getCacheSets() const -> std::vector<SharedPtr>;

private:
  /**
   * Interval of cache set numbers.
   */
  typedef std::pair<unsigned, unsigned> CacheSetItv;
  /**
   * Returns the cache set a given address maps to.
   */
  unsigned getCacheSet(const Address addr) const;
  /**
   * Compute the interval of possible cache sets to which an address of addritv
   * can map to
   */
  CacheSetItv getCacheSetInterval(const AddressInterval &addritv) const;
  /**
   * Updates the cache state after an access to any address in itv.
   * If a report is requested it returns the joined report of all accesses or
   * NULL if the underlying reports are not joinable
   */
  JoinableUpdateReport *
  updateUnknownSets(const unsigned lower, const unsigned upper,
                    AbstractAddress addr, AccessType load_store,
                    bool wantReport, const Classification assumption);
};

/**
 * \brief Computes the tag and the set number for a given address.
 */
template <CacheTraits *T, class C>
inline std::pair<unsigned, unsigned>
AbstractCacheImpl<T, C>::getTagAndIndex(AddressType addr) const {
  unsigned blockNumber = addr / T->LINE_SIZE;
  return std::make_pair(blockNumber / T->N_SETS, blockNumber % T->N_SETS);
}

/**
 * \brief Initializes the abstract cache state.
 * \param assumeAnEmptyCache
 *        Indicates which concrete states should be over-approximated by the
 * abstract state.\n \c true   The abstract state over-approximates the empty
 * cache state.\n \c false  The abstract state over-approximates all possible
 * cache states. \warning Assuming an empty cache may be unsafe.
 */
template <CacheTraits *T, class C>
AbstractCacheImpl<T, C>::AbstractCacheImpl(bool assumeAnEmptyCache)
    : cacheSets(T->N_SETS) {
  SetType initialCacheSetState(assumeAnEmptyCache);
  SharedPtr inserted = cacheSetStorage.insert(initialCacheSetState);
  cacheSets.assign(T->N_SETS, inserted);
}

template <CacheTraits *T, class C>
AbstractCacheImpl<T, C> *AbstractCacheImpl<T, C>::clone() const {
  return new AbstractCacheImpl<T, C>(*this);
}

/**
 * \brief Tries to classify an access on an address as cache hit or cache miss.
 * \param addr The address of an access to classify.
 * \return    \c CL_HIT     if there must be a valid cache line for address \p
 * addr \n \c CL_MISS    if there may not be a valid cache line for address \p
 * addr \n \c CL_UNKNOWN otherwise
 */
template <CacheTraits *T, class C>
Classification
AbstractCacheImpl<T, C>::classify(const AbstractAddress &addr) const {
  /* fastpath for unknownAddressInterval */
  if (addr.isSameInterval(AbstractAddress::getUnknownAddress())) {
    return CL_UNKNOWN;
  }

  Address lowAligned = alignToCacheline(addr.getAsInterval().lower());
  Address upAligned = alignToCacheline(addr.getAsInterval().upper());

  /* Join all classifications from the underlying per-set analyses. Abort
   * early if we have reached the top of the lattice */
  Classification result = CL_BOT;
  while (lowAligned <= upAligned && result != CL_UNKNOWN) {
    unsigned tag, index;
    boost::tie(tag, index) = getTagAndIndex(lowAligned);
    result.join(cacheSets[index]->classify(AbstractAddress(lowAligned)));
    lowAligned += T->LINE_SIZE;
  }
  return result;
}

/**
 * \brief Updates the abstract state to reflect a cache access.
 * \param addr        The address of the access.
 * \param assumption  An assumption which may allow more precise updates.
 * \details The assumption is optional and \c CL_UNKNOWN by default, i.e. no
 * assumption.
 * \warning The assumption is not checked (and in some cases cannot be checked).
 *          Assuming something may be unsafe.
 */
template <CacheTraits *T, class C>
UpdateReport *AbstractCacheImpl<T, C>::update(const AbstractAddress &addr,
                                              AccessType load_store,
                                              bool wantReport,
                                              const Classification assumption) {
  return update(addr, load_store, nullptr, wantReport, assumption);
}

/**
 * \brief Updates the abstract state to reflect a cache access.
 * \param addr        The address of the access.
 * \param load_store  Is the access a load or might it be a store?
 * \param wantReport  Does the caller want an (analysis-defined) UpdateReport?
 *                    If yes, the caller is responsible to delete() it again
 * \param assumption  An assumption which may allow more precise updates.
 * \details The assumption is optional and \c CL_UNKNOWN by default, i.e. no
 * assumption. \warning The assumption is not checked (and in some cases cannot
 * be checked). Assuming something may be unsafe.
 */
template <CacheTraits *T, class C>
UpdateReport *AbstractCacheImpl<T, C>::update(const AbstractAddress &addr,
                                              AccessType load_store,
                                              SetWiseAnaDeps *AD,
                                              bool wantReport,
                                              const Classification assumption) {
  AddressInterval itv = addr.getAsInterval();
  // Precise update possible
  if (alignToCacheline(itv.lower()) == alignToCacheline(itv.upper())) {
    unsigned tag, index;
    boost::tie(tag, index) = getTagAndIndex(itv.lower());

    SetType newCacheAnalysisSet(*cacheSets[index]);

    AnalysisDependencies *Deps = nullptr;
    if (AD) {
      Deps = AD->at(index);
    }

    AbstractAddress clAddr(alignToCacheline(itv.lower()));
    UpdateReport *report = newCacheAnalysisSet.update(clAddr, load_store, Deps,
                                                      wantReport, assumption);
    cacheSets[index] = cacheSetStorage.insert(newCacheAnalysisSet);
    assert(report || !wantReport);
    return report;
  }

  unsigned lower, upper;
  JoinableUpdateReport *report, *report2;
  // Make update for imprecise address information
  boost::tie(lower, upper) = getCacheSetInterval(itv);
  assert((T->N_SETS == 1 || lower != upper) &&
         "Could have performed precise update");
  if (lower <= upper) {
    report = updateUnknownSets(lower, upper, addr, load_store, wantReport,
                               assumption);
    if (wantReport && !report) {
      /* underlying reports are unjoinable - return no
       * information */
      return new UpdateReport;
    }
    return report;
  }

  // wraparound:
  report = updateUnknownSets(lower, T->N_SETS - 1, addr, load_store, wantReport,
                             assumption);
  report2 =
      updateUnknownSets(0, upper, addr, load_store, wantReport, assumption);

  if (!wantReport) {
    assert(!report && !report2);
    return nullptr;
  }

  if (!report || !report2) {
    /* The underlying reports were not joinable - return no
     * information */
    delete report;
    delete report2;
    return new UpdateReport;
  }

  report->join(report2);
  delete report2;
  return report;
}

template <CacheTraits *T, class C>
JoinableUpdateReport *AbstractCacheImpl<T, C>::updateUnknownSets(
    const unsigned lower, const unsigned upper, AbstractAddress addr,
    AccessType load_store, bool wantReport, const Classification assumption) {
  JoinableUpdateReport *report = nullptr;
  for (unsigned index = lower; index <= upper; ++index) {
    SetType newCacheAnalysisSet(*cacheSets[index]);
    UpdateReport *rep =
        newCacheAnalysisSet.potentialUpdate(addr, load_store, wantReport);
    cacheSets[index] = cacheSetStorage.insert(newCacheAnalysisSet);

    if (!wantReport)
      continue;

    JoinableUpdateReport *jrep = dynamic_cast<JoinableUpdateReport *>(rep);
    if (!report)
      report = jrep;
    else {
      report->join(jrep);
      delete jrep;
    }
  }

  return report;
}

/**
 * \brief Updates the abstract state to be the join of itself and another one.
 * \param y The other state to join with.
 */
template <CacheTraits *T, class C>
void AbstractCacheImpl<T, C>::join(const AbstractCache &ay) {
  // TODO use std::transform(cacheSets.begin(), cacheSets.end(),
  // y.cacheSets.begin(), res.cacheSets.begin(), join_fct);
  const Self &y = dynamic_cast<const Self &>(ay);
  for (unsigned i = 0; i < T->N_SETS; ++i) {
    if (cacheSets[i] ==
        y.cacheSets[i]) { // no active joining needed for equal sets
      continue;
    }
    SetType newCacheAnalysisSet(*cacheSets[i]);
    newCacheAnalysisSet |= *y.cacheSets[i];
    cacheSets[i] = cacheSetStorage.insert(newCacheAnalysisSet);
  }
}

/**
 * \brief Models the partial order of abstract caches
 */
template <CacheTraits *T, class C>
bool AbstractCacheImpl<T, C>::lessequal(const AbstractCache &ay) const {
  const Self &y = dynamic_cast<const Self &>(ay);
  for (unsigned i = 0; i < T->N_SETS; ++i) {
    if (cacheSets[i] == y.cacheSets[i]) { // Sets are equal
      continue;
    }
    if (!cacheSets[i]->lessequal(*y.cacheSets[i])) {
      return false;
    }
  }
  return true;
}

template <CacheTraits *T, class C>
void AbstractCacheImpl<T, C>::enterScope(const PersistenceScope &scope) {
  for (unsigned i = 0; i < T->N_SETS; ++i) {
    SetType newCacheAnalysisSet(*cacheSets[i]);
    newCacheAnalysisSet.enterScope(scope);
    cacheSets[i] = cacheSetStorage.insert(newCacheAnalysisSet);
  }
}

template <CacheTraits *T, class C>
void AbstractCacheImpl<T, C>::leaveScope(const PersistenceScope &scope) {
  for (unsigned i = 0; i < T->N_SETS; ++i) {
    SetType newCacheAnalysisSet(*cacheSets[i]);
    newCacheAnalysisSet.leaveScope(scope);
    cacheSets[i] = cacheSetStorage.insert(newCacheAnalysisSet);
  }
}

template <CacheTraits *T, class C>
std::set<PersistenceScope>
AbstractCacheImpl<T, C>::getPersistentScopes(const AbstractAddress addr) const {
  std::set<PersistenceScope> ret;
  if (addr.isArray()) {
    auto csItv = getCacheSetInterval(addr.getAsInterval());
    ret = cacheSets[csItv.first]->getPersistentScopes(addr.getArray());
    for (unsigned index = csItv.first + 1; index <= csItv.second; index++) {
      auto ret2 = cacheSets[index]->getPersistentScopes(addr.getArray());
      std::set<PersistenceScope> intersection;
      std::set_intersection(ret.begin(), ret.end(), ret2.begin(), ret2.end(),
                            std::inserter(intersection, intersection.begin()));
      ret = std::move(intersection);
    }
  } else {
    unsigned tag, index;
    assert(addr.isPrecise());
    boost::tie(tag, index) = getTagAndIndex(addr.getAsInterval().lower());
    ret = cacheSets[index]->getPersistentScopes(tag);
  }
  DEBUG_WITH_TYPE(
      "persistence", if (ret.size() > 0) {
        dbgs() << addr << " is persistent in the following scopes:\n";
        for (auto s : ret) {
          dbgs() << "\t" << s << "\n";
        }
      });
  return ret;
}

/**
 * \brief Determines whether the abstract state is equal to another one.
 * \param y The other state to compare with.
 * \return \c true if the states are equal, \c false otherwise.
 */
template <CacheTraits *T, class C>
bool AbstractCacheImpl<T, C>::equals(const AbstractCache &ay) const {
  const Self &y = dynamic_cast<const Self &>(ay);
  // Since SharedStorage returns unique pointers, we can compare pointers to
  // cache sets here.
  return std::equal(cacheSets.begin(), cacheSets.end(), y.cacheSets.begin());
}

/**
 * \brief Dumps a textual representation of the abstract state.
 * \param os The out-stream to write to.
 * \return   The possibly modified out-stream.
 */
template <CacheTraits *T, class C>
std::ostream &AbstractCacheImpl<T, C>::dump(std::ostream &os) const {
  os << "CacheAnalysis sets:\n";
  for (unsigned idx = 0; idx < T->N_SETS; ++idx) {
    printHex(os, idx);
    os << ": " << *(cacheSets[idx]) << "\n";
  }
  return os;
}

/* TODO there is no good reason for this to be in "AbstractCache". This
 * probably belongs together with getTag, such that cache set analyses can also
 * access it. Maybe one even wants to do these operations on AbstractAddresses
 * directly */
template <CacheTraits *T, class C>
unsigned AbstractCacheImpl<T, C>::getCacheSet(const Address addr) const {
  return (addr / T->LINE_SIZE) % T->N_SETS;
}

template <CacheTraits *T, class C>
Address AbstractCacheImpl<T, C>::alignToCacheline(const Address addr) const {
  return getCachelineAddress<T>(addr);
}

template <CacheTraits *T, class C>
unsigned AbstractCacheImpl<T, C>::getHitLatency() const {
  return T->LATENCY;
}

template <CacheTraits *T, class C>
WritePolicy AbstractCacheImpl<T, C>::getWritePolicy() const {
  return WritePolicy{T->WRITEBACK, T->WRITEALLOCATE};
}

template <CacheTraits *T, class C>
auto AbstractCacheImpl<T, C>::getCacheSets() const -> std::vector<SharedPtr> {
  return cacheSets;
}

template <CacheTraits *T, class C>
typename AbstractCacheImpl<T, C>::CacheSetItv
AbstractCacheImpl<T, C>::getCacheSetInterval(
    const AddressInterval &addritv) const {
  unsigned lower = 0;
  unsigned upper = T->N_SETS - 1;
  if ((addritv.upper() + 4 - addritv.lower()) >= T->N_SETS * T->LINE_SIZE) {
    return std::make_pair(lower, upper);
  }
  lower = getCacheSet(addritv.lower());
  upper = getCacheSet(addritv.upper());
  return std::make_pair(lower, upper);
}

//////// CRPD related stuff
template <CacheTraits *T>
class TrackLastAccess : public progana::JoinSemiLattice, public AbstractCache {
private:
  typedef TrackLastAccess<T> Self;

  typedef typename CacheTraits::AddressType AddressType;
  typedef typename CacheTraits::WayType WayType;
  typedef typename CacheTraits::IndexType IndexType;
  typedef typename CacheTraits::TagType TagType;

public:
  using SetWiseAnaDeps = std::vector<std::tuple<> *>;

private:
  boost::optional<Address> lastAccessedAddress;

public:
  std::pair<unsigned, unsigned> getTagAndIndex(AddressType addr) const;

public:
  virtual ~TrackLastAccess() {}

  TrackLastAccess(bool assumeAnEmptyCache = false);

  virtual TrackLastAccess *clone() const;
  virtual Classification classify(const AbstractAddress &itv) const;

  virtual UpdateReport *
  update(const AbstractAddress &addr, AccessType load_store,
         bool wantReport = false,
         const Classification assumption = dom::cache::CL_UNKNOWN);
  virtual UpdateReport *
  update(const AbstractAddress &addr, AccessType load_store, SetWiseAnaDeps *AD,
         bool wantReport = false,
         const Classification assumption = dom::cache::CL_UNKNOWN);

  virtual void enterScope(const PersistenceScope &scope){};
  virtual void leaveScope(const PersistenceScope &scope){};
  virtual std::set<PersistenceScope>
  getPersistentScopes(const AbstractAddress addr) const {
    return std::set<PersistenceScope>();
  }

  virtual void join(const AbstractCache &y);
  virtual bool lessequal(const AbstractCache &y) const;
  virtual bool equals(const AbstractCache &y) const;
  virtual std::ostream &dump(std::ostream &os) const;

  /**
   * Returns the address aligned to cache linesize
   */
  virtual Address alignToCacheline(const Address addr) const;
  /**
   * Returns the hit latency of this cache
   */
  virtual unsigned getHitLatency() const;
  /**
   * Return the write-policy of the underlying cache
   */
  virtual WritePolicy getWritePolicy() const;

  boost::optional<Address> getLastAccess() const { return lastAccessedAddress; }

private:
  /**
   * Interval of cache set numbers.
   */
  typedef std::pair<unsigned, unsigned> CacheSetItv;
  /**
   * Returns the cache set a given address maps to.
   */
  unsigned getCacheSet(const Address addr) const;
  /**
   * Compute the interval of possible cache sets to which an address of addritv
   * can map to
   */
  CacheSetItv getCacheSetInterval(const AddressInterval &addritv) const;
  /**
   * Updates the cache state after an access to any address in itv.
   * If a report is requested it returns the joined report of all accesses or
   * NULL if the underlying reports are not joinable
   */
  JoinableUpdateReport *
  updateUnknownSets(const unsigned lower, const unsigned upper,
                    AbstractAddress addr, AccessType load_store,
                    bool wantReport, const Classification assumption);
};

/**
 * \brief Computes the tag and the set number for a given address.
 */
template <CacheTraits *T>
inline std::pair<unsigned, unsigned>
TrackLastAccess<T>::getTagAndIndex(AddressType addr) const {
  unsigned blockNumber = addr / T->LINE_SIZE;
  return std::make_pair(blockNumber / T->N_SETS, blockNumber % T->N_SETS);
}

/**
 * \brief Initializes the abstract cache state.
 * \param assumeAnEmptyCache
 *        Indicates which concrete states should be over-approximated by the
 * abstract state.\n \c true   The abstract state over-approximates the empty
 * cache state.\n \c false  The abstract state over-approximates all possible
 * cache states. \warning Assuming an empty cache may be unsafe.
 */
template <CacheTraits *T>
TrackLastAccess<T>::TrackLastAccess(bool assumeAnEmptyCache)
    : lastAccessedAddress(boost::none) {}

template <CacheTraits *T>
TrackLastAccess<T> *TrackLastAccess<T>::clone() const {
  return new TrackLastAccess<T>(*this);
}

template <CacheTraits *T>
Classification TrackLastAccess<T>::classify(const AbstractAddress &addr) const {
  return CL_UNKNOWN;
}

template <CacheTraits *T>
UpdateReport *TrackLastAccess<T>::update(const AbstractAddress &addr,
                                         AccessType load_store, bool wantReport,
                                         const Classification assumption) {
  return update(addr, load_store, nullptr, wantReport, assumption);
}

template <CacheTraits *T>
UpdateReport *TrackLastAccess<T>::update(const AbstractAddress &addr,
                                         AccessType load_store,
                                         SetWiseAnaDeps *AD, bool wantReport,
                                         const Classification assumption) {
  AddressInterval itv = addr.getAsInterval();
  // Precise update possible
  assert(alignToCacheline(itv.lower()) == alignToCacheline(itv.upper()) &&
         "Access Tracking only for instructions");
  lastAccessedAddress = alignToCacheline(itv.lower());
  return nullptr;
}

template <CacheTraits *T>
JoinableUpdateReport *TrackLastAccess<T>::updateUnknownSets(
    const unsigned lower, const unsigned upper, AbstractAddress addr,
    AccessType load_store, bool wantReport, const Classification assumption) {
  assert(0 && "Should be unreachable");
  return nullptr;
}

/**
 * \brief Updates the abstract state to be the join of itself and another one.
 * \param y The other state to join with.
 */
template <CacheTraits *T>
void TrackLastAccess<T>::join(const AbstractCache &ay) {
  const Self &y = dynamic_cast<const Self &>(ay);
  if (lastAccessedAddress != y.lastAccessedAddress) {
    lastAccessedAddress = boost::none;
  }
}

/**
 * \brief Models the partial order of abstract caches
 */
template <CacheTraits *T>
bool TrackLastAccess<T>::lessequal(const AbstractCache &ay) const {
  const Self &y = dynamic_cast<const Self &>(ay);
  if (y.lastAccessedAddress) {
    return lastAccessedAddress == y.lastAccessedAddress;
  } else {
    return true;
  }
}

/**
 * \brief Determines whether the abstract state is equal to another one.
 * \param y The other state to compare with.
 * \return \c true if the states are equal, \c false otherwise.
 */
template <CacheTraits *T>
bool TrackLastAccess<T>::equals(const AbstractCache &ay) const {
  const Self &y = dynamic_cast<const Self &>(ay);
  return lastAccessedAddress == y.lastAccessedAddress;
}

/**
 * \brief Dumps a textual representation of the abstract state.
 * \param os The out-stream to write to.
 * \return   The possibly modified out-stream.
 */
template <CacheTraits *T>
std::ostream &TrackLastAccess<T>::dump(std::ostream &os) const {
  os << "Last accessed element: "
     << (lastAccessedAddress ? std::to_string(lastAccessedAddress.get())
                             : "none\n");
  return os;
}

template <CacheTraits *T>
unsigned TrackLastAccess<T>::getCacheSet(const Address addr) const {
  return (addr / T->LINE_SIZE) % T->N_SETS;
}

template <CacheTraits *T>
Address TrackLastAccess<T>::alignToCacheline(const Address addr) const {
  return getCachelineAddress<T>(addr);
}

template <CacheTraits *T> unsigned TrackLastAccess<T>::getHitLatency() const {
  return T->LATENCY;
}

template <CacheTraits *T>
WritePolicy TrackLastAccess<T>::getWritePolicy() const {
  return WritePolicy{T->WRITEBACK, T->WRITEALLOCATE};
}

template <CacheTraits *T>
typename TrackLastAccess<T>::CacheSetItv
TrackLastAccess<T>::getCacheSetInterval(const AddressInterval &addritv) const {
  unsigned lower = 0;
  unsigned upper = T->N_SETS - 1;
  if ((addritv.upper() + 4 - addritv.lower()) >= T->N_SETS * T->LINE_SIZE) {
    return std::make_pair(lower, upper);
  }
  lower = getCacheSet(addritv.lower());
  upper = getCacheSet(addritv.upper());
  return std::make_pair(lower, upper);
}

} // namespace cache
} // namespace dom

} // namespace TimingAnalysisPass

#endif /*CACHEANALYSIS_H_*/
