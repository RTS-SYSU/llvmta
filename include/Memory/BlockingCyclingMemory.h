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

#ifndef BLOCKINGCYCLINGMEMORY_H
#define BLOCKINGCYCLINGMEMORY_H

#include "Memory/AbstractCyclingMemory.h"
#include "Util/IntervalCounter.h"

#include <type_traits>

#include <boost/numeric/interval/io.hpp>
#include <boost/optional/optional.hpp>

#include <Memory/BlockingCyclingMemoryConfig.h>

namespace TimingAnalysisPass {

/**
 * Class implementing a cycling memory as a wrapper for an existing cycling
 * memory.
 *
 * It can be used to add blocking due to resource arbitration.
 * In this way, a non-shared memory can easily be extended to a shared memory.
 */
template <class Memory, const BlockingCyclingMemoryConfigType *Config>
class BlockingCyclingMemory : public AbstractCyclingMemory {
  static_assert(
      std::is_convertible<Memory *, AbstractCyclingMemory *>::value,
      "Type parameter MEMORY must be a descendant of AbstractCyclingMemory");

private:
  typedef AbstractCyclingMemory Base;

  static constexpr const unsigned &MaxBlockingPerAccess =
      Config->maxBlockingPerAccess;

protected:
  static constexpr const unsigned &AccessLatency = Config->accessLatency;

  BlockingCyclingMemory(const BlockingCyclingMemory<Memory, Config> &bcm2);

public:
  BlockingCyclingMemory();

  virtual BlockingCyclingMemory *clone() const;

  virtual ~BlockingCyclingMemory();

  /**
   * Container used to make the local metrics of this class
   * available to the world outside.
   */
  struct LocalMetrics : Memory::LocalMetrics {
    // shorthand for the base class
    typedef typename Memory::LocalMetrics LocalMetricsBase;

    // the fields added to the local metrics used as base
    IntervalCounter<true /*lower bound needed*/, true /*upper bound needed*/,
                    true /*perform join*/>
        fastForwardedBlocking;

    /**
     * Creates the local metrics based on the
     * outer class' content.
     */
    LocalMetrics(const BlockingCyclingMemory &outerClassInstance)
        : LocalMetricsBase(*outerClassInstance.memory),
          fastForwardedBlocking(outerClassInstance.fastForwardedBlocking) {}

    virtual ~LocalMetrics(){};

    /**
     * Checks for equality between local metrics.
     */
    virtual bool
    equals(const AbstractCyclingMemory::LocalMetrics &anotherInstance) {
      auto &castedInstance =
          dynamic_cast<const LocalMetrics &>(anotherInstance);
      return LocalMetricsBase::equals(castedInstance) &&
             fastForwardedBlocking == castedInstance.fastForwardedBlocking;
    }
  };

  /**
   * Restores the local metrics of this instance according
   * to the values specified in the container passed in.
   */
  virtual LocalMetrics *getLocalMetrics() { return new LocalMetrics(*this); }

  /**
   * Resets the local metrics to their initial values.
   */
  virtual void resetLocalMetrics() {
    fastForwardedBlocking = 0u;
    memory->resetLocalMetrics();
  }

  /**
   * Check if the memory is currently busy.
   */
  virtual bool isBusy() const;

  /**
   * Perform one clock cycle in the memory implementation.
   */
  virtual std::list<AbstractCyclingMemory *> cycle() const;

  /**
   * If we are just blocking and we want to stall on blocking, return true.
   * Otherwise false.
   */
  virtual bool shouldPipelineStall() const;

  /**
   * Since used in MicroArchitecturalStates, we need to know whether the memory
   * parts are the same.
   */
  virtual bool equals(const AbstractCyclingMemory &acm2) const;

  /**
   * Same as for the equality operator, this may be used by "higher" classes.
   */
  virtual size_t hashcode() const;

  virtual bool isJoinable(const AbstractCyclingMemory &acm2) const;

  virtual void join(const AbstractCyclingMemory &acm2);

  virtual void print(std::ostream &stream) const;

  /**
   * Implement how to announce a new access to the memory.
   */
  virtual std::list<AbstractCyclingMemory *>
  announceAccess(AbstractAddress addr, AccessType t, unsigned numWords) const;

  virtual std::list<AbstractCyclingMemory *> fastForward() const;

protected:
  /**
   * This hook increments the internal blocking counter.
   * It is intended to be overridden by child classes.
   */
  virtual void incrementAddedBlocking();

private:
  /**
   * Split cases only within the provable bounds.
   */
  virtual std::list<BlockingCyclingMemory<Memory, Config> *>
  performSplit() const;

  /**
   * Wrapped cycling memory object
   */
  Memory *memory;

  /**
   * A container used to delay a blocked access request until
   * finally passed on to the wrapped memory.
   */
  boost::optional<std::pair<AbstractAddress, AccessType>> delayedAccess;

  /**
   * Counter establishes a lower bound on the number of blocked cycles
   * experienced for the current access.
   */
  IntervalCounter<true /*lower bound needed*/, false /*no upper bound*/,
                  false /*do not join*/>
      addedBlocking;

  /**
   * Counter maintaining bounds on the number of
   * fast-forwarded blocking cycles.
   */
  IntervalCounter<true /*lower bound needed*/, true /*upper bound needed*/,
                  true /*perform join*/>
      fastForwardedBlocking;

protected:
  /**
   * Make a read-only reference of addedBlocking available
   * to the child classes.
   */
  const decltype(addedBlocking) &addedBlockingReadOnly = addedBlocking;
};

template <class Memory, const BlockingCyclingMemoryConfigType *Config>
BlockingCyclingMemory<Memory, Config>::BlockingCyclingMemory(
    const BlockingCyclingMemory<Memory, Config> &bcm2)
    : memory(bcm2.memory->clone()), delayedAccess(bcm2.delayedAccess),
      addedBlocking(bcm2.addedBlocking),
      fastForwardedBlocking(bcm2.fastForwardedBlocking) {}

template <class Memory, const BlockingCyclingMemoryConfigType *Config>
BlockingCyclingMemory<Memory, Config>::BlockingCyclingMemory()
    : memory(new Memory()), addedBlocking(0u), fastForwardedBlocking(0u) {}

template <class Memory, const BlockingCyclingMemoryConfigType *Config>
BlockingCyclingMemory<Memory, Config> *
BlockingCyclingMemory<Memory, Config>::clone() const {
  auto res = new BlockingCyclingMemory(*this);
  return res;
}

template <class Memory, const BlockingCyclingMemoryConfigType *Config>
BlockingCyclingMemory<Memory, Config>::~BlockingCyclingMemory() {
  delete memory;
}

template <class Memory, const BlockingCyclingMemoryConfigType *Config>
bool BlockingCyclingMemory<Memory, Config>::isBusy() const {
  return (delayedAccess || memory->isBusy());
}

template <class Memory, const BlockingCyclingMemoryConfigType *Config>
std::list<AbstractCyclingMemory *>
BlockingCyclingMemory<Memory, Config>::cycle() const {
  assert(addedBlocking.getLb() <=
             ((delayedAccess) ? MaxBlockingPerAccess : 0U) &&
         "The number of blocked cycles must at most be as high at this program "
         "point.");

  decltype(this->cycle()) res;

  // cycle wrapped memory
  for (auto cwm : memory->cycle()) {
    auto r = this->clone();
    delete r->memory;
    r->memory = static_cast<Memory *>(cwm);
    if (!r->memory->isBusy()) {
      // Not busy, so do our work
      const auto &splitRes = r->performSplit();
      res.insert(res.end(), splitRes.begin(), splitRes.end());
    } else {
      // Busy, we should not do anything
      res.push_back(r);
    }
  }

  return res;
}

template <class Memory, const BlockingCyclingMemoryConfigType *Config>
bool BlockingCyclingMemory<Memory, Config>::shouldPipelineStall() const {
  bool myres = StallOnLocalWorstType.isSet(LocalWorstCaseType::BUSBLOCKING) &&
               (delayedAccess && !memory->isBusy());
  return myres || memory->shouldPipelineStall();
}

template <class Memory, const BlockingCyclingMemoryConfigType *Config>
bool BlockingCyclingMemory<Memory, Config>::equals(
    const AbstractCyclingMemory &acm2) const {
  auto &bcm2 = dynamic_cast<const BlockingCyclingMemory &>(acm2);
  return addedBlocking == bcm2.addedBlocking &&
         fastForwardedBlocking == bcm2.fastForwardedBlocking &&
         delayedAccess == bcm2.delayedAccess && memory->equals(*bcm2.memory);
}

template <class Memory, const BlockingCyclingMemoryConfigType *Config>
size_t BlockingCyclingMemory<Memory, Config>::hashcode() const {
  size_t res = 0;
  hash_combine_hashcode(res, *memory);
  // TODO: access request is so far not used in the hash...
  // hash_combine_hashcode(res, delayedAccess);
  hash_combine_hashcode(res, addedBlocking);
  hash_combine_hashcode(res, fastForwardedBlocking);
  return res;
}

template <class Memory, const BlockingCyclingMemoryConfigType *Config>
bool BlockingCyclingMemory<Memory, Config>::isJoinable(
    const AbstractCyclingMemory &acm2) const {
  auto &bcm2 = dynamic_cast<const BlockingCyclingMemory &>(acm2);
  return addedBlocking.isJoinable(bcm2.addedBlocking) &&
         fastForwardedBlocking.isJoinable(bcm2.fastForwardedBlocking) &&
         delayedAccess == bcm2.delayedAccess &&
         memory->isJoinable(*bcm2.memory);
}

template <class Memory, const BlockingCyclingMemoryConfigType *Config>
void BlockingCyclingMemory<Memory, Config>::join(
    const AbstractCyclingMemory &acm2) {
  assert(isJoinable(acm2) &&
         "Cannot join non-joinable generic cycling memories");
  auto &bcm2 = dynamic_cast<const BlockingCyclingMemory &>(acm2);
  addedBlocking.join(bcm2.addedBlocking);
  fastForwardedBlocking.join(bcm2.fastForwardedBlocking);
  memory->join(*bcm2.memory);
  // the field delayedAccess is identical
  // anyway as guaranteed by the assert
}

template <class Memory, const BlockingCyclingMemoryConfigType *Config>
void BlockingCyclingMemory<Memory, Config>::print(std::ostream &stream) const {
  stream << "fastForwardedBlocking: [" << fastForwardedBlocking.getLb() << ", "
         << fastForwardedBlocking.getUb() << "]\n";
  if (delayedAccess) {
    stream << "delayedAccess: [ " << delayedAccess->first << ","
           << (delayedAccess->second == AccessType::LOAD ? "Load" : "Store")
           << "]\n";
    stream << "currently blocking and already experienced "
           << addedBlocking.getLb() << " cycles of blocking.\n";
  } else {
    stream << "currently no delayed access.\n";
  }
  stream << *memory << "\n";
}

template <class Memory, const BlockingCyclingMemoryConfigType *Config>
void BlockingCyclingMemory<Memory, Config>::incrementAddedBlocking() {
  ++addedBlocking;
}

template <class Memory, const BlockingCyclingMemoryConfigType *Config>
std::list<AbstractCyclingMemory *>
BlockingCyclingMemory<Memory, Config>::announceAccess(AbstractAddress addr,
                                                      AccessType t,
                                                      unsigned numWords) const {
  assert(!isBusy() && "Don't announce an access to a busy memory!");

  std::list<AbstractCyclingMemory *> results;

  // Announce it to the wrapped memory as we first handle the access and add the
  // blocking afterwards
  for (auto wS : memory->announceAccess(addr, t, numWords)) {
    assert(wS->isBusy() &&
           "There cannot be a memory that serves an access request in 0 time!");
    auto copy = this->clone();
    delete copy->memory;
    copy->memory = static_cast<Memory *>(wS);
    // store the access request
    copy->delayedAccess.emplace(addr, t);
    assert(copy->delayedAccess &&
           "Field delayedAccess should be initialized, but it isn't.");
    results.push_back(copy);
  }

  // return the changed copy
  return results;
}

template <class Memory, const BlockingCyclingMemoryConfigType *Config>
std::list<BlockingCyclingMemory<Memory, Config> *>
BlockingCyclingMemory<Memory, Config>::performSplit() const {
  assert(!memory->isBusy() &&
         "Cannot handle blocking if wrapped memory us busy");

  std::list<decltype(this->clone())> res;

  // take care of a delayed access
  if (delayedAccess) {
    if (!CompAnaType.isSet(CompositionalAnalysisType::SHAREDBUSBLOCKING) &&
        addedBlocking.getLb() < MaxBlockingPerAccess) {
      auto longerBlocked = this->clone();
      longerBlocked->incrementAddedBlocking();
      res.push_back(longerBlocked);
    }

    auto noLongerBlocked = this->clone();
    noLongerBlocked->delayedAccess = boost::none;
    noLongerBlocked->addedBlocking = 0;
    res.push_back(noLongerBlocked);
  }

  // otherwise definitely no split needed
  else {
    res.push_back(this->clone());
  }

  return res;
}

template <class Memory, const BlockingCyclingMemoryConfigType *Config>
std::list<AbstractCyclingMemory *>
BlockingCyclingMemory<Memory, Config>::fastForward() const {
  assert(this->isBusy() && "One should only fast-forward busy memories!");
  assert(this->delayedAccess && "Unable to fast forward, no access");

  decltype(this->fastForward()) res;

  if (this->memory->isBusy()) {
    // only fast-forward the inner memories
    for (auto forwardedInnerMem : memory->fastForward()) {
      auto copy = this->clone();
      delete copy->memory;
      copy->memory = static_cast<Memory *>(forwardedInnerMem);
      // fast forwarding of the blocking cycles
      if (!CompAnaType.isSet(CompositionalAnalysisType::SHAREDBUSBLOCKING)) {
        assert(
            copy->addedBlocking.getLb() == 0 &&
            copy->addedBlocking.getUb() == 0 &&
            "Not started with blocking phase, but have blocked cycles already");
        copy->addedBlocking = MaxBlockingPerAccess;
        decltype(fastForwardedBlocking) fastForwardedInterval(
            0, MaxBlockingPerAccess);
        copy->fastForwardedBlocking += fastForwardedInterval;
      }
      res.push_back(copy);
    }
  } else {
    assert(!CompAnaType.isSet(CompositionalAnalysisType::SHAREDBUSBLOCKING) &&
           "Blocking forwarding although compositional");

    auto copy = this->clone();

    // perform fast-forwarding of blocked cycles
    decltype(fastForwardedBlocking) fastForwardedInterval(
        0, MaxBlockingPerAccess - copy->addedBlocking.getLb());
    copy->addedBlocking = MaxBlockingPerAccess;
    copy->fastForwardedBlocking += fastForwardedInterval;

    // Save the result
    res.push_back(copy);
  }

  return res;
}

} // namespace TimingAnalysisPass

#endif
