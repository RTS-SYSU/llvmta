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

#ifndef REGISTERSTATUSTABLE_H
#define REGISTERSTATUSTABLE_H

#include "LLVMPasses/TimingAnalysisMain.h"
#include "Util/Util.h"

#include <boost/optional.hpp>

#include <ARMBaseRegisterInfo.h>
#include <ARMInstrInfo.h>
#include <llvm/CodeGen/MachineInstr.h>

#include <map>

namespace TimingAnalysisPass {

#ifndef REORDERBUFFER_H

class ReOrderBuffer;

#endif

/**
 * Table to store for each register entry, if there is currently an instruction
 * in the reorder buffer writing to it, if yes, which re order buffer tag.
 * Always contains the current state w.r.t. the next instruction to be
 * dispatched. //TODO check issue/dispatch terminology Is used by new
 * instructions to check whether there is an entry for a needed operand.
 */
class RegisterStatusTable {

public:
  RegisterStatusTable();

  RegisterStatusTable(const RegisterStatusTable &rst);

  bool operator==(const RegisterStatusTable &rst) const;

  size_t hashcode() const;

  friend std::ostream &operator<<(std::ostream &stream,
                                  const RegisterStatusTable &rst);

  void reassignPointers(ReOrderBuffer *robu);

  // TODO think about better names for the next two functions
  /**
   * Notifies the register status table that the instruction with the given
   * reorder buffer tag writes back to the current register
   */
  void markNewWriteBack(unsigned reg, unsigned robTag);

  /**
   * Returns a result which is supposed to be written to the register.
   * Checks whether there is no other reservation station writing to this
   * register, and stores the result. Discard if there is another station.
   */
  void writeResultBack(unsigned reg, unsigned robTag);

  /**
   * Returns the tag of the re order buffer for the given machine operand.
   * Returns none if there is no element in the reorder buffer, meaning that the
   * operand is ready. Calculates the register number using the target machine.
   */
  boost::optional<unsigned> getRobTag(const llvm::MachineOperand *miOp) const;

  /**
   * Discards all entries.
   */
  void flush();

private:
  /**
   * Map from register number to tag (of the reorder buffer).
   * Current entry for a register stores which instruction (identified by rob
   * tag) will write to the register. No entry means that no instruction will
   * write to this register.
   */
  std::map<unsigned, unsigned> regStatTbl;

  ReOrderBuffer *rob;
};

} // namespace TimingAnalysisPass

#endif /* REGISTERSTATUSTABLE_H */
