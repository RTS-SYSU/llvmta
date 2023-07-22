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

#ifndef DOMAINS_MISC_BITSTRINGDOMAIN_H_
#define DOMAINS_MISC_BITSTRINGDOMAIN_H_

#include "Memory/progana/Lattice.h"
#include <boost/call_traits.hpp>
#include <boost/concept_check.hpp>
#include <ostream>

namespace TimingAnalysisPass {

namespace dom {
namespace misc {

/**
 * \tparam R  Type used to represent lattice elements. An integer or a bitset.
 *
 * \brief   Implements lattices whose elements are representable by a bitstring.
 * \details Join and meet can be implemented as binary | and & on the bitstring.
 *          The encoding must be defined in a way such that the lattice is
 * closed under & and |.
 */
template <typename R> class BitstringDomain : public progana::CompleteLattice {
  BOOST_CONCEPT_ASSERT((boost::Integer<R>));
  typedef BitstringDomain<R> Self;

protected:
  typedef typename boost::call_traits<R>::param_type ParamType;
  R value;

public:
  BitstringDomain();
  BitstringDomain(const Self &y);
  BitstringDomain(ParamType v);
  bool operator==(const Self &y) const;
  void join(const Self &y);
  void meet(const Self &y);

  friend std::ostream &operator<<(std::ostream &os,
                                  const BitstringDomain<R> &x) {
    return os << x.value;
  }
};

template <typename R> inline BitstringDomain<R>::BitstringDomain() : value() {}

template <typename R>
inline BitstringDomain<R>::BitstringDomain(const Self &y) : value(y.value) {}

template <typename R>
inline BitstringDomain<R>::BitstringDomain(ParamType v) : value(v) {}

template <typename R>
inline bool BitstringDomain<R>::operator==(const Self &y) const {
  return value == y.value;
}

template <typename R> inline void BitstringDomain<R>::join(const Self &y) {
  value |= y.value;
}

template <typename R> inline void BitstringDomain<R>::meet(const Self &y) {
  value &= y.value;
}

} // namespace misc
} // namespace dom

} // namespace TimingAnalysisPass

#endif /*DOMAINS_MISC_BITSTRINGDOMAIN_H_*/
