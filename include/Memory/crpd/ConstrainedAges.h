////////////////////////////////////////////////////////////////////////////////
//
//   LLVMTA - Timing Analyser performing worst-case execution time analysis
//     using the LLVM backend intermediate representation
//
// Copyright (C) 2013-2022  Saarland University
// Copyright (C) 2016			 Tina Jung
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

#ifndef CONSTRAINED_AGES_H
#define CONSTRAINED_AGES_H

#include <ostream>

#include "llvm/Support/Debug.h"

#include "Memory/Classification.h"
#include "Memory/LruMaxAgeAbstractCache.h"
#include "Memory/progana/Lattice.h"

#include "Util/PersistenceScope.h"

namespace TimingAnalysisPass {

namespace dom {
namespace cache {

/**
 * \tparam T Cache traits
 *
 * \brief Implements a constrained age analysis.
 *
 * Constrained ages are defined for useful cache blocks, they describe the age
 * for the block on a path where they are not evicited. For this reason the
 * constrained age is a lower bound on the actual age and to correct this a
 * unconstrained age is considered as an additional information (unconstrained
 * age = must analysis information). This analysis is used to find information
 * about useful cache blocks that may be evicted (and therefore lead to
 * additional misses) under preemption.
 */
template <CacheTraits *T>
class ConstrainedAges : public progana::JoinSemiLattice {
  typedef ConstrainedAges<T> Self;

protected:
  unsigned ASSOCIATIVITY = T->ASSOCIATIVITY;

  using TagType = typename CacheTraits::TagType;

public:
  using Age = unsigned;
  /**
   * UCB information at a specific set
   */
  using UCBsSet = ImplicitSet<TagType>;
  /**
   * Must Analysis results
   */
  using UnconstrainedInfo = LruMaxAgeAbstractCache<T>;
  /**
   * Additional information that the analysis needs to compute its results
   */
  using AnaDeps = std::tuple<const UCBsSet &, const UnconstrainedInfo &>;

  /* Implement the interface */
  explicit ConstrainedAges(bool assumeAnEmptyCache = false);
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

  /* Constrained age specific functions */

  /**
   * \param tag The tag of the memory block the age should be looked up for.
   * \return The constrained age of tag.
   */
  auto getConstrainedAge(const TagType tag) const -> Age;

protected:
  /**
   * True, if we cannot give any precise information about this cache set.
   */
  bool top;
  /**
   * Holds the constrained ages for UCBs. If a tag is not included,
   * the age is zero.
   */
  std::map<TagType, Age> CAges;

private:
  /**
   * \brief Throw the collected information away (e.g. on updateUnknown).
   */
  void setTop();
};

template <CacheTraits *T>
inline ConstrainedAges<T>::ConstrainedAges(bool) : top(false) {}

/**
 * \see  dom::cache::CacheSetAnalysis<T>::classify(const TagType tag) const
 */
template <CacheTraits *T>
auto ConstrainedAges<T>::classify(const AbstractAddress) const
    -> Classification {
  return CL_UNKNOWN; // Not the use case for this analysis
}

/**
 * \brief Simulates an update to an unknown cache element, increase the age of
 * all elements
 */
template <CacheTraits *T>
UpdateReport *ConstrainedAges<T>::potentialUpdate(AbstractAddress addr,
                                                  AccessType load_store,
                                                  bool wantReport) {
  // No information is given about the useful cache blocks, we cannot do
  // anything here
  setTop();
  return wantReport ? new UpdateReport() : nullptr;
}

/**
 * \see dom::cache::CacheSetAnalysis<T>::update(const TagType tag, const
 * Classification assumption)
 */
template <CacheTraits *T>
UpdateReport *ConstrainedAges<T>::update(const AbstractAddress addr,
                                         AccessType load_store,
                                         AnaDeps *AddInfo, bool wantReport,
                                         const Classification) {
  TagType tag = getTag<T>(addr);
  assert(AddInfo);

  /* this function does not use reports - if one is requested create an
   * empty one */
  UpdateReport *report = wantReport ? new UpdateReport : nullptr;

  // Nothing to update
  if (top) {
    return report;
  }

  const auto &UCBs = std::get<0>(*AddInfo);
  const auto &UAges = std::get<1>(*AddInfo);

  // If we have no useful cache blocks, all ages are 0 (top information)
  if (UCBs.size() == 0) {
    setTop();
    return report;
  }

  DEBUG_WITH_TYPE("ca", {
    std::cout << "Constrained age update with: {";
    auto comma = "";
    for (const auto &X : UCBs) {
      std::cout << comma << X;
      comma = ", ";
    }
    std::cout << "}" << std::endl;

    std::cout << " Ages: " << UAges << " CurrentInfos: {";
    comma = "";
    for (const auto &Elem : CAges) {
      std::cout << comma << "UCB: " << Elem.first << " Age: " << Elem.second;
      comma = ", ";
    }
    std::cout << "}" << std::endl;
  });

  // unconstrained age lookup
  auto UAge = UAges.getMaxAge(tag);

  std::map<TagType, unsigned> TempCAges;

  for (unsigned U : UCBs) {

    // We accessed this UCB just now, so the age is zero
    if (U == tag) {
      TempCAges[tag] = 0;
      continue;
    }

    // constrained age lookup
    unsigned CAge = 0;
    if (CAges.find(U) != CAges.end()) {
      CAge = CAges.at(U);
    }

    // update the age taking the unconstrained information into account
    if (CAge >= UAge || CAge == ASSOCIATIVITY - 1) {
      TempCAges[U] = CAge;
    } else {
      TempCAges[U] = CAge + 1;
    }
  }

  // Overwrite the old CAges to remove elements
  // not contained in the new UCBs (<-> set them zero)
  CAges = TempCAges;

  DEBUG_WITH_TYPE("ca", {
    std::cout << "Update Result: {";
    auto comma = "";
    for (const auto &Elem : CAges) {
      std::cout << comma << "UCB: " << Elem.first << " Age: " << Elem.second;
      comma = ", ";
    }
    std::cout << "}" << std::endl;
  });

  return report;
}

// Choose the maximal age for each element in UCBs
/**
 * \see dom::cache::CacheSetAnalysis<T>::join(const Self& y)
 */
template <CacheTraits *T> void ConstrainedAges<T>::join(const Self &Other) {
  DEBUG_WITH_TYPE("ca", {
    std::cout << "Constrained Age join.\n" << std::endl;
  });
  // The result is already the least precise information
  if (top) {
    DEBUG_WITH_TYPE("ca", { std::cout << "Info is top." << std::endl; });
    return;
  }

  // We join with top
  if (Other.top) {
    DEBUG_WITH_TYPE("ca", { std::cout << "Other info is top." << std::endl; });
    setTop();
    return;
  }

  DEBUG_WITH_TYPE("ca", {
    std::cout << "Join self:";
    dump(std::cout);
    std::cout << std::endl << "Other: ";
    Other.dump(std::cout);
    std::cout << std::endl;
  });

  for (auto &KV : CAges) {
    auto Age = KV.second;

    // Check if the other map also contains this element
    if (Other.CAges.find(KV.first) != Other.CAges.end()) {
      auto OtherAge = Other.CAges.at(KV.first);
      if (Age < OtherAge) {
        CAges[KV.first] = OtherAge;
      }
    }
  }

  for (auto &KV : Other.CAges) {

    // We do not have this key, so the cost is currently zero, we need to take
    // the cost of the other one
    if (CAges.find(KV.first) == CAges.end()) {
      CAges[KV.first] = KV.second;
    }
  }

  DEBUG_WITH_TYPE("ca", {
    std::cout << "Result: ";
    dump(std::cout);
    std::cout << "\n" << std::endl;
  });
}

template <CacheTraits *T>
inline bool ConstrainedAges<T>::lessequal(const Self &y) const {
  Self copy(*this);
  copy.join(y);
  return copy == y;
}

template <CacheTraits *T>
auto ConstrainedAges<T>::getPersistentScopes(const Address) const
    -> std::set<PersistenceScope> {
  return {}; // Not the use case for this analysis
}

template <CacheTraits *T>
auto ConstrainedAges<T>::getPersistentScopes(const GlobalVariable *) const
    -> std::set<PersistenceScope> {
  return {}; // Not the use case for this analysis
}

/**
 * \see dom::cache::CacheSetAnalysis<T>::operator==(const Self& y) const
 */
template <CacheTraits *T>
inline bool ConstrainedAges<T>::operator==(const Self &Other) const {
  return (top == Other.top) && (CAges.size() == Other.CAges.size()) &&
         (std::equal(CAges.begin(), CAges.end(), Other.CAges.begin()));
}

// all zero < some ordering < all infty
/**
 * \see dom::cache::CacheSetAnalysis<T>::operator<(const Self& y) const
 */
template <CacheTraits *T>
inline bool ConstrainedAges<T>::operator<(const Self &Other) const {

  // Largest value, cannot be strictly smaller than anything
  if (top) {
    return false;
  }

  // The cache is top and this one isn't
  if (Other.top) {
    return true;
  }

  // Fall back on the map op<
  return CAges < Other.CAges;
}

/**
 * \see dom::cache::CacheSetAnalysis<T>::dump(std::ostream& os) const
 */
template <CacheTraits *T>
auto ConstrainedAges<T>::dump(std::ostream &os) const -> std::ostream & {

  os << "[";
  if (top) {
    os << "Top";
  } else {
    auto Comma = "";
    for (const auto &Entry : CAges) {
      os << Comma << "(" << Entry.first << ", " << Entry.second << ")";
      Comma = ", ";
    }
  }
  os << "]";

  return os;
}

/**
 * \see std::ostream& operator<<(std::ostream& os, const CacheSetAnalysis<T>& x)
 */
template <CacheTraits *T>
inline std::ostream &operator<<(std::ostream &os, const ConstrainedAges<T> &x) {
  return x.dump(os);
}

template <CacheTraits *T>
unsigned ConstrainedAges<T>::getConstrainedAge(const TagType tag) const {

  if (CAges.find(tag) != CAges.end()) {
    return CAges.at(tag);
  }

  return 0;
}

template <CacheTraits *T> void ConstrainedAges<T>::setTop() {
  CAges.clear();
  top = true;
}

} // namespace cache
} // namespace dom

} // namespace TimingAnalysisPass

#endif /*CONSTRAINED_AGES_H*/
