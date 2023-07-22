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

#ifndef STATEGRAPHCONSTRCALLBACK_H
#define STATEGRAPHCONSTRCALLBACK_H

#include "PathAnalysis/StateGraphIsEdgeJoinableCallback.h"

namespace TimingAnalysisPass {

class StateGraphConstrCallback : public StateGraphIsEdgeJoinableCallback {
public:
  /**
   * Add an edge s->e while intra-basic-block weights are constructed.
   * Take the maximum time for all states at e, time for s should be zero.
   */
  virtual void addEdge(unsigned s, unsigned e) = 0;
  /**
   * Advance all incoming edges of curr towards each state of succs.
   * This involves updating the weights. Finally delete the curr state.
   */
  virtual void advanceEdges(unsigned curr, std::list<unsigned> succs) = 0;
  /**
   * This variant does the same as advanceEdges.
   * However, it first stores the results to some temporary
   * data structures. The changes are later only committed
   * to edge2weight if no weight provider detected any
   * failed successors in this first step.
   */
  virtual std::set<unsigned> advanceEdgesPrepare(unsigned curr,
                                                 std::list<unsigned> succs) = 0;
  /**
   * This can be used to commit the changes prepared
   * in the previous method.
   */
  virtual void advanceEdgesCommit() = 0;
  /**
   * This can be used to roll back the changes prepared
   * in advanceEdgesPrepare.
   */
  virtual void advanceEdgesRollBack() = 0;
  /**
   * If joinable is set:
   * Move the edge targets of edge p->t from t to nt.
   * If the edge p->nt already existed, join weights. Finally remove t.
   * If joinable is not set:
   * Add an edge between t and nt with neutral weight. Do not remove t.
   */
  virtual void updateEdgeTarget(unsigned p, unsigned t, unsigned nt,
                                bool joinable) = 0;
  /**
   * Concatenate edges, i.e. for all predecessor p of predold do:
   * weight of (p->fresh) = sum of weight of (p->predold) and weight of
   * (predold->old). The old weights p->predold and predold->old can be removed.
   */
  virtual void concatEdges(unsigned predold, unsigned old, unsigned fresh) = 0;
  /**
   * Add an edge s->e modelling the effects of external function extfun.
   */
  virtual void addExternalEdge(std::string extfun, unsigned s, unsigned e) = 0;
  /**
   * Give a string representation of the collected weight for edge a->b.
   */
  virtual std::string getWeightDescr(unsigned a, unsigned b) const = 0;
};

} // namespace TimingAnalysisPass

#endif
