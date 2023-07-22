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

#ifndef PATHANALYSIS_H
#define PATHANALYSIS_H

#include <iostream>
#include <list>
#include <map>
#include <set>

#include "Util/Options.h"

#include "llvm/Support/Debug.h"

#include "AnalysisFramework/AnalysisResults.h"
#include "Util/UtilPathAnalysis.h"

namespace TimingAnalysisPass {

/**
 * Path Analysis interface.
 * Takes the results from the microarchitectural analysis, as well as
 * further constraints on the possible execution paths, e.g. loop bounds,
 * and calculates the longest path of the given program on the underlying
 * hardware platform.
 */
class PathAnalysis {
public:
  /**
   * Constructor
   */
  PathAnalysis(ExtremumType extremum, const VarCoeffVector &objfunc,
               const std::list<GraphConstraint> &constraints);

  virtual ~PathAnalysis();

  /**
   * This method adds a maximum time limit that
   * the solver is allowed to look for an optimal
   * solution. If the solution is not found within
   * the time limit, then the solver returns
   * the best bound it could verify within the
   * limit. Usually, this bound is sufficiently tight.
   * A value of 0 means no limit.
   *
   * The limit is so far only supported when
   * using CPLEX as solver.
   * TODO: Try to also support this for lp_solve.
   */
  void setTimeLimit(double limit);
  /**
   * Calculates (an approximation of) the extremal execution path.
   * This might involve building an ILP.
   * Returns true if all went well, false if there was an error.
   */
  virtual bool calculateExtremalPath() = 0;

  /**
   * If calculation is done, is the solution unbounded?
   */
  virtual bool isInfinite() = 0;
  /**
   * If calculation is done, is there a valid solution?
   */
  virtual bool hasSolution() = 0;
  /**
   * If hasSolution(), return a valid execution time bound.
   */
  virtual BoundItv getSolution() = 0;
  /**
   * Return a possible shortest/longest path, i.e. a variable valuation that
   * correspond to the computed bound.
   */
  virtual void getExtremalPath(std::map<std::string, double> &valuation) = 0;

  /**
   * If hasSolution(), this can be used to find out if
   * the solution was a bound.
   */
  virtual bool isSolutionBound() = 0;

  /**
   * Dump the results of the path analysis.
   * Besides the computed time bound, the results comprise the identified
   * longest path.
   */
  virtual void dump(std::ostream &mystream) = 0;
  void dumpSolution(std::ostream &mystream);

protected:
  /**
   * Build the ilp formulation of the path analysis problem.
   * By default, dumps a file that can be read by the LP-solver.
   */
  virtual void buildModel();
  void printVarCoeff(std::ostream &stream, const VarCoeffVector &vec,
                     std::set<std::string> &integervars,
                     std::set<std::string> &binaryvars);

  // The ILP formulation in our own intermediate format
  ExtremumType extremum;
  const VarCoeffVector &objfunc;
  const std::list<GraphConstraint> &constraints;

  /**
   * The return status of cplex/lp_solve - normalized to lp_solve return codes.
   */
  int returnstatus;
  /**
   * See declaration of void setTimeLimit(double)
   * for details.
   */
  double timeLimit;
};

} // namespace TimingAnalysisPass

#endif
