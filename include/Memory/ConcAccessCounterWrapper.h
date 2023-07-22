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

#ifndef CONCACCESSCOUNTERWRAPPER_H
#define CONCACCESSCOUNTERWRAPPER_H

#include "Memory/BlockingCounterCyclingMemory.h"
#include "Memory/BlockingCyclingMemory.h"

namespace TimingAnalysisPass {

/**
 * This class template can wrap the classes BlockingCyclingMemory or
 * BlockingCounterCyclingMemory and adds the accumulation of a lower
 * bound on the number of concurrent accesses to them.
 */
template <class BlockingCyclingMemType>
class ConcAccessCounterWrapper : public BlockingCyclingMemType {
private:
  /**
   * This template can be used within a static
   * assert to check whether a given type is
   * a specialization of a particular template.
   *
   * It is a variant of the accepted solution in:
   * http://stackoverflow.com/questions/11251376/how-can-i-check-if-a-type-is-an-instantiation-of-a-given-class-template
   */
  template <template <typename, const BlockingCyclingMemoryConfigType *>
            class Template,
            typename T>
  struct specializes_to : std::false_type {};
  template <template <typename, const BlockingCyclingMemoryConfigType *>
            class Template,
            typename T, const BlockingCyclingMemoryConfigType *Conf>
  struct specializes_to<Template, Template<T, Conf>> : std::true_type {};

  static_assert(
      specializes_to<BlockingCyclingMemory, BlockingCyclingMemType>::value ||
          specializes_to<BlockingCounterCyclingMemory,
                         BlockingCyclingMemType>::value,
      "Type parameter BlockingCyclingMemType must be a template specialization "
      "of"
      "BlockingCyclingMemory or BlockingCounterCyclingMemory.");

  static constexpr bool JoinCounter = true;

  typedef BlockingCyclingMemType Base;

protected:
  ConcAccessCounterWrapper(
      const ConcAccessCounterWrapper<BlockingCyclingMemType> &cacw2);

public:
  ConcAccessCounterWrapper();

  virtual ConcAccessCounterWrapper *clone() const;

  virtual ~ConcAccessCounterWrapper();

  /**
   * Container used to make the local metrics of this class
   * available to the world outside.
   */
  struct LocalMetrics : Base::LocalMetrics {
    // shorthand for the base class
    typedef typename Base::LocalMetrics LocalMetricsBase;

    // the fields added to the local metrics used as base
    IntervalCounter<true /*lower bound needed*/, false /*no upper bound*/,
                    JoinCounter /*do not join*/>
        concAccesses;

    /**
     * Creates the local metrics based on the
     * outer class' content.
     */
    LocalMetrics(const ConcAccessCounterWrapper &outerClassInstance)
        : LocalMetricsBase(outerClassInstance),
          concAccesses(outerClassInstance.concAccesses) {}

    virtual ~LocalMetrics(){};

    /**
     * Checks for equality between local metrics.
     */
    virtual bool
    equals(const AbstractCyclingMemory::LocalMetrics &anotherInstance) {
      auto castedInstance = dynamic_cast<const LocalMetrics &>(anotherInstance);
      return LocalMetricsBase::equals(castedInstance) &&
             concAccesses == castedInstance.concAccesses;
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
    concAccesses = 0u;
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
   * Counter establishes a lower bound on the number of concurrent accesses.
   */
  IntervalCounter<true /*lower bound needed*/, false /*no upper bound*/,
                  JoinCounter /*do not join*/>
      concAccesses;
};

template <class BlockingCyclingMemType>
ConcAccessCounterWrapper<BlockingCyclingMemType>::ConcAccessCounterWrapper(
    const ConcAccessCounterWrapper<BlockingCyclingMemType> &cacw2)
    : Base(cacw2), concAccesses(cacw2.concAccesses) {}

template <class BlockingCyclingMemType>
ConcAccessCounterWrapper<BlockingCyclingMemType>::ConcAccessCounterWrapper()
    : Base(), concAccesses(0u) {}

template <class BlockingCyclingMemType>
ConcAccessCounterWrapper<BlockingCyclingMemType> *
ConcAccessCounterWrapper<BlockingCyclingMemType>::clone() const {
  auto res = new ConcAccessCounterWrapper(*this);
  return res;
}

template <class BlockingCyclingMemType>
ConcAccessCounterWrapper<BlockingCyclingMemType>::~ConcAccessCounterWrapper() {}

template <class BlockingCyclingMemType>
bool ConcAccessCounterWrapper<BlockingCyclingMemType>::equals(
    const AbstractCyclingMemory &acm2) const {
  auto cacw2 =
      dynamic_cast<const ConcAccessCounterWrapper<BlockingCyclingMemType> &>(
          acm2);
  return Base::equals(cacw2) && concAccesses == cacw2.concAccesses;
}

template <class BlockingCyclingMemType>
size_t ConcAccessCounterWrapper<BlockingCyclingMemType>::hashcode() const {
  size_t res = Base::hashcode();
  hash_combine_hashcode(res, concAccesses);
  return res;
}

template <class BlockingCyclingMemType>
bool ConcAccessCounterWrapper<BlockingCyclingMemType>::isJoinable(
    const AbstractCyclingMemory &acm2) const {
  auto cacw2 =
      dynamic_cast<const ConcAccessCounterWrapper<BlockingCyclingMemType> &>(
          acm2);
  return Base::isJoinable(cacw2) && concAccesses.isJoinable(cacw2.concAccesses);
}

template <class BlockingCyclingMemType>
void ConcAccessCounterWrapper<BlockingCyclingMemType>::join(
    const AbstractCyclingMemory &acm2) {
  assert(isJoinable(acm2) &&
         "Cannot join non-joinable generic cycling memories");
  auto cacw2 =
      dynamic_cast<const ConcAccessCounterWrapper<BlockingCyclingMemType> &>(
          acm2);
  Base::join(cacw2);
  concAccesses.join(cacw2.concAccesses);
}

template <class BlockingCyclingMemType>
void ConcAccessCounterWrapper<BlockingCyclingMemType>::print(
    std::ostream &stream) const {
  Base::print(stream);
  stream << "concAccesses: [" << concAccesses.getLb() << ", "
         << concAccesses.getUb() << "]\n";
}

template <class BlockingCyclingMemType>
void ConcAccessCounterWrapper<
    BlockingCyclingMemType>::incrementAddedBlocking() {
  Base::incrementAddedBlocking();
  if (Base::addedBlockingReadOnly.getLb() % Base::AccessLatency == 1) {
    ++concAccesses;
  }
}

} // namespace TimingAnalysisPass

#endif
