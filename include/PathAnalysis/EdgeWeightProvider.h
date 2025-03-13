////////////////////////////////////////////////////////////////////////////////
//
//   LLVMTA - Timing Analyser performing worst-case execution time analysis
//     using the LLVM backend intermediate representation
//
// Copyright (C) 2013-2022  Saarland University
// Copyright (C) 2016			  Tina Jung
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

#ifndef EDGEWEIGHTPROVIDER_H
#define EDGEWEIGHTPROVIDER_H

#include "PathAnalysis/InsensitiveGraph.h"
#include "PathAnalysis/StateSensitiveGraph.h"
#include "Util/Util.h"

namespace TimingAnalysisPass {

template <class WeightType> class EdgeWeightProvider {
public:
  EdgeWeightProvider() : edge2weight() {}

  /**
   * Give the weight we are collecting via this callback.
   */
  WeightType getWeight(unsigned a, unsigned b) const {
    assert(this->edge2weight.count(std::make_pair(a, b)) > 0);
    return this->edge2weight.at(std::make_pair(a, b));
  }
  /**
   * Check if there is a weight at the edge between the given nodes.
   */
  bool hasWeight(unsigned a, unsigned b) const {
    return this->edge2weight.count(std::make_pair(a, b)) > 0;
  }

protected:
  /**
   * Remember the weight information per edge.
   */
  std::map<GraphEdge, WeightType> edge2weight;
};

} // namespace TimingAnalysisPass

#endif
