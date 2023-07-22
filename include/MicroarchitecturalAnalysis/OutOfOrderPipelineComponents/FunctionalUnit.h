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

#ifndef FUNCTIONALUNIT_H
#define FUNCTIONALUNIT_H

#include "MicroarchitecturalAnalysis/ExecutionElement.h"
#include "MicroarchitecturalAnalysis/OutOfOrderPipelineComponents/ReOrderBuffer.h"
#include "PreprocessingAnalysis/AddressInformation.h"

#include <boost/optional/optional.hpp>

#include <llvm/CodeGen/MachineInstr.h>

namespace TimingAnalysisPass {

/**
 * Abstract class describing a functional unit.
 * This is a component of the out of order pipeline.
 * It will be cycled by the pipeline.
 * Provides method to accept certain instructions and execute them.
 */
class FunctionalUnit {

public:
  FunctionalUnit();

  virtual ~FunctionalUnit() {}

  virtual FunctionalUnit *clone() const = 0;

  virtual size_t hashcode() const;

  virtual bool equals(const FunctionalUnit &fu) const;

  virtual void output(std::ostream &stream) const;

  friend std::ostream &operator<<(std::ostream &stream,
                                  const FunctionalUnit &fu);

  void reassignPointers(ReOrderBuffer *rob);

  virtual bool canExecuteInstruction(const llvm::MachineInstr *mi) const = 0;

  /**
   * Returns whether or not this functional unit is free and therefore ready to
   * execute some instruction.
   */
  virtual bool isFree() const;

  /**
   * Executes the given instruction.
   */
  virtual void executeInstruction(unsigned robTag) = 0;

  boost::optional<unsigned> getFinishedInstructionTag();

  void clearFinishedInstruction();

  /**
   * Cycles this functional unit.
   */
  // TODO(SH) I expected functional units to split up when they have variable
  // execution latency??
  // Yes, return type will be changed
  virtual std::list<FunctionalUnit *>
  cycle(std::tuple<InstrContextMapping &, AddressInformation &> &dep) = 0;

  virtual void flush();

  /**
   * Return the set of reorder buffer tags that are currently executed.
   */
  virtual std::set<unsigned> getExecutingRobTags() const = 0;

protected:
  FunctionalUnit(const FunctionalUnit &fu);

  ReOrderBuffer *rob;

  /**
   * ROB-tag of the finished instruction
   */
  boost::optional<unsigned> finishedInstruction;

  static std::map<int, std::set<unsigned>> instructionExecutionTimes;

private:
  void initExecutionTimesMap();
};

} // namespace TimingAnalysisPass

#endif /* FUNCTIONALUNIT_H */
