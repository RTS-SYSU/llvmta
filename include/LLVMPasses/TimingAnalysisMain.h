////////////////////////////////////////////////////////////////////////////////
//
//   LLVMTA - Timing Analyser performing worst-case execution time analysis
//     using the LLVM backend intermediate representation
//
// Copyright (C) 2013-2022  Saarland University
// Copyright (C) 2014-2015 Claus Faymonville
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

#ifndef TARGET_ARM_TIMINGANALYSISMAIN_H
#define TARGET_ARM_TIMINGANALYSISMAIN_H

#include "ARM.h"
#include "ARMAsmPrinter.h"
#include "ARMMachineFunctionInfo.h"

#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineModuleInfo.h"
#include "llvm/IR/Module.h"
#include "llvm/Support/CommandLine.h"

#include "AnalysisFramework/AnalysisResults.h"
#include "Util/Options.h"

#include <iostream>
#include <map>

using namespace llvm;

namespace TimingAnalysisPass {

// Forward declaration
class AddressInformation;

/**
 * @brief
 * This is the main pass of the timing analysis module. At the end of all
 * Machine-Level passes except CodeEmitter, the timing analysis is triggered.
 * The analysis entry point is given via commandline option. This pass triggers
 * value, microarchitectural, and path analyses. The output is an ILP
 * formulation whose solution is a WCET bound.
 *
 */
class TimingAnalysisMain : public MachineFunctionPass {

public:
  static char ID;
  TimingAnalysisMain(TargetMachine &TM);

  /**
   * This is a dummy function.
   */
  bool runOnMachineFunction(MachineFunction &F);

  /**
   * @brief
   * The timing analysis starts when all previous passes are finished on ALL
   * functions. The timing analysis, i.e. value, microarchitectural, and path
   * analyses are triggered here.
   *
   * @param M
   * @return true
   * @return false
   */
  virtual bool doFinalization(Module &M);

  virtual llvm::StringRef getPassName() const {
    return "TA: Main phase of Timing Analysis, e.g. Value and "
           "Microarchitectural Analyses";
  }

  /**
   * @brief Get the Target Machine object Provide static access to detailed
   * information about the target machine.
   *
   * @return TargetMachine&
   */
  static TargetMachine &getTargetMachine();

private:
  /**
   * @brief
   * Dispatch the value analysis which is specific to the used ISA.
   *
   * @tparam ISA
   */
  template <Triple::ArchType ISA> void dispatchValueAnalysis();

  /**
   * @brief  Select the overall analysis type, so timing, memory access, and
   * cache
   *
   * @param AddressInfo
   */
  void dispatchAnalysisType(AddressInformation &AddressInfo);

  ///////////////////////////
  // Timing/Cache Analysis //
  ///////////////////////////

  /**
   * @brief Dispatch the individual microarchitectures with different memory
   * topologies for timing analysis
   *
   * @param AddressInfo
   * @return boost::optional<BoundItv>
   */
  boost::optional<BoundItv>
  dispatchTimingAnalysis(AddressInformation &AddressInfo);

  /**
   * @brief Dispatch the individual Cache Analysis with different memory
   * topologies for timing analysis
   *
   * @param AddressInfo
   * @return boost::optional<BoundItv>
   */
  boost::optional<BoundItv>
  dispatchCacheAnalysis(AnalysisType Anatype, AddressInformation &AddressInfo);

  // Private fiels
  static TargetMachine *TargetMachineInstance;
};

/**
 * @brief Get the Initial Stack Pointer object.
 * Provide access to important options. Here: The initial stack pointer.
 *
 * @return unsigned
 */
unsigned getInitialStackPointer();

/**
 * @brief Get the Initial Link Register object.
 * Provide access to important options. Here: The initial link register.
 *
 * @return unsigned
 */
unsigned getInitialLinkRegister();

/**
 * @brief Get the Analysis Entry Point object.
 * Provide access to important options. Here: The analysis entry point.
 *
 * @return MachineFunction*
 */
MachineFunction *getAnalysisEntryPoint();
} // namespace TimingAnalysisPass

namespace llvm {
FunctionPass *createTimingAnalysisMain(TargetMachine &TM);
} // namespace llvm

#endif
