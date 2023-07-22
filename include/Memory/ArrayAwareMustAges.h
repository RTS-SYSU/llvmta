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

#ifndef ARRAY_AWARE_MUST_AGES_H
#define ARRAY_AWARE_MUST_AGES_H

#include "Util/Util.h"

namespace TimingAnalysisPass {
namespace dom {
namespace cache {

/* For a detailed description of these analyses read Tobias Blaß's master thesis
 * http://embedded.cs.uni-saarland.de/publications/ThesisBlass2016.pdf
 */

/* conflict set union prioritizes the conflict set above the age bound. When
 * joining, the union of the conflict sets is formed and the bounds aged
 * accordingly */
template <CacheTraits *T> class MustAgeConflictSetUnion;

/* conflict set intersection prioritizes the age bound above the conflict set.
 * When joining, the conflict sets are intersected */
template <CacheTraits *T> class MustAgeConflictSetIntersect;

/* conflict powerset remembers a dedicated age bound per possible conflict set.
 * The minimal age is taken for classification. Joining is performed pointwise
 */
template <CacheTraits *T> class MustAgeConflictPowerset;

template <CacheTraits *T> class MustAge {
public:
  static std::unique_ptr<MustAge<T>> make() {
    switch (ArrayMustAnalysis) {
    case ArrayMustAnaType::CONFLICT_SET_INTERSECT:
      return std::make_unique<MustAgeConflictSetIntersect<T>>();
    case ArrayMustAnaType::CONFLICT_SET_UNION:
      return std::make_unique<MustAgeConflictSetUnion<T>>();
    case ArrayMustAnaType::CONFLICT_POWERSET:
      return std::make_unique<MustAgeConflictPowerset<T>>();
    default:
      assert(0 && "UNREACHABLE");
    }
  }

  /* C++ cannot deep-copy abstract classes, so we have to do this by hand. * */
  virtual std::unique_ptr<MustAge<T>> clone() = 0;

  /* returns true if the age is at associativity, i.e. if the element
   * might have been evicted */
  virtual bool isAssociativity() const = 0;
  /* returns the age as a number. Note that this function returns a way
   * type - it asserts that the age is below associativity */
  virtual typename CacheTraits::WayType getAge() const = 0;
  /*
   * Ages the element by a fixed amount or an access to an array.
   * Returns whether the element is still cached or has been evicted.
   * Note: If the element has been evicted the MustAge enters an invalid
   * state and should be deconstructed.
   */
  virtual void ageBy(const GlobalVariable *arr) = 0;
  virtual void ageBy(unsigned amount) = 0;
  virtual void join(const MustAge<T> &) = 0;
  virtual void dump(std::ostream &) const = 0;
  virtual bool operator==(const MustAge<T> &other) const = 0;
  virtual bool operator<(const MustAge<T> &other) const = 0;
  virtual ~MustAge(){};
};

template <CacheTraits *T> class MustAgeConflictSet : public MustAge<T> {
  typedef typename CacheTraits::WayType WayType;
  typedef typename CacheTraits::PosType PosType;
  typedef MustAgeConflictSet<T> Self;

protected:
  PosType age;
  std::multiset<const GlobalVariable *> ArrayAccesses;

public:
  virtual bool isAssociativity() const { return age == T->ASSOCIATIVITY; }
  virtual WayType getAge() const {
    assert(!this->isAssociativity());
    return (WayType)age;
  }

  virtual void ageBy(const GlobalVariable *var) {
    assert(var);
    if (ArrayAccesses.count(var) < getPerSetSize<T>(var)) {
      ArrayAccesses.insert(var);
      this->ageBy(1);
    }
  }
  virtual void ageBy(unsigned amount) {
    assert(!this->isAssociativity());
    if (age >= T->ASSOCIATIVITY - amount) {
      this->ArrayAccesses.clear();
      age = T->ASSOCIATIVITY;
      return;
    }

    age += amount;
  }

  virtual void join(const MustAge<T> &other) = 0;

  virtual void dump(std::ostream &stream) const {
    stream << "(" << (unsigned)this->age << ", ";
    printMultiSet(stream, ArrayAccesses);
    stream << ")";
  }
  virtual bool operator==(const MustAge<T> &other_) const {
    assert(!this->isAssociativity() && !other_.isAssociativity());
    if (const Self *other = dynamic_cast<const Self *>(&other_)) {
      return age == other->getAge() && ArrayAccesses == other->ArrayAccesses;
    }
    return false;
  }
  virtual bool operator<(const MustAge<T> &other_) const {
    assert(!this->isAssociativity() && !other_.isAssociativity());
    if (const Self *other = dynamic_cast<const Self *>(&other_)) {
      return age < other->age ||
             (age == other->age && ArrayAccesses < other->ArrayAccesses);
    }
    assert(0 &&
           "Cannot sensibly define operator< vs. arguments of different type");
  }
  virtual ~MustAgeConflictSet() {}
};

template <CacheTraits *T>
class MustAgeConflictSetIntersect : public MustAgeConflictSet<T> {
  typedef typename CacheTraits::WayType WayType;
  typedef MustAgeConflictSetIntersect<T> Self;

public:
  virtual std::unique_ptr<MustAge<T>> clone() {
    auto ptr = std::make_unique<Self, Self &>(*this);
    return ptr;
  }
  virtual void join(const MustAge<T> &other_) {
    auto other = dynamic_cast<const MustAgeConflictSetIntersect<T> &>(other_);

    assert(!this->isAssociativity() && !other.isAssociativity());
    /* take the maximum of the ages and the intersection of the conflict sets */
    this->age = std::max(this->age, other.age);

    decltype(this->ArrayAccesses) intersection;
    std::set_intersection(
        this->ArrayAccesses.begin(), this->ArrayAccesses.end(),
        other.ArrayAccesses.begin(), other.ArrayAccesses.end(),
        std::inserter(intersection, intersection.begin()));

    this->ArrayAccesses = std::move(intersection);
  }
  virtual ~MustAgeConflictSetIntersect() {}
};

template <CacheTraits *T>
class MustAgeConflictSetUnion : public MustAgeConflictSet<T> {
  typedef typename CacheTraits::WayType WayType;
  typedef MustAgeConflictSetUnion<T> Self;

public:
  virtual std::unique_ptr<MustAge<T>> clone() {
    auto ptr = std::make_unique<Self, Self &>(*this);
    return ptr;
  }
  virtual void join(const MustAge<T> &other_) {
    /* Join Procedure:
     * - Bring both entries to a common conflict set by taking
     *   the union and aging appropriately.
     * - Take the maximum of the ages.
     */
    auto other = dynamic_cast<const MustAgeConflictSetUnion<T> &>(other_);
    WayType adjustedYAge = other.getAge();

    auto xit = this->ArrayAccesses.begin();
    auto xend = this->ArrayAccesses.end();
    auto yit = other.ArrayAccesses.begin();
    auto yend = other.ArrayAccesses.end();

    /* we need std::less to compare pointers - the <
     * operator yields undefined behaviour in this case */
    auto less = std::less<const GlobalVariable *>();

    while (xit != xend || yit != yend) {
      if (yit == yend || (xit != xend && less(*xit, *yit))) {
        adjustedYAge++;
        ++xit;
      } else if (xit == xend || less(*yit, *xit)) {
        this->age++;
        /* *yit is less than *xit -> this loop will not visit
         * the newly inserted element */
        this->ArrayAccesses.insert(*yit);
        ++yit;
      } else {
        /* both contain the array - nothing to do */
        ++xit;
        ++yit;
      }
      if (this->age == T->ASSOCIATIVITY || adjustedYAge == T->ASSOCIATIVITY) {
        break;
      }
    }

    this->age = std::max(this->age, adjustedYAge);
    if (this->age == T->ASSOCIATIVITY) {
      this->ArrayAccesses.clear();
    }
  }
  virtual ~MustAgeConflictSetUnion() {}
};

template <CacheTraits *T> class MustAgeConflictPowerset : public MustAge<T> {
  typedef MustAgeConflictPowerset<T> Self;
  typedef typename CacheTraits::WayType WayType;
  typedef typename CacheTraits::PosType PosType;

  /* We store one MUST-bound per conflict-set. Each of these is a bound
   * that still holds after an access to an entry of the conflict-set. In
   * particular you can choose an arbitrary entry and get a valid, albeit
   * suboptimal, bound.
   * When looking for a specific item in the perCSBound map, use the getBound
   * method since it correctly handles non-existing entries.
   */
  /* inefficient implementation - let's first see if we gain anything */
  typedef std::set<const GlobalVariable *> ConflictSet;
  std::map<ConflictSet, PosType> perCSBound;

  /* computes the bound for *set* based on the bounds of subsets of set if
   * it is not there*/
  PosType getBound(const ConflictSet &set) const {
    auto it = perCSBound.find(set);
    if (it != perCSBound.end()) {
      return it->second;
    }

    PosType ret = T->ASSOCIATIVITY;

    /* TODO inefficient implementation */
    for (auto entry : perCSBound) {
      if (!std::includes(set.begin(), set.end(), entry.first.begin(),
                         entry.first.end())) {
        /* entry.first is not a subset of set */
        continue;
      }

      std::vector<const GlobalVariable *> diff;
      std::set_difference(entry.first.begin(), entry.first.end(), set.begin(),
                          set.end(), diff.begin());

      PosType adjustedBound = entry.second;
      for (auto var : diff) {
        unsigned perSetSize = getPerSetSize<T>(var);
        if (adjustedBound >= T->ASSOCIATIVITY - perSetSize) {
          adjustedBound = T->ASSOCIATIVITY;
          break;
        }
        adjustedBound += perSetSize;
      }
      if (ret > adjustedBound) {
        ret = adjustedBound;
      }
    }
    return ret;
  }

public:
  MustAgeConflictPowerset() { perCSBound[ConflictSet()] = 0; }
  virtual std::unique_ptr<MustAge<T>> clone() {
    auto ptr = std::make_unique<Self, Self &>(*this);
    return ptr;
  }

  virtual bool isAssociativity() const {
    for (const auto entry : perCSBound) {
      assert(entry.second <= T->ASSOCIATIVITY);
      if (entry.second != T->ASSOCIATIVITY) {
        return false;
      }
    }
    return true;
  }

  virtual typename CacheTraits::WayType getAge() const {
    PosType age = T->ASSOCIATIVITY;
    for (const auto &entry : perCSBound) {
      age = std::min(age, entry.second);
    }
    assert(age != T->ASSOCIATIVITY);
    return (WayType)age;
  }
  virtual void ageBy(const GlobalVariable *arr) {
    for (auto &entry : perCSBound) {
      if (entry.first.count(arr) == 0 && entry.second < T->ASSOCIATIVITY) {
        const unsigned oldBound = entry.second;
        entry.second++;

        ConflictSet cSetWithArray(entry.first);
        cSetWithArray.insert(arr);

        /* if the array is larger than the associativity
         * pretend it is not. This guards against underflows */
        unsigned perSetSize = getPerSetSize<T>(arr);

        const unsigned extrapolatedAge =
            std::min(oldBound + perSetSize, T->ASSOCIATIVITY);
        if (perCSBound.count(cSetWithArray) == 0 ||
            perCSBound[cSetWithArray] > extrapolatedAge) {
          perCSBound[cSetWithArray] = extrapolatedAge;
        }
      }
    }
  }
  virtual void ageBy(unsigned amount) {
    assert(!isAssociativity());
    for (auto &bound : perCSBound) {
      if (bound.second >= T->ASSOCIATIVITY - amount) {
        bound.second = T->ASSOCIATIVITY;
      } else {
        bound.second += amount;
      }
    }
  }
  virtual void join(const MustAge<T> &other_) {
    auto other = dynamic_cast<const Self &>(other_);

    auto xIt = this->perCSBound.begin();
    auto xEnd = this->perCSBound.end();
    auto yIt = other.perCSBound.begin();
    auto yEnd = other.perCSBound.end();

    std::map<ConflictSet, WayType> newBounds;
    while (xIt != xEnd || yIt != yEnd) {
      bool xLtY = yIt == yEnd || (xIt != xEnd && xIt->first < yIt->first);
      bool xGtY = xIt == xEnd || (yIt != yEnd && xIt->first > yIt->first);

      const ConflictSet &set = xGtY ? yIt->first : xIt->first;
      PosType xBound = xGtY ? this->getBound(set) : xIt->second;
      PosType yBound = xLtY ? other.getBound(set) : yIt->second;
      newBounds[set] = std::max(xBound, yBound);

      assert(!xLtY || !xGtY);

      if (!xLtY) {
        yIt++;
      }
      if (!xGtY) {
        xIt++;
      }
    }
    this->perCSBound = std::move(newBounds);
    assert(this->perCSBound.size() > 0);
  }
  virtual void dump(std::ostream &stream) const {
    stream << "[";
    bool emitComma = false;
    for (const auto &entry : perCSBound) {
      if (emitComma) {
        stream << ",";
      }
      printSet(stream, entry.first);
      stream << " ->" << (int)entry.second;
      emitComma = true;
    }
    stream << "]";
  }
  virtual bool operator==(const MustAge<T> &other_) const {
    assert(!this->isAssociativity() && !other_.isAssociativity());
    if (const Self *other = dynamic_cast<const Self *>(&other_)) {
      /* TODO do we want to expand to the maximum here? */
      return this->perCSBound == other->perCSBound;
    }
    assert(0 && "== called on objects of different type");
  }
  virtual bool operator<(const MustAge<T> &other_) const {
    assert(!this->isAssociativity() && !other_.isAssociativity());
    if (const Self *other = dynamic_cast<const Self *>(&other_)) {
      /* TODO do we want to expand to the maximum here? */
      return this->perCSBound < other->perCSBound;
    }
    assert(0 && "< called on objects of different type");
  }
  virtual ~MustAgeConflictPowerset() {}
};

} // namespace cache
} // namespace dom
} // namespace TimingAnalysisPass
#endif
