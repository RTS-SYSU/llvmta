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

#include "PathAnalysis/LoopBoundInfo.h"

#include "AnalysisFramework/CallGraph.h"
#include "LLVMPasses/MachineFunctionCollector.h"
#include "LLVMPasses/TimingAnalysisMain.h"
#include "Util/Options.h"
#include "Util/Util.h"

#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/Analysis/ScalarEvolutionExpressions.h"
#include "llvm/CodeGen/MachineBasicBlock.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstr.h"

#include "llvm/CodeGen/MachineLoopInfo.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_os_ostream.h"

#include <boost/tokenizer.hpp>
#include <cassert>
#include <fstream>
#include <vector>

using namespace llvm;

namespace TimingAnalysisPass {

LoopBoundInfoPass *LoopBoundInfo;

char LoopBoundInfoPass::ID = 0;

LoopBoundInfoPass::LoopBoundInfoPass() : MachineFunctionPass(ID) {}

void LoopBoundInfoPass::getAnalysisUsage(AnalysisUsage &AU) const {
  MachineFunctionPass::getAnalysisUsage(AU);
  AU.setPreservesCFG();
  AU.addRequired<LoopInfoWrapperPass>();
  AU.addRequired<MachineLoopInfo>();
  AU.addRequired<ScalarEvolutionWrapperPass>();
}

/**
 * @brief Walks over all Loops and MachineLoops.
 *
 * @param MF
 * @return true
 * @return false
 */
bool LoopBoundInfoPass::runOnMachineFunction(MachineFunction &MF) {
  LoopInfo &LI = getAnalysis<LoopInfoWrapperPass>().getLoopInfo();
  for (auto *Loop : LI) {
    walkLoop(Loop);
  }
  MachineLoopInfo &MLI = getAnalysis<MachineLoopInfo>();
  for (auto *MachineLoop : MLI) {
    walkMachineLoop(MachineLoop);
  }
  return false;
}

void LoopBoundInfoPass::walkLoop(const Loop *Loop) {
  IrLoops.push_back(Loop);
  DEBUG_WITH_TYPE("loopbound", dbgs() << "***** We found a loop *****\n");
  DEBUG_WITH_TYPE("loopbound", dbgs() << "Begin subloops\n");
  for (auto *Subloop : Loop->getSubLoops()) {
    walkLoop(Subloop);
  }
  DEBUG_WITH_TYPE("loopbound", dbgs() << "End subloops\n");
}

bool LoopBoundInfoPass::isMachineLoopExactMatch(const MachineLoop *Maloop,
                                                const Loop *Irloop) {
  auto IrloopBBs = Irloop->getBlocks();
  auto MaloopBBs = Maloop->getBlocks();
  bool FoundAllirloopBb = true;
  for (const BasicBlock *IrBb : IrloopBBs) {
    bool Found = false;
    for (const MachineBasicBlock *MaBb : MaloopBBs) {
      Found |= (IrBb == MaBb->getBasicBlock());
    }
    FoundAllirloopBb &= Found;
  }
  bool FoundAllmaloopBb = true;
  for (const MachineBasicBlock *MaBb : MaloopBBs) {
    bool Found = false;
    for (const BasicBlock *IrBb : IrloopBBs) {
      Found |= (MaBb->getBasicBlock() == IrBb);
    }
    FoundAllmaloopBb &= Found;
  }
  return FoundAllirloopBb && FoundAllmaloopBb;
}

bool LoopBoundInfoPass::isMachineLoopPartialMatch(const MachineLoop *Maloop,
                                                  const Loop *Irloop) {
  DEBUG_WITH_TYPE("loopmatch", dbgs() << "Try to match with " << *Irloop);
  auto IrloopBBs = Irloop->getBlocks();
  auto MaloopBBs = Maloop->getBlocks();
  bool FoundAllmaloopBb = true;
  for (const MachineBasicBlock *MaBb : MaloopBBs) {
    bool Found = false;
    for (const BasicBlock *IrBb : IrloopBBs) {
      // Either there is no corresponding ir block or it matches the irloop
      Found |= MaBb->getBasicBlock() == nullptr;
      Found |= MaBb->getBasicBlock() == IrBb;
    }
    DEBUG_WITH_TYPE(
        "loopmatch",
        if (!Found) { dbgs() << "No match for " << *MaBb << " found\n"; });
    FoundAllmaloopBb &= Found;
  }
  return FoundAllmaloopBb;
}

void LoopBoundInfoPass::addSCEVMapping(const MachineLoop *ML,
                                       const Loop *Loop) {
  ScalarEvolution &SEInfo = getAnalysis<ScalarEvolutionWrapperPass>().getSE();
  DEBUG_WITH_TYPE("loopbound", dbgs()
                                   << "Adding map for loop: " << *ML << "\n");
  if (SEInfo.hasLoopInvariantBackedgeTakenCount(Loop)) {
    const SCEV *TakenCount = SEInfo.getBackedgeTakenCount(Loop);
    DEBUG_WITH_TYPE("loopbound", dbgs()
                                     << "Loop SCEV: " << *TakenCount << "\n");
    DEBUG_WITH_TYPE("loopbound", dbgs() << "Loop SCEV: " << TakenCount << "\n");
    UpperLoopBoundsSCEV.insert(std::make_pair(ML, TakenCount));
    LowerLoopBoundsSCEV.insert(std::make_pair(ML, TakenCount));
  } else {
    const SCEV *MaxTakenCount = SEInfo.getConstantMaxBackedgeTakenCount(Loop);
    DEBUG_WITH_TYPE("loopbound", dbgs() << "Non-invariant Loop Bound: "
                                        << *MaxTakenCount << "\n");
    // FIXME do not use max backedge taken count since it returns ridiculous
    // numbers with llvm7 for some of our tests
    // upperLoopBoundsSCEV.insert(std::make_pair(ML, maxTakenCount));
    // We don't add the lowerLoopBound here. The SCEV here is not for
    // an exact match on the loop bound, but only offers an upper bound
    // on the number of loop iterations. We could create a new SCEV
    // with a constant value of 0 for the lower bound. That would be
    // good for symmetry. However, creating a SCEV Constant at this
    // point in the code is a very convoluted process and not worth the
    // added complexity.
  }
}

void LoopBoundInfoPass::walkMachineLoop(const MachineLoop *Loop) {
  MaLoops.push_back(Loop);
  DEBUG_WITH_TYPE("loopmatch", dbgs()
                                   << "###### We found a machine loop #####\n"
                                   << *Loop);
  std::set<const llvm::Loop *> Candidates;
  for (const auto *Irloop : IrLoops) {
    // Is irloop a match?
    if (isMachineLoopPartialMatch(Loop, Irloop)) {
      bool NestedMatches = false;
      // Is a nested loop of irloop also a match?
      for (auto *Subloop : Irloop->getSubLoops()) {
        NestedMatches |= isMachineLoopPartialMatch(Loop, Subloop);
      }
      if (!NestedMatches) {
        Candidates.insert(Irloop);
      }
    }
  }

  if (Candidates.size() == 0) {
    DEBUG_WITH_TYPE("loopmatch",
                    dbgs() << "[Warning] We did not find matching loop\n");
  } else if (Candidates.size() == 1) {
    const llvm::Loop *CorrespondingLoop = *(Candidates.begin());
    DEBUG_WITH_TYPE("loopmatch", dbgs() << "We found corresponding loop\n");
    if (!isMachineLoopExactMatch(Loop, CorrespondingLoop)) {
      DEBUG_WITH_TYPE("loopmatch",
                      dbgs() << "[Warning] We only found subset match, maybe "
                                "due to optimizations.\n");
    }
    LoopMapping.insert(std::make_pair(Loop, CorrespondingLoop));
    addSCEVMapping(Loop, CorrespondingLoop);
  } else {
    assert(0 && "[Warning] We did find too many matching loops\n");
  }

  for (auto *Subloop : Loop->getSubLoops()) {
    walkMachineLoop(Subloop);
  }
}

template <>
bool LoopBoundInfoPass::getValueByArgument<Triple::ArchType::riscv32>(
    const Argument *Arg,
    const ConstantValueDomain<Triple::ArchType::riscv32> &CVDom,
    unsigned &Value) {
  // TODO riscv implementation of context sensitive loop bounds...
  return false;
}

template <>
bool LoopBoundInfoPass::getValueByArgument<Triple::ArchType::arm>(
    const Argument *Arg,
    const ConstantValueDomain<Triple::ArchType::arm> &CVDom, unsigned &Value) {
  // Find the gpr number this argument maps to
  unsigned Argnum = 0;

  // Catch information about the floating point ABI
  auto &TargetOptions = TimingAnalysisMain::getTargetMachine().Options;
  auto &FloatAbi = TargetOptions.FloatABIType;
  assert(FloatAbi == FloatABI::Hard || FloatAbi == FloatABI::Soft);

  // Scan all function arguments
  for (auto &Funcarg : Arg->getParent()->args()) {
    DEBUG_WITH_TYPE("loopbound",
                    dbgs() << "Next function argument: " << Funcarg << "\n");
    // Found argument. Later ones don't matter for gpr number
    if (Funcarg.getArgNo() == Arg->getArgNo()) {
      break;
    }

    // Get the type of argument
    auto *ArgType = Funcarg.getType();

    // Integer types occupy GPR registers
    if (ArgType->isIntegerTy()) {
      unsigned Size = ArgType->getPrimitiveSizeInBits();
      assert((Size <= 32 || Size == 64) && "Unexpected integer size");
      if (Size <= 32) {
        ++Argnum;
      } else {
        // Larger integers need multiple, aligned registers
        Argnum = Argnum + 2 + (Argnum % 2);
      }
    } else if (ArgType->isFloatingPointTy()) {
      // Floats have dedicated registers in hard floating point
      // mode
      if (FloatAbi != FloatABI::Hard) {
        if (ArgType->isFloatTy()) {
          ++Argnum;
        } else {
          assert(ArgType->isDoubleTy() && "Unexpected floating point type");
          Argnum = Argnum + 2 + (Argnum % 2);
        }
      }
    } else if (ArgType->isPointerTy()) {
      ++Argnum;
    } else {
      assert(0 && "Unknown argument type");
    }
  }
  DEBUG_WITH_TYPE("loopbound", dbgs() << "Argument number: " << Arg->getArgNo()
                                      << " GPR Number: " << Argnum << "\n");

  // Try to get a value for the argument register
  int Regnr;
  /* Accroding to the ARM ABI, registers R0-R3 hold the first 4 arguments
   * passed to a function. Hence, we try to get those first. Other arguments
   * are then passed through the stack. So in case of higher numbered
   * arguments, we must translate the argument number to the location on the
   * stack where it should be and then read the value of the constant value
   * domain at that memory location.
   */
  switch (Argnum) {
  case 0:
    Regnr = ARM::R0;
    break;
  case 1:
    Regnr = ARM::R1;
    break;
  case 2:
    Regnr = ARM::R2;
    break;
  case 3:
    Regnr = ARM::R3;
    break;
  default:
    DEBUG_WITH_TYPE("loopbound",
                    dbgs() << "argnum >= 4. Need to find data from Stack.\n");
    AnalysisResults::getInstance().incrementResult("SCEV_argument_high");
    Regnr = -1;
  }

  if (Regnr >= 0) {
    if (!(CVDom.isBottom() || CVDom.isTop(Regnr))) {
      Value = CVDom.getValueFor(Regnr);
      return true;
    }
    DEBUG_WITH_TYPE("loopbound", dbgs()
                                     << Argnum << " not found in CV Domain\n");
    DEBUG_WITH_TYPE("loopbound", dbgs() << CVDom.print());
    AnalysisResults::getInstance().incrementResult("SCEV_arg_cv");
  }

  return false;
}

template <llvm::Triple::ArchType ISA>
bool LoopBoundInfoPass::getSCEVBoundFromCVDomain(
    const SCEV *Equation, const ConstantValueDomain<ISA> &CVDom,
    unsigned &Value) {
  bool Ret = true;
  DEBUG_WITH_TYPE("loopbound",
                  dbgs() << "Computing for scev: " << *Equation << "\n");
  switch (static_cast<SCEVTypes>(Equation->getSCEVType())) {
  case scConstant: {
    DEBUG_WITH_TYPE("loopbound", dbgs() << "Type: Constant\n");

    volatile int64_t BitWidth =
        dyn_cast<SCEVConstant>(Equation)->getValue()->getBitWidth();
    if (BitWidth > 64) {
      DEBUG_WITH_TYPE("loopbound", dbgs() << "Skipping too large constant\n");
      AnalysisResults::getInstance().incrementResult("SCEV_constant");
      Ret = false;
      break;
    }
    volatile int64_t TmpValue =
        dyn_cast<SCEVConstant>(Equation)->getValue()->getSExtValue();
    if (TmpValue >= std::numeric_limits<int>::max() ||
        TmpValue <= std::numeric_limits<int>::min()) {
      DEBUG_WITH_TYPE("loopbound", dbgs() << "Skipping too large constant\n");
      AnalysisResults::getInstance().incrementResult("SCEV_constant");
      Ret = false;
    } else {
      // Cut the 64-bit integer down to 32-bit (range check above) and then
      // convert it to our container format "unsigned"
      Value = (unsigned)((int)TmpValue);
    }
  } break;
  case scAddExpr:
  case scMulExpr:
  case scUMaxExpr:
  case scSMaxExpr: {
    DEBUG_WITH_TYPE("loopbound", dbgs() << "Type: Nary\n");
    const SCEVNAryExpr *NAry = cast<SCEVNAryExpr>(Equation);
    unsigned FinalVal;
    for (auto &I : NAry->operands()) {
      if (I == *NAry->op_begin()) {
        unsigned Tmp;
        // Copy first value as-is
        if (!(Ret = getSCEVBoundFromCVDomain(I, CVDom, Tmp)))
          goto end_switch;
        FinalVal = Tmp;
        continue;
      }

      unsigned OpVal;
      if (getSCEVBoundFromCVDomain(I, CVDom, OpVal) == false) {
        Ret = false;
        goto end_switch;
      }

      switch (NAry->getSCEVType()) {
      case scAddExpr:
        DEBUG_WITH_TYPE("loopbound", dbgs() << "Type: Nary (ADD)\n");
        FinalVal += OpVal;
        break;
      case scMulExpr:
        DEBUG_WITH_TYPE("loopbound", dbgs() << "Type: Nary (Mul)\n");
#if 0
						/*
						 * Check if the multiplication can be done without
						 * overflows. If it overflows, we conservatively claim
						 * to have no knowledge about the result. This is
						 * because LLVM specifies <nsw> and <nuw> properties
						 * but doesn't state anything about what to do when an
						 * overflow happens. We just skip out in case of all
						 * overflows
						 *
						 * 04.06.2018 - Darshit Shah
						 * This code is currently commented out till we can
						 * figure out what exactly the nsw and nuw flags mean.
						 * Also, to anyone touching this in the future, make
						 * these overflow checks work with Add as well
						 */
						if (__builtin_mul_overflow_p (final_val, op_val, (unsigned) 0) == false) {
							ret = false;
							AnalysisResults::getInstance().incrementResult("SCEV/overflow");
							goto end_switch;
						}
#endif
        FinalVal *= OpVal;
        break;
      case scUMaxExpr:
        DEBUG_WITH_TYPE("loopbound", dbgs() << "Type: Nary (UMax)\n");
        FinalVal = std::max(FinalVal, OpVal);
        break;
      case scSMaxExpr:
        DEBUG_WITH_TYPE("loopbound", dbgs() << "Type: Nary (Max)\n");
        FinalVal = (unsigned)std::max((int)FinalVal, (int)OpVal);
        break;
      // TODO: Implement the following cases.
      case llvm::scZeroExtend:
        assert(false && "Not implemnted Yet");
      case llvm::scConstant:
        assert(false && "Not implemnted Yet");
      case llvm::scTruncate:
        assert(false && "Not implemnted Yet");
      case llvm::scSignExtend:
        assert(false && "Not implemnted Yet");
      case llvm::scUDivExpr:
        assert(false && "Not implemnted Yet");
      case llvm::scAddRecExpr:
        assert(false && "Not implemnted Yet");
      case llvm::scUMinExpr:
        assert(false && "Not implemnted Yet");
      case scSMinExpr:
        assert(false && "Not implemnted Yet");
      case scPtrToInt:
        assert(false && "Not implemnted Yet");
      case scUnknown:
        assert(false && "Not implemnted Yet");
      case scCouldNotCompute:
        assert(false && "Not implemnted Yet");
        break;
      }
    }
    Value = FinalVal;
  } break;
  case scUDivExpr: {
    DEBUG_WITH_TYPE("loopbound", dbgs() << "Type: Div\n");
    const SCEVUDivExpr *UDivExpr = cast<SCEVUDivExpr>(Equation);
    const auto *Lhs = UDivExpr->getLHS();
    const auto *Rhs = UDivExpr->getRHS();
    unsigned Lhsval, Rhsval;
    if (getSCEVBoundFromCVDomain(Lhs, CVDom, Lhsval) == false ||
        getSCEVBoundFromCVDomain(Rhs, CVDom, Rhsval) == false) {
      Ret = false;
      goto end_switch;
    }
    Value = Lhsval / Rhsval;
  } break;
  case scUnknown: {
    DEBUG_WITH_TYPE("loopbound", dbgs() << "Type: Unknown\n");
    const SCEVUnknown *U = cast<SCEVUnknown>(Equation);
    // Try to get an argument value
    auto *Arg = dyn_cast<llvm::Argument>(U->getValue());
    // We only advance if we have a function argument of type int that
    // fits into a single register
    if (Arg == nullptr || !Arg->getType()->isIntegerTy() ||
        Arg->getType()->getPrimitiveSizeInBits() > 32) {
      AnalysisResults::getInstance().incrementResult("SCEV_unknown");
      Ret = false;
      break;
    }

    Ret = getValueByArgument(Arg, CVDom, Value);
  } break;
  // Cases that we don't handle
  case scTruncate:
  case scZeroExtend:
  case scSignExtend:
  case scAddRecExpr:
  case scCouldNotCompute:
  default:
    AnalysisResults::getInstance().incrementResult("SCEV_NotImplemented");
    Ret = false;
  }
end_switch:
  return Ret;
}

template <llvm::Triple::ArchType ISA>
std::unordered_map<Context, unsigned>
LoopBoundInfoPass::getContextSensitiveBounds(
    const llvm::MachineLoop *Loop, const llvm::SCEV *Equation,
    const std::unordered_map<Context, ConstantValueDomain<ISA>> &AnaInfo) {
  std::unordered_map<Context, unsigned> CtxBounds;
  for (auto &Kv : AnaInfo) {
    auto Ctx = Kv.first;
    auto CVDomain = Kv.second;
    unsigned Value;
    if (getSCEVBoundFromCVDomain(Equation, CVDomain, Value) == true) {
      if ((unsigned)Value > std::numeric_limits<int>::max()) {
        DEBUG_WITH_TYPE(
            "loopbound",
            dbgs() << "The loopbound is greater than INT_MAX. Discarding\n");
      } else {
        CtxBounds.insert(std::make_pair(Ctx, Value));
        DEBUG_WITH_TYPE("loopbound", dbgs() << "Computed Ctx Sens Bound as: "
                                            << Value << "\n");
      }
    } else {
      DEBUG_WITH_TYPE("loopbound",
                      dbgs()
                          << "Could not compute SCEV Bound. Incomplete Data\n");
    }
    DEBUG_WITH_TYPE("loopdump", dbgs() << "Adding loop " << *Loop
                                       << ". Context: " << Ctx.serialize()
                                       << "\n");
    LoopContextMap[Loop].insert(Ctx);
  }
  return CtxBounds;
}

// Make definitions explicit here
template void
LoopBoundInfoPass::computeLoopBoundFromCVDomain<Triple::ArchType::arm>(
    const CVAnalysisType<Triple::ArchType::arm> &CvAnaInfo);
template void
LoopBoundInfoPass::computeLoopBoundFromCVDomain<Triple::ArchType::riscv32>(
    const CVAnalysisType<Triple::ArchType::riscv32> &CvAnaInfo);

template <llvm::Triple::ArchType ISA>
void LoopBoundInfoPass::computeLoopBoundFromCVDomain(
    const CVAnalysisType<ISA> &CvAnaInfo) {
  DEBUG_WITH_TYPE(
      "loopbound",
      dbgs() << "+++ Computing Loop Bounds from CV Domain Now +++\n");
  AnalysisResults &Ar = AnalysisResults::getInstance();
  Ar.registerResult("SCEV_constant", 0);
  Ar.registerResult("SCEV_argument_high", 0);
  Ar.registerResult("SCEV_arg_cv", 0);
  Ar.registerResult("SCEV_overflow", 0);
  Ar.registerResult("SCEV_unknown", 0);
  Ar.registerResult("SCEV_NotImplemented", 0);
  computeLoopBounds(UpperLoopBoundsSCEV, UpperLoopBoundsCtx, CvAnaInfo);
  computeLoopBounds(LowerLoopBoundsSCEV, LowerLoopBoundsCtx, CvAnaInfo);
}

template <llvm::Triple::ArchType ISA>
void LoopBoundInfoPass::computeLoopBounds(
    const std::unordered_map<const llvm::MachineLoop *, const llvm::SCEV *>
        &LoopMapping,
    std::unordered_map<const llvm::MachineLoop *,
                       std::unordered_map<Context, unsigned>> &LoopBounds,
    const CVAnalysisType<ISA> &CvAnaInfo) {
  for (auto Loop : LoopMapping) {
    DEBUG_WITH_TYPE("loopbound", dbgs() << "Trying to compute bounds for: "
                                        << *Loop.first << "\n");
    DEBUG_WITH_TYPE("loopbound",
                    dbgs() << "Equation is: " << *Loop.second << "\n");
    auto *ParentFunction = Loop.first->getHeader()->getParent();
    std::list<MBBedge> Initialedgelist;
    const MachineInstr *FirstInstr =
        getFirstInstrInFunction(ParentFunction, Initialedgelist);
    if (CvAnaInfo.hasAnaInfoBefore(FirstInstr)) {
      DEBUG_WITH_TYPE("loopbound", dbgs() << "We have analysis info.\n");
      auto AnaInfoCtx = CvAnaInfo.getAnaInfoBefore(FirstInstr);
      if (!AnaInfoCtx.isBottom()) {
        auto CtxBounds = getContextSensitiveBounds(
            Loop.first, Loop.second, AnaInfoCtx.getAnalysisInfoPerContext());
        LoopBounds.insert(std::make_pair(Loop.first, CtxBounds));
      } else {
        DEBUG_WITH_TYPE("loopbound", dbgs() << "No Analysis info for bottom\n");
      }
    } else {
      DEBUG_WITH_TYPE("loopbound", dbgs() << "No Analysis info available. Will "
                                             "not get bounds for this loop\n");
    }
  }
}

const std::list<const llvm::MachineLoop *>
LoopBoundInfoPass::getAllLoops() const {
  return MaLoops;
}

bool LoopBoundInfoPass::hasLoopBoundNoCtx(
    const llvm::MachineLoop *Loop,
    const std::unordered_map<const llvm::MachineLoop *,
                             std::unordered_map<Context, unsigned>> &LoopBounds,
    const std::unordered_map<const llvm::MachineLoop *,
                             std::unordered_map<Context, unsigned>>
        &ManualLoopBounds,
    const std::unordered_map<const llvm::MachineLoop *, unsigned>
        &ManualLoopBoundsNoCtx) const {

  bool HasBound = true;
  for (auto Ctx : LoopContextMap.at(Loop)) {
    HasBound &= hasLoopBound(Loop, LoopBounds, ManualLoopBounds,
                             ManualLoopBoundsNoCtx, Ctx);
  }
  return HasBound;
}

bool LoopBoundInfoPass::hasUpperLoopBound(const llvm::MachineLoop *Loop,
                                          const Context &Ctx) const {
  if (Ctx.isEmpty()) {
    return hasLoopBoundNoCtx(Loop, UpperLoopBoundsCtx, ManualUpperLoopBounds,
                             ManualUpperLoopBoundsNoCtx);
  }
  return hasLoopBound(Loop, UpperLoopBoundsCtx, ManualUpperLoopBounds,
                      ManualUpperLoopBoundsNoCtx, Ctx);
}

bool LoopBoundInfoPass::hasLowerLoopBound(const llvm::MachineLoop *Loop,
                                          const Context &Ctx) const {
  if (Ctx.isEmpty()) {
    return hasLoopBoundNoCtx(Loop, LowerLoopBoundsCtx, ManualLowerLoopBounds,
                             ManualLowerLoopBoundsNoCtx);
  }
  return hasLoopBound(Loop, LowerLoopBoundsCtx, ManualLowerLoopBounds,
                      ManualLowerLoopBoundsNoCtx, Ctx);
}

bool LoopBoundInfoPass::hasLoopBound(
    const llvm::MachineLoop *Loop,
    const std::unordered_map<const llvm::MachineLoop *,
                             std::unordered_map<Context, unsigned>> &LoopBounds,
    const std::unordered_map<const llvm::MachineLoop *,
                             std::unordered_map<Context, unsigned>>
        &ManualLoopBounds,
    const std::unordered_map<const llvm::MachineLoop *, unsigned>
        &ManualLoopBoundsNoCtx,
    const Context &Ctx) const {
  bool HasBound = false;

  if (LoopBounds.count(Loop) > 0) {
    HasBound = !!LoopBounds.at(Loop).count(Ctx);
  }

  if (!HasBound && ManualLoopBounds.count(Loop) > 0) {
    HasBound = !!ManualLoopBounds.at(Loop).count(Ctx);
  }

  if (!HasBound) {
    HasBound = !!ManualLoopBoundsNoCtx.count(Loop);
  }

  return HasBound;
}

unsigned LoopBoundInfoPass::getLoopBoundNoCtx(
    const llvm::MachineLoop *Loop,
    const std::unordered_map<const llvm::MachineLoop *,
                             std::unordered_map<Context, unsigned>> &LoopBounds,
    const std::unordered_map<const llvm::MachineLoop *,
                             std::unordered_map<Context, unsigned>>
        &ManualLoopBounds,
    const std::unordered_map<const llvm::MachineLoop *, unsigned>
        &ManualLoopBoundsNoCtx) const {
  unsigned MaxBound = 0;
  for (auto Ctx : LoopContextMap.at(Loop)) {
    MaxBound =
        std::max(MaxBound, getLoopBound(Loop, LoopBounds, ManualLoopBounds,
                                        ManualLoopBoundsNoCtx, Ctx));
  }
  return MaxBound;
}

unsigned LoopBoundInfoPass::getUpperLoopBound(const llvm::MachineLoop *Loop,
                                              const Context &Ctx) const {
  if (Ctx.isEmpty()) {
    return getLoopBoundNoCtx(Loop, UpperLoopBoundsCtx, ManualUpperLoopBounds,
                             ManualUpperLoopBoundsNoCtx);
  }
  return getLoopBound(Loop, UpperLoopBoundsCtx, ManualUpperLoopBounds,
                      ManualUpperLoopBoundsNoCtx, Ctx);
}

unsigned LoopBoundInfoPass::getLowerLoopBound(const llvm::MachineLoop *Loop,
                                              const Context &Ctx) const {
  if (Ctx.isEmpty()) {
    return getLoopBoundNoCtx(Loop, LowerLoopBoundsCtx, ManualLowerLoopBounds,
                             ManualLowerLoopBoundsNoCtx);
  }
  return getLoopBound(Loop, LowerLoopBoundsCtx, ManualLowerLoopBounds,
                      ManualLowerLoopBoundsNoCtx, Ctx);
}

unsigned LoopBoundInfoPass::getLoopBound(
    const llvm::MachineLoop *Loop,
    const std::unordered_map<const llvm::MachineLoop *,
                             std::unordered_map<Context, unsigned>> &LoopBounds,
    const std::unordered_map<const llvm::MachineLoop *,
                             std::unordered_map<Context, unsigned>>
        &ManualLoopBounds,
    const std::unordered_map<const llvm::MachineLoop *, unsigned>
        &ManualLoopBoundsNoCtx,
    const Context &Ctx) const {
  assert(hasLoopBound(Loop, LoopBounds, ManualLoopBounds, ManualLoopBoundsNoCtx,
                      Ctx) &&
         "We do not have a loop bound, check before");
  assert(!Ctx.isEmpty() && "Don't pass an empty context to getLoopBound");
  unsigned Bound;
  bool FoundBoundManual = false;

  if (ManualLoopBoundsNoCtx.count(Loop) > 0) {
    Bound = ManualLoopBoundsNoCtx.at(Loop);
    FoundBoundManual = true;
  }

  if (ManualLoopBounds.count(Loop) > 0) {
    auto ManualBounds = ManualLoopBounds.at(Loop);
    if (ManualBounds.count(Ctx) > 0) {
      auto ManualBoundVal = ManualBounds.at(Ctx);
      if (FoundBoundManual && (Bound != ManualBoundVal)) {
        errs() << "Warning: Both CtxSens and Plain manual loop bounds were "
                  "found and bounds differ! (CtxSens was used) for:\n"
               << *Loop << "| ManualBoundVal: " << ManualBoundVal
               << ", Bound: " << Bound << "\n";
      }
      Bound = ManualBoundVal;
    }
  }

  if (LoopBounds.count(Loop) > 0) {
    auto CtxBounds = LoopBounds.at(Loop);
    if (CtxBounds.count(Ctx) > 0) {
      auto AutoBound = CtxBounds.at(Ctx);
      if (FoundBoundManual && (AutoBound != Bound)) {
        errs() << "Warnings Both automatic and manual loop bounds were found "
                  "and bounds differ! (Automatic used) for:\n"
               << Loop->getHeader()->getParent()->getName().str() << " | "
               << *Loop << "| AutoBound: " << AutoBound << ", Bound: " << Bound
               << "\n";
      }
      Bound = AutoBound;
    }
  }

  return Bound;
}

void LoopBoundInfoPass::dump(std::ostream &Mystream) const {
  raw_os_ostream Llvmstream(Mystream);
  Llvmstream << "We found the following loop bounds automatically:\n";
  std::set<std::string> OrderedLoopBoundOutput;
  for (auto LoopMap : LoopContextMap) {
    auto *Func = LoopMap.first->getHeader()->getParent();
    for (auto Ctx : LoopMap.second) {
      if (hasUpperLoopBound(LoopMap.first, Ctx)) {
        OrderedLoopBoundOutput.insert(
            "# In function " + Func->getName().str() + ", loop:\n  " +
            getLoopDesc(LoopMap.first) + " with context " + Ctx.serialize() +
            "\nthe loop header is executed at most " +
            std::to_string(getUpperLoopBound(LoopMap.first, Ctx)) +
            " times.\n");
      } else {
        OrderedLoopBoundOutput.insert(
            "# In function " + Func->getName().str() + ", loop:\n  " +
            getLoopDesc(LoopMap.first) + " with context " + Ctx.serialize() +
            "\nthe loop header execution count cannot be bounded.\n");
      }
    }
  }
  for (auto &Output : OrderedLoopBoundOutput) {
    Llvmstream << Output;
  }
}

std::string
LoopBoundInfoPass::getLoopDesc(const llvm::MachineLoop *Loop) const {
  std::string Res;
  auto LoopBlocks = Loop->getBlocks();
  for (auto &Block : LoopBlocks) {
    Res += "BB#";
    Res += std::to_string(Block->getNumber());
    Res += ":";
    Res += Block->getName();
    if (Block == Loop->getHeader()) {
      Res += "<header>";
    }
    if (Block == Loop->getLoopLatch()) {
      Res += "<latch>";
    }
    if (Loop->isLoopExiting(Block)) {
      Res += "<exiting>";
    }
    Res += "_";
  }
  return Res.substr(0, Res.size() - 1);
}

void LoopBoundInfoPass::dumpNonUpperBoundLoops(std::ostream &Mystream,
                                               std::ostream &Mystream2) const {
  dumpNonBoundLoops(Mystream, Mystream2,
                    &TimingAnalysisPass::LoopBoundInfoPass::hasUpperLoopBound,
                    &TimingAnalysisPass::LoopBoundInfoPass::getUpperLoopBound);
}

void LoopBoundInfoPass::dumpNonLowerBoundLoops(std::ostream &Mystream,
                                               std::ostream &Mystream2) const {
  dumpNonBoundLoops(Mystream, Mystream2,
                    &TimingAnalysisPass::LoopBoundInfoPass::hasLowerLoopBound,
                    &TimingAnalysisPass::LoopBoundInfoPass::getLowerLoopBound);
}

void LoopBoundInfoPass::dumpNonBoundLoops(
    std::ostream &Mystream, std::ostream &Mystream2,
    bool (LoopBoundInfoPass::*HasLoopBoundFkt)(const llvm::MachineLoop *Loop,
                                               const Context &Ctx) const,
    unsigned (LoopBoundInfoPass::*GetLoopBoundFkt)(
        const llvm::MachineLoop *Loop, const Context &Ctx) const) const {
  DEBUG_WITH_TYPE("loopdump", dbgs() << "Beginning loop dump\n");
  CallGraph &Cg = CallGraph::getGraph();
  raw_os_ostream Llvmstream(Mystream);
  raw_os_ostream Llvmstream2(Mystream2);
  Llvmstream << "# Type: ContextSensitive\n";
  Llvmstream2 << "# Type: Normal\n";
  for (auto LoopMap : LoopMapping) {
    std::string LoopInfoString;
    raw_string_ostream LoopInfo(LoopInfoString);
    auto *Header = LoopMap.first->getHeader();
    if (!Cg.reachableFromEntryPoint(Header->getParent())) {
      continue;
    }
    DEBUG_WITH_TYPE("loopdump", dbgs() << "[Loop]: " << *LoopMap.first);
    LoopInfo << Header->getParent()->getName() << "|";
    LoopInfo << "Loop ";
    DEBUG_WITH_TYPE("loopdump",
                    dbgs() << "[LFunc]: " << Header->getParent()->getName()
                           << "\n");
    if (!Header->empty() && !Header->front().isTransient() &&
        !(Header->front().mayLoad() || Header->front().mayStore()) &&
        Header->front().getDebugLoc() &&
        Header->front().getDebugLoc().getLine() != 0) {
      auto DbgLoc = Header->front().getDebugLoc();
      std::string Filename = getFilenameFromDebugLoc(DbgLoc);
      LoopInfo << "in file " << Filename;
      LoopInfo << " near line " << DbgLoc.getLine() << "|";
    } else {
      bool Unknown = true;
      for (auto &CurrInstr : *Header) {
        if (CurrInstr.isTransient() || CurrInstr.mayLoad() ||
            CurrInstr.mayStore()) {
          continue;
        }
        if (CurrInstr.getDebugLoc() && CurrInstr.getDebugLoc().getLine() != 0) {
          std::string Filename =
              getFilenameFromDebugLoc(CurrInstr.getDebugLoc());
          LoopInfo << "in file " << Filename;
          LoopInfo << " near line " << CurrInstr.getDebugLoc().getLine() << "|";
          Unknown = false;
          break;
        }
      }
      if (Unknown) {
        // Try to get information from the middle-end loops
        if (LoopMapping.count(LoopMap.first) > 0) {
          std::cout << "Trying to get info from middle-end loops\n";
          const auto *Irloop = LoopMapping.at(LoopMap.first);
          auto *Irinstr = Irloop->getHeader()->getTerminator();
          if (Irinstr != nullptr && Irinstr->getDebugLoc() &&
              Irinstr->getDebugLoc().getLine() != 0) {
            std::string Filename =
                getFilenameFromDebugLoc(Irinstr->getDebugLoc());
            LoopInfo << "in file " << Filename;
            LoopInfo << " near line " << Irinstr->getDebugLoc().getLine()
                     << "|";
            Unknown = false;
          } else {
            assert(Irinstr != nullptr && "IR Instr is nullptr");
            assert(Irinstr->getDebugLoc() && "Could not get DebugLoc from IR");
            assert(false);
          }
        }
        // If still unknown
        if (Unknown) {
          LoopInfo << "in file UNKNOWN near line 0|";
        }
      }
    }
    DEBUG_WITH_TYPE("loopdump", dbgs() << "[LSTR]: " << LoopInfo.str() << "\n");

    LoopInfo << getLoopDesc(LoopMap.first) << "|";
    auto MaxBound = -1;

    if (LoopContextMap.count(LoopMap.first) > 0) {
      assert(LoopContextMap.at(LoopMap.first).size() > 0);
      // Format is: "Function|LoopDescription|LoopContext|Bound"\n
      for (auto Ctx : LoopContextMap.at(LoopMap.first)) {
        DEBUG_WITH_TYPE("loopdump",
                        dbgs() << "Context: " << Ctx.serialize() << "\n");
        Llvmstream << LoopInfo.str() << Ctx.serialize() << "|";
        if ((this->*HasLoopBoundFkt)(LoopMap.first, Ctx)) {
          auto Bound = (this->*GetLoopBoundFkt)(LoopMap.first, Ctx);
          Llvmstream << Bound;
          MaxBound = std::max(MaxBound, (int)Bound);
        } else {
          Llvmstream << "-1";
        }
        Llvmstream << "\n";
      }
    }
    DEBUG_WITH_TYPE("loopdump",
                    dbgs() << "[LCTX]: " << LoopInfo.str() << MaxBound << "\n");
    Llvmstream2 << LoopInfo.str() << MaxBound << "\n";
    /* DEBUG_WITH_TYPE("loopdump", dbgs() << llvmstream2.str() << "\n"); */
  }
}

void LoopBoundInfoPass::parseManualUpperLoopBounds(const char *Filename) {
  DEBUG_WITH_TYPE("loopbound", dbgs() << "# Parse upper loop bounds\n");
  parseManualLoopBounds(Filename, ManualUpperLoopBounds,
                        ManualUpperLoopBoundsNoCtx);
}

void LoopBoundInfoPass::parseManualLowerLoopBounds(const char *Filename) {
  DEBUG_WITH_TYPE("loopbound", dbgs() << "# Parse lower loop bounds\n");
  parseManualLoopBounds(Filename, ManualLowerLoopBounds,
                        ManualLowerLoopBoundsNoCtx);
}

void LoopBoundInfoPass::parseNormalManualLoopBounds(
    std::ifstream &File,
    std::unordered_map<const llvm::MachineLoop *, unsigned> &ManualLoopBounds) {
  DEBUG_WITH_TYPE("loopbound",
                  dbgs() << "## Parsing Normal (Non CtxSens) Manual Bounds\n");

  typedef boost::tokenizer<boost::escaped_list_separator<char>> Tokenizer;
  boost::escaped_list_separator<char> Sep('\\', '|', '"');

  for (std::string Line; getline(File, Line);) {
    DEBUG_WITH_TYPE("loopbound", dbgs()
                                     << "# Processing line: " << Line << "\n");
    std::vector<std::string> Vect;
    Tokenizer Token(Line, Sep);
    Vect.assign(Token.begin(), Token.end());
    assert(Vect.size() == 4 && "CSV file was corrupted!");
    std::string FunctionName = Vect[0];
    // vect[1] ist only debug location printing
    std::string LoopDesc = Vect[2];
    int Value = std::stoi(Vect[3]);
    // -2 corresponds to do not care about this loop
    if (Value == -2) {
      continue;
    }
    // Other negative values correspond to undefined
    assert(Value >= 0 && "[Error] Loop bound is not properly defined.\n");
    // Add non-negative manual loop bound
    unsigned Bound = (unsigned)Value;
    for (const auto *Loop : MaLoops) {
      DEBUG_WITH_TYPE("loopbound",
                      dbgs() << "# Checking equivalence for loop: " << *Loop);
      if (Loop->getHeader()->getParent()->getName() == FunctionName) {
        DEBUG_WITH_TYPE("loopbound", dbgs() << "# Matching function name\n");
        DEBUG_WITH_TYPE("loopbound", dbgs() << "# Checking loop descriptions:\n"
                                            << LoopDesc << "\n"
                                            << getLoopDesc(Loop) << "\n";);
        if (getLoopDesc(Loop) == LoopDesc) {
          DEBUG_WITH_TYPE("loopbound", dbgs()
                                           << "# Matching loop description\n");
          const MachineLoop *Maloop = Loop;
          ManualLoopBounds.insert(std::make_pair(Maloop, Bound));
          DEBUG_WITH_TYPE("loopbound", dbgs() << "Add bound for " << Maloop
                                              << "(" << *Maloop << ")"
                                              << " as " << Bound << "\n");
          goto end_loop;
        }
      }
    }
  end_loop:
    ((void)0);
  }
}

void LoopBoundInfoPass::parseCtxSensManualLoopBounds(
    std::ifstream &File,
    std::unordered_map<const llvm::MachineLoop *,
                       std::unordered_map<Context, unsigned>>
        &ManualLoopBounds) {
  DEBUG_WITH_TYPE("loopbound",
                  dbgs() << "## Parsing Context Sensitive Manual Bounds\n");

  typedef boost::tokenizer<boost::escaped_list_separator<char>> Tokenizer;
  boost::escaped_list_separator<char> Sep('\\', '|', '"');

  for (std::string Line; getline(File, Line);) {
    DEBUG_WITH_TYPE("loopbound", dbgs()
                                     << "# Processing line: " << Line << "\n");
    std::vector<std::string> Vect;
    Tokenizer Token(Line, Sep);
    Vect.assign(Token.begin(), Token.end());
    assert(Vect.size() == 5 && "CSV file was corrupted!");
    std::string FunctionName = Vect[0];
    // vect[1] ist only debug location printing
    std::string LoopDesc = Vect[2];
    std::string Context = Vect[3];
    int Value = std::stoi(Vect[4]);
    // -2 corresponds to do not care about this loop
    if (Value == -2) {
      continue;
    }
    // Other negative values correspond to undefined
    assert(Value >= 0 && "[Error] Loop bound is not properly defined.\n");
    // Add non-negative manual loop bound
    unsigned Bound = (unsigned)Value;
    for (const auto *Loop : MaLoops) {
      DEBUG_WITH_TYPE("loopbound",
                      dbgs() << "# Checking equivalence for loop: " << *Loop);
      if (Loop->getHeader()->getParent()->getName() == FunctionName) {
        DEBUG_WITH_TYPE("loopbound", dbgs() << "# Matching function name\n");
        DEBUG_WITH_TYPE("loopbound", dbgs() << "# Checking loop descriptions:\n"
                                            << LoopDesc << "\n"
                                            << getLoopDesc(Loop) << "\n";);
        if (getLoopDesc(Loop) == LoopDesc) {
          DEBUG_WITH_TYPE("loopbound", dbgs()
                                           << "# Matching loop description\n");
          DEBUG_WITH_TYPE("loopbound", dbgs() << "# Checking loop contexts:\n");
          for (auto Ctx : LoopContextMap.at(Loop)) {
            DEBUG_WITH_TYPE("loopbound", dbgs() << "# Checking context: "
                                                << Ctx.serialize() << "\n");
            if (Ctx.serialize() == Context) {
              DEBUG_WITH_TYPE("loopbound", dbgs()
                                               << "# Matching context found\n");
              const MachineLoop *Maloop = Loop;
              ManualLoopBounds[Maloop].insert(std::make_pair(Ctx, Bound));
              DEBUG_WITH_TYPE("loopbound", dbgs() << "Add bound for " << Maloop
                                                  << "(" << *Maloop
                                                  << ") in context " << Context
                                                  << " as " << Bound << "\n");
              goto end_loop;
            }
          }
        }
      }
    }
  end_loop:
    ((void)0);
  }
}

void LoopBoundInfoPass::parseManualLoopBounds(
    const char *Filename,
    std::unordered_map<const llvm::MachineLoop *,
                       std::unordered_map<Context, unsigned>> &ManualLoopBounds,
    std::unordered_map<const llvm::MachineLoop *, unsigned>
        &ManualLoopBoundsNoCtx) {
  DEBUG_WITH_TYPE("loopbound", dbgs() << "# Parse bounds\n");

  std::ifstream File(Filename);
  if (!(File.good())) {
    errs() << Filename << "File could not be opened!\n";
    return;
  }
  std::string Line;
  getline(File, Line);

  if (Line == "# Type: ContextSensitive") {
    LoopBoundInfoPass::parseCtxSensManualLoopBounds(File, ManualLoopBounds);
  } else if (Line.compare("# Type: Normal") == 0) {
    LoopBoundInfoPass::parseNormalManualLoopBounds(File, ManualLoopBoundsNoCtx);
  } else {
    assert(
        false &&
        "Manual Loopbounds should define type in (ContextSensitive, Normal)");
  }
  File.close();
}
} // namespace TimingAnalysisPass

FunctionPass *llvm::createLoopBoundInfoPass() {
  TimingAnalysisPass::LoopBoundInfo =
      new TimingAnalysisPass::LoopBoundInfoPass();
  return TimingAnalysisPass::LoopBoundInfo;
}
