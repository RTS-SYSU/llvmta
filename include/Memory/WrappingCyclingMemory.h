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

#ifndef WRAPPINGCYCLINGMEMORY_H
#define WRAPPINGCYCLINGMEMORY_H

#include "Memory/AbstractCyclingMemory.h"

#include <type_traits>

namespace TimingAnalysisPass {

/**
 * Class implementing a cycling memory as a wrapper for an existing cycling
 * memory.
 *
 * It can be used as a base class for a class that changes or tracks the
 * behavior of the cycling memory that is wrapped.
 */
template <class Memory>
class WrappingCyclingMemory : public AbstractCyclingMemory {
  static_assert(
      std::is_convertible<Memory *, AbstractCyclingMemory *>::value,
      "Type parameter MEMORY must be a descendant of AbstractCyclingMemory");

private:
  typedef AbstractCyclingMemory Base;

protected:
  WrappingCyclingMemory(const WrappingCyclingMemory<Memory> &wcm2);

public:
  WrappingCyclingMemory();

  virtual WrappingCyclingMemory *clone() const;

  virtual ~WrappingCyclingMemory();

  /**
   * Container used to make the local metrics of this class
   * available to the world outside.
   */
  struct LocalMetrics : Memory::LocalMetrics {
    // shorthand for the base class
    typedef typename Memory::LocalMetrics LocalMetricsBase;

    // the fields added to the local metrics used as base
    /*none*/

    /**
     * Creates the local metrics based on the
     * outer class' content.
     */
    LocalMetrics(const WrappingCyclingMemory &outerClassInstance)
        : LocalMetricsBase(*outerClassInstance.memory) {}

    virtual ~LocalMetrics(){};

    /**
     * Checks for equality between local metrics.
     */
    virtual bool
    equals(const AbstractCyclingMemory::LocalMetrics &anotherInstance) {
      auto &castedInstance =
          dynamic_cast<const LocalMetrics &>(anotherInstance);
      return LocalMetricsBase::equals(castedInstance);
    }
  };

  virtual LocalMetrics *getLocalMetrics() { return new LocalMetrics(*this); }

  /**
   * Resets the local metrics to their initial values.
   */
  virtual void resetLocalMetrics() { memory->resetLocalMetrics(); }

  /**
   * Check if the memory is currently busy.
   */
  virtual bool isBusy() const;

  /**
   * Perform one clock cycle in the memory implementation.
   */
  virtual std::list<AbstractCyclingMemory *> cycle() const;

  /**
   * Redirect to wrapped memory.
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
   * Wrapped cycling memory object
   */
  Memory *memory;
};

template <class Memory>
WrappingCyclingMemory<Memory>::WrappingCyclingMemory(
    const WrappingCyclingMemory<Memory> &wcm2)
    : memory(wcm2.memory->clone()) {}

template <class Memory>
WrappingCyclingMemory<Memory>::WrappingCyclingMemory() : memory(new Memory()) {}

template <class Memory>
WrappingCyclingMemory<Memory> *WrappingCyclingMemory<Memory>::clone() const {
  // use the copy constructor for efficiency
  auto res = new WrappingCyclingMemory(*this);
  return res;
}

template <class Memory>
WrappingCyclingMemory<Memory>::~WrappingCyclingMemory() {
  delete memory;
}

template <class Memory> bool WrappingCyclingMemory<Memory>::isBusy() const {
  return memory->isBusy();
}

template <class Memory>
std::list<AbstractCyclingMemory *>
WrappingCyclingMemory<Memory>::cycle() const {
  // cycle the wrapped memory first
  decltype(cycle()) res;
  auto cycledWraps = memory->cycle();

  // create a wrapper for each result
  for (auto cW : cycledWraps) {
    auto r = this->clone();
    delete r->memory;
    r->memory = static_cast<Memory *>(cW);
    res.push_back(r);
  }

  return res;
}

template <class Memory>
bool WrappingCyclingMemory<Memory>::shouldPipelineStall() const {
  return memory->shouldPipelineStall();
}

template <class Memory>
bool WrappingCyclingMemory<Memory>::equals(
    const AbstractCyclingMemory &acm2) const {
  auto &wcm2 = dynamic_cast<const WrappingCyclingMemory &>(acm2);
  return memory->equals(*wcm2.memory);
}

template <class Memory> size_t WrappingCyclingMemory<Memory>::hashcode() const {
  size_t res = 0;
  hash_combine_hashcode(res, *memory);
  return res;
}

template <class Memory>
bool WrappingCyclingMemory<Memory>::isJoinable(
    const AbstractCyclingMemory &acm2) const {
  auto &wcm2 = dynamic_cast<const WrappingCyclingMemory &>(acm2);
  return memory->isJoinable(*wcm2.memory);
}

template <class Memory>
void WrappingCyclingMemory<Memory>::join(const AbstractCyclingMemory &acm2) {
  assert(isJoinable(acm2) &&
         "Cannot join non-joinable generic cycling memories");
  auto &wcm2 = dynamic_cast<const WrappingCyclingMemory &>(acm2);
  memory->join(*wcm2.memory);
}

template <class Memory>
void WrappingCyclingMemory<Memory>::print(std::ostream &stream) const {
  stream << *memory;
}

template <class Memory>
std::list<AbstractCyclingMemory *>
WrappingCyclingMemory<Memory>::announceAccess(AbstractAddress addr,
                                              AccessType t,
                                              unsigned numWords) const {
  assert(!isBusy() && "Don't announce an access to a busy memory!");

  // announce at the wrapped memory first
  std::list<AbstractCyclingMemory *> res;
  auto announcedWraps = memory->announceAccess(addr, t, numWords);

  // create a wrapper for each result
  for (auto aW : announcedWraps) {
    auto r = this->clone();
    delete r->memory;
    r->memory = static_cast<Memory *>(aW);
    res.push_back(r);
  }

  return res;
}

template <class Memory>
std::list<AbstractCyclingMemory *>
WrappingCyclingMemory<Memory>::fastForward() const {
  assert(this->isBusy() && "One should only fast-forward busy memories!");

  std::list<AbstractCyclingMemory *> res;

  for (auto forwardedInnerMem : memory->fastForward()) {
    auto copy = this->clone();
    delete copy->memory;
    copy->memory = static_cast<Memory *>(forwardedInnerMem);
    res.push_back(copy);
  }

  return res;
}

} // namespace TimingAnalysisPass

#endif
