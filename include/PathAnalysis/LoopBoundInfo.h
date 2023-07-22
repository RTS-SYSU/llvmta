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

#ifndef LOOPBOUNDINFO_H
#define LOOPBOUNDINFO_H

#include "ARM.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineLoopInfo.h"

#include "AnalysisFramework/PartitioningDomain.h"
#include "PartitionUtil/Context.h"
#include "PreprocessingAnalysis/ConstantValueDomain.h"

#include <iostream>
#include <list>
#include <map>

namespace TimingAnalysisPass {

/**
 * Machine function pass that extracts information about potential loop bounds
 * from the LLVM middle-end, i.e. from LoopInfo and ScalarEvolution,
 * respectively.
 */
class LoopBoundInfoPass : public llvm::MachineFunctionPass {

public:
  static char ID;
  LoopBoundInfoPass();

  /**
   * This is a dummy function.
   */
  bool runOnMachineFunction(llvm::MachineFunction &MF);

  void getAnalysisUsage(llvm::AnalysisUsage &AU) const;

  virtual llvm::StringRef getPassName() const {
    return "Provides loop bound information extracted from ScalarEvolution and "
           "LoopInfo";
  }

  template <llvm::Triple::ArchType ISA>
  using CVAnaDom =
      PartitioningDomain<ConstantValueDomain<ISA>, llvm::MachineInstr>;

  template <llvm::Triple::ArchType ISA>
  using CVAnalysisType = AnalysisInformation<CVAnaDom<ISA>, llvm::MachineInstr>;

  /**
   * @brief Dump the computed instruction<->address mapping to the given
   * stream.
   *
   * @param Mystream
   */
  void dump(std::ostream &Mystream) const;

  /**
   * @brief Get the All Loops objects.
   * This are valid as we modified LLVM not to throw them
   * away.
   *
   * @return const std::list<const llvm::MachineLoop *>
   */
  const std::list<const llvm::MachineLoop *> getAllLoops() const;

  /**
   * @brief Is there a known bound for this loop?
   *
   * @param Loop
   * @param Ctx
   * @return true
   * @return false
   */
  bool hasUpperLoopBound(const llvm::MachineLoop *Loop,
                         const Context &Ctx) const;
  /**
   * @brief Is there a known bound for this loop?
   *
   * @param Loop
   * @param Ctx
   * @return true
   * @return false
   */
  bool hasLowerLoopBound(const llvm::MachineLoop *Loop,
                         const Context &Ctx) const;

  /**
   * @brief Compute SCEVs to derive the actual loopbounds using the
   * information from the Constant Value Analysis.
   *
   * @tparam ISA
   * @param CvAnaInfo
   */
  template <llvm::Triple::ArchType ISA>
  void computeLoopBoundFromCVDomain(const CVAnalysisType<ISA> &CvAnaInfo);

  /**
   * Get the loop bound if any.
   * The bound is the number of times the backedge can be taken per entrance of
   * the loop. Note this is one less than the loop iteration count per entrance.
   */
  unsigned getUpperLoopBound(const llvm::MachineLoop *Loop,
                             const Context &Ctx) const;
  unsigned getLowerLoopBound(const llvm::MachineLoop *Loop,
                             const Context &Ctx) const;

  std::string getLoopDesc(const llvm::MachineLoop *Loop) const;

  void dumpNonUpperBoundLoops(std::ostream &Mystream,
                              std::ostream &Mystream2) const;
  void dumpNonLowerBoundLoops(std::ostream &Mystream,
                              std::ostream &Mystream2) const;

  void parseManualUpperLoopBounds(const char *Filename);
  void parseManualLowerLoopBounds(const char *Filename);

private:
  /**
   * Private helpers for four pairs of public member functions.
   * Introduced to avoid code duplication and to guarantee maintainability.
   */

  bool hasLoopBoundNoCtx(
      const llvm::MachineLoop *Loop,
      const std::unordered_map<const llvm::MachineLoop *,
                               std::unordered_map<Context, unsigned>>
          &LoopBounds,
      const std::unordered_map<const llvm::MachineLoop *,
                               std::unordered_map<Context, unsigned>>
          &ManualLoopBounds,
      const std::unordered_map<const llvm::MachineLoop *, unsigned>
          &ManualLoopBoundsNoCtx) const;
  bool
  hasLoopBound(const llvm::MachineLoop *Loop,
               const std::unordered_map<const llvm::MachineLoop *,
                                        std::unordered_map<Context, unsigned>>
                   &LoopBounds,
               const std::unordered_map<const llvm::MachineLoop *,
                                        std::unordered_map<Context, unsigned>>
                   &ManualLoopBounds,
               const std::unordered_map<const llvm::MachineLoop *, unsigned>
                   &ManualLoopBoundsNoCtx,
               const Context &Ctx) const;

  unsigned getLoopBoundNoCtx(
      const llvm::MachineLoop *Loop,
      const std::unordered_map<const llvm::MachineLoop *,
                               std::unordered_map<Context, unsigned>>
          &LoopBounds,
      const std::unordered_map<const llvm::MachineLoop *,
                               std::unordered_map<Context, unsigned>>
          &ManualLoopBounds,
      const std::unordered_map<const llvm::MachineLoop *, unsigned>
          &ManualLoopBoundsNoCtx) const;

  unsigned
  getLoopBound(const llvm::MachineLoop *Loop,
               const std::unordered_map<const llvm::MachineLoop *,
                                        std::unordered_map<Context, unsigned>>
                   &LoopBounds,
               const std::unordered_map<const llvm::MachineLoop *,
                                        std::unordered_map<Context, unsigned>>
                   &ManualLoopBounds,
               const std::unordered_map<const llvm::MachineLoop *, unsigned>
                   &ManualLoopBoundsNoCtx,
               const Context &Ctx) const;

  void dumpNonBoundLoops(
      std::ostream &Mystream, std::ostream &Mystream2,
      bool (LoopBoundInfoPass::*HasLoopBoundFkt)(const llvm::MachineLoop *Loop,
                                                 const Context &Ctx) const,
      unsigned (LoopBoundInfoPass::*GetLoopBoundFkt)(
          const llvm::MachineLoop *Loop, const Context &Ctx) const) const;

  void parseManualLoopBounds(
      const char *Filename,
      std::unordered_map<const llvm::MachineLoop *,
                         std::unordered_map<Context, unsigned>>
          &ManualLoopBounds,
      std::unordered_map<const llvm::MachineLoop *, unsigned>
          &ManualNormalLoopBounds);

  /**
   * @brief Internal function: Walks over all recognized loops
   *        and searches for bounds * using ScalarEvolution.
   *
   * @param Loop
   */
  void walkLoop(const llvm::Loop *Loop);
  /**
   * @brief Internal function: Walks over all recognized machine-loops,
   *        matches them with middle-end-IR-loops, and stores the loop
   *        bounds for later use.
   *
   * @param Loop
   */
  void walkMachineLoop(const llvm::MachineLoop *Loop);
  /**
   * @brief  Helper function to determine whether each BB
   *         in MachineLoop and IRLoop has a match.
   *
   * @param Maloop
   * @param Irloop
   * @return true
   * @return false
   */
  bool isMachineLoopExactMatch(const llvm::MachineLoop *Maloop,
                               const llvm::Loop *Irloop);
  /**
   * @brief Helper function to determine whether each BB
   *        in maloop has a match.
   *
   * @param Maloop
   * @param Irloop
   * @return true
   * @return false
   */
  bool isMachineLoopPartialMatch(const llvm::MachineLoop *Maloop,
                                 const llvm::Loop *Irloop);
  /**
   * @brief Internal Function: Map the function to the SCEV that
   *        represents its loopbound.
   *
   * @param ML
   * @param Loop
   */
  void addSCEVMapping(const llvm::MachineLoop *ML, const llvm::Loop *Loop);

  /**
   * @brief Internal Function: Compute the loopbound for all loops from
   * all callsites using their SCEVs and the Constant Value Domain and
   * store them in a map.
   *
   * @tparam ISA
   * @param LoopMapping
   * @param LoopBounds
   * @param CvAnaInfo
   */
  template <llvm::Triple::ArchType ISA>
  void computeLoopBounds(
      const std::unordered_map<const llvm::MachineLoop *, const llvm::SCEV *>
          &LoopMapping,
      std::unordered_map<const llvm::MachineLoop *,
                         std::unordered_map<Context, unsigned>> &LoopBounds,
      const CVAnalysisType<ISA> &CvAnaInfo);

  /**
   * @brief Get the Context Sensitive Bounds object
   * Get the Context Sensitive Loop Bounds.
   * Given a SCEV and the Constant Value Domain Analysis Information,
   * evaluate the SCEV for each context in AnaInfo and return a map with
   * loopbounds per Context.
   *
   * @tparam ISA
   * @param Loop
   * @param Equation
   * @param AnaInfo
   * @return std::unordered_map<Context, unsigned>
   */
  template <llvm::Triple::ArchType ISA>
  std::unordered_map<Context, unsigned> getContextSensitiveBounds(
      const llvm::MachineLoop *Loop, const llvm::SCEV *Equation,
      const std::unordered_map<Context, ConstantValueDomain<ISA>> &AnaInfo);

  /**
   * @brief Compute the value of a SCEV using the CV Domain to get unknown
   * values.
   *
   * @tparam ISA
   * @param Equation
   * @param CVDom
   * @param Value
   * @return true
   * @return false
   */
  template <llvm::Triple::ArchType ISA>
  bool getSCEVBoundFromCVDomain(const SCEV *Equation,
                                const ConstantValueDomain<ISA> &CVDom,
                                unsigned &Value);

  /**
   * @brief Get the Value By Argument object
   * Get a value from the CV Domain for a function argument.
   *
   * Given an argument number and a Constant Value Domain, identify the
   * function argument and get its value from the CV Domain.
   *
   * @tparam llvm::Triple::ArchType ISA
   * @param arg
   * @param CVDom
   * @param value
   * @return true
   * @return false
   */
  template <llvm::Triple::ArchType ISA>
  bool getValueByArgument(const llvm::Argument *Arg,
                          const ConstantValueDomain<ISA> &CVDom,
                          unsigned &Value);

  void parseCtxSensManualLoopBounds(
      std::ifstream &File,
      std::unordered_map<const llvm::MachineLoop *,
                         std::unordered_map<Context, unsigned>>
          &ManualLoopBounds);

  void parseNormalManualLoopBounds(
      std::ifstream &File,
      std::unordered_map<const llvm::MachineLoop *, unsigned>
          &ManualLoopBounds);

  // USING LOOPS AND MACHINELOOPS SHOULD BE SAFE AS WE MODIFIED LLVM
  // ACCORDINGLY.
  /**
   * The set of recognized middle-end IR loops.
   */
  std::list<const llvm::Loop *> IrLoops;
  /**
   * The set of recognized machine loops.
   */
  std::list<const llvm::MachineLoop *> MaLoops;
  /**
   * A computed mapping between machine and middle-end ir loops.
   *
   * This is currently only required for dumping the unknown loopbounds.
   * Sometimes, compiler optimizations cause some information to be lost
   * and we need this mapping to find the required symbols.
   */
  std::map<const llvm::MachineLoop *, const llvm::Loop *> LoopMapping;

  /**
   * Loop bounds for middle-end ir loops as found by ScalarEvolution.
   * Stores the max-backedge-taken-count that is one less than the maximal
   * execution count of the loop header.
   */
  std::unordered_map<const llvm::MachineLoop *, std::unordered_set<Context>>
      LoopContextMap;
  std::unordered_map<const llvm::MachineLoop *, const llvm::SCEV *>
      UpperLoopBoundsSCEV;
  std::unordered_map<const llvm::MachineLoop *, const llvm::SCEV *>
      LowerLoopBoundsSCEV;
  std::unordered_map<const llvm::MachineLoop *,
                     std::unordered_map<Context, unsigned>>
      UpperLoopBoundsCtx;
  std::unordered_map<const llvm::MachineLoop *,
                     std::unordered_map<Context, unsigned>>
      LowerLoopBoundsCtx;

  /**
   * Manual loop bounds (backedge taken counts per loop entrance) annotated by
   * the user of llvmta. This is a fallback for unfound loops from the
   * ir-representation.
   */
  std::unordered_map<const llvm::MachineLoop *, unsigned>
      ManualUpperLoopBoundsNoCtx;
  std::unordered_map<const llvm::MachineLoop *, unsigned>
      ManualLowerLoopBoundsNoCtx;
  std::unordered_map<const llvm::MachineLoop *,
                     std::unordered_map<Context, unsigned>>
      ManualUpperLoopBounds;
  std::unordered_map<const llvm::MachineLoop *,
                     std::unordered_map<Context, unsigned>>
      ManualLowerLoopBounds;
};

extern LoopBoundInfoPass *LoopBoundInfo;

} // namespace TimingAnalysisPass

namespace llvm {
FunctionPass *createLoopBoundInfoPass();
} // namespace llvm

#endif
