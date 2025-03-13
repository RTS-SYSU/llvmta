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

#ifndef CONTEXTAWAREANALYSISDOMAIN_H
#define CONTEXTAWAREANALYSISDOMAIN_H

#include "ARM.h"
#include "AnalysisFramework/AnalysisInformation.h"
#include "AnalysisFramework/PartitioningDomain.h"
#include "PartitionUtil/Context.h"

#include <tuple>

namespace TimingAnalysisPass {

/**
 * This the interface class for context-aware analysis domains that follow the
 * control-flow-graph, i.e. ordinary context-aware dataflow-analyses that only
 * depend on ISA information. Context-aware means, that the transfer function
 * knows about the context it is executed in.
 *
 * - AnalysisImplementation: The Type of an actual analysis implementation.
 * Used for proper type of join.
 * - Granularity: The granularity this analysis operates on.
 * The transfer function works stepwise on this granularity.
 * - AnalysisDependencies: Variable number of Analysis Dependencies.
 * Specify analyses that AnalysisImplementation depends on.
 * Proper information is provided on each transfer.
 */
template <class AnalysisImplementation, typename Granularity,
          class AnalysisDependencies>
class ContextAwareAnalysisDomain {
public:
  typedef AnalysisInformation<
      PartitioningDomain<AnalysisImplementation, Granularity>, Granularity>
      AnalysisInfo;

  typedef AnalysisDependencies AnaDeps;

  /**
   * Identifier for debugging purposes
   */
  static std::string analysisName(const char *prefix) {
    return std::string(prefix) + "NONAME";
  }

  /**
   * Each analysis can decide whether analysis information before
   * the given instruction should be precomputed.
   */
  static bool anainfoBeforeRequired(const MachineInstr *MI) { return true; }
  /**
   * Each analysis can decide whether analysis information after
   * the given instruction should be precomputed.
   */
  static bool anainfoAfterRequired(const MachineInstr *MI) { return true; }

  /**
   * Makes an in-place update of analysis information.
   * The AnalysisDomain information is changed according to the execution of the
   * machine instruction MI in context currentCtx. It implements the abstract
   * transformer. The tuple anaInfo provides analysis information that this
   * analysis depends on.
   */
  virtual void transfer(const Granularity *g, Context *currentCtx,
                        AnaDeps &anaInfo) = 0;
  /**
   * Guard this analysis information under the assumption that the instruction
   * MI in context currentCtx has the predication outcome po. This information
   * can be used to sharpen this analysis information. This information is
   * typically the result of the transfer of MI. This function updates in-place,
   * so copying is needed if both outcomes should be evaluated. By default,
   * nothing happens.
   */
  virtual void guard(const MachineInstr *MI, Context *currentCtx,
                     AnaDeps &anaInfo, BranchOutcome bo) {}

  /**
   * Makes an in-place update of pre-call analysis information when a call is
   * analysed. This prototype implementation uses normal transfer and
   * handleCallingConventions. Specialised variants are possible via overriding
   * (inheritance), e.g. for microarch. analysis.
   *
   * Additionally:
   * It extracts the correct information from calleeOut to the returnValue
   * (possibly doing filtering on return)
   * It updates this information in-place to become relevant calleeIn
   * information (possibly doing filtering on call)
   */
  virtual AnalysisImplementation
  transferCall(const MachineInstr *callInstr, Context *ctx, AnaDeps &anaInfo,
               const MachineFunction *callee,
               AnalysisImplementation &calleeOut) {
    // FIXME what if call is predicated?
    // If call is unreachable, every successor is also unreachable
    if (this->lessequal(AnalysisImplementation(AnaDomInit::BOTTOM))) {
      return AnalysisImplementation(AnaDomInit::BOTTOM);
    }
    // Compute calleeout information by additionally calling
    // handleCallingConvention on this
    AnalysisImplementation retVal(calleeOut);
    AnalysisImplementation *this_impl =
        dynamic_cast<AnalysisImplementation *>(this);
    assert(this_impl && "Internal error: Analysis has incorrect subtype");
    retVal.handleCallingConvention(*this_impl);

    // In place update for callee in information
    this->transfer(callInstr, ctx, anaInfo);

    return retVal;
  }

  /**
   * Transfer function for entering the given basic block. By default do
   * nothing.
   */
  virtual void enterBasicBlock(const llvm::MachineBasicBlock *mbb) {}
  /**
   * Joins this analysis information with the provided one.
   */
  virtual void join(const AnalysisImplementation &element) = 0;
  /**
   * Partial order test of elements form this analysis domain.
   */
  virtual bool lessequal(const AnalysisImplementation &element) const = 0;
  /**
   * Is this element bottom?
   */
  virtual bool isBottom() const = 0;
  /**
   * Pretty-Prints the analysis information.
   */
  virtual std::string print() const = 0;

  friend std::ostream &
  operator<<(std::ostream &stream,
             const ContextAwareAnalysisDomain<AnalysisImplementation,
                                              Granularity, AnaDeps> &caad) {
    stream << caad.print();
    return stream;
  }

protected:
  /**
   * Allows the analysis to handle calling conventions of the underlying
   * systems. This is the joined analysis information of all callee,
   * preCallElement the analysis information directly before the call. E.g. the
   * info for callee-save registers can be rescued.
   */
  virtual void
  handleCallingConvention(const AnalysisImplementation &preCallElement) {}
};

} // namespace TimingAnalysisPass

#endif
