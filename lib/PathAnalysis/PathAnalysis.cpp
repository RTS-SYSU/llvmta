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

#include "PathAnalysis/PathAnalysis.h"
#include "Util/Statistics.h"

#include "llvm/Support/raw_ostream.h"

#include <fstream>

using namespace llvm;

namespace TimingAnalysisPass {

PathAnalysis::PathAnalysis(ExtremumType extremum, const VarCoeffVector &objfunc,
                           const std::list<GraphConstraint> &constraints)
    : extremum(extremum), objfunc(objfunc), constraints(constraints),
      returnstatus(0), timeLimit(0.0) {}

PathAnalysis::~PathAnalysis() {}

void PathAnalysis::setTimeLimit(double limit) { this->timeLimit = limit; }

void PathAnalysis::printVarCoeff(std::ostream &stream,
                                 const VarCoeffVector &vec,
                                 std::set<std::string> &integervars,
                                 std::set<std::string> &binaryvars) {
  for (auto &varcoeff : vec) {
    if (varcoeff.second >= 0.0) {
      stream << "+";
    }
    stream << varcoeff.second << " " << varcoeff.first.getName() << "\n";
    if (varcoeff.first.isInteger()) {
      integervars.insert(varcoeff.first.getName());
    } else if (varcoeff.first.isBinary()) {
      binaryvars.insert(varcoeff.first.getName());
    }
  }
}

void PathAnalysis::buildModel() {
  std::set<std::string> integervars;
  std::set<std::string> binaryvars;

  std::ofstream myfile;
  myfile.open("LongestPathCPLEXorGRB.lp", std::ios_base::trunc);
  myfile.precision(std::numeric_limits<double>::max_digits10);
  // Print direction
  switch (extremum) {
  case ExtremumType::Maximum:
    myfile << "Maximize\n";
    break;
  case ExtremumType::Minimum:
    myfile << "Minimize\n";
    break;
  }
  // Print objective function
  printVarCoeff(myfile, objfunc, integervars, binaryvars);
  myfile << "\n\n";
  myfile << "Subject To\n";
  // Print all constraints
  for (auto &constr : constraints) {
    printVarCoeff(myfile, std::get<0>(constr), integervars, binaryvars);
    switch (std::get<1>(constr)) {
    case ConstraintType::LessEqual:
      myfile << " <= ";
      break;
    case ConstraintType::Equal:
      myfile << " = ";
      break;
    case ConstraintType::GreaterEqual:
      myfile << " >= ";
      break;
    }
    myfile << std::get<2>(constr) << "\n";
  }
  // Print restrictions
  if (integervars.size() > 0) {
    myfile << "\nGenerals\n";
    for (auto &ele : integervars) {
      myfile << ele << "\n";
    }
    myfile << "\n";
  }
  if (binaryvars.size() > 0) {
    myfile << "\nBinaries\n";
    for (auto &ele : binaryvars) {
      myfile << ele << "\n";
    }
    myfile << "\n";
  }
  myfile << "\nEnd\n";
  // Close
  myfile.close();
}

void PathAnalysis::dumpSolution(std::ostream &mystream) {
  /* objective value */
  mystream << "Calculated Execution Time Bound: ";
  if (isInfinite()) {
    mystream << "infinite\n";
  } else if (hasSolution()) {
    mystream.setf(std::ios::fixed);
    mystream.precision(0);
    mystream << getSolution() << "\n";

    // Dump path
    std::map<std::string, double> path;
    this->getExtremalPath(path);
    // We might later have LP problems, so it is interesting to see non-rounded
    // variable valuations
    mystream.precision(10);
    for (auto &var2val : path) {
      mystream << var2val.first << ": " << var2val.second << "\n";
    }
  } else {
    mystream << "no solution\n";
  }
}

} // namespace TimingAnalysisPass
