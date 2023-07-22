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

#ifndef ANALYSISDOMAIN_H
#define ANALYSISDOMAIN_H

#include "ARM.h"
#include "AnalysisFramework/ContextAwareAnalysisDomain.h"
#include "PartitionUtil/Context.h"

namespace TimingAnalysisPass {

/**
 * This the interface class for (non-context-aware) analysis domains that follow
 * the control-flow-graph, i.e. ordinary dataflow-analyses that only depend on
 * ISA information.
 *
 * - AnalysisImplementation: The Type of an actual analysis implementation.
 * Used for proper type of join.
 * - Granularity: The granularity on which the analysis operates.
 * The transfer function operates stepwise on this granularity.
 * - AnalysisDependencies: Variable number of Analysis Dependencies.
 * Specify analyses that AnalysisImplementation depends on.
 * Proper information is provided on each transfer.
 */
template <class AnalysisImplementation, typename Granularity,
          class AnalysisDependencies>
class AnalysisDomain
    : public ContextAwareAnalysisDomain<AnalysisImplementation, Granularity,
                                        AnalysisDependencies> {
public:
  /**
   * Makes an in-place update of analysis information.
   * The AnalysisDomain information is changed according to the execution of the
   * machine instruction MI. It implements the abstract transformer. The tuple
   * anaInfo provides analysis information that this analysis depends on.
   */
  virtual void transfer(const Granularity *g,
                        AnalysisDependencies &anaInfo) = 0;
  // see in Superclass
  virtual void transfer(const Granularity *g, Context *currentCtx,
                        AnalysisDependencies &anaInfo) final {
    // This is not context-aware, same update in each context
    transfer(g, anaInfo);
  }

  /**
   * Guard handling the outcome of a branch. Context-insensitive variant.
   */
  virtual void guard(const MachineInstr *MI, AnalysisDependencies &anaInfo,
                     BranchOutcome bo) {}
  // see in Superclass, make it final such that it cannot be overridden anymore
  virtual void guard(const MachineInstr *MI, Context *currentCtx,
                     AnalysisDependencies &anaInfo, BranchOutcome bo) final {
    guard(MI, anaInfo, bo);
  }

  // see in Superclass
  virtual void
  handleCallingConvention(const AnalysisImplementation &preCallElement){};
  // see in Superclass
  virtual void join(const AnalysisImplementation &element) = 0;
  // see in Superclass
  virtual bool lessequal(const AnalysisImplementation &element) const = 0;
  // see in Superclass
  virtual std::string print() const = 0;
};

} // namespace TimingAnalysisPass

#endif
