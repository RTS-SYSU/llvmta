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

#ifndef SETWISECOUNTINGPERSISTENCE_H
#define SETWISECOUNTINGPERSISTENCE_H

#include <algorithm>
#include <ostream>
#include <set>

#include "Memory/Classification.h"
#include "Memory/UpdateReports.h"
#include "Memory/progana/Lattice.h"
#include "Memory/util/CacheUtils.h"
#include "Memory/util/ImplicitSet.h"
#include "Util/GlobalVars.h"
#include "Util/Options.h"
#include "Util/PersistenceScope.h"

namespace TimingAnalysisPass {

namespace dom {
namespace cache {

/**
 * \tparam T Cache traits
 *
 * \brief   Implements a very simple LRU persistence analysis based on counting
 * accesses per set.
 *
 */
template <CacheTraits *T>
class SetWiseCountingPersistence : public progana::JoinSemiLattice {
  typedef SetWiseCountingPersistence<T> Self;

protected:
  unsigned ASSOCIATIVITY = T->ASSOCIATIVITY;
  const CacheTraits *CacheConfig = T;
  // jjy: 在进行争用集分析时我们需要知道引用所在set的index
  unsigned r;

  typedef typename CacheTraits::WayType WayType;
  typedef typename CacheTraits::TagType TagType;
  typedef typename CacheTraits::PosType PosType;

  /* Struct describing a memory block. Among blocks of the same cache
   * set it is uniquely identified by its tag.
   * As an optimization, each block also contains the arrays it is
   * a member of. If arrays do not overlap these should be two at most.
   * Knowledge of the surrounding arrays is required for the array-aware
   * persistence analysis*/
  struct Block {
    TagType tag;
    std::vector<const GlobalVariable *> surroundingArrays;
    explicit Block(AbstractAddress addr) {
      assert(addr.isPrecise());
      Address address = getCachelineAddress<T>(addr.getAsInterval().lower());
      this->tag = getTag<T>(address);
      if (ArrayPersistenceAnalysis == ArrayPersistenceAnaType::NONE) {
        return;
      }
      for (const GlobalVariable *arr :
           StaticAddrProvider->getGlobalVariables()) {
        Address start = StaticAddrProvider->getGlobalVarAddress(arr);
        Address end = start + StaticAddrProvider->getArraySize(arr) - 1;
        Address startLine = getCachelineAddress<T>(start);
        Address endLine = getCachelineAddress<T>(end);
        /* we don't care about sub-cacheline arrays */
        if (startLine == endLine) {
          continue;
        }
        if (address >= startLine && address <= endLine) {
          surroundingArrays.push_back(arr);
        }
      }
      /* if the array is not sorted, equality comparison
       * becomes needlessly complicated */
      assert(
          std::is_sorted(surroundingArrays.begin(), surroundingArrays.end()));
    }
    /* Both comparison operations have to take surroundingArrays
     * into account since they might be used between different
     * cachesets, where the same tag means different things */
    bool operator<(const Block &other) const {
      if (this->tag == other.tag) {
        return this->surroundingArrays < other.surroundingArrays;
      }
      return this->tag < other.tag;
    }
    bool operator==(const Block &other) const {
      return this->tag == other.tag &&
             this->surroundingArrays == other.surroundingArrays;
    }
    template <class stream> void dump(stream &os) const {
      os << tag;
      if (surroundingArrays.size() > 0) {
        bool emitComma = false;
        os << "(";
        for (const GlobalVariable *arr : surroundingArrays) {
          if (emitComma)
            os << ",";
          os << arr->getName().str();
          emitComma = true;
        }
        os << ")";
      }
    }
  };

  /// If top is set, accessedTags is irrelevant, we cannot make any
  /// classification
  bool top;
  /// If not top, then accessedTags contains the accessed tags within this scope
  std::set<Block> accessedBlocks;
  /* for each datastructure: how many accesses to this array have we observed
   * so far? If this reaches the size of the datastructure we can ignore
   * future accesses */
  std::multiset<const GlobalVariable *> accessedArrays;

  void gotoTop() {
    this->top = true;
    this->accessedBlocks.clear();
    this->accessedArrays.clear();
    // std::cerr << "(" << T->ASSOCIATIVITY << ")";
  }

  unsigned getPerArrayBound(const GlobalVariable *array) {
    int bound = getPerSetSize<T>(array);
    for (const Block &b : accessedBlocks) {
      bound -= std::count(b.surroundingArrays.begin(),
                          b.surroundingArrays.end(), array);
    }
    assert(bound >= 0);
    return (unsigned)bound;
  }

public:
  // bool isl2;
  using AnaDeps = std::tuple<>;
  explicit SetWiseCountingPersistence(unsigned addr = 0,
                                      bool assumeAnEmptyCache = false);
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

  int getCSS(const TagType tag) const {
    return accessedBlocks.size() + accessedArrays.size();
  }

  int getCSS(const GlobalVariable *var) const {
    return accessedBlocks.size() + accessedArrays.size();
  }

  int getAge(const AbstractAddress addr) const { return -1; }
  bool isPersistent(const GlobalVariable *var) const;
  bool operator==(const Self &y) const;
  bool operator<(const Self &y) const;
  template <typename streamtype> streamtype &dump(streamtype &os) const;
};

///\see dom::cache::CacheSetAnalysis<T>::CacheSetAnalysis(bool
/// assumeAnEmptyCache)
template <CacheTraits *T>
inline SetWiseCountingPersistence<T>::SetWiseCountingPersistence(
    unsigned addr, bool assumeAnEmptyCache __attribute__((unused)))
    : top(false), r(addr), accessedBlocks(), accessedArrays() {}

///\see dom::cache::CacheSetAnalysis<T>::classify(const TagType tag) const
template <CacheTraits *T>
Classification
SetWiseCountingPersistence<T>::classify(const AbstractAddress addr) const {
  return CL_UNKNOWN; // cannot help here
}

/**
 * \brief Simulates an update to an unknown cache element, increase the age of
 * all elements
 */
template <CacheTraits *T>
UpdateReport *SetWiseCountingPersistence<T>::potentialUpdate(
    AbstractAddress addr, AccessType load_store, bool wantReport) {
  if (top) {
    return wantReport ? new UpdateReport : nullptr;
  }

  if (ArrayPersistenceAnalysis == ArrayPersistenceAnaType::NONE ||
      !addr.isArray()) {
    /* give up */
    this->gotoTop();
    // std::cerr << "(" << T->ASSOCIATIVITY << ")";
    return wantReport ? new UpdateReport : nullptr;
  }

  const GlobalVariable *array = addr.getArray();
  /* only update if we can have more accesses to array */
  if (accessedArrays.count(array) < getPerArrayBound(array)) {
    if (accessedBlocks.size() + accessedArrays.size() > T->ASSOCIATIVITY) {
      this->gotoTop();
      // std::cerr << "(" <<T->LEVEL<<"|"<< T->ASSOCIATIVITY << ")";
    } else {
      accessedArrays.insert(array);
    }
  }

  return wantReport ? new UpdateReport : nullptr;
}

///\see dom::cache::CacheSetAnalysis<T>::update(const TagType tag, const
/// Classification assumption)
template <CacheTraits *T>
UpdateReport *SetWiseCountingPersistence<T>::update(
    const AbstractAddress addr, AccessType load_store, AnaDeps *,
    bool wantReport, const Classification assumption __attribute__((unused))) {
  // std::cerr << "(" << T->LEVEL << "|" << T->ASSOCIATIVITY << ")";
  if (top) {
    return wantReport ? new UpdateReport : nullptr;
  }
  if (r != 0) {
    assert(getindex<T>(r) == getindex<T>(addr) &&
           "冲突的内存引用应该映射到同一个缓存集");
  }

  bool inserted;
  std::tie(std::ignore, inserted) = accessedBlocks.insert(Block(addr));

  if (inserted) {
    if (accessedBlocks.size() + accessedArrays.size() > T->ASSOCIATIVITY) {
      this->gotoTop();
      // std::cerr << "(" << T->LEVEL << "|" << T->ASSOCIATIVITY << ")";
    }
  }
  return wantReport ? new UpdateReport : nullptr;
}

///\see dom::cache::CacheSetAnalysis<T>::join(const Self& y)
template <CacheTraits *T>
void SetWiseCountingPersistence<T>::join(const Self &y) {
  if (this->top || y.top) {
    // std::cerr << "(" << T->ASSOCIATIVITY << ")";
    this->gotoTop();
    return;
  }

  this->accessedBlocks.insert(y.accessedBlocks.begin(), y.accessedBlocks.end());

  if (ArrayPersistenceAnalysis != ArrayPersistenceAnaType::NONE) {
    /* join the accessedArrays sets. This is not a set union, since we
     * want to match up equal elements on both sides (i.e. {A} join {A} = {A})
     */
    std::multiset<const GlobalVariable *> toAdd;
    std::set_difference(y.accessedArrays.begin(), y.accessedArrays.end(),
                        this->accessedArrays.begin(),
                        this->accessedArrays.end(),
                        std::inserter(toAdd, toAdd.begin()));
    this->accessedArrays.insert(toAdd.begin(), toAdd.end());

    /* make sure we still honor the bound */
    /* TODO this is inefficient */
    auto it = accessedArrays.begin();
    while (it != accessedArrays.end()) {
      if (accessedArrays.count(*it) > getPerArrayBound(*it)) {
        it = accessedArrays.erase(it);
      } else {
        it++;
      }
    }
  }

  if (accessedBlocks.size() + accessedArrays.size() > T->ASSOCIATIVITY) {
    // std::cerr << "(" << T->ASSOCIATIVITY << ")";
    this->gotoTop();
  }
}

template <CacheTraits *T>
inline bool SetWiseCountingPersistence<T>::lessequal(const Self &y) const {
  SetWiseCountingPersistence<T> copy(*this);
  copy.join(y);
  return copy == y;
}

template <CacheTraits *T>
inline bool
SetWiseCountingPersistence<T>::isPersistent(const TagType tag) const {
  // jjy: 我们考虑除了层一cache其他都是共享cache
  if (SPersistenceA && CoreNums > 0 && T->LEVEL > 1) {
    unsigned index = getindex<T>(r);
    if (top) {
      return false;
    }
    unsigned CNN = 0;
    // 计算CNN
    if (MulCType == MultiCoreType::LiangY) {
      for (int i = 0; i < mcif.coreinfo.size(); i++) {
        if (i == CurrentCore) {
          continue;
        }
        for (std::string entry : mcif.coreinfo[i]) {
          for (functionaddr *f : functiontofs[entry]) {
            for (unsigned address : f->addrlist) {
              if (getindex<T>(address) == index && getTag<T>(address) != tag) {
                CNN++;
              }
            }
          }
        }
      }
    } else {
      // 张伟的方法不管持久性的块
    }

    if (accessedBlocks.size() + accessedArrays.size() + CNN <=
        T->ASSOCIATIVITY) {
      return true;
    }
    return false;
  } else {
    return !top;
  }
}

template <CacheTraits *T>
inline bool
SetWiseCountingPersistence<T>::isPersistent(const GlobalVariable *var) const {
  return !top;
}

///\see dom::cache::CacheSetAnalysis<T>::operator==(const Self& y) const
template <CacheTraits *T>
inline bool SetWiseCountingPersistence<T>::operator==(const Self &y) const {
  // jjy:持久性分析需要知道针对的是哪一个内存引用
  if (this->r != y.r) {
    return false;
  }
  if (this->top || y.top) {
    return this->top == y.top;
  }
  return this->accessedBlocks == y.accessedBlocks &&
         this->accessedArrays == y.accessedArrays;
}

///\see dom::cache::CacheSetAnalysis<T>::operator<(const Self& y) const
template <CacheTraits *T>
inline bool SetWiseCountingPersistence<T>::operator<(const Self &y) const {
  if (this->r != y.r) {
    return this->r < y.r;
  }
  if (this->top || y.top)
    return !this->top;

  if (this->accessedBlocks != y.accessedBlocks) {
    return this->accessedBlocks < y.accessedBlocks;
  }
  if (this->accessedArrays != y.accessedArrays) {
    return this->accessedArrays < y.accessedArrays;
  }

  return false;
}

///\see dom::cache::CacheSetAnalysis<T>::dump(std::ostream& os) const
template <CacheTraits *T>
template <class streamtype>
streamtype &SetWiseCountingPersistence<T>::dump(streamtype &os) const {
  if (this->top) {
    os << "T";
  } else {
    os << "{";
    bool emitComma = false;
    for (const Block &b : this->accessedBlocks) {
      if (emitComma)
        os << ", ";
      b.dump(os);
      emitComma = true;
    }
    for (auto entry : this->accessedArrays) {
      if (emitComma)
        os << ", ";
      os << entry->getName().str();
      emitComma = true;
    }
    os << "}";
  }
  return os;
}

///\see std::ostream& operator<<(std::ostream& os, const CacheSetAnalysis<T>& x)
template <CacheTraits *T, class streamtype>
inline streamtype &operator<<(streamtype &os,
                              const SetWiseCountingPersistence<T> &x) {
  return x.dump(os);
}

} // namespace cache
} // namespace dom

} // namespace TimingAnalysisPass

#endif /*SETWISECOUNTINGPERSISTENCE_H*/
