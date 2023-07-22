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

#ifndef CONDITIONALMUSTPERSISTENCE_H
#define CONDITIONALMUSTPERSISTENCE_H

#include <algorithm>
#include <limits>
#include <map>
#include <ostream>
#include <set>

#include "Memory/Classification.h"
#include "Memory/progana/Lattice.h"
#include "Memory/util/CacheUtils.h"
#include "Memory/util/ImplicitSet.h"
#include "Util/Options.h"

namespace TimingAnalysisPass {

namespace dom {
namespace cache {

/**
 * \tparam T Cache traits
 *
 * \brief   Implements an LRU persistence analysis based on conditional must
 * information.
 *
 */
template <CacheTraits *T>
class ConditionalMustPersistence : public progana::JoinSemiLattice {
  typedef ConditionalMustPersistence<T> Self;

protected:
  unsigned ASSOCIATIVITY = T->ASSOCIATIVITY;
  const CacheTraits *CacheConfig = T;

  typedef typename CacheTraits::WayType WayType;
  typedef typename CacheTraits::TagType TagType;
  typedef typename CacheTraits::PosType PosType;

  std::map<TagType, unsigned> conflicts;

public:
  using AnaDeps = std::tuple<>;
  explicit ConditionalMustPersistence(bool assumeAnEmptyCache = false);
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
inline ConditionalMustPersistence<T>::ConditionalMustPersistence(
    bool assumeAnEmptyCache __attribute__((unused)))
    : conflicts() {}

///\see dom::cache::CacheSetAnalysis<T>::classify(const TagType tag) const
template <CacheTraits *T>
Classification
ConditionalMustPersistence<T>::classify(const AbstractAddress addr) const {
  return CL_UNKNOWN; // cannot help here
}

/**
 * \brief Simulates an update to an unknown cache element, increase the age of
 * all elements
 */
template <CacheTraits *T>
UpdateReport *ConditionalMustPersistence<T>::potentialUpdate(
    AbstractAddress addr, AccessType load_store, bool wantReport) {
  for (auto &block : conflicts) {
    if (block.second > 0 && block.second <= ASSOCIATIVITY)
      block.second++;
  }
  return nullptr;
}

///\see dom::cache::CacheSetAnalysis<T>::update(const TagType tag, const
///Classification assumption)
template <CacheTraits *T>
UpdateReport *ConditionalMustPersistence<T>::update(
    const AbstractAddress addr, AccessType load_store, AnaDeps *,
    bool wantReport, const Classification assumption __attribute__((unused))) {

  TagType tag = getTag<T>(addr);
  if (!conflicts.count(tag)) {
    conflicts[tag] = 1;
    return nullptr;
  }

  for (auto &block : conflicts) {
    if (block.first == tag)
      block.second = 1;
    else if (block.second > 0 && block.second <= ASSOCIATIVITY)
      block.second++;
  }
  return nullptr;
}

///\see dom::cache::CacheSetAnalysis<T>::join(const Self& y)
template <CacheTraits *T>
void ConditionalMustPersistence<T>::join(const Self &y) {
  for (auto &block : y.conflicts) { // not all blocks necessarily coincide
    if (!conflicts.count(block.first))
      conflicts[block.first] = 0;
    conflicts[block.first] = std::max(block.second, conflicts[block.first]);
  }
}

template <CacheTraits *T>
inline bool ConditionalMustPersistence<T>::lessequal(const Self &y) const {
  Self copy(*this);
  copy.join(y);
  return copy == y;
}

template <CacheTraits *T>
inline bool
ConditionalMustPersistence<T>::isPersistent(const TagType tag) const {
  // If the tag is present in the conflict sets map,(i.e. there are conflicting
  // blocks for the current tag) we need to check that the size of the conflict
  // set for this tag is <= ASSOCIATIVITY

  if (conflicts.count(tag))
    return conflicts.at(tag) <= ASSOCIATIVITY;

  // In case when there is no entry for the tag in the conflict sets map, it
  // implies that the corresponding block has not been accessed yet and hence
  // this is the first access to the block. This in turn implies that the
  // current tag is persistent.

  return true;
}

template <CacheTraits *T>
inline bool
ConditionalMustPersistence<T>::isPersistent(const GlobalVariable *var) const {
  /* We have no idea */
  return false;
}

///\see dom::cache::CacheSetAnalysis<T>::operator==(const Self& y) const
template <CacheTraits *T>
inline bool ConditionalMustPersistence<T>::operator==(const Self &y) const {
  return conflicts == y.conflicts;
}

///\see dom::cache::CacheSetAnalysis<T>::operator<(const Self& y) const
template <CacheTraits *T>
inline bool ConditionalMustPersistence<T>::operator<(const Self &y) const {
  return conflicts < y.conflicts;
}

///\see dom::cache::CacheSetAnalysis<T>::dump(std::ostream& os) const
template <CacheTraits *T>
template <class streamtype>
streamtype &ConditionalMustPersistence<T>::dump(streamtype &os) const {
  os << "{";
  bool emitComma = false;
  for (auto &t2n : this->conflicts) {
    if (emitComma)
      os << ", ";
    printHex(os, t2n.first);
    os << " |-> " << t2n.second;
    emitComma = true;
  }
  os << "}";
  return os;
}

///\see std::ostream& operator<<(std::ostream& os, const CacheSetAnalysis<T>& x)
template <CacheTraits *T, class streamtype>
inline streamtype &operator<<(streamtype &os,
                              const ConditionalMustPersistence<T> &x) {
  return x.dump(os);
}

} // namespace cache
} // namespace dom

} // namespace TimingAnalysisPass

#endif /*CONDITIONALMUSTPERSISTENCE_H*/
