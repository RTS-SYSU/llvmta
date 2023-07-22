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

#ifndef SIMPLESDRAMCYCLINGMEMORY_H
#define SIMPLESDRAMCYCLINGMEMORY_H

#include "Memory/AbstractCyclingMemory.h"
#include "Util/IntervalCounter.h"
#include "Util/Util.h"

namespace TimingAnalysisPass {

const struct {
  unsigned freq;           // in kiloHertz kHz
  unsigned refreshPeriod;  // in milliseconds ms
  unsigned numRows;        // number of rows
  unsigned maxBurstLength; // longest possible burst access in words
  unsigned getRefreshInterArrivalCycles() const {
    return refreshPeriod * freq / numRows -
           (Latency + PerWordLatency * maxBurstLength);
  }
} SDRAMConfig = {100000, 64, 8192, 8};

/**
 * Class implementing a cycling memory based on a very simple SDRAM controller
 * model. Upon an access, the row is activated, the access is performed, and the
 * row is closed again. Each row must be refreshed every 64 ms.
 *
 * A typical Access looks like (IDLE, 0) -> (ACCESS, acclat - 1) -> ... ->
 * (ACCESS, 1)
 * -> (ACCESS, 0) = (REFRESH, reflat) -> (REFRESH, reflat - 1) -> ... ->
 * (REFRESH, 1) -> (REFRESH, 0) = (IDLE, 0).
 */
class SimpleSDRAMCyclingMemory : public AbstractCyclingMemory {
private:
  typedef AbstractCyclingMemory Base;

public:
  SimpleSDRAMCyclingMemory();

  virtual SimpleSDRAMCyclingMemory *clone() const;

  virtual ~SimpleSDRAMCyclingMemory(){};

  /**
   * Container used to make the local metrics of this class
   * available to the world outside.
   */
  struct LocalMetrics : public Base::LocalMetrics {
    // the fields added to the local metrics used as base
    // Record the fast forwarded cycles
    IntervalCounter<true /*lower bound needed*/, true /*upper bound needed*/,
                    true /*perform join*/>
        fastForwardedAccessCycles;

    // Remember whether we just started a refresh
    boost::optional<AbstractAddress> justRefreshed;

    /**
     * Creates the local metrics based on the
     * outer class' content.
     */
    LocalMetrics(const SimpleSDRAMCyclingMemory &outerClassInstance)
        : fastForwardedAccessCycles(
              outerClassInstance.fastForwardedAccessCycles),
          justRefreshed(outerClassInstance.justRefreshed) {}

    virtual ~LocalMetrics(){};

    /**
     * Joins the current local metrics with another instance.
     */
    virtual void join(const Base::LocalMetrics &anotherInstance) {
      const LocalMetrics &other =
          dynamic_cast<const LocalMetrics &>(anotherInstance);
      if (justRefreshed != other.justRefreshed) {
        justRefreshed = boost::none;
      }
      fastForwardedAccessCycles.join(other.fastForwardedAccessCycles);
    }

    /**
     * Checks for equality between local metrics.
     */
    virtual bool equals(const Base::LocalMetrics &anotherInstance) {
      const LocalMetrics &other =
          dynamic_cast<const LocalMetrics &>(anotherInstance);
      return fastForwardedAccessCycles == other.fastForwardedAccessCycles &&
             justRefreshed == other.justRefreshed;
    }
  };

  virtual LocalMetrics *getLocalMetrics() { return new LocalMetrics(*this); }

  /**
   * Resets the local metrics to their initial values.
   */
  virtual void resetLocalMetrics() {
    justRefreshed = boost::none;
    fastForwardedAccessCycles = 0u;
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
   * If we have worked on a refresh during the last cycle and we want to stall
   * on refresh, return true. Otherwise false.
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
  enum class DRAMPhase { IDLE, REFRESH, ACCESS };

  /**
   * Current phase of the controller.
   */
  DRAMPhase accessPhase;
  /**
   * Counter for time blocked for current phase (time until phase can switch).
   */
  unsigned timeBlocked;

  /**
   * Just initiated a refresh on the provided row address interval.
   */
  boost::optional<AbstractAddress> justRefreshed;

  /**
   * Flag used to speed-up fast forwarding: If during ACCESS convergence is
   * detected, fast forward the access, then split, and in one case also
   * fast-forward the refresh. In both cases, at the end of ACCESS in cycle(),
   * we should not start another refresh. Therefore, this flag is set to true in
   * these cases. If the access is finalised, reset the flag.
   */
  bool hasSeenRefresh;

  /**
   * Counter maintaining bounds on the number of
   * fast-forwarded access cycles.
   */
  decltype(SimpleSDRAMCyclingMemory::LocalMetrics::fastForwardedAccessCycles)
      fastForwardedAccessCycles;
};

} // namespace TimingAnalysisPass

#endif
