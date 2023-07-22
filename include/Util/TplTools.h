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

#ifndef UTIL_TPLTOOLS_H
#define UTIL_TPLTOOLS_H

#include <type_traits>

namespace TimingAnalysisPass {

/**
 * This is a set of helper utilities used in order to
 * select the correct specialization of a template
 * function depending on the existence of a particular
 * member in one of the template parameters.
 *
 * This solution is inspired by the accepted answer
 * in the following post:
 * http://stackoverflow.com/questions/13786888/check-if-member-exists-using-enable-if
 *
 * For now, I will not describe the tool set in detail.
 * For a use-case see TimingAnalysisMain::doPathAnalysis.
 * Both source and header file contain necessary stuff.
 *
 * The intuition is roughly as follows:
 * - Assume to start with only one template function
 *   that is so far called in all cases.
 * - Now create an exact copy of it that
 *   does certain things different than the original.
 * - Add an unnamed parameter of type TplGeneral
 *   to the original function.
 * - Add an unnamed parameter of type TplSpecial
 *   to the changed function.
 * - At all call sites, add TplSpecial() as argument.
 * - So far, the more specific version (the changed
 *   one) would always be called.
 * - Add an unnamed template value parameter
 *   of type TplSwitch<decltype(X)> and default value
 *   0 to the changed function.
 * - X is now the qualified name of a field of one
 *   of the preceding template parameter.
 * - Whenever the field described by X does not exist,
 *   then the template matching for the special version
 *   fails and the original version is used. (SFINAE)
 *
 * This allows even for more complicated use cases:
 * - A specialized function can check for the existence
 *   of several fields by using several additional
 *   template parameters exactly as described before.
 * - We can in principle allow several specialized
 *   versions of a general case function.
 *   An example for this is also given by
 *   TimingAnalysisMain::doPathAnalysis.
 *   However, in such cases, it is crucial that the
 *   selection conditions for the different special
 *   versions are disjoint!
 *
 * TplSwitch checks for the existence of a (field) member
 * of a given class. However, there is a more general
 * use case, namely to check arbitrary conditions, e.g.
 * depending on the type of fields or inheritance properties.
 * TplSwitch is a special case of TplCond and uses it in its
 * implementation. TplCond uses std::enable_if.
 */
struct TplGeneral {};

struct TplSpecial : TplGeneral {};

template <bool B> using TplCond = typename std::enable_if<B, int>::type;

template <typename T> using TplSwitch = TplCond<!std::is_void<T>::value>;

} // namespace TimingAnalysisPass

#endif
