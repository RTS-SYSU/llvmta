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

#include "LLVMPasses/DispatchInOrderPipeline.h"

#include "LLVMPasses/DispatchMemory.h"
#include "LLVMPasses/DispatchMuArchAnalysis.h"
#include "Memory/SeparateCachesMemoryTopology.h"
#include "Memory/SeparateMemoriesTopology.h"
#include "Memory/SingleMemoryTopology.h"
#include "Memory/util/CacheUtils.h"
#include "MicroarchitecturalAnalysis/InOrderPipelineState.h"

namespace TimingAnalysisPass {

double getInstructionCacheMissPenaltyInOrder(double maximisses) {
  assert(CompAnaType.isSet(CompositionalAnalysisType::ICACHE) &&
         "Expected instruction misses to be comp.");

  unsigned bgmemlatency = getCachelineMemoryLatency(CacheType::INSTRUCTION);
  if (BackgroundMemoryType == BgMemType::SIMPLEDRAM &&
      !CompAnaType.isSet(CompositionalAnalysisType::DRAMREFRESH)) {
    bgmemlatency += DRAMRefreshLatency;
  }

  auto maxstorestobus = AnalysisResults::getInstance().getResultUpperBound(
      "IntAna_MaxStoresToBus_StoresToBus");
  assert(maxstorestobus && "Expected this metrics to be bounded");
  // Each store or load could block the bus for a fetch. If loads are
  // compositional as well, then not.
  if (UnblockStores) {
    if (CompAnaType.isSet(CompositionalAnalysisType::DCACHE)) {
      // If d-cache is treated compositionally as well, penalty is direct effect
      // for loads Still, each store can block an instruction fetch up to
      // bgmemlatency many cycles
      return maximisses * bgmemlatency +
             std::min(maximisses, maxstorestobus.get()) * bgmemlatency;
    } else {
      auto maxdmisses = AnalysisResults::getInstance().getResultUpperBound(
          "IntAna_MaxDataMisses_DataMisses");
      assert(maxdmisses && "Expected this metrics to be bounded");
      // If there are less data misses than instruction misses, not all
      // instruction misses can be blocked on bus +3 for instruction cache miss
      // penalty come from negative timing anomaly to hide bus blocking and
      // computation in the I$-hit case If there is a store, the instruction
      // fetch can be blocked for additional bgmemlatency many cycles.
      return maximisses * bgmemlatency +
             std::min(maximisses, maxstorestobus.get()) * bgmemlatency +
             std::min(maxdmisses.get(),
                      std::max(0.0, maximisses - maxstorestobus.get())) *
                 3;
    }
  } else {
    if (CompAnaType.isSet(CompositionalAnalysisType::DCACHE)) {
      return maximisses * bgmemlatency +
             std::min(maximisses, maxstorestobus.get()) * 3;
    } else {
      auto maxdmisses = AnalysisResults::getInstance().getResultUpperBound(
          "IntAna_MaxDataMisses_DataMisses");
      assert(maxdmisses && "Expected this metrics to be bounded");
      return maximisses * bgmemlatency +
             std::min(maximisses, maxstorestobus.get() + maxdmisses.get()) * 3;
    }
  }
}

double getDataCacheMissPenaltyInOrder(double maxdmisses) {
  assert(CompAnaType.isSet(CompositionalAnalysisType::DCACHE) &&
         "Expected data misses to be comp.");

  unsigned bgmemlatency = getCachelineMemoryLatency(CacheType::DATA);
  if (BackgroundMemoryType == BgMemType::SIMPLEDRAM &&
      !CompAnaType.isSet(CompositionalAnalysisType::DRAMREFRESH)) {
    bgmemlatency += DRAMRefreshLatency;
  }

  if (UnblockStores) {
    auto maxstorestobus = AnalysisResults::getInstance().getResultUpperBound(
        "IntAna_MaxStoresToBus_StoresToBus");
    assert(maxstorestobus && "Expected this metrics to be bounded");
    // Each load miss can be blocked by store for latency-1 cycles
    if (CompAnaType.isSet(CompositionalAnalysisType::ICACHE)) {
      return maxdmisses * bgmemlatency +
             std::min(maxstorestobus.get(), maxdmisses) * bgmemlatency;
    } else {
      auto maximisses = AnalysisResults::getInstance().getResultUpperBound(
          "IntAna_MaxInstrMisses_InstrMisses");
      assert(maximisses && "Expected this metrics to be bounded");
      return maxdmisses * bgmemlatency +
             std::min(maxdmisses, maxstorestobus.get()) * bgmemlatency +
             std::min(maximisses.get(),
                      std::max(0.0, maxdmisses - maxstorestobus.get())) *
                 6;
    }
  } else {
    if (CompAnaType.isSet(CompositionalAnalysisType::ICACHE)) {
      // If i-cache is treated compositionally as well, penalty is direct effect
      return maxdmisses * bgmemlatency;
    } else {
      auto maximisses = AnalysisResults::getInstance().getResultUpperBound(
          "IntAna_MaxInstrMisses_InstrMisses");
      assert(maximisses && "Expected this metrics to be bounded");
      // If there are less instruction misses than data misses, not all data
      // misses can be blocked on bus +5 for data cache miss penalty come from
      // negative timing anomaly to hide bus blocking and computation in the
      // D$-hit case
      return maxdmisses * bgmemlatency +
             std::min(maxdmisses, maximisses.get()) * 6;
    }
  }
}

boost::optional<BoundItv>
dispatchInOrderTimingAnalysis(AddressInformation &addressInfo) {
  std::tuple<AddressInformation &> addrInfoTuple(addressInfo);

  configureCyclingMemories();

  switch (MemTopType) {
  case MemoryTopologyType::SINGLEMEM: {
    assert(InstrCachePersType == PersistenceType::NONE &&
           DataCachePersType == PersistenceType::NONE &&
           "Cannot use Persistence analyses here");
    typedef SingleMemoryTopology<makeOptionsBackgroundMem> MemTop;
    return dispatchTimingAnalysisJoin<InOrderPipelineState<MemTop>>(
        addrInfoTuple);
  }
  case MemoryTopologyType::SEPARATECACHES: {
    typedef SingleMemoryTopology<makeOptionsBackgroundMem> BgMem;
    typedef SeparateCachesMemoryTopology<CacheFactory::makeOptionsInstrCache,
                                         CacheFactory::makeOptionsDataCache,
                                         BgMem>
        MemTop;
    auto timebound =
        dispatchTimingAnalysisJoin<InOrderPipelineState<MemTop>>(addrInfoTuple);
    boost::optional<BoundItv> result = timebound;
    AnalysisResults &ar = AnalysisResults::getInstance();
    boost::optional<BoundItv> icachebound = boost::none;
    if (CompAnaType.isSet(CompositionalAnalysisType::ICACHE)) {
      icachebound =
          dispatchInOrderCacheAnalysis(AnalysisType::L1ICACHE, addressInfo);
      ar.registerResult("CompAna_MaxMisses_InstrMisses", icachebound);
      if (result && icachebound) {
        result = BoundItv{
            result.get().ub +
                getInstructionCacheMissPenaltyInOrder(icachebound.get().ub),
            result.get().lb +
                getInstructionCacheMissPenaltyInOrder(icachebound.get().lb)};
      } else {
        result = boost::none;
      }
    }
    boost::optional<BoundItv> dcachebound = boost::none;
    if (CompAnaType.isSet(CompositionalAnalysisType::DCACHE)) {
      dcachebound =
          dispatchInOrderCacheAnalysis(AnalysisType::L1DCACHE, addressInfo);
      ar.registerResult("CompAna_MaxMisses_DataMisses", dcachebound);
      if (result && dcachebound) {
        result =
            BoundItv{result.get().ub +
                         getDataCacheMissPenaltyInOrder(dcachebound.get().ub),
                     result.get().lb +
                         getDataCacheMissPenaltyInOrder(dcachebound.get().lb)};
      } else {
        result = boost::none;
      }
    }
    // If bounded result and DRAM refreshes compositional, add the refresh
    // penalties
    // TODO do this at the end, after the switch. In case blocking is
    // compositional as well, iterating them all together
    if (result && CompAnaType.isSet(CompositionalAnalysisType::DRAMREFRESH)) {
      unsigned refreshInterArrivalTime =
          SDRAMConfig.getRefreshInterArrivalCycles();
      unsigned maxRefreshes = 0;
      unsigned maxRefreshesOld = 0;
      do {
        maxRefreshesOld = maxRefreshes;
        maxRefreshes = std::ceil(result.get().ub / refreshInterArrivalTime);
        result = BoundItv{result.get().ub + (maxRefreshes - maxRefreshesOld) *
                                                DRAMRefreshLatency,
                          result.get().lb + (maxRefreshes - maxRefreshesOld) *
                                                DRAMRefreshLatency};
        // Check for off-by-one to be consistent with the integrated variant
        if (maxRefreshesOld == maxRefreshes) {
          unsigned maxRefreshesPrime = std::ceil(
              (result.get().ub + DRAMRefreshLatency) / refreshInterArrivalTime);
          if (maxRefreshesPrime > maxRefreshes) {
            assert((maxRefreshesPrime - maxRefreshes == 1) &&
                   "It should be at most off-by-one.");
            maxRefreshes = maxRefreshesPrime;
            result = BoundItv{result.get().ub + DRAMRefreshLatency,
                              result.get().lb + DRAMRefreshLatency};
          }
        }
      } while (maxRefreshesOld != maxRefreshes);
    }
    return result;
  }
  case MemoryTopologyType::PRIVINSTRSPMDATASHARED: {
    typedef SeparateMemoriesTopology<makeOptionsPrivInstrMem,
                                     makeOptionsBackgroundMem>
        MemTop;
    return dispatchTimingAnalysisJoin<InOrderPipelineState<MemTop>>(
        addrInfoTuple);
  }
  default:
    errs() << "No known memory topology chosen.\n";
    return boost::none;
  }
}

} // namespace TimingAnalysisPass
