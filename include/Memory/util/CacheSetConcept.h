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

#ifndef CONCEPTS_CACHESET_H_
#define CONCEPTS_CACHESET_H_

#include "Memory/CacheTraits.h"
#include "Memory/Classification.h"
#include "Util/AbstractAddress.h"
#include "Util/Util.h"
#include <ostream>

namespace TimingAnalysisPass {

namespace concepts {

template <class X>
struct CacheSet : boost::DefaultConstructible<X>,
                  boost::CopyConstructible<X>,
                  boost::Assignable<X> {
  typedef typename X::AnaDeps AnaDeps;

  // TODO check types of Traits::*
  // BOOST_CONCEPT_ASSERT((SignedInteger<difference_type>));

  BOOST_CONCEPT_USAGE(CacheSet) {
    X a(true); // require constructor for initialization as "empty cache"
    same_type(cl, cX.classify(addr));
    x.update(addr, act, Deps);
  }

private:
  dom::cache::Classification cl;
  static const AbstractAddress addr;
  AnaDeps *Deps;
  X x;
  AccessType act;
  const X cX;

  template <typename T> void same_type(T const &, T const &);
};

} // namespace concepts

} // namespace TimingAnalysisPass

#endif /*CONCEPTS_CACHESET_H_*/
