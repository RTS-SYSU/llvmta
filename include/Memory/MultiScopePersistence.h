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

#ifndef MULTISCOPEPERSISTENCE_H
#define MULTISCOPEPERSISTENCE_H

#include <algorithm>
#include <ostream>
#include <set>

#include "Memory/Classification.h"
#include "Memory/progana/Lattice.h"
#include "Memory/util/ImplicitSet.h"

/**
 * Using this macro you can enable strict scope consistency, i.e.
 * a scope cannot be entered if it has been entered already without leaving.
 * In general, this is desirable to find potential bugs.
 * However, due to our scope handling, this leads to problems for special
 * testcases (nested2.c) when using the out-of-order pipeline that has a
 * relatively large instruction window. We start scopes (speculatively) when we
 * cross a BB-edge during fetch, and we end scopes (either when misspeculated
 * or) when we commit instructions that cross a BB-edge. So it might happen,
 * that during an iteration, we already want to enter a scope for the second
 * time although we haven't yet left for the first time (instructions still
 * in-flight). This throws an assertion in strict consistency mode. If disabled,
 * we count how often we entered, and upon leaving we first decrement this
 * number before actually closing the scope.
 */
//#define STRICT_SCOPE_CONSISTENCY

namespace TimingAnalysisPass {

namespace dom {
namespace cache {

/**
 * \tparam P persistence analysis type
 *
 * \brief   Implements a multi-scope wrapper for existing persistence analyses.
 */
template <class P>
class MultiScopePersistence : public progana::JoinSemiLattice {
  typedef MultiScopePersistence Self;

protected:
  typedef typename CacheTraits::TagType TagType;

  std::map<const PersistenceScope, P> scopes2info;

#ifndef STRICT_SCOPE_CONSISTENCY
  std::map<const PersistenceScope, unsigned> scopes2entercount;
#endif

public:
  using AnaDeps = std::tuple<>;
  explicit MultiScopePersistence(bool assumeAnEmptyCache = false);
  Classification classify(const AbstractAddress addr) const;
  UpdateReport *update(const AbstractAddress addr, AccessType load_store,
                       AnaDeps *, bool wantReport = false,
                       const Classification assumption = CL_UNKNOWN);
  UpdateReport *potentialUpdate(AbstractAddress addr, AccessType load_store,
                                bool wantReport = false);
  void join(const Self &y);
  bool lessequal(const Self &y) const;
  void enterScope(const PersistenceScope &scope);
  void leaveScope(const PersistenceScope &scope);
  std::set<PersistenceScope> getPersistentScopes(const TagType tag) const;
  std::set<PersistenceScope>
  getPersistentScopes(const GlobalVariable *var) const;
  bool operator==(const Self &y) const;
  bool operator<(const Self &y) const;
  std::ostream &dump(std::ostream &os) const;
};

///\see dom::cache::CacheSetAnalysis<P>::CacheSetAnalysis(bool
///assumeAnEmptyCache)
template <class P>
inline MultiScopePersistence<P>::MultiScopePersistence(bool assumeAnEmptyCache
                                                       __attribute__((unused)))
    : scopes2info()
#ifndef STRICT_SCOPE_CONSISTENCY
      ,
      scopes2entercount()
#endif
{
}

///\see dom::cache::CacheSetAnalysis<P>::classify(const TagType tag) const
template <class P>
Classification
MultiScopePersistence<P>::classify(const AbstractAddress addr) const {
  return CL_UNKNOWN; // cannot help here
}

/**
 * \brief Simulates an update to an unknown cache element, increase the age of
 * all elements
 */
template <class P>
UpdateReport *MultiScopePersistence<P>::potentialUpdate(AbstractAddress addr,
                                                        AccessType load_store,
                                                        bool wantReport) {
  for (auto &scope2info : scopes2info) {
    scope2info.second.potentialUpdate(addr, load_store, false);
  }
  // Should we join the underlying reports instead of returning null?
  return wantReport ? new UpdateReport : nullptr;
}

///\see dom::cache::CacheSetAnalysis<P>::update(const TagType tag, const
///Classification assumption)
template <class P>
UpdateReport *MultiScopePersistence<P>::update(
    const AbstractAddress addr, AccessType load_store, AnaDeps *Deps,
    bool wantReport, const Classification assumption) {
  for (auto &scope2info : scopes2info) {
    scope2info.second.update(addr, load_store, Deps, false, assumption);
  }
  // Should we join the underlying reports instead of returning null?
  return wantReport ? new UpdateReport : nullptr;
}

///\see dom::cache::CacheSetAnalysis<P>::join(const Self& y)
template <class P> void MultiScopePersistence<P>::join(const Self &y) {
  // TODO eliminate
  // std::cerr << "Want to join:\n" << *this << "\nand\n" << y << "\n";
  assert(this->scopes2info.size() == y.scopes2info.size() &&
         "Different #of scopes at join");

#ifndef STRICT_SCOPE_CONSISTENCY
  auto ecit1 = this->scopes2entercount.begin();
  auto ecit2 = y.scopes2entercount.begin();
  for (; ecit1 != this->scopes2entercount.end(); ++ecit1, ++ecit2) {
    assert(ecit1->second == ecit2->second &&
           "Joining two same scopes that have been entered differently often.");
  }
#endif

  auto it1 = this->scopes2info.begin();
  auto it2 = y.scopes2info.begin();
  for (; it1 != this->scopes2info.end(); ++it1, ++it2) {
    assert(it1->first == it2->first &&
           "Encountered differrent scopes at join.");
    it1->second.join(it2->second);
  }
}

template <class P>
inline bool MultiScopePersistence<P>::lessequal(const Self &y) const {
  assert(this->scopes2info.size() == y.scopes2info.size() &&
         "Different #of scopes at lessequal");

#ifndef STRICT_SCOPE_CONSISTENCY
  auto ecit1 = this->scopes2entercount.begin();
  auto ecit2 = y.scopes2entercount.begin();
  for (; ecit1 != this->scopes2entercount.end(); ++ecit1, ++ecit2) {
    assert(
        ecit1->second == ecit2->second &&
        "Comparing two same scopes that have been entered differently often.");
  }
#endif

  auto it1 = this->scopes2info.begin();
  auto it2 = y.scopes2info.begin();
  for (; it1 != this->scopes2info.end(); ++it1, ++it2) {
    assert(it1->first == it2->first &&
           "Encountered differrent scopes at lessequal.");
    if (!it1->second.lessequal(it2->second)) {
      return false;
    }
  }
  return true;
}

template <class P>
void MultiScopePersistence<P>::enterScope(const PersistenceScope &scope) {
#ifdef STRICT_SCOPE_CONSISTENCY
  assert(scopes2info.count(scope) == 0 && "Entered scope twice");
  scopes2info.insert(std::make_pair(scope, P()));
#else
  if (scopes2info.count(scope) == 0) {
    scopes2info.insert(std::make_pair(scope, P()));
    scopes2entercount.insert(std::make_pair(scope, 1));
  } else {
    ++scopes2entercount[scope];
  }
#endif
}

template <class P>
void MultiScopePersistence<P>::leaveScope(const PersistenceScope &scope) {
  assert(scopes2info.count(scope) > 0 && "Left scope already");
#ifdef STRICT_SCOPE_CONSISTENCY
  scopes2info.erase(scope);
#else
  if (scopes2entercount.at(scope) > 1) {
    --scopes2entercount[scope];
  } else {
    scopes2info.erase(scope);
    scopes2entercount.erase(scope);
  }
#endif
}

template <class P>
std::set<PersistenceScope>
MultiScopePersistence<P>::getPersistentScopes(const TagType tag) const {
  std::set<PersistenceScope> result;
  for (auto &scope2pers : this->scopes2info) {
    if (scope2pers.second.isPersistent(tag)) {
      result.insert(scope2pers.first);
    }
  }
  return result;
}

template <class P>
std::set<PersistenceScope>
MultiScopePersistence<P>::getPersistentScopes(const GlobalVariable *var) const {
  std::set<PersistenceScope> result;
  for (auto &scope2pers : this->scopes2info) {
    if (scope2pers.second.isPersistent(var)) {
      result.insert(scope2pers.first);
    }
  }
  return result;
}

///\see dom::cache::CacheSetAnalysis<P>::operator==(const Self& y) const
template <class P>
inline bool MultiScopePersistence<P>::operator==(const Self &y) const {
  assert(this->scopes2info.size() == y.scopes2info.size() &&
         "Different #of scopes at equal");

#ifndef STRICT_SCOPE_CONSISTENCY
  auto ecit1 = this->scopes2entercount.begin();
  auto ecit2 = y.scopes2entercount.begin();
  for (; ecit1 != this->scopes2entercount.end(); ++ecit1, ++ecit2) {
    assert(ecit1->second == ecit2->second &&
           "Joining two same scopes that have been entered differently often.");
  }
#endif

  auto it1 = this->scopes2info.begin();
  auto it2 = y.scopes2info.begin();
  for (; it1 != this->scopes2info.end(); ++it1, ++it2) {
    assert(it1->first == it2->first &&
           "Encountered differrent scopes at equal.");
    if (!(it1->second == it2->second)) {
      return false;
    }
  }
  return true;
}

///\see dom::cache::CacheSetAnalysis<P>::operator<(const Self& y) const
template <class P>
inline bool MultiScopePersistence<P>::operator<(const Self &y) const {
  if (this->scopes2info.size() != y.scopes2info.size()) {
    return this->scopes2info.size() < y.scopes2info.size();
  }
  auto it1 = this->scopes2info.begin();
  auto it2 = y.scopes2info.begin();
  for (; it1 != this->scopes2info.end(); ++it1, ++it2) {
    if (!(it1->first == it2->first)) {
      return it1->first < it2->first;
    }
    if (!(it1->second == it2->second)) {
      return it1->second < it2->second;
    }
#ifndef STRICT_SCOPE_CONSISTENCY
    if (!(this->scopes2entercount.at(it1->first) ==
          y.scopes2entercount.at(it2->first))) {
      return this->scopes2entercount.at(it1->first) <
             y.scopes2entercount.at(it2->first);
    }
#endif
  }

  return false;
}

///\see dom::cache::CacheSetAnalysis<P>::dump(std::ostream& os) const
template <class P>
std::ostream &MultiScopePersistence<P>::dump(std::ostream &os) const {
  os << "[";
  bool emitComma = false;
  for (auto &scope2info : this->scopes2info) {
    if (emitComma)
      os << ", ";
#ifdef STRICT_SCOPE_CONSISTENCY
    os << "Scope " << scope2info.first.getId() << ": " << scope2info.second;
#else
    os << "Scope " << scope2info.first.getId() << "(entered "
       << scopes2entercount.at(scope2info.first) << "): " << scope2info.second;
#endif
    emitComma = true;
  }
  os << "]";
  return os;
}

///\see std::ostream& operator<<(std::ostream& os, const CacheSetAnalysis<P>& x)
template <class P>
inline std::ostream &operator<<(std::ostream &os,
                                const MultiScopePersistence<P> &x) {
  return x.dump(os);
}

} // namespace cache
} // namespace dom

} // namespace TimingAnalysisPass

#endif /*MULTISCOPEPERSISTENCE_H_*/
