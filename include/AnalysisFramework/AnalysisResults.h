////////////////////////////////////////////////////////////////////////////////
//
//   LLVMTA - Timing Analyser performing worst-case execution time analysis
//     using the LLVM backend intermediate representation
//
// Copyright (C) 2013-2022  Saarland University
// Copyright (C) 2014-2015  Claus Faymonville
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

#ifndef ANALYSISRESULTS_H
#define ANALYSISRESULTS_H

#include <fstream>
#include <map>
#include <set>
#include <string>

#include "boost/optional.hpp"

namespace TimingAnalysisPass {

struct BoundItv {
  double lb;
  double ub;

  bool operator==(const BoundItv &itv) const {
    return ub == itv.ub && lb == itv.lb;
  };

  friend std::ostream &operator<<(std::ostream &os, const BoundItv &bitv);
};

class AnalysisResults {

public:
  static AnalysisResults &getInstance();

  void registerResult(std::string identifier, boost::optional<double> result);
  void registerResult(std::string identifier, boost::optional<BoundItv> result);

  bool hasResult(std::string identifier) const;

  boost::optional<double> getResultUpperBound(std::string identifier) const;

  /* increments the specified results if possible. Returns true if
   * successful, false if "identifier" is not registered */
  bool incrementResult(std::string identifier);

  /* finalizes the variable, i.e. future calls to increment will not
   * change the value any more */
  void finalize(std::string identifier);

  void dump(std::ostream &outFile) const;

private:
  AnalysisResults();

  // declaring, but not implementing copy constructor and assign operator
  AnalysisResults(const AnalysisResults &) = delete;
  void operator=(const AnalysisResults &) = delete;

  std::map<std::string, boost::optional<double>> results;
  std::map<std::string, boost::optional<BoundItv>> itvresults;

  std::set<std::string> finalizedResults;
};

} // namespace TimingAnalysisPass

#endif /* ANALYSISRESULTS_H */
