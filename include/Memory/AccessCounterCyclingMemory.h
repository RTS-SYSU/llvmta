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

#ifndef ACCESSCOUNTERCYCLINGMEMORY_H
#define ACCESSCOUNTERCYCLINGMEMORY_H

#include "Memory/WrappingCyclingMemory.h"

#include <Util/IntervalCounter.h>

namespace TimingAnalysisPass {

/**
 * Class implementing a cycling memory as a wrapper for an existing cycling
 * memory.
 *
 * It accumulates upper and lower bounds on the number of accesses requested.
 */
template <class Memory, bool LowerBoundNeeded, bool UpperBoundNeeded,
          bool AllowJoin>
class AccessCounterCyclingMemory : public WrappingCyclingMemory<Memory> {
  static_assert(
      std::is_convertible<Memory *, AbstractCyclingMemory *>::value,
      "Type parameter MEMORY must be a descendant of AbstractCyclingMemory");

private:
  typedef WrappingCyclingMemory<Memory> Base;

protected:
  AccessCounterCyclingMemory(
      const AccessCounterCyclingMemory<Memory, LowerBoundNeeded,
                                       UpperBoundNeeded, AllowJoin> &accm2);

public:
  AccessCounterCyclingMemory();

  virtual AccessCounterCyclingMemory *clone() const;

  virtual ~AccessCounterCyclingMemory(){};

  /**
   * Container used to make the local metrics of this class
   * available to the world outside.
   */
  struct LocalMetrics : Base::LocalMetrics {
    // shorthand for the base class
    typedef typename Base::LocalMetrics LocalMetricsBase;

    // the fields added to the local metrics used as base
    IntervalCounter<LowerBoundNeeded, UpperBoundNeeded, AllowJoin>
        accessCounter;

    /**
     * Creates the local metrics based on the
     * outer class' content.
     */
    LocalMetrics(const AccessCounterCyclingMemory &outerClassInstance)
        : LocalMetricsBase(outerClassInstance),
          accessCounter(outerClassInstance.accessCounter) {}

    virtual ~LocalMetrics(){};

    /**
     * Checks for equality between local metrics.
     */
    virtual bool
    equals(const AbstractCyclingMemory::LocalMetrics &anotherInstance) {
      auto &castedInstance =
          dynamic_cast<const LocalMetrics &>(anotherInstance);
      return LocalMetricsBase::equals(castedInstance) &&
             accessCounter == castedInstance.accessCounter;
    }
  };

  virtual LocalMetrics *getLocalMetrics() { return new LocalMetrics(*this); }

  /**
   * Resets the local metrics to their initial values.
   */
  virtual void resetLocalMetrics() {
    Base::resetLocalMetrics();
    accessCounter = 0u;
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
  virtual std::list<AbstractCyclingMemory *>
  announceAccess(AbstractAddress addr, AccessType t, unsigned numWords) const;

protected:
  /**
   * The internal access counter.
   */
  IntervalCounter<LowerBoundNeeded, UpperBoundNeeded, AllowJoin> accessCounter;
};

template <class Memory, bool LowerBoundNeeded, bool UpperBoundNeeded,
          bool AllowJoin>
AccessCounterCyclingMemory<Memory, LowerBoundNeeded, UpperBoundNeeded,
                           AllowJoin>::
    AccessCounterCyclingMemory(
        const AccessCounterCyclingMemory<Memory, LowerBoundNeeded,
                                         UpperBoundNeeded, AllowJoin> &accm2)
    : Base(accm2), accessCounter(accm2.accessCounter) {}

template <class Memory, bool LowerBoundNeeded, bool UpperBoundNeeded,
          bool AllowJoin>
AccessCounterCyclingMemory<Memory, LowerBoundNeeded, UpperBoundNeeded,
                           AllowJoin>::AccessCounterCyclingMemory()
    : Base(), accessCounter() {}

template <class Memory, bool LowerBoundNeeded, bool UpperBoundNeeded,
          bool AllowJoin>
AccessCounterCyclingMemory<Memory, LowerBoundNeeded, UpperBoundNeeded,
                           AllowJoin> *
AccessCounterCyclingMemory<Memory, LowerBoundNeeded, UpperBoundNeeded,
                           AllowJoin>::clone() const {
  auto res = new AccessCounterCyclingMemory(*this);
  return res;
}

template <class Memory, bool LowerBoundNeeded, bool UpperBoundNeeded,
          bool AllowJoin>
bool AccessCounterCyclingMemory<Memory, LowerBoundNeeded, UpperBoundNeeded,
                                AllowJoin>::equals(const AbstractCyclingMemory
                                                       &acm2) const {
  auto &accm2 = dynamic_cast<const AccessCounterCyclingMemory &>(acm2);
  return Base::equals(accm2) && accessCounter == accm2.accessCounter;
}

template <class Memory, bool LowerBoundNeeded, bool UpperBoundNeeded,
          bool AllowJoin>
size_t AccessCounterCyclingMemory<Memory, LowerBoundNeeded, UpperBoundNeeded,
                                  AllowJoin>::hashcode() const {
  size_t res = Base::hashcode();
  hash_combine_hashcode(res, accessCounter);
  return res;
}

template <class Memory, bool LowerBoundNeeded, bool UpperBoundNeeded,
          bool AllowJoin>
bool AccessCounterCyclingMemory<
    Memory, LowerBoundNeeded, UpperBoundNeeded,
    AllowJoin>::isJoinable(const AbstractCyclingMemory &acm2) const {
  auto &accm2 = dynamic_cast<const AccessCounterCyclingMemory &>(acm2);
  return Base::isJoinable(accm2) &&
         accessCounter.isJoinable(accm2.accessCounter);
}

template <class Memory, bool LowerBoundNeeded, bool UpperBoundNeeded,
          bool AllowJoin>
void AccessCounterCyclingMemory<Memory, LowerBoundNeeded, UpperBoundNeeded,
                                AllowJoin>::join(const AbstractCyclingMemory
                                                     &acm2) {
  assert(isJoinable(acm2) &&
         "Cannot join non-joinable generic cycling memories");
  auto &accm2 = dynamic_cast<const AccessCounterCyclingMemory &>(acm2);
  Base::join(accm2);
  accessCounter.join(accm2.accessCounter);
}

template <class Memory, bool LowerBoundNeeded, bool UpperBoundNeeded,
          bool AllowJoin>
void AccessCounterCyclingMemory<Memory, LowerBoundNeeded, UpperBoundNeeded,
                                AllowJoin>::print(std::ostream &stream) const {
  stream << "accessCounter: " << accessCounter << ", ";
  Base::print(stream);
}

template <class Memory, bool LowerBoundNeeded, bool UpperBoundNeeded,
          bool AllowJoin>
std::list<AbstractCyclingMemory *>
AccessCounterCyclingMemory<Memory, LowerBoundNeeded, UpperBoundNeeded,
                           AllowJoin>::announceAccess(AbstractAddress addr,
                                                      AccessType t,
                                                      unsigned numWords) const {
  assert(!this->isBusy() && "Don't announce an access to a busy memory!");

  // increase the access counter
  auto copy = this->clone();
  ++copy->accessCounter;

  auto res = copy->Base::announceAccess(addr, t, numWords);
  delete copy;
  return res;
}

} // namespace TimingAnalysisPass

#endif
