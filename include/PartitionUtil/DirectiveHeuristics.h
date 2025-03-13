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

#ifndef DIRECTIVEHEURISTICS_H
#define DIRECTIVEHEURISTICS_H

#include "ARM.h"
#include "ARMMachineFunctionInfo.h"

#include "llvm/Analysis/LoopInfo.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineLoopInfo.h"
#include "llvm/CodeGen/TargetInstrInfo.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Target/TargetMachine.h"

#include <iostream>
#include <list>
#include <map>

#include "PartitionUtil/Directive.h"
#include "Util/Util.h"

using namespace llvm;

namespace TimingAnalysisPass {

/**
 * @brief
 * Class that is responsible for deriving partitioning directives. It is
 * implemented as a MachineFunctionPass within the LLVM Framework. It derives
 * directives on the basic block level, as well as on the instruction level.
 *
 */
class DirectiveHeuristicsPass : public MachineFunctionPass {
public:
  static char ID;
  DirectiveHeuristicsPass();

  ~DirectiveHeuristicsPass() {
    // TODO get rid of all these pointers in the map
    // delete all directives
    for (auto Ele : DirectiveBeforeInstr) {
      delete Ele.second;
    }
    for (auto Ele : DirectiveAfterInstr) {
      delete Ele.second;
    }
    for (auto Ele : DirectiveEnterBBEdge) {
      for (auto *Ele2 : *Ele.second) {
        delete Ele2;
      }
      delete Ele.second;
    }
    for (auto Ele : DirectiveLeaveBBEdge) {
      for (auto *Ele2 : *Ele.second) {
        delete Ele2;
      }
      delete Ele.second;
    }
    for (auto Ele : DirectiveBeforeFunc) {
      delete Ele.second;
    }
    for (auto Ele : DirectiveAfterFunc) {
      delete Ele.second;
    }
  }

  /**
   * @brief Get the Analysis Usage object Declare dependencies of this analysis,
   * here the MachineLoopInfo.
   *
   * @param AU
   */
  void getAnalysisUsage(llvm::AnalysisUsage &AU) const;

  /**
   * @brief
   * Derive partitioning directives on the basic block level, for each function.
   * This include the following directives currently:  - Directives for
   * Partitions of Type ::FUNCALLEE on function entry and exit - Directives for
   * Partitions of Type ::LOOPPEEL and ::LOOPITER on entry and exit of looping
   * regions
   *
   * @param MF
   * @return true
   * @return false
   */
  bool runOnMachineFunction(MachineFunction &MF);
  /**
   * @brief
   * Derive partitioning directives on the instruction level, for each basic
   * block. This includes directives of type ::CREATE/::MERGE for Partitions
   * ::CALLSITE on each function call site.
   *
   * @param MBB
   * @return true
   * @return false
   */
  bool runOnMachineBasicBlock(MachineBasicBlock &MBB);

  llvm::StringRef getPassName() const {
    return "Annotate the control-flow-graph with Trace Partitioning Directives";
  }

  /**
   * @brief
   * Dump all annotated directives. For debugging purposes.
   *
   * @param Mystream
   */
  void dump(std::ostream &Mystream) const;

  /**
   * @brief Get the Directive Before Instr object. Returns the directive that
   * should be executed directly before the given instruction MI.
   *
   * @param MI
   * @return Directive*
   */
  Directive *getDirectiveBeforeInstr(const MachineInstr *MI);

  /**
   * @brief Get the Directive After Instr object Returns the directive that
   * should be executed directly after the given instruction MI.
   *
   * @param MI
   * @return Directive*
   */
  Directive *getDirectiveAfterInstr(const MachineInstr *MI);

  /**
   * @brief Get the Directive On Call object.  Returns the directive that should
   * be executed as first thing on call of the given function MF.
   *
   * @param MF
   * @return Directive*
   */
  Directive *getDirectiveOnCall(const MachineFunction *MF);

  /**
   * @brief Get the Directive On Return object. Returns the directive that
   * should be executed as last thing on return of the given function MF.
   *
   * @param MF
   * @return Directive*
   */
  Directive *getDirectiveOnReturn(const MachineFunction *MF);

  /**
   * @brief Get the Directive On Edge Enter object. Returns directives that
   * should be executed directly when the given edge is entered. The result
   * implies an ordering: First list members are to be executed first.
   *
   * @param E
   * @return std::list<Directive *>*
   */
  std::list<Directive *> *getDirectiveOnEdgeEnter(MBBedge E);

  /**
   * @brief Get the Directive On Edge Leave object. Returns directives that
   * should be executed directly before leaving the given edge. The result
   * implies an ordering: First list members are to be executed first.
   *
   * @param E
   * @return std::list<Directive *>*
   */
  std::list<Directive *> *getDirectiveOnEdgeLeave(MBBedge E);

  /**
   * @brief Checks for the directive that should be executed directly before the
   * given instruction MI.
   *
   * @param MI
   * @return true
   * @return false
   */
  bool hasDirectiveBeforeInstr(const MachineInstr *MI);

  /**
   * @brief Checks for the directive that should be executed directly after the
   * given instruction MI.
   *
   * @param MI
   * @return true
   * @return false
   */
  bool hasDirectiveAfterInstr(const MachineInstr *MI);

  /**
   * @brief
   * Checks for the directive that should be executed as first thing on call of
   * the given function.
   *
   * @param MF
   * @return true
   * @return false
   */
  bool hasDirectiveOnCall(const MachineFunction *MF);

  /**
   * @brief
   * Checks for the directive that should be executed as last thing on return of
   * the given function.
   *
   * @param MF
   * @return true
   * @return false
   */
  bool hasDirectiveOnReturn(const MachineFunction *MF);

  /**
   * @brief
   * Checks for directives that should be executed directly when the given edge
   * is entered.
   *
   * @param E
   * @return true
   * @return false
   */
  bool hasDirectiveOnEdgeEnter(MBBedge E);

  /**
   * @brief
   * Checks for directives that should be executed directly before leaving the
   * given edge.
   *
   * @param E
   * @return true
   * @return false
   */
  bool hasDirectiveOnEdgeLeave(MBBedge E);

private:
  ///< Directive to be executed before the given instruction
  std::map<const MachineInstr *, Directive *, instrptrcomp>
      DirectiveBeforeInstr;
  ///< Directive to be executed after the given instruction
  std::map<const MachineInstr *, Directive *, instrptrcomp> DirectiveAfterInstr;

  ///< Directive to be executed when the given edge between basicblocks is
  ///< entered. Directives are executed in list-order from begin to end.
  std::map<MBBedge, std::list<Directive *> *, mbbedgecomp> DirectiveEnterBBEdge;
  ///< Directive to be executed when the given edge between basicblocks is left.
  ///< Directives are executed in list-order from begin to end.
  std::map<MBBedge, std::list<Directive *> *, mbbedgecomp> DirectiveLeaveBBEdge;

  ///< Directive to be executed before the given function
  std::map<const MachineFunction *, Directive *, machfunccomp>
      DirectiveBeforeFunc;
  ///< Directive to be executed after the given function
  std::map<const MachineFunction *, Directive *, machfunccomp>
      DirectiveAfterFunc;

  /**
   * @brief
   * Annotate partitioning directives for loop peeling for all loops  in the
   * current (called from runOnMachineFunction) function.  The heuristics peels
   * each loop as many times as is given by the  -ta-loop-peel option.
   *
   * @param Loop
   */
  void annotateLoopDirective(const llvm::MachineLoop *Loop);
};

/**
 * @brief
 * Singleton Object of the Directive Derivation Pass. Used to access the derived
 * directives later on.
 *
 */
extern DirectiveHeuristicsPass *DirectiveHeuristicsPassInstance;

} // namespace TimingAnalysisPass

namespace llvm {
FunctionPass *createDirectiveHeuristicsPass();
} // namespace llvm

#endif
