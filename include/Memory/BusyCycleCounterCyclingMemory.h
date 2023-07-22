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

#ifndef BUSYCYCLECOUNTERCYCLINGMEMORY_H
#define BUSYCYCLECOUNTERCYCLINGMEMORY_H

#include "Memory/WrappingCyclingMemory.h"

#include <Util/IntervalCounter.h>

namespace TimingAnalysisPass {

/**
 * Class implementing a cycling memory as a wrapper for an existing cycling
 * memory.
 *
 * It accumulates upper and lower bounds on the number of busy cycles of the
 * wrapped memory.
 */
template <class Memory, bool LowerBoundNeeded, bool UpperBoundNeeded,
          bool AllowJoin>
class BusyCycleCounterCyclingMemory : public WrappingCyclingMemory<Memory> {
  static_assert(
      std::is_convertible<Memory *, AbstractCyclingMemory *>::value,
      "Type parameter MEMORY must be a descendant of AbstractCyclingMemory");

private:
  typedef WrappingCyclingMemory<Memory> Base;

protected:
  BusyCycleCounterCyclingMemory(
      const BusyCycleCounterCyclingMemory<Memory, LowerBoundNeeded,
                                          UpperBoundNeeded, AllowJoin> &bcccm2);

public:
  BusyCycleCounterCyclingMemory();

  virtual BusyCycleCounterCyclingMemory *clone() const;

  virtual ~BusyCycleCounterCyclingMemory(){};

  /**
   * Container used to make the local metrics of this class
   * available to the world outside.
   */
  struct LocalMetrics : Base::LocalMetrics {
    // shorthand for the base class
    typedef typename Base::LocalMetrics LocalMetricsBase;

    // the fields added to the local metrics used as base
    IntervalCounter<LowerBoundNeeded, UpperBoundNeeded, AllowJoin>
        busyCycleCounter;

    /**
     * Creates the local metrics based on the
     * outer class' content.
     */
    LocalMetrics(const BusyCycleCounterCyclingMemory &outerClassInstance)
        : LocalMetricsBase(outerClassInstance),
          busyCycleCounter(outerClassInstance.busyCycleCounter) {}

    virtual ~LocalMetrics(){};

    /**
     * Checks for equality between local metrics.
     */
    virtual bool
    equals(const AbstractCyclingMemory::LocalMetrics &anotherInstance) {
      auto &castedInstance =
          dynamic_cast<const LocalMetrics &>(anotherInstance);
      return LocalMetricsBase::equals(castedInstance) &&
             busyCycleCounter == castedInstance.busyCycleCounter;
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
    Base::resetLocalMetrics();
    busyCycleCounter = 0u;
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

  /**
   * Implement how to announce a new access to the memory.
   */
  virtual std::list<AbstractCyclingMemory *> cycle() const;

protected:
  /**
   * The internal access counter.
   */
  IntervalCounter<LowerBoundNeeded, UpperBoundNeeded, AllowJoin>
      busyCycleCounter;
};

template <class Memory, bool LowerBoundNeeded, bool UpperBoundNeeded,
          bool AllowJoin>
BusyCycleCounterCyclingMemory<Memory, LowerBoundNeeded, UpperBoundNeeded,
                              AllowJoin>::
    BusyCycleCounterCyclingMemory(
        const BusyCycleCounterCyclingMemory<
            Memory, LowerBoundNeeded, UpperBoundNeeded, AllowJoin> &bcccm2)
    : Base(bcccm2), busyCycleCounter(bcccm2.busyCycleCounter) {}

template <class Memory, bool LowerBoundNeeded, bool UpperBoundNeeded,
          bool AllowJoin>
BusyCycleCounterCyclingMemory<Memory, LowerBoundNeeded, UpperBoundNeeded,
                              AllowJoin>::BusyCycleCounterCyclingMemory() {}

template <class Memory, bool LowerBoundNeeded, bool UpperBoundNeeded,
          bool AllowJoin>
BusyCycleCounterCyclingMemory<Memory, LowerBoundNeeded, UpperBoundNeeded,
                              AllowJoin> *
BusyCycleCounterCyclingMemory<Memory, LowerBoundNeeded, UpperBoundNeeded,
                              AllowJoin>::clone() const {
  auto res = new BusyCycleCounterCyclingMemory(*this);
  return res;
}

template <class Memory, bool LowerBoundNeeded, bool UpperBoundNeeded,
          bool AllowJoin>
bool BusyCycleCounterCyclingMemory<
    Memory, LowerBoundNeeded, UpperBoundNeeded,
    AllowJoin>::equals(const AbstractCyclingMemory &acm2) const {
  auto &bcccm2 = dynamic_cast<const BusyCycleCounterCyclingMemory &>(acm2);
  return Base::equals(bcccm2) && busyCycleCounter == bcccm2.busyCycleCounter;
}

template <class Memory, bool LowerBoundNeeded, bool UpperBoundNeeded,
          bool AllowJoin>
size_t BusyCycleCounterCyclingMemory<Memory, LowerBoundNeeded, UpperBoundNeeded,
                                     AllowJoin>::hashcode() const {
  size_t res = Base::hashcode();
  hash_combine_hashcode(res, busyCycleCounter);
  return res;
}

template <class Memory, bool LowerBoundNeeded, bool UpperBoundNeeded,
          bool AllowJoin>
bool BusyCycleCounterCyclingMemory<
    Memory, LowerBoundNeeded, UpperBoundNeeded,
    AllowJoin>::isJoinable(const AbstractCyclingMemory &acm2) const {
  auto &bcccm2 = dynamic_cast<const BusyCycleCounterCyclingMemory &>(acm2);
  return Base::isJoinable(bcccm2) &&
         busyCycleCounter.isJoinable(bcccm2.busyCycleCounter);
}

template <class Memory, bool LowerBoundNeeded, bool UpperBoundNeeded,
          bool AllowJoin>
void BusyCycleCounterCyclingMemory<Memory, LowerBoundNeeded, UpperBoundNeeded,
                                   AllowJoin>::join(const AbstractCyclingMemory
                                                        &acm2) {
  assert(isJoinable(acm2) &&
         "Cannot join non-joinable generic cycling memories");
  auto &bcccm2 = dynamic_cast<const BusyCycleCounterCyclingMemory &>(acm2);
  Base::join(bcccm2);
  busyCycleCounter.join(bcccm2.busyCycleCounter);
}

template <class Memory, bool LowerBoundNeeded, bool UpperBoundNeeded,
          bool AllowJoin>
void BusyCycleCounterCyclingMemory<Memory, LowerBoundNeeded, UpperBoundNeeded,
                                   AllowJoin>::print(std::ostream &stream)
    const {
  stream << "busyCycleCounter: " << busyCycleCounter << ", ";
  Base::print(stream);
}

template <class Memory, bool LowerBoundNeeded, bool UpperBoundNeeded,
          bool AllowJoin>
std::list<AbstractCyclingMemory *>
BusyCycleCounterCyclingMemory<Memory, LowerBoundNeeded, UpperBoundNeeded,
                              AllowJoin>::cycle() const {
  if (this->isBusy()) {
    // increase the busy cycle counter
    auto copy = this->clone();
    ++copy->busyCycleCounter;

    auto res = copy->Base::cycle();
    delete copy;
    return res;
  }

  return this->Base::cycle();
}

} // namespace TimingAnalysisPass

#endif
