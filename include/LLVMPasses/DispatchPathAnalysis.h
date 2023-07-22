////////////////////////////////////////////////////////////////////////////////
//
//   LLVMTA - Timing Analyser performing worst-case execution time analysis
//     using the LLVM backend intermediate representation
//
// Copyright (C) 2013-2022  Saarland University
// Copyright (C) 2014-2015 Claus Faymonville
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

#ifndef DISPATCHPATHANALYSIS_H
#define DISPATCHPATHANALYSIS_H

#include "AnalysisFramework/AnalysisResults.h"

#include "PathAnalysis/FlowConstraintProvider.h"
#include "PathAnalysis/InsensitiveGraph.h"
#include "PathAnalysis/IsEdgeJoinableMultipleProviders.h"
#include "PathAnalysis/StateGraphAddressProvider.h"
#include "PathAnalysis/StateGraphCacheMissProvider.h"
#include "PathAnalysis/StateGraphDRAMRefreshProvider.h"
#include "PathAnalysis/StateGraphDirtifyingStoreProvider.h"
#include "PathAnalysis/StateGraphNumericWeightProvider.h"
#include "PathAnalysis/StateGraphPreemptionCacheMissProvider.h"
#include "PathAnalysis/StateGraphWritebackProvider.h"
#include "PathAnalysis/StateSensitiveGraph.h"
#include "PathAnalysis/TimingPathAnalysis.h"

#include "LLVMPasses/DispatchMemory.h"
#include "Memory/AbstractCyclingMemory.h"

#include "Util/Options.h"
#include "Util/Statistics.h"
#include "Util/TplTools.h"
#include "Util/Util.h"

#include "llvm/Support/Format.h"

#include <fstream>
#include <iostream>
#include <list>

#include <boost/multiprecision/cpp_int.hpp>

#include <Memory/BlockingCyclingMemoryConfig.h>

using namespace boost::multiprecision;

namespace TimingAnalysisPass {

typedef std::map<std::string, double> LPAssignment;

//////////////////////////////////////////////////////////////////////////////
////// Helper functions to access parts of local metrics /////////////////////
//////////////////////////////////////////////////////////////////////////////

// a short-hand for one of the following 4 variants
template <class MuStateLocalMetrics>
AbstractCyclingMemory::LocalMetrics *
bgMemMetr(const MuStateLocalMetrics &metrics) {
  return getBackgroundMemoryLocalMetrics(metrics, TplSpecial());
}

// Fixed latency timing analysis
template <class MuStateLocalMetrics>
AbstractCyclingMemory::LocalMetrics *
getBackgroundMemoryLocalMetrics(const MuStateLocalMetrics &metrics,
                                TplGeneral) {
  assert(0 && "Cannot obtain background memory metrics for this configuration "
              "(did you forget to specify --ta-muarch-type?).");
  return nullptr;
}

// SingleMemoryTopology
template <class MuStateLocalMetrics,
          TplSwitch<decltype(MuStateLocalMetrics::memoryTopology.memory)> = 0>
AbstractCyclingMemory::LocalMetrics *
getBackgroundMemoryLocalMetrics(const MuStateLocalMetrics &metrics,
                                TplSpecial) {
  return metrics.memoryTopology.memory;
}

// SeparateMemoriesTopology
template <
    class MuStateLocalMetrics,
    TplSwitch<decltype(MuStateLocalMetrics::memoryTopology.dataMemory)> = 0>
AbstractCyclingMemory::LocalMetrics *
getBackgroundMemoryLocalMetrics(const MuStateLocalMetrics &metrics,
                                TplSpecial) {
  return metrics.memoryTopology.dataMemory;
}

// SeparateCachesMemoryTopology (with SingleMemoryTopology as background)
template <class MuStateLocalMetrics,
          TplSwitch<decltype(MuStateLocalMetrics::memoryTopology
                                 .backgroundMemory.memory)> = 0>
AbstractCyclingMemory::LocalMetrics *
getBackgroundMemoryLocalMetrics(const MuStateLocalMetrics &metrics,
                                TplSpecial) {
  return metrics.memoryTopology.backgroundMemory.memory;
}

///////////////////////////////////////////////////////////////////////////////
/// Common: Path Analysis /////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

// forward declarations
template <class MuArchDomain, class PAI>
boost::optional<BoundItv>
dispatchTimingPathAnalysis(const PAI &microArchAnaInfo);

template <class MuState>
boost::optional<BoundItv> doCoRunnerSensitivePathAnalysis(
    MuStateGraph<MuState> *pSg, MuStateGraph<MuState> *pArrivalCurveSg,
    StateGraphNumericWeightProvider<MuState> &sgtp,
    StateGraphCacheMissProvider<MuState, CacheType::DATA> *sgdcpers,
    StateGraphCacheMissProvider<MuState, CacheType::INSTRUCTION> *sgicpers);

boost::optional<BoundItv>
doPathAnalysis(const std::string identifier, const ExtremumType extremumType,
               const VarCoeffVector &objective,
               const std::list<GraphConstraint> &constraints,
               LPAssignment *extpath = nullptr, const double timeLimit = 0.0);

void calculateSoundSlope(double lower, double upper,
                         const std::list<GraphConstraint> &constraints,
                         const VarCoeffVector ubtime,
                         const Variable interferencevar,
                         double boundwithoutint);

void calculateCompositionalBaseBound(
    const std::list<GraphConstraint> &constraints,
    const GraphConstraint &interferenceConstr, const VarCoeffVector ubtime,
    const Variable interferencevar, double fixedSlope);

void dumpInterferenceResponseCurve(
    cpp_int rightmostSamplepoint, unsigned numSamples,
    const std::list<GraphConstraint> &constraints, const VarCoeffVector ubTime,
    const Variable interferencevar, std::string suffix, unsigned zoomFactor,
    cpp_int xstepScale = 1);

void performCRPDAnalysis(
    const Graph &SimpleGraph, CacheType CT,
    const EdgeWeightProvider<std::vector<AbstractAddress>> *Provider);

double computeWBCleanupCost(const LPAssignment &longestPath);

// Smaller helper functions
std::string intToStr(cpp_int num);

double intToDouble(cpp_int num, bool roundUp);

cpp_int optDoubleToInt(boost::optional<double> num, bool roundUp);

///////////////////////////////////////////////////////////////////////////////
/// Timing: Path Analysis /////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

template <class MuArchDomain, class PAI>
boost::optional<BoundItv>
dispatchTimingPathAnalysis(const PAI &microArchAnaInfo) {
  switch (PathAnaType) {
  case PathAnalysisType::SIMPLEILP: {
    InsensitiveGraph<MuArchDomain> sg(microArchAnaInfo);
    InsensitiveGraph<MuArchDomain> arrivalCurveSg(microArchAnaInfo);
    return dispatchTimingPathAnalysisWeightProvider(&sg, &arrivalCurveSg);
  }
  case PathAnalysisType::GRAPHILP: {
    StateSensitiveGraph<MuArchDomain> sg(microArchAnaInfo);
    StateSensitiveGraph<MuArchDomain> arrivalCurveSg(microArchAnaInfo);
    return dispatchTimingPathAnalysisWeightProvider(&sg, &arrivalCurveSg);
  }
  default:
    errs() << "The chosen path analysis type is not supported.\n";
    return boost::none;
  }
}

template <class MuState>
void dispatchDumpInterferenceResponseCurve(TimingPathAnalysis<MuState> &tpa) {
  assert(DumpInterferenceResponseCurve.getBits());
  assert(!(DumpInterferenceResponseCurve.getBits() &
           (DumpInterferenceResponseCurve.getBits() - 1)) &&
         "Currently only one source of interference supported");

  // Get Basic constraints such as flow, loop bound, and persistence constraints
  std::list<GraphConstraint> constraintsWithoutInterference;
  tpa.getBasicConstraints(constraintsWithoutInterference);

  // Optimize for maximum time
  VarCoeffVector timeObjective = tpa.sgtp->getEdgeWeightTimesTakenVector();

  // Dump a sampled version of the interference response curve
  if (DumpInterferenceResponseCurve.isSet(InterferenceSource::ICMPREEMPTION)) {
    // Instruction Cache only, preemption
    assert(tpa.sgicmpreemption && "Cannot estimate rightmost point");
    auto objMaxAddICmisses =
        tpa.sgicmpreemption->getEdgeWeightTimesTakenVector();
    auto resMaxAddICmisses =
        doPathAnalysis(std::string("AddICmisses"), ExtremumType::Maximum,
                       objMaxAddICmisses, constraintsWithoutInterference);

    auto combinedConstraints = constraintsWithoutInterference;
    combinedConstraints.push_back(
        tpa.sgicmpreemption->getInterferenceConstraint());

    dumpInterferenceResponseCurve(
        optDoubleToInt(resMaxAddICmisses.get().ub, true /*in doubt, round up*/),
        40, combinedConstraints, timeObjective,
        Variable::getGlobalVar(Variable::Type::maxAddInstrMissPreemption),
        "ICMPreemption", 1 /* No zoom Full Curve */);
  } else if (DumpInterferenceResponseCurve.isSet(
                 InterferenceSource::DCMPREEMPTION)) {
    // Data cache only, preemption
    assert(tpa.sgdcmpreemption && "Cannot estimate rightmost point");
    auto objMaxAddDCmisses =
        tpa.sgdcmpreemption->getEdgeWeightTimesTakenVector();
    auto resMaxAddDCmisses =
        doPathAnalysis(std::string("AddDCmisses"), ExtremumType::Maximum,
                       objMaxAddDCmisses, constraintsWithoutInterference);

    auto combinedConstraints = constraintsWithoutInterference;
    combinedConstraints.push_back(
        tpa.sgdcmpreemption->getInterferenceConstraint());

    dumpInterferenceResponseCurve(
        optDoubleToInt(resMaxAddDCmisses.get().ub, true /*in doubt, round up*/),
        40, combinedConstraints, timeObjective,
        Variable::getGlobalVar(Variable::Type::maxAddDataMissPreemption),
        "DCMPreemption", 1 /* No zoom Full Curve */);
  } else if (DumpInterferenceResponseCurve.isSet(
                 InterferenceSource::DRAMREFRESH)) {
    assert(tpa.ubAccessesProvider && "Cannot estimate rightmost point");
    auto objUbAccesses =
        tpa.ubAccessesProvider->getEdgeWeightTimesTakenVector();
    auto resUbAccesses =
        doPathAnalysis(std::string("NumAccesses"), ExtremumType::Maximum,
                       objUbAccesses, constraintsWithoutInterference);

    auto combinedConstraints = constraintsWithoutInterference;
    combinedConstraints.push_back(
        tpa.sgdramrefreshes->getDRAMRefreshConstraints().back()
        // ignore the constraints interrelating maxNumRefreshes with the
        // execution time
    );

    dumpInterferenceResponseCurve(
        optDoubleToInt(resUbAccesses.get().ub, true /*in doubt, round up*/), 40,
        combinedConstraints, timeObjective,
        Variable::getGlobalVar(Variable::Type::maxNumRefreshes), "Refreshes",
        1 /* No zoom Full Curve */);
  } else if (DumpInterferenceResponseCurve.isSet(
                 InterferenceSource::WRITEBACK)) {
    assert(tpa.sgwbp && "Cannot estimate rightmost point");
    auto writeBacks = tpa.sgwbp->getEdgeWeightTimesTakenVector();
    auto numWBs =
        doPathAnalysis(std::string("NumWritebacks"), ExtremumType::Maximum,
                       writeBacks, constraintsWithoutInterference);

    auto combinedConstraints = constraintsWithoutInterference;
    writeBacks.push_back(std::make_pair(
        Variable::getGlobalVar(Variable::Type::writebacks), -1.0));
    GraphConstraint wbsConstr =
        std::make_tuple(writeBacks, ConstraintType::LessEqual, 0.0);
    combinedConstraints.push_back(wbsConstr);

    dumpInterferenceResponseCurve(
        optDoubleToInt(numWBs.get().ub, true /*in doubt, round up*/), 40,
        combinedConstraints, timeObjective,
        Variable::getGlobalVar(Variable::Type::writebacks), "Writebacks",
        1 /* No zoom Full Curve */);
  } else {
    errs()
        << "The current type of interference source is not supported for the "
        << "dumping of interference response curves.\n";
  }
}

template <class MuState>
void dispatchCompositionalBaseBound(TimingPathAnalysis<MuState> &tpa) {
  assert(CompositionalBaseBound.getBits());
  assert(!(CompositionalBaseBound.getBits() &
           (CompositionalBaseBound.getBits() - 1)) &&
         "Currently only one source of interference supported");

  // Get Basic constraints such as flow, loop bound, and persistence constraints
  std::list<GraphConstraint> constraintsWithoutInterference;
  tpa.getBasicConstraints(constraintsWithoutInterference);

  // Optimize for maximum time
  VarCoeffVector timeObjective = tpa.sgtp->getEdgeWeightTimesTakenVector();

  Statistics &stats = Statistics::getInstance();
  stats.startMeasurement("Comp Base Bound Path Analysis");

  // Calculate a compositional base bound (this is a normal ILP run, because we
  // build the state graph that way)
  if (CompositionalBaseBound.isSet(InterferenceSource::DRAMREFRESH)) {
    AnalysisResults &ar = AnalysisResults::getInstance();
    auto solCompWcetBase =
        doPathAnalysis("Comp Base Time", ExtremumType::Maximum, timeObjective,
                       constraintsWithoutInterference);

    ar.registerResult("CompositionalBaseWCET", solCompWcetBase);
  } else {
    errs() << "The current type of interference source is not supported for the"
           << "compositional base bound approach.\n";
  }

  stats.stopMeasurement("Comp Base Bound Path Analysis");
}

template <class MuState>
void dispatchSoundSlopeComputation(TimingPathAnalysis<MuState> &tpa) {
  assert(CalculateSlopeInterferenceCurve.getBits());
  assert(!(CalculateSlopeInterferenceCurve.getBits() &
           (CalculateSlopeInterferenceCurve.getBits() - 1)) &&
         "Currently only one source of interference supported");

  // Get Basic constraints such as flow, loop bound, and persistence constraints
  std::list<GraphConstraint> constraintsWithoutInterference;
  tpa.getBasicConstraints(constraintsWithoutInterference);

  // Get Zero Interference constraints
  std::list<GraphConstraint> constraintsZeroInterference(
      constraintsWithoutInterference);
  tpa.addAvailableInterferenceConstraints(constraintsZeroInterference);
  tpa.setInterferenceToZero(constraintsZeroInterference);

  // Optimize for maximum time
  VarCoeffVector timeObjective = tpa.sgtp->getEdgeWeightTimesTakenVector();

  // Perform the longest path search (under zero interference)
  auto res = doPathAnalysis("TimeZeroInterference", ExtremumType::Maximum,
                            timeObjective, constraintsZeroInterference);
  assert(res && "Could not compute WCET under zero interference");

  // Potentially calculate the maximal slope
  if (CalculateSlopeInterferenceCurve.isSet(InterferenceSource::DRAMREFRESH)) {
    auto combinedConstraints = constraintsWithoutInterference;
    combinedConstraints.push_back(
        tpa.sgdramrefreshes->getDRAMRefreshConstraints().back()
        // Ignore constraint relating maxNumRefreshes with maxTime
    );
    calculateSoundSlope(0.1 * DRAMRefreshLatency, 10 * DRAMRefreshLatency,
                        combinedConstraints, timeObjective,
                        Variable::getGlobalVar(Variable::Type::maxNumRefreshes),
                        res.get().ub);
  } else {
    errs() << "The current type of interference source is not supported for the"
           << "computation of a soung penalty.\n";
  }
}

template <class MuState>
void dispatchMetricsOnWCEP(TimingPathAnalysis<MuState> &tpa, double wcet) {
  // Build the constraint maxTime = WCET, so we use the length of the WCET path
  // as a condition to maximize misses on
  std::list<GraphConstraint> wcetpathconstraints;
  // Get Basic constraints such as flow, loop bound, and persistence constraints
  tpa.getBasicConstraints(wcetpathconstraints);
  // Add potential interference constraints for dram refreshes, crpd-cost, ...
  tpa.addAvailableInterferenceConstraints(wcetpathconstraints);

  VarCoeffVector maxTime = tpa.sgtp->getEdgeWeightTimesTakenVector();
  GraphConstraint wcetpathlength =
      std::make_tuple(maxTime, ConstraintType::Equal, wcet);
  wcetpathconstraints.push_back(wcetpathlength);

  AnalysisResults &ar = AnalysisResults::getInstance();

  if (MetricsOnWCEP.isSet(MetricType::L1IMISSES)) {
    // Maximize I$-misses
    auto objicmisses = tpa.sgnicmp->getEdgeWeightTimesTakenVector();
    auto resInstrMisses =
        doPathAnalysis(std::string("Time_MissesI$"), ExtremumType::Maximum,
                       objicmisses, wcetpathconstraints);
    ar.registerResult("IntAna_MaxTime_InstrMisses", resInstrMisses);
  }
  if (MetricsOnWCEP.isSet(MetricType::L1DMISSES)) {
    // Maximize D$-Misses
    auto objdcmisses = tpa.sgndcmp->getEdgeWeightTimesTakenVector();
    auto resDataMisses =
        doPathAnalysis(std::string("Time_MissesD$"), ExtremumType::Maximum,
                       objdcmisses, wcetpathconstraints);
    ar.registerResult("IntAna_MaxTime_DataMisses", resDataMisses);
  }
  if (MetricsOnWCEP.isSet(MetricType::BUSACCESSES)) {
    // Maximize bus accesses
    auto objUbAccesses =
        tpa.ubAccessesProvider->getEdgeWeightTimesTakenVector();
    auto resUbAccesses =
        doPathAnalysis(std::string("Time_NumAccesses"), ExtremumType::Maximum,
                       objUbAccesses, wcetpathconstraints);
    ar.registerResult("IntAna_MaxTime_BusAccesses", resUbAccesses);
  }
  if (MetricsOnWCEP.isSet(MetricType::BUSSTORES)) {
    // Maximize stores to bus
    auto objBusStores = tpa.sgnsbap->getEdgeWeightTimesTakenVector();
    auto resBusStores =
        doPathAnalysis(std::string("Time_StoresBus"), ExtremumType::Maximum,
                       objBusStores, wcetpathconstraints);
    ar.registerResult("IntAna_MaxTime_StoresToBus", resBusStores);
  }
  if (MetricsOnWCEP.isSet(MetricType::WRITEBACKS)) {
    if (!tpa.sgwbp) {
      /* TODO we could also just return 0 */
      std::cerr << "Cannot maximize writebacks on a non-write-back cache -- "
                   "aborting\n";
      exit(1);
    }
    /* determine the number of writebacks in the program */
    VarCoeffVector wbs = tpa.sgwbp->getEdgeWeightTimesTakenVector();
    auto numWBs =
        doPathAnalysis(std::string("Time_Writebacks"), ExtremumType::Maximum,
                       wbs, wcetpathconstraints);
    ar.registerResult("IntAna_MaxTime_Writebacks", numWBs.get());
  }
}

template <class MuState>
void dispatchAdditionalMetricsToMax(TimingPathAnalysis<MuState> &tpa) {
  std::list<GraphConstraint> constraints;
  // Get Basic constraints such as flow, loop bound, and persistence constraints
  tpa.getBasicConstraints(constraints);
  // Add potential interference constraints for dram refreshes, crpd-cost, ...
  tpa.addAvailableInterferenceConstraints(constraints);

  AnalysisResults &ar = AnalysisResults::getInstance();

  if (MetricsToMax.isSet(MetricType::L1IMISSES) ||
      (CompAnaType.isSet(CompositionalAnalysisType::DCACHE) &&
       !CompAnaType.isSet(CompositionalAnalysisType::ICACHE))) {
    auto objInstrMisses = tpa.sgnicmp->getEdgeWeightTimesTakenVector();
    auto resInstrMisses =
        doPathAnalysis(std::string("MissesI$"), ExtremumType::Maximum,
                       objInstrMisses, constraints);
    ar.registerResult("IntAna_MaxInstrMisses_InstrMisses", resInstrMisses);
  }
  if (MetricsToMax.isSet(MetricType::L1DMISSES) ||
      (CompAnaType.isSet(CompositionalAnalysisType::ICACHE) &&
       !CompAnaType.isSet(CompositionalAnalysisType::DCACHE))) {
    auto objDataMisses = tpa.sgndcmp->getEdgeWeightTimesTakenVector();
    auto resDataMisses =
        doPathAnalysis(std::string("MissesD$"), ExtremumType::Maximum,
                       objDataMisses, constraints);
    ar.registerResult("IntAna_MaxDataMisses_DataMisses", resDataMisses);
  }
  // We need also the number of stores at max that went to the bus, for icache
  // miss penalty
  if (MetricsToMax.isSet(MetricType::BUSSTORES) ||
      CompAnaType.isSet(CompositionalAnalysisType::ICACHE) ||
      CompAnaType.isSet(CompositionalAnalysisType::DCACHE)) {
    auto objStoreBusAccess = tpa.sgnsbap->getEdgeWeightTimesTakenVector();
    auto resStores =
        doPathAnalysis(std::string("StoresBus"), ExtremumType::Maximum,
                       objStoreBusAccess, constraints);
    ar.registerResult("IntAna_MaxStoresToBus_StoresToBus", resStores);
  }
  if (MetricsToMax.isSet(MetricType::BUSACCESSES)) {
    auto objBusAccesses =
        tpa.ubAccessesProvider->getEdgeWeightTimesTakenVector();
    auto resAccesses =
        doPathAnalysis(std::string("BusAccesses"), ExtremumType::Maximum,
                       objBusAccesses, constraints);
    ar.registerResult("IntAna_MaxBusAccesses_BusAccesses", resAccesses);
  }
  if (MetricsToMax.isSet(MetricType::WRITEBACKS)) {
    if (!tpa.sgwbp) {
      /* TODO we could also just return 0 */
      std::cerr << "Cannot maximize writebacks on a non-write-back cache -- "
                   "aborting\n";
      exit(1);
    }
    /* determine the number of writebacks in the program */
    VarCoeffVector wbs = tpa.sgwbp->getEdgeWeightTimesTakenVector();
    auto numWBs = doPathAnalysis(std::string("Writebacks"),
                                 ExtremumType::Maximum, wbs, constraints);
    ar.registerResult("IntAna_MaxWritebacks_Writebacks", numWBs.get());
  }
}

/**
 * Dispatch and execute the whole timing path analysis.
 */
template <class MuState>
boost::optional<BoundItv> dispatchTimingPathAnalysisWeightProvider(
    MuStateGraph<MuState> *sg, MuStateGraph<MuState> *arrivalCurveSg) {
  // Create a timing path analysis problem that captures all weight providers
  TimingPathAnalysis<MuState> tpa(sg);
  tpa.registerWeightProvider();

  // LEGACY CODE: perform a co-runner-sensitive analysis
  if (CoRunnerSensitive) {
    assert(SharedBus != SharedBusType::NONE &&
           "Co-runner-sensitive analysis makes only sense in "
           "combination with shared resources.");
    // TODO: also pass in the sgdramrefreshes as soon as their
    // use is shown in the non-iterative part
    // TODO: in the long run, we need to change the structure here
    // in a way that unifies iterative and non-iterative parts and avoids
    // the current degree of code duplication
    return doCoRunnerSensitivePathAnalysis(sg, arrivalCurveSg, *tpa.sgtp,
                                           tpa.sgdcpers, tpa.sgicpers);
  }
  // END LEGACY CODE

  AnalysisResults::getInstance().registerResult("staticallyRefutedWritebacks",
                                                0);
  AnalysisResults::getInstance().registerResult("staticMisses", 0);

  // Build state graph
  sg->buildGraph();

  AnalysisResults::getInstance().finalize("staticallyRefutedWritebacks");
  AnalysisResults::getInstance().finalize("staticMisses");

  // Dump state graph without longest-path coloring to aid debugging of
  // path analysis problems
  if (!QuietMode) {
    VERBOSE_PRINT(" -> Finished Microarchitectural State Graph Construction\n");
    std::ofstream myfile;
    if (!DumpVcgGraph) {
      myfile.open("StateGraph_Time.dot", std::ios_base::trunc);
    } else {
      myfile.open("StateGraph_Time.vcg", std::ios_base::trunc);
    }
    sg->dump(myfile, nullptr);
    myfile.close();
  } else // Quiet mode
  {
    // In quiet mode, we want to keep overall memory low.
    sg->freeMuStates();
  }

  sg->deleteMuArchInfo();

  // Trigger the next measurement phase
  Statistics &stats = Statistics::getInstance();
  stats.stopMeasurement("Timing Stategraph Generation");
  stats.startMeasurement("Timing Path Analysis");

  // Dump Interference response curves
  if (DumpInterferenceResponseCurve.getBits()) {
    dispatchDumpInterferenceResponseCurve(tpa);
    return boost::none;
  }
  // Calculate a per-benchmark sound penalty, i.e. a max slope in the i-r-curve
  else if (CalculateSlopeInterferenceCurve.getBits()) {
    dispatchSoundSlopeComputation(tpa);
    return boost::none;
  }
  // Calculate the compositional base bound
  else if (CompositionalBaseBound.getBits()) {
    dispatchCompositionalBaseBound(tpa);
    return boost::none;
  }
  // Normal timing bound computation
  assert(!DumpInterferenceResponseCurve.getBits() &&
         !CalculateSlopeInterferenceCurve.getBits() &&
         !CompositionalBaseBound.getBits());

  // Create constraints
  std::list<GraphConstraint> constraints;
  // Get Basic constraints such as flow, loop bound, and persistence constraints
  tpa.getBasicConstraints(constraints);
  // Add potential interference constraints for dram refreshes, crpd-cost, ...
  tpa.addAvailableInterferenceConstraints(constraints);

  // Optimize for maximum time
  VarCoeffVector timeObjective = tpa.sgtp->getEdgeWeightTimesTakenVector();

  // Extremal path
  LPAssignment longestPath;
  // Perform the longest path search (under given interference budgets)
  auto res = doPathAnalysis("Time", ExtremumType::Maximum, timeObjective,
                            constraints, &longestPath);

  /* dump the state graph with coloring information, overwriting the
   * previous dump */
  if (!QuietMode) {
    std::ofstream myfile;
    if (!DumpVcgGraph) {
      myfile.open("StateGraph_Time.dot", std::ios_base::trunc);
    } else {
      myfile.open("StateGraph_Time.vcg", std::ios_base::trunc);
    }
    sg->dump(myfile, &longestPath);
    myfile.close();
  }

  AnalysisResults &ar = AnalysisResults::getInstance();
  ar.registerResult("time", res);

  // If required, calculate additional metrics on a worst-case timing path
  if (MetricsOnWCEP.getBits() && longestPath.size() > 0) {
    assert(res.get().lb == res.get().ub &&
           "Cannot compute metrics on WCEP if bound is imprecise");
    dispatchMetricsOnWCEP(tpa, res.get().ub);
  }
  // If requested or needed for compositional analysis, maximise additional
  // metrics
  if (MetricsToMax.getBits() || CompAnaType.getBits()) {
    dispatchAdditionalMetricsToMax(tpa);
  }

  // Write-back cache additional stuff
  if (res && DataCacheWriteBack) {
    // Compute write-back cleanup cost (i.e. the cost of writing all left-over
    // dirty blocks)
    double cleanupCost = computeWBCleanupCost(longestPath);
    if (cleanupCost >= 0) {
      ar.registerResult("WritebackCleanupCost", cleanupCost);
    }
  }

  // Handle Compositional Blocking
  if (CompAnaType.isSet(CompositionalAnalysisType::SHAREDBUSBLOCKING)) {
    assert(tpa.ubAccessesProvider &&
           "Expected to receive initialized weight provider");
    auto objUbAccesses =
        tpa.ubAccessesProvider->getEdgeWeightTimesTakenVector();
    auto resUbAccesses =
        doPathAnalysis(std::string("NumAccesses"), ExtremumType::Maximum,
                       objUbAccesses, constraints);
    ar.registerResult("IntAna_MaxBusAccesses_BusAccesses", resUbAccesses);
    const unsigned &MaxBlockingPerAccess =
        blockingCyclingMemoryConfig.maxBlockingPerAccess;
    // If we wish a joint ILP to get maximal precision
    if (CompAnaJointILP) {
      scaleVarCoeffVector(objUbAccesses, MaxBlockingPerAccess);
      auto timeObjective = tpa.sgtp->getEdgeWeightTimesTakenVector();
      objUbAccesses.insert(objUbAccesses.end(), timeObjective.begin(),
                           timeObjective.end());
      auto resMaxTimeBlocking =
          doPathAnalysis(std::string("IntAna_MaxTimeBlocking"),
                         ExtremumType::Maximum, objUbAccesses, constraints);
      res = resMaxTimeBlocking;
    } else {
      if (res && resUbAccesses) {
        res = BoundItv{
            res.get().ub + resUbAccesses.get().ub * MaxBlockingPerAccess,
            res.get().lb + resUbAccesses.get().lb * MaxBlockingPerAccess};
      } else {
        res = boost::none;
      }
    }
  }

  return res;
}

///////////////////////////////////////////////////////////////////////////////
/// Cache: Path Analysis //////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

template <class MuArchDomain, class PAI>
boost::optional<BoundItv> dispatchCachePathAnalysis(const PAI &cacheAnaInfo) {
  // Select the type of path analysis
  MuStateGraph<typename MuArchDomain::State> *sg = nullptr;
  switch (PathAnaType) {
  case PathAnalysisType::SIMPLEILP: {
    sg = new InsensitiveGraph<MuArchDomain>(cacheAnaInfo);
    break;
  }
  case PathAnalysisType::GRAPHILP: {
    sg = new StateSensitiveGraph<MuArchDomain>(cacheAnaInfo);
    break;
  }
  default:
    errs() << "The chosen path analysis type is not supported.\n";
    return boost::none;
  }
  assert(sg != nullptr && "Could not create state graph.");

  // Build and dump state graph
  StateGraphNumericWeightProvider<typename MuArchDomain::State> sgtp(
      sg,
      [](const typename MuArchDomain::State::LocalMetrics &metrics) {
        return metrics.missedCache.size();
      },
      std::string("UB ") +
          (MuArchDomain::State::LocalMetrics::dCache ? "D$" : "I$") +
          " Misses");
  sg->buildGraph();

  if (!QuietMode) {
    VERBOSE_PRINT(" -> Finished Microarchitectural State Graph Construction\n");
    std::ofstream myfile;
    if (!DumpVcgGraph) {
      myfile.open(
          std::string("StateGraph_Misses") +
              (MuArchDomain::State::LocalMetrics::dCache ? "D$" : "I$") +
              ".dot",
          std::ios_base::trunc);
    } else {
      myfile.open(
          std::string("StateGraph_Misses") +
              (MuArchDomain::State::LocalMetrics::dCache ? "D$" : "I$") +
              ".vcg",
          std::ios_base::trunc);
    }
    sg->dump(myfile, nullptr);
    myfile.close();
  }

  sg->deleteMuArchInfo();

  // Create flow constraints
  std::list<GraphConstraint> constraints;
  {
    FlowConstraintProvider fcprov(sg);
    fcprov.buildConstraints();
    auto flowConstr = fcprov.getConstraints();
    constraints.insert(constraints.end(), flowConstr.begin(), flowConstr.end());
  }

  // Perform path analysis
  auto obj = sgtp.getEdgeWeightTimesTakenVector();
  auto result = doPathAnalysis(
      std::string("Misses") +
          (MuArchDomain::State::LocalMetrics::dCache ? "D$" : "I$"),
      ExtremumType::Maximum, obj, constraints);
  delete sg;
  return result;
}

///////////////////////////////////////////////////////////////////////////////
/// Cache-Related Preemption Delay: Path Analysis /////////////////////////////
///////////////////////////////////////////////////////////////////////////////

template <class MuArchDomain, class PAI>
boost::optional<BoundItv> dispatchCRPDPathAnalysis(const PAI &muAnaInfo,
                                                   TplGeneral) {
  return boost::none;
}

template <class MuArchDomain, class PAI,
          TplSwitch<decltype(MuArchDomain::State::LocalMetrics::memoryTopology
                                 .instrCache)> = 0,
          TplSwitch<decltype(MuArchDomain::State::LocalMetrics::memoryTopology
                                 .dataCache)> = 0>
boost::optional<BoundItv> dispatchCRPDPathAnalysis(const PAI &muAnaInfo,
                                                   TplSpecial) {
  typedef typename MuArchDomain::State MuState;

  Statistics &stats = Statistics::getInstance();
  stats.startMeasurement("CRPD Stategraph Generation");

  // Select the type of path analysis
  MuStateGraph<MuState> *sg = nullptr;
  switch (PathAnaType) {
  case PathAnalysisType::SIMPLEILP: {
    sg = new InsensitiveGraph<MuArchDomain>(muAnaInfo);
    break;
  }
  case PathAnalysisType::GRAPHILP: {
    sg = new StateSensitiveGraph<MuArchDomain>(muAnaInfo);
    break;
  }
  default:
    errs() << "The chosen path analysis type is not supported.\n";
    return boost::none;
  }
  assert(sg != nullptr && "Could not create state graph.");

  assert(needAccessedDataAddresses() && needAccessedInstructionAddresses() &&
         "Important weight providers not available");

  // Add the address interval weight provider
  auto getIJustAccessed = [](const typename MuState::LocalMetrics &lm) {
    return lm.memoryTopology.justUpdatedInstrCache;
  };
  const auto *sgicacc =
      new StateGraphAddressProvider<MuState>(sg, false, getIJustAccessed);

  // TODO Uncomment the following to activate data address provider
  /* tblass: Don't! First fix the FIXME in GraphIterator */
  //	auto getDJustAccessed = [](const typename MuState::LocalMetrics& lm) {
  // return lm.memoryTopology.justUpdatedDataCache; }; 	const auto *sgdcacc =
  // new StateGraphAddressProvider<MuState>(sg, true, getDJustAccessed);

  // Build the state graph
  sg->buildGraph();

  if (!QuietMode) {
    VERBOSE_PRINT(" -> Finished Microarchitectural State Graph Construction\n");
    std::ofstream myfile;
    if (!DumpVcgGraph) {
      myfile.open(std::string("StateGraph_CRPD.dot", std::ios_base::trunc));
    } else {
      myfile.open(std::string("StateGraph_CRPD.vcg", std::ios_base::trunc));
    }
    sg->dump(myfile, nullptr);
    myfile.close();
  }

  if (!AnaType.isSet(AnalysisType::TIMING)) {
    sg->deleteMuArchInfo();
  }

  stats.stopMeasurement("CRPD Stategraph Generation");

  // CRPD
  const auto &SimpleGraph = sg->getGraph();
  performCRPDAnalysis(SimpleGraph, CacheType::INSTRUCTION, sgicacc);
  delete sgicacc;

  // TODO Uncomment for CRPD analysis for Data Cache (better use
  // performCRPDAnalysis)
  //	CacheRelatedPreemptionDelay<CacheConfig> CRPDData(SimpleGraph, sgdcacc);
  //	CRPDData.runResilienceAnalysis({});

  delete sg;
  return boost::none;
}

///////////////////////////////////////////////////////////////////////////////
/// Iterative Path Analysis ///////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

template <class MuState>
boost::optional<BoundItv> doCoRunnerSensitivePathAnalysis(
    MuStateGraph<MuState> *pSg, MuStateGraph<MuState> *pArrivalCurveSg,
    StateGraphNumericWeightProvider<MuState, int> &sgtp,
    StateGraphCacheMissProvider<MuState, CacheType::DATA> *sgdcpers,
    StateGraphCacheMissProvider<MuState, CacheType::INSTRUCTION> *sgicpers) {
  /* ==============================================
   * Initialization phase
   * ==============================================
   */
  MuStateGraph<MuState> &sg = *pSg;

  assert(NumConcurrentCores >= 1u && "The co-runner-sensitive analysis does "
                                     "not work without concurrent cores.");
  assert((!CoRunnerSensitiveNoWcetBound ||
          !CoRunnerSensitiveNoArrivalCurveValues) &&
         "At least one of these options has to be false.");
  assert(!(ProgramPeriodRel.getNumOccurrences() > 0 &&
           CoRunnerSensitiveNoWcetBound) &&
         "Cannot skip the WCET bound calculation in iterative mode if relative "
         "period is wanted...");

  // Use a different state graph for the
  // arrival curves as soon as we have to
  // calculate arrival curves AND (the
  // BlockingJoinablePartitionSize
  // for the run optimizations is > 0 OR
  // AccessCyclesJoinablePartitionSize > 0).
  MuStateGraph<MuState> &arrivalCurveStateGraph =
      (SelectedArrivalCurveCalculationMethod ==
           ArrivalCurveCalculationMethod::ILPBASED &&
       (BlockingJoinablePartitionSize > 0 ||
        AccessCyclesJoinablePartitionSize > 0))
          ? *pArrivalCurveSg
          : sg;

  // provider of lower bound over number of processor cycles
  StateGraphNumericWeightProvider<MuState> lbTimeProvider(
      &arrivalCurveStateGraph,
      static_cast<
          std::function<unsigned(const typename MuState::LocalMetrics &)>>(
          [](const typename MuState::LocalMetrics &metrics) {
            return metrics.time.getLb() +
                   getFastForwardedAccessCycles(bgMemMetr(metrics)).getLb();
          }),
      "LB Time");
  lbTimeProvider.setWeightJoiner(
      (const unsigned &(*)(const unsigned &, const unsigned &)) & std::min);

  // provider of upper bound over number of accesses
  StateGraphNumericWeightProvider<MuState> ubAccessesProvider(
      &sg,
      [](const typename MuState::LocalMetrics &metrics) {
        return getUbAccesses(bgMemMetr(metrics));
      },
      "UB Accesses");

  // provider of lower bound on the number of blocking cycles
  StateGraphNumericWeightProvider<MuState> lbBlockingProvider(
      &sg,
      static_cast<
          std::function<unsigned(const typename MuState::LocalMetrics &)>>(
          [](const typename MuState::LocalMetrics &metrics) {
            return getLbBlockingCycles(bgMemMetr(metrics));
          }),
      "LB Blocking");
  lbBlockingProvider.setWeightJoiner(
      (const unsigned &(*)(const unsigned &, const unsigned &)) & std::min);
  if (BlockingJoinablePartitionSize > 0 && !CoRunnerSensitiveNoWcetBound) {
    lbBlockingProvider.setAreWeightsJoinable(
        [](const unsigned &a, const unsigned &b) {
          return a / BlockingJoinablePartitionSize ==
                 b / BlockingJoinablePartitionSize;
        });
  }

  // provider of lower bound on the number of concurrentaccesses
  StateGraphNumericWeightProvider<MuState> lbConcAccessesProvider(
      &sg,
      [](const typename MuState::LocalMetrics &metrics) {
        return getLbConcAccesses(bgMemMetr(metrics));
      },
      "LB Conc Accesses");
  lbConcAccessesProvider.setWeightJoiner(
      (const unsigned &(*)(const unsigned &, const unsigned &)) & std::min);

  // provider of upper bounds on the number of access cycles
  StateGraphNumericWeightProvider<MuState, int> ubAccessCyclesProvider(
      &arrivalCurveStateGraph,
      static_cast<std::function<int(const typename MuState::LocalMetrics &)>>(
          [](const typename MuState::LocalMetrics &metrics) {
            auto bgMem = bgMemMetr(metrics);
            return getUbAccessCycles(bgMem) +
                   getFastForwardedAccessCycles(bgMem).getUb();
          }),
      "UB Access Cycles");
  if (SelectedArrivalCurveCalculationMethod ==
          ArrivalCurveCalculationMethod::ILPBASED &&
      AccessCyclesJoinablePartitionSize > 0 &&
      !CoRunnerSensitiveNoArrivalCurveValues) {
    ubAccessCyclesProvider.setAreWeightsJoinable(
        [](const int &a, const int &b) {
          return a / AccessCyclesJoinablePartitionSize ==
                 b / AccessCyclesJoinablePartitionSize;
        });
  }

  // upper bound on the loop implementing the blocked cycles
  StateGraphNumericWeightProvider<MuState> ubBlockedCycleLoopProvider(
      &sg,
      static_cast<
          std::function<unsigned(const typename MuState::LocalMetrics &)>>(
          [](const typename MuState::LocalMetrics &metrics) {
            return getFastForwardedBlocking(bgMemMetr(metrics)).getUb();
          }),
      "UB Blocked Cycle Loop");

  // upper bound on the loop implementing the access cycles
  StateGraphNumericWeightProvider<MuState> ubTimeCycleLoopProvider(
      &arrivalCurveStateGraph,
      static_cast<
          std::function<unsigned(const typename MuState::LocalMetrics &)>>(
          [](const typename MuState::LocalMetrics &metrics) { return 0; }),
      "UB Time Cycle Loop");

  // if we do not only consider single program runs in path
  // analysis, we need to also take into account that there
  // may also pass time between program runs, while all other
  // kinds of events that we typically account for never
  // occur outside of a program run.
  sgtp.setIdleCycleWeight(1u);
  lbTimeProvider.setIdleCycleWeight(1u);

  // build state graph with all providers registered so far
  if (&sg == &arrivalCurveStateGraph ||
      (&sg != &arrivalCurveStateGraph && !CoRunnerSensitiveNoWcetBound)) {
    sg.buildGraph();
  }
  if (&sg != &arrivalCurveStateGraph &&
      !CoRunnerSensitiveNoArrivalCurveValues) {
    arrivalCurveStateGraph.buildGraph();
  }

  if (!QuietMode) {
    VERBOSE_PRINT(" -> Finished Microarchitectural State Graph Construction\n");
    // dump the state graph to file
    if (&sg == &arrivalCurveStateGraph ||
        (&sg != &arrivalCurveStateGraph && !CoRunnerSensitiveNoWcetBound)) {
      std::ofstream myfile;
      if (!DumpVcgGraph) {
        myfile.open("StateGraph_Time.dot", std::ios_base::trunc);
      } else {
        myfile.open("StateGraph_Time.vcg", std::ios_base::trunc);
      }
      sg.dump(myfile, nullptr);
      myfile.close();
    }
    if (&sg != &arrivalCurveStateGraph &&
        !CoRunnerSensitiveNoArrivalCurveValues) {
      std::ofstream myFile;
      if (!DumpVcgGraph) {
        myFile.open("StateGraph_ArrivalCurveAccessCycles.dot",
                    std::ios_base::trunc);
      } else {
        myFile.open("StateGraph_ArrivalCurveAccessCycles.vcg",
                    std::ios_base::trunc);
      }
      arrivalCurveStateGraph.dump(myFile, nullptr);
      myFile.close();
    }
  }

  sg.deleteMuArchInfo();

  // Trigger the next measurement phase
  Statistics &stats = Statistics::getInstance();
  stats.stopMeasurement("Timing Stategraph Generation");
  stats.startMeasurement("Timing Path Analysis");

  std::list<GraphConstraint> flowConstr;
  VarCoeffVector lbBlockingTimesTakenVector;
  VarCoeffVector ubTimeTimesTakenVector;
  if (&sg == &arrivalCurveStateGraph ||
      (&sg != &arrivalCurveStateGraph && !CoRunnerSensitiveNoWcetBound)) {
    // build flow constraints
    FlowConstraintProvider fcprov(&sg);
    fcprov.buildConstraints();
    flowConstr = fcprov.getConstraints();

    // add persistence constraints if available
    if (sgdcpers) {
      // Extract the constraints down to this level
      const auto &dataPersConstr = sgdcpers->getPersistenceConstraints();
      flowConstr.insert(flowConstr.end(), dataPersConstr.begin(),
                        dataPersConstr.end());
    }
    if (sgicpers) {
      // Extract the constraints down to this level
      const auto &instrPersConstr = sgicpers->getPersistenceConstraints();
      flowConstr.insert(flowConstr.end(), instrPersConstr.begin(),
                        instrPersConstr.end());
    }

    // constraint the blocked cycle loop
    auto constraintLeftHandSide = ubBlockedCycleLoopProvider.getVarCoeffVector(
        [](const std::map<GraphEdge, unsigned> &edge2weight,
           VarCoeffVector &result,
           const std::pair<const GraphEdge, unsigned> &currEdgeWeight) {
          auto ubBlockedCycleLoop = currEdgeWeight.second;
          if (ubBlockedCycleLoop > 0) {
            // constraint how often the blocked cycle loop may at most be taken
            auto edgeTimesTakenVar = Variable::getEdgeVar(
                Variable::Type::timesTaken, currEdgeWeight.first);
            result.push_back(
                std::make_pair(edgeTimesTakenVar, ubBlockedCycleLoop));
          }
        });
    auto blockedCycleLoopTimesTakenVar =
        Variable::getGlobalVar(Variable::Type::blockedCycleLoopTimesTaken);
    constraintLeftHandSide.push_back(
        std::make_pair(blockedCycleLoopTimesTakenVar, -1));
    flowConstr.push_back(std::make_tuple(constraintLeftHandSide,
                                         ConstraintType::GreaterEqual, 0));

    // the blocked cycle loops are needed for tight bounds
    // on the overall amount of blocking
    lbBlockingTimesTakenVector =
        lbBlockingProvider.getEdgeWeightTimesTakenVector();
    lbBlockingTimesTakenVector.push_back(
        std::make_pair(blockedCycleLoopTimesTakenVar, 1));

    // the blocked cycle loops also contribute to the UB of the time
    ubTimeTimesTakenVector = sgtp.getEdgeWeightTimesTakenVector();
    ubTimeTimesTakenVector.push_back(
        std::make_pair(blockedCycleLoopTimesTakenVar, 1));
  }

  // the optional times taken vectors potentially needed
  // for the ILP arrival curve value calculation
  boost::optional<VarCoeffVector> lbTime_edgeTimesTakenVector;
  std::function<void()> lbTime_edgeTimesTakenVector_init = [&]() {
    assert(!lbTime_edgeTimesTakenVector);
    lbTime_edgeTimesTakenVector =
        lbTimeProvider.getEdgeWeightTimesTakenVector();
  };
  boost::optional<VarCoeffVector> lbTime_edgeTimesTakenVector_withoutStartEnd;
  std::function<void()> lbTime_edgeTimesTakenVector_withoutStartEnd_init =
      [&]() {
        assert(!lbTime_edgeTimesTakenVector_withoutStartEnd);
        lbTime_edgeTimesTakenVector_withoutStartEnd =
            lbTimeProvider.getEdgeWeightTimesTakenVector(true);
      };
  boost::optional<VarCoeffVector> lbTime_negatedEdgeTimesTakenVector;
  std::function<void()> lbTime_negatedEdgeTimesTakenVector_init = [&]() {
    assert(!lbTime_negatedEdgeTimesTakenVector);
    // construct the negated vector from the
    // non-negated one
    if (!lbTime_edgeTimesTakenVector) {
      lbTime_edgeTimesTakenVector_init();
      assert(lbTime_edgeTimesTakenVector);
    }
    lbTime_negatedEdgeTimesTakenVector.emplace();
    VarCoeffVector &innerVector = *lbTime_negatedEdgeTimesTakenVector;
    for (auto &entry : *lbTime_edgeTimesTakenVector) {
      innerVector.push_back(std::make_pair(entry.first, -1.0 * entry.second));
    }
  };
  boost::optional<VarCoeffVector> lbTime_negatedEdgeTimesTakenSubVector;
  std::function<void()> lbTime_negatedEdgeTimesTakenSubVector_init = [&]() {
    assert(!lbTime_negatedEdgeTimesTakenSubVector);
    // explicitly construct the negated vector
    lbTime_negatedEdgeTimesTakenSubVector = lbTimeProvider.getVarCoeffVector(
        [](const std::map<GraphEdge, unsigned> &edge2weight,
           VarCoeffVector &result,
           const std::pair<const GraphEdge, unsigned> &currEdgeWeight) {
          auto edgeTimesTakenSubVar = Variable::getEdgeVar(
              Variable::Type::timesTakenSub, currEdgeWeight.first);
          unsigned currLowerTimeBound = currEdgeWeight.second;
          result.push_back(
              std::make_pair(edgeTimesTakenSubVar, -1.0 * currLowerTimeBound));
        });
  };
  boost::optional<VarCoeffVector>
      ubAccessCycles_minus_lbTime_edgeTimesTakenVector_withoutStartEnd;
  std::function<void()>
      ubAccessCycles_minus_lbTime_edgeTimesTakenVector_withoutStartEnd_init =
          [&]() {
            assert(
                !ubAccessCycles_minus_lbTime_edgeTimesTakenVector_withoutStartEnd);
            // construct the vector of ub access cycles first
            ubAccessCycles_minus_lbTime_edgeTimesTakenVector_withoutStartEnd =
                ubAccessCyclesProvider.getEdgeWeightTimesTakenVector(true);
            // then directly add the negated version
            // of the vector of lb time to the
            // existing vector
            VarCoeffVector &innerVector =
                *ubAccessCycles_minus_lbTime_edgeTimesTakenVector_withoutStartEnd;
            lbTimeProvider.getVarCoeffVector(
                [&innerVector](const std::map<GraphEdge, unsigned> &edge2weight,
                               VarCoeffVector &result,
                               const std::pair<const GraphEdge, unsigned>
                                   &currEdgeWeight) {
                  auto edgeTimesTakenVar = Variable::getEdgeVar(
                      Variable::Type::timesTaken, currEdgeWeight.first);
                  innerVector.push_back(std::make_pair(
                      edgeTimesTakenVar, -1.0 * currEdgeWeight.second));
                  auto edgeIsStartVar = Variable::getEdgeVar(
                      Variable::Type::isStart, currEdgeWeight.first);
                  innerVector.push_back(
                      std::make_pair(edgeIsStartVar, currEdgeWeight.second));
                  auto edgeIsEndVar = Variable::getEdgeVar(
                      Variable::Type::isEnd, currEdgeWeight.first);
                  innerVector.push_back(
                      std::make_pair(edgeIsEndVar, currEdgeWeight.second));
                });
          };
  boost::optional<VarCoeffVector> ubAccessCycles_edgeTimesTakenVector;
  std::function<void()> ubAccessCycles_edgeTimesTakenVector_init = [&]() {
    assert(!ubAccessCycles_edgeTimesTakenVector);
    ubAccessCycles_edgeTimesTakenVector =
        ubAccessCyclesProvider.getEdgeWeightTimesTakenVector();
  };
  boost::optional<VarCoeffVector> lbConcAccesses_edgeTimesTakenVector;
  std::function<void()> lbConcAccesses_edgeTimesTakenVector_init = [&]() {
    assert(!lbConcAccesses_edgeTimesTakenVector);
    lbConcAccesses_edgeTimesTakenVector =
        lbConcAccessesProvider.getEdgeWeightTimesTakenVector();
  };

  // implementation artifact:
  // we represent infinite by -1
  cpp_int infinity(-1);

  // declaration of the variables later used in the algorithm
  cpp_int wcetBound;
  cpp_int previousWcetBound;
  cpp_int bcetBound(0); // 0 as initial value is always sound, calculate better
                        // one only if necessary...
  cpp_int accessBound;
  cpp_int blockingBound(CoRunnerSensitiveAnalysisFixedPointType ==
                                FixedPointType::GREATEST
                            ? infinity
                            : 0);
  cpp_int concAccessesBound(CoRunnerSensitiveAnalysisFixedPointType ==
                                    FixedPointType::GREATEST
                                ? infinity
                                : 0);
  bool recalculateWcetBound = true;
  std::list<cpp_int> accessCycleBounds;
  std::list<cpp_int> staticAccessCycleBounds;
  std::list<GraphConstraint> flowAndBlockingConstr;
  std::list<GraphConstraint> generalPathFlowConstr;
  GraphConstraint blockingConstr;
  int numAdditionalIterations = 0;
  std::map<cpp_int, cpp_int> maxAccessCyclesPerCache;
  VarCoeffVector progStartVars;
  cpp_int effectivePeriod = (unsigned)ProgramPeriod;

  // upper bound on the number of cycles an access might take on the bus
  cpp_int UBbusCyclesPerAccess;
  switch (BackgroundMemoryType) {
  case BgMemType::SRAM: {
    UBbusCyclesPerAccess =
        std::max(getCachelineMemoryLatency(CacheType::INSTRUCTION),
                 getCachelineMemoryLatency(CacheType::DATA));
    break;
  }
  case BgMemType::SIMPLEDRAM: {
    assert(0 && "SDRAM is not yet supported in combination with "
                "the iterative analysis approach");
    break;
  }
  default: {
    assert(0 && "Unsupported background memory type");
    break;
  }
  }

  /* ==============================================
   * Helper function definition phase
   * ==============================================
   */

  std::function<cpp_int(cpp_int)> maxAccessCyclesPer;
  std::function<cpp_int(cpp_int)> maxAccessCyclesPerInner;
  {
    if (CoRunnerSensitiveNoArrivalCurveValues) {
      maxAccessCyclesPerInner = [&](cpp_int time) { return time; };
    } else {
      switch (SelectedArrivalCurveCalculationMethod) {
      case ArrivalCurveCalculationMethod::PROGRAM_GRANULARITY: {
        // in some cases with a relative period, we know that
        // the absolute period evaluated from the relative value
        // will definitely at least be as high as the BCET bound.
        // in those cases, there is no point in a BCET bound.
        if (!(ProgramPeriodRel.getNumOccurrences() > 0 &&
              ((!ProgramPeriodRelEvalWrtWcetIgnoringInterference &&
                ProgramPeriodRel >= 0) ||
               (ProgramPeriodRelEvalWrtWcetIgnoringInterference &&
                ProgramPeriodRel >= 1)))) {
          // lower bound on the execution time in any program run
          if (!lbTime_edgeTimesTakenVector) {
            lbTime_edgeTimesTakenVector_init();
            assert(lbTime_edgeTimesTakenVector);
          }
          auto pathAnaRes =
              doPathAnalysis("Time", ExtremumType::Minimum,
                             *lbTime_edgeTimesTakenVector, flowConstr);
          bcetBound = pathAnaRes
                          ? optDoubleToInt(pathAnaRes.get().lb,
                                           false /*in doubt, round down*/)
                          : 1;
        }

        // calculate the max access cycles for the
        // interval length time based on the maximum number
        // of accesses and the period.
        maxAccessCyclesPerInner = [&](cpp_int time) {
          cpp_int accessCycles(0);

          // in 0 time there can only be 0 blocking
          if (time == 0) {
            return accessCycles;
          }

          // in case of an unbounded number of
          // accesses or a period of 0,
          // we have to be maximally pessimistic
          if (accessBound == infinity || effectivePeriod == 0) {
            return time;
          }

          // maximal amount of access cycles per program run
          cpp_int UBAccCycPerProgRun = accessBound * UBbusCyclesPerAccess;

          // Michael: the following three orthogonal bounds are
          // described in Section 10.1 of my dissertation

          // by how much does time exceed UBAccCycPerProgRun, if any
          cpp_int exceed_time = time - UBAccCycPerProgRun;
          if (exceed_time < 0)
            exceed_time = 0;

          // how many times does effectivePeriod completely fit into exceed_time
          cpp_int d = exceed_time / effectivePeriod;
          // and how much is left
          cpp_int m = exceed_time % effectivePeriod;

          // first bound
          cpp_int bound1 = UBAccCycPerProgRun + d * UBAccCycPerProgRun;
          if (m != 0)
            bound1 += UBAccCycPerProgRun;

          // second bound
          cpp_int bound2 = UBAccCycPerProgRun + d * UBAccCycPerProgRun;
          bound2 += m;

          // third bound
          cpp_int bound3 = time;

          // return the minimum
          accessCycles = bound1 < bound2 ? bound1 : bound2;
          if (bound3 < accessCycles)
            accessCycles = bound3;
          return accessCycles;
        };
        break;
      }
      case ArrivalCurveCalculationMethod::ILPBASED: {
        // Arrival curve calculation using ILP.
        // In this alternative, in general, we cannot use the blocking
        // constraint as the blocking bound is only valid for interval lengths
        // smaller or equal to the WCET bound. Even if this is given for a
        // certain interval length, we still would have to take care about the
        // corner cases with the first and the last basic block in the interval.
        // Thus a blocking constraint for an arrival-curve-calculating ILP would
        // have to look slightly different. And finally, it is very unlikely
        // that the cases excluded because they exceed a blocking bound would
        // have also lead to the maximum value in terms of granted access
        // cycles.

        // build flow constraints that also argue
        // about paths that do not correspond to
        // a single program run.
        FlowConstraintProvider generalfcprov(
            &arrivalCurveStateGraph, false, /*activate non-run mode*/
            true, /*not interpreted in non-run mode anyway*/
            ArrivalCurveLoopGetInnerEdgesMethod,
            ArrivalCurveCallSiteGetInnerEdgesMethod);
        generalfcprov.buildConstraints();
        generalPathFlowConstr = generalfcprov.getConstraints();

        // for the subpath method, we need further
        // flow constraints for a subpath of the
        // considered path that only executes
        // complete program runs.
        // MJa: quick fix: in case of only a relative period given,
        // the effective period was at this point still the default
        // value of the absolute period (0) and, thus, prevented the
        // constraints for the sub path method from being created.
        if ((effectivePeriod > 0 || ProgramPeriodRel.getNumOccurrences() > 0) &&
            ProgramPeriodSubpathMethod) {
          // add flow constraints for complete runs
          FlowConstraintProvider subpathfcprov(
              &arrivalCurveStateGraph, true /*activate run mode*/,
              true /*allow the execution of several runs*/);
          subpathfcprov.setTimesTakenType(Variable::Type::timesTakenSub);
          subpathfcprov.buildConstraints();
          auto subpathfc = subpathfcprov.getConstraints();
          generalPathFlowConstr.insert(generalPathFlowConstr.end(),
                                       subpathfc.begin(), subpathfc.end());

          // already collect variables for
          // a constraint constructed later
          VarCoeffVector negProgStartVarsSubPath;

          // it should be a subpath
          for (const auto &vertex :
               arrivalCurveStateGraph.getGraph().getVertices()) {
            for (const auto &vt_succ : vertex.second.getSuccessors()) {
              auto edge = std::make_pair(vertex.first, vt_succ);
              auto edgeTimesTakenVar =
                  Variable::getEdgeVar(Variable::Type::timesTaken, edge);
              auto edgeTimesTakenSubVar =
                  Variable::getEdgeVar(Variable::Type::timesTakenSub, edge);
              VarCoeffVector isSubpathConstrVars;
              isSubpathConstrVars.push_back(
                  std::make_pair(edgeTimesTakenVar, 1));
              isSubpathConstrVars.push_back(
                  std::make_pair(edgeTimesTakenSubVar, -1));
              generalPathFlowConstr.push_back(std::make_tuple(
                  isSubpathConstrVars, ConstraintType::GreaterEqual, 0));

              // for the program start edges we collect even more
              if (edge.first == 0 && edge.second != 0) {
                progStartVars.push_back(std::make_pair(edgeTimesTakenVar, 1));
                negProgStartVarsSubPath.push_back(
                    std::make_pair(edgeTimesTakenSubVar, -1));
              }
            }
          }

          // the program start edges in the sub path should
          // be taken exactly once less than the program
          // start edges in the original path
          // MJa: The "exactly once" is a problem as soon as
          // there is no program start edge at all in the
          // originally considered path. This leads to the
          // sub path being infeasible, as it cannot contain
          // a negative amount of program start edges. This
          // leads to the whole assignment being infeasible.
          // Thus we are not sure to catch all paths with
          // the original constraint and might end up with
          // unsound arrival curve values.
          // The new solution realizes the difference of 1 by
          // a binary variable that is only true iff the
          // originally considered path contains at least one
          // program start edge.
          auto containsProgStartVar =
              Variable::getGlobalVar(Variable::Type::containsProgStart);
          {
            // Sum of prog start edges is greater equal containsProgStartVar
            VarCoeffVector vcv;
            vcv.insert(vcv.end(), progStartVars.begin(), progStartVars.end());
            vcv.push_back(std::make_pair(containsProgStartVar, -1));
            generalPathFlowConstr.push_back(
                std::make_tuple(vcv, ConstraintType::GreaterEqual, 0));
          }
          // a further constraint restricting the value of containsProgStart
          // depends on the window length and therefore has to be recreated
          // for each window length...
          {
            VarCoeffVector progStartConstrVars;
            progStartConstrVars.insert(progStartConstrVars.end(),
                                       progStartVars.begin(),
                                       progStartVars.end());
            progStartConstrVars.insert(progStartConstrVars.end(),
                                       negProgStartVarsSubPath.begin(),
                                       negProgStartVarsSubPath.end());
            progStartConstrVars.push_back(
                std::make_pair(containsProgStartVar, -1));
            generalPathFlowConstr.push_back(
                std::make_tuple(progStartConstrVars, ConstraintType::Equal, 0));
          }
        }

        // build a constraint bounding the maximum number of access cycles
        if (ArrivalCurveIlpObjective ==
            ArrivalCurveIlpObjectiveType::COMBINED) {
          if (!ubAccessCycles_edgeTimesTakenVector) {
            ubAccessCycles_edgeTimesTakenVector_init();
            assert(ubAccessCycles_edgeTimesTakenVector);
          }
          auto leftHandSide = *ubAccessCycles_edgeTimesTakenVector;
          Variable maxAccessCycles =
              Variable::getGlobalVar(Variable::Type::maxAccessCycles);
          leftHandSide.push_back(std::make_pair(maxAccessCycles, -1));
          generalPathFlowConstr.push_back(
              std::make_tuple(leftHandSide, ConstraintType::GreaterEqual, 0));
        }

        maxAccessCyclesPerInner = [&](cpp_int time) {
          cpp_int accessCycles(0);

          // in 0 time there can only be 0 blocking
          if (time == 0) {
            return accessCycles;
          }

          // create the window constraint
          std::list<GraphConstraint> flowAndWindowconstr;
          if (time != infinity) {
            // add all the flow constraints
            flowAndWindowconstr.insert(flowAndWindowconstr.end(),
                                       generalPathFlowConstr.begin(),
                                       generalPathFlowConstr.end());
            // true-parameter: make sure that the weight for
            // the first and the last edge in the path is
            // not included in the overall weight
            {
              if (!lbTime_edgeTimesTakenVector_withoutStartEnd) {
                lbTime_edgeTimesTakenVector_withoutStartEnd_init();
                assert(lbTime_edgeTimesTakenVector_withoutStartEnd);
              }
              VarCoeffVector &leftHandSide =
                  *lbTime_edgeTimesTakenVector_withoutStartEnd;
              GraphConstraint windowConstr =
                  std::make_tuple(leftHandSide, ConstraintType::LessEqual,
                                  intToDouble(time, true));
              flowAndWindowconstr.push_back(windowConstr);
            }
          }

          // add a period constraint
          // MJa: if time == infinity, we can only get an
          // non-infinite objective value if the program
          // never performs a single access cycle. in that
          // particular case, we would not profit at all
          // from the additional period constraint...
          if (effectivePeriod > 0 && time != infinity) {
            // add all the flow constraints if not already
            // done so
            if (flowAndWindowconstr.empty()) {
              flowAndWindowconstr.insert(flowAndWindowconstr.end(),
                                         generalPathFlowConstr.begin(),
                                         generalPathFlowConstr.end());
            }

            const double period = intToDouble(effectivePeriod, false);

            // helper to construct the left hand side
            // of the constraint depending on the
            // times taken variable type
            auto buildLeftHandSide = [&](Variable::Type timesTakenType) {
              // subtract the lower time bounds of the edges multiplied
              // with their times taken count
              VarCoeffVector leftHandSide;
              switch (timesTakenType) {
              case Variable::Type::timesTaken: {
                if (!lbTime_negatedEdgeTimesTakenVector) {
                  lbTime_negatedEdgeTimesTakenVector_init();
                  assert(lbTime_negatedEdgeTimesTakenVector);
                }
                leftHandSide = *lbTime_negatedEdgeTimesTakenVector;
                break;
              }
              case Variable::Type::timesTakenSub: {
                if (!lbTime_negatedEdgeTimesTakenSubVector) {
                  lbTime_negatedEdgeTimesTakenSubVector_init();
                  assert(lbTime_negatedEdgeTimesTakenSubVector);
                }
                leftHandSide = *lbTime_negatedEdgeTimesTakenSubVector;
                break;
              }
              default: {
                assert(false && "some times taken variable type expected");
                break;
              }
              }
              // add the period multiplied with the
              // times taken counts of the program's
              // start edges
              for (auto edgeSinkId :
                   arrivalCurveStateGraph.getGraph().getSuccessors(0)) {
                if (edgeSinkId == 0) {
                  // the idle cycle is not a program start edge
                  continue;
                }
                auto progStartEdge = std::make_pair(0, edgeSinkId);
                auto edgeTimesTakenVar =
                    Variable::getEdgeVar(timesTakenType, progStartEdge);
                leftHandSide.push_back(
                    std::make_pair(edgeTimesTakenVar, period));
              }
              return leftHandSide;
            };

            // build the normal period constraint
            GraphConstraint periodConstr =
                std::make_tuple(buildLeftHandSide(Variable::Type::timesTaken),
                                ConstraintType::LessEqual, period);
            flowAndWindowconstr.push_back(periodConstr);

            if (ProgramPeriodSubpathMethod) {
              {
                auto containsProgStartVar =
                    Variable::getGlobalVar(Variable::Type::containsProgStart);
                // containsProgStart times window length is greater equal
                // sum of prog start edges
                VarCoeffVector vcv;
                vcv.insert(vcv.end(), progStartVars.begin(),
                           progStartVars.end());
                vcv.push_back(std::make_pair(containsProgStartVar,
                                             -intToDouble(time, true)));
                flowAndWindowconstr.push_back(
                    std::make_tuple(vcv, ConstraintType::LessEqual, 0));
              }
              // build the subpath period constraint
              GraphConstraint subpathPeriodConstr = std::make_tuple(
                  buildLeftHandSide(Variable::Type::timesTakenSub),
                  ConstraintType::LessEqual, 0);
              flowAndWindowconstr.push_back(subpathPeriodConstr);
            }
          }

          // construct the second variant of the objective
          if (ArrivalCurveIlpObjective ==
                  ArrivalCurveIlpObjectiveType::COMBINED &&
              time != infinity) {
            // add all the flow constraints if not already
            // done so
            if (flowAndWindowconstr.empty()) {
              flowAndWindowconstr.insert(flowAndWindowconstr.end(),
                                         generalPathFlowConstr.begin(),
                                         generalPathFlowConstr.end());
            }

            if (!ubAccessCycles_minus_lbTime_edgeTimesTakenVector_withoutStartEnd) {
              ubAccessCycles_minus_lbTime_edgeTimesTakenVector_withoutStartEnd_init();
              assert(
                  ubAccessCycles_minus_lbTime_edgeTimesTakenVector_withoutStartEnd);
            }
            VarCoeffVector leftHandSide =
                *ubAccessCycles_minus_lbTime_edgeTimesTakenVector_withoutStartEnd;

            // subtract the maximal number of access cycles variable
            Variable maxAccessCycles =
                Variable::getGlobalVar(Variable::Type::maxAccessCycles);
            leftHandSide.push_back(std::make_pair(maxAccessCycles, -1.0));

            // the result has to be greater equal the negated window length
            flowAndWindowconstr.push_back(
                std::make_tuple(leftHandSide, ConstraintType::GreaterEqual,
                                -1.0 * intToDouble(time, true)));
          }

          // perform the actual arrival curve value calculation
          auto &usedConstr = !flowAndWindowconstr.empty()
                                 ? flowAndWindowconstr
                                 : generalPathFlowConstr;
          VarCoeffVector objective;
          {
            // for performance reasons, we still keep the
            // coefficient vector explicit in the objective
            // in case we have only one objective.
            switch (ArrivalCurveIlpObjective) {
            case ArrivalCurveIlpObjectiveType::VARIANT1:
              if (!ubAccessCycles_edgeTimesTakenVector) {
                ubAccessCycles_edgeTimesTakenVector_init();
                assert(ubAccessCycles_edgeTimesTakenVector);
              }
              objective = *ubAccessCycles_edgeTimesTakenVector;
              break;
            case ArrivalCurveIlpObjectiveType::VARIANT2:
              if (!ubAccessCycles_minus_lbTime_edgeTimesTakenVector_withoutStartEnd) {
                ubAccessCycles_minus_lbTime_edgeTimesTakenVector_withoutStartEnd_init();
                assert(
                    ubAccessCycles_minus_lbTime_edgeTimesTakenVector_withoutStartEnd);
              }
              objective =
                  *ubAccessCycles_minus_lbTime_edgeTimesTakenVector_withoutStartEnd;
              // MJa: actually, we would want to add time as additional constant
              // to the objective. as this is not possible, and I also do not
              // want to simulate this by a dummy variable, we have to add time
              // later in case the result is bounded.
              break;
            case ArrivalCurveIlpObjectiveType::COMBINED:
              Variable maxAccessCycles =
                  Variable::getGlobalVar(Variable::Type::maxAccessCycles);
              objective.push_back(std::make_pair(maxAccessCycles, 1));
              break;
            }
          }
          auto pathAnaRes =
              doPathAnalysis("ArrivalCurveAccessCycles", ExtremumType::Maximum,
                             objective, usedConstr, nullptr,
                             ArrivalCurveIlpTimeLimit // time limit taken from
                                                      // command line parameter
              );
          cpp_int result = pathAnaRes
                               ? optDoubleToInt(pathAnaRes.get().ub,
                                                true /*in doubt, round up*/)
                               : infinity;

          // MJa: add the additional constant mentioned earlier
          if (ArrivalCurveIlpObjective ==
                  ArrivalCurveIlpObjectiveType::VARIANT2 &&
              result != infinity) {
            result += time;
          }

          // pessimistically assume one access cycle more happened to
          // compensate for the otherwise potentially unsound
          // result due to our implementation of the delayed
          // splits for memory accesses. A complete delaying of all
          // case splits to the end of the access would not require
          // any changes. However, the last granted access cycles still
          // remains at the very end of the access in some cases in our
          // implementation. Thus, adding a safety margin of one access
          // cycle is sufficient. Cf. my notes of 23.08.2017.
          //   result != infinity:
          //     prevent -1 (infinity) from becoming a
          //     positive value (non-infinite)
          //   result > 0:
          //     a result of zero is only possible if
          //     there is no edge annotated with a single
          //     event. in that case, there is no unsoundness
          //     due to delayed split
          if (result != infinity && result > 0) {
            result += 1;
          }

          // make sure never return more than the interval length
          return result <= time ? result : time;
        };
        break;
      }
      default:
        assert(false && "Unsupported arrival curve calculation method.");
        break;
      }
    }

    // implement the caching
    maxAccessCyclesPer = [&](cpp_int time) {
      // skip the curve value calculation
      if (CoRunnerSensitiveNoArrivalCurveValues) {
        return time;
      }

      // serve the request from the cache
      if (maxAccessCyclesPerCache.count(time) > 0) {
        return maxAccessCyclesPerCache[time];
      }

      // obtain the value
      cpp_int value;
      if (time == infinity) {
        value = infinity;
      } else {
        value = maxAccessCyclesPerInner(time);
      }

      // store the value in the cache
      maxAccessCyclesPerCache[time] = value;

      return value;
    };
  }

  std::function<void()> outputOwnWcetBound = [&]() {
    outs() << "WCET bound of this core: " << intToStr(wcetBound) << "\n";
  };

  std::function<void(std::list<cpp_int> &, std::string & inString)>
      readListFromString =
          [&](std::list<cpp_int> &list, std::string &inString) {
            // split line at all ;
            size_t pos;
            do {
              // try to find ; in the remainder
              pos = inString.find(";");

              // if it is not contained the remainder is the last item
              if (pos == std::string::npos) {
                cpp_int item(inString);
                list.push_back(item);
              }

              // if it is contained, cut off an item in front of it
              else {
                cpp_int item(inString.substr(0, pos));
                list.push_back(item);
                inString.erase(0, pos + 1);
              }
            } while (pos != std::string::npos);
          };

  std::function<void(std::list<cpp_int> &)> readListFromCin =
      [&](std::list<cpp_int> &list) {
        // read in a line from cin
        std::string inString;
        std::getline(std::cin, inString);

        readListFromString(list, inString);
      };

  if (ConcAccCycBounds.length() != 0) {
    std::string temp(ConcAccCycBounds);
    readListFromString(staticAccessCycleBounds, temp);
    // TODO check that the bounds do not increase for any core at any point.
  }

  std::function<void(std::list<cpp_int> &)> inputConcurrentWcetBounds =
      [&](std::list<cpp_int> &concurrentWcetBounds) {
        outs() << "WCET bounds of concurrent cores:\n";
        readListFromCin(concurrentWcetBounds);
      };

  std::function<void(std::list<cpp_int> &)> outputAccessCycleBoundsOfThisCore =
      [&](std::list<cpp_int> &accessCycleBounds) {
        outs() << "access cycle bounds of this core: ";
        for (auto it = accessCycleBounds.begin(); it != accessCycleBounds.end();
             ++it) {
          if (it != accessCycleBounds.begin()) {
            outs() << ";";
          }
          outs() << intToStr(*it);
        }
        outs() << "\n";
      };

  std::function<void(std::list<cpp_int> &)> inputAccessCycleBoundsOfConcCores =
      [&](std::list<cpp_int> &accessCycleBounds) {
        outs() << "access cycle bounds of concurrent cores:\n";
        readListFromCin(accessCycleBounds);
      };

  std::function<bool()> outputHasOwnWcetBoundChanged = [&]() {
    bool changed =
        (CoRunnerSensitiveAnalysisFixedPointType == FixedPointType::GREATEST &&
         wcetBound < previousWcetBound) ||
        (CoRunnerSensitiveAnalysisFixedPointType == FixedPointType::LEAST &&
         wcetBound > previousWcetBound);
    outs() << "has own WCET bound changed: " << (changed ? 1 : 0) << "\n";
    return changed;
  };

  // TODO the communication operations of the following two
  // functions should be factored out to further helper
  // that only care about the input and output just as
  // the previous one.

  std::function<bool()> anyWcetBoundChanged = [&]() {
    // special treatment for non-interactive mode
    if (ConcAccCycBounds.length() != 0) {
      if (staticAccessCycleBounds.size() >= NumConcurrentCores) {
        return true;
      } else {
        assert(staticAccessCycleBounds.size() == 0 &&
               "Number of elements must by a multiple of NumConcurrentCores.");
        return false;
      }
    }

    // write out if the own WCET bound changed
    bool changed = outputHasOwnWcetBoundChanged();

    // use a shortcut
    if (changed) {
      return true;
    }

    // ask if a bound of a concurrent core changed
    std::list<cpp_int> temp;
    outs() << "has a WCET bound of a concurrent core changed:\n";
    readListFromCin(temp);
    assert(temp.size() == 1 && "Expected 0 or 1 as input.");
    if (*temp.begin() == 0) {
      return false;
    }
    if (*temp.begin() == 1) {
      return true;
    }
    assert(false && "Expected 0 or 1 as input.");
  };

  std::function<void()> calcAndExchangeAccessCycleBounds = [&]() {
    // special handling for the non-interactive mode
    if (ConcAccCycBounds.length() != 0) {
      accessCycleBounds.clear();

      assert(staticAccessCycleBounds.size() >= NumConcurrentCores &&
             "Not enough elements remaining.");
      auto begin = staticAccessCycleBounds.begin();
      auto end = staticAccessCycleBounds.begin();
      std::advance(end, (unsigned)NumConcurrentCores);
      accessCycleBounds.insert(accessCycleBounds.begin(), begin, end);
      assert(accessCycleBounds.size() == NumConcurrentCores &&
             "Wrong number of elements inserted.");
      staticAccessCycleBounds.erase(begin, end);
      return;
    }

    // send the WCET to the analyses for the concurrent cores
    outputOwnWcetBound();

    // read in the WCET bounds of the programs
    // on the concurrent cores
    std::list<cpp_int> concurrentWcetBounds;
    inputConcurrentWcetBounds(concurrentWcetBounds);
    assert(concurrentWcetBounds.size() == NumConcurrentCores &&
           "There needs to be one WCET bound per concurrent core.");

    // calculate the access cycle bounds
    // for this core and the WCET bounds
    // of the concurrent cores
    accessCycleBounds.clear();
    for (auto concWcetBound : concurrentWcetBounds) {
      accessCycleBounds.push_back(maxAccessCyclesPer(concWcetBound));
    }

    // output the access cycle bounds
    outputAccessCycleBoundsOfThisCore(accessCycleBounds);

    // read in the access cycle bounds for the
    // concurrent cores
    accessCycleBounds.clear();
    inputAccessCycleBoundsOfConcCores(accessCycleBounds);

    // TODO alternatively read in the access cycle bounds
    // for the concurrent cores from a command line parameter.
    // This case is only intended for regression test and so
    // on. In this case, we do not need any of the communication.
  };

  std::function<void()> calcBlockingBound = [&]() {
    // MJa: TODO: the following is still round-robin-
    // specific. it needs to be generalized in order
    // to also support other work-conserving bus
    // arbitration schemes.

    // calculate the maximum amount of blocking
    // cycles per concurrent core
    cpp_int maxBlockingPerCore = accessBound * UBbusCyclesPerAccess;

    // and there is the max amount of overall blocking
    // which is implicitly already assumed by the
    // microarchitectural analysis
    cpp_int maxOverallBlocking =
        maxBlockingPerCore * (unsigned)NumConcurrentCores;

    // make sure we got the correct number of access cycle bounds
    assert(accessCycleBounds.size() == NumConcurrentCores &&
           "There needs to be one access cycle bound per concurrent core.");

    // sum up individual blocking bounds per concurrent core.
    // this should now be robust enough to also input arrival
    // curve values of infinity (-1) from the other cores in
    // case we are not interested in improving the wcet bound
    // of the program considered in the current analysis
    // instance...
    cpp_int newBlockingBound(0);
    cpp_int newConcAccessesBound(0);
    for (auto accessCycleBound : accessCycleBounds) {
      const cpp_int blockingContribution =
          (accessCycleBound != infinity &&
           accessCycleBound < maxBlockingPerCore)
              ? accessCycleBound
              : maxBlockingPerCore;
      newBlockingBound += blockingContribution;
      cpp_int concAccessesContribution =
          blockingContribution / UBbusCyclesPerAccess;
      if (blockingContribution % UBbusCyclesPerAccess >= 1) {
        ++concAccessesContribution;
      }
      newConcAccessesBound += concAccessesContribution;
    }

    // there is only sense in recalculation
    // the bounds of this core if the new
    // blocking bound (that is used as a constraint
    // in the recalculation) changed compared to
    // the previous iteration.
    if (CoRunnerSensitiveAnalysisFixedPointType == FixedPointType::GREATEST) {
      recalculateWcetBound =
          (blockingBound == infinity && newBlockingBound != infinity) ||
          newBlockingBound < blockingBound;
    }
    // for the iteration towards least fixed point, there is only sense in
    // the recalculation if the new blocking increased
    else {
      recalculateWcetBound =
          (blockingBound != infinity && newBlockingBound == infinity) ||
          newBlockingBound > blockingBound;
      // MJa: TODO: in the future, there might
      // be the case that the WCET without interference
      // is bounded but we cannot bound the interference.
      // E.g. for prio-based arbitration.
      // The greatest fixed point is anyway useless in
      // these situations as we start with a WCET of
      // infinity as we cannot bound interference without
      // knowledge about the co-runners.
      // The least fixed point might help as we start from
      // an optimistic assumption. However, we might have to
      // consider an upper bound to the deadline under
      // all possible scheduling scenarios in order to
      // guarantee termination of the iteration at some point.
    }

    if (CoRunnerSensitiveAnalysisFixedPointType == FixedPointType::GREATEST) {
      // optimization:
      // if the new blocking bound is greater than
      // or equal to the current WCET bound,
      // even an improved new blocking bound
      // guaranteed to not lead to better results
      // in the implicit path enumeration.
      recalculateWcetBound &= newBlockingBound < wcetBound;
      // similar optimization:
      // there is even more potential for this optimization
      // to be effective as soon as we are looking at an
      // architecture for which it might pay off to recalculate
      // the access bound also in each iteration
      recalculateWcetBound &= newBlockingBound < maxOverallBlocking;
    }

    // use new blocking bound from now on
    blockingBound = newBlockingBound;
    concAccessesBound = newConcAccessesBound;
  };

  std::function<void()> calcBlockingConstr = [&]() {
    assert(blockingBound != infinity || concAccessesBound != infinity);

    if (recalculateWcetBound) {
      // take the normal flow constraints as a starting point
      flowAndBlockingConstr = flowConstr;

      // add the blocking constraint if there is a blocking bound
      if (blockingBound != infinity) {
        GraphConstraint blockingConstr = std::make_tuple(
            lbBlockingTimesTakenVector, ConstraintType::LessEqual,
            intToDouble(blockingBound, true));
        flowAndBlockingConstr.push_back(blockingConstr);
      }

      // add a constraint if there is a concurrent accesses bound
      if (concAccessesBound != infinity) {
        if (!lbConcAccesses_edgeTimesTakenVector) {
          lbConcAccesses_edgeTimesTakenVector_init();
        }
        GraphConstraint concAccessesConstr = std::make_tuple(
            *lbConcAccesses_edgeTimesTakenVector, ConstraintType::LessEqual,
            intToDouble(concAccessesBound, true));

        flowAndBlockingConstr.push_back(concAccessesConstr);
      }
    }
  };

  std::function<void()> calcAccessBound = [&]() {
    // we will likely not profit from the blocking
    // constraint here...
    auto pathAnaRes = doPathAnalysis(
        "NumAccesses", ExtremumType::Maximum,
        ubAccessesProvider.getEdgeWeightTimesTakenVector(), flowConstr);
    accessBound = pathAnaRes ? optDoubleToInt(pathAnaRes.get().ub,
                                              true /*in doubt, round up*/)
                             : infinity;
  };

  std::function<void()> calcWcetBound = [&]() {
    // skip WCET bound calculation
    if (CoRunnerSensitiveNoWcetBound) {
      wcetBound = infinity;
      return;
    }

    // add the blocking constraint only if there is a finite blocking bound
    auto &constraints =
        (blockingBound != infinity || concAccessesBound != infinity
             ? flowAndBlockingConstr
             : flowConstr);

    // calculate upper bound on the execution time
    auto pathAnaRes = doPathAnalysis("Time", ExtremumType::Maximum,
                                     ubTimeTimesTakenVector, constraints);
    wcetBound = pathAnaRes ? optDoubleToInt(pathAnaRes.get().ub,
                                            true /*in doubt, round up*/)
                           : infinity;
  };

  /* ==============================================
   * Iterative algorithm phase
   * ==============================================
   */

  if (SelectedArrivalCurveCalculationMethod ==
          ArrivalCurveCalculationMethod::PROGRAM_GRANULARITY ||
      !CoRunnerSensitiveNoWcetBound) {
    // upper bound on the number of bus accesses in any program run
    calcAccessBound();
  }

  if (!CoRunnerSensitiveNoWcetBound) {
    if (DumpInterferenceResponseCurve.getBits()) {

      if (CoRunnerSensitiveDumpedBlockedCyclesScaledToAccesses) {
        // MJa: TODO: the following is still round-robin-
        // specific. it needs to be generalized in order
        // to also support other work-conserving bus
        // arbitration schemes.

        // calculate the maximum amount of interfering
        // accesses per concurrent core
        cpp_int maxInterferingAccessesPerCore = accessBound;

        // and there is the max amount of overall
        // interfering accesses
        cpp_int maxOverallInterferingAccesses =
            maxInterferingAccessesPerCore * (unsigned)NumConcurrentCores;

        // enrich the flow constraints
        auto combinedConstraints = flowConstr;
        const auto &interferingAccessesVar =
            Variable::getGlobalVar(Variable::Type::maxBusInterference);

        // constraint number of blocked cycles
        auto curveLbBlockingTimesTakenVector(lbBlockingTimesTakenVector);
        double memLat = intToDouble(UBbusCyclesPerAccess, true);
        curveLbBlockingTimesTakenVector.push_back(
            std::make_pair(interferingAccessesVar, -memLat));
        GraphConstraint curveBlockingConstr = std::make_tuple(
            curveLbBlockingTimesTakenVector, ConstraintType::LessEqual, 0.0);
        combinedConstraints.push_back(curveBlockingConstr);

        // constraint number of concurrent accesses
        if (!lbConcAccesses_edgeTimesTakenVector) {
          lbConcAccesses_edgeTimesTakenVector_init();
        }
        auto curveLbConcAccessesTimesTakenVector(
            *lbConcAccesses_edgeTimesTakenVector);
        curveLbConcAccessesTimesTakenVector.push_back(
            std::make_pair(interferingAccessesVar, -1.0));
        GraphConstraint curveConcAccessesConstr =
            std::make_tuple(curveLbConcAccessesTimesTakenVector,
                            ConstraintType::LessEqual, 0.0);
        combinedConstraints.push_back(curveConcAccessesConstr);

        dumpInterferenceResponseCurve(
            maxOverallInterferingAccesses, 100, combinedConstraints,
            ubTimeTimesTakenVector, interferingAccessesVar,
            "BusBlockingAccesses", 1 /* Full curve, no zoom */);
      } else {
        // MJa: TODO: the following is still round-robin-
        // specific. it needs to be generalized in order
        // to also support other work-conserving bus
        // arbitration schemes.

        // calculate the maximum amount of blocking
        // cycles per concurrent core
        cpp_int maxBlockingPerCore = accessBound * UBbusCyclesPerAccess;

        // and there is the max amount of overall blocking
        // which is implicitly already assumed by the
        // microarchitectural analysis
        cpp_int maxOverallBlocking =
            maxBlockingPerCore * (unsigned)NumConcurrentCores;

        // enrich the flow constraints
        auto combinedConstraints = flowConstr;
        const auto &blockedCyclesVar =
            Variable::getGlobalVar(Variable::Type::maxBusInterference);

        // constraint number of blocked cycles
        auto curveLbBlockingTimesTakenVector(lbBlockingTimesTakenVector);
        curveLbBlockingTimesTakenVector.push_back(
            std::make_pair(blockedCyclesVar, -1.0));
        GraphConstraint curveBlockingConstr = std::make_tuple(
            curveLbBlockingTimesTakenVector, ConstraintType::LessEqual, 0.0);
        combinedConstraints.push_back(curveBlockingConstr);

        // constraint number of concurrent accesses
        if (!lbConcAccesses_edgeTimesTakenVector) {
          lbConcAccesses_edgeTimesTakenVector_init();
        }
        auto curveLbConcAccessesTimesTakenVector(
            *lbConcAccesses_edgeTimesTakenVector);
        double memLatInvDown = 1.0 / intToDouble(UBbusCyclesPerAccess, true);
        double memLatInvUp = 1.0 / intToDouble(UBbusCyclesPerAccess, false);
        curveLbConcAccessesTimesTakenVector.push_back(
            std::make_pair(blockedCyclesVar, -memLatInvUp));
        GraphConstraint curveConcAccessesConstr =
            std::make_tuple(curveLbConcAccessesTimesTakenVector,
                            ConstraintType::LessEqual, 1.0 - memLatInvDown);
        combinedConstraints.push_back(curveConcAccessesConstr);

        dumpInterferenceResponseCurve(
            maxOverallBlocking, 100, combinedConstraints,
            ubTimeTimesTakenVector, blockedCyclesVar, "BusBlockingCycles",
            1 /* Full curve, no zoom */);
      }
    }
  }

  // upper bound on the execution time in any program run
  if (CoRunnerSensitiveAnalysisFixedPointType == FixedPointType::LEAST) {
    calcBlockingConstr();
  }
  calcWcetBound();

  // we finished iteration 0 before the loop
  // is entered for the first actual iteration
  if (numAdditionalIterations <= UntilIterationMeasurement) {
    std::string measurementId = "Until Iteration ";
    measurementId += std::to_string(numAdditionalIterations);
    stats.stopMeasurement(measurementId);
  }
  ++numAdditionalIterations;

  // take care of a relative period.
  // this should not be accounted for "iteration 0",
  // as its results are only needed within the loop.
  if (ProgramPeriodRel.getNumOccurrences() > 0) {
    // relative period value
    double rel = ProgramPeriodRel;

    // it depends on the iteration direction
    // which of the absolute values that the
    // relative value is processed with are
    // already available and which ones need
    // to be recalculated
    cpp_int coRunInsensWcetBound(0);
    cpp_int wcetBoundIgnoringInterference(0);
    if (CoRunnerSensitiveAnalysisFixedPointType == FixedPointType::GREATEST) {
      coRunInsensWcetBound = wcetBound;
      if (rel < 1.0 || ProgramPeriodRelEvalWrtWcetIgnoringInterference) {
        // have to calculate bound ignoring interference

        // backup normal iteration values
        cpp_int backupWcetBound = wcetBound;
        cpp_int backupBlockingBound = blockingBound;
        cpp_int backupConcAccessesBound = concAccessesBound;
        bool backupRecalculateWcetBound = recalculateWcetBound;

        // perform recalculation assuming no interference
        blockingBound = 0;
        concAccessesBound = 0;
        recalculateWcetBound = true;
        calcBlockingConstr();
        calcWcetBound();
        wcetBoundIgnoringInterference = wcetBound;

        // restore normal iteration state
        wcetBound = backupWcetBound;
        blockingBound = backupBlockingBound;
        concAccessesBound = backupConcAccessesBound;
        recalculateWcetBound = backupRecalculateWcetBound;
      }
    } else {
      wcetBoundIgnoringInterference = wcetBound;
      if (!ProgramPeriodRelEvalWrtWcetIgnoringInterference) {
        // have to calculate co-runner-insensitive wcet bound

        // backup normal iteration values
        cpp_int backupWcetBound = wcetBound;
        cpp_int backupBlockingBound = blockingBound;
        cpp_int backupConcAccessesBound = concAccessesBound;
        bool backupRecalculateWcetBound = recalculateWcetBound;

        // perform recalculation assuming arbitrary co-runners
        blockingBound = infinity;
        concAccessesBound = infinity;
        recalculateWcetBound = true;
        calcWcetBound();
        coRunInsensWcetBound = wcetBound;

        // restore normal iteration state
        wcetBound = backupWcetBound;
        blockingBound = backupBlockingBound;
        concAccessesBound = backupConcAccessesBound;
        recalculateWcetBound = backupRecalculateWcetBound;
      }
    }

    // calculate the effective absolute period
    if (ProgramPeriodRelEvalWrtWcetIgnoringInterference) {
      assert(wcetBoundIgnoringInterference != infinity &&
             "relative periods are not supported for programs with unbounded "
             "execution time");
      double ratVal =
          rel * static_cast<unsigned>(wcetBoundIgnoringInterference);
      if (ratVal < 0.0) {
        ratVal = 0.0;
      }
      effectivePeriod = static_cast<cpp_int>(ratVal);
    } else {
      assert(coRunInsensWcetBound != infinity &&
             "relative periods are not supported for programs with unbounded "
             "execution time");
      cpp_int absoluteBase(coRunInsensWcetBound);
      if (rel < 1.0) {
        absoluteBase -= wcetBoundIgnoringInterference;
      }
      double ratVal = rel * static_cast<unsigned>(absoluteBase);
      if (rel < 1.0) {
        ratVal += static_cast<unsigned>(wcetBoundIgnoringInterference);
      }
      if (ratVal < 0.0) {
        ratVal = 0.0;
      }
      effectivePeriod = static_cast<cpp_int>(ratVal);
    }

    // write out the effective absolute period
    outs() << "the relative period " << rel
           << " was evaluated to the absolute period "
           << static_cast<unsigned>(effectivePeriod) << "\n";
  }

  if (effectivePeriod < bcetBound) {
    outs() << "The specified absolute period "
           << static_cast<unsigned>(effectivePeriod)
           << " is smaller than the BCET bound "
           << static_cast<unsigned>(bcetBound) << ". "
           << "Thus we use the BCET bound as absolute period for better "
              "precision..."
           << "\n";
    effectivePeriod = bcetBound;
  }

  if (CompositionalBaseBound.getBits()) {
    if (wcetBound != infinity) {
      // Add the constraints that "sum lbblocking edges <= interference_var"
      const auto &maxBusInterference =
          Variable::getGlobalVar(Variable::Type::maxBusInterference);
      auto complbBlockingTimesTakenVector(lbBlockingTimesTakenVector);
      complbBlockingTimesTakenVector.push_back(
          std::make_pair(maxBusInterference, -1.0));
      GraphConstraint compblockingConstr = std::make_tuple(
          complbBlockingTimesTakenVector, ConstraintType::LessEqual, 0.0);

      calculateCompositionalBaseBound(flowConstr, compblockingConstr,
                                      ubTimeTimesTakenVector,
                                      maxBusInterference, 1.0);
    }

    // We are finished
    return boost::none;
  }

  if (CalculateSlopeInterferenceCurve.getBits()) {
    if (wcetBound != infinity) {
      auto combinedConstraints = flowConstr;
      const auto &interferenceVar =
          Variable::getGlobalVar(Variable::Type::maxBusInterference);

      // constraint number of blocked cycles
      auto slopeLbBlockingTimesTakenVector(lbBlockingTimesTakenVector);
      double memLat = intToDouble(UBbusCyclesPerAccess, true);
      slopeLbBlockingTimesTakenVector.push_back(
          std::make_pair(interferenceVar, -memLat));
      GraphConstraint slopeBlockingConstr = std::make_tuple(
          slopeLbBlockingTimesTakenVector, ConstraintType::LessEqual, 0.0);
      combinedConstraints.push_back(slopeBlockingConstr);

      // constraint number of concurrent accesses
      if (!lbConcAccesses_edgeTimesTakenVector) {
        lbConcAccesses_edgeTimesTakenVector_init();
      }
      auto slopeLbConcAccessesTimesTakenVector(
          *lbConcAccesses_edgeTimesTakenVector);
      slopeLbConcAccessesTimesTakenVector.push_back(
          std::make_pair(interferenceVar, -1.0));
      GraphConstraint slopeConcAccessesConstr = std::make_tuple(
          slopeLbConcAccessesTimesTakenVector, ConstraintType::LessEqual, 0.0);
      combinedConstraints.push_back(slopeConcAccessesConstr);

      calculateSoundSlope(0.1 * memLat, 10 * memLat, combinedConstraints,
                          ubTimeTimesTakenVector, interferenceVar,
                          intToDouble(wcetBound, true));
    }

    // We are finished
    return boost::none;
  }

  // now do the iteration loop
  do {
    // status output
    outs() << "Additional iteration #" << numAdditionalIterations << "\n";

    // calculate access cycle bounds for this core based
    // on the WCET bounds of the concurrent cores.
    calcAndExchangeAccessCycleBounds();

    if (wcetBound != infinity) {
      // calculate a blocking bound for this core based on
      // the access cycle bounds of the concurrent cores.
      calcBlockingBound();
    } else {
      // In our setting, an infinite WCET is never
      // caused by unbounded blocking per access
      // (the blocking per access is already bounded
      // in the results of the microarchitectural
      // analysis). An infinite WCET is most of the
      // time caused by missing loop bounds or
      // non-sufficient annotation of external
      // information. This would not get better in
      // any way by blocking bound and the WCET
      // bound would stay infinite. Thus, we do not
      // recalculate the WCET bound at all in this
      // and therefore also do not need a blocking
      // bound.
      // A further aspect is that the access cycle
      // bounds calculated by the concurrent cores
      // for an infinite interval length would in
      // almost all cases also be infinite.
      recalculateWcetBound = false;
    }

    // status output
    outs() << "blockingBound: " << intToStr(blockingBound) << "\n";

    previousWcetBound = wcetBound;

    if (recalculateWcetBound) {
      // calculate the blocking constraint from the blocking bound
      calcBlockingConstr();

      // rerun the path analysis for a wcet bound
      calcWcetBound();

      if ((CoRunnerSensitiveAnalysisFixedPointType ==
               FixedPointType::GREATEST &&
           wcetBound > previousWcetBound) ||
          (CoRunnerSensitiveAnalysisFixedPointType == FixedPointType::LEAST &&
           wcetBound < previousWcetBound)) {
        // Conceptually, we have monotonicity here.
        // We do not yet fully understand why an added or
        // more tight constraint can lead to a higher value
        // for the objective function.
        // Maybe there goes something wrong, if we have to
        // deal with really large number in the ILP?
        // If that is the case, then the obtained solution
        // is anyway far from being sound.
        // For now we just warn and assume that the old
        // value was already sound...
        outs() << "Warning: the WCET bound should not be able to increase.\n";
        outs() << "old WCET bound: " << intToStr(previousWcetBound) << "\n";
        outs() << "new WCET bound: " << intToStr(wcetBound) << "\n";
        wcetBound = previousWcetBound;
      }
      if (CoRunnerSensitiveAnalysisFixedPointType == FixedPointType::GREATEST) {
        assert(wcetBound <= previousWcetBound &&
               "Iterative approach should be monotone!");
      } else {
        assert(wcetBound >= previousWcetBound &&
               "Iterative approach should be monotone!");
      }
    }

    // stop measurement and update iteration counter
    if (numAdditionalIterations <= UntilIterationMeasurement) {
      std::string measurementId = "Until Iteration ";
      measurementId += std::to_string(numAdditionalIterations);
      stats.stopMeasurement(measurementId);
    }
    ++numAdditionalIterations;
  } while (anyWcetBoundChanged());

  // stop remaining measurements
  while (numAdditionalIterations <= UntilIterationMeasurement) {
    std::string measurementId = "Until Iteration ";
    measurementId += std::to_string(numAdditionalIterations);
    stats.stopMeasurement(measurementId);
    ++numAdditionalIterations;
  }

  if (wcetBound != infinity) {
    return BoundItv{static_cast<double>(wcetBound),
                    static_cast<double>(wcetBound)};
  } else {
    return boost::none;
  }
}

} // namespace TimingAnalysisPass

#endif
