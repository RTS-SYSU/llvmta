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

#ifndef TIMINGANALYSIS_UTIL_PATHANALYSIS_H
#define TIMINGANALYSIS_UTIL_PATHANALYSIS_H

#include <map>
#include <vector>

#include "PathAnalysis/Variable.h"

namespace TimingAnalysisPass {

// Type definition for the graph input of the path analysis
/**
 * Returns a vector with pairs of variables with their respective coefficient.
 */
typedef std::vector<std::pair<Variable, double>> VarCoeffVector;
/**
 * Scla eall coefficients within the given vector.
 */
void scaleVarCoeffVector(VarCoeffVector &v, double s);
/**
 * Calculate the value of a objective function for a given path (a given
 * variable to value mapping)
 */
double getObjectiveValue(const VarCoeffVector &objective,
                         const std::map<std::string, double> valuation);

/**
 * The type of comparisons in constraints.
 */
enum class ConstraintType {
  LessEqual = 1,
  Equal = 3,
  GreaterEqual = 2,
};

/**
 * The possible types of extrema.
 */
enum class ExtremumType { Minimum = 0, Maximum = 1 };

/**
 * An additional graph constraint is always of the following form:
 * 1) A Vector of edges (this will be the ILP variables) with coefficients. The
 * edges are summed up. 2) ConstraintType is the type of comparison 3) A
 * constant to compare with
 */
typedef std::tuple<VarCoeffVector, ConstraintType, double> GraphConstraint;
} // namespace TimingAnalysisPass

#endif
