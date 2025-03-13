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

#ifndef UPDATE_REPORTS_H
#define UPDATE_REPORTS_H

#include "Util/AbstractAddress.h"
#include "Util/Util.h"
#include "llvm/Support/Casting.h"

namespace TimingAnalysisPass {

namespace dom {
namespace cache {

/* The generic update report for all kinds of analyses. It does not provide any
 * features itself but serves as a marker and a generic superclass */
class UpdateReport {
public:
  virtual ~UpdateReport() {}
};

/* An update report that can be joined with update reports from other cache
 * sets. */
class JoinableUpdateReport : public UpdateReport {
public:
  /* Joins this with other, modifying the object. Passing NULL is defined
   * as NOOP */
  virtual void join(const JoinableUpdateReport *other) = 0;
  virtual ~JoinableUpdateReport() {}
};

template <class TagType> class LruMinAgeUpdateReport : public UpdateReport {
public:
  LruMinAgeUpdateReport()
      : evictedElements(), justEvictedUnknowns(false),
        justIntroducedUnknowns(false) {}

  /* The elements evicted during this update */
  std::set<TagType> evictedElements;
  /* true if this update removed the last "unknown" element from the cache
   * (i.e. a special element that represents an arbitrary tag. See
   * "implicit tags" in LruMinAgeAbstractCache for details) */
  bool justEvictedUnknowns;
  /* true if this update introduces the "unknown" element */
  bool justIntroducedUnknowns;
};

template <class TagType>
std::ostream &operator<<(std::ostream &stream,
                         LruMinAgeUpdateReport<TagType> &rep) {
  stream << "MAY update report: evicted {";
  bool printComma = false;
  for (TagType t : rep.evictedElements) {
    if (printComma) {
      stream << ", ";
    }
    printHex(stream, t);
    printComma = true;
  }
  if (rep.justEvictedUnknowns) {
    stream << ", *";
  }
  stream << "}";
  return stream;
}

template <class TagType> class LruMaxAgeUpdateReport : public UpdateReport {
public:
  LruMaxAgeUpdateReport() : evictedElements() {}

  /* The elements evicted during this update */
  std::set<TagType> evictedElements;
};

template <class TagType>
std::ostream &operator<<(std::ostream &stream,
                         LruMaxAgeUpdateReport<TagType> &rep) {
  stream << "MUST update report: evicted {";
  bool printComma = false;
  for (TagType t : rep.evictedElements) {
    if (printComma) {
      stream << ", ";
    }
    printHex(stream, t);
    printComma = true;
  }
  return stream;
}

class WritebackReport : public JoinableUpdateReport {
public:
  bool wbPossible;
  bool dirtifyingStore;

  WritebackReport(bool _wbPossible, bool dfs)
      : wbPossible(_wbPossible), dirtifyingStore(dfs) {}

  virtual void join(const JoinableUpdateReport *_other) {
    if (!_other)
      return;

    auto other = dynamic_cast<const WritebackReport *>(_other);

    /* cannot join with different report types */
    assert(_other);

    wbPossible = wbPossible || other->wbPossible;
    dirtifyingStore = dirtifyingStore || other->dirtifyingStore;
  }

  virtual boost::optional<AbstractAddress> potentialWritebacks() const {
    return wbPossible ? boost::optional<AbstractAddress>(
                            AbstractAddress::getUnknownAddress())
                      : boost::none;
  }
};

} // namespace cache
} // namespace dom
} // namespace TimingAnalysisPass
#endif
