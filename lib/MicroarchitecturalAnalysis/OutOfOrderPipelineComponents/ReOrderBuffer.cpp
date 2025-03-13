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

#include "MicroarchitecturalAnalysis/OutOfOrderPipelineComponents/ReOrderBuffer.h"
#include "LLVMPasses/StaticAddressProvider.h"
#include "MicroarchitecturalAnalysis/OutOfOrderPipelineComponents/CommonDataBus.h"
#include "MicroarchitecturalAnalysis/OutOfOrderPipelineComponents/RegisterStatusTable.h"

#include "llvm/Support/Debug.h"

#include <utility>

namespace TimingAnalysisPass {

/**
 * Output operator for ROB_State
 */
std::ostream &operator<<(std::ostream &stream, const ROB_State &robSt) {
  switch (robSt) {
  case ROB_State::Execute:
    stream << "Execute";
    break;
  case ROB_State::Write_Back:
    stream << "Write back";
    break;
  }
  return stream;
}

/**
 * Output operator for ReOrderBufferElement
 */
std::ostream &operator<<(std::ostream &stream,
                         const ReOrderBufferElement &robElem) {
  stream << std::get<0>(robElem) << " | State: "
         << std::get<1>(robElem); // << " | Dest: " << std::get<2>(robElem);
  return stream;
}

ReOrderBuffer::ReOrderBuffer() : robTail(0), robHead(0), rst(nullptr) {
  for (unsigned cnt = 0; cnt < ROB_SIZE; cnt++) {
    rob[cnt] = boost::none;
  }
}

ReOrderBuffer::ReOrderBuffer(const ReOrderBuffer &robu)
    : rob(robu.rob), robTail(robu.robTail), robHead(robu.robHead),
      rst(nullptr) {}

bool ReOrderBuffer::operator==(const ReOrderBuffer &rob) const {
  for (unsigned i = 0; i < ROB_SIZE; i++) {
    auto relI = (robHead + i) % ROB_SIZE;
    auto robRelI = (rob.robHead + i) % rob.ROB_SIZE;
    if (this->rob[relI] != rob.rob[robRelI])
      return false;
  }

  return true;
}

size_t ReOrderBuffer::hashcode() const {
  size_t result = 0;

  for (unsigned i = 0; i < ROB_SIZE; i++) {
    unsigned relI = (robHead + i) % ROB_SIZE;
    if (rob[relI]) {
      hash_combine(result, std::get<0>(rob[relI].get()));
      hash_combine(result, (unsigned)std::get<1>(rob[relI].get()));

      for (auto &dest : std::get<2>(rob[relI].get())) {
        hash_combine(result, dest);
      }
    }
  }

  return result;
}

std::ostream &operator<<(std::ostream &stream, const ReOrderBuffer &rob) {
  stream << "Re-Order Buffer: {\n";

  for (unsigned i = 0; i < rob.ROB_SIZE; i++) {
    unsigned relPos = (rob.robHead + i) % rob.ROB_SIZE;
    stream << "Relative Position to head: " << i << ": ";
    if (rob.rob[relPos]) {
      auto robelem = rob.rob[relPos].get();
      stream << robelem;
    } else {
      stream << "Not set";
    }
    stream << "\n";
  }

  stream << "}\n";
  return stream;
}

unsigned ReOrderBuffer::getRelativeToHead(unsigned number) const {
  if (number >= robHead) {
    return number - robHead;
  } else {
    return 8 - robHead + number;
  }
}

ExecutionElement
ReOrderBuffer::getExecutionElementForRobTag(unsigned robInd) const {
  assert(rob[robInd] && "No Instruction at given position in re order buffer.");
  return std::get<0>(rob[robInd].get());
}

bool ReOrderBuffer::isFull() const {
  // checking whether robTail (next free element) is already set, in that case
  // the buffer is full
  return rob[robTail] != boost::none;
}

bool ReOrderBuffer::isEmpty() const {
  return robHead == robTail && rob[robHead] == boost::none;
}

bool ReOrderBuffer::isExecuted(int robArrayIndex) const {
  assert(robArrayIndex >= 0 &&
         "Called isExecuted with a negative array index.");
  return rob[robArrayIndex] &&
         std::get<1>(rob[robArrayIndex].get()) == ROB_State::Write_Back;
}

unsigned ReOrderBuffer::issueInstruction(ExecutionElement ee) {
  assert(!isFull() && "Tried dispatching to a full re order buffer.");
  auto mi = StaticAddrProvider->getMachineInstrByAddr(ee.first);

  std::set<unsigned> destRegs;

  for (const MachineOperand *op = mi->operands_begin();
       op != mi->operands_end(); ++op) {
    // only process destination registers
    if (op->isReg()) {
      if (op->isDef()) {
        unsigned regNum = op->getReg();

        // add to dest registers (set corresponding bit to 1)
        destRegs.insert(regNum);

        // mark write back in register status table
        rst->markNewWriteBack(regNum, robTail);
      }
    }
  }

  rob[robTail] = std::make_tuple(ee, ROB_State::Execute, destRegs);

  unsigned currRobTail = robTail;
  robTail++;
  if (robTail == ROB_SIZE) {
    robTail = 0;
  }
  return currRobTail;
}

std::list<ExecutionElement> ReOrderBuffer::cycle(const CommonDataBus &oldCdb) {
  // finish an instruction if it is on the common data bus
  if (oldCdb.isSet()) {
    auto cdbTag = oldCdb.getCdb();
    finishExecution(cdbTag);
  }

  return commitInstructions();
}

void ReOrderBuffer::finishExecution(unsigned robArrayIndex) {
  assert(
      rob[robArrayIndex] &&
      "There was no element in the reorder buffer at the given array index.");
  std::get<1>(rob[robArrayIndex].get()) = ROB_State::Write_Back;
}

std::list<ExecutionElement> ReOrderBuffer::commitInstructions() {
  std::list<ExecutionElement> committedInstructions;
  // return if there is no element in the pipeline
  if (!rob[robHead]) {
    assert(robHead == robTail && "Tail pointer of reorder buffer is wrong!");
    return committedInstructions;
  }

  // check whether there is still an instruction and it is in write_back state
  while (rob[robHead] &&
         std::get<1>(rob[robHead].get()) == ROB_State::Write_Back) {
    // finish this instruction
    committedInstructions.push_back(std::get<0>(rob[robHead].get()));

    // get all dest registers and tell register status table that these are
    // written back
    for (auto dest : std::get<2>(rob[robHead].get())) {
      rst->writeResultBack(dest, robHead);
    }

    // get the address before the entry is gone
    unsigned addr = std::get<0>(rob[robHead].get()).first;

    // delete it from reorder buffer
    rob[robHead] = boost::none;

    robHead++;
    if (robHead == ROB_SIZE) {
      robHead = 0;
    }

    // only one branch is allowed to write to the pc at a time
    // therefore we stop when there is a branch begin committed
    // TODO allow multiple branches to finish in one cycle - need to take care
    // of taken and not taken cases for subsequent branches
    assert(StaticAddrProvider->hasMachineInstrByAddr(addr) &&
           "Had no machine instruction for address in re order buffer.");
    const MachineInstr *mi = StaticAddrProvider->getMachineInstrByAddr(addr);
    if (mi->isConditionalBranch() || mi->isCall() || mi->isReturn())
      break;
  }

  return committedInstructions;
}

bool ReOrderBuffer::isUnresolvedBranchBefore(unsigned robTag) const {
  unsigned cnt = robHead;
  while (cnt != robTag) {
    assert(
        rob[cnt] &&
        "There was no rob element at a position between robHead and robTag.");
    auto mi = StaticAddrProvider->getMachineInstrByAddr(
        std::get<0>(rob[cnt].get()).first);
    if (mi->isConditionalBranch() || mi->isCall() || mi->isReturn())
      return true;

    cnt++;
    if (cnt == ROB_SIZE) {
      cnt = 0;
    }
  }
  return false;
}

void ReOrderBuffer::flush() {
  // Full case, robHead equals robTail and all entries are valid, just reset all
  // entries
  if (isFull()) {
    for (unsigned i = 0; i < ROB_SIZE; ++i) {
      assert(rob[i] && "Reorder buffer full, but empty entry found.\n");
      rob[i] = boost::none;
    }
  }
  // Non-full case, flush until robHead equals robTail
  while (robHead != robTail) {
    rob[robHead] = boost::none;
    robHead++;
    if (robHead == ROB_SIZE) {
      robHead = 0;
    }
  }
}

boost::optional<ExecutionElement> ReOrderBuffer::getHeadElement() const {
  if (rob[robHead]) {
    return std::get<0>(rob[robHead].get());
  } else {
    return boost::none;
  }
}

void ReOrderBuffer::reassignPointers(RegisterStatusTable *rst2) { rst = rst2; }

std::set<unsigned> ReOrderBuffer::getExecutingRobTags() const {
  std::set<unsigned> res;
  for (unsigned i = 0; i < ROB_SIZE; ++i) {
    if (rob[i] && std::get<1>(rob[i].get()) == ROB_State::Execute) {
      res.insert(i);
    }
  }
  return res;
}

} // namespace TimingAnalysisPass
