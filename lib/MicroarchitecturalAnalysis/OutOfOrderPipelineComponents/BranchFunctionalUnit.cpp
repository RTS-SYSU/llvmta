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

#include "MicroarchitecturalAnalysis/OutOfOrderPipelineComponents/BranchFunctionalUnit.h"

#include <llvm/Support/Debug.h>

namespace TimingAnalysisPass {

BranchFunctionalUnit::BranchFunctionalUnit() : FunctionalUnit() {}

BranchFunctionalUnit::BranchFunctionalUnit(const BranchFunctionalUnit &dfu)
    : FunctionalUnit(dfu) {}

FunctionalUnit *BranchFunctionalUnit::clone() const {
  return new BranchFunctionalUnit(*this);
}

bool BranchFunctionalUnit::equals(const FunctionalUnit &fu) const {
  return FunctionalUnit::equals(fu);
}

size_t BranchFunctionalUnit::hashcode() const {
  return FunctionalUnit::hashcode();
}

void BranchFunctionalUnit::output(std::ostream &stream) const {
  stream << "Branch Functional Unit: {\n";

  FunctionalUnit::output(stream);

  stream << "}\n";
}

bool BranchFunctionalUnit::canExecuteInstruction(const MachineInstr *mi) const {
  // branch functional unit accepts only branch instructions which are not
  // implemented by loads
  return (mi->isBranch() || mi->isCall() || mi->isReturn()) && !mi->mayLoad();
}

bool BranchFunctionalUnit::isFree() const { return FunctionalUnit::isFree(); }

void BranchFunctionalUnit::executeInstruction(unsigned robTag) {
  assert(isFree() && "Functional Unit was not free!");
  // set instruction
  this->finishedInstruction = robTag;
}

std::list<FunctionalUnit *> BranchFunctionalUnit::cycle(
    std::tuple<InstrContextMapping &, AddressInformation &> &dep) {
  std::list<FunctionalUnit *> result;
  BranchFunctionalUnit *bfu = new BranchFunctionalUnit(*this);
  // cycle does not do anything
  result.push_back(bfu);
  return result;
}

void BranchFunctionalUnit::flush() { FunctionalUnit::flush(); }

std::set<unsigned> BranchFunctionalUnit::getExecutingRobTags() const {
  std::set<unsigned> result;
  if (this->finishedInstruction) {
    result.insert(this->finishedInstruction.get());
  }
  return result;
}

} // namespace TimingAnalysisPass
