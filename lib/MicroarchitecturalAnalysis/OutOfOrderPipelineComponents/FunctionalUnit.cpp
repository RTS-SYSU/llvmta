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

#include "MicroarchitecturalAnalysis/OutOfOrderPipelineComponents/FunctionalUnit.h"

/**
 * 0 means a variable-latency execution latency configuration
 * 1 means a one-cycle execution latency for each instruction
 * 2 means a two-cycles execution latency for each instruction
 */
#define OOOEXECUTIONLATENCY 0

#if !defined OOOEXECUTIONLATENCY
#error OOOEXECUTIONLATENCY is not defined.
#endif

namespace TimingAnalysisPass {

FunctionalUnit::FunctionalUnit()
    : rob(nullptr), finishedInstruction(boost::none) {
  initExecutionTimesMap();
}

FunctionalUnit::FunctionalUnit(const FunctionalUnit &fu)
    : rob(nullptr), finishedInstruction(fu.finishedInstruction) {}

void FunctionalUnit::initExecutionTimesMap() {
  // Fill execution time map
  if (instructionExecutionTimes.size() == 0) {
    auto arch =
        TimingAnalysisMain::getTargetMachine().getTargetTriple().getArch();
    if (arch == Triple::ArchType::arm) {
      instructionExecutionTimes =
#if (OOOEXECUTIONLATENCY == 2) // two cycles each
#include "MicroarchitecturalAnalysis/ExecutionLatencies/Arm/TwoCyclesLatencies.def"
#elif (OOOEXECUTIONLATENCY == 1) // one cycle each
#include "MicroarchitecturalAnalysis/ExecutionLatencies/Arm/OneCycleLatencies.def"
#elif (OOOEXECUTIONLATENCY == 0) // variable-latency instructions
#include "MicroarchitecturalAnalysis/ExecutionLatencies/Arm/VariableOutoforderLatencies.def"
#else
#error Unsupported execution latencies.
#endif
          ;
    } else {
      assert(arch == Triple::ArchType::riscv32);
      instructionExecutionTimes =
#if (OOOEXECUTIONLATENCY == 2) // two cycles each
#include "MicroarchitecturalAnalysis/ExecutionLatencies/Riscv/TwoCyclesLatencies.def"
#elif (OOOEXECUTIONLATENCY == 1) // one cycle each
#include "MicroarchitecturalAnalysis/ExecutionLatencies/Riscv/OneCycleLatencies.def"
#elif (OOOEXECUTIONLATENCY == 0) // variable-latency instructions
#include "MicroarchitecturalAnalysis/ExecutionLatencies/Riscv/VariableOutoforderLatencies.def"
#else
#error Unsupported execution latencies.
#endif
          ;
    }
  }
}

size_t FunctionalUnit::hashcode() const {
  size_t result = 0;

  // hash finished instruction if available
  if (finishedInstruction) {
    hash_combine(result,
                 this->rob->getRelativeToHead(finishedInstruction.get()));
  }

  return result;
}

bool FunctionalUnit::equals(const FunctionalUnit &fu) const {
  if (((bool)finishedInstruction) != ((bool)fu.finishedInstruction))
    return false;
  if (finishedInstruction) {
    auto fiTag = finishedInstruction.get();
    auto dfuFiTag = fu.finishedInstruction.get();
    return (this->rob->getRelativeToHead(fiTag) ==
            fu.rob->getRelativeToHead(dfuFiTag));
  }
  return true;
}

void FunctionalUnit::output(std::ostream &stream) const {
  if (finishedInstruction) {
    stream << "Finished instruction with tag "
           << rob->getRelativeToHead(finishedInstruction.get()) << "\n";
  } else {
    stream << "No instruction finished.\n";
  }
}

std::ostream &operator<<(std::ostream &stream, const FunctionalUnit &fu) {
  fu.output(stream);

  return stream;
}

void FunctionalUnit::reassignPointers(ReOrderBuffer *robu) { rob = robu; }

bool FunctionalUnit::isFree() const {
  return finishedInstruction == boost::none;
}

boost::optional<unsigned> FunctionalUnit::getFinishedInstructionTag() {
  return finishedInstruction;
}

void FunctionalUnit::clearFinishedInstruction() {
  // reset finishedInstruction
  finishedInstruction = boost::none;
}

void FunctionalUnit::flush() { finishedInstruction = boost::none; }

std::map<int, std::set<unsigned>> FunctionalUnit::instructionExecutionTimes;

} // namespace TimingAnalysisPass
