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

#ifndef JJYSEPARATECACHESMEMORYTOPOLOGY_H
#define JJYSEPARATECACHESMEMORYTOPOLOGY_H

#include "llvm/Support/Debug.h"

#include "Memory/AbstractCache.h"
#include "Memory/Classification.h"
#include "Memory/MemoryTopologyInterface.h"
#include "MicroarchitecturalAnalysis/InOrderPipelineState.h"
#include "Util/GlobalVars.h"
#include "Util/Options.h"

#include <list>

namespace TimingAnalysisPass {

using namespace dom::cache;

/**
 * Class representing a memory topology with separate caches for both
 * instruction and data cache, plus a background memory for cache misses. The
 * background memory has to be another memory topology.
 */
template <AbstractCache *(*makeInstrCache)(bool),
          AbstractCache *(*makeDataCache)(bool),
          AbstractCache *(*makeL2Cache)(bool), class BgMem>
class JJYSeparateCachesMemoryTopology
    : public MemoryTopologyInterface<JJYSeparateCachesMemoryTopology<
          makeInstrCache, makeDataCache, makeL2Cache, BgMem>> {
public:
  /**
   * Public Default Contructor
   */
  JJYSeparateCachesMemoryTopology();

  /**
   * Copy Constructor
   */
  JJYSeparateCachesMemoryTopology(const JJYSeparateCachesMemoryTopology &scmt);

  /**
   * Assignment operator
   */
  JJYSeparateCachesMemoryTopology &
  operator=(const JJYSeparateCachesMemoryTopology &scmt);

  /**
   * Destructor
   */
  ~JJYSeparateCachesMemoryTopology() {}

  /**
   * Container used to make the local metrics of this class
   * available to the world outside.
   */
  struct LocalMetrics {
    // the fields added to the local metrics used as base
    // The access to the address - if any - just missed the cache
    boost::optional<AbstractAddress> justMissedInstrCache;
    // The access to the address - if any - just missed the cache
    boost::optional<AbstractAddress> justMissedDataCache;
    boost::optional<AbstractAddress> justMissedL2Cache;
    // The persistence scope just entered
    boost::optional<std::set<PersistenceScope>> justEntered;
    // The access - if any - that updates the I-cache repl policy state
    boost::optional<AbstractAddress> justUpdatedInstrCache;
    // The access - if any - that updates the D-cache repl policy state
    boost::optional<AbstractAddress> justUpdatedDataCache;
    boost::optional<AbstractAddress> justDirtifiedLine;
    bool justWroteBackLine;
    // Number of misses to instruction cache
    unsigned l1instrMisses, l2instrMisses;
    // Number of misses to data cache
    unsigned l1dataMisses, l2dataMisses;
    // Number of stores to the bus
    unsigned storesToBus;
    // Reference to the instruction cache
    AbstractCache *instrCache;
    // Reference to the data cache
    AbstractCache *dataCache;
    AbstractCache *l2Cache;
    // Local Metrics of the internally wrapped memory topology
    typename BgMem::LocalMetrics backgroundMemory;

    /**
     * Creates the local metrics based on the
     * outer class' content.
     */
    LocalMetrics(const JJYSeparateCachesMemoryTopology &outerClassInstance)
        : justMissedInstrCache(
              outerClassInstance.instructionComponent.justMissedCache),
          justMissedDataCache(outerClassInstance.dataComponent.justMissedCache),
          justMissedL2Cache(outerClassInstance.L2Component.justMissedCache),
          justEntered(outerClassInstance.justEntered),
          justUpdatedInstrCache(
              outerClassInstance.instructionComponent.justUpdatedCache),
          justUpdatedDataCache(
              outerClassInstance.dataComponent.justUpdatedCache),
          justDirtifiedLine(outerClassInstance.dataComponent.justDirtifiedLine),
          justWroteBackLine(outerClassInstance.dataComponent.justWroteBackLine),
          l1instrMisses(outerClassInstance.instructionComponent.l1nmisses),
          l1dataMisses(outerClassInstance.dataComponent.l1nmisses),
          l2instrMisses(outerClassInstance.instructionComponent.l2nmisses),
          l2dataMisses(outerClassInstance.dataComponent.l2nmisses),
          storesToBus(outerClassInstance.dataComponent.numStoreBusAccess),
          instrCache(outerClassInstance.instructionComponent.cache->clone()),
          dataCache(outerClassInstance.dataComponent.cache->clone()),
          l2Cache(outerClassInstance.L2Component.cache->clone()),
          backgroundMemory(outerClassInstance.memory) {}

    ~LocalMetrics() {
      delete instrCache;
      delete dataCache;
      delete l2Cache;
    }

    /**
     * Checks for equality between local metrics.
     */
    bool operator==(const LocalMetrics &anotherInstance) {
      return justMissedInstrCache == anotherInstance.justMissedInstrCache &&
             justMissedDataCache == anotherInstance.justMissedDataCache &&
             justMissedL2Cache == anotherInstance.justMissedL2Cache &&
             justEntered == anotherInstance.justEntered &&
             justUpdatedInstrCache == anotherInstance.justUpdatedInstrCache &&
             justUpdatedDataCache == anotherInstance.justUpdatedDataCache &&
             justDirtifiedLine == anotherInstance.justDirtifiedLine &&
             justWroteBackLine == anotherInstance.justWroteBackLine &&
             l1instrMisses == anotherInstance.l1instrMisses &&
             l2dataMisses == anotherInstance.l2dataMisses &&
             // l2
             l2instrMisses == anotherInstance.l2instrMisses &&
             l2dataMisses == anotherInstance.l2dataMisses &&
             storesToBus == anotherInstance.storesToBus &&
             instrCache->equals(*anotherInstance.instrCache) &&
             dataCache->equals(*anotherInstance.dataCache) &&
             l2Cache->equals(*anotherInstance.l2Cache) &&
             backgroundMemory == anotherInstance.backgroundMemory;
    }
  };

  /**
   * Resets the local metrics to their initial values.
   */
  void resetLocalMetrics() {
    instructionComponent.justMissedCache = boost::none;
    instructionComponent.justUpdatedCache = boost::none;
    justEntered = boost::none;
    instructionComponent.l1nmisses = 0;
    instructionComponent.l2nmisses = 0;
    instructionComponent.numStoreBusAccess = 0;
    dataComponent.justMissedCache = boost::none;
    dataComponent.justUpdatedCache = boost::none;
    dataComponent.justDirtifiedLine = boost::none;
    dataComponent.justWroteBackLine = false;
    dataComponent.l1nmisses = 0;
    dataComponent.l2nmisses = 0;
    dataComponent.numStoreBusAccess = 0;

    L2Component.justMissedCache = boost::none;
    L2Component.justUpdatedCache = boost::none;
    L2Component.justDirtifiedLine = boost::none;
    L2Component.justWroteBackLine = false;
    L2Component.l1nmisses = 0;
    L2Component.l2nmisses = 0;
    L2Component.numStoreBusAccess = 0;
    memory.resetLocalMetrics();
  }

  /**
   * Accesses the instruction with the given address.
   * This may override a previous access.
   * Returns an id.
   */
  virtual boost::optional<unsigned> accessInstr(unsigned addr,
                                                unsigned numWords);

  /**
   * Accesses data at the given address.
   * Returns an id or none if the access cannot be processed.
   */
  virtual boost::optional<unsigned>
  accessData(AbstractAddress addr, AccessType load_store, unsigned numWords);

  /**
   * Cycles the topology once.
   * This includes cycling all memory modules inside.
   * The bool parameter says whether there are potential data misses pending
   * between the fetch and memory phase. A strictly in-order pipeline requires
   * stalling fetch misses. It is passed to the underlying topology.
   */
  virtual std::list<JJYSeparateCachesMemoryTopology>
  cycle(bool potentialDataMissesPending) const;

  /**
   * Ask the underlying memory topology to stall during this cycle.
   */
  virtual bool shouldPipelineStall() const;

  /**
   * Checks whether an instruction access finished.
   */
  virtual bool finishedInstrAccess(unsigned accessId);

  /**
   * Checks whether a data access finished.
   */
  virtual bool finishedDataAccess(unsigned accessId);

  /// See superclass
  virtual void enterScope(const PersistenceScope &scope);
  virtual void leaveScope(const PersistenceScope &scope);

  virtual bool hasUnfinishedAccesses() const;

  /**
   * Checks whether this topology is the same as the given one.
   */
  virtual bool operator==(const JJYSeparateCachesMemoryTopology &scmt) const;

  /**
   * Hashes the topology.
   */
  virtual size_t hashcode() const;

  /**
   * Is the memory topology waiting to be joined with similar topologies?
   */
  virtual bool isWaitingForJoin() const;

  virtual bool isJoinable(const JJYSeparateCachesMemoryTopology &scmt) const;

  virtual void join(const JJYSeparateCachesMemoryTopology &scmt);

  /**
   * Is the memory topology currently performing an instruction access?
   */
  virtual bool isBusyAccessingInstr() const;

  /**
   * Is the memory topology currently performing a data access?
   */
  virtual bool isBusyAccessingData() const;

  /**
   * Fast-forwarding of the memory topology.
   */
  virtual std::list<JJYSeparateCachesMemoryTopology> fastForward() const;

  /**
   * Outputs the data content of this topology.
   */
  template <AbstractCache *(*makeInstrCachef)(bool),
            AbstractCache *(*makeDataCachef)(bool),
            AbstractCache *(*makeL2Cachef)(bool), class BgMemf>
  friend std::ostream &operator<<(
      std::ostream &stream,
      const JJYSeparateCachesMemoryTopology<makeInstrCachef, makeDataCachef,
                                            makeL2Cachef, BgMemf> &scmt);

private:
  typedef MemoryTopologyInterface<JJYSeparateCachesMemoryTopology> Super;

  typedef typename Super::Access Access;

  /**
   * Increments the current id.
   * Prevents '0' being used as current id, as this is used to represent
   * nothing.
   */
  void incrementCurrentId();

  /**
   * Trigger an access if currently no access is ongoing
   */
  std::list<JJYSeparateCachesMemoryTopology> startInstructionAccess();
  std::list<JJYSeparateCachesMemoryTopology> mystartInstructionAccess();
  std::list<JJYSeparateCachesMemoryTopology> startDataAccess();
  std::list<JJYSeparateCachesMemoryTopology> mystartDataAccess();

  /**
   * According to the given classification perform action in the memory topology
   */
  void processInstrCacheAccess(Classification cl);
  void processDataCacheAccess(Classification cl);

  /**
   * Check whether accesses to cache or background memory are finished
   */
  std::list<JJYSeparateCachesMemoryTopology> checkInstructionPart();
  std::list<JJYSeparateCachesMemoryTopology> checkDataPart();

  // Reference to the memory topology that is accessed whenever a cache miss
  // occurs. Has to be derived by MemoryTopology.
  BgMem memory;

  /**
   * Counter to provide a new identifier for each access.
   * Should start counting with 1, cf. currentIdAccessed.
   */
  unsigned currentId;

  /**
   * The different phases an access can be in (for the general case)
   */
  enum class AccessPhase {
    WaitForSTART, // We are waiting for the access to start
    WaitForLOAD, // We are waiting for a load from background memory topology to
                 // finish
    WaitForCACHE, // We are waiting for the cache to finish its update
    WaitForSTORE  // We are waiting for a store from background
                  // memory topology to finish
  };

  /**
   * One ongoing access
   */
  struct OngoingAccess {
    /// Stores the id currently being accessed by the topology.
    Access access;
    /// The access phase of the current access
    AccessPhase phase;
    /// The background memory could not take the access as it was busy, try
    /// again
    bool bgmemStall;
    /// Stores the id currently accessed in the background memory topology.
    unsigned bgMemAccessId;
    /// Stores the id currently accessed in the l2 topology.
    unsigned bgl2AccessId;
    /// Blocking counter to wait until a cache access is finished.
    unsigned l1timeBlocked, l2timeBlocked;
    /// Classification of this access by the cache
    Classification cl;

    // Constructor
    OngoingAccess(Access acc)
        : access(acc), phase(AccessPhase::WaitForSTART), bgmemStall(false),
          bgMemAccessId(0), bgl2AccessId(0), l1timeBlocked(0), l2timeBlocked(0),
          cl(CL_BOT) {}
  };

  struct MemoryComponent {
    /// Queue holding future accesses
    /// TODO!!!!!!!!
    std::list<Access> waitingQueue;
    /// The on-going access
    boost::optional<OngoingAccess> ongoingAccess;
    /// Stores the id of the finished access
    unsigned finishedId;
    /// The abstract cache
    AbstractCache *cache;
    // Remember the access we just performed to update the cache
    boost::optional<AbstractAddress> justUpdatedCache;
    // Remember which address we have just missed in cache - if any
    boost::optional<AbstractAddress> justMissedCache;
    // true if the last access dirtified the line it accessed.
    boost::optional<AbstractAddress> justDirtifiedLine;
    // true if the last access wrote back a line
    bool justWroteBackLine;
    // Collect the numer of misses we encountered in this basic block
    unsigned l2nmisses;
    unsigned l1nmisses;
    // Collect the number of stores that access the bus in this basic block
    unsigned numStoreBusAccess;

    // Constructor
    MemoryComponent(AbstractCache *cache)
        : waitingQueue(), ongoingAccess(boost::none), finishedId(0),
          cache(cache), justUpdatedCache(boost::none),
          justMissedCache(boost::none), justDirtifiedLine(boost::none),
          justWroteBackLine(false), l2nmisses(0), numStoreBusAccess(0),
          l1nmisses(0) {}
    // Copy constructor
    MemoryComponent(const MemoryComponent &mc)
        : waitingQueue(mc.waitingQueue), ongoingAccess(mc.ongoingAccess),
          finishedId(mc.finishedId), cache(mc.cache->clone()),
          justUpdatedCache(mc.justUpdatedCache),
          justMissedCache(mc.justMissedCache),
          justDirtifiedLine(mc.justDirtifiedLine),
          justWroteBackLine(mc.justWroteBackLine), l2nmisses(mc.l2nmisses),
          l1nmisses(mc.l1nmisses), numStoreBusAccess(mc.numStoreBusAccess) {}
    // Assignment operator
    MemoryComponent &operator=(const MemoryComponent &mc) {
      waitingQueue = mc.waitingQueue;
      ongoingAccess = mc.ongoingAccess;
      finishedId = mc.finishedId;
      delete cache;
      cache = mc.cache->clone();
      justUpdatedCache = mc.justUpdatedCache;
      justMissedCache = mc.justMissedCache;
      justDirtifiedLine = mc.justDirtifiedLine;
      justWroteBackLine = mc.justWroteBackLine;
      l2nmisses = mc.l2nmisses;
      numStoreBusAccess = mc.numStoreBusAccess;
      l1nmisses = mc.l1nmisses;
      return *this;
    }
    // Destructor
    ~MemoryComponent() { delete cache; }
    // Equals operator
    bool equals(const MemoryComponent &mc, unsigned myId, unsigned mcId) const {
      return cache->lessequal(*mc.cache) && mc.cache->lessequal(*cache) &&
             // do not compare justMissed because if they differ, the caches
             // should differ as well
             justDirtifiedLine == mc.justDirtifiedLine &&
             justWroteBackLine == mc.justWroteBackLine &&
             l2nmisses == mc.l2nmisses &&
             numStoreBusAccess == mc.numStoreBusAccess &&
             l1nmisses == mc.l1nmisses && equalsWithoutCache(mc, myId, mcId);
    }
    bool equalsWithoutCache(const MemoryComponent &mc, unsigned myId,
                            unsigned mcId) const {
      return Super::areQueuesEqual(waitingQueue, mc.waitingQueue, myId, mcId) &&
             ((!ongoingAccess && !mc.ongoingAccess) ||
              (ongoingAccess && mc.ongoingAccess &&
               Super::areAccessElementsEqual(ongoingAccess.get().access,
                                             mc.ongoingAccess.get().access,
                                             myId, mcId) &&
               // do only a "soft" compare of the background topology ids, since
               // they are relative to an unknown value
               ((ongoingAccess.get().bgMemAccessId != 0 &&
                 mc.ongoingAccess.get().bgMemAccessId != 0) ||
                (ongoingAccess.get().bgMemAccessId == 0 &&
                 mc.ongoingAccess.get().bgMemAccessId == 0)) &&
               ((ongoingAccess.get().bgl2AccessId != 0 &&
                 mc.ongoingAccess.get().bgl2AccessId != 0) ||
                (ongoingAccess.get().bgl2AccessId == 0 &&
                 mc.ongoingAccess.get().bgl2AccessId == 0)) &&
               ongoingAccess.get().l1timeBlocked ==
                   mc.ongoingAccess.get().l1timeBlocked &&
               ongoingAccess.get().phase == mc.ongoingAccess.get().phase &&
               ongoingAccess.get().bgmemStall ==
                   mc.ongoingAccess.get().bgmemStall &&
               ongoingAccess.get().cl == mc.ongoingAccess.get().cl)) &&
             Super::areAccessIdsEqual(finishedId, mc.finishedId, myId, mcId) &&
             // If we keep the accessed addresses, we need them precisely
             justUpdatedCache == mc.justUpdatedCache &&
             /* If these field differs we shouldn't join or
              * the dfs-bound gets weaker */
             justWroteBackLine == mc.justWroteBackLine &&
             justDirtifiedLine == mc.justDirtifiedLine;
    }
    void joinCache(const MemoryComponent &mc) {
      cache->join(*mc.cache);
      if (justMissedCache != mc.justMissedCache) {
        justMissedCache = boost::none;
      }
      assert(justUpdatedCache == mc.justUpdatedCache);
      assert(justDirtifiedLine == mc.justDirtifiedLine);
      assert(justWroteBackLine == mc.justWroteBackLine);
      l2nmisses = std::max(l2nmisses, mc.l2nmisses);
      l1nmisses = std::max(l1nmisses, mc.l1nmisses);
      numStoreBusAccess = std::max(numStoreBusAccess, mc.numStoreBusAccess);
    }
  };

  /**
   * Instruction part of the topology
   */
  MemoryComponent instructionComponent;
  /**
   * Data part of the topology
   */
  MemoryComponent dataComponent;

  // jjy: 层2缓存
  MemoryComponent L2Component;

  /**
   * The persistence scope just entered
   */
  boost::optional<std::set<PersistenceScope>> justEntered;
};

template <AbstractCache *(*makeInstrCache)(bool),
          AbstractCache *(*makeDataCache)(bool),
          AbstractCache *(*makeL2Cache)(bool), class BgMem>
JJYSeparateCachesMemoryTopology<makeInstrCache, makeDataCache, makeL2Cache,
                                BgMem>::JJYSeparateCachesMemoryTopology()
    : memory(BgMem()), currentId(1),
      instructionComponent(makeInstrCache(false)),
      dataComponent(makeDataCache(false)), L2Component(makeL2Cache(false)),
      justEntered(boost::none) {}

template <AbstractCache *(*makeInstrCache)(bool),
          AbstractCache *(*makeDataCache)(bool),
          AbstractCache *(*makeL2Cache)(bool), class BgMem>
JJYSeparateCachesMemoryTopology<makeInstrCache, makeDataCache, makeL2Cache,
                                BgMem>::
    JJYSeparateCachesMemoryTopology(const JJYSeparateCachesMemoryTopology &scmt)
    : memory(scmt.memory), currentId(scmt.currentId),
      instructionComponent(scmt.instructionComponent),
      dataComponent(scmt.dataComponent), L2Component(scmt.L2Component),
      justEntered(scmt.justEntered) {}

template <AbstractCache *(*makeInstrCache)(bool),
          AbstractCache *(*makeDataCache)(bool),
          AbstractCache *(*makeL2Cache)(bool), class BgMem>
JJYSeparateCachesMemoryTopology<makeInstrCache, makeDataCache, makeL2Cache,
                                BgMem> &
JJYSeparateCachesMemoryTopology<
    makeInstrCache, makeDataCache, makeL2Cache,
    BgMem>::operator=(const JJYSeparateCachesMemoryTopology &scmt) {
  instructionComponent = scmt.instructionComponent;
  dataComponent = scmt.dataComponent;
  L2Component = scmt.L2Component;
  memory = scmt.memory;
  currentId = scmt.currentId;
  justEntered = scmt.justEntered;
  return *this;
}

template <AbstractCache *(*makeInstrCache)(bool),
          AbstractCache *(*makeDataCache)(bool),
          AbstractCache *(*makeL2Cache)(bool), class BgMem>
boost::optional<unsigned>
JJYSeparateCachesMemoryTopology<makeInstrCache, makeDataCache, makeL2Cache,
                                BgMem>::accessInstr(unsigned addr,
                                                    unsigned numWords) {
  // override (delete) previous access
  if (instructionComponent.waitingQueue.size() > 0) {
    instructionComponent.waitingQueue.pop_front();
  }
  unsigned resId = currentId;
  instructionComponent.waitingQueue.push_back(
      Access(resId, AbstractAddress(addr), AccessType::LOAD, numWords));
  incrementCurrentId();
  return boost::optional<unsigned>(resId);
}

template <AbstractCache *(*makeInstrCache)(bool),
          AbstractCache *(*makeDataCache)(bool),
          AbstractCache *(*makeL2Cache)(bool), class BgMem>
boost::optional<unsigned>
JJYSeparateCachesMemoryTopology<makeInstrCache, makeDataCache, makeL2Cache,
                                BgMem>::accessData(AbstractAddress addr,
                                                   AccessType load_store,
                                                   unsigned numWords) {
  unsigned resId;
  if (dataComponent.waitingQueue.size() == 0) {
    resId = currentId;
    dataComponent.waitingQueue.push_back(
        Access(resId, addr, load_store, numWords));
    incrementCurrentId();
    return boost::optional<unsigned>(resId);
  } else {
    return boost::none;
  }
}

template <AbstractCache *(*makeInstrCache)(bool),
          AbstractCache *(*makeDataCache)(bool),
          AbstractCache *(*makeL2Cache)(bool), class BgMem>
bool JJYSeparateCachesMemoryTopology<makeInstrCache, makeDataCache, makeL2Cache,
                                     BgMem>::finishedInstrAccess(unsigned id) {
  bool res = instructionComponent.finishedId == id;
  if (res) {
    instructionComponent.finishedId = 0;
  }
  return res;
}

template <AbstractCache *(*makeInstrCache)(bool),
          AbstractCache *(*makeDataCache)(bool),
          AbstractCache *(*makeL2Cache)(bool), class BgMem>
bool JJYSeparateCachesMemoryTopology<makeInstrCache, makeDataCache, makeL2Cache,
                                     BgMem>::finishedDataAccess(unsigned id) {
  bool res = dataComponent.finishedId == id;
  if (res) {
    dataComponent.finishedId = 0;
  }
  return res;
}

template <AbstractCache *(*makeInstrCache)(bool),
          AbstractCache *(*makeDataCache)(bool),
          AbstractCache *(*makeL2Cache)(bool), class BgMem>
void JJYSeparateCachesMemoryTopology<makeInstrCache, makeDataCache, makeL2Cache,
                                     BgMem>::enterScope(const PersistenceScope
                                                            &scope) {
  instructionComponent.cache->enterScope(scope);
  dataComponent.cache->enterScope(scope);
  L2Component.cache->enterScope(scope);
  if (!justEntered) {
    justEntered = std::set<PersistenceScope>();
  }
  justEntered.get().insert(scope);
}

template <AbstractCache *(*makeInstrCache)(bool),
          AbstractCache *(*makeDataCache)(bool),
          AbstractCache *(*makeL2Cache)(bool), class BgMem>
void JJYSeparateCachesMemoryTopology<makeInstrCache, makeDataCache, makeL2Cache,
                                     BgMem>::leaveScope(const PersistenceScope
                                                            &scope) {
  instructionComponent.cache->leaveScope(scope);
  dataComponent.cache->leaveScope(scope);
  L2Component.cache->leaveScope(scope);
}
// jjy:可能需要改
template <AbstractCache *(*makeInstrCache)(bool),
          AbstractCache *(*makeDataCache)(bool),
          AbstractCache *(*makeL2Cache)(bool), class BgMem>
bool JJYSeparateCachesMemoryTopology<makeInstrCache, makeDataCache, makeL2Cache,
                                     BgMem>::hasUnfinishedAccesses() const {
  bool result = instructionComponent.ongoingAccess ||
                !instructionComponent.waitingQueue.empty() ||
                dataComponent.ongoingAccess ||
                !dataComponent.waitingQueue.empty() ||
                memory.hasUnfinishedAccesses();
  return result;
}

template <AbstractCache *(*makeInstrCache)(bool),
          AbstractCache *(*makeDataCache)(bool),
          AbstractCache *(*makeL2Cache)(bool), class BgMem>
void JJYSeparateCachesMemoryTopology<makeInstrCache, makeDataCache, makeL2Cache,
                                     BgMem>::incrementCurrentId() {
  currentId++;
  if (currentId == 0) { // prevent zero from begin used!
    currentId++;
  }
}

// cycle is called from the pipeline
template <AbstractCache *(*makeInstrCache)(bool),
          AbstractCache *(*makeDataCache)(bool),
          AbstractCache *(*makeL2Cache)(bool), class BgMem>
std::list<JJYSeparateCachesMemoryTopology<makeInstrCache, makeDataCache,
                                          makeL2Cache, BgMem>>
JJYSeparateCachesMemoryTopology<makeInstrCache, makeDataCache, makeL2Cache,
                                BgMem>::cycle(bool potentialDataMissesPending)
    const {
  // Overall result list
  std::list<JJYSeparateCachesMemoryTopology> resultList;

  JJYSeparateCachesMemoryTopology succ(*this);
  // We delete our just-missed events in all our successors
  succ.instructionComponent.justMissedCache = boost::none;
  succ.dataComponent.justMissedCache = boost::none;
  succ.L2Component.justMissedCache = boost::none;
  // We delete our just-accessed events in all our successors
  succ.instructionComponent.justUpdatedCache = boost::none;
  succ.dataComponent.justUpdatedCache = boost::none;
  succ.dataComponent.justDirtifiedLine = boost::none;
  succ.dataComponent.justWroteBackLine = false;
  // We delete scope entering
  succ.justEntered = boost::none;

  // If starting instruction accesses is feasible, do it
  for (auto &startinstrTopology : succ.mystartInstructionAccess()) {
    for (auto &startdataTopology : startinstrTopology.mystartDataAccess()) {
      // Cycle background memory
      for (auto &memory :
           startdataTopology.memory.cycle(potentialDataMissesPending)) {
        JJYSeparateCachesMemoryTopology afterbgmemcycle(startdataTopology);
        afterbgmemcycle.memory = memory; // memorytopology

        // If we should have stalled the pipeline in this cycle, we should also
        // stall the topology
        if (afterbgmemcycle.shouldPipelineStall()) {
          resultList.push_back(afterbgmemcycle);
        } else {
          // Cycle Memory Topology
          for (auto &memAfterInstr : afterbgmemcycle.checkInstructionPart()) {
            for (auto &memAfterData : memAfterInstr.checkDataPart()) {
              resultList.push_back(memAfterData);
            }
          }
        }
      }
    }
  }

  return resultList;
}

// JJY: 改变split
template <AbstractCache *(*makeInstrCache)(bool),
          AbstractCache *(*makeDataCache)(bool),
          AbstractCache *(*makeL2Cache)(bool), class BgMem>
std::list<JJYSeparateCachesMemoryTopology<makeInstrCache, makeDataCache,
                                          makeL2Cache, BgMem>>
JJYSeparateCachesMemoryTopology<makeInstrCache, makeDataCache, makeL2Cache,
                                BgMem>::mystartInstructionAccess() {
  std::list<JJYSeparateCachesMemoryTopology> resultList;

  // We do not have any ongoing instruction access, so start one if there is one
  // waiting
  if (!instructionComponent.ongoingAccess) {
    // nothing accessed yet
    if (instructionComponent.waitingQueue.size() > 0) {
      instructionComponent.ongoingAccess =
          OngoingAccess(instructionComponent.waitingQueue.front());
      instructionComponent.waitingQueue.pop_front();

      // check cache for hit/l2hit/l2miss/l2unknown
      Classification L1 = instructionComponent.cache->classify(
          instructionComponent.ongoingAccess.get().access.addr);
      Classification L2 = L2Component.cache->classify(
          instructionComponent.ongoingAccess.get().access.addr);
      if (L1 == CL_HIT || (L1 == CL_UNKNOWN && ::isBCET)) {
        this->processInstrCacheAccess(CL_HIT);
      } else {
        if (L2 == CL_HIT || (L2 == CL_UNKNOWN && ::isBCET)) {
          if (L1 == CL_UNKNOWN) {
            //时序异常
            JJYSeparateCachesMemoryTopology l1hit(*this);
            l1hit.processInstrCacheAccess(CL_HIT);
            resultList.push_back(l1hit);
          }
          this->processInstrCacheAccess(CL2_HIT);
        } else {
          this->processInstrCacheAccess(CL2_MISS);
        }
      }
    }
  }
  resultList.push_back(*this);
  return resultList;
}

template <AbstractCache *(*makeInstrCache)(bool),
          AbstractCache *(*makeDataCache)(bool),
          AbstractCache *(*makeL2Cache)(bool), class BgMem>
std::list<JJYSeparateCachesMemoryTopology<makeInstrCache, makeDataCache,
                                          makeL2Cache, BgMem>>
JJYSeparateCachesMemoryTopology<makeInstrCache, makeDataCache, makeL2Cache,
                                BgMem>::mystartDataAccess() {
  std::list<JJYSeparateCachesMemoryTopology> resultList;

  // We do not have any ongoing data access, so start one if there is one
  // waiting
  if (!dataComponent.ongoingAccess) {
    if (dataComponent.waitingQueue.size() > 0) {
      dataComponent.ongoingAccess =
          OngoingAccess(dataComponent.waitingQueue.front());
      dataComponent.waitingQueue.pop_front();

      // check cache for hit/miss/unknown
      Classification L1 = dataComponent.cache->classify(
          dataComponent.ongoingAccess.get().access.addr);
      Classification L2 = L2Component.cache->classify(
          dataComponent.ongoingAccess.get().access.addr);
      if (L1 == CL_HIT || (L1 == CL_UNKNOWN && ::isBCET)) {
        this->processDataCacheAccess(CL_HIT);
      } else {
        if (L2 == CL_HIT || (L2 == CL_UNKNOWN && ::isBCET)) {
          if (L1 == CL_UNKNOWN) {
            //时序异常
            JJYSeparateCachesMemoryTopology l1hit(*this);
            l1hit.processDataCacheAccess(CL_HIT);
            resultList.push_back(l1hit);
          }
          this->processDataCacheAccess(CL2_HIT);
        } else {
          this->processDataCacheAccess(CL2_MISS);
        }
      }
    }
  }
  resultList.push_back(*this);
  return resultList;
}

template <AbstractCache *(*makeInstrCache)(bool),
          AbstractCache *(*makeDataCache)(bool),
          AbstractCache *(*makeL2Cache)(bool), class BgMem>
std::list<JJYSeparateCachesMemoryTopology<makeInstrCache, makeDataCache,
                                          makeL2Cache, BgMem>>
JJYSeparateCachesMemoryTopology<makeInstrCache, makeDataCache, makeL2Cache,
                                BgMem>::checkInstructionPart() {
  std::list<JJYSeparateCachesMemoryTopology> resultList;

  if (instructionComponent.ongoingAccess) // We are accessing something
  {
    auto &ongoingAcc = instructionComponent.ongoingAccess.get();
    // check whether something was accessed in the background memory
    if (ongoingAcc.bgMemAccessId != 0) {
      if (memory.finishedInstrAccess(ongoingAcc.bgMemAccessId)) {
        // Not waiting for memory any more
        ongoingAcc.bgl2AccessId = ongoingAcc.bgMemAccessId;

        ongoingAcc.bgMemAccessId = 0;
        // Blocked for cache update
        ongoingAcc.l2timeBlocked = 1;
      }
    } else if (ongoingAcc.bgl2AccessId != 0) {
      if (memory.l2finishedInstrAccess(ongoingAcc.bgl2AccessId) ||
          ongoingAcc.l2timeBlocked == 1) {
        // Not waiting for l2 any more
        ongoingAcc.bgl2AccessId = 0;
        // Blocked for cache update
        ongoingAcc.l1timeBlocked = 1;
        if (needAccessedInstructionAddresses()) {
          instructionComponent.justUpdatedCache = ongoingAcc.access.addr;
        }
        L2Component.cache->update(ongoingAcc.access.addr,
                                  ongoingAcc.access.load_store, false,
                                  ongoingAcc.cl);
      }
    } else {
      if (ongoingAcc.l1timeBlocked > 0) {
        ongoingAcc.l1timeBlocked--;
      }

      if (ongoingAcc.l1timeBlocked == 0) {
        instructionComponent.finishedId = ongoingAcc.access.id;
        if (needAccessedInstructionAddresses()) {
          instructionComponent.justUpdatedCache = ongoingAcc.access.addr;
        }
        instructionComponent.cache->update(ongoingAcc.access.addr,
                                           ongoingAcc.access.load_store, false,
                                           ongoingAcc.cl);
        instructionComponent.ongoingAccess = boost::none;
      }
    }
  }
  resultList.push_back(*this);
  return resultList;
}

template <AbstractCache *(*makeInstrCache)(bool),
          AbstractCache *(*makeDataCache)(bool),
          AbstractCache *(*makeL2Cache)(bool), class BgMem>
std::list<JJYSeparateCachesMemoryTopology<makeInstrCache, makeDataCache,
                                          makeL2Cache, BgMem>>
JJYSeparateCachesMemoryTopology<makeInstrCache, makeDataCache, makeL2Cache,
                                BgMem>::checkDataPart() {
  std::list<JJYSeparateCachesMemoryTopology> resultList;

  if (dataComponent.ongoingAccess) // We are accessing something
  {
    auto &ongoingAcc = dataComponent.ongoingAccess.get();
    // Do we need to stall as background memory is busy, try again now
    if (ongoingAcc.bgmemStall) {
      assert(UnblockStores && "Cannot be stalled on background memory when "
                              "blocking Stores are used");
      assert((ongoingAcc.phase == AccessPhase::WaitForLOAD ||
              ongoingAcc.phase == AccessPhase::WaitForSTORE) &&
             "Stall => waiting for load or store");
      auto accTy = (ongoingAcc.phase == AccessPhase::WaitForLOAD)
                       ? AccessType::LOAD
                       : AccessType::STORE;
      // Loads are done in cacheline chunks
      auto nwords = (accTy == AccessType::LOAD) ? Dlinesize / 4
                                                : ongoingAcc.access.numWords;
      auto res = memory.accessData(ongoingAcc.access.addr, accTy, nwords);
      if (res) {
        ongoingAcc.bgMemAccessId = res.get();
        ongoingAcc.bgmemStall = false;
      }
    } else {

      if (ongoingAcc.phase == AccessPhase::WaitForLOAD) {
        // assert(
        //     (ongoingAcc.bgMemAccessId != 0 || ongoingAcc.bgl2AccessId != 0)
        //     && "Waiting for load but not accessing anything");
        if (memory.finishedDataAccess(
                ongoingAcc
                    .bgMemAccessId)) { // We waited for load and are finished
          ongoingAcc.bgMemAccessId = 0;
          ongoingAcc.l1timeBlocked = 1;
          ongoingAcc.l2timeBlocked = 1;
          ongoingAcc.phase = AccessPhase::WaitForCACHE;
        }
      }

      else if (ongoingAcc.phase == AccessPhase::WaitForCACHE) {
        if (ongoingAcc.bgl2AccessId != 0) {
          if (memory.l2finishedDataAccess(ongoingAcc.bgl2AccessId)) {
            ongoingAcc.bgl2AccessId = 0;
            ongoingAcc.l2timeBlocked = 0;
            ongoingAcc.l1timeBlocked = 1;
            // ongoingAcc.phase = AccessPhase::WaitForl1CACHE;
            L2Component.cache->update(ongoingAcc.access.addr,
                                      ongoingAcc.access.load_store, false,
                                      ongoingAcc.cl);
          }
        } else {
          //访问主存后
          if (ongoingAcc.l2timeBlocked == 1) {
            L2Component.cache->update(ongoingAcc.access.addr,
                                      ongoingAcc.access.load_store, false,
                                      ongoingAcc.cl);
            ongoingAcc.l2timeBlocked = 0;
          }
          if (ongoingAcc.l1timeBlocked > 0) {
            ongoingAcc.l1timeBlocked--;
          }

          /* check if we are ready to progress */
          if (ongoingAcc.l1timeBlocked == 0) {
            Access acc = ongoingAcc.access;
            AbstractAddress addr = ongoingAcc.access.addr;
            AccessType accType = ongoingAcc.access.load_store;
            if (needAccessedDataAddresses()) {
              dataComponent.justUpdatedCache = addr;
            }
            bool mightMiss =
                ongoingAcc.cl == CL2_MISS || ongoingAcc.cl == CL2_UNKNOWN;
            bool isWBCache = dataComponent.cache->getWritePolicy().WriteBack;

            /* In the absence of any further information assume any access
             * causes a writeback and any store is dirtifying */
            boost::optional<AbstractAddress> WBVictimItv(
                AbstractAddress::getUnknownAddress());

            /* we are interested in the report for dirtifying stores and
             * writebacks
             */
            bool wantReport =
                isWBCache && (mightMiss || accType == AccessType::STORE);
            UpdateReport *report = dataComponent.cache->update(
                addr, accType, wantReport, ongoingAcc.cl);
            if (isWBCache) {
              /* If the report is a WriteBackReport improve our
               * writeback/dirtifying store information */
              auto wbreport = dynamic_cast<WritebackReport *>(report);
              if (wbreport && StaticallyRefuteWritebacks) {
                WBVictimItv = wbreport->potentialWritebacks();
              }
              if (accType == AccessType::STORE) {
                dataComponent.justDirtifiedLine = acc.addr;
                if (WBBound == WBBoundType::DIRTIFYING_STORE && wbreport &&
                    !wbreport->dirtifyingStore) {
                  dataComponent.justDirtifiedLine = boost::none;
                }
              }

              if (mightMiss) {
                AnalysisResults::getInstance().incrementResult("staticMisses");
                if (!WBVictimItv) {
                  AnalysisResults::getInstance().incrementResult(
                      "staticallyRefutedWritebacks");
                }
              }
            }

            if (accType == AccessType::STORE && !isWBCache) {
              // Write-through policy and we have a store
              // We want to launch a store to the address we were accessing
              // originally
              auto res =
                  memory.accessData(acc.addr, AccessType::STORE, acc.numWords);
              if (res) {
                ongoingAcc.bgMemAccessId = res.get();
              } else {
                ongoingAcc.bgmemStall = true;
              }
              ongoingAcc.phase = AccessPhase::WaitForSTORE;
              ++dataComponent.numStoreBusAccess;
            }
            /* We split if we cannot prove there is no writeback
   TODO should we try to prove that there *is* a
   writeback to save a split? It might also help when we add
   storebuffers, since it might draw writeback budget away from more
   critical points */
            else if (isWBCache && mightMiss && WBVictimItv) {
              JJYSeparateCachesMemoryTopology scmtNoWriteback(*this);
              scmtNoWriteback.dataComponent.finishedId =
                  scmtNoWriteback.dataComponent.ongoingAccess.get().access.id;
              scmtNoWriteback.dataComponent.ongoingAccess = boost::none;
              resultList.push_back(scmtNoWriteback);
              //写回策略改动标记
              // We should do a write-back
              auto res = memory.accessData(WBVictimItv.get(), AccessType::STORE,
                                           Dlinesize / 4);
              assert(res && "Background Memory Topology rejected data access!");
              ongoingAcc.bgMemAccessId = res.get();
              ongoingAcc.phase = AccessPhase::WaitForSTORE;

              ++dataComponent.numStoreBusAccess;
              dataComponent.justWroteBackLine = true;
            } else { // We are finished, nothing left to do
              dataComponent.finishedId =
                  dataComponent.ongoingAccess.get().access.id;
              dataComponent.ongoingAccess = boost::none;
            }

            if (isWBCache && dataComponent.justDirtifiedLine) {
              /* split the states to allow restricting the
               * dfs by persistence constraints */
              JJYSeparateCachesMemoryTopology noDFSsplit(*this);
              noDFSsplit.dataComponent.justDirtifiedLine = boost::none;
              resultList.push_back(noDFSsplit);
            }
            delete report;
          }
        }
      } else if (ongoingAcc.phase == AccessPhase::WaitForSTORE) {
        assert((ongoingAcc.bgMemAccessId != 0) &&
               "Waiting for store but not accessing anything");
        if (UnblockStores) { // If option for unblocking stores is set, finish
                             // access directly
          dataComponent.finishedId = ongoingAcc.access.id;
          dataComponent.ongoingAccess = boost::none;
        } else {
          // We wait for the store to finish before signaling finish to the
          // outside
          if (ongoingAcc.bgMemAccessId > 0
                  ? memory.finishedDataAccess(ongoingAcc.bgMemAccessId)
                  : false) {
            dataComponent.finishedId = ongoingAcc.access.id;
            dataComponent.ongoingAccess = boost::none;
          }
        }
      }
    }
  }

  resultList.push_back(*this);
  return resultList;
}

template <AbstractCache *(*makeInstrCache)(bool),
          AbstractCache *(*makeDataCache)(bool),
          AbstractCache *(*makeL2Cache)(bool), class BgMem>
void JJYSeparateCachesMemoryTopology<
    makeInstrCache, makeDataCache, makeL2Cache,
    BgMem>::processInstrCacheAccess(Classification cl) {
  // Remember Classification
  auto &ongoingAcc = instructionComponent.ongoingAccess.get();
  ongoingAcc.cl = cl; // hit/l2hit/l2miss/
  // We do not think this code do actual work, so just ignore them.

  if (cl == CL_HIT) {
    ongoingAcc.l1timeBlocked = instructionComponent.cache->getHitLatency();
    ongoingAcc.bgl2AccessId = 0;
    ongoingAcc.bgMemAccessId = 0;

  } else if (cl == CL2_HIT) {
    ++instructionComponent.l1nmisses;
    Access acc = ongoingAcc.access;
    ongoingAcc.l2timeBlocked = L2Latency;
    if (InstrCachePersType != PersistenceType::NONE || PreemptiveExecution) {
      // We just missed the instr cache (only needed for persistence analysis
      // and integrated preemptive execution mode)
      assert(acc.addr.isPrecise());
      instructionComponent.justMissedCache =
          AbstractAddress(instructionComponent.cache->alignToCacheline(
              acc.addr.getAsInterval().lower()));
    }
    boost::optional<unsigned> res =
        memory.l2accessInstr(acc.addr.getAsInterval().lower(),
                             Ilinesize / 4); //指令取的字节数固定
    if (res) {
      ongoingAcc.bgl2AccessId = *res;
      ongoingAcc.bgMemAccessId = 0;
    } else {
      assert(false &&
             "Background memory topology rejected instruction access.");
    }

  } else {
    ++instructionComponent.l1nmisses;
    ++instructionComponent.l2nmisses;
    Access acc = ongoingAcc.access;

    // if (InstrCachePersType != PersistenceType::NONE || PreemptiveExecution) {
    //   // We just missed the instr cache (only needed for persistence analysis
    //   // and integrated preemptive execution mode)
    //   assert(acc.addr.isPrecise());
    //   instructionComponent.justMissedCache =
    //       AbstractAddress(instructionComponent.cache->alignToCacheline(
    //           acc.addr.getAsInterval().lower()));
    // }

    // jjy:we add l2Cache persistence analysis
    if (L2CachePersType != PersistenceType::NONE || PreemptiveExecution) {
      assert(acc.addr.isPrecise());
      L2Component.justMissedCache =
          AbstractAddress(L2Component.cache->alignToCacheline(
              acc.addr.getAsInterval().lower()));
    }
    boost::optional<unsigned> res = memory.accessInstr(
        acc.addr.getAsInterval().lower(), Ilinesize / 4); //指令取的字节数固定
    if (res) {
      ongoingAcc.bgMemAccessId = *res;
    } else {
      assert(false &&
             "Background memory topology rejected instruction access.");
    }
  }
}

template <AbstractCache *(*makeInstrCache)(bool),
          AbstractCache *(*makeDataCache)(bool),
          AbstractCache *(*makeL2Cache)(bool), class BgMem>
void JJYSeparateCachesMemoryTopology<
    makeInstrCache, makeDataCache, makeL2Cache,
    BgMem>::processDataCacheAccess(Classification cl) {
  auto &ongoingAcc = dataComponent.ongoingAccess.get();
  ongoingAcc.cl = cl;

  if (cl == CL_HIT) { // We hit the cache (in case we load and in case we store)
    ongoingAcc.l1timeBlocked = dataComponent.cache->getHitLatency();
    ongoingAcc.phase = AccessPhase::WaitForCACHE;
  } else if (cl == CL2_HIT) {
    Access acc = dataComponent.ongoingAccess.get().access;
    dataComponent.l1nmisses++;
    auto res = memory.l2accessData(acc.addr, AccessType::LOAD, Dlinesize / 4);
    if (res) {
      ongoingAcc.bgl2AccessId = res.get();
    } else {
      ongoingAcc.bgmemStall = true;
    }
    ongoingAcc.l2timeBlocked = L2Latency;
    ongoingAcc.phase = AccessPhase::WaitForCACHE;
    if (DataCachePersType != PersistenceType::NONE || PreemptiveExecution) {
      // We just missed the data cache (only needed for persistence analysis
      // and integrated preemptive execution mode)
      if (dataComponent.cache->alignToCacheline(
              acc.addr.getAsInterval().lower()) ==
          dataComponent.cache->alignToCacheline(
              acc.addr.getAsInterval().upper())) {
        dataComponent.justMissedCache =
            AbstractAddress(dataComponent.cache->alignToCacheline(
                acc.addr.getAsInterval().lower()));
      } else if (acc.addr.isArray()) {
        /* TODO we should have a way to tell addr about alignment, such that
         * getAsInterval() returns correctly aligned bounds. For now just
         * don't call getAsInterval on the justMissedCache member */
        dataComponent.justMissedCache = acc.addr;
      }
    }

  } else {
    Access acc = dataComponent.ongoingAccess.get().access;
    // What shall we do?
    if (acc.load_store == AccessType::STORE &&
        !dataComponent.cache->getWritePolicy().WriteAllocate) {
      // We store (missed) write-non-allocate
      assert(!dataComponent.cache->getWritePolicy().WriteBack &&
             "Only write-through can be non-write-allocate");

      auto res = memory.accessData(acc.addr, AccessType::STORE, acc.numWords);
      if (res) {
        ongoingAcc.bgMemAccessId = res.get();
      } else {
        ongoingAcc.bgmemStall = true;
      }
      ongoingAcc.phase = AccessPhase::WaitForSTORE;
      ++dataComponent.numStoreBusAccess;
    } else {
      // jjy:we add l2Cache persistence analysis
      if (L2CachePersType != PersistenceType::NONE || PreemptiveExecution) {
        if (L2Component.cache->alignToCacheline(
                acc.addr.getAsInterval().lower()) ==
            L2Component.cache->alignToCacheline(
                acc.addr.getAsInterval().upper())) {
          L2Component.justMissedCache =
              AbstractAddress(L2Component.cache->alignToCacheline(
                  acc.addr.getAsInterval().lower()));
        } else if (acc.addr.isArray()) {
          L2Component.justMissedCache = acc.addr;
        }
      }
      // Only in these cases, we account for misses
      auto res = memory.accessData(acc.addr, AccessType::LOAD, Dlinesize / 4);
      if (res) {
        ongoingAcc.bgMemAccessId = res.get();
      } else {
        ongoingAcc.bgmemStall = true;
      }
      ++dataComponent.l2nmisses;
      dataComponent.l1nmisses++;
      ongoingAcc.phase = AccessPhase::WaitForLOAD; // We wait for the load
    }
  }
}

template <AbstractCache *(*makeInstrCache)(bool),
          AbstractCache *(*makeDataCache)(bool),
          AbstractCache *(*makeL2Cache)(bool), class BgMem>
bool JJYSeparateCachesMemoryTopology<makeInstrCache, makeDataCache, makeL2Cache,
                                     BgMem>::shouldPipelineStall() const {
  return memory.shouldPipelineStall();
}

template <AbstractCache *(*makeInstrCache)(bool),
          AbstractCache *(*makeDataCache)(bool),
          AbstractCache *(*makeL2Cache)(bool), class BgMem>
bool JJYSeparateCachesMemoryTopology<
    makeInstrCache, makeDataCache, makeL2Cache,
    BgMem>::operator==(const JJYSeparateCachesMemoryTopology &scmt) const {
  bool result =
      memory == scmt.memory &&
      instructionComponent.equals(scmt.instructionComponent, currentId,
                                  scmt.currentId) &&
      dataComponent.equals(scmt.dataComponent, currentId, scmt.currentId) &&
      L2Component.equals(scmt.L2Component, currentId, scmt.currentId) &&
      justEntered == scmt.justEntered;
  return result;
}

// jjy：看情况改
template <AbstractCache *(*makeInstrCache)(bool),
          AbstractCache *(*makeDataCache)(bool),
          AbstractCache *(*makeL2Cache)(bool), class BgMem>
size_t JJYSeparateCachesMemoryTopology<makeInstrCache, makeDataCache,
                                       makeL2Cache, BgMem>::hashcode() const {
  size_t res = 0;
  // hash_combine(res, this->instructionComponent.cache);
  // hash_combine(res, this->dataComponent.cache);
  // TODO fix hashing error first
  hash_combine_hashcode(res, this->memory);
  // TODO hash queues here
  if (instructionComponent.ongoingAccess) {
    Super::hash_access(res, instructionComponent.ongoingAccess.get().access,
                       this->currentId);
    hash_combine(res, instructionComponent.ongoingAccess.get().l1timeBlocked);
    // hash_combine(res,
    // instructionComponent.ongoingAccess.get().l2timeBlocked);
  }
  if (dataComponent.ongoingAccess) {
    Super::hash_access(res, dataComponent.ongoingAccess.get().access,
                       this->currentId);
    hash_combine(res, dataComponent.ongoingAccess.get().l1timeBlocked);
    // memory->l2cache 会计算timeblock
    //  hash_combine(res, dataComponent.ongoingAccess.get().l2timeBlocked);
  }
  if (instructionComponent.finishedId != 0)
    hash_combine(res, instructionComponent.finishedId - this->currentId);
  if (dataComponent.finishedId != 0)
    hash_combine(res, dataComponent.finishedId - this->currentId);
  return res;
}

template <AbstractCache *(*makeInstrCache)(bool),
          AbstractCache *(*makeDataCache)(bool),
          AbstractCache *(*makeL2Cache)(bool), class BgMem>
bool JJYSeparateCachesMemoryTopology<makeInstrCache, makeDataCache, makeL2Cache,
                                     BgMem>::isWaitingForJoin() const {
  return memory.isWaitingForJoin();
}

template <AbstractCache *(*makeInstrCache)(bool),
          AbstractCache *(*makeDataCache)(bool),
          AbstractCache *(*makeL2Cache)(bool), class BgMem>
bool JJYSeparateCachesMemoryTopology<
    makeInstrCache, makeDataCache, makeL2Cache,
    BgMem>::isJoinable(const JJYSeparateCachesMemoryTopology &scmt) const {
  return memory.isJoinable(scmt.memory) &&
         // caches are assumed to be joinable, so are justMissed
         instructionComponent.equalsWithoutCache(scmt.instructionComponent,
                                                 currentId, scmt.currentId) &&
         dataComponent.equalsWithoutCache(scmt.dataComponent, currentId,
                                          scmt.currentId) &&
         L2Component.equalsWithoutCache(scmt.L2Component, currentId,
                                        scmt.currentId) &&
         justEntered == scmt.justEntered;
}

template <AbstractCache *(*makeInstrCache)(bool),
          AbstractCache *(*makeDataCache)(bool),
          AbstractCache *(*makeL2Cache)(bool), class BgMem>
void JJYSeparateCachesMemoryTopology<
    makeInstrCache, makeDataCache, makeL2Cache,
    BgMem>::join(const JJYSeparateCachesMemoryTopology &scmt) {
  assert(isJoinable(scmt) && "Cannot join non-joinable states.");

  // Join sub-components
  memory.join(scmt.memory);
  instructionComponent.joinCache(scmt.instructionComponent);
  dataComponent.joinCache(scmt.dataComponent);
  L2Component.joinCache(scmt.L2Component);

  // Everything id related is just kept, as it is equal (relative to the
  // absolute id) anyway. Not that this makes the join non-symmetric w.r.t.
  // absolute id's but to relative id's.
}

template <AbstractCache *(*makeInstrCache)(bool),
          AbstractCache *(*makeDataCache)(bool),
          AbstractCache *(*makeL2Cache)(bool), class BgMem>
bool JJYSeparateCachesMemoryTopology<makeInstrCache, makeDataCache, makeL2Cache,
                                     BgMem>::isBusyAccessingInstr() const {
  return !instructionComponent.waitingQueue.empty() ||
         instructionComponent.ongoingAccess;
}

template <AbstractCache *(*makeInstrCache)(bool),
          AbstractCache *(*makeDataCache)(bool),
          AbstractCache *(*makeL2Cache)(bool), class BgMem>
bool JJYSeparateCachesMemoryTopology<makeInstrCache, makeDataCache, makeL2Cache,
                                     BgMem>::isBusyAccessingData() const {
  return !dataComponent.waitingQueue.empty() || dataComponent.ongoingAccess;
}
// jjy：待改
template <AbstractCache *(*makeInstrCache)(bool),
          AbstractCache *(*makeDataCache)(bool),
          AbstractCache *(*makeL2Cache)(bool), class BgMem>
std::list<JJYSeparateCachesMemoryTopology<makeInstrCache, makeDataCache,
                                          makeL2Cache, BgMem>>
JJYSeparateCachesMemoryTopology<makeInstrCache, makeDataCache, makeL2Cache,
                                BgMem>::fastForward() const {
  std::list<JJYSeparateCachesMemoryTopology> res;

  bool instrCompIdle = !isBusyAccessingInstr();
  bool dataCompIdle = !isBusyAccessingData();

  bool instrCompAllowsFastForward =
      (instrCompIdle ||
       (instructionComponent.ongoingAccess &&
        (instructionComponent.ongoingAccess.get().bgMemAccessId != 0 ||
         instructionComponent.ongoingAccess.get().bgl2AccessId != 0))) &&
      instructionComponent.justMissedCache ==
          boost::none // Do not forget any events
      && L2Component.justMissedCache == boost::none &&
      instructionComponent.justUpdatedCache == boost::none;

  bool dataCompAllowsFastForward =
      (dataCompIdle ||
       (dataComponent.ongoingAccess &&
        (dataComponent.ongoingAccess->phase == AccessPhase::WaitForLOAD ||
         dataComponent.ongoingAccess.get().bgl2AccessId != 0 ||
         ((!UnblockStores || dataComponent.ongoingAccess->bgmemStall) &&
          dataComponent.ongoingAccess->phase == AccessPhase::WaitForSTORE)))) &&
      dataComponent.justMissedCache == boost::none &&
      L2Component.justMissedCache == boost::none // Do not forget any events
      && dataComponent.justUpdatedCache == boost::none;

  if (instrCompAllowsFastForward && dataCompAllowsFastForward &&
      justEntered == boost::none) {
    // fast-forward the inner memory, then return
    for (auto &forwardedInnerMem : memory.fastForward()) {
      auto copy = res.emplace(res.end(), *this);
      copy->memory = forwardedInnerMem;
    }
    return res;
  }

  // return an unchanged copy
  res.emplace(res.end(), *this);
  return res;
}
// jjy：待改
template <AbstractCache *(*makeInstrCache)(bool),
          AbstractCache *(*makeDataCache)(bool),
          AbstractCache *(*makeL2Cache)(bool), class BgMem>
std::ostream &
operator<<(std::ostream &stream,
           const JJYSeparateCachesMemoryTopology<makeInstrCache, makeDataCache,
                                                 makeL2Cache, BgMem> &scmt) {
  if (scmt.justEntered) {
    stream << "Just entered Scopes ";
    bool comma = false;
    for (auto &scope : scmt.justEntered.get()) {
      if (comma) {
        stream << ", ";
      }
      stream << scope.getId();
      comma = true;
    }
    stream << "\n";
  }

  if (scmt.instructionComponent.waitingQueue.size() > 0) {
    stream << " Instruction element in cache queue: ";
    MemoryTopologyInterface<JJYSeparateCachesMemoryTopology<
        makeInstrCache, makeDataCache, makeL2Cache, BgMem>>::
        outputAccess(stream, scmt.instructionComponent.waitingQueue.front(),
                     true, scmt.currentId);
  } else {
    stream << " Instruction cache queue empty.\n";
  }
  // dot图不输出cache改动

  stream << "Instruction Cache:\n " << *scmt.instructionComponent.cache << "\n";
  stream << "L2Misses up to now: " << scmt.instructionComponent.l2nmisses
         << "\n";
  stream << "L1Misses up to now: " << scmt.instructionComponent.l1nmisses
         << "\n";
  if (scmt.instructionComponent.justUpdatedCache) {
    stream << "Just updated: "
           << scmt.instructionComponent.justUpdatedCache.get() << "\n";
  }

  stream << "Currently accessed in Instruction Cache: ";
  if (scmt.instructionComponent.ongoingAccess) {
    MemoryTopologyInterface<JJYSeparateCachesMemoryTopology<
        makeInstrCache, makeDataCache, makeL2Cache, BgMem>>::
        outputAccess(stream,
                     scmt.instructionComponent.ongoingAccess.get().access, true,
                     scmt.currentId);
    stream << "Access Phase: "
           << (int)scmt.instructionComponent.ongoingAccess.get().phase << "\n";
    stream << "BgMem Stall: "
           << scmt.instructionComponent.ongoingAccess.get().bgmemStall << "\n";
    stream << "l1Cache TimeBlocked: "
           << scmt.instructionComponent.ongoingAccess.get().l1timeBlocked
           << "\n";
    // stream << "l2Cache TimeBlocked: "
    //        << scmt.instructionComponent.ongoingAccess.get().l2timeBlocked
    //        << "\n";
    stream << "Classification: "
           << scmt.instructionComponent.ongoingAccess.get().cl << "\n";
  } else {
    stream << "Nothing accessed.\n";
  }

  stream << "Finished Instruction Access in SCMT, relative ID: ";
  if (scmt.instructionComponent.finishedId != 0) {
    stream << (int)(scmt.instructionComponent.finishedId - scmt.currentId)
           << "\n";
  } else {
    stream << "Nothing finished.\n";
  }

  if (scmt.dataComponent.waitingQueue.size() > 0) {
    stream << "Data element in cache queue: ";
    MemoryTopologyInterface<JJYSeparateCachesMemoryTopology<
        makeInstrCache, makeDataCache, makeL2Cache,
        BgMem>>::outputAccess(stream, scmt.dataComponent.waitingQueue.front(),
                              false, scmt.currentId);
  } else {
    stream << "Data cache queue empty.\n";
  }

  stream << "Data Cache:\n " << *scmt.dataComponent.cache;
  stream << "L2Misses up to now: " << scmt.dataComponent.l2nmisses << "\n";
  stream << "L1Misses up to now: " << scmt.dataComponent.l1nmisses << "\n";
  stream << "L2 Cache:\n ";
  scmt.L2Component.cache->dump(stream);
  stream << "Stores to bus up to now: " << scmt.dataComponent.numStoreBusAccess
         << "\n";
  if (scmt.dataComponent.justUpdatedCache) {
    stream << "Just updated: " << scmt.dataComponent.justUpdatedCache.get()
           << "\n";
  }
  if (scmt.dataComponent.justDirtifiedLine) {
    stream << "Just dirtified cacheline\n";
  }
  if (scmt.dataComponent.justWroteBackLine) {
    stream << "Just wrote back cacheline\n";
  }

  stream << "Currently accessed in Data Cache: ";
  if (scmt.dataComponent.ongoingAccess) {
    MemoryTopologyInterface<JJYSeparateCachesMemoryTopology<
        makeInstrCache, makeDataCache, makeL2Cache, BgMem>>::
        outputAccess(stream, scmt.dataComponent.ongoingAccess.get().access,
                     false, scmt.currentId);
    stream << "Access Phase: "
           << (int)scmt.dataComponent.ongoingAccess.get().phase << "\n";
    stream << "BgMem Stall: "
           << scmt.dataComponent.ongoingAccess.get().bgmemStall << "\n";
    stream << "l1Cache TimeBlocked: "
           << scmt.dataComponent.ongoingAccess.get().l1timeBlocked << "\n";
    // stream << "l2Cache TimeBlocked: "
    //        << scmt.dataComponent.ongoingAccess.get().l2timeBlocked << "\n";
    stream << "Classification: " << scmt.dataComponent.ongoingAccess.get().cl
           << "\n";
  } else {
    stream << "Nothing accessed.\n";
  }

  stream << "Finished DataAccess in SCMT, relative ID: ";
  if (scmt.dataComponent.finishedId != 0) {
    stream << (int)(scmt.dataComponent.finishedId - scmt.currentId) << "\n";
  } else {
    stream << "Nothing finished\n";
  }

  stream << "Background Topology: \n" << scmt.memory;
  return stream;
}

} // namespace TimingAnalysisPass

#endif
