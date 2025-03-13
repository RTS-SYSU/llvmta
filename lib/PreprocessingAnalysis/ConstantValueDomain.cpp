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

#include "PreprocessingAnalysis/ConstantValueDomain.h"

#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/TargetInstrInfo.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Module.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "llvm/Target/TargetMachine.h"

#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineMemOperand.h"
#include "llvm/CodeGen/PseudoSourceValue.h"

#include "LLVMPasses/TimingAnalysisMain.h"
#include "PreprocessingAnalysis/AddressInformation.h"

#include <sstream>

using namespace llvm;

namespace TimingAnalysisPass {

template <Triple::ArchType ISA>
ConstantValueDomain<ISA>::ConstantValueDomain(AnaDomInit init)
    : bot(init == AnaDomInit::BOTTOM) {
  if (init == AnaDomInit::START) { // start: we have additional knowledge about
                                   // stackpointer
    // Zero register
    if (ISA == Triple::ArchType::riscv32) {
      this->reg2const.insert(std::make_pair(0, 0));
    }
    // The initial stack pointer is known, so set it.
    this->reg2const.insert(
        std::make_pair(stackPointerRegister, getInitialStackPointer()));
    for (auto &glvar : StaticAddrProvider->getGlobalVariables()) {
      auto initial = StaticAddrProvider->getGlobalVariableInitialValue(glvar);
      auto addr = StaticAddrProvider->getGlobalVarAddress(glvar);
      if (initial) {
        addr2const.insert(std::make_pair(addr, initial.get()));
      }
    }
  }
}

template <Triple::ArchType ISA>
ConstantValueDomain<ISA>::ConstantValueDomain(const ConstantValueDomain &cvd)
    : bot(cvd.bot), reg2const(cvd.reg2const), addr2const(cvd.addr2const),
      reg2symbol(cvd.reg2symbol), addr2symbol(cvd.addr2symbol),
      fnparam2symbol(cvd.fnparam2symbol), aliasfreeSlots(cvd.aliasfreeSlots) {}

template <Triple::ArchType ISA>
ConstantValueDomain<ISA> &
ConstantValueDomain<ISA>::operator=(const ConstantValueDomain &other) {
  this->bot = other.bot;
  this->reg2const = other.reg2const;
  this->addr2const = other.addr2const;
  this->reg2symbol = other.reg2symbol;
  this->addr2symbol = other.addr2symbol;
  this->fnparam2symbol = other.fnparam2symbol;
  this->aliasfreeSlots = other.aliasfreeSlots;
  return *this;
}

template <Triple::ArchType ISA>
void ConstantValueDomain<ISA>::join(const ConstantValueDomain &element) {
  if (element.bot) { // Join with bottom
    return;
  }
  if (this->bot) { // we are bottom and join with non-bottom, init the map and
                   // copy
    this->bot = false;
    this->reg2const = element.reg2const;
    this->reg2symbol = element.reg2symbol;
    this->addr2const = element.addr2const;
    this->addr2symbol = element.addr2symbol;
    this->fnparam2symbol = element.fnparam2symbol;
    this->aliasfreeSlots = element.aliasfreeSlots;
    return;
  }
  assert(!bot && !element.bot && "Missed join with bottom");

#ifndef NDEBUG
  // Only needed in assertion
  ConstantValueDomain oldthis(*this);
#endif

  // normal join, intersect the reg->const mappings
  for (auto r2cit = this->reg2const.begin(); r2cit != this->reg2const.end();) {
    unsigned regnr = r2cit->first;
    if (element.reg2const.count(regnr) == 0 ||
        element.reg2const.at(regnr) != r2cit->second) {
      r2cit = this->reg2const.erase(r2cit);
    } else {
      ++r2cit;
    }
  }
  for (auto r2sit = this->reg2symbol.begin();
       r2sit != this->reg2symbol.end();) {
    unsigned regnr = r2sit->first;
    if (element.reg2symbol.count(regnr) == 0 ||
        element.reg2symbol.at(regnr) != r2sit->second) {
      r2sit = this->reg2symbol.erase(r2sit);
    } else {
      ++r2sit;
    }
  }

  // Only keep addr->const pairs that agree in both analysis domain elements
  for (auto a2cit = this->addr2const.begin();
       a2cit != this->addr2const.end();) {
    Address addr = a2cit->first;
    if (element.addr2const.count(addr) == 0 ||
        a2cit->second != element.addr2const.at(addr)) {
      a2cit = this->addr2const.erase(a2cit);
    } else {
      ++a2cit;
    }
  }
  for (auto a2sit = this->addr2symbol.begin();
       a2sit != this->addr2symbol.end();) {
    Address addr = a2sit->first;
    if (element.addr2symbol.count(addr) == 0 ||
        a2sit->second != element.addr2symbol.at(addr)) {
      a2sit = this->addr2symbol.erase(a2sit);
    } else {
      ++a2sit;
    }
  }

  // Take intersection of fnparam2symbol: Within a function, this is not
  // expected to change, but if ctx-sensitivity is low multiple callsites might
  // get merged and we lose information.
  for (auto p2sit = this->fnparam2symbol.begin();
       p2sit != this->fnparam2symbol.end();) {
    auto pname = p2sit->first;
    if (element.fnparam2symbol.count(pname) == 0 ||
        element.fnparam2symbol.at(pname) != p2sit->second) {
      p2sit = this->fnparam2symbol.erase(p2sit);
    } else {
      ++p2sit;
    }
  }

  // Compute intersection of the alias-free slots
  for (auto afsit = this->aliasfreeSlots.begin();
       afsit != this->aliasfreeSlots.end();) {
    if (element.aliasfreeSlots.count(*afsit)) {
      ++afsit;
    } else {
      afsit = this->aliasfreeSlots.erase(afsit);
    }
  }

  // Consistency of join and lessequal
  assert(element.lessequal(*this) && "Expected x lessequal x join y");
  assert(oldthis.lessequal(*this) && "Expected y lessequal x join y");

  static bool emitted_warning;
  if (!emitted_warning && reg2const.count(stackPointerRegister) == 0) {
    std::cerr << "[WARNING] lost stack pointer in a join - consider increasing "
                 "context sensitivity\n";
    emitted_warning = true;
  }
}

template <Triple::ArchType ISA>
bool ConstantValueDomain<ISA>::lessequal(
    const ConstantValueDomain &element) const {
  if (this->bot) // this bottom
    return true;
  if (element.bot) // this not bottom, but element bottom
    return false;

  for (unsigned regnr = 0; regnr < numOfRegisters; ++regnr) {
    if (element.reg2const.count(regnr) == 0) // ? <= top
      continue;
    if (this->reg2const.count(regnr) == 0) // top <= z -> false
      return false;
    if (this->reg2const.find(regnr)->second !=
        element.reg2const.find(regnr)->second) // unequal
      return false;
  }
  // Is this reg2symbol strictly included in element's reg2symbol, it cannot be
  // lessequal.
  if (!std::includes(this->reg2symbol.begin(), this->reg2symbol.end(),
                     element.reg2symbol.begin(), element.reg2symbol.end())) {
    return false;
  }
  for (auto &a2c : element.addr2const) {
    if (addr2const.count(a2c.first) > 0) {
      if (addr2const.at(a2c.first) != a2c.second) {
        return false;
      }
    } else {
      return false;
    }
  }
  // Is this addr2symbol strictly included in element's addr2symbol, it cannot
  // be lessequal.
  if (!std::includes(this->addr2symbol.begin(), this->addr2symbol.end(),
                     element.addr2symbol.begin(), element.addr2symbol.end())) {
    return false;
  }
  // Is this fnparam2symbol strictly included in element's fnparam2symbol, it
  // cannot be lessequal
  if (!std::includes(this->fnparam2symbol.begin(), this->fnparam2symbol.end(),
                     element.fnparam2symbol.begin(),
                     element.fnparam2symbol.end())) {
    return false;
  }
  // this->aliasfreeSlots are superset of element.aliasfreeSlots
  return std::includes(this->aliasfreeSlots.begin(), this->aliasfreeSlots.end(),
                       element.aliasfreeSlots.begin(),
                       element.aliasfreeSlots.end());
}

template <Triple::ArchType ISA>
std::string ConstantValueDomain<ISA>::print() const {
  if (this->bot)
    return "bot";
  std::stringstream ss;
  ss << "[";
  for (unsigned regnr = 0; regnr < numOfRegisters; ++regnr) {
    ss << regnr << " |-> ";
    if (reg2const.count(regnr) == 0) {
      ss << "top";
    } else {
      printHex(ss, reg2const.find(regnr)->second);
    }
    if (reg2symbol.count(regnr) > 0) {
      ss << ", @" << reg2symbol.at(regnr)->getName().str();
    }
    if (regnr < numOfRegisters - 1)
      ss << ",\n ";
  }
  ss << "]\n";
  ss << "{";
  for (auto &a2c : addr2const) {
    printHex(ss, a2c.first);
    ss << " |-> ";
    printHex(ss, a2c.second);
    if (addr2symbol.count(a2c.first) > 0) {
      ss << ", @" << addr2symbol.at(a2c.first)->getName().str();
    }
    ss << "\n";
  }
  // Print those addr to symbol mappings that are not covered by addr to const
  // yet
  for (auto &a2s : addr2symbol) {
    if (addr2const.count(a2s.first) == 0) {
      printHex(ss, a2s.first);
      ss << " |-> top, @" << a2s.second->getName().str() << "\n";
    }
  }
  ss << "}";
  // Output set of guaranteed alias-free slots
  /*	ss << "\n{\n";
          bool emitComma = false;
          for (auto& afss : aliasfreeSlots) {
                  if (emitComma) {
                          ss << ", ";
                  }
                  printHex(ss, afss);
                  emitComma = true;
          }
          ss << "}";*/
  /*ss << "\n[\n";
  for (auto& p2s : fnparam2symbol) {
          ss << p2s.first << " |-> @" << p2s.second->getName().str() << "\n";
  }
  ss << "]";*/
  return ss.str();
}

template <Triple::ArchType ISA>
bool ConstantValueDomain<ISA>::isBottom() const {
  return this->bot;
}

template <Triple::ArchType ISA>
bool ConstantValueDomain<ISA>::isTop(unsigned regnr) const {
  if (GPRegClass.contains(regnr)) {
    auto MRI = TimingAnalysisMain::getTargetMachine().getMCRegisterInfo();
    auto ownregnr = MRI->getEncodingValue(regnr);
    assert(!isBottom() && "No register information for bottom value");
    return reg2const.count(ownregnr) == 0;
  } else {
    return true;
  }
}

template <Triple::ArchType ISA>
int ConstantValueDomain<ISA>::getValueFor(unsigned regnr) const {
  assert(!isBottom() && !isTop(regnr) && "Do not have value for this register");
  auto MRI = TimingAnalysisMain::getTargetMachine().getMCRegisterInfo();
  auto ownregnr = MRI->getEncodingValue(regnr);
  return reg2const.at(ownregnr);
}

template <Triple::ArchType ISA>
const typename ConstantValueDomain<ISA>::MemoryAccessSymbol *
ConstantValueDomain<ISA>::getSymbolFor(unsigned regnr) const {
  if (GPRegClass.contains(regnr)) {
    auto MRI = TimingAnalysisMain::getTargetMachine().getMCRegisterInfo();
    auto realregnr = MRI->getEncodingValue(regnr);
    if (reg2symbol.count(realregnr) > 0) {
      //			assert (!isTop(regnr) && "Should not have symbol
      //for this register");
      return reg2symbol.at(realregnr);
    } else {
      return nullptr;
    }
  } else {
    return nullptr;
  }
}

template <Triple::ArchType ISA>
void ConstantValueDomain<ISA>::performStoreValue(
    const MachineInstr *MI, Address addr, int *valptr,
    const MemoryAccessSymbol *sym) {
  if (valptr) {
    addr2const[addr] = *valptr;
  } else {
    addr2const.erase(addr);
  }

  if (sym) {
    addr2symbol[addr] = sym;
  } else {
    addr2symbol.erase(addr);
  }

  if (valptr || sym) {
    assert(MI->mayStore() &&
           "Cannot perform value store for non-store instruction");
    if (!MI->memoperands_empty()) {
      MachineMemOperand *memop = *(MI->memoperands_begin());
      if (const PseudoSourceValue *val = memop->getPseudoValue()) {
        if (const FixedStackPseudoSourceValue *fspsv =
                dyn_cast<FixedStackPseudoSourceValue>(val)) {
          // We have an access to a FixedStack Slot which is by LLVM alias free
          auto *MFI = &(MI->getParent()->getParent()->getFrameInfo());
          // Check alias freeness (TODO seems to not be fulfilled for certain
          // riscv stack slots, not sure why)
          if (MFI->isSpillSlotObjectIndex(fspsv->getFrameIndex()) &&
              !fspsv->mayAlias(MFI) && !fspsv->isAliased(MFI)) {
            aliasfreeSlots.insert(addr);
          }
        }
      }
    }
  } else {
    // Do not need alias information any more
    aliasfreeSlots.erase(addr);
  }
}

template <Triple::ArchType ISA>
void ConstantValueDomain<ISA>::performStoreUnknownValue(Address addr) {
  addr2const.erase(addr);
  addr2symbol.erase(addr);
  aliasfreeSlots.erase(addr);
}

template <Triple::ArchType ISA>
void ConstantValueDomain<ISA>::performStoreUnknownAddress(
    AbstractAddress addr) {

  assert(!addr.isPrecise() && "This address isn't unknown!");
  AddressInterval itv = addr.getAsInterval();

  // Throw away info for all addresses in the interval that are not guaranteed
  // to be alias-free
  for (auto a2cit = addr2const.begin(); a2cit != addr2const.end();) {
    if (a2cit->first < itv.lower() || a2cit->first > itv.upper() ||
        aliasfreeSlots.count(a2cit->first) > 0) {
      ++a2cit;
    } else {
      a2cit = addr2const.erase(a2cit);
    }
  }
  for (auto a2sit = addr2symbol.begin(); a2sit != addr2symbol.end();) {
    if (a2sit->first < itv.lower() || a2sit->first > itv.upper() ||
        aliasfreeSlots.count(a2sit->first) > 0) {
      ++a2sit;
    } else {
      a2sit = addr2symbol.erase(a2sit);
    }
  }
}

template <Triple::ArchType ISA>
AbstractAddress ConstantValueDomain<ISA>::extractGlobalDatastructure(
    const MachineInstr *MI) const {
  const GlobalVariable *resglvar = nullptr;
  // Due to optimizations, there might be multiple memory operands. We require
  // them to describe the same target.
  if (!MI->memoperands_empty()) {
    for (MachineMemOperand *mo : MI->memoperands()) {
      if (auto moval = mo->getValue()) {
        // Pointer into a datastructure
        if (auto geptr = dyn_cast<GetElementPtrInst>(moval)) {
          if (auto glvar =
                  dyn_cast<GlobalVariable>(geptr->getPointerOperand())) {
            if (resglvar == nullptr) {
              resglvar = glvar;
            }
            if (resglvar != glvar) {
              errs() << "[Warning] Disagreeing multiple memory operands, "
                     << "can degrade precision of address information.\n";
              resglvar = nullptr;
              break;
            }
          } else if (auto funcarg =
                         dyn_cast<Argument>(geptr->getPointerOperand())) {
            auto fnparamname = funcarg->getName().str();
            if (fnparam2symbol.count(fnparamname) > 0) {
              auto glvar = fnparam2symbol.at(fnparamname);

              if (resglvar == nullptr) {
                resglvar = glvar;
              }
              if (resglvar != glvar) {
                errs() << "[Warning] Disagreeing multiple memory operands, "
                       << "can degrade precision of address information.\n";
                resglvar = nullptr;
                break;
              }
            }
          }
          // If unknown memory operand is inside the list, resort to unknown
          else {
            resglvar = nullptr;
            break;
          }
        }
        // A scalar datastructure
        else if (auto glvar = dyn_cast<GlobalVariable>(moval)) {
          resglvar = glvar;
        } else {
          resglvar = nullptr;
          break;
        }
      } else {
        resglvar = nullptr;
        break;
      }
    }
  }
  // If data-structure extracted from memory operands, use it
  if (resglvar) {
    return AbstractAddress(resglvar);
  }
  // Fall-back, we know nothing
  return AbstractAddress::getUnknownAddress();
}

// List of instantiations for different ISAs

template class ConstantValueDomain<Triple::ArchType::arm>;
template class ConstantValueDomain<Triple::ArchType::riscv32>;

} // namespace TimingAnalysisPass
