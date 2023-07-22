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

#include "LLVMPasses/AsmDumpAndCheckPass.h"

#include "RISCV.h"

#include "Util/Options.h"
#include "Util/Util.h"

#include "llvm/Support/FileSystem.h"

using namespace llvm;

namespace TimingAnalysisPass {

char AsmDumpAndCheckPass::ID = 0;

/**
 * @brief Construct a new Asm Dump And Check Pass:: Asm Dump And Check Pass
 * object
 *
 * @param TM
 */
AsmDumpAndCheckPass::AsmDumpAndCheckPass(TargetMachine &TM)
    : MachineFunctionPass(ID), TM(TM), SeenUnknownInstruction(false) {
  auto Arch = TM.getTargetTriple().getArch();
  if (Arch != llvm::Triple::ArchType::arm &&
      Arch != llvm::Triple::ArchType::riscv32) {
    errs() << "Unknown arch: " << Arch << "\n";
    assert(0 && "not implemented");
  }
  std::error_code ErrInfo;
  ;
  raw_fd_ostream Myfile("Assembler.txt", ErrInfo, sys::fs::OF_None);
  Myfile << "Textual Machine Code Representation\n"
         << "------------------------------------\n\n";
  Myfile.close();
}

/**
 * @brief Checks if unknown Instructions were found.
 *        Always returns false.
 *
 * @return false
 */
bool AsmDumpAndCheckPass::doFinalization(Module &) {
  if (SeenUnknownInstruction) {
    assert(0 && "Found unknown instruction");
  }
  return false;
}
/**
 * @brief Iterates over MachineFunction
 *        and dumps its content into a File.
 *
 * @param F
 * @return true
 * @return false
 */
bool AsmDumpAndCheckPass::runOnMachineFunction(MachineFunction &F) {
  // If we want to see the assembler code that we analyse, dump it
  std::error_code ErrInfo;
  raw_fd_ostream Myfile("Assembler.txt", ErrInfo, sys::fs::OF_Append);
  F.print(Myfile);
  Myfile.close();

  // Check compliance of binary (especially the instructions) with our
  // assumptions
  for (MachineFunction::iterator FI = F.begin(); FI != F.end(); ++FI) {
    runOnMachineBasicBlock(*FI);
  }
  return false;
}

template <>
void AsmDumpAndCheckPass::checkInstruction<llvm::Triple::ArchType::arm>(
    const MachineInstr &I);
template <>
void AsmDumpAndCheckPass::checkInstruction<llvm::Triple::ArchType::riscv32>(
    const MachineInstr &I);

/**
 * @brief Calls checkInstruction on all Instructions in MBB.
 *
 * @param MBB
 * @return true
 * @return false
 */
bool AsmDumpAndCheckPass::runOnMachineBasicBlock(MachineBasicBlock &MBB) {
  for (auto &I : MBB) {
    assert(!I.isBundle() && "We found a bundled instruction!");

    auto Arch = TM.getTargetTriple().getArch();
    if (Arch == llvm::Triple::ArchType::arm) {
      checkInstruction<llvm::Triple::ArchType::arm>(I);
    } else if (Arch == llvm::Triple::ArchType::riscv32) {
      checkInstruction<llvm::Triple::ArchType::riscv32>(I);
    }
  }
  return false;
}

/**
 * @brief Checks if MachineInstr is implemented in LLVMTA
 *
 * @tparam riscv32
 * @param I
 */
template <>
void AsmDumpAndCheckPass::checkInstruction<llvm::Triple::ArchType::riscv32>(
    const MachineInstr &I) {
  bool Predicated = isPredicated(&I);
  assert(!Predicated &&
         "Predicated RISC-V instructions are not supported by llvmta");

  switch (I.getOpcode()) {
  case RISCV::IMPLICIT_DEF:
  case RISCV::CFI_INSTRUCTION:
  case RISCV::KILL:

  // Integer subset r32i
  case RISCV::LUI:

  case RISCV::JAL:
  case RISCV::JALR:
  case RISCV::PseudoRET:  // is a jalr $x0 $x1
  case RISCV::PseudoCALL: // is a pair of auipc + jalr which can be transformed
                          // by the linker with R_RISCV_CALL relocations
  case RISCV::PseudoBR:   // is a jal $x0

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

  // m extension
  case RISCV::MUL:
  case RISCV::MULH:
  case RISCV::MULHSU:
  case RISCV::MULHU:
  case RISCV::DIV:
  case RISCV::DIVU:
  case RISCV::REM:
  case RISCV::REMU:

  // Floating Point (single and double, f & d extension)
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

    break;
  default:
    errs() << "UNKNOWN: " << I << "\n";
    SeenUnknownInstruction = true;
    if (StrictMode) {
      assert(0 && "Found unknown instruction");
    }
    break;
  }
}

/**
 * @brief Checks if MachineInstr is implemented in LLVMTA
 *
 * @tparam arm
 * @param I
 */
template <>
void AsmDumpAndCheckPass::checkInstruction<llvm::Triple::ArchType::arm>(
    const MachineInstr &I) {
  bool Predicated = isPredicated(&I);
  if ((I.isCall() || I.mayLoad() || I.mayStore()) && Predicated) {
    assert(0 && "Predicated Calls/Loads/Stores are not supported by llvmta");
  }

  if (StrictMode) {
    if (!I.isBranch() && Predicated) {
      errs() << I;
    }
    assert((I.isBranch() || !Predicated) &&
           "No predicated execution for non-branches");
  }

  // Use ARMCodeEmitter.cpp to understand all of these instructions
  switch (I.getOpcode()) {
  // Branches in a wider sense
  case ARM::BX_RET: // Branch Return, load lr register into pc register
    break;

  case ARM::BL:      // Branch to label and link
  case ARM::BL_pred: // Branch to label and link, but this time predicated
  case ARM::Bcc:     // Branch to label on condition
  case ARM::B:       // Branch to label always
    // Currently unsupported			case ARM::BR_JTr: // this is a jump
    // table instruction
    assert((I.getDesc().isBranch() || I.getDesc().isCall()) &&
           "This should be a branch!");
    // FIXME not always a branch, might be a call as well
    break;

  case ARM::MOVr: // Move register to register
  case ARM::MOVi: // Move rotated (bit[11..8]) immediate (bit[7..0]) to register
  case ARM::MOVsi: // Move register to register with immediate shift (bit[11..7]
                   // shift_imm, bit[6..5] shift, bit[4] 0, bit[3..0] Rm
  case ARM::MOVsr: // Move register to register with register shift (bit[11.8]
                   // Rs, bit[7] 0, bit[6..5] shift, bit[4] 1, bit[3..0] Rm
  case ARM::MVNi:  // Move not (0xFFFFFFFF xor operand) rotated (bit[11.8])
                   // immediate (bit[7..0]) to register
  case ARM::MVNr:
  case ARM::MVNsi:
  case ARM::MVNsr:

  // Subtraction
  case ARM::SUBri:  // immediate from register
  case ARM::SUBrr:  // register from register
  case ARM::SUBrsi: // shifter_operand (immediate shift) from register
  case ARM::SUBrsr:

  case ARM::SBCri:
  case ARM::SBCrr:
  case ARM::SBCrsi:

  // Reverse Subtraction
  case ARM::RSBri:  // register from immediate
  case ARM::RSBrsi: // register from shifter_operand (immediate shift)

  case ARM::RSCri:
  case ARM::RSCrsi:

  // Addition
  case ARM::ADDrr:  // register and register
  case ARM::ADDrsi: // register and shifter_operand (immediate shift)
  case ARM::ADDrsr: // register and shifter_operand (register shift)
  case ARM::ADDri:  // register and immediate

  case ARM::ADCrr:
  case ARM::ADCri:
  case ARM::ADCrsi:

  // Exclusive Or
  case ARM::EORrsr:
  case ARM::EORrsi:
  case ARM::EORrr:
  case ARM::EORri:

  // Or
  case ARM::ORRri:
  case ARM::ORRrsi:
  case ARM::ORRrsr:
  case ARM::ORRrr:

  // And
  case ARM::ANDrsi:
  case ARM::ANDri:
  case ARM::ANDrr:
  case ARM::ANDrsr:

  case ARM::MULv5:   // multiplication
  case ARM::MLAv5:   // multiply-accumulate
  case ARM::SMULLv5: // signed multiply long
  case ARM::UMULLv5: // unsigned multiply long
  case ARM::UMLALv5:

  // Bit clear, register AND NOT operand2
  case ARM::BICri:
  case ARM::BICrr:
  case ARM::BICrsi:
  case ARM::BICrsr:

  // Test, Update CPSR flags on register AND operand2
  case ARM::TSTri:
  case ARM::TSTrr:
  case ARM::TSTrsr:
  case ARM::TSTrsi:

  case ARM::TEQri:
  case ARM::TEQrr:
  case ARM::TEQrsr:

  // Compare, Update CPSR flags on register - operand2
  case ARM::CMPrr:
  case ARM::CMPri:
  case ARM::CMPrsi:
  case ARM::CMPrsr:
  case ARM::CMNri:
  case ARM::CMNzrr:

  // Misc Data-Processing
  case ARM::RBIT:
  case ARM::CLZ:

  // Prefetch Instructions
  case ARM::PLIi12:
  case ARM::PLDi12:
  case ARM::PLDWi12:
  case ARM::PLIrs:
  case ARM::PLDrs:
  case ARM::PLDWrs:

  // push {..}, store multiple, decrement before
  // pop {..}, load multiple, increment after
  case ARM::LDMIA:
  case ARM::STMIA:
  case ARM::LDMIA_UPD:
  case ARM::LDMIA_RET:
  case ARM::STMIA_UPD:
  case ARM::LDMIB:
  case ARM::STMIB:
  case ARM::LDMIB_UPD:
  case ARM::STMIB_UPD:
  case ARM::LDMDA:
  case ARM::STMDA:
  case ARM::LDMDA_UPD:
  case ARM::STMDA_UPD:
  case ARM::LDMDB:
  case ARM::STMDB:
  case ARM::LDMDB_UPD:
  case ARM::STMDB_UPD:

  // Store word
  case ARM::STRi12:      // address: register +/- immediate (12-bits)
  case ARM::STRrs:       // address: register +/- shifted register
  case ARM::STR_PRE_IMM: // ?? Splitted into micro-ops?
  case ARM::STR_PRE_REG: // ?? Splitted into micro-ops?
  case ARM::STR_POST_IMM:
  case ARM::STR_POST_REG:
  // Store halfword
  case ARM::STRH: // address register, zero offset
  case ARM::STRH_PRE:
  case ARM::STRH_POST:
  // Store byte
  case ARM::STRBrs:        // address: register +/- shifter register
  case ARM::STRB_POST_IMM: // ?? Splitted into micro-ops?
  case ARM::STRB_PRE_IMM:
  case ARM::STRB_PRE_REG:
  case ARM::STRBi12: // address: register +/- immediate (12-bits)
  // Store doulbe-word
  case ARM::STRD:

  // Load word
  case ARM::LDRi12: // address: register +/- immediate (12-bits)
  case ARM::LDRrs:  // address: register +/- shifted register
  case ARM::LDRcp:  // address: constant-pool
  case ARM::LDR_PRE_REG:
  case ARM::LDR_PRE_IMM:
  case ARM::LDR_POST_REG:
  case ARM::LDR_POST_IMM:
  // Load halfword
  case ARM::LDRH:      // unsigned, address: register zero offset
  case ARM::LDRSH:     // signed, address: register zero offset
  case ARM::LDRSH_PRE: // signed
  case ARM::LDRSH_POST:
  case ARM::LDRH_PRE:
  case ARM::LDRH_POST:
  // Load byte
  case ARM::LDRB_POST_IMM:
  case ARM::LDRB_PRE_REG:
  case ARM::LDRB_PRE_IMM:
  case ARM::LDRBi12: // address: register +/- immediate (12-bits)
  case ARM::LDRBrs:  // address: register +/- shifted register
  case ARM::LDRSB:
  case ARM::LDRSB_PRE:

  case ARM::UXTAB:

  // Jump-Table stuff
  case ARM::LEApcrelJT:
  case ARM::BR_JTr:
  case ARM::JUMPTABLE_ADDRS:
  case ARM::BR_JTm_rs:
  case ARM::BR_JTm_i12:

  // Pseudo instructions we support
  case ARM::CONSTPOOL_ENTRY:
  case ARM::IMPLICIT_DEF:
  case ARM::KILL:
  case ARM::DBG_VALUE:
  case ARM::CFI_INSTRUCTION:

  // ARM8 necessary instructions
  case ARM::LEApcrel:
  case ARM::MOVi16:  // MOVw?? Move bottom
  case ARM::MOVTi16: // Move top
  case ARM::SXTH:    // Sign extend + rotate (halfword)
  case ARM::SXTB:    // Sign extend + rotate (byte)
  case ARM::UXTH:    // Zero extend + rotate (halfword)
  case ARM::UXTB:    // Zero extend + rotate (byte)
  case ARM::UXTAH:   // Zero extend + rotate (halfword) + add on value
  case ARM::BFC:     // Bit field clear
  case ARM::BFI:
  case ARM::MUL:
  case ARM::SMMUL:
  case ARM::SMULBB: // Mul bottom bottom
  case ARM::SMULBT: // Mul bottom top
  case ARM::UMULL:
  case ARM::UDIV:
  case ARM::SDIV:
  case ARM::MLS: // Multiple subtract
  case ARM::MLA:
  case ARM::SMMLA:
  case ARM::SMLABB:
  case ARM::UBFX: // Bit field extract and zero extend

  case ARM::VMOVSR:
  case ARM::VMOVRS:
  case ARM::VMOVDRR:
  case ARM::VMOVRRD:
  case ARM::VMOVD:
  case ARM::VMOVS:
  case ARM::VSELEQD:
  case ARM::VABSD:
  case ARM::VABSS:
  case ARM::VSITOD:
  case ARM::VSITOS:
  case ARM::VLDRD:
  case ARM::VLDRS:
  case ARM::VSTRD:
  case ARM::VSTRS:
  case ARM::VLDMSIA:
  case ARM::VLDMSIA_UPD:
  case ARM::VLDMDIA:
  case ARM::VSTMDIA:
  case ARM::VLDMDIA_UPD:
  case ARM::VLDMDDB_UPD:
  case ARM::VSTMDIA_UPD:
  case ARM::VSTMDDB_UPD:
  case ARM::VMULD:
  case ARM::VMULS:
  case ARM::VNMULS:
  case ARM::VNMULD:
  case ARM::VMLAD:
  case ARM::VMLAS:
  case ARM::VMLSD:
  case ARM::VNMLSD:
  case ARM::VNMLSS:
  case ARM::VMLSS:
  case ARM::VSUBD:
  case ARM::VSUBS:
  case ARM::VADDD:
  case ARM::VADDS:
  case ARM::VDIVD:
  case ARM::VDIVS:
  case ARM::VSQRTD:
  case ARM::VNEGD:
  case ARM::VNEGS:
  case ARM::VTOSIZD:
  case ARM::FCONSTD:
  case ARM::FCONSTS:
  case ARM::FMSTAT:
  case ARM::VCMPS:
  case ARM::VCMPD:
  case ARM::VCMPZS:
  case ARM::VCMPZD:
  case ARM::VCMPED:
  case ARM::VCMPES:
  case ARM::VCMPEZD:
  case ARM::VCMPEZS:
  case ARM::VCVTDS:
  case ARM::VCVTSD:
  case ARM::VUITOS:
  case ARM::VUITOD:
  case ARM::VTOSIZS:
  case ARM::VTOUIZD:
  case ARM::VTOUIZS:
    break;
  default:
    errs() << "UNKNOWN: " << I << "\n";
    SeenUnknownInstruction = true;
    if (StrictMode) {
      assert(0 && "Found unknown instruction");
    }
    break;
  }
}

} // namespace TimingAnalysisPass

FunctionPass *llvm::createAsmDumpAndCheckPass(TargetMachine &TM) {
  return new TimingAnalysisPass::AsmDumpAndCheckPass(TM);
}
