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

#ifndef TARGET_ARM_MACHINEFUNCTIONCOLLECTOR_H
#define TARGET_ARM_MACHINEFUNCTIONCOLLECTOR_H

#include "ARM.h"
#include "ARMMachineFunctionInfo.h"
#include "llvm/CodeGen/MachineFunctionPass.h"

#include <list>
#include <map>

using namespace llvm;

namespace TimingAnalysisPass {

class MachineFunctionCollector : public MachineFunctionPass {

public:
  static char ID;
  MachineFunctionCollector();
  /**
   * This is the only source that references the MachineFunction objects.
   * If this pass is destructed, all MachineFunction objects should by
   * destructed.
   */
  ~MachineFunctionCollector();

  bool runOnMachineFunction(MachineFunction &F);

  MachineFunction *getFunctionByName(std::string Name);

  bool hasFunctionByName(std::string Name);

  std::list<MachineFunction *> getAllMachineFunctions();

private:
  std::map<std::string, MachineFunction *> Name2func;
};

extern MachineFunctionCollector *machineFunctionCollector;
} // namespace TimingAnalysisPass

namespace llvm {
FunctionPass *createMachineFunctionCollector();
} // namespace llvm

#endif
