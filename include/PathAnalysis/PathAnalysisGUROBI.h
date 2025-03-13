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

#ifndef PATHANALYSISGUROBI_H
#define PATHANALYSISGUROBI_H

#include "Util/Options.h"

#ifdef GUROBIINSTALLED

#include "LLVMPasses/TimingAnalysisMain.h"
#include "PathAnalysis/PathAnalysis.h"
#include "PathAnalysis/Variable.h"
#include "Util/Graph.h"
#include "Util/Util.h"

extern "C" {
#include <gurobi_c.h>
}

namespace TimingAnalysisPass {

class PathAnalysisGUROBI : public PathAnalysis {
public:
  PathAnalysisGUROBI(ExtremumType extremum, const VarCoeffVector &objfunc,
                     const std::list<GraphConstraint> &constraints);

  virtual ~PathAnalysisGUROBI();

  virtual bool calculateExtremalPath();
  virtual void getExtremalPath(std::map<std::string, double> &valuation);

  virtual void dump(std::ostream &mystream);

  virtual bool isInfinite();
  virtual bool hasSolution();
  virtual BoundItv getSolution();
  virtual bool isSolutionBound();

private:
  /**
   * Gurobi environment
   */
  GRBenv *gurobienv;
  /**
   * Gurobi model
   */
  GRBmodel *gurobi_lp;
};

} // namespace TimingAnalysisPass

#endif

#endif
