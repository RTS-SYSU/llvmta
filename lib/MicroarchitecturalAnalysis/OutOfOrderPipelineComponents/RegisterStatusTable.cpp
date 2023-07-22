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

#include "MicroarchitecturalAnalysis/OutOfOrderPipelineComponents/RegisterStatusTable.h"
#include "LLVMPasses/TimingAnalysisMain.h"
#include "MicroarchitecturalAnalysis/OutOfOrderPipelineComponents/ReOrderBuffer.h"

#include "ARMTargetMachine.h"

using namespace llvm;

namespace TimingAnalysisPass {

RegisterStatusTable::RegisterStatusTable() : regStatTbl(), rob(nullptr) {}

RegisterStatusTable::RegisterStatusTable(const RegisterStatusTable &rst)
    : regStatTbl(rst.regStatTbl), rob(nullptr) {}

bool RegisterStatusTable::operator==(const RegisterStatusTable &rst) const {
  // check all entries
  for (auto rstElem : regStatTbl) {
    // check that there is an entry for the register in the other object as well
    if (rst.regStatTbl.count(rstElem.first) == 0)
      return false;
    // check whether the entries are the same (relative to the re order buffer)
    if (rst.rob->getRelativeToHead(rst.regStatTbl.at(rstElem.first)) !=
        (rob->getRelativeToHead(rstElem.second))) {
      return false;
    }
  }

  // check that the second register status table has no additional entries
  return regStatTbl.size() == rst.regStatTbl.size();
}

size_t RegisterStatusTable::hashcode() const {
  size_t result = 0;

  // process all entries
  for (auto rstElem : regStatTbl) {
    // hash the register
    hash_combine(result, rstElem.first);
    // hash the rob-tag relative to the rob
    hash_combine(result, rob->getRelativeToHead(rstElem.second));
  }

  return result;
}

std::ostream &operator<<(std::ostream &stream, const RegisterStatusTable &rst) {
  stream << "Register Status Table: { \n";

  for (auto rstElem : rst.regStatTbl) {
    stream << "Entry for register #" << rstElem.first << ": "
           << rst.rob->getRelativeToHead(rstElem.second) << "\n";
  }

  stream << "}\n";
  return stream;
}

void RegisterStatusTable::reassignPointers(ReOrderBuffer *robu) { rob = robu; }

void RegisterStatusTable::markNewWriteBack(unsigned reg, unsigned robTag) {
  // overwrite old entries, since this happens in order
  regStatTbl[reg] = robTag;
}

void RegisterStatusTable::writeResultBack(unsigned reg, unsigned robTag) {
  if (regStatTbl[reg] == robTag) {
    // Storing the register value is not needed, happened in value analysis
    regStatTbl.erase(reg);
  }
}

boost::optional<unsigned>
RegisterStatusTable::getRobTag(const llvm::MachineOperand *miOp) const {
  // check whether this instruction needs to wait for another
  assert(miOp->isReg() && "Tried an operand without access to a register.");
  auto regNum = miOp->getReg();
  if (regStatTbl.count(regNum) > 0) {
    return regStatTbl.at(regNum);
  } else {
    return boost::none;
  }
}

void RegisterStatusTable::flush() { regStatTbl.clear(); }

} // namespace TimingAnalysisPass
