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

#ifndef FIXEDLATENCYCYCLINGMEMORY_H
#define FIXEDLATENCYCYCLINGMEMORY_H

#include "Memory/AbstractCyclingMemory.h"
#include "Memory/FixedLatencyCyclingMemoryConfig.h"
#include "Util/IntervalCounter.h"

namespace TimingAnalysisPass {

/**
 * Class implementing a cycling memory based on a fixed-latency memory model.
 */
template <const FixedLatencyCyclingMemoryConfigType *Config>
class FixedLatencyCyclingMemory : public AbstractCyclingMemory {
private:
  typedef AbstractCyclingMemory Base;

  static constexpr const unsigned &Latency = Config->latency;
  static constexpr const unsigned &PerWordLatency = Config->perWordLatency;

protected:
  FixedLatencyCyclingMemory(const FixedLatencyCyclingMemory<Config> &flcm);

public:
  FixedLatencyCyclingMemory();

  virtual FixedLatencyCyclingMemory *clone() const;

  virtual ~FixedLatencyCyclingMemory(){};

  /**
   * Container used to make the local metrics of this class
   * available to the world outside.
   */
  struct LocalMetrics : public Base::LocalMetrics {
    // the fields added to the local metrics used as base
    IntervalCounter<true /*lower bound needed*/, true /*upper bound needed*/,
                    true /*perform join*/>
        fastForwardedAccessCycles;

    /**
     * Creates the local metrics based on the
     * outer class' content.
     */
    LocalMetrics(const FixedLatencyCyclingMemory &outerClassInstance)
        : fastForwardedAccessCycles(
              outerClassInstance.fastForwardedAccessCycles) {}

    virtual ~LocalMetrics(){};

    /**
     * Checks for equality between local metrics.
     */
    virtual bool
    equals(const AbstractCyclingMemory::LocalMetrics &anotherInstance) {
      auto &castedInstance =
          dynamic_cast<const LocalMetrics &>(anotherInstance);
      return fastForwardedAccessCycles ==
             castedInstance.fastForwardedAccessCycles;
    }
  };

  virtual LocalMetrics *getLocalMetrics() { return new LocalMetrics(*this); }

  /**
   * Resets the local metrics to their initial values.
   */
  virtual void resetLocalMetrics() { fastForwardedAccessCycles = 0u; }

  /**
   * Check if the memory is currently busy.
   */
  virtual bool isBusy() const;

  /**
   * Perform one clock cycle in the memory implementation.
   */
  virtual std::list<AbstractCyclingMemory *> cycle() const;

  /**
   * Fixed latency memory usually does not require stalling.
   */
  virtual bool shouldPipelineStall() const;

  /**
   * Since used in MicroArchitecturalStates, we need to know whether the memory
   * parts are the same.
   */
  virtual bool equals(const AbstractCyclingMemory &am2) const;

  /**
   * Same as for the equality operator, this may be used by "higher" classes.
   */
  virtual size_t hashcode() const;

  virtual bool isJoinable(const AbstractCyclingMemory &am2) const;

  virtual void join(const AbstractCyclingMemory &am2);

  virtual void print(std::ostream &stream) const;

  /**
   * Implement how to announce a new access to the memory.
   */
  virtual std::list<AbstractCyclingMemory *>
  announceAccess(AbstractAddress addr, AccessType t, unsigned numWords) const;

  virtual std::list<AbstractCyclingMemory *> fastForward() const;

private:
  /**
   * Blocking counter to stall the topology until an access is finished.
   */
  int timeBlocked;

  /**
   * Counter maintaining bounds on the number of
   * fast-forwarded access cycles.
   */
  IntervalCounter<true /*lower bound needed*/, true /*upper bound needed*/,
                  true /*perform join*/>
      fastForwardedAccessCycles;
};

template <const FixedLatencyCyclingMemoryConfigType *Config>
FixedLatencyCyclingMemory<Config>::FixedLatencyCyclingMemory(
    const FixedLatencyCyclingMemory<Config> &flcm)
    : timeBlocked(flcm.timeBlocked),
      fastForwardedAccessCycles(flcm.fastForwardedAccessCycles) {}

template <const FixedLatencyCyclingMemoryConfigType *Config>
FixedLatencyCyclingMemory<Config>::FixedLatencyCyclingMemory()
    : timeBlocked(0), fastForwardedAccessCycles(0u) {}

template <const FixedLatencyCyclingMemoryConfigType *Config>
FixedLatencyCyclingMemory<Config> *
FixedLatencyCyclingMemory<Config>::clone() const {
  return new FixedLatencyCyclingMemory(*this);
}

template <const FixedLatencyCyclingMemoryConfigType *Config>
bool FixedLatencyCyclingMemory<Config>::isBusy() const {
  return (timeBlocked > 0);
}

template <const FixedLatencyCyclingMemoryConfigType *Config>
std::list<AbstractCyclingMemory *>
FixedLatencyCyclingMemory<Config>::cycle() const {
  std::list<AbstractCyclingMemory *> res;
  FixedLatencyCyclingMemory *r = this->clone();
  if (r->timeBlocked > 0) {
    r->timeBlocked--;
  }
  res.push_back(r);
  return res;
}

template <const FixedLatencyCyclingMemoryConfigType *Config>
bool FixedLatencyCyclingMemory<Config>::shouldPipelineStall() const {
  return false;
}

template <const FixedLatencyCyclingMemoryConfigType *Config>
bool FixedLatencyCyclingMemory<Config>::equals(
    const AbstractCyclingMemory &am2) const {
  auto &gcm2 = dynamic_cast<const FixedLatencyCyclingMemory &>(am2);
  return timeBlocked == gcm2.timeBlocked &&
         fastForwardedAccessCycles == gcm2.fastForwardedAccessCycles;
}

template <const FixedLatencyCyclingMemoryConfigType *Config>
size_t FixedLatencyCyclingMemory<Config>::hashcode() const {
  size_t res = 0;
  hash_combine(res, timeBlocked);
  hash_combine_hashcode(res, fastForwardedAccessCycles);
  return res;
}

template <const FixedLatencyCyclingMemoryConfigType *Config>
bool FixedLatencyCyclingMemory<Config>::isJoinable(
    const AbstractCyclingMemory &am2) const {
  auto &gcm2 = dynamic_cast<const FixedLatencyCyclingMemory &>(am2);
  return timeBlocked == gcm2.timeBlocked &&
         fastForwardedAccessCycles.isJoinable(gcm2.fastForwardedAccessCycles);
}

template <const FixedLatencyCyclingMemoryConfigType *Config>
void FixedLatencyCyclingMemory<Config>::join(const AbstractCyclingMemory &am2) {
  assert(isJoinable(am2) &&
         "Cannot join non-joinable generic cycling memories");
  // the fields timeBlocked are identical anyway as guaranteed by the assert
  auto &gcm2 = dynamic_cast<const FixedLatencyCyclingMemory &>(am2);
  fastForwardedAccessCycles.join(gcm2.fastForwardedAccessCycles);
}

template <const FixedLatencyCyclingMemoryConfigType *Config>
void FixedLatencyCyclingMemory<Config>::print(std::ostream &stream) const {
  stream << "fastForwardedAccessCycles: [" << fastForwardedAccessCycles.getLb()
         << ", " << fastForwardedAccessCycles.getUb() << "]\n";
  stream << "needs " << timeBlocked << "cycles to finish.";
}

template <const FixedLatencyCyclingMemoryConfigType *Config>
std::list<AbstractCyclingMemory *>
FixedLatencyCyclingMemory<Config>::announceAccess(AbstractAddress addr,
                                                  AccessType t,
                                                  unsigned numWords) const {
  assert(!isBusy() && "Don't announce an access to a busy memory!");
  std::list<AbstractCyclingMemory *> res;
  FixedLatencyCyclingMemory *r = this->clone();
  r->timeBlocked = Latency + numWords * PerWordLatency;
  res.push_back(r);
  return res;
}

template <const FixedLatencyCyclingMemoryConfigType *Config>
std::list<AbstractCyclingMemory *>
FixedLatencyCyclingMemory<Config>::fastForward() const {
  assert(this->isBusy() && "One should only fast-forward busy memories!");

  std::list<AbstractCyclingMemory *> res;
  FixedLatencyCyclingMemory *r = this->clone();

  // TODO (low prio) if we use disabled muarchjoin, then we keep
  // fastForwardedAccessCycles apart, might be expensive.

  // perform fast-forwarding of the remaining cycles
  r->fastForwardedAccessCycles += (r->timeBlocked - 1);
  r->timeBlocked = 1;

  res.push_back(r);
  return res;
}

} // namespace TimingAnalysisPass

#endif
