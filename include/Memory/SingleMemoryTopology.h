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

#ifndef SINGLEMEMORYTOPOLOGY_H
#define SINGLEMEMORYTOPOLOGY_H

#include "llvm/Support/Debug.h"

#include "Memory/AbstractCyclingMemory.h"
#include "Memory/MemoryTopologyInterface.h"
#include <cassert>
#include <list>

namespace TimingAnalysisPass {

/**
 * Class representing a memory topology without a cache, with one memory
 * component.
 *
 * The type parameter Memory is assumed to be inherited from
 * AbstractCyclingMemory.
 */
template <AbstractCyclingMemory *(*makeBgMem)()>
class SingleMemoryTopology
    : public MemoryTopologyInterface<SingleMemoryTopology<makeBgMem>> {
public:
  SingleMemoryTopology();

  SingleMemoryTopology(const SingleMemoryTopology &ncmt);

  ~SingleMemoryTopology() { delete memory; }

  SingleMemoryTopology &operator=(const SingleMemoryTopology &ncmt);

  /**
   * Container used to make the local metrics of this class
   * available to the world outside.
   */
  struct LocalMetrics {
    // the fields added to the local metrics used as base
    typename AbstractCyclingMemory::LocalMetrics *memory;

    /**
     * Creates the local metrics based on the
     * outer class' content.
     */
    LocalMetrics(const SingleMemoryTopology &outerClassInstance)
        : memory(outerClassInstance.memory->getLocalMetrics()) {}

    ~LocalMetrics() { delete memory; }

    /**
     * Checks for equality between local metrics.
     */
    bool operator==(const LocalMetrics &anotherInstance) {
      return memory->equals(*anotherInstance.memory);
    }
  };

  /**
   * Resets the local metrics to their initial values.
   */
  void resetLocalMetrics() {
    memory->resetLocalMetrics();
    l2Cache->resetLocalMetrics();
  }

  /**
   * Tells the memory topology to access an instruction.
   * Returns the id for that instruction or none, if something is already
   * accessed.
   */
  virtual boost::optional<unsigned> accessInstr(unsigned addr,
                                                unsigned numWords);
  boost::optional<unsigned> l2accessInstr(unsigned addr, unsigned numWords);
  /**
   * Tells the memory topology to access an instruction.
   * Returns the id for that instruction or none, if something is already
   * accessed.
   */
  virtual boost::optional<unsigned>
  accessData(AbstractAddress addr, AccessType load_store, unsigned numWords);
  boost::optional<unsigned>
  l2accessData(AbstractAddress addr, AccessType load_store, unsigned numWords);
  /**
   * Cycle method for the memory topology.
   * This method should be called by the pipeline.
   *
   * The bool parameter says whether there are potential data misses pending
   * between the fetch and memory phase. A strictly in-order pipeline requires
   * stalling fetch misses.
   *
   * Returns a list of resulting memory topology states.
   */
  virtual std::list<SingleMemoryTopology>
  cycle(bool potentialDataMissesPending) const;

  /**
   * Ask underlying background memory if the pipeline should stall.
   */
  virtual bool shouldPipelineStall() const;

  /**
   * Returns whether a given ID (instruction access) has been finished.
   * If so, reset instruction access finished.
   */
  virtual bool finishedInstrAccess(unsigned accessId);
  virtual bool l2finishedInstrAccess(unsigned accessId);

  /**
   * Returns whether a given ID (data access) has been finished.
   * If so, reset data access finished.
   */
  virtual bool finishedDataAccess(unsigned accessId);
  virtual bool l2finishedDataAccess(unsigned accessId);

  virtual bool hasUnfinishedAccesses() const;

  virtual bool operator==(const SingleMemoryTopology &ncmt2) const;

  virtual size_t hashcode() const;

  /**
   * Is the memory topology waiting to be joined with similar topologies?
   */
  virtual bool isWaitingForJoin() const;

  virtual bool isJoinable(const SingleMemoryTopology &ncmt) const;

  virtual void join(const SingleMemoryTopology &ncmt);

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
  virtual std::list<SingleMemoryTopology> fastForward() const;

  template <AbstractCyclingMemory *(*makeBgMemf)()>
  friend std::ostream &operator<<(std::ostream &stream,
                                  const SingleMemoryTopology<makeBgMemf> &ncmt);

private:
  /**
   * Increments the current ID.
   * Skips 0.
   */
  void incrementCurrentId();

  typedef MemoryTopologyInterface<SingleMemoryTopology> Super;

  typedef typename Super::Access Access;

  /**
   * Accesses the memory with the given element.
   * Returns a list of resulting memory topology states.
   * @param isL2, check is L2 Access
   */
  std::list<SingleMemoryTopology> accessMemory(Access accessElement) const;
  std::list<SingleMemoryTopology> accessL2(Access accessElement) const;

  /**
   * Finishes the current access, i.e. make it available for the pipeline.
   */
  void finishAccess();
  void l2finishAccess();

  // Reference to the memory
  AbstractCyclingMemory *memory, *l2Cache;

  /**
   * Queue to store all incoming instruction accesses.
   */
  std::list<Access> instructionQueue, l2instrQueue;

  /**
   * Queue to store all incoming data accesses.
   */
  std::list<Access> dataQueue, l2dataQueue;

  /**
   * Counter to provide a new identifier for each access.
   * Starts counting with 1, cf. currentIdAccessed.
   */
  unsigned currentId;

  /**
   * Stores the id currently being accessed by the topology.
   * 0 means there is currently no access being processed.
   */
  unsigned currentIdAccessed, currentIdAccessedl2;

  /**
   * Stores the ID of the access which finished in the last cycle.
   */
  unsigned finishedAccess, l2finishedAccess;

  /**
   * Remembers if the access behind currentIdAccessed
   * accesses an instruction or data.
   */
  bool currentIdAccessesInstr;

  /**
   * Used to remember whether the topology is waiting for
   * join or not. The logical information on which this
   * depends is unfortunately volatile and no longer
   * available when we actually ask if waiting for join.
   */
  bool waitingForJoin;
};

template <AbstractCyclingMemory *(*makeBgMem)()>
SingleMemoryTopology<makeBgMem>::SingleMemoryTopology()
    : memory(makeBgMem()), l2Cache(makeBgMem()), currentId(1), // Skip 0 here.
      currentIdAccessed(0), finishedAccess(0), currentIdAccessesInstr(false),
      waitingForJoin(false), currentIdAccessedl2(0), l2finishedAccess(0) {}

template <AbstractCyclingMemory *(*makeBgMem)()>
SingleMemoryTopology<makeBgMem>::SingleMemoryTopology(
    const SingleMemoryTopology &ncmt)
    : memory(ncmt.memory->clone()), l2Cache(ncmt.l2Cache->clone()),
      instructionQueue(ncmt.instructionQueue), dataQueue(ncmt.dataQueue),
      l2instrQueue(ncmt.l2instrQueue), l2dataQueue(ncmt.l2dataQueue),
      currentId(ncmt.currentId), currentIdAccessed(ncmt.currentIdAccessed),
      currentIdAccessedl2(ncmt.currentIdAccessedl2),
      finishedAccess(ncmt.finishedAccess),
      l2finishedAccess(ncmt.l2finishedAccess),
      currentIdAccessesInstr(ncmt.currentIdAccessesInstr),
      waitingForJoin(ncmt.waitingForJoin) {}

template <AbstractCyclingMemory *(*makeBgMem)()>
SingleMemoryTopology<makeBgMem> &
SingleMemoryTopology<makeBgMem>::operator=(const SingleMemoryTopology &ncmt) {
  delete memory;
  delete l2Cache;
  memory = ncmt.memory->clone();
  instructionQueue = ncmt.instructionQueue;
  dataQueue = ncmt.dataQueue;
  currentId = ncmt.currentId;
  currentIdAccessed = ncmt.currentIdAccessed;
  finishedAccess = ncmt.finishedAccess;
  currentIdAccessesInstr = ncmt.currentIdAccessesInstr;
  waitingForJoin = ncmt.waitingForJoin;
  // L2
  l2Cache = ncmt.l2Cache->clone();
  l2instrQueue = ncmt.l2instrQueue;
  l2dataQueue = ncmt.l2dataQueue;
  l2finishedAccess = ncmt.l2finishedAccess;
  currentIdAccessedl2 = ncmt.currentIdAccessedl2;
  return *this;
}

template <AbstractCyclingMemory *(*makeBgMem)()>
boost::optional<unsigned>
SingleMemoryTopology<makeBgMem>::accessInstr(unsigned addr, unsigned numWords) {
  // When we have caches, we need full cacheline fetch
  assert((MemTopType != MemoryTopologyType::SEPARATECACHES ||
          numWords == Ilinesize / 4) &&
         "Can only load full cachelines");

  // Override any preceding access here
  if (instructionQueue.size() > 0) {
    instructionQueue.pop_front();
  }
  unsigned resId = currentId;
  // create access element
  instructionQueue.push_back(
      Access(resId, AbstractAddress(addr), AccessType::LOAD, numWords));
  incrementCurrentId();
  return boost::optional<unsigned>(resId);
}

template <AbstractCyclingMemory *(*makeBgMem)()>
boost::optional<unsigned>
SingleMemoryTopology<makeBgMem>::l2accessInstr(unsigned addr,
                                               unsigned numWords) {
  // When we have caches, we need full cacheline fetch
  assert((MemTopType != MemoryTopologyType::SEPARATECACHES ||
          numWords == Ilinesize / 4) &&
         "Can only load full cachelines");

  // Override any preceding access here
  if (l2instrQueue.size() > 0) {
    l2instrQueue.pop_front();
  }
  unsigned resId = currentId;
  // create access element
  l2instrQueue.push_back(
      Access(resId, AbstractAddress(addr), AccessType::LOAD, numWords));
  incrementCurrentId();
  return boost::optional<unsigned>(resId);
}

template <AbstractCyclingMemory *(*makeBgMem)()>
boost::optional<unsigned> SingleMemoryTopology<makeBgMem>::accessData(
    AbstractAddress addr, AccessType load_store, unsigned numWords) {
  // When we have caches and a load, we need full cacheline fetch
  assert((MemTopType != MemoryTopologyType::SEPARATECACHES ||
          load_store != AccessType::LOAD || numWords == Dlinesize / 4) &&
         "Can only load full cachelines");

  unsigned resId;
  if (dataQueue.size() == 0) {
    resId = currentId;
    dataQueue.push_back(Access(resId, addr, load_store, numWords));
    incrementCurrentId();
    return boost::optional<unsigned>(resId);
  } else {
    return boost::none;
  }
}
template <AbstractCyclingMemory *(*makeBgMem)()>
boost::optional<unsigned> SingleMemoryTopology<makeBgMem>::l2accessData(
    AbstractAddress addr, AccessType load_store, unsigned numWords) {
  // When we have caches and a load, we need full cacheline fetch
  assert((MemTopType != MemoryTopologyType::SEPARATECACHES ||
          load_store != AccessType::LOAD || numWords == Dlinesize / 4) &&
         "Can only load full cachelines");

  unsigned resId;
  if (l2dataQueue.size() == 0) {
    resId = currentId;
    l2dataQueue.push_back(Access(resId, addr, load_store, numWords));
    incrementCurrentId();
    return boost::optional<unsigned>(resId);
  } else {
    return boost::none;
  }
}

template <AbstractCyclingMemory *(*makeBgMem)()>
void SingleMemoryTopology<makeBgMem>::incrementCurrentId() {
  currentId++;
  if (currentId == 0) { // prevent zero from begin used!
    currentId++;
  }
}

template <AbstractCyclingMemory *(*makeBgMem)()>
std::list<SingleMemoryTopology<makeBgMem>>
SingleMemoryTopology<makeBgMem>::cycle(bool potentialDataMissesPending) const {
  std::list<SingleMemoryTopology> res;

  res.push_back(*this);

  // get next element from the queue
  if (currentIdAccessed == 0) { // nothing is currently being accessed
    if (!dataQueue.empty()) {   // something is in the data queue, prioritize is
      res = accessMemory(dataQueue.front());
      for (auto &r : res) {
        r.dataQueue.pop_front();
        r.currentIdAccessesInstr = false;
      }
    } else {
      if (!instructionQueue.empty()) { // miss的
        // If data misses by previous instructions are still pending, wait for
        // them first in strictly in-order case
        if (!enableStrictInorderDataInstrArbitration() ||
            !potentialDataMissesPending) {
          assert(!potentialDataMissesPending &&
                 "Here we should see a difference");
          res = accessMemory(instructionQueue.front()); //算访问内存延迟
          for (auto &r : res) {
            r.instructionQueue.pop_front();
            r.currentIdAccessesInstr = true;
          }
        }
      }
    }
  }

  // get next element from the queue,l2 cache
  if (currentIdAccessedl2 == 0) { // nothing is currently being accessed

    if (!l2dataQueue.empty()) {
      res = accessL2(l2dataQueue.front());
      for (auto &r : res) {
        r.l2dataQueue.pop_front();
        r.currentIdAccessesInstr = false;
      }
    } else {
      if (!l2instrQueue.empty()) { // 层1 cache miss的
        // If data misses by previous instructions are still pending, wait for
        // them first in strictly in-order case
        if (!enableStrictInorderDataInstrArbitration() ||
            !potentialDataMissesPending) {
          assert(!potentialDataMissesPending &&
                 "Here we should see a difference");
          res = accessL2(l2instrQueue.front());
          for (auto &r : res) {
            r.l2instrQueue.pop_front();
            r.currentIdAccessesInstr = true;
          }
        }
      }
    }
  }

  std::list<SingleMemoryTopology> res2;
  for (SingleMemoryTopology &r : res) {
    // reset the waiting for join flag
    r.waitingForJoin = false;
    auto cycledMems = r.memory->cycle(); //--
    SingleMemoryTopology newInst(r);
    for (auto cM : cycledMems) {
      delete newInst.memory;
      newInst.memory = cM;
      newInst.finishedAccess = 0;
      if (newInst.currentIdAccessed > 0 && !newInst.memory->isBusy()) {
        // there was an access which finished!
        newInst.finishAccess();
      }
      assert(!(newInst.waitingForJoin && newInst.currentIdAccessed != 0) &&
             "Should not be waiting for join when something is accessed!");
    }
    cycledMems = r.l2Cache->cycle();
    for (auto cM : cycledMems) {
      delete newInst.l2Cache;
      newInst.l2Cache = cM;
      newInst.l2finishedAccess = 0;
      if (newInst.currentIdAccessedl2 > 0 && !newInst.l2Cache->isBusy()) {
        // there was an access which finished!
        newInst.l2finishAccess();
      }
      assert(!(newInst.waitingForJoin && newInst.currentIdAccessedl2 != 0 &&
               newInst.currentIdAccessed != 0) &&
             "Should not be waiting for join when something is accessed!");
    }
    res2.push_back(newInst);
  }
  return res2;
}

template <AbstractCyclingMemory *(*makeBgMem)()>
bool SingleMemoryTopology<makeBgMem>::shouldPipelineStall() const {
  return memory->shouldPipelineStall();
}

template <AbstractCyclingMemory *(*makeBgMem)()>
bool SingleMemoryTopology<makeBgMem>::finishedInstrAccess(unsigned id) {
  bool res = finishedAccess == id;
  if (res) {
    finishedAccess = 0;
  }
  return res;
}

template <AbstractCyclingMemory *(*makeBgMem)()>
bool SingleMemoryTopology<makeBgMem>::l2finishedInstrAccess(unsigned id) {
  bool res = l2finishedAccess == id;
  if (res) {
    l2finishedAccess = 0;
  }
  return res;
}

template <AbstractCyclingMemory *(*makeBgMem)()>
bool SingleMemoryTopology<makeBgMem>::finishedDataAccess(unsigned id) {
  bool res = finishedAccess == id;
  if (res) {
    finishedAccess = 0;
  }
  return res;
}

template <AbstractCyclingMemory *(*makeBgMem)()>
bool SingleMemoryTopology<makeBgMem>::l2finishedDataAccess(unsigned id) {
  bool res = l2finishedAccess == id;
  if (res) {
    l2finishedAccess = 0;
  }
  return res;
}
template <AbstractCyclingMemory *(*makeBgMem)()>
bool SingleMemoryTopology<makeBgMem>::hasUnfinishedAccesses() const {
  bool result = currentIdAccessed != 0 || !dataQueue.empty() ||
                !instructionQueue.empty() || !l2dataQueue.empty() ||
                !l2instrQueue.empty();
  return result;
}

template <AbstractCyclingMemory *(*makeBgMem)()>
std::list<SingleMemoryTopology<makeBgMem>>
SingleMemoryTopology<makeBgMem>::accessMemory(Access accessElement) const {
  std::list<SingleMemoryTopology> result;
  // Announce the access and build result list
  for (auto aR :
       memory->announceAccess(accessElement.addr, accessElement.load_store,
                              accessElement.numWords, false)) {
    SingleMemoryTopology altMT(*this);
    altMT.currentIdAccessed = accessElement.id;
    // Set new memory
    delete altMT.memory;
    altMT.memory = aR;
    altMT.memory->addaccessCounter();
    result.push_back(altMT);
  }
  return result;
}

template <AbstractCyclingMemory *(*makeBgMem)()>
std::list<SingleMemoryTopology<makeBgMem>>
SingleMemoryTopology<makeBgMem>::accessL2(Access accessElement) const {
  std::list<SingleMemoryTopology> result;
  // Announce the access and build result list
  for (auto aR :
       l2Cache->announceAccess(accessElement.addr, accessElement.load_store,
                               accessElement.numWords, true)) {
    SingleMemoryTopology altMT(*this);
    altMT.currentIdAccessedl2 = accessElement.id;
    // Set new l2 cache
    delete altMT.l2Cache;
    altMT.l2Cache = aR;
    altMT.memory->addaccessCounter();
    result.push_back(altMT);
  }
  return result;
}

template <AbstractCyclingMemory *(*makeBgMem)()>
void SingleMemoryTopology<makeBgMem>::finishAccess() {
  finishedAccess = currentIdAccessed;
  waitingForJoin = true;
  currentIdAccessed = 0;
}
template <AbstractCyclingMemory *(*makeBgMem)()>
void SingleMemoryTopology<makeBgMem>::l2finishAccess() {
  l2finishedAccess = currentIdAccessedl2;
  // TODO
  waitingForJoin = true;
  currentIdAccessedl2 = 0;
}
// TODO == operator | is similar/joinable
template <AbstractCyclingMemory *(*makeBgMem)()>
bool SingleMemoryTopology<makeBgMem>::operator==(
    const SingleMemoryTopology &ncmt) const {
  return memory->equals(*ncmt.memory) && l2Cache->equals(*ncmt.l2Cache) &&
         Super::areQueuesEqual(l2instrQueue, ncmt.l2instrQueue, currentId,
                               ncmt.currentId) &&
         Super::areQueuesEqual(l2dataQueue, ncmt.l2dataQueue, currentId,
                               ncmt.currentId) &&
         Super::areQueuesEqual(instructionQueue, ncmt.instructionQueue,
                               currentId, ncmt.currentId) &&
         Super::areQueuesEqual(dataQueue, ncmt.dataQueue, currentId,
                               ncmt.currentId) &&
         Super::areAccessIdsEqual(currentIdAccessedl2, ncmt.currentIdAccessedl2,
                                  currentId, ncmt.currentId) &&
         Super::areAccessIdsEqual(l2finishedAccess, ncmt.l2finishedAccess,
                                  currentId, ncmt.currentId) &&
         Super::areAccessIdsEqual(currentIdAccessed, ncmt.currentIdAccessed,
                                  currentId, ncmt.currentId) &&
         Super::areAccessIdsEqual(finishedAccess, ncmt.finishedAccess,
                                  currentId, ncmt.currentId) &&
         waitingForJoin == ncmt.waitingForJoin;
}

template <AbstractCyclingMemory *(*makeBgMem)()>
size_t SingleMemoryTopology<makeBgMem>::hashcode() const {
  size_t res = 0;
  hash_combine_hashcode(res, *this->memory);
  hash_combine_hashcode(res, *this->l2Cache);
  // TODO hash queue content
  if (currentIdAccessed != 0) {
    hash_combine(res, (this->currentIdAccessed - this->currentId));
  }
  if (finishedAccess != 0) {
    hash_combine(res, this->finishedAccess - this->currentId);
  }
  if (currentIdAccessedl2 != 0) {
    hash_combine(res, (this->currentIdAccessedl2 - this->currentId));
  }
  if (l2finishedAccess != 0) {
    hash_combine(res, this->l2finishedAccess - this->currentId);
  }
  hash_combine(res, waitingForJoin);
  return res;
}

template <AbstractCyclingMemory *(*makeBgMem)()>
bool SingleMemoryTopology<makeBgMem>::isWaitingForJoin() const {
  // if an access just finished, wait for join
  return waitingForJoin;
}

template <AbstractCyclingMemory *(*makeBgMem)()>
bool SingleMemoryTopology<makeBgMem>::isJoinable(
    const SingleMemoryTopology &ncmt) const {
  return memory->isJoinable(*ncmt.memory) &&
         l2Cache->isJoinable(*ncmt.l2Cache) &&
         Super::areQueuesEqual(l2instrQueue, ncmt.l2instrQueue, currentId,
                               ncmt.currentId) &&
         Super::areQueuesEqual(l2dataQueue, ncmt.l2dataQueue, currentId,
                               ncmt.currentId) &&
         Super::areQueuesEqual(instructionQueue, ncmt.instructionQueue,
                               currentId, ncmt.currentId) &&
         Super::areQueuesEqual(dataQueue, ncmt.dataQueue, currentId,
                               ncmt.currentId) &&
         Super::areAccessIdsEqual(currentIdAccessedl2, ncmt.currentIdAccessedl2,
                                  currentId, ncmt.currentId) &&
         Super::areAccessIdsEqual(l2finishedAccess, ncmt.l2finishedAccess,
                                  currentId, ncmt.currentId) &&
         Super::areAccessIdsEqual(currentIdAccessed, ncmt.currentIdAccessed,
                                  currentId, ncmt.currentId) &&
         Super::areAccessIdsEqual(finishedAccess, ncmt.finishedAccess,
                                  currentId, ncmt.currentId);
}

template <AbstractCyclingMemory *(*makeBgMem)()>
void SingleMemoryTopology<makeBgMem>::join(const SingleMemoryTopology &ncmt) {
  assert(isJoinable(ncmt) && "Cannot join non-joinable topologies.");

  // Everything id related is just kept, as it is equal (relative to the
  // absolute id) anyway. Not that this makes the join non-symmetric w.r.t.
  // absolute id's but to relative id's.

  waitingForJoin |= ncmt.waitingForJoin;

  // Join the subcomponent
  memory->join(*ncmt.memory);
  l2Cache->join(*ncmt.l2Cache);
}

template <AbstractCyclingMemory *(*makeBgMem)()>
bool SingleMemoryTopology<makeBgMem>::isBusyAccessingInstr() const {
  return !instructionQueue.empty() || !l2instrQueue.empty() ||
         ((currentIdAccessed > 0 || currentIdAccessedl2 > 0) &&
          currentIdAccessesInstr);
}

template <AbstractCyclingMemory *(*makeBgMem)()>
bool SingleMemoryTopology<makeBgMem>::isBusyAccessingData() const {
  return !dataQueue.empty() || !l2dataQueue.empty() ||
         ((currentIdAccessed > 0 || currentIdAccessedl2 > 0) &&
          !currentIdAccessesInstr);
}

template <AbstractCyclingMemory *(*makeBgMem)()>
std::list<SingleMemoryTopology<makeBgMem>>
SingleMemoryTopology<makeBgMem>::fastForward() const {
  std::list<SingleMemoryTopology> res;

  if (memory->isBusy()) {
    assert(currentIdAccessed > 0);
    // fast-forward the inner memory, then return
    for (auto forwardedInnerMem : memory->fastForward()) {
      auto copy = res.emplace(res.end(), *this);
      delete copy->memory;
      copy->memory = forwardedInnerMem;
    }
    return res;
  }
  if (l2Cache->isBusy()) {
    assert(currentIdAccessedl2 > 0);
    // fast-forward the inner memory, then return
    for (auto forwardedInnerMem : l2Cache->fastForward()) {
      auto copy = res.emplace(res.end(), *this);
      delete copy->l2Cache;
      copy->l2Cache = forwardedInnerMem;
    }
    return res;
  }

  // return an unchanged copy
  res.emplace(res.end(), *this);
  return res;
}

template <AbstractCyclingMemory *(*makeBgMemf)()>
std::ostream &operator<<(std::ostream &stream,
                         const SingleMemoryTopology<makeBgMemf> &ncmt) {
  stream << "[ SingleMemoryTopology \n"; //| CurrentId: " << ncmt.currentId <<
                                         //"\n";

  // Instruction Queue
  if (ncmt.instructionQueue.size() > 0) {
    assert(ncmt.instructionQueue.size() == 1 && "Too large instruction queue");
    stream << " Instruction element in queue: ";
    MemoryTopologyInterface<SingleMemoryTopology<makeBgMemf>>::outputAccess(
        stream, ncmt.instructionQueue.front(), true, ncmt.currentId);
  } else {
    stream << " Instruction queue empty.\n";
  }
  // Data Queue
  if (ncmt.dataQueue.size() > 0) {
    assert(ncmt.dataQueue.size() == 1 && "Too large data queue");
    stream << " Data element in queue: ";
    MemoryTopologyInterface<SingleMemoryTopology<makeBgMemf>>::outputAccess(
        stream, ncmt.dataQueue.front(), false, ncmt.currentId);
  } else {
    stream << " Data queue empty.\n";
  }
  stream << "Current relative Access ID: ";
  if (ncmt.currentIdAccessed == 0) {
    stream << "Nothing accessed.\n";
  } else {
    stream << (int)(ncmt.currentIdAccessed - ncmt.currentId) << ".\n";
  }
  if (ncmt.finishedAccess == 0) {
    stream << " No element finished just now. \n";
  } else {
    stream << " Element finished, relative ID: "
           << (int)(ncmt.finishedAccess - ncmt.currentId) << " \n";
  }
  stream << " waitingForJoin: " << ncmt.waitingForJoin << "\n";
  stream << "BackgroundL2cache:\n" << *ncmt.l2Cache << "\n";
  stream << "BackgroundMemory:\n" << *ncmt.memory << "\n";
  stream << "]\n";
  stream << "]\n";
  return stream;
}

} // namespace TimingAnalysisPass

#endif
