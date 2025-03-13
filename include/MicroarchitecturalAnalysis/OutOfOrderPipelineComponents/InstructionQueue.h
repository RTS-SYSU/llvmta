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

#ifndef INSTRUCTIONQUEUE_H
#define INSTRUCTIONQUEUE_H

#include <boost/optional/optional.hpp>
#include <deque>

#include "Memory/MemoryTopologyInterface.h"

#include "MicroarchitecturalAnalysis/ProgramCounter.h"

namespace TimingAnalysisPass {

/**
 * Instruction queue to serve instructions from memory to the pipeline.
 * Contains fetched instructions
 */
template <class OuterState, unsigned InstructionQueue_Size>
class InstructionQueue {
public:
  /**
   * Constructor
   */
  InstructionQueue(OuterState *os);

  /**
   * Copy Constructor
   */
  InstructionQueue(const InstructionQueue &iq);

  bool operator==(const InstructionQueue &iq) const;

  size_t hashcode() const;

  template <class OS, unsigned IQ_S>
  friend std::ostream &operator<<(std::ostream &stream,
                                  const InstructionQueue<OS, IQ_S> &iq);

  void cycle(OuterState *os, InstrContextMapping &ins2ctx);

  /**
   * Method to flush the queue completely.
   * To be used when e.g. the program counter changes.
   */
  void flush(OuterState *os, const llvm::MachineInstr *committedInstr);

  bool isEmpty() const;

  /**
   * Returns the execution element that is leaving the queue next, if any in the
   * queue.
   */
  boost::optional<ExecutionElement> getNextExecutionElement() const;

private:
  void tryIssueInstr(OuterState *os);

  /**
   * Access PC from here, if there is any space left
   * Access memory from here as well
   */
  void fillQueue(OuterState *os, InstrContextMapping &ins2ctx);

  /**
   * Gets the next instruction to dispatch it in the pipeline.
   * If there is no instruction in the queue, returns None.
   * This does not delete the instruction from the queue,
   * since the pipeline needs to check whether it is able to dispatch it.
   */
  boost::optional<ExecutionElement> getInstructionForDispatch() const;

  /**
   * Marks the given execution element as dispatched.
   */
  void instructionIssued(ExecutionElement &ee);

  /**
   * Actual instruction queue.
   * Using deque to be able to iterate over the queue.
   */
  std::deque<ExecutionElement> queue;

  unsigned instrAccessId;

  bool stallFetch;
};

template <class OuterState, unsigned InstructionQueue_Size>
InstructionQueue<OuterState, InstructionQueue_Size>::InstructionQueue(
    OuterState *os)
    : queue(), stallFetch(false) {
  // put first access to memory here
  auto &mt = os->getMemory();
  auto accessRet = mt.accessInstr(os->getPc().getPc().first, 1);
  assert(accessRet && "Access instruction unsuccessful - first access.");
  instrAccessId = accessRet.get();
}

template <class OuterState, unsigned InstructionQueue_Size>
InstructionQueue<OuterState, InstructionQueue_Size>::InstructionQueue(
    const InstructionQueue &iq)
    : queue(iq.queue), instrAccessId(iq.instrAccessId),
      stallFetch(iq.stallFetch) {}

template <class OuterState, unsigned InstructionQueue_Size>
bool InstructionQueue<OuterState, InstructionQueue_Size>::operator==(
    const InstructionQueue &iq) const {
  return this->queue == iq.queue && this->stallFetch == iq.stallFetch;
}

template <class OuterState, unsigned InstructionQueue_Size>
size_t InstructionQueue<OuterState, InstructionQueue_Size>::hashcode() const {
  size_t result = 0;

  for (auto &qe : queue) {
    hash_combine(result, qe);
  }

  hash_combine(result, stallFetch);

  return result;
}

template <class OS, unsigned IQ_S>
std::ostream &operator<<(std::ostream &stream,
                         const InstructionQueue<OS, IQ_S> &iq) {
  stream << "Instruction Queue: {\n";

  stream << " -- first position is the next element to issue --\n";

  unsigned cnt = 0;
  // Output all execution elements
  for (auto &ee : iq.queue) {
    stream << "Queue element at position " << cnt << ": " << ee << "\n";
    cnt++;
  }
  // Output "empty" lines until max size
  for (; cnt < IQ_S; cnt++) {
    stream << "No element in position " << cnt << "\n";
  }

  stream << "Some Instruction is accessed right now.\n";

  if (iq.stallFetch) {
    stream << "Further Fetching is stalled.\n";
  } else {
    stream << "Fetch is enabled and not stalled.\n";
  }

  stream << "}\n";
  return stream;
}

template <class OuterState, unsigned InstructionQueue_Size>
boost::optional<ExecutionElement>
InstructionQueue<OuterState, InstructionQueue_Size>::getInstructionForDispatch()
    const {
  if (queue.size() > 0) {
    return queue.front();
  } else {
    return boost::none;
  }
}

template <class OuterState, unsigned InstructionQueue_Size>
void InstructionQueue<OuterState, InstructionQueue_Size>::instructionIssued(
    ExecutionElement &ee) {
  assert(queue.front() == ee &&
         "Dispatching execution element was not possible.");
  queue.pop_front();
}

template <class OuterState, unsigned InstructionQueue_Size>
void InstructionQueue<OuterState, InstructionQueue_Size>::fillQueue(
    OuterState *os, InstrContextMapping &ins2ctx) {
  // only fill queue, if there are positions available to buffer
  if (queue.size() < InstructionQueue_Size && !stallFetch) {
    if (os->getMemory().finishedInstrAccess(instrAccessId)) {
      // Fetch next instruction which was finished by memory and put it into
      // queue
      ExecutionElement fetchedExecEle = os->getPc().fetchNextInstruction();
      // Put fetched element into the instruction-queue
      queue.push_back(fetchedExecEle);

      // Do early branch handling and stall-fetch hanlding (end of program,
      // return, etc.)
      if (StaticAddrProvider->hasMachineInstrByAddr(fetchedExecEle.first)) {
        assert(!fetchedExecEle.second.isEmpty() &&
               "Empty context for execution element detected.");
        auto mi =
            StaticAddrProvider->getMachineInstrByAddr(fetchedExecEle.first);
        // Check for unconditional branches and calls to handle them early
        if (mi->isUnconditionalBranch() ||
            (mi->isCall() && !isPredicated(mi))) {
          os->earlyBranch(fetchedExecEle, ins2ctx);
        }
        if (mi->isReturn() || isJumpTableBranch(mi)) {
          stallFetch = true;
          return;
        }
      } else {
        // end of program
        // might also be the start of an external function
        assert(StaticAddrProvider->goesExternal(fetchedExecEle.first) &&
               "Found some unexpected address (no machine instruction, not "
               "first external address.)");
        // remove this element from the queue
        queue.pop_back();
        // stop fetching here
        stallFetch = true;
        return;
      }

      // Persistence Scope handling
      if (needPersistenceScopes()) {
        if (StaticAddrProvider->hasMachineInstrByAddr(
                os->getPc().getPc().first) &&
            StaticAddrProvider->hasMachineInstrByAddr(fetchedExecEle.first)) {
          auto fetchedinstr =
              StaticAddrProvider->getMachineInstrByAddr(fetchedExecEle.first);
          auto nextinstr = StaticAddrProvider->getMachineInstrByAddr(
              os->getPc().getPc().first);
          auto edge =
              std::make_pair(fetchedinstr->getParent(), nextinstr->getParent());
          if (edge.first != edge.second &&
              PersistenceScopeInfo::getInfo().entersScope(edge)) {
            const auto &scopes =
                PersistenceScopeInfo::getInfo().getEnteringScopes(edge);
            auto &specScopeEntr = os->getSpeculativeScopeEntrances();
            if (specScopeEntr.count(os->getPc().getPc()) > 0) {
              ++specScopeEntr.at(os->getPc().getPc()).first;
              assert(scopes == specScopeEntr.at(os->getPc().getPc()).second &&
                     "Same instruction gives different scopes");
            } else {
              specScopeEntr.insert(std::make_pair(os->getPc().getPc(),
                                                  std::make_pair(1, scopes)));
            }
            for (auto scope : scopes) {
              DEBUG_WITH_TYPE("persistence",
                              errs()
                                  << "(BB" << edge.first->getNumber() << ", BB"
                                  << edge.second->getNumber() << ") "
                                  << "We are going to enter a scope: "
                                  << scope.getId() << "\n");
              os->getMemory().enterScope(scope);
            }
          }
        }
      }

      // Start the next access
      auto accessRet =
          os->getMemory().accessInstr(os->getPc().getPc().first, 1);
      assert(accessRet &&
             "Access instruction unsuccessful - after an old access.");
      instrAccessId = accessRet.get();
    }
  }
}

template <class OuterState, unsigned InstructionQueue_Size>
void InstructionQueue<OuterState, InstructionQueue_Size>::tryIssueInstr(
    OuterState *os) {
  boost::optional<ExecutionElement> issueInstr = getInstructionForDispatch();
  if (issueInstr) {
    // only issue if the address belongs to the program
    // This is not sound concerning worst case execution time, since succeeding
    // processes could intervene with instructions.
    assert(StaticAddrProvider->hasMachineInstrByAddr(issueInstr.get().first) &&
           "There was no machine instruction for the address to issue.");
    const MachineInstr *mi =
        StaticAddrProvider->getMachineInstrByAddr(issueInstr.get().first);

    // check whether there are free positions in the re order buffer
    auto &rob = os->getReOrderBuffer();
    if (!rob.isFull()) {
      auto &rst = os->getRegisterStatusTable();
      auto &cdb = os->getCDB();
      for (auto &rS : os->getResStations()) {
        // find a reservation station that has a free position for this
        // instruction
        if (rS.canExecuteInstruction(mi) && !rS.isFull()) {
          // instruction can be issued

          // issue to the reservation station
          for (auto &rS : os->getResStations()) {
            if (rS.canExecuteInstruction(mi) && !rS.isFull()) {

              // for each operand
              // check whether it is a source or destination
              // if source, get the robId or mark it as available
              std::unordered_set<unsigned> sources;
              for (const MachineOperand *op = mi->operands_begin();
                   op != mi->operands_end(); ++op) {
                if (op->isReg() && op->isUse() && op->getReg() != 0) {
                  boost::optional<unsigned> robIndex = rst.getRobTag(op);
                  if (robIndex) { // operand is not yet available in the
                                  // register
                    // check whether the preceding instruction is already
                    // finished
                    if (!rob.isExecuted(robIndex.get())) {
                      // check whether the result is on the CDB.
                      if ((!cdb.isSet()) || cdb.getCdb() != robIndex) {
                        // instruction is not executed yet
                        sources.insert(robIndex.get());
                      }
                    }
                  }
                }
              }

              // issue to the reorder buffer
              unsigned robPosOpt = rob.issueInstruction(issueInstr.get());

              rS.issueInstruction(robPosOpt, sources);

              // delete instruction from the queue
              instructionIssued(issueInstr.get());

              break;
            }
          }
        }
      }
    }
  }
}

template <class OuterState, unsigned InstructionQueue_Size>
void InstructionQueue<OuterState, InstructionQueue_Size>::cycle(
    OuterState *os, InstrContextMapping &ins2ctx) {
  tryIssueInstr(os);
  // fill queue only if there is no branch or an early branch
  fillQueue(os, ins2ctx);
}

template <class OuterState, unsigned InstructionQueue_Size>
void InstructionQueue<OuterState, InstructionQueue_Size>::flush(
    OuterState *os, const llvm::MachineInstr *committedInstr) {
  queue.clear();

  // Persistence Scope handling
  // Edge betwen the last committed instruction leading to the flush and the
  // newly set program counter
  if (needPersistenceScopes()) {
    if (StaticAddrProvider->hasMachineInstrByAddr(os->getPc().getPc().first)) {
      auto nextinstr =
          StaticAddrProvider->getMachineInstrByAddr(os->getPc().getPc().first);
      auto edge =
          std::make_pair(committedInstr->getParent(), nextinstr->getParent());
      if (edge.first != edge.second &&
          PersistenceScopeInfo::getInfo().entersScope(edge)) {
        const auto &scopes =
            PersistenceScopeInfo::getInfo().getEnteringScopes(edge);
        auto &specScopeEntr = os->getSpeculativeScopeEntrances();
        if (specScopeEntr.count(os->getPc().getPc()) > 0) {
          ++specScopeEntr.at(os->getPc().getPc()).first;
          assert(scopes == specScopeEntr.at(os->getPc().getPc()).second &&
                 "Same instruction gives different scopes");
        } else {
          specScopeEntr.insert(
              std::make_pair(os->getPc().getPc(), std::make_pair(1, scopes)));
        }
        for (auto scope : scopes) {
          DEBUG_WITH_TYPE("persistence",
                          errs() << "(BB" << edge.first->getNumber() << ", BB"
                                 << edge.second->getNumber() << ") "
                                 << "We are going to enter a scope: "
                                 << scope.getId() << "\n");
          os->getMemory().enterScope(scope);
        }
      }
    }
  }

  auto accessRet = os->getMemory().accessInstr(os->getPc().getPc().first, 1);
  assert(accessRet && "Memory did not accept fresh access after flush");
  instrAccessId = accessRet.get();
  stallFetch = false;
}

template <class OuterState, unsigned InstructionQueue_Size>
bool InstructionQueue<OuterState, InstructionQueue_Size>::isEmpty() const {
  return queue.size() == 0;
}

template <class OuterState, unsigned InstructionQueue_Size>
boost::optional<ExecutionElement>
InstructionQueue<OuterState, InstructionQueue_Size>::getNextExecutionElement()
    const {
  return getInstructionForDispatch();
}

} // namespace TimingAnalysisPass

#endif /* INSTRUCTIONQUEUE_H */
