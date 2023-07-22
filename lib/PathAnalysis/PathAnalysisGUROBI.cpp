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

#include "Util/Options.h"

#ifdef GUROBIINSTALLED

#include "PathAnalysis/PathAnalysisGUROBI.h"

namespace TimingAnalysisPass {

PathAnalysisGUROBI::PathAnalysisGUROBI(
    ExtremumType extremum, const VarCoeffVector &objfunc,
    const std::list<GraphConstraint> &constraints)
    : PathAnalysis(extremum, objfunc, constraints), gurobienv(nullptr),
      gurobi_lp(nullptr) {}

PathAnalysisGUROBI::~PathAnalysisGUROBI() {
  if (gurobi_lp != nullptr) {
    if (GRBfreemodel(gurobi_lp)) {
      errs() << "Unable to free gurobi model.\n";
    }
  }
  if (gurobienv != nullptr) {
    GRBfreeenv(gurobienv);
  }
}

void PathAnalysisGUROBI::getExtremalPath(
    std::map<std::string, double> &valuation) {
  assert(hasSolution() &&
         "The path problem has no solution, cannot return a path");

  int numvars;
  if (int error = GRBgetintattr(gurobi_lp, GRB_INT_ATTR_NUMVARS, &numvars)) {
    errs() << "Error obtaining number of variables: " << error << "\n";
    return;
  }

  char *varname;
  double x;
  int error;
  for (int j = 0; j < numvars; ++j) {
    if ((error = GRBgetstrattrelement(gurobi_lp, GRB_STR_ATTR_VARNAME, j,
                                      &varname))) {
      errs() << "Error obtaining variable name: " << error << "\n";
      return;
    }
    if ((error = GRBgetdblattrelement(gurobi_lp, GRB_DBL_ATTR_X, j, &x))) {
      errs() << "Error obtaining variable valuation: " << error << "\n";
      return;
    }
    valuation.insert(std::make_pair(varname, (x == -0.0) ? 0.0 : x));
  }
}

bool PathAnalysisGUROBI::calculateExtremalPath() {
  buildModel();

  /* Init Gurobi environment */
  if (GRBloadenv(&gurobienv, nullptr)) {
    errs() << "Problem creating Gurobi environment: "
           << GRBgeterrormsg(gurobienv) << "\n";
    return false;
  }
  /* Turn off verbose output */
  if (GRBsetintparam(gurobienv, GRB_INT_PAR_OUTPUTFLAG, 0)) {
    errs() << "Unable to disable verbose output: " << GRBgeterrormsg(gurobienv)
           << "\n";
  }
  /* Read dumped model */
  if (GRBreadmodel(gurobienv, "LongestPathCPLEXorGRB.lp", &gurobi_lp)) {
    errs() << "Problem reading dumped Gurobi model: "
           << GRBgeterrormsg(gurobienv) << "\n";
    return false;
  }
  /* Extract model environment */
  auto modelenv = GRBgetenv(gurobi_lp);
  assert(modelenv != nullptr);

  /**
   * Set a time limit if one is specified.
   */
  if (this->timeLimit > 0.0) {
    if (GRBsetdblparam(modelenv, GRB_DBL_PAR_TIMELIMIT, this->timeLimit)) {
      errs() << "Unable to set time limit for Gurobi: "
             << GRBgeterrormsg(gurobienv) << "\n";
      return false;
    }
  }

  if (LpSolverEffort != LpSolverEffortType::MAXIMAL) {
    /* Solve problem with default tolerances */
    if (GRBoptimize(gurobi_lp)) {
      errs() << "Gurobi failed solving model: " << GRBgeterrormsg(gurobienv)
             << "\n";
      return false;
    }
  }

  if (LpSolverEffort != LpSolverEffortType::MINIMAL) {
    /* Set tolerance parameters in the same way as for CPLEX */
    if (GRBsetdblparam(modelenv, GRB_DBL_PAR_MIPGAP, 0.0)) {
      errs() << "Unable to set parameter MIPGap: " << GRBgeterrormsg(gurobienv)
             << "\n";
      return false;
    }
    if (GRBsetdblparam(modelenv, GRB_DBL_PAR_MIPGAPABS, 0.0)) {
      errs() << "Unable to set parameter MIPGapAbs: "
             << GRBgeterrormsg(gurobienv) << "\n";
      return false;
    }
    if (GRBsetdblparam(modelenv, GRB_DBL_PAR_INTFEASTOL, 1.0e-6)) {
      errs() << "Unable to set parameter IntFeasTol: "
             << GRBgeterrormsg(gurobienv) << "\n";
      return false;
    }
    // If time limit not set explicitly use a default one for the limited case
    if (LpSolverEffort == LpSolverEffortType::LIMITED &&
        this->timeLimit == 0.0) {
      if (GRBsetdblparam(modelenv, GRB_DBL_PAR_TIMELIMIT, 300)) { // 300 seconds
        errs() << "Unable to set time limit for Gurobi: "
               << GRBgeterrormsg(gurobienv) << "\n";
        return false;
      }
    }
    /* Solve problem with harder tolerances */
    if (GRBoptimize(gurobi_lp)) {
      errs() << "Gurobi failed solving model: " << GRBgeterrormsg(gurobienv)
             << "\n";
      return false;
    }
  }

  /*int solcount;
  GRBgetintattr(gurobi_lp, GRB_INT_ATTR_SOLCOUNT, &solcount);
  errs() << "Gurobi computed " << solcount << " solutions.\n";*/

  GRBgetintattr(gurobi_lp, GRB_INT_ATTR_STATUS, &this->returnstatus);
  return true;
}

bool PathAnalysisGUROBI::isInfinite() {
  assert(gurobi_lp && "Isinfinite on non-existing model.\n");
  return returnstatus == GRB_UNBOUNDED || returnstatus == GRB_INF_OR_UNBD;
}

bool PathAnalysisGUROBI::hasSolution() {
  if (gurobi_lp != nullptr) {
    if (returnstatus == GRB_TIME_LIMIT) {
      double boundval;
      int error = GRBgetdblattr(gurobi_lp, GRB_DBL_ATTR_OBJBOUNDC, &boundval);
      return !error;
    }
    if (returnstatus == GRB_OPTIMAL) {
      double objval;
      int error = GRBgetdblattr(gurobi_lp, GRB_DBL_ATTR_OBJVAL, &objval);
      return !error;
    }
  }
  return false;
}

BoundItv PathAnalysisGUROBI::getSolution() {
  assert(hasSolution() && "The path problem has no solution");
  double objval = 0.0;
  double objbound = 0.0;

  if (int error = GRBgetdblattr(gurobi_lp, GRB_DBL_ATTR_OBJBOUNDC, &objbound)) {
    errs()
        << "Error retrieving the currently best bound on the objective values: "
        << error << "\n";
  }
  if (int error = GRBgetdblattr(gurobi_lp, GRB_DBL_ATTR_OBJVAL, &objval)) {
    errs() << "Error retrieving the optimal objective value: " << error << "\n";
  }

  double &lb = (extremum == ExtremumType::Maximum ? objval : objbound);
  double &ub = (extremum == ExtremumType::Maximum ? objbound : objval);

  // have to perform an epsilon comparison, since the lower
  // bound might slightly exceed the upper bound
  assert(lb <= ub + 0.01 && "The lower bound must not exceed the upper bound.");

  return BoundItv{lb, ub};
}

bool PathAnalysisGUROBI::isSolutionBound() {
  assert(hasSolution() && "The path problem has no solution");
  if (returnstatus == GRB_TIME_LIMIT) {
    return true;
  }
  return false;
}

void PathAnalysisGUROBI::dump(std::ostream &mystream) {
  mystream << "Detailed results of the Path Analysis (gurobi):\n"
           << "-----------------------------------------------\n";

  bool optimal = false;

  if (gurobi_lp == nullptr) {
    mystream << "No ILP generated and solved yet\n";
    return;
  }
  switch (returnstatus) {
  case GRB_OPTIMAL:
    optimal = true;
    mystream << "We found an optimal solution.\n";
    break;
  case GRB_TIME_LIMIT:
    optimal = this->timeLimit == 0.0; // Count time limit as optimal if the user
                                      // has not specified a time out
    mystream << "We ran into a time limit.\n";
    break;
  case GRB_INFEASIBLE:
    mystream << "The model is infeasible.\n";
    break;
  case GRB_UNBOUNDED:
    mystream << "The model is unbounded.\n";
    break;
  case GRB_INF_OR_UNBD:
    mystream << "The model is infeasible or unbounded.\n";
    break;
  default:
    mystream << "An unknown gurobi status code: " << returnstatus << "\n";
    break;
  }

  if (optimal) {
    this->dumpSolution(mystream);
  }
}

} // namespace TimingAnalysisPass

#endif
