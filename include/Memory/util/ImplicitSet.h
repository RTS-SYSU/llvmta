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

#ifndef IMPLICITSET_H_
#define IMPLICITSET_H_

#include <algorithm>
#include <iostream>
#include <iterator>
#include <limits>
#include <set>

namespace TimingAnalysisPass {

template <class C> class ImplicitSet : public std::set<C> {
  typedef ImplicitSet Self;
  typedef std::set<C> Super;

  bool isUniverse_;

public:
  typedef typename Super::size_type size_type;
  typedef typename Super::iterator iterator;

  ImplicitSet() : Super(), isUniverse_(false) {}

  explicit ImplicitSet(bool isUniverse) : Super(), isUniverse_(isUniverse) {}

  ImplicitSet(const std::set<C> &set) : Super(set), isUniverse_(false) {}

  ImplicitSet(const Self &y, const C &elem)
      : Super(y), isUniverse_(y.isUniverse_) {
    this->insert(elem);
  }

  explicit ImplicitSet(const C &elem) : Super(), isUniverse_(false) {
    this->insert(elem);
  }

  bool isNegated() const { return isUniverse_; }

  bool containsAll() const { return isUniverse_ && Super::empty(); }

  void clear() {
    Super::clear();
    isUniverse_ = false;
  }

  size_type count(const C &x) const {
    size_type c = Super::count(x);
    return isNegated() ? 1 - c : c;
  }

  bool empty() const {
    if (isNegated())
      return false;
    return Super::empty();
  }

  void erase(const C &elem) {
    if (isNegated())
      Super::insert(elem);
    else
      Super::erase(elem);
  }

  iterator find(const C &x) const {
    assert(!isNegated());
    return Super::find(x);
  }

  std::pair<iterator, bool> insert(const C &elem) {
    if (isNegated()) {
      Super::erase(elem);
      return std::make_pair(this->end(), false);
    } else
      return Super::insert(elem);
  }

  inline iterator insert(iterator position, const C &elem) {
    return ++this->insert(elem).first;
  }

  template <class InputIterator>
  void insert(InputIterator first, InputIterator last) {
    while (first != last)
      this->insert(*first++);
  }

  void insertAll() {
    Super::clear();
    isUniverse_ = true;
  }

  size_type size() const {
    size_type n = Super::size();
    return isNegated() ? std::numeric_limits<size_type>::max() - n : n;
  }

  void swap(Self &y) {
    Super::swap(y);
    std::swap(isUniverse_, y.isUniverse);
  }

  std::ostream &dump(std::ostream &out) const {
    if (isNegated())
      out << "All \\ ";
    out << "{";
    //		std::copy(this->begin(), this->end(), std::ostream_iterator<C>(out, ",
    //"));

    // Ugly hack: at the moment we cast _any_ type to int
    // We only use unsigned char, hence this works
    // How to dump in a generic way?
    for (typename Super::const_iterator it = this->begin(); it != this->end();
         ++it)
      out << (it == this->begin() ? "" : ", ") << (int)*it;
    out << "}";
    return out;
  }

  bool isSubset(const Self &sup) {
    if (sup.isNegated())
      if (this->isNegated())
        return std::includes(this->begin(), this->end(), sup.begin(),
                             sup.end());
      else {
        Super tmp;
        std::set_intersection(this->begin(), this->end(), sup.begin(),
                              sup.end(), std::inserter(tmp, tmp.begin()));
        return tmp.empty();
      }
    else if (this->isNegated())
      return false;
    else
      return std::includes(sup.begin(), sup.end(), this->begin(), this->end());
  }

  static Self intersect(const Self &s1, const Self &s2) {
    if (s1.isNegated())
      if (s2.isNegated()) {
        Self res(true);
        Super &sup(res);
        std::set_union(s1.begin(), s1.end(), s2.begin(), s2.end(),
                       std::inserter(sup, sup.begin()));
        return res;
      } else {
        Self res(false);
        Super &sup(res);
        std::set_difference(s2.begin(), s2.end(), s1.begin(), s1.end(),
                            std::inserter(sup, sup.begin()));
        return res;
      }
    else if (s2.isNegated()) {
      Self res(false);
      Super &sup(res);
      std::set_difference(s1.begin(), s1.end(), s2.begin(), s2.end(),
                          std::inserter(sup, sup.begin()));
      return res;
    } else {
      Self res(false);
      Super &sup(res);
      std::set_intersection(s1.begin(), s1.end(), s2.begin(), s2.end(),
                            std::inserter(sup, sup.begin()));
      return res;
    }
  }

  static Self unite(const Self &s1, const Self &s2) {
    if (s1.isNegated())
      if (s2.isNegated()) {
        Self res(true);
        Super &sup(res);
        std::set_intersection(s1.begin(), s1.end(), s2.begin(), s2.end(),
                              std::inserter(sup, sup.begin()));
        return res;
      } else {
        Self res(true);
        Super &sup(res);
        std::set_difference(s1.begin(), s1.end(), s2.begin(), s2.end(),
                            std::inserter(sup, sup.begin()));
        return res;
      }
    else if (s2.isNegated()) {
      Self res(true);
      Super &sup(res);
      std::set_difference(s2.begin(), s2.end(), s1.begin(), s1.end(),
                          std::inserter(sup, sup.begin()));
      return res;
    } else {
      Self res(false);
      Super &sup(res);
      std::set_union(s1.begin(), s1.end(), s2.begin(), s2.end(),
                     std::inserter(sup, sup.begin()));
      return res;
    }
  }

  static Self substract(const Self &s1, const Self &s2) {
    if (s1.isNegated())
      if (s2.isNegated()) {
        Self res(false);
        Super &sup(res);
        std::set_difference(s2.begin(), s2.end(), s1.begin(), s1.end(),
                            std::inserter(sup, sup.begin()));
        return res;
      } else {
        Self res(true);
        Super &sup(res);
        std::set_union(s1.begin(), s1.end(), s2.begin(), s2.end(),
                       std::inserter(sup, sup.begin()));
        return res;
      }
    else if (s2.isNegated()) {
      Self res(false);
      Super &sup(res);
      std::set_intersection(s1.begin(), s1.end(), s2.begin(), s2.end(),
                            std::inserter(sup, sup.begin()));
      return res;
    } else {
      Self res(false);
      Super &sup(res);
      std::set_difference(s1.begin(), s1.end(), s2.begin(), s2.end(),
                          std::inserter(sup, sup.begin()));
      return res;
    }
  }
};

template <class C>
std::ostream &operator<<(std::ostream &out, const ImplicitSet<C> &x) {
  return x.dump(out);
}

} // namespace TimingAnalysisPass

#endif /* IMPLICITSET_H_ */
