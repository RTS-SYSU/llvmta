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

#include "Memory/crpd/CacheRelatedPreemptionDelay.h"
#include "PathAnalysis/PathAnalysisCPLEX.h"
#include "PathAnalysis/PathAnalysisGUROBI.h"
#include "PathAnalysis/PathAnalysisLPSolve.h"
#include "Util/Options.h"
#include "Util/Util.h"

#include "llvm/Support/Format.h"

#include <boost/multiprecision/cpp_int.hpp>
#include <iostream>

#include "LLVMPasses/DispatchPathAnalysis.h"

using namespace boost::multiprecision;

namespace TimingAnalysisPass {

///////////////////////////////////////////////////////////////////////////////
/// Common: Path Analysis /////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

/*
 * Global Var remembering which file has already been
 * written to by doPathAnalysis() in the current
 * program run.
 */
std::set<std::string> writtenByDoPathAnalysis;

boost::optional<BoundItv>
doPathAnalysis(const std::string identifier, const ExtremumType extremumType,
               const VarCoeffVector &objective,
               const std::list<GraphConstraint> &constraints,
               LPAssignment *extpath, const double timeLimit) {
  // Create the path analysis.
  std::unique_ptr<PathAnalysis> pathAnalysis;

  // Fallback to lpsolve if gurobi license is missing.
#ifdef GUROBIINSTALLED
  std::string Output = exec("gurobi_cl");
  if (Output.find("Error") != std::string::npos) {
    LpSolver = LpSolverType::LPSOLVE;
    VERBOSE_PRINT(" -> No valid Gurobi License found!\n");
  }
#endif
  switch (LpSolver) {
  case LpSolverType::LPSOLVE:
    if (!QuietMode)
      VERBOSE_PRINT(" -> Using Solver: LPsolve\n");
    pathAnalysis.reset(
        new PathAnalysisLPSolve(extremumType, objective, constraints));
    break;
#ifdef CPLEXINSTALLED
  case LpSolverType::CPLEX:
    if (!QuietMode)
      VERBOSE_PRINT(" -> Using Solver: CPLEX\n");
    pathAnalysis.reset(
        new PathAnalysisCPLEX(extremumType, objective, constraints));
    break;
#endif
#ifdef GUROBIINSTALLED
  case LpSolverType::GUROBI:
    if (!QuietMode)
      VERBOSE_PRINT(" -> Using Solver: Gurobi\n");
    pathAnalysis.reset(
        new PathAnalysisGUROBI(extremumType, objective, constraints));
    break;
#endif
  }

  // Set the time limit. 0.0 means no time limit!
  pathAnalysis->setTimeLimit(timeLimit);

  // Perform the path analysis.
  if (!pathAnalysis->calculateExtremalPath()) {
    errs() << "Path analysis failed. Aborting\n";
    exit(1);
  }

  // Dump the results to a file.
  VERBOSE_PRINT(" -> Finished Path Analysis\n");
  const bool maximum = extremumType == ExtremumType::Maximum;
  const std::string outputFileName =
      "PathAnalysis_" + identifier + "_" + (maximum ? "Max" : "Min") + ".txt";
  if (!QuietMode) {
    std::ofstream myfile;
    auto openMode = writtenByDoPathAnalysis.count(outputFileName) == 0
                        ? std::ios_base::trunc
                        : std::ios_base::app;
    writtenByDoPathAnalysis.insert(outputFileName);
    myfile.open(outputFileName, openMode);
    pathAnalysis->dump(myfile);
    myfile.close();
  }

  // Return extremal value and (optionally) extremal path.
  if (pathAnalysis->isInfinite()) {
    return boost::none;
  } else if (pathAnalysis->hasSolution()) {
    if (extpath != nullptr) {
      pathAnalysis->getExtremalPath(*extpath);
    }
    return pathAnalysis->getSolution();
  } else {
    errs() << "Path analysis could not compute valid result, see "
           << outputFileName << " for details.\n";
    return boost::none;
  }
}

void calculateSoundSlope(double lower, double upper,
                         const std::list<GraphConstraint> &constraints,
                         const VarCoeffVector ubtime,
                         const Variable interferencevar,
                         double boundwithoutint) {
  // Search slope s, such that wcetBound + s * interference >= curve-value
  std::function<boost::optional<BoundItv>(double)> checkSlopeCandidate =
      [&](double slopeCandidate) {
        auto slopeconstraints = constraints;

        VarCoeffVector feasCheck(ubtime);
        feasCheck.push_back(std::make_pair(interferencevar, -slopeCandidate));
        GraphConstraint feasCheckConstr = std::make_tuple(
            feasCheck, ConstraintType::GreaterEqual, boundwithoutint);
        slopeconstraints.push_back(feasCheckConstr);

        auto feasResult =
            doPathAnalysis("SlopeFeasCheck", ExtremumType::Maximum, feasCheck,
                           slopeconstraints);

        return feasResult;
      };

  std::function<bool(const boost::optional<BoundItv> &)> isFeasible =
      [boundwithoutint](const boost::optional<BoundItv> &feasResult) {
        return feasResult && feasResult.get().lb > boundwithoutint + 0.0001;
      };

  double slopeLowerBound = lower;
  double slopeUpperBound = upper;

  assert(isFeasible(checkSlopeCandidate(slopeLowerBound)) &&
         "Lower slope bound already infeasible");
  assert(!isFeasible(checkSlopeCandidate(slopeUpperBound)) &&
         "Upper slope bound still feasible");

  while (slopeUpperBound - slopeLowerBound > 0.2) {
    outs() << "Current slope interval: [" << slopeLowerBound << ", "
           << slopeUpperBound << "]\n";
    double slopeToTest =
        (slopeUpperBound - slopeLowerBound) / 2.0 + slopeLowerBound;
    outs() << "Check new candidate: " << slopeToTest << "\n";
    auto testres = checkSlopeCandidate(slopeToTest);
    if (isFeasible(testres)) {
      outs() << "Was feasible\n";
      slopeLowerBound = slopeToTest;
    } else {
      outs() << "Was infeasible\n";
      slopeUpperBound = slopeToTest;
    }
  }
  outs() << "Result slope interval: [" << slopeLowerBound << ", "
         << slopeUpperBound << "]\n";

  AnalysisResults &ar = AnalysisResults::getInstance();
  ar.registerResult("SlopeFromWCETZeroInterference", slopeUpperBound);
}

void calculateCompositionalBaseBound(
    const std::list<GraphConstraint> &constraints,
    const GraphConstraint &interferenceConstr, const VarCoeffVector ubtime,
    const Variable interferencevar, double fixedSlope) {
  AnalysisResults &ar = AnalysisResults::getInstance();

  auto compconstraints = constraints;
  compconstraints.push_back(interferenceConstr);

  // To calculate the compositional base bound, compute the maximal difference
  // between the WCET and the direct effect interference
  VarCoeffVector optCurveApprox(ubtime);
  optCurveApprox.push_back(std::make_pair(interferencevar, -fixedSlope));

  // Calculate the compositional base bound
  auto solCompWcetBase = doPathAnalysis("Comp Base Time", ExtremumType::Maximum,
                                        optCurveApprox, compconstraints);

  ar.registerResult("CompositionalBaseWCET", solCompWcetBase);
  // outs() << "Compositional Base Bound: " << solCompWcetBase.get() << "\n";
}

void dumpInterferenceResponseCurve(
    cpp_int rightmostSamplepoint, unsigned numSamples,
    const std::list<GraphConstraint> &constraints, const VarCoeffVector ubTime,
    const Variable interferencevar, std::string suffix, unsigned zoomFactor,
    cpp_int xstepScale) {
  if (rightmostSamplepoint == -1 || rightmostSamplepoint == 0) {
    outs() << "There is no rightmost sample point (or it is zero), skipping "
              "producing interference response curve\n";
    return;
  }

  assert(rightmostSamplepoint > 0);

  // prepare the additional constraint on the number
  // of blocked cycles
  auto constraintSet = constraints;
  constraintSet.push_back(constraintSet.back()); // dummy, will be overwritten

  // exact number of samples
  unsigned numberOfSamples = numSamples;
  assert(numberOfSamples >= 2); // sample at least start and end value

  std::ofstream csvFile;
  cpp_int valueAtZero(-1);

  VarCoeffVector interferenceVarVector;
  interferenceVarVector.push_back(std::make_pair(interferencevar, 1.0));

#if 0
	// begin
	constexpr unsigned detailedBegin = 50;
	csvFile.open("TimePerBlockedCyclesBegin.csv", ios_base::trunc);
	for (cpp_int interference = 0;
			interference < detailedBegin &&
				interference * xstepScale <= rightmostSamplepoint;
			++interference) {
		// actual ILP run
		GraphConstraint interferenceConstr =
			std::make_tuple(
				interferenceVarVector,
				ConstraintType::LessEqual,
				intToDouble(interference * xstepScale, true)
			);
		constraintSet.back() = interferenceConstr;
		cpp_int currentWcetBound = optDoubleToInt(doPathAnalysis(
			"TimePerInterference",
			ExtremumType::Maximum,
			ubTime,
			constraintSet
		), true /*in doubt, round up*/);
		// normalize y-axis
		if (interference == 0) {
			valueAtZero = currentWcetBound;
		}
		assert(valueAtZero >= 0 && "WCET at 0 interference not initialized.");
		cpp_int normalized = currentWcetBound - valueAtZero;
		// dump to file
		csvFile << interference << ";"
			<< normalized << std::endl;
		csvFile.flush();
	}
	csvFile.close();
#endif

#if 0
	// end
	constexpr unsigned detailedEnd = 50;
	csvFile.open("TimePerBlockedCyclesEnd.csv", ios_base::trunc);
	cpp_int startValue = rightmostSamplepoint - detailedEnd + 1;
	if (startValue < 0) {
		startValue = 0;
	}
	for (cpp_int interference = startValue;
			interference <= rightmostSamplepoint; ++interference) {
		// actual ILP run
		GraphConstraint interferenceConstr =
			std::make_tuple(
				interferenceVarVector,
				ConstraintType::LessEqual,
				intToDouble(interference, true)
			);
		constraintSet.back() = interferenceConstr;
		cpp_int currentWcetBound = optDoubleToInt(doPathAnalysis(
			"TimePerInterference",
			ExtremumType::Maximum,
			ubTime,
			constraintSet
		), true /*in doubt, round up*/);
		// normalize y-axis
		assert(valueAtZero >= 0 && "WCET at 0 interference not initialized.");
		cpp_int normalized = currentWcetBound - valueAtZero;
		// normalize x-axis
		cpp_int xAxis = interference - startValue;
		// dump to file
		csvFile << xAxis << ";"
			<< normalized << std::endl;
		csvFile.flush();
	}
	csvFile.close();
#endif

  rightmostSamplepoint = rightmostSamplepoint / zoomFactor;

  // we must reduce the number of samples
  // as the whole range does not provide
  // that many different sample points
  if (numberOfSamples > rightmostSamplepoint + 1) {
    outs() << "Range to small for " << numberOfSamples << "different samples.\n"
           << "Falling back to the maximum possible:"
           << intToStr(rightmostSamplepoint + 1) << "\n";
    numberOfSamples = static_cast<unsigned>(rightmostSamplepoint) + 1;
  }

  // do the sampling (exhaustive or non-exhaustive)
  csvFile.open("InterferenceResponseCurve" + suffix + ".csv",
               std::ios_base::trunc);
  for (unsigned i = 0; i < numberOfSamples; i++) {
    // exact value of i-th sample position
    cpp_rational exact = rightmostSamplepoint;
    exact *= i;
    exact /= (numberOfSamples - 1);
    // potentially truncate
    cpp_int rounded = numerator(exact) / denominator(exact);
    // if truncated, apply rounding
    cpp_rational lost(exact);
    lost -= rounded;
    if (lost >= 0.5) {
      rounded++;
    }
    // actual ILP run
    GraphConstraint interferenceConstr =
        std::make_tuple(interferenceVarVector, ConstraintType::LessEqual,
                        intToDouble(rounded, true));
    constraintSet.back() = interferenceConstr;
    cpp_int currentWcetBound = optDoubleToInt(
        doPathAnalysis("TimePerBlockedCycles", ExtremumType::Maximum, ubTime,
                       constraintSet)
            .get()
            .ub,
        true /*in doubt, round up*/); // Take upper bound value provided by path
                                      // analysis
    // normalize y-axis
    if (i == 0) {
      valueAtZero = currentWcetBound;
    }
    assert(valueAtZero >= 0 && "WCET at 0 interference not initialized.");
    currentWcetBound -= valueAtZero;
    cpp_rational normalized = currentWcetBound;
    // normalized *= (numberOfSamples - 1);
    normalized /= rightmostSamplepoint;
    // normalize x-axis
    cpp_rational xAxis = rounded;
    xAxis /= rightmostSamplepoint;
    // dump to file
    csvFile << (double)xAxis << ";" << (double)normalized << std::endl;
    csvFile.flush();
  }
  csvFile.close();
}

// helper functionality
template <CacheTraits *CacheConfig>
void performCRPDAnalysisCC(
    const Graph &SimpleGraph,
    const EdgeWeightProvider<std::vector<AbstractAddress>> *provider) {
  Statistics &stats = Statistics::getInstance();
  if (CRPDAnaType.getBits() == 0) {
    CRPDAnaType.addValue(CRPDAnalysisType::ECB);
    CRPDAnaType.addValue(CRPDAnalysisType::UCB);
    CRPDAnaType.addValue(CRPDAnalysisType::DCUCB);
    CRPDAnaType.addValue(CRPDAnalysisType::RESILIENCE);
  }

  // CRPD analysis instance
  CacheRelatedPreemptionDelay<CacheConfig> CRPDInst(SimpleGraph, provider);
  // ECB analysis
  if (CRPDAnaType.isSet(CRPDAnalysisType::ECB)) {
    stats.startMeasurement("ECB Analysis");
    typename CacheRelatedPreemptionDelay<CacheConfig>::ECBInfo ECBs =
        CRPDInst.computeECBsPerSet();
    CRPDInst.dumpECBs("EvictingCacheBlocks.csv", ECBs);
    stats.stopMeasurement("ECB Analysis");
  }
  // UCB analysis
  if (CRPDAnaType.isSet(CRPDAnalysisType::UCB)) {
    stats.startMeasurement("UCB Analysis");
    typename CacheRelatedPreemptionDelay<CacheConfig>::UCBInfo UCBs =
        CRPDInst.computeUCBsPerSet();
    CRPDInst.dumpUCBs(UCBs);
    stats.stopMeasurement("UCB Analysis");
  }
  // DC-UCB analysis
  if (CRPDAnaType.isSet(CRPDAnalysisType::DCUCB)) {
    stats.startMeasurement("DCUCB Analysis");
    typename CacheRelatedPreemptionDelay<CacheConfig>::UCBInfo DCUCBs =
        CRPDInst.computeDCUCBsPerSet();
    CRPDInst.dumpUCBs(DCUCBs, "DCUCB");
    stats.stopMeasurement("DCUCB Analysis");
  }
  // Resilience analysis
  if (CRPDAnaType.isSet(CRPDAnalysisType::RESILIENCE)) {
    stats.startMeasurement("Resilience Analysis");
    auto preemptingTaskECBs =
        CRPDInst.readECBs("EvictingCacheBlocks.csv"); // TODO for testing only:
                                                      // reading the own ECBs
    CRPDInst.runResilienceAnalysis(preemptingTaskECBs);
    stats.stopMeasurement("Resilience Analysis");
  }
}

void performCRPDAnalysis(
    const Graph &SimpleGraph, CacheType CT,
    const EdgeWeightProvider<std::vector<AbstractAddress>> *provider) {
  assert(CT == CacheType::INSTRUCTION || CT == CacheType::DATA);

  if (CT == CacheType::DATA) {
    performCRPDAnalysisCC<&dcacheConf>(SimpleGraph, provider);
  } else {
    performCRPDAnalysisCC<&icacheConf>(SimpleGraph, provider);
  }
}

///////////////////////////////////////////////////////////////////////////////
/////// Helper Functions //////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
std::string intToStr(cpp_int num) {
  std::ostringstream oss;
  oss << num;
  return oss.str();
}

double intToDouble(cpp_int num, bool roundUp) {
  double result = num.convert_to<double>();
  cpp_int num2(result);
  if (num != num2) {
    outs() << "Warning: There was a loss in precision when converting from "
              "cpp_int to double!\n";
    if (roundUp && num2 < num) {
      outs() << "^^ Info: Had to chose the next greater representable for a "
                "safe rounding.\n";
      result = nextafter(result, std::numeric_limits<double>::max());
    }
    if (!roundUp && num2 > num) {
      outs() << "^^ Info: Had to chose the next smaller representable for a "
                "safe rounding.\n";
      result = nextafter(result, std::numeric_limits<double>::min());
    }
  }
  return result;
}

cpp_int optDoubleToInt(boost::optional<double> num, bool roundUp) {
  // TODO: this function should be refactored.
  // obtain an optional double interval as parameter.
  // obtain an enum value indicating which interval should
  // be extracted and mapped to an integer.
  // depending on the chosen bound, the rounding direction
  // modulo epsilon shall be chosen in a safe way.
  // moreover, the function shall be renamed and moved
  // to util.
  // finally, there shall be a function with the same name
  // that goes to long instead of cpp_int and internally
  // uses this function.
  // the long variant shall be used in TimingAnalysisMain
  // and AnalysisResult where we currently do the mapping
  // in a different way.
  // in the long run, one wants to refactor AnalysisResults
  // in a way that each registered results is registered with
  // the information whether it should be mapped to integer
  // or not.
  cpp_int infinity(-1);
  // boost::none means unbounded
  if (!num) {
    return infinity;
  }
  // potentially lossy cast to big int
  const cpp_int result(*num);
  // represent original and casted value
  // as rationals
  const cpp_rational original(*num);
  const cpp_rational casted(result);
  // if the two values are equal,
  // everything is fine
  if (original == casted) {
    return result;
  }
  // potentially special treatment needed
  else {
    // acceptable distance from an
    // integer to still consider the
    // double value as the integer
    const cpp_rational epsilon(0.1);
    // positive originals may have decreased
    if (original > casted) {
      assert(original - casted < 1);
      // decreased to close integer value
      if (original - casted <= epsilon) {
        return result;
      }
      // close integer value in other direction
      // OR explicitly round up
      if (casted + 1 - original <= epsilon || roundUp) {
        return result + 1;
      }
    }
    // negative originals may have increased
    if (original < casted) {
      assert(casted - original < 1);
      // increased to close integer value
      if (casted - original <= epsilon) {
        return result;
      }
      // close integer value in other direction
      // OR explicitly round down
      if (original + 1 - casted <= epsilon || !roundUp) {
        return result - 1;
      }
    }
    return result;
  }
}
/*
 * This function computes the number of cycles the system would need to write
 * back all dirty lines from the cache. This is useful if you want to compare
 * the timing bounds with a writethrough cache since they pay this cost
 * up-front.
 * Returning a negative number disables the cleanup costs */
double computeWBCleanupCost(const LPAssignment &WCETpath) {
  if (WBBound == WBBoundType::NONE) {
    return -1; /* We have no fair way to compute cleanup costs for dirtiness
                  analysis only */
  }
  std::string writebacks =
      Variable::getGlobalVar(Variable::Type::writebacks).getName();
  std::string dfss =
      Variable::getGlobalVar(Variable::Type::dirtifyingStores).getName();

  /* compute the overall number of cachelines in the cache. This obviously
   * is an upper bound on the cleanup costs */
  double numLines = Dassoc * Dnsets;
  double costs =
      std::min(WCETpath.at(dfss) - WCETpath.at(writebacks), numLines);
  if (costs < 0) {
    /* costs can be smaller than 0 if we did not enforce the bound */
    return 0;
  }
  costs *= (Latency + PerWordLatency * Dlinesize / 4);
  if (BackgroundMemoryType == BgMemType::SIMPLEDRAM) {
    /* TODO this is too simplistic. We should do a
     * fixed-point iteration here, since the refreshes might
     * delay everything and cause even more refreshes */
    unsigned refreshInterArrivalTime =
        SDRAMConfig.getRefreshInterArrivalCycles();
    unsigned numRefreshes = ceil(costs / refreshInterArrivalTime);
    costs += numRefreshes * DRAMRefreshLatency;
  }

  return costs;
}

} // namespace TimingAnalysisPass
