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

#include "MicroarchitecturalAnalysis/FixedLatencyState.h"

using namespace llvm;

namespace TimingAnalysisPass {

FixedLatencyState::FixedLatencyState(ProgramLocation &pl)
    : MicroArchitecturalState(pl), inflightInstruction(boost::none),
      remainingExecutionTime(0) {}

FixedLatencyState::FixedLatencyState(const FixedLatencyState &fls)
    : MicroArchitecturalState(fls),
      inflightInstruction(fls.inflightInstruction),
      remainingExecutionTime(fls.remainingExecutionTime) {}

FixedLatencyState::StateSet
FixedLatencyState::cycle(std::tuple<InstrContextMapping &> &dep) const {
  // Result set
  StateSet res;

  // Copy this state for the successor
  FixedLatencyState succ(*this);
  // Increment the base time counter for the successor state
  ++succ.time;

  // There is nothing left to do for current execution element
  if (succ.remainingExecutionTime == 0) {
    // Get the next instruction
    auto fetchedElement = succ.pc.fetchNextInstruction();
    succ.inflightInstruction = fetchedElement;
    // Each instruction takes two cycles to execute
    succ.remainingExecutionTime = 2;
  } else {
    assert(succ.inflightInstruction &&
           "Non-zero remaining execution time for non-existing instr");
    // Do one cycle of computation
    --succ.remainingExecutionTime;
    // Completes in succ cycle, make write-back effects visible (e.g. the
    // changed pc due to branching)
    if (succ.remainingExecutionTime == 0) {
      auto completingInstr = StaticAddrProvider->getMachineInstrByAddr(
          succ.inflightInstruction.get().first);
      if (completingInstr->isBranch() || completingInstr->isCall() ||
          completingInstr->isReturn()) {
        auto &ins2ctx = std::get<0>(dep);
        auto alternativeSucc =
            succ.handleBranching(succ.inflightInstruction.get(), ins2ctx);
        res.insert(alternativeSucc.begin(), alternativeSucc.end());
      }
    }
  }

  // Return the successor state wrapped to a set
  res.insert(succ);
  return res;
}

bool FixedLatencyState::isFinal(ExecutionElement &pl) {
  // If we do not have an inflight-instruction, we cannot be final
  if (!this->inflightInstruction) {
    return false;
  }
  // If we have an inflight element, we are final if
  // * inflight == pl
  // * there is no execution time remaining
  auto x = this->inflightInstruction.get();
  return StaticAddrProvider->goesExternal(pl.first) ||
         (pl.first == x.first && pl.second == x.second &&
          this->remainingExecutionTime == 0);
}

bool FixedLatencyState::operator==(const FixedLatencyState &ds) const {
  return MicroArchitecturalState::operator==(ds) &&
         this->inflightInstruction == ds.inflightInstruction &&
         this->remainingExecutionTime == ds.remainingExecutionTime;
}

bool FixedLatencyState::isJoinable(const FixedLatencyState &ds) const {
  return MicroArchitecturalState::isJoinable(ds) &&
         this->inflightInstruction == ds.inflightInstruction &&
         this->remainingExecutionTime == ds.remainingExecutionTime;
}

void FixedLatencyState::join(const FixedLatencyState &ds) {
  MicroArchitecturalState::join(ds);
  // Only join if inflightinstr equal, nothing to do
  return;
}

size_t FixedLatencyState::hashcode() const {
  // Initial hash by superclass
  size_t val = MicroArchitecturalState::hashcode();
  hash_combine(val, this->remainingExecutionTime);
  if (this->inflightInstruction) {
    auto x = this->inflightInstruction.get();
    hash_combine(val, x.first);
    hash_combine(val, x.second);
  }
  return val;
}

std::ostream &operator<<(std::ostream &stream, const FixedLatencyState &fls) {
  auto &base =
      (const MicroArchitecturalState<FixedLatencyState,
                                     FixedLatencyState::StateDep> &)fls;
  stream << base << "\n";
  stream << "[ Execution Unit: ";
  if (fls.inflightInstruction) {
    stream << fls.inflightInstruction.get();
  } else {
    stream << "None";
  }
  stream << " | Complete in " << fls.remainingExecutionTime << " ]";
  return stream;
}

} // namespace TimingAnalysisPass
