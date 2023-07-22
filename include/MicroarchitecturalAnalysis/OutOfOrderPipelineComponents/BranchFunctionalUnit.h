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

#ifndef BRANCHFUNCTIONALUNIT_H
#define BRANCHFUNCTIONALUNIT_H

#include "MicroarchitecturalAnalysis/OutOfOrderPipelineComponents/FunctionalUnit.h"

#include <boost/optional.hpp>

namespace TimingAnalysisPass {

/**
 * Describes a functional unit which does not execute anything,
 * but instead tries to put the instruction result directly to the bus.
 * This serves the purposes to keep the structure of the framework also for
 * instructions like branches.
 */
class BranchFunctionalUnit : public FunctionalUnit {

public:
  BranchFunctionalUnit();

  ~BranchFunctionalUnit() {}

  FunctionalUnit *clone() const;

  bool equals(const FunctionalUnit &fu) const;

  size_t hashcode() const;

  void output(std::ostream &stream) const;

  bool canExecuteInstruction(const MachineInstr *mi) const;

  bool isFree() const;

  void executeInstruction(unsigned robTag);

  std::list<FunctionalUnit *>
  cycle(std::tuple<InstrContextMapping &, AddressInformation &> &dep);

  void flush();

  std::set<unsigned> getExecutingRobTags() const;

private:
  BranchFunctionalUnit(const BranchFunctionalUnit &dfu);
};

} // namespace TimingAnalysisPass

#endif /* BRANCHFUNCTIONALUNIT_H */
