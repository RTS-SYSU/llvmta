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

#ifndef TIMINGPATHANALYSIS_H
#define TIMINGPATHANALYSIS_H

#include "AnalysisFramework/AnalysisResults.h"

#include "PathAnalysis/FlowConstraintProvider.h"
#include "PathAnalysis/InsensitiveGraph.h"
#include "PathAnalysis/StateGraph.h"
#include "PathAnalysis/StateGraphAddressProvider.h"
#include "PathAnalysis/StateGraphCacheMissProvider.h"
#include "PathAnalysis/StateGraphDRAMRefreshProvider.h"
#include "PathAnalysis/StateGraphDirtifyingStoreProvider.h"
#include "PathAnalysis/StateGraphNumericWeightProvider.h"
#include "PathAnalysis/StateGraphPreemptionCacheMissProvider.h"
#include "PathAnalysis/StateGraphWritebackProvider.h"
#include "PathAnalysis/StateSensitiveGraph.h"

#include "LLVMPasses/DispatchMemory.h"
#include "Memory/AbstractCyclingMemory.h"

#include "Util/Options.h"
#include "Util/Statistics.h"
#include "Util/TplTools.h"
#include "Util/Util.h"

#include <fstream>
#include <iostream>
#include <list>

namespace TimingAnalysisPass {

/**
 * Create cache related weight providers for the given stategraph
 */
template <class MuState>
void createCacheRelatedWeightProvider(
    MuStateGraph<MuState> *sg, TplGeneral,
    StateGraphNumericWeightProvider<MuState> *&sgnicmp,
    StateGraphNumericWeightProvider<MuState> *&sgndcmp,
    StateGraphNumericWeightProvider<MuState> *&sgnsbap,
    StateGraphCacheMissProvider<MuState, CacheType::DATA> *&sgdcpers,
    StateGraphCacheMissProvider<MuState, CacheType::INSTRUCTION> *&sgicpers,
    StateGraphDirtifyingStoreProvider<MuState> *&sgdfs,
    StateGraphWritebackProvider<MuState> *&sgwbp,
    StateGraphPreemptionCacheMissProvider<MuState, CacheType::INSTRUCTION> *
        &sgicmpreemption,
    StateGraphPreemptionCacheMissProvider<MuState, CacheType::DATA> *
        &sgdcmpreemption) {}

// TODO pass as argument tpa to not pass all of the cache providers
template <
    class MuState,
    TplSwitch<decltype(MuState::LocalMetrics::memoryTopology.instrCache)> = 0,
    TplSwitch<decltype(MuState::LocalMetrics::memoryTopology.dataCache)> = 0>
void createCacheRelatedWeightProvider(
    MuStateGraph<MuState> *sg, TplSpecial,
    StateGraphNumericWeightProvider<MuState> *&sgnicmp,
    StateGraphNumericWeightProvider<MuState> *&sgndcmp,
    StateGraphNumericWeightProvider<MuState> *&sgnsbap,
    StateGraphCacheMissProvider<MuState, CacheType::DATA> *&sgdcpers,
    StateGraphCacheMissProvider<MuState, CacheType::INSTRUCTION> *&sgicpers,
    StateGraphDirtifyingStoreProvider<MuState> *&sgdfs,
    StateGraphWritebackProvider<MuState> *&sgwbp,
    StateGraphPreemptionCacheMissProvider<MuState, CacheType::INSTRUCTION> *
        &sgicmpreemption,
    StateGraphPreemptionCacheMissProvider<MuState, CacheType::DATA> *
        &sgdcmpreemption) {
  typedef typename MuState::LocalMetrics LocalMetrics;

  sgnicmp = new StateGraphNumericWeightProvider<MuState>(
      sg, [](const LocalMetrics &lm) { return lm.memoryTopology.instrMisses; },
      "UB I$ Misses");

  sgndcmp = new StateGraphNumericWeightProvider<MuState>(
      sg, [](const LocalMetrics &lm) { return lm.memoryTopology.dataMisses; },
      "UB D$ Misses");

  sgnsbap = new StateGraphNumericWeightProvider<MuState>(
      sg, [](const LocalMetrics &lm) { return lm.memoryTopology.storesToBus; },
      "UB Stores To Bus");

  auto getDCache = [](const LocalMetrics &lm) {
    return lm.memoryTopology.dataCache;
  };
  auto getJustDMissed = [](const LocalMetrics &lm) {
    return lm.memoryTopology.justMissedDataCache;
  };
  auto getICache = [](const LocalMetrics &lm) {
    return lm.memoryTopology.instrCache;
  };
  auto getJustIMissed = [](const LocalMetrics &lm) {
    return lm.memoryTopology.justMissedInstrCache;
  };
  auto getJustEntered = [](const LocalMetrics &lm) {
    return lm.memoryTopology.justEntered;
  };

  if (DataCachePersType != PersistenceType::NONE) {
    sgdcpers = new StateGraphCacheMissProvider<MuState, CacheType::DATA>(
        sg, getDCache, getJustDMissed, getJustEntered);
  }
  if (InstrCachePersType != PersistenceType::NONE) {
    sgicpers = new StateGraphCacheMissProvider<MuState, CacheType::INSTRUCTION>(
        sg, getICache, getJustIMissed, getJustEntered);
  }

  if (DataCacheWriteBack) {
    auto getJustDirtifiedLine = [](const LocalMetrics &lm) {
      return lm.memoryTopology.justDirtifiedLine;
    };
    auto getJustWroteBack = [](const LocalMetrics &lm) {
      return lm.memoryTopology.justWroteBackLine;
    };
    sgdfs = new StateGraphDirtifyingStoreProvider<MuState>(
        sg, getDCache, getJustDirtifiedLine);
    sgwbp = new StateGraphWritebackProvider<MuState>(sg, getJustWroteBack);
  }

  if (PreemptiveExecution) {
    sgicmpreemption = new StateGraphPreemptionCacheMissProvider<
        MuState, CacheType::INSTRUCTION>(sg, getICache, getJustIMissed);
    sgdcmpreemption =
        new StateGraphPreemptionCacheMissProvider<MuState, CacheType::DATA>(
            sg, getDCache, getJustDMissed);
  }
}

template <class MuState> class TimingPathAnalysis {
public:
  TimingPathAnalysis(MuStateGraph<MuState> *sg)
      : sg(sg), sgtp(nullptr), sgnicmp(nullptr), sgndcmp(nullptr),
        sgnsbap(nullptr), sgdcpers(nullptr), sgicpers(nullptr),
        sgicmpreemption(nullptr), sgdcmpreemption(nullptr), sgdfs(nullptr),
        sgwbp(nullptr), sgdramrefreshes(nullptr), ubAccessesProvider(nullptr) {}

  ~TimingPathAnalysis() {
    // Free stuff
    delete sgtp;
    delete sgnicmp;
    delete sgndcmp;
    delete sgnsbap;
    delete sgdcpers;
    delete sgicpers;
    delete sgicmpreemption;
    delete sgdcmpreemption;
    delete sgdfs;
    delete sgwbp;
    delete sgdramrefreshes;
    delete ubAccessesProvider;
  }

  void registerWeightProvider();

  void getBasicConstraints(std::list<GraphConstraint> &constraints);

  void
  addAvailableInterferenceConstraints(std::list<GraphConstraint> &constraints);

  void setInterferenceToZero(std::list<GraphConstraint> &constraints);

private:
  void getWritebackConstraints(std::list<GraphConstraint> &constraints);
  MuStateGraph<MuState> *sg;

public:
  /**
   * Upper Bound Time Provider
   */
  StateGraphNumericWeightProvider<MuState, int> *sgtp;
  /**
   * Cache-related weight provider
   */
  StateGraphNumericWeightProvider<MuState> *sgnicmp;
  StateGraphNumericWeightProvider<MuState> *sgndcmp;
  StateGraphNumericWeightProvider<MuState> *sgnsbap;
  StateGraphCacheMissProvider<MuState, CacheType::DATA> *sgdcpers;
  StateGraphCacheMissProvider<MuState, CacheType::INSTRUCTION> *sgicpers;
  StateGraphPreemptionCacheMissProvider<MuState, CacheType::INSTRUCTION>
      *sgicmpreemption;
  StateGraphPreemptionCacheMissProvider<MuState, CacheType::DATA>
      *sgdcmpreemption;
  /**
   * Data cache write-back related
   */
  StateGraphDirtifyingStoreProvider<MuState> *sgdfs;
  StateGraphWritebackProvider<MuState> *sgwbp;
  /**
   * DRAM refresh
   */
  StateGraphDRAMRefreshProvider<MuState> *sgdramrefreshes;
  /**
   * Upper Bound on number of accesses to bus
   */
  StateGraphNumericWeightProvider<MuState> *ubAccessesProvider;
};

template <class MuState>
void TimingPathAnalysis<MuState>::registerWeightProvider() {
  // prepare the UB time provider
  std::function<int(const typename MuState::LocalMetrics &)> ubTimeExtractor;

  if (MuArchType == MicroArchitecturalType::FIXEDLATENCY) {
    // Fixed latency state does not know any memory
    ubTimeExtractor = [](const typename MuState::LocalMetrics &metrics) {
      return metrics.time.getUb();
    };
  } else if (CoRunnerSensitive) {
    // in co-runner-sensitive analysis, ignore the fast-forwarded blocking
    ubTimeExtractor = [](const typename MuState::LocalMetrics &metrics) {
      auto bgMem = bgMemMetr(metrics);
      return metrics.time.getUb() + getFastForwardedAccessCycles(bgMem).getUb();
    };
  } else {
    // in co-runner-insensitive analysis, account for it
    ubTimeExtractor = [](const typename MuState::LocalMetrics &metrics) {
      auto bgMem = bgMemMetr(metrics);
      return metrics.time.getUb() +
             getFastForwardedAccessCycles(bgMem).getUb() +
             getFastForwardedBlocking(bgMem).getUb();
    };
  }

  if (CompositionalBaseBound.isSet(InterferenceSource::DRAMREFRESH)) {
    sgtp = new StateGraphCompBaseTimeWeightProvider<MuState>(
        sg, ubTimeExtractor, "UB Time");
  } else {
    sgtp = new StateGraphNumericWeightProvider<MuState, int>(
        sg, ubTimeExtractor, "UB Time");
  }

  // Cache-related weight provider have to be filled outside due to template
  // magic
  createCacheRelatedWeightProvider(sg, TplSpecial(), sgnicmp, sgndcmp, sgnsbap,
                                   sgdcpers, sgicpers, sgdfs, sgwbp,
                                   sgicmpreemption, sgdcmpreemption);

  // DRAM Refreshes
  if (BackgroundMemoryType == BgMemType::SIMPLEDRAM &&
      !(CompAnaType.isSet(CompositionalAnalysisType::DRAMREFRESH) ||
        CompositionalBaseBound.isSet(InterferenceSource::DRAMREFRESH))) {
    sgdramrefreshes = new StateGraphDRAMRefreshProvider<MuState>(sg);
  }

  // Provider of upper bound over number of accesses (only needed for
  // compositional bus blocking, or sometimes for DRAM)
  if (MetricsOnWCEP.isSet(MetricType::BUSACCESSES) ||
      MetricsToMax.isSet(MetricType::BUSACCESSES) ||
      (SharedBus == SharedBusType::ROUNDROBIN && !CoRunnerSensitive) ||
      (BackgroundMemoryType == BgMemType::SIMPLEDRAM &&
       (DumpInterferenceResponseCurve.isSet(InterferenceSource::DRAMREFRESH) ||
        CompositionalBaseBound.isSet(InterferenceSource::DRAMREFRESH)))) {
    ubAccessesProvider = new StateGraphNumericWeightProvider<MuState>(
        sg,
        [](const typename MuState::LocalMetrics &metrics) {
          return getUbAccesses(bgMemMetr(metrics));
        },
        "UB Accesses");
  }
}

template <class MuState>
void TimingPathAnalysis<MuState>::getWritebackConstraints(
    std::list<GraphConstraint> &constraints) {
  /* first define the writebacks and dirtifyingStores variables based on
   * the edge weights */
  VarCoeffVector wbs = sgwbp->getEdgeWeightTimesTakenVector();
  Variable wbs_var = Variable::getGlobalVar(Variable::Type::writebacks);
  wbs.push_back(std::make_pair(wbs_var, -1.0));
  GraphConstraint wbsConstr = std::make_tuple(wbs, ConstraintType::Equal, 0.0);
  constraints.push_back(wbsConstr);

  VarCoeffVector dfs = sgdfs->getEdgeWeightTimesTakenVector();
  Variable dfs_var = Variable::getGlobalVar(Variable::Type::dirtifyingStores);
  dfs.push_back(std::make_pair(dfs_var, -1.0));
  /* If we assume an initially unknown cache, each line in the cache might
   * counts as another dirtifying store */
  double dfsBias = AssumeCleanCache ? 0 : -(double)Dnsets * Dassoc;
  /* the dirtifyingStores variable may be smaller than the number of
   * dirtifying store edges due to other constraints.*/
  GraphConstraint dfsConstr =
      std::make_tuple(dfs, ConstraintType::GreaterEqual, dfsBias);
  constraints.push_back(dfsConstr);

  /* build dirtifying-store-bound (if WBBoundType is "store" this
   * implicitly becomes a store-bound) */
  if (WBBound != WBBoundType::NONE) {
    VarCoeffVector dfsMinusWBs = {std::make_pair(dfs_var, 1.0),
                                  std::make_pair(wbs_var, -1.0)};
    constraints.push_back(
        std::make_tuple(dfsMinusWBs, ConstraintType::GreaterEqual, 0.0));
  }

  if (DataCachePersType != PersistenceType::NONE && DFSPersistence) {
    auto dfsConstr = sgdfs->getPersistentDFSConstraints();
    constraints.insert(constraints.end(), dfsConstr.begin(), dfsConstr.end());
  }
}
template <class MuState>
void TimingPathAnalysis<MuState>::getBasicConstraints(
    std::list<GraphConstraint> &constraints) {
  // Add flow constraints
  FlowConstraintProvider fcprov(sg);
  fcprov.buildConstraints();
  auto flowConstr = fcprov.getConstraints();
  constraints.insert(constraints.end(), flowConstr.begin(), flowConstr.end());

  // Add persistence constraints for data and instruction cache
  if (sgdcpers) {
    const auto &dataPersConstr = sgdcpers->getPersistenceConstraints();
    constraints.insert(constraints.end(), dataPersConstr.begin(),
                       dataPersConstr.end());
  }
  if (sgicpers) {
    const auto &instrPersConstr = sgicpers->getPersistenceConstraints();
    constraints.insert(constraints.end(), instrPersConstr.begin(),
                       instrPersConstr.end());
  }
}

template <class MuState>
void TimingPathAnalysis<MuState>::addAvailableInterferenceConstraints(
    std::list<GraphConstraint> &constraints) {
  // Do we need the constraint maxTime = sum timestaken * ubtime because
  // constraints relate to maxTime? Currently only the DRAM refresh constraints
  // are doing that
  bool needMaxTimeConstraint = sgdramrefreshes != nullptr;
  if (needMaxTimeConstraint) {
    auto timeobj = sgtp->getEdgeWeightTimesTakenVector();
    timeobj.push_back(
        std::make_pair(Variable::getGlobalVar(Variable::Type::maxTime), -1.0));
    GraphConstraint objconstr =
        std::make_tuple(timeobj, ConstraintType::Equal, 0);
    constraints.push_front(objconstr);
  }

  // DRAM refresh constraints
  if (sgdramrefreshes) {
    // Extract DRAM refresh constraints
    const auto &dramConstr = sgdramrefreshes->getDRAMRefreshConstraints();
    constraints.insert(constraints.end(), dramConstr.begin(), dramConstr.end());
  }

  // If preemptive execution mode, generate constraints for maximal additional
  // cache miss budget
  if (PreemptiveExecution) {
    assert(sgicmpreemption && sgdcmpreemption &&
           "Preemptive execution mode, but additional cache miss providers not "
           "set");
    constraints.push_back(sgicmpreemption->getInterferenceConstraint());
    constraints.push_back(sgdcmpreemption->getInterferenceConstraint());
    VarCoeffVector icintvar;
    icintvar.push_back(std::make_pair(
        Variable::getGlobalVar(Variable::Type::maxAddInstrMissPreemption),
        1.0));
    constraints.push_back(std::make_tuple(icintvar, ConstraintType::LessEqual,
                                          (unsigned)PreemptionICacheBudget));
    VarCoeffVector dcintvar;
    dcintvar.push_back(std::make_pair(
        Variable::getGlobalVar(Variable::Type::maxAddDataMissPreemption), 1.0));
    constraints.push_back(std::make_tuple(dcintvar, ConstraintType::LessEqual,
                                          (unsigned)PreemptionDCacheBudget));
  }

  // Writeback
  if (sgdfs && sgwbp) {
    getWritebackConstraints(constraints);
  }

  // TODO shared bus blocking
}

template <class MuState>
void TimingPathAnalysis<MuState>::setInterferenceToZero(
    std::list<GraphConstraint> &constraints) {
  // DRAM refreshes
  if (sgdramrefreshes) {
    VarCoeffVector noRefreshes;
    noRefreshes.push_back(std::make_pair(
        Variable::getGlobalVar(Variable::Type::maxNumRefreshes), 1.0));
    GraphConstraint noRefreshConstr =
        std::make_tuple(noRefreshes, ConstraintType::Equal, 0);
    constraints.push_back(noRefreshConstr);
  }

  // TODO do it also for preemption cost!! and all the other sources
}

} // namespace TimingAnalysisPass

#endif
