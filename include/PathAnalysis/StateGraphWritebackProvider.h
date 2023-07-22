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

#ifndef STATEGRAPHWRITEBACKPROVIDER_H
#define STATEGRAPHWRITEBACKPROVIDER_H

namespace TimingAnalysisPass {
template <class MuState>
class StateGraphWritebackProvider
    : public StateGraphNumericWeightProvider<MuState> {
public:
  typedef unsigned WeightType;

  StateGraphWritebackProvider(
      MuStateGraph<MuState> *stgr,
      const std::function<bool(const typename MuState::LocalMetrics &)>
          justWroteBackLine)
      : StateGraphNumericWeightProvider<MuState>(stgr, justWroteBackLine,
                                                 "writebacks") {
    /* tblass: For some reason passing std::equal
     * directly doesn't work, even after casting.
     * Maybe someone who knows more C++ voodoo can
     * fix this */
    this->setAreWeightsJoinable([](unsigned a, unsigned b) { return a == b; });
  }

  virtual ~StateGraphWritebackProvider() {}

protected:
  typedef typename MuState::LocalMetrics LocalMetrics;

  virtual WeightType advanceWeight(const WeightType &weight,
                                   const LocalMetrics &curr,
                                   const LocalMetrics &succ);
};
template <class MuState>
typename StateGraphWritebackProvider<MuState>::WeightType
StateGraphWritebackProvider<MuState>::advanceWeight(const WeightType &weight,
                                                    const LocalMetrics &curr,
                                                    const LocalMetrics &succ) {
  return weight + this->extractWeight(succ);
}

} // namespace TimingAnalysisPass
#endif
