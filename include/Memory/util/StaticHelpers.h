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

#ifndef UTIL_STATICHELPERS_H_
#define UTIL_STATICHELPERS_H_

#include <boost/type_traits/is_convertible.hpp>

namespace TimingAnalysisPass {

struct NullType;

template <bool Cond, unsigned N, unsigned M> struct SelectInt {
  static const unsigned value = N;
};

template <unsigned N, unsigned M> struct SelectInt<false, N, M> {
  static const unsigned value = M;
};

template <bool selectFirst, typename T, typename U> struct Select {
  typedef T Result;
};

template <typename T, typename U> struct Select<false, T, U> {
  typedef U Result;
};

template <typename From, typename To> struct ConvertibleTypes {
  typedef typename Select<boost::is_convertible<From, To>::value, From,
                          NullType>::Result FromType;
  typedef typename Select<boost::is_convertible<From, To>::value, To,
                          NullType>::Result ToType;
};

template <typename T1, typename T2> struct SmallerOf {
  typedef typename Select<sizeof(T1) <= sizeof(T2), T1, T2>::Result Result;
};

template <typename T1, typename T2> struct LargerOf {
  typedef typename Select<sizeof(T1) >= sizeof(T2), T1, T2>::Result Result;
};

#define IsPwr2(N) (!(N & (N - 1)) && N)

template <unsigned N> struct Log2 {
  static const unsigned value = 1 + Log2<N / 2>::value;
  static const unsigned floor = value;
  static const unsigned ceil = value + (IsPwr2(N) ? 0 : 1);
};

template <> struct Log2<1> {
  static const unsigned value = 0;
  static const unsigned floor = 0;
  static const unsigned ceil = 0;
};

template <> struct Log2<0> {};

} // namespace TimingAnalysisPass

#endif /*UTIL_STATICHELPERS_H_*/
