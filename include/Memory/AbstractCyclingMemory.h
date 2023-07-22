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

#ifndef ABSTRACTCYCLINGMEMORY_H
#define ABSTRACTCYCLINGMEMORY_H

#include "PreprocessingAnalysis/AddressInformation.h"

#include "Util/Util.h"

#include <boost/concept_check.hpp>
#include <boost/static_assert.hpp>
#include <boost/type_traits.hpp>

namespace TimingAnalysisPass {

/**
 * This superclass describes anything that
 * is expected from an instance of an cycling memory.
 */
class AbstractCyclingMemory {
public:
  virtual AbstractCyclingMemory *clone() const = 0;

  virtual ~AbstractCyclingMemory(){};

  /**
   * Container used to make the local metrics of this class
   * available to the world outside.
   */
  struct LocalMetrics {
    virtual ~LocalMetrics(){};

    /**
     * Checks for equality between local metrics.
     */
    virtual bool equals(const LocalMetrics &anotherInstance) = 0;
  };

  virtual LocalMetrics *getLocalMetrics() = 0;

  virtual void resetLocalMetrics() = 0;

  /**
   * Check if the memory is currently busy.
   */
  virtual bool isBusy() const = 0;

  /**
   * Perform one clock cycle in the memory implementation.
   */
  virtual std::list<AbstractCyclingMemory *> cycle() const = 0;

  /**
   * Should the pipeline (and memory topology) stall while memory access is
   * performed?
   */
  virtual bool shouldPipelineStall() const = 0;

  /**
   * Since used in MicroArchitecturalStates, we need to know whether the memory
   * parts are the same.
   */
  virtual bool equals(const AbstractCyclingMemory &am2) const = 0;

  /**
   * Same as for the equality operator, this may be used by "higher" classes.
   */
  virtual size_t hashcode() const = 0;

  virtual bool isJoinable(const AbstractCyclingMemory &am2) const = 0;

  virtual void join(const AbstractCyclingMemory &am2) = 0;

  virtual void print(std::ostream &stream) const = 0;

  virtual std::list<AbstractCyclingMemory *>
  announceAccess(AbstractAddress addr, AccessType t,
                 unsigned numWords) const = 0;

  virtual std::list<AbstractCyclingMemory *> fastForward() const = 0;
};

std::ostream &operator<<(std::ostream &stream,
                         const AbstractCyclingMemory &acm);

} // namespace TimingAnalysisPass

#endif
