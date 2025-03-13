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

#include "AnalysisFramework/AnalysisResults.h"
#include "Util/Options.h"
#include <boost/optional/optional_io.hpp>
#include <iostream>

namespace TimingAnalysisPass {

std::ostream &operator<<(std::ostream &os, const BoundItv &bitv) {
  os << "[" << bitv.lb << ", " << bitv.ub << "]";
  return os;
}

AnalysisResults &AnalysisResults::getInstance() {
  static AnalysisResults anares;
  return anares;
}

AnalysisResults::AnalysisResults() {}

void AnalysisResults::registerResult(std::string identifier,
                                     boost::optional<double> result) {
  if (hasResult(identifier)) {
    std::cerr << "[WARNING] Registering the result " << identifier
              << " more than once\n";
    if (result == results[identifier]) {
      return;
    }
    std::cerr << "Values disagree: had " << results[identifier]
              << ", new value " << result << "\n";
    abort();
  }
  results[identifier] = result;
}

void AnalysisResults::registerResult(std::string identifier,
                                     boost::optional<BoundItv> result) {
  if (hasResult(identifier)) {
    std::cerr << "[WARNING] Registering the result " << identifier
              << " more than once\n";
    if (itvresults.count(identifier) > 0 && result == itvresults[identifier]) {
      return;
    }
    std::cerr << "Values disagreed, Aborting...\n";
    abort();
  }
  itvresults[identifier] = result;
}

bool AnalysisResults::hasResult(std::string identifier) const {
  return results.count(identifier) > 0 || itvresults.count(identifier) > 0;
}

boost::optional<double>
AnalysisResults::getResultUpperBound(std::string identifier) const {
  assert(hasResult(identifier) && "No result for this identifier!");
  if (results.count(identifier) > 0) {
    return results.at(identifier);
  } else {
    if (itvresults.at(identifier)) {
      return itvresults.at(identifier).get().ub;
    } else {
      return boost::none;
    }
  }
}

bool AnalysisResults::incrementResult(std::string identifier) {
  if (!hasResult(identifier))
    return false;

  if (finalizedResults.count(identifier) > 0)
    return false;

  if (results.count(identifier) > 0) {
    if (!results.at(identifier)) {
      return false;
    }
    results[identifier] = results[identifier].get() + 1;
  } else {
    if (!itvresults.at(identifier)) {
      return false;
    }
    ++itvresults[identifier].get().ub;
    ++itvresults[identifier].get().lb;
  }
  return true;
}

void AnalysisResults::finalize(std::string identifier) {
  finalizedResults.insert(identifier);
}

void AnalysisResults::dump(std::ostream &outFile) const {
  if (!CalculateSlopeInterferenceCurve.getBits()) {
    outFile.setf(std::ios::fixed);
    outFile.precision(0);
  }

  outFile << "<bounds>\n";
  for (auto &res : results) {
    // We need this check here to ensure that XML tags with attributes
    // are created correctly. That is, the attribute value should only
    // occur in the starting tag, but not the closing tag
    std::string tag, xmltag = res.first;
    size_t paramloc = xmltag.find(" ");
    tag = (paramloc == std::string::npos) ? xmltag : xmltag.substr(0, paramloc);
    outFile << "<" << xmltag << ">";
    if (res.second) {
      outFile << res.second.get();
    } else {
      outFile << "unbounded";
    }
    outFile << "</" << tag << ">\n";
  }
  for (auto &res : itvresults) {
    std::string xmltag = res.first;
    outFile << "<" << xmltag << " ";
    if (res.second) {
      outFile << "ub=\"" << res.second.get().ub << "\" lb=\""
              << res.second.get().lb << "\"";
    } else {
      outFile << "ub=\"unbounded\" lb=\"unbounded\"";
    }
    outFile << " />\n";
  }
  outFile << "</bounds>\n";
}

} // namespace TimingAnalysisPass
