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

#include "RISCV.h"

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

template <>
AbstractAddress
ConstantValueDomain<Triple::ArchType::riscv32>::getDataAccessAddress(
    const MachineInstr *MI, unsigned pos) const {
  assert(!(MI->mayLoad() && MI->mayStore()) &&
         "Cannot load and store at same time");

  if (isBottom()) {
    // empty interval
    return AbstractAddress(AddressInterval(1, 0));
  }

  DEBUG_WITH_TYPE("addrinfo", errs() << *MI);
  switch (MI->getOpcode()) {
  case RISCV::FLW:
  case RISCV::FSW:
  case RISCV::FLD:
  case RISCV::FSD:
  case RISCV::LW:
  case RISCV::SW: {
    assert(MI->getOperand(1).isReg());
    assert(MI->getOperand(2).isImm() || MI->getOperand(2).isGlobal());

    // Base register
    auto baseregnr = MI->getOperand(1).getReg();
    if (isTop(baseregnr)) {
      if (auto glvar = getSymbolFor(baseregnr)) {
        return AbstractAddress(glvar);
      }
      return extractGlobalDatastructure(MI);
    }
    unsigned address = getValueFor(baseregnr);

    // Immediate offset
    if (MI->getOperand(2).isImm()) {
      int32_t offset = MI->getOperand(2).getImm();
      address += offset;
    } else {
      const GlobalVariable *glvar =
          dyn_cast<const GlobalVariable>(MI->getOperand(2).getGlobal());
      if (glvar && StaticAddrProvider->hasGlobalVarAddress(glvar)) {
        address +=
            (0x00000fff & StaticAddrProvider->getGlobalVarAddress(glvar));
        assert(address == StaticAddrProvider->getGlobalVarAddress(glvar) &&
               "unexpected");
      } else {
        break;
      }
    }

    assert(pos == 0 || MI->getOpcode() == RISCV::FLD ||
           MI->getOpcode() == RISCV::FSD);
    address += pos * 4;

    return AbstractAddress(address);
  }
  default:
    break;
  }
  return AbstractAddress::getUnknownAddress();
}

void performBinaryOperation(
    const MachineInstr *MI, std::map<unsigned, int> &reg2const,
    std::map<unsigned, const GlobalVariable *> &reg2symbol,
    std::function<int(int, int)> binop) {
  auto MRI = TimingAnalysisMain::getTargetMachine().getMCRegisterInfo();

  auto dest = MI->getOperand(0).getReg();
  auto destnr = MRI->getEncodingValue(dest);
  auto srcreg = MI->getOperand(1).getReg();
  auto srcregnr = MRI->getEncodingValue(srcreg);
  auto src2reg = MI->getOperand(2).getReg();
  auto src2regnr = MRI->getEncodingValue(src2reg);

  if (reg2symbol.count(srcregnr) || reg2symbol.count(src2regnr)) {
    assert((!(reg2symbol.count(srcregnr) && reg2symbol.count(src2regnr)) ||
            (MI->getOpcode() == RISCV::SUB &&
             reg2symbol.at(srcregnr) == reg2symbol.at(src2regnr))) &&
           "Cannot combine two differing symbols");
    reg2symbol[destnr] = reg2symbol.count(srcregnr) ? reg2symbol.at(srcregnr)
                                                    : reg2symbol.at(src2regnr);
  } else {
    reg2symbol.erase(destnr);
  }

  if (reg2const.count(srcregnr) && reg2const.count(src2regnr)) {
    reg2const[destnr] = binop(reg2const.at(srcregnr), reg2const.at(src2regnr));
  } else {
    reg2const.erase(destnr);
  }
}

template <>
void ConstantValueDomain<Triple::ArchType::riscv32>::transfer(
    const MachineInstr *MI, std::tuple<> &anaInfo) {
  assert(TimingAnalysisMain::getTargetMachine().getTargetTriple().getArch() ==
         Triple::ArchType::riscv32);

  if (this->bot) { // transfer on bot -> gives bot again
    return;
  }

  assert(reg2const[0] == 0 && "Someone wrote to register 0");

  // Non-bottom update
  auto MRI = TimingAnalysisMain::getTargetMachine().getMCRegisterInfo();

  switch (MI->getOpcode()) {
  case RISCV::LUI: {
    auto dest = MI->getOperand(0).getReg();
    auto destnr = MRI->getEncodingValue(dest);
    assert(destnr < 32 && "Destination register out of bounds");
    reg2symbol.erase(destnr);
    if (MI->getOperand(1).isImm()) {
      reg2const[destnr] = (0x000fffff & MI->getOperand(1).getImm()) << 12;
    } else if (MI->getOperand(1).isGlobal()) {
      if (const GlobalVariable *glvar =
              dyn_cast<const GlobalVariable>(MI->getOperand(1).getGlobal())) {
        if (StaticAddrProvider->hasGlobalVarAddress(glvar)) {
          reg2const[destnr] =
              0xfffff000 & StaticAddrProvider->getGlobalVarAddress(glvar);
        }
        reg2symbol[destnr] = glvar;
      }
    } else if (MI->getOperand(1).isCPI()) {
      unsigned cpi = MI->getOperand(1).getIndex();
      auto MF = MI->getParent()->getParent();
      unsigned cpeaddress = StaticAddrProvider->getConstPoolEntryAddr(MF, cpi);
      reg2const[destnr] = (cpeaddress & 0xfffff000);
    } else {
      reg2const.erase(destnr);
      assert(0 && "unexpected");
    }
    break;
  }
  case RISCV::ADDI: {
    auto dest = MI->getOperand(0).getReg();
    auto destnr = MRI->getEncodingValue(dest);
    auto srcreg = MI->getOperand(1).getReg();
    auto srcregnr = MRI->getEncodingValue(srcreg);
    if (MI->getOperand(2).isImm()) {
      auto imm = MI->getOperand(2).getImm();
      if (reg2const.count(srcregnr))
        reg2const[destnr] = reg2const[srcregnr] + imm;
      else
        reg2const.erase(destnr);
      if (reg2symbol.count(srcregnr))
        reg2symbol[destnr] = reg2symbol[srcregnr];
      else
        reg2symbol.erase(destnr);
    } else if (MI->getOperand(2).isGlobal()) {
      if (const GlobalVariable *glvar =
              dyn_cast<const GlobalVariable>(MI->getOperand(2).getGlobal())) {
        if (StaticAddrProvider->hasGlobalVarAddress(glvar)) {
          if (reg2const.count(srcregnr)) {
            reg2const[destnr] =
                reg2const[srcregnr] +
                (0x00000fff & StaticAddrProvider->getGlobalVarAddress(glvar));
          } else {
            reg2const.erase(destnr);
          }
          if (reg2symbol.count(srcregnr)) {
            assert((destnr != srcregnr || reg2symbol.at(srcregnr) == glvar) &&
                   "Internal assumption");
            reg2symbol[destnr] = reg2symbol.at(srcregnr);
          } else {
            reg2symbol.erase(destnr);
          }
        } else {
          reg2const.erase(destnr);
          reg2symbol.erase(destnr);
        }
      }
    } else if (MI->getOperand(2).isCPI()) {
      reg2symbol.erase(destnr);
      unsigned cpi = MI->getOperand(2).getIndex();
      auto MF = MI->getParent()->getParent();
      unsigned cpeaddress = StaticAddrProvider->getConstPoolEntryAddr(MF, cpi);
      if (reg2const.count(srcregnr)) {
        reg2const[destnr] = reg2const[srcregnr] + (cpeaddress & 0x00000fff);
        assert(reg2const[destnr] == (int)cpeaddress &&
               "Internal assumption about loading constant violated");
      } else {
        assert(0 && "Unexpected fail to load constant");
      }
    } else {
      reg2const.erase(destnr);
      reg2symbol.erase(destnr);
      assert(0 && "unexpected");
    }
    break;
  }
  case RISCV::ADD: {
    performBinaryOperation(MI, this->reg2const, this->reg2symbol,
                           [](int a, int b) -> int { return a + b; });
    break;
  }
  case RISCV::SUB: {
    performBinaryOperation(MI, this->reg2const, this->reg2symbol,
                           [](int a, int b) -> int { return a - b; });
    break;
  }
  case RISCV::LW: {
    auto dest = MI->getOperand(0).getReg();
    auto destnr = MRI->getEncodingValue(dest);
    assert(MI->getOperand(1).isReg() &&
           (MI->getOperand(2).isImm() || MI->getOperand(2).isGlobal()) &&
           "unexpected");
    AbstractAddress addr = getDataAccessAddress(MI, 0);

    reg2symbol.erase(destnr);
    reg2const.erase(destnr);

    if (addr.isPrecise()) {
      unsigned concreteAddr = addr.getAsInterval().lower();
      if (StaticAddrProvider->hasValueAtAddress(concreteAddr)) {
        reg2const[destnr] = StaticAddrProvider->getValueAtAddress(concreteAddr);
        break;
      }
      if (addr2symbol.count(concreteAddr) > 0) {
        reg2symbol[destnr] = addr2symbol.at(concreteAddr);
      }
      if (addr2const.count(concreteAddr) > 0) {
        reg2const[destnr] = addr2const.at(concreteAddr);
      }
    }
    break;
  }
  case RISCV::SW: {
    assert(MI->getOperand(1).isReg() &&
           (MI->getOperand(2).isImm() || MI->getOperand(2).isGlobal()) &&
           "unexpected");
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
  case RISCV::PseudoCALL: {
    reg2const.erase(1); // $ra is set to address of next instruction, does not
                        // matter for us...
    reg2symbol.erase(1);
    // Argument and stack pointer is only implicitly modified by called
    // function, do not modify here...
    break;
  }
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
        if (GPRegClass.contains(operand.getReg())) {
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
}

template <>
void ConstantValueDomain<Triple::ArchType::riscv32>::handleCallingConvention(
    const ConstantValueDomain &preCallElement) {
  if (this->bot) { // bottom, cannot sharpen this information
    return;
  }
  assert(!this->bot && "Cannot handle calling convention for unreachable call");
  // Keep analysis information for callee-save registers. I.e. for RISC-V 8,9,
  // 18-27
  for (unsigned regnr = 8; regnr <= 27; ++regnr) {
    if (10 <= regnr && regnr <= 17)
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

template class ConstantValueDomain<Triple::ArchType::riscv32>;

} // namespace TimingAnalysisPass
