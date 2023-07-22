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

#ifdef CPLEXINSTALLED

#include "PathAnalysis/PathAnalysisCPLEX.h"

namespace TimingAnalysisPass {

PathAnalysisCPLEX::PathAnalysisCPLEX(
    ExtremumType extremum, const VarCoeffVector &objfunc,
    const std::list<GraphConstraint> &constraints)
    : PathAnalysis(extremum, objfunc, constraints), env(nullptr),
      cplex_lp(nullptr) {}

PathAnalysisCPLEX::~PathAnalysisCPLEX() {
  if (cplex_lp != nullptr) {
    assert(env != nullptr);
    if (CPXfreeprob(env, &cplex_lp) != 0) {
      errs() << "Unable to free cplex problem.\n";
    }
  }
  if (env != nullptr) {
    if (CPXcloseCPLEX(&env) != 0) {
      errs() << "Unable to close cplex environment.\n";
    }
  }
}

void PathAnalysisCPLEX::getExtremalPath(
    std::map<std::string, double> &valuation) {
  assert(hasSolution() &&
         "The path problem has no solution, cannot return a path");

  // How many variables do we have?
  unsigned numcols = CPXgetnumcols(this->env, this->cplex_lp);
  // Get the valuation for all these variables
  int status;
  double *variableValuation = new double[numcols];
  status =
      CPXgetx(this->env, this->cplex_lp, variableValuation, 0, numcols - 1);
  assert(status == 0 && "Could not retrieve variable valuation");

  // Get the names for all these variables
  int spacerequired;
  status = CPXgetcolname(this->env, this->cplex_lp, NULL, NULL, 0,
                         &spacerequired, 0, numcols - 1);
  assert(status == CPXERR_NEGATIVE_SURPLUS &&
         "Error determining space needs for column names");
  int colnamespace = -spacerequired;
  assert(colnamespace > 0 && "No names associated with problem");
  auto colnames = (char **)new char *[sizeof(char *) * numcols];
  auto colnamestore = (char *)new char[colnamespace];
  status = CPXgetcolname(this->env, this->cplex_lp, colnames, colnamestore,
                         colnamespace, &spacerequired, 0, numcols - 1);
  assert(status == 0 && "CPXgetcolname failed");

  // Dump the valuations
  for (unsigned j = 0; j < numcols; ++j) {
    valuation.insert(std::make_pair(colnames[j], variableValuation[j]));
  }

  delete[] variableValuation;
}

bool PathAnalysisCPLEX::calculateExtremalPath() {
  this->buildModel();

  int status = 0;

  /* Init CPLEX environment */
  env = CPXopenCPLEX(&status);
  if (env == NULL) {
    errs() << "Problem creating CPLEX environment: Error " << status << "\n";
    return false;
  }
  /* Create empty model */
  cplex_lp = CPXcreateprob(env, &status, "LongestPathCPLEXorGRB.lp");
  if (cplex_lp == NULL) {
    errs() << "Problem creating CPLEX model: Error " << status << "\n";
    return false;
  }
  /* Read dumped model */
  status = CPXreadcopyprob(env, cplex_lp, "LongestPathCPLEXorGRB.lp", NULL);
  if (status) {
    errs() << "Problem reading dumped CPLEX model: Error " << status << "\n";
    return false;
  }
  /* Set algorithm */
  status = CPXsetintparam(env, CPX_PARAM_LPMETHOD, CPX_ALG_AUTOMATIC);
  if (status) {
    errs() << "Could not set CPLEX algorithm: Error " << status << "\n";
    return false;
  }
  //	/* Disable presolve for testing */
  //	status = CPXsetintparam(env, CPX_PARAM_PREIND, CPX_OFF);
  //	if (status) {
  //		errs() << "Could not set parameter CPX_PARAM_PREIND.\n";
  //		return;
  //	}

  /**
   * Set a time limit if one is specified.
   */
  if (this->timeLimit > 0.0) {
    status = CPXsetdblparam(env, CPX_PARAM_TILIM, this->timeLimit);
    if (status) {
      errs() << "Could not set parameter CPX_PARAM_TILIM: Error " << status
             << "\n";
      return false;
    }
  }

  if (LpSolverEffort != LpSolverEffortType::MAXIMAL) {
    /* Solve problem with default tolerances */
    status = CPXmipopt(env, cplex_lp);
    if (status) {
      errs() << "CPLEX failed solving model: Error " << status << "\n";
      return false;
    }
  }

  if (LpSolverEffort != LpSolverEffortType::MINIMAL) {
    /* Set 0 tolerance to epgap and epagap */
    /* For more information, see shipped HTML documentation under:
     * Parameters of CPLEX -> Parameters Reference Manual -> Topical list of
     * parameters
     * -> MIP tolerance -> (absolute|relative) MIP gap tolerance */
    status = CPXsetdblparam(env, CPX_PARAM_EPGAP, 0.0);
    if (status) {
      errs() << "Could not set parameter CPX_PARAM_EPGAP: Error " << status
             << "\n";
      return false;
    }
    status = CPXsetdblparam(env, CPX_PARAM_EPAGAP, 0.0);
    if (status) {
      errs() << "Could not set parameter CPX_PARAM_EPAGAP: Error " << status
             << "\n";
      return false;
    }
    /* Try as hard as possible to make all integer variable
     * values really integer. */
    status = CPXsetdblparam(env, CPX_PARAM_EPINT, 1.0e-6);
    if (status) {
      errs() << "Could not set parameter CPX_PARAM_EPINT: Error " << status
             << "\n";
      return false;
    }
    // If time limit not set explicitly use a default one for the limited case
    if (LpSolverEffort == LpSolverEffortType::LIMITED &&
        this->timeLimit == 0.0) {
      status = CPXsetdblparam(env, CPX_PARAM_TILIM, 300);
      if (status) {
        errs() << "Could not set parameter CPX_PARAM_TILIM: Error " << status
               << "\n";
        return false;
      }
    }
    /* Solve problem with harder tolerances */
    status = CPXmipopt(env, cplex_lp);
    if (status) {
      errs() << "CPLEX failed solving model: Error " << status << "\n";
      return false;
    }
  }

  this->returnstatus = CPXgetstat(env, cplex_lp);
  return true;
}

bool PathAnalysisCPLEX::isInfinite() {
  if (returnstatus == CPXMIP_TIME_LIM_FEAS ||
      returnstatus == CPXMIP_TIME_LIM_INFEAS) {
    double boundval;
    int status = CPXgetbestobjval(env, cplex_lp, &boundval);
    return (cplex_lp != nullptr) &&
           (boundval == std::numeric_limits<double>::infinity() ||
            boundval == -std::numeric_limits<double>::infinity() ||
            status == CPXERR_NO_SOLN);
  } else {
    double objval;
    int status = CPXgetobjval(env, cplex_lp, &objval);
    return (cplex_lp != nullptr) && ((returnstatus != CPXMIP_OPTIMAL &&
                                      returnstatus != CPXMIP_OPTIMAL_TOL) ||
                                     (status == CPXERR_NO_SOLN));
  }
}

bool PathAnalysisCPLEX::hasSolution() {
  if (returnstatus == CPXMIP_OPTIMAL_TOL ||
      returnstatus == CPXMIP_TIME_LIM_FEAS ||
      returnstatus == CPXMIP_TIME_LIM_INFEAS) {
    double boundval;
    int status = CPXgetbestobjval(env, cplex_lp, &boundval);
    return (cplex_lp != nullptr) && (!status);
  } else {
    double objval;
    int status = CPXgetobjval(env, cplex_lp, &objval);
    return (cplex_lp != nullptr) && (!status);
  }
}

BoundItv PathAnalysisCPLEX::getSolution() {
  assert(hasSolution() && "The path problem has no solution");
  double objval = 0.0;
  double objbound = 0.0;

  if (int error = CPXgetbestobjval(env, cplex_lp, &objbound)) {
    errs()
        << "Error retrieving the currently best bound on the objective values: "
        << error << "\n";
  }
  if (int error = CPXgetobjval(env, cplex_lp, &objval)) {
    errs() << "Error retrieving the optimal objective value: " << error << "\n";
  }

  double &lb = (extremum == ExtremumType::Maximum ? objval : objbound);
  double &ub = (extremum == ExtremumType::Maximum ? objbound : objval);

  // have to perform an epsilon comparison, since the lower
  // bound might slightly exceed the upper bound
  assert(lb <= ub + 0.01 && "The lower bound must not exceed the upper bound.");

  return BoundItv{lb, ub};
}

bool PathAnalysisCPLEX::isSolutionBound() {
  assert(hasSolution() && "The path problem has no solution");
  if (returnstatus == CPXMIP_OPTIMAL_TOL ||
      returnstatus == CPXMIP_TIME_LIM_FEAS ||
      returnstatus == CPXMIP_TIME_LIM_INFEAS) {
    return true;
  }
  return false;
}

void PathAnalysisCPLEX::dump(std::ostream &mystream) {
  mystream << "Detailed results of the Path Analysis (cplex):\n"
           << "----------------------------------------------\n";

  bool optimal = false;

  if (cplex_lp == nullptr) {
    mystream << "No ILP generated and solved yet\n";
    return;
  }
  switch (returnstatus) {
  case CPXMIP_OPTIMAL:
    optimal = true;
    mystream << "We found an optimal solution.\n";
    break;
  case CPXMIP_OPTIMAL_TOL:
    optimal = true;
    mystream << "We found a solution that is not necessarily optimal,"
             << "but a bound to the optimum that is provably within the "
                "defined tolerance.\n";
    break;
  case CPXMIP_TIME_LIM_FEAS:
  case CPXMIP_TIME_LIM_INFEAS:
    optimal = true;
    mystream << "We found a solution that is not necessarily optimal,"
             << "but a bound to the optimum that was calculated until the "
                "solver timed out.\n";
    break;
  case CPXMIP_INFEASIBLE:
    mystream << "The model is infeasible.\n";
    break;
  case CPXMIP_UNBOUNDED:
    mystream << "The model is unbounded.\n";
    break;
  case CPXMIP_INForUNBD:
    mystream << "The model is infeasible or unbounded.\n";
    break;
  default:
    mystream << "An unknown CPLEX status code: " << returnstatus << "\n";
    break;
  }

  if (optimal) {
    this->dumpSolution(mystream);
  }
}

} // namespace TimingAnalysisPass

#endif
