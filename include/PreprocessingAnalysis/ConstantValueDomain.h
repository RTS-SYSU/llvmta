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

#ifndef CONSTANTVALUEDOMAIN_H
#define CONSTANTVALUEDOMAIN_H

#include "AnalysisFramework/AnalysisDomain.h"
#include "Util/AbstractAddress.h"
#include "Util/Util.h"

#include "ARM.h"
#include "ARMMachineFunctionInfo.h"
#include "ARMTargetMachine.h"

#include "RISCV.h"
#include "RISCVTargetMachine.h"

#include <map>
#include <sstream>

using namespace llvm;

namespace TimingAnalysisPass {

/**
 * Class implementing constant-value analysis for registers.
 * Either this information is unreachable (bot) or for each register a constant
 * value (if so) or top (every possible value) is provided. This analysis does
 * not depend on other analyses.
 */
template <llvm::Triple::ArchType ISA>
class ConstantValueDomain : public AnalysisDomain<ConstantValueDomain<ISA>,
                                                  MachineInstr, std::tuple<>> {
public:
  /**
   * Initialise this analysis information according to init, i.e. either BOTTOM,
   * TOP, or START.
   */
  explicit ConstantValueDomain(AnaDomInit init);
  /**
   * Copy constructor.
   */
  ConstantValueDomain(const ConstantValueDomain &cvd);
  /**
   * Assignment operator
   */
  ConstantValueDomain &operator=(const ConstantValueDomain &other);

  /**
   * Identifier for debugging purposes
   */
  static std::string analysisName(const char *prefix) {
    return std::string(prefix) + "CVD";
  }

  static bool anainfoBeforeRequired(const MachineInstr *MI) {
    std::list<MBBedge> tmp_list;
    const MachineFunction *mfunc = MI->getParent()->getParent();
    return MI->mayLoad() || MI->mayStore() ||
           MI == getFirstInstrInFunction(mfunc, tmp_list);
  }
  static bool anainfoAfterRequired(const MachineInstr *MI) { return false; }

  using AnalysisDomain<ConstantValueDomain, MachineInstr,
                       std::tuple<>>::transfer;
  void transfer(const MachineInstr *MI, std::tuple<> &anaInfo);
  void handleCallingConvention(const ConstantValueDomain &preCallElement);
  void join(const ConstantValueDomain &element);
  bool lessequal(const ConstantValueDomain &element) const;
  std::string print() const;

  bool isBottom() const;
  bool isTop(unsigned regnr) const;
  int getValueFor(unsigned regnr) const;

  AbstractAddress getDataAccessAddress(const MachineInstr *MI,
                                       unsigned pos) const;

private:
  typedef GlobalVariable MemoryAccessSymbol;

  // Helper functions to manipulate addr2const
  void performStoreValue(const MachineInstr *MI, Address addr, int *valptr,
                         const MemoryAccessSymbol *sym);
  void performStoreUnknownValue(Address addr);
  void performStoreUnknownAddress(AbstractAddress addr);

  // Helper functions to extract global datastructure knowledge
  AbstractAddress extractGlobalDatastructure(const MachineInstr *MI) const;

  const MemoryAccessSymbol *getSymbolFor(unsigned regnr) const;

  /**
   * If a register is guaranteed to have a constant value, find it here.
   * If not, the value is top and not included in this map.
   * If bot is true, this means bottom and reg2const should have not meaning.
   */
  bool bot;
  std::map<unsigned, int> reg2const;
  std::map<Address, int> addr2const;

  /**
   * Simple tracking of which location hold memory access symbols (e.g. global
   * variables).
   */
  std::map<unsigned, const MemoryAccessSymbol *> reg2symbol;
  std::map<Address, const MemoryAccessSymbol *> addr2symbol;
  std::map<std::string, const MemoryAccessSymbol *> fnparam2symbol;

  /**
   * A set collecting addresses of alias-free stack slots/spill slots for which
   * we store values. Those need not be invalidated upon unknown accesses.
   */
  std::set<Address> aliasfreeSlots;

  /// ISA-dependent information

  /// Number of registers to track
  constexpr static unsigned numOfRegisters =
      ISA == Triple::ArchType::riscv32 ? 32 : 16;
  /// Stack pointer
  unsigned stackPointerRegister =
      ISA == Triple::ArchType::riscv32 ? 2 : 13;
  /// General-Purpose Register Class
  constexpr static const TargetRegisterClass &GPRegClass =
      ISA == Triple::ArchType::riscv32 ? RISCV::GPRRegClass : ARM::GPRRegClass;
};

} // namespace TimingAnalysisPass

#endif
