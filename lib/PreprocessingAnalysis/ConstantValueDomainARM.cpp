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

#include "PreprocessingAnalysis/ConstantValueDomain.h"

#include "ARM.h"
#include "ARMMachineFunctionInfo.h"
#include "ARMTargetMachine.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/TargetInstrInfo.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Module.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "llvm/Target/TargetMachine.h"

#include "LLVMPasses/TimingAnalysisMain.h"
#include "PreprocessingAnalysis/AddressInformation.h"

using namespace llvm;

namespace TimingAnalysisPass {

static unsigned getAddressMode(const MachineInstr *MI) {
  return ((MI->getDesc().TSFlags) & ARMII::AddrModeMask);
}

template <>
AbstractAddress
ConstantValueDomain<Triple::ArchType::arm>::getDataAccessAddress(
    const MachineInstr *MI, unsigned pos) const {
  if (MI->mayLoad() && MI->mayStore()) {
    errs() << *MI;
  }
  // assertion will fail for prefetch instructions.
  // assert (!(MI->mayLoad() && MI->mayStore()) && "Cannot load and store at
  // same time");

  if (isBottom()) {
    // empty interval
    return AbstractAddress(AddressInterval(1, 0));
  }

  ARM_AM::AMSubMode ldstmsubmode = ARM_AM::bad_am_submode;
  unsigned ldstmdouble = 0; // 0 undef, 1 single, 2 double

  DEBUG_WITH_TYPE("addrinfo", errs() << *MI);
  switch (MI->getOpcode()) {
  // TODO add BR_JTm_rs BR_JTm_i12, we know what will be accessed
  // Immediate offset
  case ARM::PLIi12:
  case ARM::PLDi12:
  case ARM::PLDWi12: {
    // Special address mode for reg +/- imm12
    assert(getAddressMode(MI) == ARMII::AddrMode_i12);
    bool preindex = getIndexMode(MI) == ARMII::IndexModePre;
    assert(preindex || getIndexMode(MI) == ARMII::IndexModeNone);

    unsigned baseregopidx = preindex ? 1 : 0;
    unsigned immopidx = preindex ? 2 : 1;

    assert(MI->getOperand(immopidx).isImm());

    // We load something from our constantpool
    if (MI->getOperand(baseregopidx).isCPI()) {
      assert(MI->getOperand(immopidx).getImm() == 0);
      unsigned cpi = MI->getOperand(baseregopidx).getIndex();
      auto MF = MI->getParent()->getParent();
      unsigned cpeaddr = StaticAddrProvider->getConstPoolEntryAddr(MF, cpi);
      return AbstractAddress(cpeaddr);
    }
    assert(MI->getOperand(baseregopidx).isReg());

    // Base register
    auto baseregnr = MI->getOperand(baseregopidx).getReg();
    assert((!preindex ||
            (MI->getOperand(MI->mayLoad() ? 1 : 0).getReg() == baseregnr)) &&
           "Base regs differ");
    if (isTop(baseregnr)) {
      if (auto glvar = getSymbolFor(baseregnr)) {
        return AbstractAddress(glvar);
      }
      return extractGlobalDatastructure(MI);
    }
    unsigned address = getValueFor(baseregnr);

    // Immediate offset
    int32_t offset = MI->getOperand(immopidx).getImm(); // can be negative
    if (offset == INT32_MIN) { // LLVM special handling for #-0
      offset = 0;
    }

    address += offset;
    return AbstractAddress(address);
  }
  case ARM::LDRcp:
  case ARM::LDRi12:
  case ARM::STRi12:
  case ARM::LDRBi12:
  case ARM::STRBi12:
  // Immediate pre-indexed
  case ARM::LDR_PRE_IMM:
  case ARM::LDRB_PRE_IMM:
  case ARM::STR_PRE_IMM:
  case ARM::STRB_PRE_IMM: {
    // Special address mode for reg +/- imm12
    assert(getAddressMode(MI) == ARMII::AddrMode_i12 ||
           getAddressMode(MI) == ARMII::AddrMode2);
    bool preindex = getIndexMode(MI) == ARMII::IndexModePre;
    assert(preindex || getIndexMode(MI) == ARMII::IndexModeNone);

    unsigned baseregopidx = preindex ? 2 : 1;
    unsigned immopidx = preindex ? 3 : 2;

    assert(MI->getOperand(immopidx).isImm());

    // We load something from our constantpool
    if (MI->getOperand(baseregopidx).isCPI()) {
      assert(MI->getOperand(immopidx).getImm() == 0);
      unsigned cpi = MI->getOperand(baseregopidx).getIndex();
      auto MF = MI->getParent()->getParent();
      unsigned cpeaddr = StaticAddrProvider->getConstPoolEntryAddr(MF, cpi);
      return AbstractAddress(cpeaddr);
    }
    assert(MI->getOperand(baseregopidx).isReg());

    // Base register
    auto baseregnr = MI->getOperand(baseregopidx).getReg();
    assert((!preindex ||
            (MI->getOperand(MI->mayLoad() ? 1 : 0).getReg() == baseregnr)) &&
           "Base regs differ");
    if (isTop(baseregnr)) {
      if (auto glvar = getSymbolFor(baseregnr)) {
        return AbstractAddress(glvar);
      }
      return extractGlobalDatastructure(MI);
    }
    unsigned address = getValueFor(baseregnr);

    // Immediate offset
    int32_t offset = MI->getOperand(immopidx).getImm(); // can be negative
    if (offset == INT32_MIN) { // LLVM special handling for #-0
      offset = 0;
    }

    address += offset;
    return AbstractAddress(address);
  }
  // Immediate/Register post-indexed
  case ARM::STR_POST_IMM:
  case ARM::STRB_POST_IMM:
  case ARM::LDR_POST_IMM:
  case ARM::LDRB_POST_IMM:
  case ARM::LDR_POST_REG:
  case ARM::STR_POST_REG: {
    assert(getAddressMode(MI) == ARMII::AddrMode2);
    assert(getIndexMode(MI) == ARMII::IndexModePost);
    assert(MI->getOperand(0).isReg()); // Base Reg or load result
    assert(MI->getOperand(1).isReg()); // Store value or base reg
    assert(MI->getOperand(2).isReg()); // Base reg
    assert(MI->getOperand(3).isReg());
    assert(MI->getOperand(4).isImm());

    auto baseregnr = MI->getOperand(2).getReg();
    assert((MI->getOperand(MI->mayLoad() ? 1 : 0).getReg() == baseregnr) &&
           "Base regs differ");

    // Immediate not needed here, just for reference
    /*unsigned immval = MI->getOperand(immIdx).getImm();
    uint32_t offset = ARM_AM::getAM2Offset(immval); // only 12 bits
    bool isSub = ARM_AM::getAM2Op(immval) == ARM_AM::sub; // should offset be
    added of subtracted*/

    if (isTop(baseregnr)) {
      if (auto glvar = getSymbolFor(baseregnr)) {
        return AbstractAddress(glvar);
      }
      return extractGlobalDatastructure(MI);
    }
    // Post-indexed: The base register forms the memory address.
    return AbstractAddress(getValueFor(baseregnr));
  }
  // (Scaled) Register offset
  case ARM::LDRrs:
  case ARM::LDRBrs:
  case ARM::STRrs:
  case ARM::STRBrs:
  case ARM::PLIrs:
  case ARM::PLDrs:
  case ARM::PLDWrs:
  // (scaled) Register pre-indexed
  case ARM::LDRB_PRE_REG:
  case ARM::LDR_PRE_REG:
  case ARM::STR_PRE_REG:
  case ARM::STRB_PRE_REG: {
    assert(getAddressMode(MI) == ARMII::AddrModeNone ||
           getAddressMode(MI) == ARMII::AddrMode2);
    bool preindex = getIndexMode(MI) == ARMII::IndexModePre;
    assert(preindex || getIndexMode(MI) == ARMII::IndexModeNone);

    unsigned baseregopidx = preindex ? 2 : 1;
    unsigned offsetregopidx = preindex ? 3 : 2;
    unsigned shiftopidx = preindex ? 4 : 3;

    auto baseregnr = MI->getOperand(baseregopidx).getReg();
    auto offsetregnr = MI->getOperand(offsetregopidx).getReg();
    auto shiftop = MI->getOperand(shiftopidx).getImm();
    assert((!preindex ||
            (MI->getOperand(MI->mayLoad() ? 1 : 0).getReg() == baseregnr)) &&
           "Base regs differ");

    if (isTop(baseregnr) || isTop(offsetregnr)) {
      // We tracked down the symbol during analysis
      if (auto glvar = getSymbolFor(baseregnr)) {
        return AbstractAddress(glvar);
      }
      // If not, let us try the mem-operand solution
      return extractGlobalDatastructure(MI);
    }
    int rmregval = getValueFor(offsetregnr);

    unsigned shImm = ARM_AM::getAM2Offset(shiftop);   // Bit [11:7]
    unsigned shOpc = ARM_AM::getAM2ShiftOpc(shiftop); // Bit [6:5]
    switch (shOpc) {
    // See ARM Architecture Reference Manual
    case ARM_AM::no_shift: // LLVM no-op
      break;
    case ARM_AM::lsl: {
      rmregval = rmregval << shImm;
      break;
    }
    case ARM_AM::asr: {
      if (shImm == 0) { // Shift by 32
        if (rmregval & 0x8000000) {
          rmregval = 0xFFFFFFFF;
        } else {
          rmregval = 0;
        }
      } else {
        rmregval = rmregval >> shImm;
      }
      break;
    }
    case ARM_AM::lsr: {
      if (shImm == 0) { // Shift by 32
        rmregval = 0;
      } else { // logic right shift
        rmregval = (((unsigned)rmregval) >> shImm);
      }
      break;
    }
    case ARM_AM::ror:
    case ARM_AM::rrx:
    default:
      assert(0 && "Unsupported shift/rotation in load");
    }
    unsigned address = getValueFor(baseregnr);
    if (ARM_AM::getAM2Op(shiftop) == ARM_AM::add) {
      address += rmregval;
    } else {
      address -= rmregval;
    }
    return AbstractAddress(address);
  }
  // Miscellaneous loads/stores
  // Byte loads
  case ARM::LDRSB:
  case ARM::LDRSB_PRE:
  // Halfword immediate/register offset
  case ARM::LDRH:
  case ARM::LDRSH:
  case ARM::STRH:
  // Halfword immediate/register pre-indexed
  case ARM::LDRH_PRE:
  case ARM::LDRSH_PRE:
  case ARM::STRH_PRE:
  // Halfword post-indexed
  case ARM::LDRH_POST:
  case ARM::LDRSH_POST:
  case ARM::STRH_POST:
  // Double-word
  case ARM::STRD: {
    assert(getAddressMode(MI) == ARMII::AddrMode3);
    bool preindex = getIndexMode(MI) == ARMII::IndexModePre;
    bool postindex = getIndexMode(MI) == ARMII::IndexModePost;
    assert(preindex || postindex || getIndexMode(MI) == ARMII::IndexModeNone);

    unsigned baseregopidx = 1;
    unsigned offsetregopidx = 2;
    unsigned immopidx = 3;

    if (preindex || postindex) {
      baseregopidx += 1;
      offsetregopidx += 1;
      immopidx += 1;
    }

    // Double word stuff has two data operands
    if (MI->getOpcode() == ARM::STRD) {
      baseregopidx += 1;
      offsetregopidx += 1;
      immopidx += 1;
    }

    assert(MI->getOperand(baseregopidx).isReg());
    assert(MI->getOperand(offsetregopidx).isReg());
    assert(MI->getOperand(immopidx).isImm());

    auto baseregnr = MI->getOperand(baseregopidx).getReg();
    auto offsetregnr = MI->getOperand(offsetregopidx).getReg();
    auto immval = MI->getOperand(immopidx).getImm();

    if (isTop(baseregnr)) {
      // We tracked down the symbol during analysis
      if (auto glvar = getSymbolFor(baseregnr)) {
        return AbstractAddress(glvar);
      }
      return extractGlobalDatastructure(MI);
    }

    unsigned addr = getValueFor(baseregnr);

    // Post-indexed loads use just the basereg as address
    if (postindex) {
      return AbstractAddress(addr);
    }

    // Offset value
    unsigned offset = 0;
    if (offsetregnr == 0) { // +/- imm8
      offset = ARM_AM::getAM3Offset(immval);
    } else { // +/- reg
      if (isTop(offsetregnr)) {
        // We tracked down the symbol during analysis
        if (auto glvar = getSymbolFor(baseregnr)) {
          return AbstractAddress(glvar);
        }
        // If not, let us try the mem-operand solution
        return extractGlobalDatastructure(MI);
      }
      offset = getValueFor(offsetregnr);
    }

    // Add or subtract offset
    if (ARM_AM::getAM3Op(immval) == ARM_AM::add) {
      addr += offset;
    } else {
      addr -= offset;
    }

    // Double word
    if (MI->getOpcode() == ARM::STRD) {
      assert(pos < 2 && "Position argument too high");
      addr += pos * 4;
    }

    return AbstractAddress(addr);
  }
  // Single and double word load for floating-point unit
  case ARM::VLDRS:
  case ARM::VSTRS:
  case ARM::VLDRD:
  case ARM::VSTRD: {
    assert(getAddressMode(MI) == ARMII::AddrMode5);
    assert(getIndexMode(MI) ==
           ARMII::IndexModeNone); // LLVM only supports immediate offset
    unsigned baseregopidx = 1;
    unsigned offsetopidx = 2;

    // We load something from our constantpool
    if (MI->getOperand(baseregopidx).isCPI()) {
      unsigned cpi = MI->getOperand(baseregopidx).getIndex();
      auto MF = MI->getParent()->getParent();
      unsigned cpeaddr = StaticAddrProvider->getConstPoolEntryAddr(MF, cpi);
      return AbstractAddress(cpeaddr);
    }

    // We have a register+offset memory access
    assert(MI->getOperand(baseregopidx).isReg() && "Load not from register");
    assert(MI->getOperand(offsetopidx).isImm() && "Load not immediate offset");

    // Base register
    auto baseregnr = MI->getOperand(baseregopidx).getReg();
    if (isTop(baseregnr)) {
      // We tracked down the symbol during analysis
      if (auto glvar = getSymbolFor(baseregnr)) {
        return AbstractAddress(glvar);
      }
      return extractGlobalDatastructure(MI);
    }
    unsigned address = getValueFor(baseregnr);

    // Immediate offset
    auto immval = MI->getOperand(offsetopidx).getImm();
    unsigned offset = ARM_AM::getAM5Offset(immval) * 4;
    if (ARM_AM::getAM5Op(immval) == ARM_AM::add) {
      address += offset;
    } else {
      address -= offset;
    }

    // Floating-point double loads two words
    if (MI->getOpcode() == ARM::VLDRD || MI->getOpcode() == ARM::VSTRD) {
      assert(pos < 2 && "Position argument too high");
      address += pos * 4;
    }
    return AbstractAddress(address);
  }
  // Load/Store multiple, all flavours
  case ARM::VLDMDIA:
  case ARM::VSTMDIA:
  case ARM::VLDMDIA_UPD:
  case ARM::VSTMDIA_UPD:
    ldstmdouble = 2;
    // fall-through
  case ARM::VLDMSIA:
  case ARM::VLDMSIA_UPD:
  case ARM::LDMIA:
  case ARM::STMIA:
  case ARM::LDMIA_UPD:
  case ARM::LDMIA_RET:
  case ARM::STMIA_UPD:
    if (ldstmdouble == 0) {
      ldstmdouble = 1;
    }
    ldstmsubmode = ARM_AM::ia;
    // fall-through
  case ARM::LDMIB:
  case ARM::STMIB:
  case ARM::LDMIB_UPD:
  case ARM::STMIB_UPD:
    if (ldstmdouble == 0) {
      ldstmdouble = 1;
    }
    if (ldstmsubmode == ARM_AM::bad_am_submode) {
      ldstmsubmode = ARM_AM::ib;
    }
    // fall-through
  case ARM::LDMDA:
  case ARM::STMDA:
  case ARM::LDMDA_UPD:
  case ARM::STMDA_UPD:
    if (ldstmdouble == 0) {
      ldstmdouble = 1;
    }
    if (ldstmsubmode == ARM_AM::bad_am_submode) {
      ldstmsubmode = ARM_AM::da;
    }
    // fall-through
  case ARM::VLDMDDB_UPD:
  case ARM::VSTMDDB_UPD:
    if (ldstmdouble == 0) {
      ldstmdouble = 2;
    }
    // fall-through
  case ARM::LDMDB:
  case ARM::STMDB:
  case ARM::LDMDB_UPD:
  case ARM::STMDB_UPD: {
    if (ldstmdouble == 0) {
      ldstmdouble = 1;
    }
    if (ldstmsubmode == ARM_AM::bad_am_submode) {
      ldstmsubmode = ARM_AM::db;
    }
    assert(ldstmdouble != 0);
    // pseudo instructions do not resolve to specific addres modes.
    assert(getAddressMode(MI) == ARMII::AddrMode4 || isPseudoInstruction(MI));
    // Base register
    assert(MI->getOperand(0).isReg());
    auto baseregnr = MI->getOperand(0).getReg();
    // Update base register ?
    unsigned numopreglist = 0;
    ;
    if (getIndexMode(MI) == ARMII::IndexModeUpd) {
      assert(MI->getOperand(1).getReg() == baseregnr && "Base regs differ");
      numopreglist = MI->getNumOperands() - 4;
    } else {
      assert(getIndexMode(MI) == ARMII::IndexModeNone);
      numopreglist = MI->getNumOperands() - 3;
    }
    // adjust for potential double ldm/stm
    numopreglist *= ldstmdouble;
    // Base register known ?
    if (isTop(baseregnr)) {
      break;
    }
    // Compute start address depending on submode
    auto startvalue = getValueFor(baseregnr);
    switch (ldstmsubmode) {
    case ARM_AM::ia:
      break;
    case ARM_AM::ib:
      startvalue += 4;
      break;
    case ARM_AM::da:
      startvalue = startvalue - 4 * numopreglist + 4;
      break;
    case ARM_AM::db:
      startvalue = startvalue - 4 * numopreglist;
      break;
    default:
      assert(0 && "Illegal ldstm submode");
    }
    // Calculate final address
    assert(pos < numopreglist && "Asking for more registers than in list");
    unsigned address = startvalue + pos * 4;
    return AbstractAddress(address);
  }
  default:
    break;
  }
  return AbstractAddress::getUnknownAddress();
}

template <>
void ConstantValueDomain<Triple::ArchType::arm>::transfer(
    const MachineInstr *MI, std::tuple<> &anaInfo) {
  assert(TimingAnalysisMain::getTargetMachine().getTargetTriple().getArch() ==
         Triple::ArchType::arm);

  if (this->bot) { // transfer on bot -> gives bot again
    return;
  }
  // Non-bottom update
  auto MRI = TimingAnalysisMain::getTargetMachine().getMCRegisterInfo();

  // Remember current analysis info
  ConstantValueDomain predecessorInfo(*this);

  /* If first instruction in function entry block (function start),
     try to figure out a mapping of function parameters to memory access symbols
   */
  if (MI->getParent()->getNumber() == 0) {
    if (MI == getFirstInstrInBB(MI->getParent())) {
      // Start of function, parameter map should be clear
      assert(fnparam2symbol.empty() &&
             "Expected the param to symbol mapping to be empty");
      auto func = MI->getParent()->getParent();
      auto &reginfo = func->getRegInfo();
      // Collect live in gpr registers
      std::set<unsigned> liveinregs;
      for (auto liveit = reginfo.livein_begin(); liveit != reginfo.livein_end();
           ++liveit) {
        if (ARM::GPRRegClass.contains(liveit->first)) {
          liveinregs.insert(liveit->first);
        }
      }
      // search the first BasicBlock for debug entries for a live in register
      for (auto &firstInstr : *(MI->getParent())) {
        if (firstInstr.getOpcode() == ARM::DBG_VALUE &&
            firstInstr.getNumExplicitOperands() == 4) {
          auto &op0 = firstInstr.getOperand(0);
          auto &op1 = firstInstr.getOperand(1);
          auto &op2 = firstInstr.getOperand(2);
          // We have a match for a live in register
          if (op0.isReg() && liveinregs.count(op0.getReg()) > 0 &&
              op1.isReg() && op1.getReg() == 0 && op2.isMetadata()) {
            assert(op2.getMetadata()->getNumOperands() == 4 &&
                   "Internal assumption about llvm metadata violated");
            auto metadata = op2.getMetadata()->getOperand(1).get();
            // Extract name of function parameter
            if (const MDString *argname = dyn_cast<MDString>(metadata)) {
              auto argstr = argname->getString().str();
              unsigned regnr = MRI->getEncodingValue(op0.getReg());
              // errs() << "We have an argument mapping: " << argstr << " to
              // register " << regnr << "\n";
              if (reg2symbol.count(regnr) > 0) {
                // errs() << "A global symbol is passed as argument: " <<
                // *reg2symbol.at(regnr) << "\n";
                fnparam2symbol[argstr] = reg2symbol.at(regnr);
              }
              liveinregs.erase(op0.getReg()); // Only consider first debug entry
            }
          }
        }
      }
    }
  }

  // Upon a call, we do not want to pass param->symbol mappings to the callee
  if (MI->isCall()) {
    fnparam2symbol.clear();
  }

  // TODO: More opcodes and should we care about values in memory?
  switch (MI->getOpcode()) {
  case ARM::LEApcrel: {
    assert(MI->getNumOperands() == 4 &&
           "Unexpected number of operands for LEApcrel");
    auto dest = MI->getOperand(0).getReg();
    auto destnr = MRI->getEncodingValue(dest);
    reg2symbol.erase(destnr);
    if (MI->getOperand(1).isCPI()) // We have a load from constant pool
    {
      auto MF = MI->getParent()->getParent();
      auto cpi = MI->getOperand(1).getIndex();
      unsigned cpeaddress = StaticAddrProvider->getConstPoolEntryAddr(MF, cpi);
      reg2const[destnr] = cpeaddress;
    } else {
      reg2const.erase(destnr);
    }
    break;
  }
  case ARM::MOVi: // Move immediate to register to register
  {
    auto dest = MI->getOperand(0).getReg();
    auto destnr = MRI->getEncodingValue(dest);
    auto imm = MI->getOperand(1).getImm();
    assert(destnr < 16 && "Destination register out of bounds");
    reg2const[destnr] = imm;
    reg2symbol.erase(destnr);
    break;
  }
  case ARM::MOVi16: {
    auto dest = MI->getOperand(0).getReg();
    auto destnr = MRI->getEncodingValue(dest);
    assert(destnr < 16 && "Destination register out of bounds");
    reg2symbol.erase(destnr);
    if (MI->getOperand(1).isImm()) {
      reg2const[destnr] = 0x0000ffff & MI->getOperand(1).getImm();
    } else if (MI->getOperand(1).isGlobal()) {
      if (const GlobalVariable *glvar =
              dyn_cast<const GlobalVariable>(MI->getOperand(1).getGlobal())) {
        if (StaticAddrProvider->hasGlobalVarAddress(glvar)) {
          reg2const[destnr] =
              0x0000ffff & StaticAddrProvider->getGlobalVarAddress(glvar);
        }
      }
    } else {
      reg2const.erase(destnr);
    }
    break;
  }
  case ARM::MOVTi16: {
    auto dest = MI->getOperand(0).getReg();
    auto destnr = MRI->getEncodingValue(dest);
    assert(destnr < 16 && "Destination register out of bounds");
    auto src = MI->getOperand(1).getReg();
    assert(src == dest &&
           "Movt expected to have same source and destination operand");
    reg2symbol.erase(destnr);
    if (MI->getOperand(2).isImm()) {
      if (reg2const.count(destnr) > 0) {
        reg2const[destnr] = ((0x0000ffff & MI->getOperand(2).getImm()) << 16) |
                            reg2const[destnr];
      }
    } else if (MI->getOperand(2).isGlobal()) {
      if (const GlobalVariable *glvar =
              dyn_cast<const GlobalVariable>(MI->getOperand(2).getGlobal())) {
        if (StaticAddrProvider->hasGlobalVarAddress(glvar)) {
          if (reg2const.count(destnr) > 0) {
            reg2const[destnr] =
                (0xffff0000 & StaticAddrProvider->getGlobalVarAddress(glvar)) |
                reg2const[destnr];
          }
        }
        reg2symbol[destnr] = glvar;
      }
    } else {
      reg2const.erase(destnr);
    }
    break;
  }
  case ARM::MVNi: // Move immediate to register after inversion
  {
    auto dest = MI->getOperand(0).getReg();
    auto destnr = MRI->getEncodingValue(dest);
    auto imm = MI->getOperand(1).getImm();
    uint32_t mask = 0xFFFFFFFF;
    assert(destnr < 16 && "Destination register out of bounds");
    reg2const[destnr] = imm ^ mask;
    reg2symbol.erase(destnr);
    break;
  }
  case ARM::MOVr: {
    auto dest = MI->getOperand(0).getReg();
    auto destnr = MRI->getEncodingValue(dest);
    auto src = MI->getOperand(1).getReg();
    auto srcnr = MRI->getEncodingValue(src);
    if (reg2const.count(srcnr) > 0) {
      reg2const[destnr] = reg2const[srcnr];
    } else {
      reg2const.erase(destnr);
    }
    if (reg2symbol.count(srcnr) > 0) {
      reg2symbol[destnr] = reg2symbol[srcnr];
    } else {
      reg2symbol.erase(destnr);
    }
    break;
  }
  case ARM::SUBri: {
    auto dest = MI->getOperand(0).getReg();
    auto destnr = MRI->getEncodingValue(dest);
    auto srcreg = MI->getOperand(1).getReg();
    auto srcregnr = MRI->getEncodingValue(srcreg);
    auto imm = MI->getOperand(2).getImm();
    if (reg2const.count(srcregnr) == 0)
      reg2const.erase(destnr);
    else
      reg2const[destnr] = reg2const[srcregnr] - imm;
    if (reg2symbol.count(srcregnr))
      reg2symbol[destnr] = reg2symbol[srcregnr];
    else
      reg2symbol.erase(destnr);
    break;
  }
  case ARM::ADDri: {
    auto dest = MI->getOperand(0).getReg();
    auto destnr = MRI->getEncodingValue(dest);
    auto srcreg = MI->getOperand(1).getReg();
    auto srcregnr = MRI->getEncodingValue(srcreg);
    auto imm = MI->getOperand(2).getImm();
    if (reg2const.count(srcregnr) == 0)
      reg2const.erase(destnr);
    else
      reg2const[destnr] = reg2const[srcregnr] + imm;
    if (reg2symbol.count(srcregnr))
      reg2symbol[destnr] = reg2symbol[srcregnr];
    else
      reg2symbol.erase(destnr);
    break;
  }
  case ARM::ADDrr: {
    auto destnr = MRI->getEncodingValue(MI->getOperand(0).getReg());
    auto srcregnr = MRI->getEncodingValue(MI->getOperand(1).getReg());
    auto src2regnr = MRI->getEncodingValue(MI->getOperand(2).getReg());
    reg2symbol.erase(destnr);
    if (reg2const.count(srcregnr) == 0 || reg2const.count(src2regnr) == 0)
      reg2const.erase(destnr);
    else
      reg2const[destnr] = reg2const.at(srcregnr) + reg2const.at(src2regnr);
    break;
  }
  case ARM::ADDrsi: {
    auto destnr = MRI->getEncodingValue(MI->getOperand(0).getReg());
    auto srcreg = MI->getOperand(1).getReg();
    auto srcregnr = MRI->getEncodingValue(srcreg);
    auto src2reg = MI->getOperand(2).getReg();
    auto src2regnr = MRI->getEncodingValue(src2reg);
    auto immd = MI->getOperand(3).getImm();
    assert(srcreg != 0 && src2reg != 0 && "Expected no noreg");
    reg2symbol.erase(destnr);
    if (reg2const.count(srcregnr) == 0 || reg2const.count(src2regnr) == 0) {
      reg2const.erase(destnr);
    } else {
      if (ARM_AM::getSORegShOp(immd) == ARM_AM::lsl) {
        auto rmval = reg2const.at(src2regnr);
        rmval = rmval << ARM_AM::getSORegOffset(immd);
        reg2const[destnr] = reg2const.at(srcregnr) + rmval;
      } else {
        reg2const.erase(destnr);
      }
    }
    break;
  }
  case ARM::BICri: {
    auto dest = MI->getOperand(0).getReg();
    auto destnr = MRI->getEncodingValue(dest);
    auto srcreg = MI->getOperand(1).getReg();
    auto srcregnr = MRI->getEncodingValue(srcreg);
    unsigned imm = MI->getOperand(2).getImm();
    reg2symbol.erase(destnr);
    if (reg2const.count(srcregnr) == 0)
      reg2const.erase(destnr);
    else
      reg2const[destnr] = reg2const[srcregnr] & (~imm);
    break;
  }
  case ARM::LDRi12:
  case ARM::LDRcp: {
    assert((MI->getOpcode() != ARM::LDRcp) || MI->getOperand(1).isCPI());
    auto dest = MI->getOperand(0).getReg();
    auto destnr = MRI->getEncodingValue(dest);
    reg2symbol.erase(destnr);
    if (MI->getOperand(1).isCPI()) // We have a load from constant pool
    {
      auto MF = MI->getParent()->getParent();
      auto cpi = MI->getOperand(1).getIndex();
      unsigned cpaddress = StaticAddrProvider->getConstPoolEntryAddr(MF, cpi);
      if (StaticAddrProvider->hasValueAtAddress(cpaddress)) {
        reg2const[destnr] = StaticAddrProvider->getValueAtAddress(cpaddress);
      }
      if (auto glvar = StaticAddrProvider->getSymbolAtAddress(cpaddress)) {
        reg2symbol[destnr] = glvar;
      }
      break;
    } else if (MI->getOperand(1).isReg()) {
      AbstractAddress addr = getDataAccessAddress(MI, 0);
      if (addr.isPrecise()) {
        unsigned concreteAddr = addr.getAsInterval().lower();
        if (StaticAddrProvider->hasValueAtAddress(concreteAddr)) {
          reg2const[destnr] =
              StaticAddrProvider->getValueAtAddress(concreteAddr);
          break;
        }

        if (addr2symbol.count(concreteAddr) > 0) {
          reg2symbol[destnr] = addr2symbol.at(concreteAddr);
        }
        if (addr2const.count(concreteAddr) > 0) {
          reg2const[destnr] = addr2const.at(concreteAddr);
          break;
        }
      }
    }
    reg2const.erase(destnr);
    break;
  }
  case ARM::STRi12: {
    AbstractAddress addr = getDataAccessAddress(MI, 0);
    if (addr.isPrecise()) {
      // Exact address
      unsigned concreteAddr = addr.getAsInterval().lower();
      auto src = MI->getOperand(0).getReg();
      auto srcnr = MRI->getEncodingValue(src);

      // We know value to store
      int *valptr = reg2const.count(srcnr) > 0 ? &reg2const.at(srcnr) : nullptr;
      auto sym = reg2symbol.count(srcnr) > 0 ? reg2symbol.at(srcnr) : nullptr;
      performStoreValue(MI, concreteAddr, valptr, sym);
    } else {
      // Unknown address
      performStoreUnknownAddress(addr);
    }
    break;
  }
  case ARM::STMDB_UPD: {
    auto rn = MRI->getEncodingValue(MI->getOperand(0).getReg());
    auto base = MRI->getEncodingValue(MI->getOperand(1).getReg());
    assert((rn == base) && "Base registers differ");

    // Try to save stuff in address part of analysis information
    for (unsigned it = 4; it < MI->getNumOperands(); ++it) {
      AbstractAddress addr = getDataAccessAddress(MI, it - 4);
      if (addr.isPrecise()) {
        unsigned concreteAddr = addr.getAsInterval().lower();
        auto srcnr = MRI->getEncodingValue(MI->getOperand(it).getReg());
        // Store known value
        int *valptr =
            reg2const.count(srcnr) > 0 ? &reg2const.at(srcnr) : nullptr;
        auto sym = reg2symbol.count(srcnr) > 0 ? reg2symbol.at(srcnr) : nullptr;
        performStoreValue(MI, concreteAddr, valptr, sym);
      } else {
        performStoreUnknownAddress(addr);
        break; // Once everything is cleaned, leave the loop
      }
    }

    unsigned number = MI->getNumOperands() - 4;
    if (reg2const.count(base) > 0) {
      reg2const[base] = reg2const[base] - 4 * number;
    }
    reg2symbol.erase(base);
    break;
  }
  case ARM::VSTMDDB_UPD: {
    auto rn = MRI->getEncodingValue(MI->getOperand(0).getReg());
    auto base = MRI->getEncodingValue(MI->getOperand(1).getReg());
    assert((rn == base) && "Base registers differ");

    // Stores to double precision fp registers (do not care here)

    // Update the base register
    unsigned number = MI->getNumOperands() - 4;
    if (reg2const.count(base) > 0) {
      reg2const[base] =
          reg2const[base] - 4 /* byte-addressable */ * 2 /* double */ * number;
    }
    reg2symbol.erase(base);
    break;
  }
  case ARM::LDMIA_UPD:
  case ARM::LDMIA_RET: {
    auto rn = MRI->getEncodingValue(MI->getOperand(0).getReg());
    auto base = MRI->getEncodingValue(MI->getOperand(1).getReg());
    assert((rn == base) && "Base registers differ");

    // Try to gain stuff from address part of analysis information
    for (unsigned it = 4; it < MI->getNumOperands(); ++it) {
      assert(MI->getOperand(it).isReg());
      // LDMIA_RET last Operand is implicit killed, like BX_RET
      // and has no effect on const values
      if (MI->getOpcode() == ARM::LDMIA_RET) {
        break;
      }
      assert(MI->getOperand(it).isDef());
      auto destnr = MRI->getEncodingValue(MI->getOperand(it).getReg());
      assert(destnr != base && "Cannot load into indexed base register");
      reg2symbol.erase(destnr);
      reg2const.erase(destnr);
      AbstractAddress addr = getDataAccessAddress(MI, it - 4);
      if (addr.isPrecise()) {
        if (addr2const.count(addr.getAsInterval().lower()) > 0) {
          reg2const[destnr] = addr2const[addr.getAsInterval().lower()];
        }
        if (addr2symbol.count(addr.getAsInterval().lower()) > 0) {
          reg2symbol[destnr] = addr2symbol[addr.getAsInterval().lower()];
        }
      }
    }

    unsigned number = MI->getNumOperands() - 4;
    if (reg2const.count(base) > 0) {
      reg2const[base] = reg2const[base] + 4 * number;
    }
    reg2symbol.erase(base);
    break;
  }
  case ARM::VLDMDIA_UPD:
  case ARM::VLDMSIA_UPD: {
    auto rn = MRI->getEncodingValue(MI->getOperand(0).getReg());
    auto base = MRI->getEncodingValue(MI->getOperand(1).getReg());
    assert((rn == base) && "Base registers differ");

    // Load to double/single precision fp registers (do not care here)
    unsigned multdouble = (MI->getOpcode() == ARM::VLDMDIA_UPD) ? 2 : 1;

    // Update the base register
    unsigned number = MI->getNumOperands() - 4;
    if (reg2const.count(base) > 0) {
      reg2const[base] = reg2const[base] + 4 /* byte-addressable */ *
                                              multdouble /* double */ * number;
    }
    reg2symbol.erase(base);
    break;
  }
  case ARM::STR_PRE_IMM: {
    // Update the memory->data mapping
    AbstractAddress addr = getDataAccessAddress(MI, 0);
    if (addr.isPrecise()) {
      performStoreUnknownValue(addr.getAsInterval().lower());
    } else {
      performStoreUnknownAddress(addr);
    }
    // Update address base register
    auto addressreg = MI->getOperand(0).getReg();
    assert(addressreg == MI->getOperand(2).getReg() &&
           "Base address register differs");
    auto offset = MI->getOperand(3).getImm();
    auto destnr = MRI->getEncodingValue(addressreg);
    if (reg2const.count(destnr) > 0) {
      reg2const[destnr] = reg2const[destnr] + offset;
    }
    reg2symbol.erase(destnr);
    break;
  }
  case ARM::LDR_POST_IMM: {
    auto addressreg = MI->getOperand(1).getReg();
    assert(addressreg == MI->getOperand(2).getReg() &&
           "Base address register differs");
    auto offset = MI->getOperand(4).getImm();
    assert(MI->getOperand(3).getReg() == 0 &&
           "We do only support noreg for ldr_post_imm");
    auto base = MRI->getEncodingValue(addressreg);
    if (reg2const.count(base) > 0) {
      reg2const[base] = reg2const[base] + offset;
    }
    // Symbol kept

    // Delete information about destination location
    auto destnr = MRI->getEncodingValue(MI->getOperand(0).getReg());
    assert(destnr != base && "Cannot load into indexed base register");
    reg2symbol.erase(destnr);
    reg2const.erase(destnr);
    break;
  }
  case ARM::LDR_PRE_IMM: {
    auto addressreg = MI->getOperand(1).getReg();
    assert(addressreg == MI->getOperand(2).getReg() &&
           "Base address register differs");
    auto offset = MI->getOperand(3).getImm();
    auto base = MRI->getEncodingValue(addressreg);
    if (reg2const.count(base) > 0) {
      reg2const[base] = reg2const[base] + offset;
    }
    // Symbol kept

    // Delete information about destination location
    auto destnr = MRI->getEncodingValue(MI->getOperand(0).getReg());
    assert(destnr != base && "Cannot load into indexed base register");
    reg2symbol.erase(destnr);
    reg2const.erase(destnr);
    break;
  }
  case ARM::BL:
  case ARM::BL_pred: {
    reg2const.erase(14); // LR is set to address of next instruction, does not
                         // matter for us...
    reg2symbol.erase(14);
    // Stack pointer is only implicitly modified by called function, do not
    // modify here...
    break;
  }
    /*		case ARM::MOVsi: // Move register to register with immediate shift
       (bit[11..7] shift_imm, bit[6..5] shift, bit[4] 0, bit[3..0] Rm case
       ARM::MOVsr: // Move register to register with register shift (bit[11.8]
       Rs, bit[7] 0, bit[6..5] shift, bit[4] 1, bit[3..0] Rm

                    // No effect on constants
                    case ARM::CMPri:
                    case ARM::Bcc:
                    case ARM::B:
                    case ARM::BX_RET:*/

  default: {
    if (MI->mayStore()) {
      auto numAcc = AddressInformation::getNumOfDataAccesses(MI);
      for (unsigned pos = 0; pos < numAcc; ++pos) {
        AbstractAddress addr = getDataAccessAddress(MI, pos);
        if (addr.isPrecise()) {
          performStoreUnknownValue(addr.getAsInterval().lower());
        } else {
          performStoreUnknownAddress(addr);
          break; // If cleared, then nothing needs to be done in this loop
        }
      }
    }
    // Invalidate the results we have for all the registers that are freshly
    // defined here.
    for (unsigned o = 0; o < MI->getNumOperands(); ++o) {
      auto operand = MI->getOperand(o);
      if (operand.isReg() && operand.isDef()) {
        // We only care about general-purpose registers
        // There are also other register sets (e.g. CCR for CPSR etc, and SPR,
        // DPR for floating point) See also file:
        // llvm/lib/Target/ARM/ARMRegisterInfo.td
        if (ARM::GPRRegClass.contains(operand.getReg())) {
          auto destnr = MRI->getEncodingValue(operand.getReg());
          reg2const.erase(destnr);
          reg2symbol.erase(destnr);
        }
      }
    }
    DEBUG_WITH_TYPE(
        ConstantValueDomain::analysisName("").c_str(),
        dbgs() << "[Warning] Instruction " << getMachineInstrIdentifier(MI)
               << " uses implicit transfer function => imprecision\n"
               << *MI);
    break;
  }
  }

  /**
   * If the instruction is predicated, account for that nothing might had
   * happened.
   */
  int PIdx = MI->findFirstPredOperandIdx();
  bool predicated = (PIdx != -1 && MI->getOperand(PIdx).getImm() != ARMCC::AL);
  if (predicated) {
    this->join(predecessorInfo);
  }
}

template <>
void ConstantValueDomain<Triple::ArchType::arm>::handleCallingConvention(
    const ConstantValueDomain &preCallElement) {
  if (this->bot) { // bottom, cannot sharpen this information
    return;
  }
  assert(!this->bot && "Cannot handle calling convention for unreachable call");
  // Keep analysis information for callee-save registers. I.e. for ARM: r4-r8,
  // r10-r11, and SP (r13), and for calling convention used here
  // (Tag_ABI_PCS_R9_use) also r9
  for (unsigned regnr = 4; regnr <= 13; ++regnr) {
    if (regnr == 12)
      continue;
    if (preCallElement.reg2const.count(regnr) >
        0) { // We have information pre-call
      this->reg2const[regnr] = preCallElement.reg2const.find(regnr)
                                   ->second; // insert or changed info
    }
    if (preCallElement.reg2symbol.count(regnr) >
        0) { // We have information pre-call
      this->reg2symbol[regnr] = preCallElement.reg2symbol.at(regnr);
    }
  }

  // Slots added during the call, are now no spill slots any more and should not
  // be protected
  this->aliasfreeSlots = preCallElement.aliasfreeSlots;
  // For all alias-free slots, we can use the values before the call
  for (auto &a2v : preCallElement.addr2const) {
    if (preCallElement.aliasfreeSlots.count(a2v.first) > 0) {
      /* At fixed-point, the following assert should hold. However, during
      iteration, due to low context-sensitivity, it might happen that the
      constraint does not hold yet. assert ((this->addr2const.count(a2v.first)
      == 0 || this->addr2const.at(a2v.first) == a2v.second)
              && "Disagreeing values for memory location, someone changed
      alias-free slots.");*/
      this->addr2const[a2v.first] = a2v.second;
    }
  }
  for (auto &a2v : preCallElement.addr2symbol) {
    if (preCallElement.aliasfreeSlots.count(a2v.first) > 0) {
      this->addr2symbol[a2v.first] = a2v.second;
    }
  }
  // Upon function call, keep the param to symbol mapping from inside this
  // function
  this->fnparam2symbol = preCallElement.fnparam2symbol;
}

template class ConstantValueDomain<Triple::ArchType::arm>;

} // namespace TimingAnalysisPass
