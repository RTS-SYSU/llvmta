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

#ifndef CONCEPTS_CACHESETANALYSIS_H_
#define CONCEPTS_CACHESETANALYSIS_H_

#include "Memory/CacheTraits.h"
#include "Memory/Classification.h"
#include "Memory/UpdateReports.h"
#include "Memory/progana/LatticeConcepts.h"
#include "Memory/util/CacheSetConcept.h"
#include "Util/Util.h"
#include <ostream>

namespace TimingAnalysisPass {

namespace concepts {

template <class X>
struct CacheSetAnalysis : concepts::CacheSet<X>,
                          concepts::JoinSemiLattice<X>,
                          concepts::TotalOrder<X> {
  typedef typename X::AnaDeps AnaDeps;

  BOOST_CONCEPT_USAGE(CacheSetAnalysis) {
    /* tblass: we pass in "false" instead of an arbitrary bool to prevent
     * memory allocations. Just in case this is executed (I'm not
     * sure) */
    report = x.update(addr, acct, Deps, false, cCl);
    /* require that the last three arguments are optional */
    report = x.update(addr, acct, Deps);
    report = x.update(addr, acct, Deps, false);
  }

private:
  X x;
  const X cx;
  AccessType acct;
  static const AbstractAddress addr;
  AnaDeps *Deps;
  const dom::cache::Classification cCl;
  dom::cache::UpdateReport *report;
};

} // namespace concepts

} // namespace TimingAnalysisPass

#endif /*CONCEPTS_CACHESETANALYSIS_H_*/
