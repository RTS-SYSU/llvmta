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

#ifndef STATEGRAPH_H
#define STATEGRAPH_H

#include "Util/Graph.h"
#include "Util/Util.h"

#include "MicroarchitecturalAnalysis/MicroArchitecturalState.h"
#include "PathAnalysis/StateGraphConstrCallback.h"
#include "PathAnalysis/Variable.h"

#include <string>
#include <unordered_map>

namespace TimingAnalysisPass {

/**
 * Interface for all state graphs, the state-sensitive as well as the
 * insensitive ones. The structural part of the state graph is later passed to
 * the Path Analysis to build the ILP model.
 */
class StateGraph {
public:
  /**
   * Register stategraph construction callbacks.
   *
   * We inherently rely on the construction callbacks
   * being iterated over in the exactly same order
   * as they were registered. Make sure to not violate
   * this hypothesis.
   */
  void registerCallback(StateGraphConstrCallback *cb) {
    constructionCallbacks.push_back(cb);
  }

  /**
   * Register stategraph is-edge-joinable callbacks
   */
  void registerIsEdgeJoinableCallback(StateGraphIsEdgeJoinableCallback *cb) {
    isEdgeJoinableCallbacks.push_back(cb);
  }

  virtual void buildGraph() = 0;

  virtual const Graph &getGraph() const = 0;

  virtual std::vector<unsigned>
  getInStates(const MachineBasicBlock *mbb) const = 0;

  virtual std::vector<unsigned>
  getOutStates(const MachineBasicBlock *mbb) const = 0;

  virtual std::vector<unsigned> getCallStates(const MachineInstr *mi) const = 0;

  virtual std::vector<unsigned>
  getReturnStates(const MachineInstr *mi) const = 0;

  /**
   * Return, if possible, the context of the given state.
   * This is possible for state- or context-sensitive graph,
   * but hardly possible for the insensitive graph version.
   * If not supported, return null on default.
   */
  virtual const Context *getContextOfState(unsigned stateid) const {
    return nullptr;
  }

  /* dumps the StateGraph in .vcg format. If optTimesTaken is not NULL it
   * is assumed to be a mapping from LP-variable names to edge
   * frequencies. All variables with frequency > 0 (i.e. the worst-case
   * path) are colored in "this->longestPathColor" */
  virtual void
  dump(std::ostream &mystream,
       const std::map<std::string, double> *optTimesTaken) const = 0;

  virtual ~StateGraph() {}

protected:
  /* helper function: dumps a single edge definition. If onWCETPath is set
   * the edge is considered part of the WCET-path and layouted according to
   * the WCETPathStyle */
  virtual void dumpEdge(std::ostream &stream,
                        std::pair<unsigned, unsigned> edge, std::string &label,
                        bool onWCETPath) const {
    if (!DumpVcgGraph) {
      stream << edge.first << "->" << edge.second << "[ label = \"" << label
             << "\"\n";

      if (onWCETPath) {
        stream << ", color = " << this->WCETPathStyle.color
               << ", penwidth = " << this->WCETPathStyle.thickness << " ";
      }
      stream << "]\n";
    } else {
      stream << "edge : {\n";
      stream << "\tsourcename : \"" << edge.first << "\" ";
      stream << "targetname : \"" << edge.second << "\"\n";
      stream << "\tlabel : \"" << label << "\"\n";

      if (onWCETPath) {
        stream << "\tcolor : " << this->WCETPathStyle.color << "\n";
        stream << "\tthickness: " << this->WCETPathStyle.thickness << "\n";
      }
      stream << "}\n";
    }
  }

  std::list<StateGraphConstrCallback *> constructionCallbacks;
  std::list<StateGraphIsEdgeJoinableCallback *> isEdgeJoinableCallbacks;
  const struct {
    std::string color = "red";
    int thickness = 3;
  } WCETPathStyle;
};

template <class MuState> class MuStateGraph : public StateGraph {
public:
  typedef MuState State;

  virtual void freeMuStates() = 0;
  virtual typename MuState::StateSet getStatesForId(unsigned id) = 0;
  virtual void deleteMuArchInfo() = 0;
};

} // namespace TimingAnalysisPass

#endif
