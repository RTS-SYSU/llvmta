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

#ifndef PROGANA_LATTICE_H_
#define PROGANA_LATTICE_H_

#include "Memory/progana/LatticeConcepts.h"
#include "Memory/util/StaticHelpers.h"
#include <boost/concept/requires.hpp>
#include <boost/type_traits/is_convertible.hpp>
#include <iterator>

namespace TimingAnalysisPass {

namespace progana {

// Helpers to prevent template instantiation for non-Lattice types.
class JoinSemiLattice {};
class MeetSemiLattice {};
class CompleteLattice : public JoinSemiLattice, public MeetSemiLattice {};

template <typename T>
class JoinSemiLatticeChecker
    : public ConvertibleTypes<T, progana::JoinSemiLattice> {};

template <typename T>
class MeetSemiLatticeChecker
    : public ConvertibleTypes<T, progana::MeetSemiLattice> {};

template <typename T>
class CompleteLatticeChecker
    : public ConvertibleTypes<T, progana::CompleteLattice> {};

template <typename T> class JoinOrMeetSemiLatticeChecker {
  static const bool isConvertible =
      boost::is_convertible<T, progana::JoinSemiLattice>::value ||
      boost::is_convertible<T, progana::MeetSemiLattice>::value;

public:
  typedef typename Select<isConvertible, T, NullType>::Result FromType;
};

template <typename T> class StrictMeetSemiLatticeChecker {
  static const bool isConvertible =
      boost::is_convertible<T, progana::MeetSemiLattice>::value &&
      !boost::is_convertible<T, progana::JoinSemiLattice>::value;

public:
  typedef typename Select<isConvertible, T, NullType>::Result FromType;
};

template <typename T> class StrictJoinSemiLatticeChecker {
  static const bool isConvertible =
      boost::is_convertible<T, progana::JoinSemiLattice>::value &&
      !boost::is_convertible<T, progana::MeetSemiLattice>::value;

public:
  typedef typename Select<isConvertible, T, NullType>::Result FromType;
};
// End helpers

// 1. Joins
template <class C>
inline C &operator|=(C &x,
                     const typename JoinSemiLatticeChecker<C>::FromType &y) {
  x.join(y);
  return x;
}

template <class C>
inline C operator|(const C &x,
                   const typename JoinSemiLatticeChecker<C>::FromType &y) {
  C res(x);
  return res |= y;
}

// 2. Meets
template <class C>
inline C &operator&=(C &x,
                     const typename MeetSemiLatticeChecker<C>::FromType &y) {
  x.meet(y);
  return x;
}

template <class C>
inline C operator&(const C &x,
                   const typename MeetSemiLatticeChecker<C>::FromType &y) {
  C res(x);
  return res &= y;
}

// 3. Comparison functions
template <class C>
inline bool
operator!=(const C &x,
           const typename JoinOrMeetSemiLatticeChecker<C>::FromType &y) {
  return !(x == y);
}

// 3.a) Function definitions for JoinSemiLattices, which only use join.
template <class C>
inline bool po_leq(const C &x,
                   const typename JoinSemiLatticeChecker<C>::FromType &y) {
  return (x | y) == y;
}

template <class C>
inline bool po_geq(const C &x,
                   const typename JoinSemiLatticeChecker<C>::FromType &y) {
  return (x | y) == x;
}

template <class C>
inline bool po_lt(const C &x,
                  const typename JoinSemiLatticeChecker<C>::FromType &y) {
  const C j = x | y;
  return (j == y) && !(j == x);
}

template <class C>
inline bool po_gt(const C &x,
                  const typename JoinSemiLatticeChecker<C>::FromType &y) {
  const C j = x | y;
  return (j == x) && !(j == y);
}

// 3.b) Function definitions for MeetSemiLattices, which only use meet.
template <class C>
inline bool
po_leq(const C &x,
       const typename StrictMeetSemiLatticeChecker<C>::FromType &y) {
  return (x & y) == x;
}

template <class C>
inline bool
po_geq(const C &x,
       const typename StrictMeetSemiLatticeChecker<C>::FromType &y) {
  return (x & y) == y;
}

template <class C>
inline bool po_lt(const C &x,
                  const typename StrictMeetSemiLatticeChecker<C>::FromType &y) {
  const C j = x & y;
  return (j == x) && !(j == y);
}

template <class C>
inline bool po_gt(const C &x,
                  const typename StrictMeetSemiLatticeChecker<C>::FromType &y) {
  const C j = x & y;
  return (j == y) && !(j == x);
}

// Static join over a range
template <class InputIterator>
inline BOOST_CONCEPT_REQUIRES(
    ((boost::InputIterator<InputIterator>))(
        (concepts::JoinSemiLattice<
            typename std::iterator_traits<InputIterator>::value_type>)),
    (typename std::iterator_traits<InputIterator>::value_type) // return type
    ) join(InputIterator first, InputIterator last) {
  if (first == last) {
    typename std::iterator_traits<InputIterator>::value_type res;
    return res;
  }

  typename std::iterator_traits<InputIterator>::value_type res(*first++);
  while (first != last)
    res |= *first++;

  return res;
}

// Static meet over a range
template <class InputIterator>
inline BOOST_CONCEPT_REQUIRES(
    ((boost::InputIterator<InputIterator>))(
        (concepts::MeetSemiLattice<
            typename std::iterator_traits<InputIterator>::value_type>)),
    (typename std::iterator_traits<InputIterator>::value_type) // return type
    ) meet(InputIterator first, InputIterator last) {
  if (first == last) {
    typename std::iterator_traits<InputIterator>::value_type res;
    return res;
  }

  typename std::iterator_traits<InputIterator>::value_type res(*first++);
  while (first != last)
    res &= *first++;

  return res;
}

} // namespace progana

} // namespace TimingAnalysisPass

#endif /*PROGANA_LATTICE_H_*/
