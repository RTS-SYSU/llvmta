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

#include "MicroarchitecturalAnalysis/ProgramCounter.h"

using namespace llvm;

namespace TimingAnalysisPass {

ProgramCounter::ProgramCounter(unsigned address, Context ctx) {
  pc = std::make_pair(address, ctx);
}

bool ProgramCounter::operator==(const ProgramCounter &pc2) const {
  return pc == pc2.pc;
}

size_t ProgramCounter::hashcode() const {
  size_t res = 0;
  hash_combine(res, pc.first);
  hash_combine(res, pc.second);
  return res;
}

void ProgramCounter::setPc(ExecutionElement ee) { pc = ee; }

ExecutionElement ProgramCounter::getPc() { return pc; }

void ProgramCounter::setAddress(unsigned address) { pc.first = address; }

ExecutionElement ProgramCounter::fetchNextInstruction() {
  // Remember the current execution element
  auto res = this->pc;

  // Update the program counter

  // Compute next instruction address
  auto nextpcAddr = this->pc.first + 4;
  // If current and next address correspond to real instruction
  if (StaticAddrProvider->hasMachineInstrByAddr(this->pc.first) &&
      StaticAddrProvider->hasMachineInstrByAddr(nextpcAddr) &&
      !this->pc.second.isEmpty()) {
    auto currInstr = StaticAddrProvider->getMachineInstrByAddr(this->pc.first);
    auto nextInstr = StaticAddrProvider->getMachineInstrByAddr(nextpcAddr);
    Context nextContext(this->pc.second);
    // If current instruction has after-directive, do update
    if (DirectiveHeuristicsPassInstance->hasDirectiveAfterInstr(currInstr)) {
      nextContext.update(
          DirectiveHeuristicsPassInstance->getDirectiveAfterInstr(currInstr));
    }
    // Same basic block, thus subsequent instructions
    if (currInstr->getParent() == nextInstr->getParent()) {
      // If next instruction has before-directive, do update
      if (DirectiveHeuristicsPassInstance->hasDirectiveBeforeInstr(nextInstr)) {
        nextContext.update(
            DirectiveHeuristicsPassInstance->getDirectiveBeforeInstr(
                nextInstr));
      }
      this->pc = std::make_pair(nextpcAddr, nextContext);
    } else {
      // If first non-empty (transitive) successor basic block,
      // do directive updates and context edge transfer
      if (auto edgesSet =
              getEdgesBetween(currInstr->getParent(), nextInstr->getParent())) {
        Context lastContext;
        for (auto list : *edgesSet) {
          Context imContext(nextContext);
          for (auto edge : list) {
            // errs() << "inside for, address: " << edge << "\n";
            if (DirectiveHeuristicsPassInstance->hasDirectiveOnEdgeEnter(
                    edge)) {
              for (auto direc :
                   *DirectiveHeuristicsPassInstance->getDirectiveOnEdgeEnter(
                       edge)) {
                imContext.update(direc);
              }
            }
            imContext.transfer(edge);
            if (DirectiveHeuristicsPassInstance->hasDirectiveOnEdgeLeave(
                    edge)) {
              for (auto direc :
                   *DirectiveHeuristicsPassInstance->getDirectiveOnEdgeLeave(
                       edge)) {
                imContext.update(direc);
              }
            }
          }
          if (DirectiveHeuristicsPassInstance->hasDirectiveBeforeInstr(
                  nextInstr)) {
            imContext.update(
                DirectiveHeuristicsPassInstance->getDirectiveBeforeInstr(
                    nextInstr));
          }
          if (lastContext.isEmpty()) {
            lastContext = imContext;
          } else {
            assert(lastContext == imContext &&
                   "Contexts of different paths were different as well!");
          }
        }
        nextContext = lastContext;
        this->pc = std::make_pair(nextpcAddr, nextContext);
        // We do not need edgesSet any more, free it
        delete edgesSet;
      } else {
        // else invalidate context
        std::list<PartitionToken *> empty;
        Context emptyCtx(empty);
        this->pc = std::make_pair(nextpcAddr, emptyCtx);
      }
    }
  } else {
    // One of them does not belong to a machine instruction, so we do not have a
    // meaningful context
    std::list<PartitionToken *> empty;
    Context emptyCtx(empty);
    this->pc = std::make_pair(nextpcAddr, emptyCtx);
  }

  // Return old pc which is next to fetch instruction
  return res;
}

} // namespace TimingAnalysisPass
