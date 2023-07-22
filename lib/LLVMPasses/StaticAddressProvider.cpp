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

#include "LLVMPasses/StaticAddressProvider.h"

#include "RISCV.h"

#include "AnalysisFramework/CallGraph.h"
#include "Util/Options.h"
#include "Util/Util.h"

#include "llvm/CodeGen/MachineConstantPool.h"
#include "llvm/CodeGen/MachineJumpTableInfo.h"
#include "llvm/IR/Constants.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_os_ostream.h"

#include <sstream>

using namespace llvm;

namespace TimingAnalysisPass {

StaticAddressProvider *StaticAddrProvider;

char StaticAddressProvider::ID = 0;

StaticAddressProvider::StaticAddressProvider(TargetMachine &TM)
    : MachineFunctionPass(ID), TM(TM) {
  CodeAddress = CodeStartAddress;
  RodataAddress = 0; // Will be set after the doInitialization()
}

bool StaticAddressProvider::runOnMachineFunction(MachineFunction &F) {
  auto Arch = TM.getTargetTriple().getArch();
  // RISC-V has constant pools for constants of size "double"
  // They are put in a part of the rodata segment
  if (Arch == llvm::Triple::ArchType::riscv32) {
    auto MCP = F.getConstantPool()->getConstants();
    for (unsigned Cpeidx = 0; Cpeidx < MCP.size(); ++Cpeidx) {
      Cpe2addr.insert(
          std::make_pair(std::make_pair(&F, Cpeidx), RodataAddress));
      unsigned Entrysize = MCP[Cpeidx].getSizeInBytes(F.getDataLayout());
      assert(Entrysize % 8 == 0);
      RodataAddress += (Entrysize / 8);
    }
  }

  // Run on basic blocks individually
  bool Changed = false;
  for (MachineFunction::iterator FI = F.begin(); FI != F.end(); ++FI)
    Changed |= runOnMachineBasicBlock(*FI);
  return Changed;
}

bool StaticAddressProvider::runOnMachineBasicBlock(MachineBasicBlock &MBB) {
  unsigned SkipAddresses = 0; // Skip that many words in address space, e.g. for
                              // the jump table allocation

  int PosInMbb = 0;

  auto Arch = TM.getTargetTriple().getArch();

  for (auto &I : MBB) {
    assert(!I.isBundle() && "We found a bundled instruction!");

    bool AssignAddress = false;

    // Remember the position of the instruction within the basic block
    Ins2posinbb.insert(std::make_pair(&I, PosInMbb));
    ++PosInMbb;

    unsigned InstrAllocSizeInBytes = 4;
    if (isPseudoInstruction(&I)) {
      if (Arch == llvm::Triple::ArchType::arm) {
        switch (I.getOpcode()) {
        // If we have a constant pool entry remember its address
        case ARM::CONSTPOOL_ENTRY: {
          unsigned LabelID = I.getOperand(0).getImm(); // The label to load from
          unsigned CPI =
              I.getOperand(1)
                  .getIndex(); // Index of the given constant in the pool
          auto MCP =
              I.getParent()->getParent()->getConstantPool()->getConstants();
          assert(CPI < MCP.size() && "Invalid constant pool index.");
          auto CPELab = std::make_pair(I.getParent()->getParent(), LabelID);
          assert(Cpe2addr.count(CPELab) == 0 &&
                 "We saw same constant pool entry twice");
          const auto *CPE = MCP[CPI].Val.ConstVal;
          // If constant pool contains an address to global variable track it
          if (const GlobalVariable *GV = dyn_cast<GlobalVariable>(CPE)) {
            unsigned VarAddr = Glvar2addr.at(GV);
            Addr2values.insert(std::make_pair(CodeAddress, VarAddr));
            Addr2symbol.insert(std::make_pair(CodeAddress, GV));
          }
          Cpe2addr.insert(std::make_pair(CPELab, CodeAddress));
          AssignAddress = true;
          // CP entry can allocate more than 4 bytes
          InstrAllocSizeInBytes = I.getOperand(2).getImm();
          assert((InstrAllocSizeInBytes % 4 == 0) &&
                 "Cannot have non-4-divisble cp entry size");
          break;
        }
        // We ignore the pseudo-instructions that do not have any effect later
        // on
        case ARM::IMPLICIT_DEF:
        case ARM::KILL:
        case ARM::DBG_VALUE:
        case ARM::CFI_INSTRUCTION:
          assert(I.isTransient() && "Non-effect pseudo might have effect?");
          break;
        // TODO review, why are these instructions pseudo? Have one ISA
        // corresponding instruction... We treat the following instructions as
        // non-pseudo-instructions
        case ARM::B:
        case ARM::MULv5:
        case ARM::SMULLv5:
        case ARM::UMULLv5:
        case ARM::UMLALv5:
        case ARM::MLAv5:
        case ARM::LEApcrelJT:
        case ARM::LEApcrel:
        case ARM::BR_JTr:
        case ARM::BR_JTm_rs:
        case ARM::BR_JTm_i12:
        case ARM::LDMIA_RET:
          // Lowers to LDMIA_UPD during ASM printing.
          AssignAddress = true;
          break;
        case ARM::JUMPTABLE_ADDRS: {
          assert(I.getOperand(1).isJTI() &&
                 "Cannot JUMPTABLE to non jump table");
          assert(MBB.getParent()->getJumpTableInfo() &&
                 "Have JUMPTABLE but not jump table");
          auto JTindex = I.getOperand(1).getIndex();
          // assert (I.getOperand(0).getImm() == JTindex && "First operand
          // expected to be jt-index");
          auto &MJTEs = MBB.getParent()->getJumpTableInfo()->getJumpTables();
          auto &TargetMbBs = MJTEs[JTindex].MBBs;
          assert(TargetMbBs.size() > 0 && "Empty or negative jumptable");
          unsigned Jtsize = TargetMbBs.size();
          assert(I.getOperand(2).getImm() == 4 * Jtsize &&
                 "Third operand expected to be jt-size");
          SkipAddresses += Jtsize;
          AssignAddress = false;
          break;
        }
        default: {
          errs() << (isPseudoInstruction(&I) ? "true" : "false") << I;
          assert(0 && "We have unhandled pseudo instructions");
          break;
        }
        }
      } else if (Arch == llvm::Triple::riscv32) {
        switch (I.getOpcode()) {
        // We ignore the pseudo-instructions that do not have any effect later
        // on
        case RISCV::IMPLICIT_DEF:
        case RISCV::KILL:
        case RISCV::CFI_INSTRUCTION:
          assert(I.isTransient() && "Non-effect pseudo might have effect?");
          break;
        // TODO review, why are all instructions classified as pseudo?
        // We treat the following instructions as non-pseudo-instructions
        case RISCV::LUI:

        case RISCV::JAL:
        case RISCV::JALR:
        case RISCV::PseudoRET:
        case RISCV::PseudoCALL:
        case RISCV::PseudoBR:

        case RISCV::BEQ:
        case RISCV::BNE:
        case RISCV::BLT:
        case RISCV::BGE:
        case RISCV::BLTU:
        case RISCV::BGEU:

        case RISCV::LB:
        case RISCV::LH:
        case RISCV::LW:
        case RISCV::LBU:
        case RISCV::LHU:

        case RISCV::SB:
        case RISCV::SH:
        case RISCV::SW:

        case RISCV::ADDI:
        case RISCV::SLTI:
        case RISCV::SLTIU:
        case RISCV::XORI:
        case RISCV::ORI:
        case RISCV::ANDI:
        case RISCV::SLLI:
        case RISCV::SRLI:
        case RISCV::SRAI:

        case RISCV::ADD:
        case RISCV::SUB:
        case RISCV::SLL:
        case RISCV::SLT:
        case RISCV::SLTU:
        case RISCV::XOR:
        case RISCV::SRL:
        case RISCV::SRA:
        case RISCV::OR:
        case RISCV::AND:

        case RISCV::MUL:
        case RISCV::MULH:
        case RISCV::MULHSU:
        case RISCV::MULHU:
        case RISCV::DIV:
        case RISCV::DIVU:
        case RISCV::REM:
        case RISCV::REMU:

        case RISCV::FLW:
        case RISCV::FSW:
        case RISCV::FLD:
        case RISCV::FSD:

        case RISCV::FMADD_S:
        case RISCV::FMADD_D:
        case RISCV::FMSUB_S:
        case RISCV::FMSUB_D:
        case RISCV::FNMSUB_S:
        case RISCV::FNMSUB_D:
        case RISCV::FNMADD_S:
        case RISCV::FNMADD_D:
        case RISCV::FADD_S:
        case RISCV::FADD_D:
        case RISCV::FSUB_S:
        case RISCV::FSUB_D:
        case RISCV::FMUL_S:
        case RISCV::FMUL_D:
        case RISCV::FDIV_S:
        case RISCV::FDIV_D:

        case RISCV::FSQRT_S:
        case RISCV::FSQRT_D:

        case RISCV::FSGNJ_S:
        case RISCV::FSGNJ_D:
        case RISCV::FSGNJN_S:
        case RISCV::FSGNJN_D:
        case RISCV::FSGNJX_S:
        case RISCV::FSGNJX_D:

        case RISCV::FLE_S:
        case RISCV::FLE_D:
        case RISCV::FLT_S:
        case RISCV::FLT_D:
        case RISCV::FEQ_S:
        case RISCV::FEQ_D:

        case RISCV::FMIN_S:
        case RISCV::FMIN_D:
        case RISCV::FMAX_S:
        case RISCV::FMAX_D:

        case RISCV::FMV_W_X:
        case RISCV::FMV_X_W:

        case RISCV::FCVT_S_W:
        case RISCV::FCVT_S_WU:
        case RISCV::FCVT_W_S:
        case RISCV::FCVT_WU_S:
        case RISCV::FCVT_S_D:
        case RISCV::FCVT_D_S:
        case RISCV::FCVT_W_D:
        case RISCV::FCVT_WU_D:
        case RISCV::FCVT_D_W:
        case RISCV::FCVT_D_WU:

          AssignAddress = true;
          break;
        default: {
          errs() << (isPseudoInstruction(&I) ? "true" : "false") << I;
          assert(0 && "We have unhandled pseudo instructions");
          break;
        }
        }
      }
    } else {
      AssignAddress = true;
    }

    if (AssignAddress) {
      assert(!I.isTransient() &&
             "Instructions might have no effect, but allocate anyway?");
      assert(Ins2addr.count(&I) == 0 && "We saw the same instruction twice.");
      Ins2addr.insert(std::make_pair(&I, CodeAddress));
      assert(Addr2ins.count(CodeAddress) == 0 &&
             "We saw the same address for different instr.");
      Addr2ins.insert(std::make_pair(CodeAddress, &I));

      CodeAddress += InstrAllocSizeInBytes;
    }
  }

  CodeAddress += SkipAddresses * 4;

  return false;
}

bool StaticAddressProvider::doInitialization(Module &M) {
  // TODO Take correct addresses here
  unsigned Startdatasection = 0x00d0000;

  DataLayoutInstance = std::make_unique<const DataLayout>(&M);
  for (Module::const_global_iterator Gvi = M.global_begin();
       Gvi != M.global_end(); ++Gvi) {
    /* align the startaddress to the next variable's desired alignment */
    unsigned Alignment = Gvi->getAlignment();
    assert((Alignment & (Alignment - 1)) == 0 &&
           "alignment is not a power of 2");
    if (Startdatasection & (Alignment - 1)) {
      Startdatasection &= ~(Alignment - 1);
      Startdatasection += Alignment;
    }

    Glvar2addr.insert(std::make_pair(&*Gvi, Startdatasection));
    DEBUG_WITH_TYPE("staddrprov",
                    dbgs() << Startdatasection << ": " << *Gvi << "\n");
    auto *PtrType = Gvi->getType();
    assert(PtrType->isPointerTy() && "Global Variable that is not a pointer");
    auto *ElementType = PtrType->getPointerElementType();
    Startdatasection += M.getDataLayout().getTypeAllocSize(ElementType);
  }

  for (auto &Gl2ad : Glvar2addr) {
    if (!Gl2ad.first->hasInitializer())
      continue;
    const auto *GvInit = Gl2ad.first->getInitializer();
    // If global variable refers another variable, or a constant casted to ptr,
    // track it
    if (const GlobalVariable *GV = dyn_cast<GlobalVariable>(GvInit)) {
      Addr2values.insert(std::make_pair(Gl2ad.second, Glvar2addr.at(GV)));
      Addr2symbol.insert(std::make_pair(Gl2ad.second, GV));
    } else if (const ConstantExpr *CE = dyn_cast<ConstantExpr>(GvInit)) {
      // We require an inttoptr opcode with only one operand
      if (CE->getOpcode() == 43 && CE->op_begin() + 1 == CE->op_end()) {
        auto &FirstOp = *(CE->op_begin());
        if (const ConstantInt *CI = dyn_cast<ConstantInt>(FirstOp)) {
          auto Value = CI->getSExtValue();
          Addr2values.insert(std::make_pair(Gl2ad.second, Value));
        }
      }
    }
  }
  RodataAddress = Startdatasection;
  return false;
}

bool StaticAddressProvider::hasMachineInstrByAddr(unsigned Addr) {
  return Addr2ins.count(Addr) > 0;
}

const MachineInstr *
StaticAddressProvider::getMachineInstrByAddr(unsigned Addr) {
  assert(Addr2ins.count(Addr) > 0 &&
         "Cannot find instruction for given address");
  return Addr2ins[Addr];
}

unsigned StaticAddressProvider::getAddr(const MachineInstr *I) {
  assert(Ins2addr.count(I) > 0 && "Cannot find address for this instruction");
  return Ins2addr.find(I)->second;
}

unsigned StaticAddressProvider::getConstPoolEntryAddr(const MachineFunction *MF,
                                                      unsigned Idx) {
  assert(Cpe2addr.count(std::make_pair(MF, Idx)) > 0 &&
         "Cannot find address for CP entry");
  return Cpe2addr.find(std::make_pair(MF, Idx))->second;
}

bool StaticAddressProvider::hasValueAtAddress(unsigned Addr) {
  return Addr2values.count(Addr) > 0;
}

unsigned StaticAddressProvider::getValueAtAddress(unsigned Addr) {
  assert(hasValueAtAddress(Addr) && "Cannot get value at the given address");
  return Addr2values.at(Addr);
}

const GlobalVariable *StaticAddressProvider::getSymbolAtAddress(unsigned Addr) {
  if (Addr2symbol.count(Addr) > 0) {
    return Addr2symbol.at(Addr);
  }
  return nullptr;
}

bool StaticAddressProvider::hasGlobalVarAddress(const GlobalVariable *Glvar) {
  return Glvar2addr.count(Glvar) > 0;
}

unsigned
StaticAddressProvider::getGlobalVarAddress(const GlobalVariable *Glvar) {
  assert(hasGlobalVarAddress(Glvar) &&
         "Cannot get address for given global variable");
  return Glvar2addr.at(Glvar);
}

unsigned StaticAddressProvider::getArraySize(const GlobalVariable *Glvar) {
  Type *Type = Glvar->getType()->getElementType();
  assert(Type->isSized());
  unsigned Size = DataLayoutInstance->getTypeAllocSize(Type);
  /* if our size is not divisible by four we have to acccess the
   * surrounding word anyway - round up to the next multiple of 4 */
  if (Size % 4 != 0) {
    Size = (Size & ~3) + 4;
  }
  return Size;
}

std::set<const GlobalVariable *>
StaticAddressProvider::getGlobalVariables() const {
  std::set<const GlobalVariable *> Allkeys;
  for (auto &Gva : Glvar2addr) {
    Allkeys.insert(Gva.first);
  }
  return Allkeys;
}

boost::optional<int> StaticAddressProvider::getGlobalVariableInitialValue(
    const GlobalVariable *Glvar) const {
  if (Glvar->hasDefinitiveInitializer() && !Glvar->isExternallyInitialized()) {
    const auto *Constant = Glvar->getInitializer();
    // errs() << *constant << "\n";
    if (const ConstantExpr *Ce = dyn_cast<ConstantExpr>(Constant)) {
      if (Ce->isCast()) {
        assert((Ce->op_begin() + 1 == Ce->op_end()) &&
               "Internal assumption violated");
        if (const ConstantInt *Ci = dyn_cast<ConstantInt>(*Ce->op_begin())) {
          if (Ci->getValue().getActiveBits() <= 32) {
            int Finval = (int)Ci->getLimitedValue();
            return Finval;
          }
          errs() << "[Warning] Detected a constant initializer whose value "
                    "does not fit into 32 bits.\n";
        }
      }
    }
  }
  return boost::none;
}

bool StaticAddressProvider::goesExternal(unsigned Addr) {
  if (this->hasMachineInstrByAddr(Addr)) {
    // We have an instruction for this address, so likely it is not going extern
    return false;
  }
  // Likely we are external otherwise
  return true;
}

void StaticAddressProvider::dump(std::ostream &Mystream) const {
  Mystream << "Address Mapping\n"
           << "---------------\n\n";
  for (auto &Kv : Addr2ins) {
    printHex(Mystream, Kv.first);
    Mystream << ": " << getMachineInstrIdentifier(Kv.second) << "\n";
  }
  Mystream << "\nAddress to Address Mapping\n"
           << "------------------------\n\n";
  for (auto &Av : Addr2values) {
    printHex(Mystream, Av.first);
    Mystream << ": ";
    printHex(Mystream, Av.second);
    if (Addr2symbol.count(Av.first) > 0) {
      Mystream << ", @" << Addr2symbol.at(Av.first)->getName().str();
    }
    Mystream << "\n";
  }

  Mystream << "\nGlobal Variables to Address Mapping\n"
           << "-----------------------------------\n\n";

  llvm::raw_os_ostream LLVMstream(Mystream);
  if (!ArrayAnalysis) {
    LLVMstream << "Note: Array Awareness disabled\n";
  }

  for (auto &Ga : Glvar2addr) {
    LLVMstream << *Ga.first << ": ";
    printHex(LLVMstream, Ga.second);
    LLVMstream << "\n";
  }
}

} // namespace TimingAnalysisPass

FunctionPass *llvm::createStaticAddressProvider(TargetMachine &TM) {
  TimingAnalysisPass::StaticAddrProvider =
      new TimingAnalysisPass::StaticAddressProvider(TM);
  return TimingAnalysisPass::StaticAddrProvider;
}
