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

#ifndef BLOCKINGCOUNTERCYCLINGMEMORY_H
#define BLOCKINGCOUNTERCYCLINGMEMORY_H

#include "Memory/BlockingCyclingMemory.h"
#include "Util/IntervalCounter.h"

#include <type_traits>

namespace TimingAnalysisPass {

/**
 * Class implementing a cycling memory as a wrapper for an existing cycling
 * memory.
 *
 * It can be used to add blocking due to resource arbitration.
 * In this way, a non-shared memory can easily be extended to a shared memory.
 *
 * This variant of BlockingCyclingMemory has an internal counter that
 * accumulates a lower bound on the number of blocking cycles for more
 * than one bus access. The counter is exposed in the local metrics.
 */
template <class Memory, const BlockingCyclingMemoryConfigType *Config>
class BlockingCounterCyclingMemory
    : public BlockingCyclingMemory<Memory, Config> {
  static_assert(
      std::is_convertible<Memory *, AbstractCyclingMemory *>::value,
      "Type parameter MEMORY must be a descendant of AbstractCyclingMemory");

private:
  static constexpr bool JoinCounter = true;

  typedef BlockingCyclingMemory<Memory, Config> Base;

protected:
  BlockingCounterCyclingMemory(
      const BlockingCounterCyclingMemory<Memory, Config> &bccm2);

public:
  BlockingCounterCyclingMemory();

  virtual BlockingCounterCyclingMemory *clone() const;

  virtual ~BlockingCounterCyclingMemory(){};

  /**
   * Container used to make the local metrics of this class
   * available to the world outside.
   */
  struct LocalMetrics : Base::LocalMetrics {
    // shorthand for the base class
    typedef typename Base::LocalMetrics LocalMetricsBase;

    // the fields added to the local metrics used as base
    IntervalCounter<true, false, JoinCounter> blockingCounter;

    /**
     * Creates the local metrics based on the
     * outer class' content.
     */
    LocalMetrics(const BlockingCounterCyclingMemory &outerClassInstance)
        : LocalMetricsBase(outerClassInstance),
          blockingCounter(outerClassInstance.counter) {}

    virtual ~LocalMetrics(){};

    /**
     * Checks for equality between local metrics.
     */
    virtual bool
    equals(const AbstractCyclingMemory::LocalMetrics &anotherInstance) {
      auto &castedInstance =
          dynamic_cast<const LocalMetrics &>(anotherInstance);
      return LocalMetricsBase::equals(castedInstance) &&
             blockingCounter == castedInstance.blockingCounter;
    }
  };

  virtual LocalMetrics *getLocalMetrics() { return new LocalMetrics(*this); }

  /**
   * Resets the local metrics to their initial values.
   */
  virtual void resetLocalMetrics() {
    Base::resetLocalMetrics();
    counter = 0u;
  }

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

protected:
  /**
   * This hook increments the internal blocking counter.
   * It is intended to be overridden by child classes.
   */
  virtual void incrementAddedBlocking();

private:
  /**
   * Counter establishes a lower bound on the number of blocked cycles
   * experienced since the last reset of the counter.
   */
  IntervalCounter<true /*lower bound needed*/, false /*no upper bound*/,
                  JoinCounter /*join depending on parmeter*/>
      counter;
};

template <class Memory, const BlockingCyclingMemoryConfigType *Config>
BlockingCounterCyclingMemory<Memory, Config>::BlockingCounterCyclingMemory(
    const BlockingCounterCyclingMemory<Memory, Config> &bccm2)
    : Base(bccm2), counter(bccm2.counter) {}

template <class Memory, const BlockingCyclingMemoryConfigType *Config>
BlockingCounterCyclingMemory<Memory, Config>::BlockingCounterCyclingMemory()
    : counter(0u) {}

template <class Memory, const BlockingCyclingMemoryConfigType *Config>
BlockingCounterCyclingMemory<Memory, Config> *
BlockingCounterCyclingMemory<Memory, Config>::clone() const {
  auto res = new BlockingCounterCyclingMemory(*this);
  return res;
}

template <class Memory, const BlockingCyclingMemoryConfigType *Config>
void BlockingCounterCyclingMemory<Memory, Config>::incrementAddedBlocking() {
  Base::incrementAddedBlocking();
  ++counter;
}

template <class Memory, const BlockingCyclingMemoryConfigType *Config>
bool BlockingCounterCyclingMemory<Memory, Config>::equals(
    const AbstractCyclingMemory &acm2) const {
  auto &bccm2 = dynamic_cast<const BlockingCounterCyclingMemory &>(acm2);
  return (Base::equals(bccm2) && counter == bccm2.counter);
}

template <class Memory, const BlockingCyclingMemoryConfigType *Config>
size_t BlockingCounterCyclingMemory<Memory, Config>::hashcode() const {
  size_t res = Base::hashcode();
  hash_combine_hashcode(res, counter);
  return res;
}

template <class Memory, const BlockingCyclingMemoryConfigType *Config>
bool BlockingCounterCyclingMemory<Memory, Config>::isJoinable(
    const AbstractCyclingMemory &acm2) const {
  auto &bccm2 = dynamic_cast<const BlockingCounterCyclingMemory &>(acm2);
  return (Base::isJoinable(bccm2) && counter.isJoinable(bccm2.counter));
}

template <class Memory, const BlockingCyclingMemoryConfigType *Config>
void BlockingCounterCyclingMemory<Memory, Config>::join(
    const AbstractCyclingMemory &acm2) {
  assert(isJoinable(acm2) &&
         "Cannot join non-joinable generic cycling memories");
  auto &bccm2 = dynamic_cast<const BlockingCounterCyclingMemory &>(acm2);
  Base::join(bccm2);
  counter.join(bccm2.counter);
}

template <class Memory, const BlockingCyclingMemoryConfigType *Config>
void BlockingCounterCyclingMemory<Memory, Config>::print(
    std::ostream &stream) const {
  stream << "blockingCounter: " << counter << ", ";
  Base::print(stream);
}

} // namespace TimingAnalysisPass

#endif
