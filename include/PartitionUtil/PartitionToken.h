////////////////////////////////////////////////////////////////////////////////
//
//   LLVMTA - Timing Analyser performing worst-case execution time analysis
//     using the LLVM backend intermediate representation
//
// Copyright (C) 2013-2022  Saarland University
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

#ifndef TIMINGANALYSIS_PARTITIONTOKEN_H
#define TIMINGANALYSIS_PARTITIONTOKEN_H

#include "ARM.h"
#include "ARMMachineFunctionInfo.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/TargetInstrInfo.h"
#include "llvm/Target/TargetMachine.h"

#include <iostream>
#include <set>

#include "Util/Util.h"

namespace TimingAnalysisPass {

// Forward declaration
class Directive;

/**
 * Enum containing the different possible types of partition Tokens.
 * We splitted call site and callee site of a function call for a cleaner
 * interface:
 * - to model that the entry function is a callee but has no caller
 * - to model multiple possible callees for one call site
 * - to model multiple call sites for one callee
 */
enum class PartitionTokenType {
  NONE,     ///< Neutral Element, technical reasons
  IF,       ///< Partition on the outcome of an if
  LOOPPEEL, ///< Partition on the i-th iteration
  LOOPITER, ///< Partition on all iterations after the i-th one
  // TODO LOOPUNROLL, ///< Partition on all iterations modulo k = i
  CALLSITE, ///< Partition on the function call site
  FUNCALLEE ///< Partition on the function callee
};

/**
 * Abstract Base class for all token kinds, defines a common interface
 */
class PartitionToken {
public:
  // Virtual destructor
  virtual ~PartitionToken(){};

  /**
   * Returns the type of this partition token.
   * Can be used for later subtype-casting
   */
  virtual PartitionTokenType getType() const = 0;
  virtual std::string print() const = 0;
  virtual std::string serialize() const = 0;
  virtual bool equals(const PartitionToken &pt) const = 0;
  virtual bool less(const PartitionToken &pt) const = 0;

  void setEnclosingDirective(Directive *d);
  Directive *getEnclosingDirective() const;

  friend std::ostream &operator<<(std::ostream &stream,
                                  const PartitionToken &pt);

private:
  Directive *direc;
};

/**
 * Class implementing partition tokens of type NONE
 */
class PartitionTokenNone : public PartitionToken {
public:
  static PartitionTokenNone *getInstance();
  PartitionTokenType getType() const;
  std::string print() const;
  std::string serialize() const;
  virtual bool equals(const PartitionToken &pt) const;
  virtual bool less(const PartitionToken &pt) const;

private:
  PartitionTokenNone();
  static PartitionTokenNone *instance;
};

/**
 * Class implementing partition tokens of type IF.
 * It states that the branching instruction branchInstrID has the outcome
 * assumeTaken. For an assumeTaken=true token, there should also be an
 * assumeTaken=false token, to ensure soundness in the general setting.
 */
class PartitionTokenIf : public PartitionToken {
public:
  PartitionTokenIf(std::string branchInstrID, bool assumeTaken);
  PartitionTokenType getType() const;
  std::string print() const;
  std::string serialize() const;
  virtual bool equals(const PartitionToken &pt) const;
  virtual bool less(const PartitionToken &pt) const;

private:
  std::string branchInstrID;
  bool assumeTaken;
};

/**
 * Class implementing partition tokens of type LOOPPEEL.
 * It states how often on of the backedges has been taken.
 * taken = 0 corresponds to the 1st iteration, and so on.
 */
// TODO Remove the set of backedges as it is implicit with loop
class PartitionTokenLoopPeel : public PartitionToken {
public:
  PartitionTokenLoopPeel(const llvm::MachineLoop *l, std::set<MBBedge> be,
                         unsigned t);
  PartitionTokenType getType() const;
  std::string print() const;
  std::string serialize() const;
  virtual bool equals(const PartitionToken &pt) const;
  virtual bool less(const PartitionToken &pt) const;
  unsigned backedgeTakenCount() const;
  bool hasBackedge(MBBedge edge) const;
  std::set<MBBedge> getBackedges() const;
  const llvm::MachineLoop *getLoop() const;

private:
  const llvm::MachineLoop *loop;
  std::set<MBBedge> backedges;
  unsigned taken;
};

/**
 * Class implementing partition tokens of type LOOPITER.
 * It states that backedges have been taken at least taken times.
 * taken = 1 corresponds to the 2nd and later iterations, and so on.
 */
// TODO Remove the set of backedges as it is implicit with loop
class PartitionTokenLoopIter : public PartitionToken {
public:
  PartitionTokenLoopIter(const llvm::MachineLoop *l, std::set<MBBedge> be,
                         unsigned t);
  PartitionTokenType getType() const;
  std::string print() const;
  std::string serialize() const;
  virtual bool equals(const PartitionToken &pt) const;
  virtual bool less(const PartitionToken &pt) const;
  unsigned backedgeLeastTakenCount() const;
  bool hasBackedge(MBBedge edge) const;
  std::set<MBBedge> getBackedges() const;
  const llvm::MachineLoop *getLoop() const;

private:
  const llvm::MachineLoop *loop;
  std::set<MBBedge> backedges;
  unsigned taken;
};

/**
 * Class implementing partition tokens of type CALLSITE.
 * We call a function at the given instruction.
 * Which function is called is determined by the callee.
 */
class PartitionTokenCallSite : public PartitionToken {
public:
  PartitionTokenCallSite(const MachineInstr *location);
  PartitionTokenType getType() const;
  std::string print() const;
  std::string serialize() const;
  virtual bool equals(const PartitionToken &pt) const;
  virtual bool less(const PartitionToken &pt) const;
  const MachineInstr *getCallSite() const;

private:
  const MachineInstr *callInstr;
};

/**
 * Class implementing partition tokens of type FUNCALLEE.
 * The given function is called.
 * The call site was determined by the caller and is part of the context string.
 */
class PartitionTokenFunCallee : public PartitionToken {
public:
  PartitionTokenFunCallee(const llvm::MachineFunction *func);
  PartitionTokenType getType() const;
  std::string print() const;
  std::string serialize() const;
  virtual bool equals(const PartitionToken &pt) const;
  virtual bool less(const PartitionToken &pt) const;
  const llvm::MachineFunction *getCallee() const { return function; }

private:
  const llvm::MachineFunction *function;
};
} // namespace TimingAnalysisPass

/**
 * Hashing functionality for partition tokens.
 */
namespace std {
template <> struct hash<TimingAnalysisPass::PartitionToken> {
  size_t operator()(const TimingAnalysisPass::PartitionToken &pt) const {
    size_t val{0};
    TimingAnalysisPass::hash_combine(val, (int)pt.getType());
    return val;
  }
};
} // namespace std

#endif
