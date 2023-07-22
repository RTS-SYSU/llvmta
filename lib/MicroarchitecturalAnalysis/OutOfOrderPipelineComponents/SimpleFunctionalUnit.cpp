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

#include "MicroarchitecturalAnalysis/OutOfOrderPipelineComponents/SimpleFunctionalUnit.h"

#include <llvm/Support/Debug.h>

namespace TimingAnalysisPass {

SimpleFunctionalUnit::SimpleFunctionalUnit()
    : FunctionalUnit(), executingInstruction(boost::none) {}

SimpleFunctionalUnit::SimpleFunctionalUnit(const SimpleFunctionalUnit &sfu)
    : FunctionalUnit(sfu), executingInstruction(sfu.executingInstruction) {}

FunctionalUnit *SimpleFunctionalUnit::clone() const {
  return new SimpleFunctionalUnit(*this);
}

bool SimpleFunctionalUnit::equals(const FunctionalUnit &fu) const {
  auto &sfu = dynamic_cast<const SimpleFunctionalUnit &>(fu);

  if (((bool)executingInstruction) != ((bool)sfu.executingInstruction)) {
    return false;
  }
  // check executing instruction
  if (executingInstruction) {
    const std::tuple<unsigned, unsigned, std::set<unsigned>> &eIpair =
        executingInstruction.get();
    const std::tuple<unsigned, unsigned, std::set<unsigned>> &sfuEIpair =
        sfu.executingInstruction.get();
    if (this->rob->getRelativeToHead(std::get<0>(eIpair)) !=
        sfu.rob->getRelativeToHead(std::get<0>(sfuEIpair))) {
      return false;
    }
    if (std::get<1>(eIpair) != std::get<1>(sfuEIpair)) {
      return false;
    }
    if (std::get<2>(eIpair) != std::get<2>(sfuEIpair)) {
      return false;
    }
  }

  return FunctionalUnit::equals(fu);
}

size_t SimpleFunctionalUnit::hashcode() const {
  size_t result = FunctionalUnit::hashcode();

  if (executingInstruction) {
    // hash rob-tag relative to the re order buffer
    hash_combine(result, this->rob->getRelativeToHead(
                             std::get<0>(executingInstruction.get())));
    // hash time it executed
    hash_combine(result, std::get<1>(executingInstruction.get()));
    for (auto time : std::get<2>(executingInstruction.get())) {
      hash_combine(result, time);
    }
  }

  return result;
}

void SimpleFunctionalUnit::output(std::ostream &stream) const {
  stream << "Simple Functional Unit: {\n";

  if (executingInstruction) {
    stream << "Executing instruction with tag "
           << this->rob->getRelativeToHead(
                  std::get<0>(executingInstruction.get()))
           << "\n";
    stream << "Time executed: " << std::get<1>(executingInstruction.get())
           << "\n";
    stream << "Time this instruction might take: ";
    for (unsigned t : std::get<2>(executingInstruction.get())) {
      stream << t << ", ";
    }
    stream << "\n";
  } else {
    stream << "No instruction executing.\n";
  }

  FunctionalUnit::output(stream);

  stream << "}\n";
}

bool SimpleFunctionalUnit::canExecuteInstruction(const MachineInstr *mi) const {
  // Simple functional unit accepts all instructions except for branches and
  // load/stores
  return !(mi->isBranch() || mi->isCall() || mi->isReturn() || mi->mayLoad() ||
           mi->mayStore());
}

bool SimpleFunctionalUnit::isFree() const {
  return FunctionalUnit::isFree() && executingInstruction == boost::none;
}

void SimpleFunctionalUnit::executeInstruction(unsigned robTag) {
  assert(isFree() && "Functional Unit was not free!");

  unsigned addr = rob->getExecutionElementForRobTag(robTag).first;
  assert(StaticAddrProvider->hasMachineInstrByAddr(addr) &&
         "No machine instruction for this address.");
  unsigned opcode =
      StaticAddrProvider->getMachineInstrByAddr(addr)->getOpcode();
  assert(instructionExecutionTimes.count(opcode) > 0 &&
         "No execution times found for instruction.");
  std::set<unsigned> finishTimes = instructionExecutionTimes.at(opcode);
  // set instruction
  executingInstruction = std::make_tuple(robTag, 0, finishTimes);
}

std::list<FunctionalUnit *> SimpleFunctionalUnit::cycle(
    std::tuple<InstrContextMapping &, AddressInformation &> &dep) {
  std::list<FunctionalUnit *> result;
  SimpleFunctionalUnit *sfu = new SimpleFunctionalUnit(*this);
  // cycle
  if (sfu->executingInstruction) {
    auto &eIt = sfu->executingInstruction.get();
    unsigned timeExecuted = ++std::get<1>(eIt);

    std::set<unsigned> &finishTimes = std::get<2>(eIt);
    auto lowestTimeIt = finishTimes.begin();
    if (*lowestTimeIt == timeExecuted) {
      // instruction might have finished
      finishTimes.erase(lowestTimeIt);
      if (finishTimes.size() > 0) {
        // instruction might still be executing, split here
        assert(*(finishTimes.begin()) > timeExecuted &&
               "Multiple identical finish times for instruction.");
        SimpleFunctionalUnit *newSfu = new SimpleFunctionalUnit(*sfu);
        result.push_back(newSfu);
      }
      // set finished instruction after the split on sfu
      sfu->finishedInstruction = std::get<0>(eIt);
      sfu->executingInstruction = boost::none;
    }
  }
  result.push_back(sfu);
  return result;
}

void SimpleFunctionalUnit::flush() {
  FunctionalUnit::flush();
  executingInstruction = boost::none;
}

std::set<unsigned> SimpleFunctionalUnit::getExecutingRobTags() const {
  std::set<unsigned> res;
  if (executingInstruction) {
    res.insert(std::get<0>(executingInstruction.get()));
  }
  if (this->finishedInstruction) {
    res.insert(this->finishedInstruction.get());
  }
  return res;
}

} // namespace TimingAnalysisPass
