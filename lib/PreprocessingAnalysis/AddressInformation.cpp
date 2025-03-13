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

#include "PreprocessingAnalysis/AddressInformation.h"
#include "LLVMPasses/TimingAnalysisMain.h"

using namespace llvm;

namespace TimingAnalysisPass {

template <>
unsigned
AddressInformation::getNumOfDataAccessesIn<llvm::Triple::ArchType::arm>(
    const MachineInstr *MI) {
  assert((MI->mayLoad() || MI->mayStore()) &&
         "Dont ask for memory operands for non-memory instr");
  switch (MI->getOpcode()) {
  default:
    DEBUG_WITH_TYPE("addrinfo", errs() << *MI;);
    assert(0 && "We do not support this instruction opcode");
    break;
  case ARM::BR_JTm_rs:  // Jump table, will load from jumptable
  case ARM::BR_JTm_i12: // Jump table, will load from jumptable
  case ARM::LDRi12:
  case ARM::STRi12:
  case ARM::LDRcp:
  case ARM::LDRrs:
  case ARM::STRrs:
  case ARM::LDRH:
  case ARM::LDRH_PRE:
  case ARM::LDRH_POST:
  case ARM::STRH:
  case ARM::STRH_PRE:
  case ARM::STRH_POST:
  case ARM::LDRSH:
  case ARM::LDRSH_PRE:
  case ARM::LDRSH_POST:
  case ARM::LDRBrs:
  case ARM::STRBrs:
  case ARM::LDRBi12:
  case ARM::STRBi12:
  case ARM::LDRSB:
  case ARM::LDRSB_PRE:
  case ARM::STR_PRE_IMM:
  case ARM::STR_POST_IMM:
  case ARM::STR_POST_REG:
  case ARM::STR_PRE_REG:
  case ARM::STRB_POST_IMM:
  case ARM::STRB_PRE_IMM:
  case ARM::STRB_PRE_REG:
  case ARM::LDR_POST_IMM:
  case ARM::LDR_POST_REG:
  case ARM::LDR_PRE_IMM:
  case ARM::LDR_PRE_REG:
  case ARM::LDRB_POST_IMM:
  case ARM::LDRB_PRE_IMM:
  case ARM::LDRB_PRE_REG:
  // ARM Cache Prefetching
  case ARM::PLIi12:
  case ARM::PLIrs:
  case ARM::PLDi12:
  case ARM::PLDrs:
  case ARM::PLDWi12:
  case ARM::PLDWrs:
  // ARM8 Load & Stores
  case ARM::VLDRS:
  case ARM::VSTRS:
    return 1;
  // Double load & stores
  case ARM::VLDRD:
  case ARM::VSTRD:
  case ARM::STRD:
    return 2;
  // Load store multiple
  case ARM::LDMIA:
  case ARM::LDMDA:
  case ARM::LDMDB:
  case ARM::LDMIB:
  case ARM::STMIA:
  case ARM::STMDA:
  case ARM::STMDB:
  case ARM::STMIB:
  case ARM::VLDMSIA:
    return MI->getNumOperands() - 3;
  case ARM::LDMIA_UPD:
  case ARM::LDMIA_RET: // Tanslates to LDMIA_UPD.
  case ARM::LDMDA_UPD:
  case ARM::LDMDB_UPD:
  case ARM::LDMIB_UPD:
  case ARM::STMIA_UPD:
  case ARM::STMDA_UPD:
  case ARM::STMDB_UPD:
  case ARM::STMIB_UPD:
  case ARM::VLDMSIA_UPD:
    return MI->getNumOperands() - 4;
  // Double load store multiple
  case ARM::VLDMDIA:
  case ARM::VSTMDIA:
    return 2 * (MI->getNumOperands() - 3);
  case ARM::VLDMDIA_UPD:
  case ARM::VLDMDDB_UPD:
  case ARM::VSTMDIA_UPD:
  case ARM::VSTMDDB_UPD:
    return 2 * (MI->getNumOperands() - 4);
  }
}

template <>
unsigned
AddressInformation::getNumOfDataAccessesIn<llvm::Triple::ArchType::riscv32>(
    const MachineInstr *MI) {
  assert((MI->mayLoad() || MI->mayStore()) &&
         "Dont ask for memory operands for non-memory instr");
  switch (MI->getOpcode()) {
  default:
    DEBUG_WITH_TYPE("addrinfo", errs() << *MI;);
    assert(0 && "We do not support this instruction opcode");
    break;
  case RISCV::LB:
  case RISCV::LH:
  case RISCV::LW:
  case RISCV::LBU:
  case RISCV::LHU:
  case RISCV::SB:
  case RISCV::SH:
  case RISCV::SW:
  case RISCV::FLW:
  case RISCV::FSW:
    return 1;
  // Double load & stores
  case RISCV::FLD:
  case RISCV::FSD:
    return 2;
  }
}

unsigned AddressInformation::getNumOfDataAccesses(const MachineInstr *MI) {
  auto arch =
      TimingAnalysisMain::getTargetMachine().getTargetTriple().getArch();
  if (arch == llvm::Triple::ArchType::arm) {
    return getNumOfDataAccessesIn<llvm::Triple::ArchType::arm>(MI);
  } else if (arch == llvm::Triple::ArchType::riscv32) {
    return getNumOfDataAccessesIn<llvm::Triple::ArchType::riscv32>(MI);
  } else {
    assert(0 && "Unsupported ISA used");
    return 0;
  }
}

void AddressInformation::dump(std::ostream &mystream) const {
  unsigned numStaticReference = 0;
  unsigned numPreciseAddress = 0;
  unsigned numPreciseCacheline = 0;
  unsigned numDatastructure = 0;
  unsigned numUnknown = 0;

  StaticAddrProvider->dump(mystream);
  mystream << std::endl;

  raw_os_ostream llvmstream(mystream);
  llvmstream << "Data Access Addresses:\n"
             << "----------------------\n\n";
  for (auto currFunc : machineFunctionCollector->getAllMachineFunctions()) {
    for (auto currBB = currFunc->begin(); currBB != currFunc->end(); ++currBB) {
      for (auto currMI = currBB->begin(); currMI != currBB->end(); ++currMI) {
        if (currMI->mayLoad() || currMI->mayStore()) {
          llvmstream << getMachineInstrIdentifier(&*currMI) << ": " << *currMI;
          auto ctxs = getAddressContexts(&*currMI);
          if (ctxs.empty()) {
            llvmstream << "NO CONTEXT-SENSITIVE INFO AVAILABLE!\n";
          } else {
            std::set<Context, ctxcomp> ctx_sorted;
            for (Context c : ctxs) {
              ctx_sorted.insert(c);
            }
            for (Context ctx : ctx_sorted) {
              std::stringstream ss;
              ss << ctx;
              llvmstream << "In context:\n" << ss.str() << "\n";
              for (unsigned o = 0; o < getNumOfDataAccesses(&*currMI); ++o) {
                const auto &addr = getDataAccessAddress(&*currMI, &ctx, o);
                llvmstream << "Address for #memop " << o << ": " << addr
                           << "\n";
                ++numStaticReference;
                if (addr.isPrecise()) {
                  ++numPreciseAddress;
                } else if ((addr.getAsInterval().lower() & ~(Dlinesize - 1)) ==
                           (addr.getAsInterval().upper() & ~(Dlinesize - 1))) {
                  DEBUG_WITH_TYPE("cachelineAccesses",
                                  dbgs() << "Cacheline-precise access in ";
                                  currMI->getDebugLoc().print(dbgs());
                                  dbgs() << "\n");
                  ++numPreciseCacheline;
                } else if (addr.isArray()) {
                  DEBUG_WITH_TYPE("arrayAccesses", dbgs() << "Array access in ";
                                  currMI->getDebugLoc().print(dbgs());
                                  dbgs() << "\n");
                  ++numDatastructure;
                } else if (addr == AbstractAddress::getUnknownAddress()) {
                  DEBUG_WITH_TYPE(
                      "unknownAccesses", dbgs() << "Unknown address in ";
                      currMI->getDebugLoc().print(dbgs()); dbgs() << "\n");
                  ++numUnknown;
                }
              }
            }
          }
        }
      }
    }
  }
  auto &ar = AnalysisResults::getInstance();
  ar.registerResult("StaticMemoryReferences", numStaticReference);
  ar.registerResult("StaticMemoryReferencesWithPreciseAddress",
                    numPreciseAddress);
  ar.registerResult("StaticMemoryReferencesWithPreciseCacheline",
                    numPreciseCacheline);
  ar.registerResult("StaticMemoryReferencesToDatastructure", numDatastructure);
  ar.registerResult("StaticMemoryUnknownReferences", numUnknown);
}

//////////////////////////////
// The Specialised variants //
//////////////////////////////

template <>
AbstractAddress
AddressInformationImpl<ConstantValueDomain<llvm::Triple::ArchType::arm>>::
    getDataAccessAddress(const MachineInstr *MI, Context *currCtx,
                         unsigned pos) const {
  if (currCtx != nullptr) {
    const auto &res =
        addressAnaInfo.getAnaInfoBefore(MI).findAnalysisInfo(*currCtx);
    return res.getDataAccessAddress(MI, pos);
  }
  return AbstractAddress::getUnknownAddress();
}

template <>
AbstractAddress
AddressInformationImpl<ConstantValueDomain<llvm::Triple::ArchType::riscv32>>::
    getDataAccessAddress(const MachineInstr *MI, Context *currCtx,
                         unsigned pos) const {
  if (currCtx != nullptr) {
    const auto &res =
        addressAnaInfo.getAnaInfoBefore(MI).findAnalysisInfo(*currCtx);
    return res.getDataAccessAddress(MI, pos);
  }
  return AbstractAddress::getUnknownAddress();
}

} // namespace TimingAnalysisPass
