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

#ifndef FLOWCONSTRAINTPROVIDER_H
#define FLOWCONSTRAINTPROVIDER_H

#include "PathAnalysis/GetEdges.h"
#include "PathAnalysis/Variable.h"
#include "Util/UtilPathAnalysis.h"

namespace TimingAnalysisPass {

/**
 * Class generating flow constraints for the given microarchitectural graph.
 * These flow constraints include the following:
 * 1) Loop bound constraints
 * 2) Call-Return edge constraints
 * 3) Start constraint
 */
class FlowConstraintProvider {
public:
  /**
   * Construct flow constraints for the given graph.
   */
  FlowConstraintProvider(const StateGraph *sg, bool programRunMode = true,
                         bool allowSeveralRuns = false,
                         typename GetEdges::method loopGetInnerEdgesMethod =
                             GetEdges::method::insideProgramRuns,
                         typename GetEdges::method callSiteGetInnerEdgesMethod =
                             GetEdges::method::insideProgramRuns);
  ~FlowConstraintProvider();
  /**
   * Build the constraints.
   */
  void buildConstraints();
  void buildUpperConstraints();
  void buildLowerConstraints();
  /**
   * Returns a list of built flow constraints.
   */
  std::list<GraphConstraint> getConstraints() const;
  std::list<GraphConstraint> getUpperConstraints() const;
  std::list<GraphConstraint> getLowerConstraints() const;
  /**
   * Allows to build the constraints with
   * different variable types than the default
   * ones. This might for example be helpful when the
   * actual path that is argued about is not a run
   * path but we want to additionally specify run
   * constraints on a sub or super path of it.
   */
  void setTimesTakenType(Variable::Type timesTakenType) {
    this->timesTakenType = timesTakenType;
  }
  void setIsStartType(Variable::Type isStartType) {
    this->isStartType = isStartType;
  }
  void setIsEndType(Variable::Type isEndType) { this->isEndType = isEndType; }

private:
  /**
   * Build the constraints that check that the in flow is equal to
   * the out flow for all nodes in the graph.
   */
  void buildInFlowEqualsOutFlowConstraints();
  /**
   * Build the loop constraints with the bounds provided by LoopBoundInfo.
   */
  void buildLoopConstraints(bool upper);
  /**
   * Build the call-/return-edge constraints. Each function returns as often as
   * its called.
   */
  void buildCallReturnConstraints();
  /**
   * Build the start constraint.
   */
  void buildStartConstraint();

  /**
   * Reference to the underlying graph.
   */
  const StateGraph *graph;
  /**
   * Are we only considering program runs or
   * arbitrary paths?
   */
  const bool programRunMode;
  /**
   * In case we are in run mode, are we allowed
   * to execute several complete runs and potentially
   * idle cycles?
   */
  const bool allowSeveralRuns;
  /**
   * An edge getter for the graph.
   */
  GetEdges *getEdges;
  /**
   * Internally used to decide if have to use the
   * general form of constraints or if we can use
   * specially optimized version for program runs.
   */
  bool isGeneralMode() const;
  /**
   * The lists of constraints.
   */
  std::list<GraphConstraint> inFlowEqualsOutFlowConstraints;
  std::list<GraphConstraint> upperLoopConstraints;
  std::list<GraphConstraint> lowerLoopConstraints;
  std::list<GraphConstraint> callReturnConstraints;
  std::list<GraphConstraint> startConstraints;
  /**
   * If this variable is set to true, then the program run
   * mode is realized as an instance of the general mode.
   * This can be used by developers to test if the program run
   * mode and the general mode result in the same bounds for
   * program runs.
   */
  static constexpr bool simulateProgramRunModeByGeneralMode = false;
  /**
   * In general mode, we might need some further
   * functions that are implemented in a different
   * manner depending on the constructor parameters.
   *
   * The tuple type is meant to be used in the following way:
   * - first component provides the actual implementation
   * - second component: implementation may use its first parameter
   * - third component: implementation may use its second parameter
   * This allows a better control over when it is
   * necessary to actually calculate the parameters
   * and when it is safe to pass in empty sets.
   */
  const std::tuple<
      std::function<std::set<GraphEdge>(const std::set<GraphEdge> &inEdges,
                                        const std::set<GraphEdge> &outEdges,
                                        const void *cacheId)>,
      bool, bool>
      loopGetInnerEdgesImpl;
  const std::tuple<
      std::function<std::set<GraphEdge>(const std::set<GraphEdge> &inEdges,
                                        const std::set<GraphEdge> &outEdges,
                                        const void *cacheId)>,
      bool, bool>
      callSiteGetInnerEdgesImpl;
  std::tuple<std::function<std::set<GraphEdge>(
                 const std::set<GraphEdge> &inEdges,
                 const std::set<GraphEdge> &outEdges, const void *cacheId)>,
             bool, bool>
  initializeGetInnerEdgesImpl(typename GetEdges::method method);
  /**
   * We need to be generic in the types for the timesTaken-,
   * isStart- and isEnd-Variables because sometimes we might
   * need to constraint other paths than the one actually
   * determining the objective.
   */
  Variable::Type timesTakenType = Variable::Type::timesTaken;
  Variable::Type isStartType = Variable::Type::isStart;
  Variable::Type isEndType = Variable::Type::isEnd;
};

} // namespace TimingAnalysisPass

#endif
