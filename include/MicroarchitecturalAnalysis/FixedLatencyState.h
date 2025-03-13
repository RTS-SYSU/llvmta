////////////////////////////////////////////////////////////////////////////////
//
//   LLVMTA - Timing Analyser performing worst-case execution time analysis
//     using the LLVM backend intermediate representation
//
// Copyright (C) 2013-2022  Saarland University
// Copyright (C) 2014-2015 Claus Faymonville
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

#ifndef FIXEDLATENCYSTATE_H
#define FIXEDLATENCYSTATE_H

#include "MicroarchitecturalAnalysis/MicroArchitecturalState.h"

#include "ARM.h"

#include <boost/optional/optional.hpp>

#include <set>

namespace TimingAnalysisPass {

/**
 * Class implementing the cycle-based semantics of a very simple processor with
 * (configurable) fixed-latency instructions (no pipelining).
 * The resulting analysis is basically a counter-based microarchitectural
 * analysis.
 *
 * MJa: TODO: Add the needed template parameters to provide BCET support as well
 * ^^ Although this is not really needed. For the fixed latency architecture
 *    as currently implemented, the local metric for upper bounds on the time
 *    can as well be used as lower bound in the BCET calculation.
 */
class FixedLatencyState
    : public MicroArchitecturalState<FixedLatencyState,
                                     std::tuple<InstrContextMapping &>> {
public:
  // define SuperClass for convenience
  typedef MicroArchitecturalState<FixedLatencyState,
                                  std::tuple<InstrContextMapping &>>
      SuperClass;

  /**
   * Constructor. Creates an empty microarchitectural state (i.e. all
   * microarchitectural entities are empty - just as after reset) but with the
   * given program counter.
   */
  explicit FixedLatencyState(ProgramLocation &pl);
  /**
   * Copy Constructor
   */
  explicit FixedLatencyState(const FixedLatencyState &fls);

  /**
   * Virtual destructor
   */
  virtual ~FixedLatencyState() { /* Nothing to clean up */
  }

  /**
   * Container used to make the local metrics of this class
   * available to the world outside.
   */
  struct LocalMetrics : SuperClass::LocalMetrics {
    // shorthand for the base class
    typedef typename SuperClass::LocalMetrics LocalMetricsBase;

    // the fields added to the local metrics used as base
    /*none*/

    /**
     * Creates the local metrics based on the
     * outer class' content.
     */
    LocalMetrics(const FixedLatencyState &outerClassInstance)
        : LocalMetricsBase(outerClassInstance) {}

    /**
     * Checks for equality between local metrics.
     */
    bool operator==(const LocalMetrics &anotherInstance) {
      return LocalMetricsBase::operator==(anotherInstance);
    }
  };

  /**
   * Resets the local metrics to their initial values.
   */
  void resetLocalMetrics() { SuperClass::resetLocalMetrics(); }

  /**
   * See superclass first.
   * Basically count down the latency of the instruction currently being
   * executed.
   */
  virtual StateSet cycle(std::tuple<InstrContextMapping &> &dep) const;
  /**
   * See superclass first.
   * MI is final when it was executed the previous cycle and its latency reached
   * 0 by entering this state.
   */
  virtual bool isFinal(ExecutionElement &pl);

  /// \see superclass
  bool operator==(const FixedLatencyState &ds) const;

  /// \see superclass
  virtual bool isJoinable(const FixedLatencyState &ds) const;

  /// \see superclass
  virtual void join(const FixedLatencyState &ds);

  /// \see superclass
  virtual size_t hashcode() const;

  // Output operation
  friend std::ostream &operator<<(std::ostream &stream,
                                  const FixedLatencyState &fls);

private:
  /**
   * The execution element (aka instruction) that is currently executed.
   */
  boost::optional<ExecutionElement> inflightInstruction;
  /**
   * The time remaining until the current in-flight element (\see
   * inflightInstruction) is fully executed.
   */
  unsigned remainingExecutionTime;
};

} // namespace TimingAnalysisPass

#endif
