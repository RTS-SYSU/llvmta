////////////////////////////////////////////////////////////////////////////////
//
//   LLVMTA - Timing Analyser performing worst-case execution time analysis
//     using the LLVM backend intermediate representation
//
// Copyright (C) 2013-2022  Saarland University
// Copyright (C) 2014-2015 Claus Faymonville
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

#ifndef STATICADDRESSPROVIDER_H
#define STATICADDRESSPROVIDER_H

#include "ARM.h"
#include "ARMMachineFunctionInfo.h"
#include "llvm/ADT/SmallSet.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/CodeGen/MachineConstantPool.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineModuleInfo.h"
#include "llvm/CodeGen/TargetInstrInfo.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/GlobalValue.h"
#include "llvm/IR/Module.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Target/TargetMachine.h"

#include <boost/optional.hpp>

#include <iostream>
#include <map>

#include "Util/Util.h"

using namespace llvm;

namespace TimingAnalysisPass {

/**
 * Class that manages the placement of e.g. instructions, data structures in
 * address space. It provides access to the addresses of instructions as well as
 * the reverse mapping.
 */
class StaticAddressProvider : public MachineFunctionPass {

public:
  static char ID;

  /**
   * Constructor
   */
  StaticAddressProvider(TargetMachine &TM);

  /**
   * Place instructions in address space.
   */
  bool runOnMachineBasicBlock(MachineBasicBlock &MBB);
  bool runOnMachineFunction(MachineFunction &F);

  /**
   * Place data structures in address space.
   */
  virtual bool doInitialization(Module &M);

  virtual llvm::StringRef getPassName() const {
    return "Provides addresses to instructions that are needed by timing "
           "analysis";
  }

  /**
   * @brief Return the address the given instruction is placed at.
   *
   * @param I
   * @return unsigned
   */
  unsigned getAddr(const MachineInstr *I);

  /**
   * @brief Do we have a machine instruction (in our program to analyse)
   * at the given address.
   *
   * @param Addr
   * @return true
   * @return false
   */
  bool hasMachineInstrByAddr(unsigned Addr);

  /**
   * @brief Get the machine instruction (of our program) at the given
   * address, if any. Else assert.
   *
   * @param Addr
   * @return const MachineInstr*
   */
  const MachineInstr *getMachineInstrByAddr(unsigned Addr);

  /**
   * @brief
   * Returns the address of the idx-th constant pool entry of the
   * constant pool of function MF.
   *
   * @param MF
   * @param idx
   * @return unsigned
   */
  unsigned getConstPoolEntryAddr(const MachineFunction *MF, unsigned Idx);

  /**
   * @brief Do we know the constant value at the given address?
   *
   * @param Addr
   * @return true
   * @return false
   */
  bool hasValueAtAddress(unsigned Addr);

  /**
   * @brief If we have the constant value at the given address, return
   * it.
   *
   * @param Addr
   * @return unsigned
   */
  unsigned getValueAtAddress(unsigned Addr);

  /**
   * @brief Does an address contain a value that corresponds to a symbol.
   * Return nullptr if not.
   *
   * @param addr
   * @return const GlobalVariable*
   */
  const GlobalVariable *getSymbolAtAddress(unsigned Addr);

  /**
   * @brief Have we the address for the given global variable.
   *
   * @param Glvar
   * @return true
   * @return false
   */
  bool hasGlobalVarAddress(const GlobalVariable *Glvar);

  /**
   * @brief Get the address of the given global variable.
   *
   * @param Glvar
   * @return unsigned
   */
  unsigned getGlobalVarAddress(const GlobalVariable *Glvar);

  /**
   * @brief Returns the size of the (value of the) global variable glvar
   *
   * @param Glvar
   * @return unsigned
   */
  unsigned getArraySize(const GlobalVariable *Glvar);

  /**
   * @brief Return a set of global variables that we allocated in memory.
   *
   * @return std::set<const GlobalVariable *>
   */
  std::set<const GlobalVariable *> getGlobalVariables() const;

  /**
   * @brief Return a single constant initial value for the global variable, if
   * any. E.g. if the variable has an array type, we return none.
   *
   * @param glvar
   * @return boost::optional<int>
   */
  boost::optional<int>
  getGlobalVariableInitialValue(const GlobalVariable *Glvar) const;

  /**
   * @brief Returns whether the given address is the start address is outside
   * our known address space.
   *
   * @param Addr
   * @return true
   * @return false
   */
  bool goesExternal(unsigned Addr);

  /**
   * @brief Dump the computed instruction<->address mapping to the given stream.
   *
   * @param Mystream
   */
  void dump(std::ostream &Mystream) const;

private:
  TargetMachine &TM;
  std::unique_ptr<const DataLayout> DataLayoutInstance;
  /// The address where code placement starts
  unsigned CodeAddress;
  /// The address where rodata placement starts
  unsigned RodataAddress;

  /// Instruction to address mapping, including constant pool entries
  std::map<const MachineInstr *, unsigned> Ins2addr;
  /// Address to instruction mapping, including constant pool entries
  std::map<unsigned, const MachineInstr *> Addr2ins;

  /// Constant Pool Entries to address mapping
  std::map<std::pair<const MachineFunction *, unsigned>, unsigned> Cpe2addr;

  /// Map global variables to addresses (filled in initialization)
  std::map<const GlobalVariable *, unsigned, glvarcomp> Glvar2addr;
  /// Address to Value mapping (Values might again be Addresses)
  std::map<unsigned, unsigned> Addr2values;
  /// Address to Symbol mapping
  std::map<unsigned, const GlobalVariable *> Addr2symbol;

public:
  /// Instruction to identifier mapping
  std::map<const MachineInstr *, unsigned> Ins2posinbb;
};

extern StaticAddressProvider *StaticAddrProvider;
} // namespace TimingAnalysisPass

namespace llvm {
FunctionPass *createStaticAddressProvider(TargetMachine &TM);
} // namespace llvm

#endif
