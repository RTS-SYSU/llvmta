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

#ifndef ELEMENTWISECOUNTINGPERSISTENCE_H
#define ELEMENTWISECOUNTINGPERSISTENCE_H

#include <algorithm>
#include <ostream>
#include <set>

#include "Memory/Classification.h"
#include "Memory/SetWiseCountingPersistence.h"
#include "Memory/progana/Lattice.h"
#include "Memory/util/ImplicitSet.h"

namespace TimingAnalysisPass {

namespace dom {
namespace cache {

/**
 * \tparam T Cache traits
 *
 * \brief   Implements a simple LRU persistence analysis based on counting
 * accesses per element.
 */
template <CacheTraits *T>
class ElementWiseCountingPersistence : public progana::JoinSemiLattice {
  typedef ElementWiseCountingPersistence<T> Self;

protected:
  unsigned ASSOCIATIVITY = T->ASSOCIATIVITY;
  const CacheTraits *CacheConfig = T;

  typedef typename CacheTraits::WayType WayType;
  typedef typename CacheTraits::TagType TagType;
  typedef typename CacheTraits::PosType PosType;

  /**
   * Map containing conflict set information for specific accessed tags.
   * If the map has no set for a specific tag, than it is empty by default.
   */
  std::map<TagType, SetWiseCountingPersistence<T>> ele2conflicts;

public:
  using AnaDeps = std::tuple<>;
  explicit ElementWiseCountingPersistence(bool assumeAnEmptyCache = false);
  Classification classify(const AbstractAddress addr) const;
  UpdateReport *update(const AbstractAddress addr, AccessType load_store,
                       AnaDeps *, bool wantReport = false,
                       const Classification assumption = CL_UNKNOWN);
  UpdateReport *potentialUpdate(AbstractAddress addr, AccessType load_store,
                                bool wantReport = false);
  void join(const Self &y);
  bool lessequal(const Self &y) const;
  void enterScope(const PersistenceScope &scope) {}
  void leaveScope(const PersistenceScope &scope) {}
  bool isPersistent(const TagType tag) const;
  bool isPersistent(const GlobalVariable *var) const;
  bool operator==(const Self &y) const;
  bool operator<(const Self &y) const;
  template <typename streamtype> streamtype &dump(streamtype &os) const;
};

///\see dom::cache::CacheSetAnalysis<T>::CacheSetAnalysis(bool
///assumeAnEmptyCache)
template <CacheTraits *T>
inline ElementWiseCountingPersistence<T>::ElementWiseCountingPersistence(
    bool assumeAnEmptyCache __attribute__((unused)))
    : ele2conflicts() {}

///\see dom::cache::CacheSetAnalysis<T>::classify(const TagType tag) const
template <CacheTraits *T>
Classification
ElementWiseCountingPersistence<T>::classify(const AbstractAddress addr) const {
  return CL_UNKNOWN; // cannot help here
}

/**
 * \brief Simulates an update to an unknown cache element, increase the age of
 * all elements
 */
template <CacheTraits *T>
UpdateReport *ElementWiseCountingPersistence<T>::potentialUpdate(
    AbstractAddress addr, AccessType load_store, bool wantReport) {
  for (auto &e2c : ele2conflicts) {
    e2c.second.potentialUpdate(addr, load_store);
  }
  return wantReport ? new UpdateReport : nullptr;
}

///\see dom::cache::CacheSetAnalysis<T>::update(const TagType tag, const
///Classification assumption)
template <CacheTraits *T>
UpdateReport *ElementWiseCountingPersistence<T>::update(
    const AbstractAddress addr, AccessType load_store, AnaDeps *Deps,
    bool wantReport, const Classification assumption __attribute__((unused))) {
  TagType tag = getTag<T>(addr);
  ele2conflicts[tag] = SetWiseCountingPersistence<T>();
  for (auto &e2c : ele2conflicts) {
    e2c.second.update(addr, load_store, Deps);
  }
  return wantReport ? new UpdateReport : nullptr;
}

///\see dom::cache::CacheSetAnalysis<T>::join(const Self& y)
template <CacheTraits *T>
void ElementWiseCountingPersistence<T>::join(const Self &y) {
  // Join when both are defined
  for (auto &e2c : ele2conflicts) {
    if (y.ele2conflicts.count(e2c.first) > 0) {
      e2c.second.join(y.ele2conflicts.at(e2c.first));
    }
  }
  // Add mapping that are there in y but not in this
  for (auto &e2c : y.ele2conflicts) {
    if (ele2conflicts.count(e2c.first) == 0) {
      ele2conflicts.insert(std::make_pair(e2c.first, e2c.second));
    }
  }
}

template <CacheTraits *T>
inline bool ElementWiseCountingPersistence<T>::lessequal(const Self &y) const {
  for (auto &e2c : ele2conflicts) {
    if (y.ele2conflicts.count(e2c.first) == 0 ||
        !e2c.second.lessequal(y.ele2conflicts.at(e2c.first))) {
      return false;
    }
  }
  return true;
}

template <CacheTraits *T>
inline bool
ElementWiseCountingPersistence<T>::isPersistent(const TagType tag) const {
  /* ele2conflicts.count(tag) == 0 means we have never seen the element
   * before (on any path). If we never see it again it doesn't harm to
   * mark it as persistent (since we are allowed one miss anyway). If we
   * do see it again and our conflict set is small enough we want to mark
   * this access as persistent since it corresponds to the initial load */
  return ele2conflicts.count(tag) == 0 ||
         ele2conflicts.at(tag).isPersistent(tag);
}

template <CacheTraits *T>
inline bool ElementWiseCountingPersistence<T>::isPersistent(
    const GlobalVariable *var) const {
  /* We have no idea */
  return false;
}

///\see dom::cache::CacheSetAnalysis<T>::operator==(const Self& y) const
template <CacheTraits *T>
inline bool ElementWiseCountingPersistence<T>::operator==(const Self &y) const {
  return this->lessequal(y) && y.lessequal(*this);
}

///\see dom::cache::CacheSetAnalysis<T>::operator<(const Self& y) const
template <CacheTraits *T>
inline bool ElementWiseCountingPersistence<T>::operator<(const Self &y) const {
  if (this->ele2conflicts.size() != y.ele2conflicts.size())
    return this->ele2conflicts.size() < y.ele2conflicts.size();

  auto it1 = this->ele2conflicts.begin();
  auto it2 = y.ele2conflicts.begin();
  for (; it1 != this->ele2conflicts.end(); ++it1, ++it2) {
    if (it1->first != it2->first) {
      return it1->first < it2->first;
    }
    if (it1->second != it2->second) {
      return it1->second < it2->second;
    }
  }

  return false;
}

///\see dom::cache::CacheSetAnalysis<T>::dump(std::ostream& os) const
template <CacheTraits *T>
template <typename streamtype>
streamtype &ElementWiseCountingPersistence<T>::dump(streamtype &os) const {
  os << "{";
  bool emitComma = false;
  for (auto &e2c : this->ele2conflicts) {
    if (emitComma)
      os << ", ";
    printHex(os, e2c.first);
    os << " |-> " << e2c.second;
    emitComma = true;
  }
  os << "}";
  return os;
}

///\see std::ostream& operator<<(std::ostream& os, const CacheSetAnalysis<T>& x)
template <CacheTraits *T, class streamtype>
inline streamtype &operator<<(streamtype &os,
                              const ElementWiseCountingPersistence<T> &x) {
  return x.dump(os);
}

} // namespace cache
} // namespace dom

} // namespace TimingAnalysisPass

#endif /*ELEMENTWISECOUNTINGPERSISTENCE_H*/
