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

#ifndef TIMINGANALYSIS_CONVERGENCE_TYPE_H
#define TIMINGANALYSIS_CONVERGENCE_TYPE_H

namespace TimingAnalysisPass {

/**
 * The possible types of convergence that a
 * pipeline state might report to its memory
 * topology.
 *
 * Convergence in this sense means that the
 * abstract pipeline state is guaranteed to
 * stay unchanged at least until some defined
 * event occurs.
 */
enum ConvergenceType {
  /**
   * The pipeline state is potentially
   * not converged.
   */
  POTENTIALLY_NOT_CONVERGED = 1,
  /**
   * The pipeline state is definitely
   * converged until the instruction or
   * the data memory is non-busy.
   */
  CONVERGED_UNTIL_ANY_MEMORY_NON_BUSY = 2,
  /**
   * The pipeline state is definitely
   * converged until the instruction
   * memory is non-busy.
   */
  CONVERGED_UNTIL_INSTR_MEMORY_NON_BUSY = 3,
  /**
   * The pipeline state is definitely
   * converged until the data memory
   * is non-busy.
   */
  CONVERGED_UNTIL_DATA_MEMORY_NON_BUSY = 4
};

} // namespace TimingAnalysisPass

#endif
