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

#ifndef COLLECTINGCONTEXTSDOMAIN_H
#define COLLECTINGCONTEXTSDOMAIN_H

#include "AnalysisFramework/AnalysisDomain.h"

using namespace llvm;

namespace TimingAnalysisPass {

/**
 * Class implementing a dummy analysis that does nothing.
 * Automatically, via the context-sensitive framework, this analysis collect all
 * contexts that are created during and analysis. This analysis is used as a
 * preprocessing analysis to all microarchitectural analyses.
 */
class CollectingContextsDomain
    : public AnalysisDomain<CollectingContextsDomain, MachineInstr,
                            std::tuple<>> {
public:
  /**
   * Initialise this analysis information according to init, i.e. either BOTTOM,
   * TOP, or START.
   */
  explicit CollectingContextsDomain(AnaDomInit init);
  /**
   * Copy constructor.
   */
  CollectingContextsDomain(const CollectingContextsDomain &ccd);
  /**
   * Assignment operator
   */
  CollectingContextsDomain &operator=(const CollectingContextsDomain &other);

  /**
   * Identifier for debugging purposes
   */
  static std::string analysisName(const char *prefix) {
    return std::string(prefix) + "CCD";
  }

  using AnalysisDomain<CollectingContextsDomain, MachineInstr,
                       std::tuple<>>::transfer;
  void transfer(const MachineInstr *MI, std::tuple<> &anaInfo);
  void join(const CollectingContextsDomain &element);
  bool lessequal(const CollectingContextsDomain &element) const;
  std::string print() const;
  bool isBottom() const;

private:
  // This is a bot - top lattice, only two elements.
  bool bot;
};

} // namespace TimingAnalysisPass

#endif
