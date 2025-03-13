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

#include "LLVMPasses/MachineFunctionCollector.h"

#include <iostream>

using namespace llvm;

namespace TimingAnalysisPass {

MachineFunctionCollector *machineFunctionCollector;

char MachineFunctionCollector::ID = 0;

MachineFunctionCollector::MachineFunctionCollector()
    : MachineFunctionPass(ID) {}

MachineFunctionCollector::~MachineFunctionCollector() {}

/**
 * @brief Generates a Map, with MF's and their corresponding names.
 *
 * @param MF
 * @return true
 * @return false
 */
bool MachineFunctionCollector::runOnMachineFunction(MachineFunction &MF) {
  bool Changed = false;
  assert(Name2func.count(MF.getName().str()) == 0 &&
         "We saw the same function twice");

  Name2func.insert(std::make_pair(MF.getName().str(), &MF));

  return Changed;
}

/**
 * @brief Returns all collected MF's.
 *
 * @return std::list<MachineFunction *>
 */
std::list<MachineFunction *>
MachineFunctionCollector::getAllMachineFunctions() {
  std::list<MachineFunction *> Res;
  for (auto It = Name2func.begin(); It != Name2func.end(); ++It) {
    Res.push_back(It->second);
  }
  return Res;
}

/**
 * @brief Returns MF with matching name.
 *
 * @param Name
 * @return MachineFunction*
 */
MachineFunction *MachineFunctionCollector::getFunctionByName(std::string Name) {
  assert(Name2func.count(Name) > 0 &&
         "There is no function with the given name");
  return Name2func.find(Name)->second;
}

/**
 * @brief Returns true if MF, with Name exists.
 *
 * @param Name
 * @return true
 * @return false
 */
bool MachineFunctionCollector::hasFunctionByName(std::string Name) {
  return Name2func.count(Name) > 0;
}

} // namespace TimingAnalysisPass

FunctionPass *llvm::createMachineFunctionCollector() {
  TimingAnalysisPass::machineFunctionCollector =
      new TimingAnalysisPass::MachineFunctionCollector();
  return TimingAnalysisPass::machineFunctionCollector;
}
