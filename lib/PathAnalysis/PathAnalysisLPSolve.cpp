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

#include "PathAnalysis/PathAnalysisLPSolve.h"

namespace TimingAnalysisPass {

PathAnalysisLPSolve::PathAnalysisLPSolve(
    ExtremumType extremum, const VarCoeffVector &objfunc,
    const std::list<GraphConstraint> &constraints)
    : PathAnalysis(extremum, objfunc, constraints), lp(nullptr) {}

PathAnalysisLPSolve::~PathAnalysisLPSolve() {
  // Delete it
  delete_lp(lp);
}

void PathAnalysisLPSolve::buildModel() {
  // build the lp here
  createEmptyLp();

  // add constraints
  addAdditionalConstraints();

  // add objective function
  constructObjectiveFunction();
}

void PathAnalysisLPSolve::addAdditionalConstraints() {
  DEBUG_WITH_TYPE("ilp", dbgs() << "Building " << constraints.size()
                                << " additional constraints.\n");

  // enter row mode to build the lp faster
  set_add_rowmode(lp, true);

  for (auto &lc : constraints) {
    addConstraint(lc);
  }

  // exit row mode
  set_add_rowmode(lp, false);

  DEBUG_WITH_TYPE("ilp", dbgs()
                             << "Finished building additional constraints.\n");
}

void PathAnalysisLPSolve::addConstraint(const GraphConstraint &cstr) {
  VarCoeffVector variables = std::get<0>(cstr);
  auto equality = std::get<1>(cstr);
  auto bound = std::get<2>(cstr);

  REAL *row = new REAL[variables.size()];
  int *colno = new int[variables.size()];

  int count = varCoeffVectorIntoArrays(variables, row, colno);

  // add a constraint as defined above with less equal 0; LE -> 1
  unsigned char ret = add_constraintex(lp, count, row, colno,
                                       static_cast<int>(equality), bound);
  if (!ret) {
    std::cerr << "Failed to add constraint\n";
    abort();
  }

  delete[] row;
  delete[] colno;
}

int PathAnalysisLPSolve::varCoeffVectorIntoArrays(
    const VarCoeffVector &variables, REAL *row, int *colno) {
  std::map<int, int> varId2index;

  int j = 0;
  for (auto &var2coeff : variables) {
    int varId = getVarId(var2coeff.first);
    // variable added to constraint for the first time
    if (varId2index.count(varId) == 0) {
      colno[j] = varId;
      row[j] = var2coeff.second;
      varId2index[varId] = j;
      j++;
    }
    // repeated use of the same variable
    // -> add the coefficient to the previous ones
    else {
      int oldJ = varId2index[varId];
      assert(colno[oldJ] == varId &&
             "The index should lead to the cell that stores the varId!");
      row[oldJ] += var2coeff.second;
    }
  }

  return j;
}

void PathAnalysisLPSolve::createEmptyLp() {
  // init lp with the correct number of variables (one for each edge)
  if ((lp = make_lp(0, 0)) == nullptr) {
    assert(0 && "Error while creating empty LP");
  }
}

unsigned PathAnalysisLPSolve::getVarId(const Variable &var) {
  // return the var id if it already exists
  if (var2idMap.count(var) > 0) {
    return var2idMap.at(var);
  }

  // otherwise assign the next id to the var
  unsigned assignedId = nextVarId++;
  assert(((int)assignedId) >= 0 && "Used up all possible columns.");
  // ^^ if we find an example for which the range of positive
  // integers is not enough, try if negative integers are also
  // OK for the lpsolve API by using the following assert instead:
  // assert(assignedId != 0 && "Used up all possible columns.");
  var2idMap.emplace(var, assignedId);

  // add a the new column to the lp
  auto status = add_columnex(lp, 0, nullptr, nullptr);
  assert(status && "Not been able to add a column to the lp.");

  // set the column name
  {
    auto varName = var.getName();
    DEBUG_WITH_TYPE("ilp", dbgs() << "Adding variable \"" << varName
                                  << "\" to the ILP.\n");
    char *name = new char[varName.length() + 1];
    name[varName.length()] = 0;
    memcpy(name, varName.c_str(), varName.size());
    status = set_col_name(lp, assignedId, name);
    assert(status && "Not been able to set the column name.");
    delete[] name;
  }

  // set the possible range for the variable
  if (var.isBinary()) {
    status = set_binary(lp, assignedId, true);
    assert(status && "Not been able to declare the variable as binary.");
  } else if (var.isInteger()) {
    status = set_int(lp, assignedId, true);
    assert(status && "Not been able to declare the variable as integer.");
  }

  return assignedId;
}

void PathAnalysisLPSolve::constructObjectiveFunction() {
  DEBUG_WITH_TYPE("ilp", dbgs() << "Building objective function.\n");

  REAL *row = new REAL[objfunc.size()];
  int *colno = new int[objfunc.size()];

  int count = varCoeffVectorIntoArrays(objfunc, row, colno);

  // set the objective in lpsolve
  if (!set_obj_fnex(lp, count, row, colno)) {
    assert(0 && "Could not set objective function");
  }

  // free allocated memory
  delete[] row;
  delete[] colno;

  // set the object direction according to maximize
  auto setDirection = extremum == ExtremumType::Maximum ? set_maxim : set_minim;
  setDirection(lp);

  DEBUG_WITH_TYPE("ilp", dbgs() << "Finished building objective function.\n");
}

void PathAnalysisLPSolve::getExtremalPath(
    std::map<std::string, double> &valuation) {
  assert(hasSolution() &&
         "The path problem has no solution, cannot return a path");

  // variable values
  REAL *row = new REAL[var2idMap.size()];
  assert(row != nullptr && "Not enough space to dump results");
  get_variables(lp, row);
  for (auto &v2i : var2idMap) {
    valuation.insert(
        std::make_pair(get_col_name(lp, v2i.second), row[v2i.second - 1]));
  }
  delete[] row;
}

bool PathAnalysisLPSolve::calculateExtremalPath() {
  buildModel();

  // Dump objective + constraints in the lp-format (that can be read by some
  // lp-solvers, e.g. CPLEX)
  char lpfilename[] = "LongestPath.lp";
  write_lp(lp, lpfilename);

  assert(LpSolver == LpSolverType::LPSOLVE && "Unknown lp solver choosen");

  // Set normal verbosity level
  set_verbose(lp, IMPORTANT);

  // Now let lpsolve calculate a solution
  this->returnstatus = solve(lp);
  return true;
}

bool PathAnalysisLPSolve::isInfinite() {
  return (lp != nullptr) &&
         (returnstatus == UNBOUNDED || is_infinite(lp, get_objective(lp)));
}

bool PathAnalysisLPSolve::hasSolution() {
  return (lp != nullptr) && (returnstatus == OPTIMAL);
}

BoundItv PathAnalysisLPSolve::getSolution() {
  assert(hasSolution() && "The path problem has no solution");
  double objval = 0.0;
  objval = get_objective(lp);
  return BoundItv{objval, objval};
}

bool PathAnalysisLPSolve::isSolutionBound() {
  assert(hasSolution() && "The path problem has no solution");
  return false;
}

void PathAnalysisLPSolve::dump(std::ostream &mystream) {
  mystream << "Detailed results of the Path Analysis (lpsolve):\n"
           << "------------------------------------------------\n";

  bool optimal = false;

  if (lp == nullptr) {
    mystream << "No ILP generated and solved yet\n";
    return;
  }
  switch (returnstatus) {
  case OPTIMAL:
    optimal = true;
    mystream << "We found an optimal solution.\n";
    break;
  case NOMEMORY:
    mystream << "LP solver runs out of memory.\n";
    break;
  case SUBOPTIMAL:
    mystream << "We only found a suboptimal solution due to time and memory "
                "constraints.\n";
    break;
  case INFEASIBLE:
    mystream << "The model is infeasible.\n";
    break;
  case UNBOUNDED:
    mystream << "The model is unbounded.\n";
    break;
  default:
    mystream << "An unknown lp_solve error occurred: " << returnstatus << "\n";
    break;
  }
  if (optimal) {
    this->dumpSolution(mystream);
  }
}

} // namespace TimingAnalysisPass
