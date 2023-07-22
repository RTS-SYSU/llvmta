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

#include "LLVMPasses/DispatchMemory.h"

#include "Memory/AccessCounterCyclingMemory.h"
#include "Memory/AlwaysCache.h"
#include "Memory/BlockingCounterCyclingMemory.h"
#include "Memory/BlockingCyclingMemory.h"
#include "Memory/BusyCycleCounterCyclingMemory.h"
#include "Memory/CacheTraits.h"
#include "Memory/CompositionalAbstractCache.h"
#include "Memory/ConcAccessCounterWrapper.h"
#include "Memory/ConditionalMustPersistence.h"
#include "Memory/DirtinessAnalysis.h"
#include "Memory/ElementWiseCountingPersistence.h"
#include "Memory/FixedLatencyCyclingMemory.h"
#include "Memory/LruMaxAgeAbstractCache.h"
#include "Memory/LruMaxAgeArrayAwareCache.h"
#include "Memory/LruMinAgeAbstractCache.h"
#include "Memory/MultiScopePersistence.h"
#include "Memory/SetWiseCountingPersistence.h"
#include "Memory/SimpleSDRAMCyclingMemory.h"
#include "Util/Options.h"

namespace TimingAnalysisPass {

using namespace dom::cache;

CacheTraits icacheConf(16, 2, 32, false, false);

CacheTraits dcacheConf(16, 2, 32, false, false);

template <CacheTraits *CacheConfig, typename CacheAna>
inline AbstractCache *makePersistenceCache(PersistenceType persType,
                                           bool assumeEmptyCache) {
  typedef MultiScopePersistence<SetWiseCountingPersistence<CacheConfig>>
      SWPersis;
  typedef MultiScopePersistence<ElementWiseCountingPersistence<CacheConfig>>
      ElePersis;
  typedef MultiScopePersistence<ConditionalMustPersistence<CacheConfig>>
      CMPersis;

  if (persType != PersistenceType::NONE) {
    /* ArrayAnalysis is a prerequisite for any further DS analysis */
    assert(ArrayPersistenceAnalysis == ArrayPersistenceAnaType::NONE ||
           ArrayAnalysis);
  }

  switch (persType) {
  case PersistenceType::NONE:
    return new AbstractCacheImpl<CacheConfig, CacheAna>(assumeEmptyCache);
  case PersistenceType::SETWISE: {
    typedef CompositionalAbstractCache<CacheAna, SWPersis> Analysis;
    return new AbstractCacheImpl<CacheConfig, Analysis>(assumeEmptyCache);
  }
  case PersistenceType::ELEWISE: {
    if (ArrayPersistenceAnalysis == ArrayPersistenceAnaType::SETWISE) {
      typedef CompositionalAbstractCache<
          CacheAna, CompositionalAbstractCache<SWPersis, ElePersis>>
          Analysis;
      return new AbstractCacheImpl<CacheConfig, Analysis>(assumeEmptyCache);
    }
    typedef CompositionalAbstractCache<CacheAna, ElePersis> Analysis;
    return new AbstractCacheImpl<CacheConfig, Analysis>(assumeEmptyCache);
  }
  case PersistenceType::CONDMUST: {
    if (ArrayPersistenceAnalysis == ArrayPersistenceAnaType::SETWISE) {
      typedef CompositionalAbstractCache<
          CacheAna, CompositionalAbstractCache<SWPersis, CMPersis>>
          Analysis;
      return new AbstractCacheImpl<CacheConfig, Analysis>(assumeEmptyCache);
    }
    typedef CompositionalAbstractCache<CacheAna, CMPersis> Analysis;
    return new AbstractCacheImpl<CacheConfig, Analysis>(assumeEmptyCache);
  }
  }
  assert(0 && "UNREACHABLE");
}

template <CacheTraits *CacheConfig, class Must>
inline AbstractCache *makeDirtinessCache(PersistenceType persType,
                                         bool assumeEmptyCache) {
  typedef LruMinAgeAbstractCache<CacheConfig> May;
  if (CacheConfig->WRITEBACK && AnalyseDirtiness) {
    typedef DirtinessAnalysis<CacheConfig, Must, May> CacheAna;
    return makePersistenceCache<CacheConfig, CacheAna>(persType,
                                                       assumeEmptyCache);
  }

  typedef CompositionalAbstractCache<Must, May> CacheAna;
  return makePersistenceCache<CacheConfig, CacheAna>(persType,
                                                     assumeEmptyCache);
}
template <CacheTraits *CacheConfig>
inline AbstractCache *
makeOptionsCache(CacheReplPolicyType replpol, PersistenceType persType,
                 bool assumeEmptyCache, bool compositional,
                 bool arrayAwareMust) {

  if (replpol == CacheReplPolicyType::ALHIT ||
      replpol == CacheReplPolicyType::ALMISS) {
    typedef AlwaysCache<CacheConfig> AbsDataCache;
    return new AbsDataCache(replpol);
  } else if (compositional) {
    typedef AlwaysCache<CacheConfig> AbsDataCache;
    return new AbsDataCache(CacheReplPolicyType::ALHIT);
  }

  assert(replpol == CacheReplPolicyType::LRU &&
         "We do not support FIFO yet"); // TODO support FIFO caches

  if (arrayAwareMust) {
    assert(ArrayAnalysis);
    return makeDirtinessCache<CacheConfig,
                              LruMaxAgeArrayAwareCache<CacheConfig>>(
        persType, assumeEmptyCache);
  }

  return makeDirtinessCache<CacheConfig, LruMaxAgeAbstractCache<CacheConfig>>(
      persType, assumeEmptyCache);
}

AbstractCache *CacheFactory::makeOptionsInstrCache(bool assumeEmptyCache) {
  return makeOptionsCache<&icacheConf>(
      InstrCacheReplPolType, InstrCachePersType, assumeEmptyCache,
      CompAnaType.isSet(CompositionalAnalysisType::ICACHE), false);
}

AbstractCache *CacheFactory::makeOptionsDataCache(bool assumeEmptyCache) {
  return makeOptionsCache<&dcacheConf>(
      DataCacheReplPolType, DataCachePersType, assumeEmptyCache,
      CompAnaType.isSet(CompositionalAnalysisType::DCACHE),
      ArrayMustAnalysis != ArrayMustAnaType::NONE);
}

AbstractCache *
CacheFactory::makeOptionsInstrCacheIgnComp(bool assumeEmptyCache) {
  return makeOptionsCache<&icacheConf>(InstrCacheReplPolType,
                                       InstrCachePersType, assumeEmptyCache,
                                       false, false);
}

AbstractCache *
CacheFactory::makeOptionsDataCacheIgnComp(bool assumeEmptyCache) {
  return makeOptionsCache<&dcacheConf>(
      DataCacheReplPolType, DataCachePersType, assumeEmptyCache, false,
      ArrayMustAnalysis != ArrayMustAnaType::NONE);
}

void configureCyclingMemories() {

  fixedLatencyCyclingMemoryConfig.latency = Latency;
  fixedLatencyCyclingMemoryConfig.perWordLatency = PerWordLatency;
  oneCycleFixedLatencyCyclingMemoryConfig.latency = 0;
  oneCycleFixedLatencyCyclingMemoryConfig.perWordLatency = 1;

  if (SharedBus != SharedBusType::NONE) {
    unsigned accLat;
    if (MemTopType == MemoryTopologyType::SEPARATECACHES) {
      // for use with caches, the latency depends on the cache line size
      // as a whole cache line is requested at a time
      accLat = std::max(getCachelineMemoryLatency(CacheType::INSTRUCTION),
                        getCachelineMemoryLatency(CacheType::DATA));
    } else {
      // otherwise, only a single word is requested at a time
      accLat = Latency + PerWordLatency;
    }
    blockingCyclingMemoryConfig.maxBlockingPerAccess =
        NumConcurrentCores * accLat;
    blockingCyclingMemoryConfig.accessLatency = accLat;
  }
}

// MJa: these new typedefs should establish an at least a bit better
// maintainability. when i fixed a bug, i discovered that some casts
// for the non-iterative blocking case still were not up to date.
template <typename MemoryType>
using MemoryNonIterativeNonBlocking =
    AccessCounterCyclingMemory<MemoryType, false, true, true>;

template <typename MemoryType>
using MemoryNonIterativeBlocking = AccessCounterCyclingMemory<
    BlockingCyclingMemory<MemoryType, &blockingCyclingMemoryConfig>, false,
    true, true>;

namespace MemoriesForIterative {
// MJa: Remember that splits cannot be delayed with the blocking counter cycling
// memory as they immediately affect the blocking counter which is exposed as
// local metric
template <typename MemoryType>
using AccessCycleCounterMemory =
    BusyCycleCounterCyclingMemory<MemoryType, false, true, true>;
template <typename MemoryType>
using BlockingMemory = ConcAccessCounterWrapper<BlockingCounterCyclingMemory<
    AccessCycleCounterMemory<MemoryType>, &blockingCyclingMemoryConfig>>;
template <typename MemoryType>
using AccessCounterMemory =
    AccessCounterCyclingMemory<BlockingMemory<MemoryType>, false, true, true>;
} // namespace MemoriesForIterative

/**
 * Helper function template that treats all the shared
 * memory specific options.
 * It is only known within this compilation unit to
 * not slow down the compilation of the other units.
 */
template <typename MemoryType> AbstractCyclingMemory *dispatchSharedBus() {
  if (!CoRunnerSensitive) {
    switch (SharedBus) {
    case SharedBusType::NONE: {
      return new MemoryNonIterativeNonBlocking<MemoryType>();
      break;
    }
    case SharedBusType::ROUNDROBIN: {
      return new MemoryNonIterativeBlocking<MemoryType>();
      break;
    }
    default:
      assert(0 && "No known shared bus type");
      break;
    }
  } else {
    switch (SharedBus) {
    case SharedBusType::NONE: {
      assert(0 &&
             "Co-runner-sensitive analysis only possible with shared resource");
      break;
    }
    case SharedBusType::ROUNDROBIN: {
      return new MemoriesForIterative::AccessCounterMemory<MemoryType>();
      break;
    }
    default:
      assert(0 && "No known shared bus type");
      break;
    }
  }
  return nullptr;
}

AbstractCyclingMemory *makeOptionsBackgroundMem() {
  switch (BackgroundMemoryType) {
  case BgMemType::SRAM: {
    return dispatchSharedBus<
        FixedLatencyCyclingMemory<&fixedLatencyCyclingMemoryConfig>>();
  }
  case BgMemType::SIMPLEDRAM: {
    return dispatchSharedBus<SimpleSDRAMCyclingMemory>();
  }
  default:
    assert(0 && "Unsupported background memory type");
    return nullptr;
  }
}

AbstractCyclingMemory *makeOptionsPrivInstrMem() {
  // So far we only support a very fast instruction
  // scratchpad as private instruction memory.
  // TODO: In order to support more, we need further
  // command line parameters based on which we return
  // different private instruction memories.
  return new FixedLatencyCyclingMemory<
      &oneCycleFixedLatencyCyclingMemoryConfig>();
}

unsigned
getUbAccesses(const AbstractCyclingMemory::LocalMetrics *pBaseMetrics) {
  if (pBaseMetrics == nullptr) {
    return 0;
  }
  if (!CoRunnerSensitive) {
    switch (SharedBus) {
    case SharedBusType::NONE:
      switch (BackgroundMemoryType) {
      case BgMemType::SRAM: {
        auto casted = dynamic_cast<
            const MemoryNonIterativeNonBlocking<FixedLatencyCyclingMemory<
                &fixedLatencyCyclingMemoryConfig>>::LocalMetrics *>(
            pBaseMetrics);
        assert(casted != nullptr);
        return casted->accessCounter.getUb();
      }
      case BgMemType::SIMPLEDRAM: {
        auto casted = dynamic_cast<const MemoryNonIterativeNonBlocking<
            SimpleSDRAMCyclingMemory>::LocalMetrics *>(pBaseMetrics);
        assert(casted != nullptr);
        return casted->accessCounter.getUb();
      }
      default:
        assert(0 && "Unsupported background memory type");
        return 0;
      }
    case SharedBusType::ROUNDROBIN: {
      // in non-iterative mode, we have to consider the local metrics of
      // blocking cycling memory for all possibilities of a lowest level cycling
      // memory.
      switch (BackgroundMemoryType) {
      case BgMemType::SRAM: {
        auto casted = dynamic_cast<
            const MemoryNonIterativeBlocking<FixedLatencyCyclingMemory<
                &fixedLatencyCyclingMemoryConfig>>::LocalMetrics *>(
            pBaseMetrics);
        assert(casted != nullptr);
        return casted->accessCounter.getUb();
      }
      case BgMemType::SIMPLEDRAM: {
        auto casted = dynamic_cast<const MemoryNonIterativeBlocking<
            SimpleSDRAMCyclingMemory>::LocalMetrics *>(pBaseMetrics);
        assert(casted != nullptr);
        return casted->accessCounter.getUb();
      }
      default:
        assert(0 && "Unsupported background memory type");
        return 0;
      }
    }
    default:
      assert(0 && "No known shared memory blocking type");
      return 0;
    }
  } else {
    switch (SharedBus) {
    case SharedBusType::NONE: {
      assert(0 &&
             "Co-runner-sensitive analysis only possible with shared resource");
      break;
    }
    case SharedBusType::ROUNDROBIN: {
      // in iterative mode, we additionally have to add the
      // access cycle counting intermediate layer
      switch (BackgroundMemoryType) {
      case BgMemType::SRAM: {
        auto casted =
            dynamic_cast<const MemoriesForIterative::AccessCounterMemory<
                FixedLatencyCyclingMemory<&fixedLatencyCyclingMemoryConfig>>::
                             LocalMetrics *>(pBaseMetrics);
        assert(casted != nullptr);
        return casted->accessCounter.getUb();
      }
      case BgMemType::SIMPLEDRAM: {
        auto casted =
            dynamic_cast<const MemoriesForIterative::AccessCounterMemory<
                SimpleSDRAMCyclingMemory>::LocalMetrics *>(pBaseMetrics);
        assert(casted != nullptr);
        return casted->accessCounter.getUb();
      }
      default:
        assert(0 && "Unsupported background memory type");
        return 0;
      }
    }
    default:
      assert(0 && "No known shared memory blocking type");
      return 0;
    }
  }
  //	return static_cast<const
  //MemoriesForIterative::AccessCounterMemory::LocalMetrics*>(pBaseMetrics)
  //		->accessCounter.getUb();
}

unsigned
getLbBlockingCycles(const AbstractCyclingMemory::LocalMetrics *pBaseMetrics) {
  if (pBaseMetrics == nullptr) {
    return 0;
  }
  assert(CoRunnerSensitive &&
         "This function is so far only designed for use with "
         "co-runner-sensitive analysis." &&
         "If you want to use it in other places, carefully add support for "
         "them and remove this assert...");
  switch (BackgroundMemoryType) {
  case BgMemType::SRAM: {
    auto casted = dynamic_cast<
        const MemoriesForIterative::BlockingMemory<FixedLatencyCyclingMemory<
            &fixedLatencyCyclingMemoryConfig>>::LocalMetrics *>(pBaseMetrics);
    assert(casted != nullptr);
    return casted->blockingCounter.getLb();
  }
  case BgMemType::SIMPLEDRAM: {
    auto casted = dynamic_cast<const MemoriesForIterative::BlockingMemory<
        SimpleSDRAMCyclingMemory>::LocalMetrics *>(pBaseMetrics);
    assert(casted != nullptr);
    return casted->blockingCounter.getLb();
  }
  default:
    assert(0 && "Unsupported background memory type");
    return 0;
  }
  //	return static_cast<const
  //MemoriesForIterative::BlockingMemory::LocalMetrics*>(pBaseMetrics)
  //		->blockingCounter.getLb();
}

unsigned
getUbAccessCycles(const AbstractCyclingMemory::LocalMetrics *pBaseMetrics) {
  if (pBaseMetrics == nullptr) {
    return 0;
  }
  assert(CoRunnerSensitive &&
         "This function is so far only designed for use with "
         "co-runner-sensitive analysis." &&
         "If you want to use it in other places, carefully add support for "
         "them and remove this assert...");
  switch (BackgroundMemoryType) {
  case BgMemType::SRAM: {
    auto casted =
        dynamic_cast<const MemoriesForIterative::AccessCycleCounterMemory<
            FixedLatencyCyclingMemory<&fixedLatencyCyclingMemoryConfig>>::
                         LocalMetrics *>(pBaseMetrics);
    assert(casted != nullptr);
    return casted->busyCycleCounter.getUb();
  }
  case BgMemType::SIMPLEDRAM: {
    auto casted =
        dynamic_cast<const MemoriesForIterative::AccessCycleCounterMemory<
            SimpleSDRAMCyclingMemory>::LocalMetrics *>(pBaseMetrics);
    assert(casted != nullptr);
    return casted->busyCycleCounter.getUb();
  }
  default:
    assert(0 && "Unsupported background memory type");
    return 0;
  }
  //	return static_cast<const
  //MemoriesForIterative::AccessCycleCounterMemory::LocalMetrics*>(pBaseMetrics)
  //		->busyCycleCounter.getUb();
}

ForwardedCycles getFastForwardedAccessCycles(
    const AbstractCyclingMemory::LocalMetrics *pBaseMetrics) {
  if (pBaseMetrics == nullptr) {
    return ForwardedCycles(0u, 0u);
  }
  switch (BackgroundMemoryType) {
  case BgMemType::SRAM: {
    auto casted = dynamic_cast<const FixedLatencyCyclingMemory<
        &fixedLatencyCyclingMemoryConfig>::LocalMetrics *>(pBaseMetrics);
    assert(casted != nullptr);
    return casted->fastForwardedAccessCycles;
  }
  case BgMemType::SIMPLEDRAM: {
    auto casted = dynamic_cast<const SimpleSDRAMCyclingMemory::LocalMetrics *>(
        pBaseMetrics);
    assert(casted != nullptr);
    return casted->fastForwardedAccessCycles;
  }
  default:
    assert(0 && "Unsupported background memory type");
    return ForwardedCycles(0u, 0u);
  }
}

ForwardedCycles getFastForwardedBlocking(
    const AbstractCyclingMemory::LocalMetrics *pBaseMetrics) {
  if (pBaseMetrics == nullptr) {
    return ForwardedCycles(0u, 0u);
  }
  if (!CoRunnerSensitive) {
    switch (SharedBus) {
    case SharedBusType::NONE:
      return ForwardedCycles(0u, 0u);
    case SharedBusType::ROUNDROBIN: {
      // in non-iterative mode, we have to consider the local metrics of
      // blocking cycling memory for all possibilities of a lowest level cycling
      // memory.
      switch (BackgroundMemoryType) {
      case BgMemType::SRAM: {
        auto casted = dynamic_cast<
            const MemoryNonIterativeBlocking<FixedLatencyCyclingMemory<
                &fixedLatencyCyclingMemoryConfig>>::LocalMetrics *>(
            pBaseMetrics);
        assert(casted != nullptr);
        return casted->fastForwardedBlocking;
      }
      case BgMemType::SIMPLEDRAM: {
        auto casted = dynamic_cast<const MemoryNonIterativeBlocking<
            SimpleSDRAMCyclingMemory>::LocalMetrics *>(pBaseMetrics);
        assert(casted != nullptr);
        return casted->fastForwardedBlocking;
      }
      default:
        assert(0 && "Unsupported background memory type");
        return ForwardedCycles(0u, 0u);
      }
    }
    default:
      assert(0 && "No known shared memory blocking type");
      return ForwardedCycles(0u, 0u);
    }
  } else {
    switch (SharedBus) {
    case SharedBusType::NONE: {
      assert(0 &&
             "Co-runner-sensitive analysis only possible with shared resource");
      break;
    }
    case SharedBusType::ROUNDROBIN: {
      // in iterative mode, we additionally have to add the
      // access cycle counting intermediate layer
      switch (BackgroundMemoryType) {
      case BgMemType::SRAM: {
        auto casted = dynamic_cast<const MemoriesForIterative::BlockingMemory<
            FixedLatencyCyclingMemory<&fixedLatencyCyclingMemoryConfig>>::
                                       LocalMetrics *>(pBaseMetrics);
        assert(casted != nullptr);
        return casted->fastForwardedBlocking;
      }
      case BgMemType::SIMPLEDRAM: {
        auto casted = dynamic_cast<const MemoriesForIterative::BlockingMemory<
            SimpleSDRAMCyclingMemory>::LocalMetrics *>(pBaseMetrics);
        assert(casted != nullptr);
        return casted->fastForwardedBlocking;
      }
      default:
        assert(0 && "Unsupported background memory type");
        return ForwardedCycles(0u, 0u);
      }
    }
    default:
      assert(0 && "No known shared memory blocking type");
      return ForwardedCycles(0u, 0u);
    }
  }
}

unsigned
getLbConcAccesses(const AbstractCyclingMemory::LocalMetrics *pBaseMetrics) {
  if (pBaseMetrics == nullptr) {
    return 0;
  }
  assert(CoRunnerSensitive &&
         "This function is so far only designed for use with "
         "co-runner-sensitive analysis." &&
         "If you want to use it in other places, carefully add support for "
         "them and remove this assert...");
  switch (BackgroundMemoryType) {
  case BgMemType::SRAM: {
    auto casted = dynamic_cast<
        const MemoriesForIterative::BlockingMemory<FixedLatencyCyclingMemory<
            &fixedLatencyCyclingMemoryConfig>>::LocalMetrics *>(pBaseMetrics);
    assert(casted != nullptr);
    return casted->concAccesses.getLb();
  }
  case BgMemType::SIMPLEDRAM: {
    auto casted = dynamic_cast<const MemoriesForIterative::BlockingMemory<
        SimpleSDRAMCyclingMemory>::LocalMetrics *>(pBaseMetrics);
    assert(casted != nullptr);
    return casted->concAccesses.getLb();
  }
  default:
    assert(0 && "Unsupported background memory type");
    return 0;
  }
  //	return static_cast<const
  //MemoriesForIterative::BlockingMemory::LocalMetrics*>(pBaseMetrics)
  //		->blockingCounter.getLb();
}

} // namespace TimingAnalysisPass
