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

#ifndef COMPOSITIONALANALYSIS_H_
#define COMPOSITIONALANALYSIS_H_

#include <algorithm>
#include <assert.h>
#include <iterator>
#include <ostream>

#include "Memory/Classification.h"
#include "Memory/PersistenceScopeInfo.h"
#include "Memory/UpdateReports.h"
#include "Memory/progana/Lattice.h"
#include "Memory/util/CacheSetAnalysisConcept.h"

namespace TimingAnalysisPass {

namespace dom {
namespace cache {

/**
 * \tparam A1 First cache set analysis
 * \tparam A2 Second cache set analysis
 *
 * \brief   Implements a cache set analysis using two compatible analyses to
 * achieve higher precision. \details Most common use-case is to combine a must-
 * and a may- analysis. However, it is perfectly legal to combine any two
 * analyses. \note    The order in which the analyses are specified may have an
 * influence on performance. Specify the analyses \p A1 and \p A2 such that \p
 * A1 will classify less tags as \c CL_UNKNOWN than \p A2. Normally, this means
 * that \p A1 should be the must analysis and \p A2 the may analysis.
 *
 * \todo More information exchange.
 */
template <class A1, class A2>
class CompositionalAbstractCache : public progana::JoinSemiLattice {
  typedef CompositionalAbstractCache<A1, A2> Self;

protected:
  typedef typename CacheTraits::TagType TagType;
  typedef A1 SetType1;
  typedef A2 SetType2;

  BOOST_CONCEPT_ASSERT((concepts::CacheSetAnalysis<SetType1>));
  BOOST_CONCEPT_ASSERT((concepts::CacheSetAnalysis<SetType2>));

  SetType1 analysis1;
  SetType2 analysis2;

public:
  using AnaDeps = std::pair<typename A1::AnaDeps *, typename A2::AnaDeps *>;

  explicit CompositionalAbstractCache(bool assumeAnEmptyCache = false);
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

  template <class Set> void getMustCache(Set &res) const {
    analysis1.getMustCache(res);
    analysis2.getMustCache(res);
  }

  template <class Set> void reduce(const Set &mustCache) {
    analysis1.reduce(mustCache);
    analysis2.reduce(mustCache);
  }
};

///\see dom::cache::CacheSetAnalysis<T>::CacheSetAnalysis(bool
///assumeAnEmptyCache)
template <class A1, class A2>
inline CompositionalAbstractCache<A1, A2>::CompositionalAbstractCache(
    bool assumeAnEmptyCache)
    : analysis1(assumeAnEmptyCache), analysis2(assumeAnEmptyCache) {}

///\see dom::cache::CacheSetAnalysis<T>::classify(const TagType tag) const
template <class A1, class A2>
Classification
CompositionalAbstractCache<A1, A2>::classify(const AbstractAddress addr) const {
  Classification cl = analysis1.classify(addr);
  if (cl != CL_UNKNOWN)
    return cl;
  return analysis2.classify(addr);
}

///\see dom::cache::CacheSetAnalysis<T>::update(const TagType tag, const
///Classification assumption)
template <class A1, class A2>
UpdateReport *CompositionalAbstractCache<A1, A2>::update(
    const AbstractAddress addr, AccessType load_store, AnaDeps *Deps,
    bool wantReport, const Classification assumption) {

#ifdef NO_REDUCTIONS
  Classification cl = assumption;
#else
  Classification cl = (assumption == CL_UNKNOWN) ? classify(addr) : assumption;
  assert(cl != CL_BOT);
#endif

  typename A1::AnaDeps *Deps1 = nullptr;
  typename A2::AnaDeps *Deps2 = nullptr;
  if (Deps) {
    Deps1 = Deps->first;
    Deps2 = Deps->second;
  }
  UpdateReport *report =
      analysis1.update(addr, load_store, Deps1, wantReport, cl);
  UpdateReport *report2 =
      analysis2.update(addr, load_store, Deps2, wantReport, cl);

  if (!wantReport) {
    assert(!report && !report2);
    return nullptr;
  }

  JoinableUpdateReport *jreport = dynamic_cast<JoinableUpdateReport *>(report);
  /* The underlying reports are not joinable. Discard their reports and
   * return the generic report. */
  if (!jreport) {
    delete report;
    delete report2;
    return new UpdateReport;
  }

  jreport->join(dynamic_cast<JoinableUpdateReport *>(report2));
  delete report2;
  return jreport;
}

template <class A1, class A2>
UpdateReport *CompositionalAbstractCache<A1, A2>::potentialUpdate(
    AbstractAddress addr, AccessType load_store, bool wantReport) {
  UpdateReport *report1 =
      analysis1.potentialUpdate(addr, load_store, wantReport);
  UpdateReport *report2 =
      analysis2.potentialUpdate(addr, load_store, wantReport);

  if (!wantReport) {
    assert(!report1 && !report2);
    return nullptr;
  }

  JoinableUpdateReport *jreport = dynamic_cast<JoinableUpdateReport *>(report1);
  /* The underlying reports are not joinable. Discard their reports and
   * return the generic report. */
  if (!jreport) {
    delete report1;
    delete report2;
    return new UpdateReport;
  }

  jreport->join(dynamic_cast<JoinableUpdateReport *>(report2));
  delete report2;
  return jreport;
}

///\see dom::cache::CacheSetAnalysis<T>::join(const Self& y)
template <class A1, class A2>
inline void CompositionalAbstractCache<A1, A2>::join(const Self &y) {
  analysis1.join(y.analysis1);
  analysis2.join(y.analysis2);
}

template <class A1, class A2>
inline bool CompositionalAbstractCache<A1, A2>::lessequal(const Self &y) const {
  return analysis1.lessequal(y.analysis1) && analysis2.lessequal(y.analysis2);
}

template <class A1, class A2>
inline void
CompositionalAbstractCache<A1, A2>::enterScope(const PersistenceScope &scope) {
  analysis1.enterScope(scope);
  analysis2.enterScope(scope);
}

template <class A1, class A2>
inline void
CompositionalAbstractCache<A1, A2>::leaveScope(const PersistenceScope &scope) {
  analysis1.leaveScope(scope);
  analysis2.leaveScope(scope);
}

template <class A1, class A2>
std::set<PersistenceScope>
CompositionalAbstractCache<A1, A2>::getPersistentScopes(
    const TagType tag) const {
  auto res1 = analysis1.getPersistentScopes(tag);
  auto res2 = analysis2.getPersistentScopes(tag);
  res1.insert(res2.begin(), res2.end());
  return res1;
}
template <class A1, class A2>
std::set<PersistenceScope>
CompositionalAbstractCache<A1, A2>::getPersistentScopes(
    const GlobalVariable *var) const {
  auto res1 = analysis1.getPersistentScopes(var);
  auto res2 = analysis2.getPersistentScopes(var);
  res1.insert(res2.begin(), res2.end());
  return res1;
}

///\see dom::cache::CacheSetAnalysis<T>::operator==(const Self& y) const
template <class A1, class A2>
inline bool
CompositionalAbstractCache<A1, A2>::operator==(const Self &y) const {
  return analysis1 == y.analysis1 && analysis2 == y.analysis2;
}

///\see dom::cache::CacheSetAnalysis<T>::operator<(const Self& y) const
template <class A1, class A2>
inline bool CompositionalAbstractCache<A1, A2>::operator<(const Self &y) const {
  if (analysis1 < y.analysis1)
    return true;
  if (y.analysis1 < analysis1)
    return false;
  return analysis2 < y.analysis2;
}

/////\see dom::cache::CacheSetAnalysis<T>::hash() const
// template <class A1, class A2>
// inline std::size_t CompositionalAbstractCache<A1, A2>::hash() const
//{
//	return analysis1.hash() ^ analysis2.hash();
// }

///\see dom::cache::CacheSetAnalysis<T>::dump(std::ostream& os) const
template <class A1, class A2>
inline std::ostream &
CompositionalAbstractCache<A1, A2>::dump(std::ostream &os) const {
  return os << analysis1 << " " << analysis2;
}

///\see std::ostream& operator<<(std::ostream& os, const CacheSetAnalysis<T>& x)
template <class A1, class A2>
inline std::ostream &operator<<(std::ostream &os,
                                const CompositionalAbstractCache<A1, A2> &x) {
  return x.dump(os);
}

} // namespace cache
} // namespace dom

} // namespace TimingAnalysisPass

#endif /*COMPOSITIONALANALYSIS_H_*/
