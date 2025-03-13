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

#ifndef REORDERBUFFER_H
#define REORDERBUFFER_H

#include "MicroarchitecturalAnalysis/ExecutionElement.h"

namespace TimingAnalysisPass {

/**
 * Possible states of reorder buffer elements.
 */
enum class ROB_State {
  Execute,   // current element is in execution
  Write_Back // current element is ready to be written back
};

/**
// TODO(SH) Flaw here, an instruction on ARM can write-back up to 16 registers
(load/store multiple) or normal instr up to two.
// Implement this via a bitmap in the third argument to be space-efficient?
 * Contains the instruction, the current state of execution and the destination
registers.
 * Destination register is represented as a set.
 * Value is not needed for the analysis.
 */
typedef std::tuple<ExecutionElement, ROB_State, std::set<unsigned>>
    ReOrderBufferElement;

#ifndef COMMONDATABUS_H

class CommonDataBus;

#endif

#ifndef REGISTERSTATUSTABLE_H

class RegisterStatusTable;

#endif

class ReOrderBuffer {

public:
  ReOrderBuffer();

  ReOrderBuffer(const ReOrderBuffer &robu);

  bool operator==(const ReOrderBuffer &rob) const;

  size_t hashcode() const;

  friend std::ostream &operator<<(std::ostream &stream,
                                  const ReOrderBuffer &rob);

  unsigned getRelativeToHead(unsigned number) const;

  ExecutionElement getExecutionElementForRobTag(unsigned robInd) const;

  /**
   * Returns whether there are free positions in the buffer.
   */
  bool isFull() const;

  /**
   * Returns whether there are no instructions in the buffer.
   */
  bool isEmpty() const;

  /**
   * Returns whether the instruction at this array index is already executed and
   * therefore in WRITE_BACK state. This means that operands from this
   * instruction are ready.
   */
  bool isExecuted(int robArrayIndex) const;

  /**
   * Issues a new instruction from the instruction queue to this buffer.
   * Stores the destination registers.
   * Returns the position in the reorder buffer.
   */
  unsigned issueInstruction(ExecutionElement mi);

  /**
   * Cycles the reorder buffer.
   * Sets an instruction to finished if that is on the cdb,
   * and commits instructions from the reorder buffer.
   * Returns a list of all finished execution elements.
   */
  std::list<ExecutionElement> cycle(const CommonDataBus &oldCdb);

  /**
   * Notifies the reorder buffer that an instruction has finished execution.
   * The instruction is identified by the rob tag.
   * TODO check whether it is possible to do this in rob.cycle - asking the cdb
   * what is finished right now
   * TODO cycle rob after the instruction queue in ooops, contains
   * finishExecution and commitInstructions
   */
  void finishExecution(unsigned robArrayIndex);

  /**
   * Tries to commit as many instructions as possible.
   * Returns the list of finalized execution elements.
   */
  std::list<ExecutionElement> commitInstructions();

  /**
   * Checks whether there is an unresolved branch between robHead and the given
   * robTag.
   */
  bool isUnresolvedBranchBefore(unsigned robTag) const;

  /**
   * Clears the re order buffer.
   */
  void flush();

  /**
   * Returns the execution element at the head position, if any.
   */
  boost::optional<ExecutionElement> getHeadElement() const;

  void reassignPointers(RegisterStatusTable *rst);

  /**
   * Return the set of reorder buffer tags that are currently supposed to be
   * executed.
   */
  std::set<unsigned> getExecutingRobTags() const;

private:
  static const unsigned ROB_SIZE = 8;

  /**
   * The actual reorder buffer.
   */
  boost::optional<ReOrderBufferElement> rob[ROB_SIZE];

  /**
   * Tail entry for the reorder buffer.
   * Marks the next free array index.
   */
  unsigned robTail;

  /**
   * Head entry for the reorder buffer.
   * Marks the next array index of instruction which can be written back.
   */
  unsigned robHead;

  RegisterStatusTable *rst;
};

} // namespace TimingAnalysisPass

#endif /* REORDERBUFFER_H */
