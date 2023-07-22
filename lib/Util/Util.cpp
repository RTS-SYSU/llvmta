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

#include "Util/Util.h"
#include "AnalysisFramework/CallGraph.h"
#include "LLVMPasses/StaticAddressProvider.h"
#include "LLVMPasses/TimingAnalysisMain.h"

#include "llvm/IR/DebugInfoMetadata.h"

#include "RISCV.h"

#include <queue>

using namespace llvm;

namespace TimingAnalysisPass {

unsigned debugDumpNo = 0;

const MachineOperand &getBranchTargetOperand(const MachineInstr *MI) {
  assert(MI->isBranch());
  auto arch =
      TimingAnalysisMain::getTargetMachine().getTargetTriple().getArch();
  if (arch == Triple::ArchType::arm) {
    return MI->getOperand(0);
  } else {
    assert(arch == Triple::ArchType::riscv32);
    if (MI->getOpcode() == RISCV::PseudoBR) {
      return MI->getOperand(0);
    } else {
      return MI->getOperand(2);
    }
  }
}

bool isJumpTableBranch(const MachineInstr *MI) {
  auto arch =
      TimingAnalysisMain::getTargetMachine().getTargetTriple().getArch();
  if (arch == Triple::ArchType::arm) {
    return MI->getOpcode() == ARM::BR_JTr ||
           MI->getOpcode() == ARM::BR_JTm_rs ||
           MI->getOpcode() == ARM::BR_JTm_i12;
  } else {
    assert(arch == Triple::ArchType::riscv32);
    // TODO riscv ???
    return false;
  }
}

int getJumpTableIndex(const MachineInstr *MI) {
  assert(isJumpTableBranch(MI) &&
         "Cannot get jump table index of non jump-table branch");
  auto arch =
      TimingAnalysisMain::getTargetMachine().getTargetTriple().getArch();
  if (arch == Triple::ArchType::arm) {
    unsigned opidx = 0;
    if (MI->getOpcode() == ARM::BR_JTr) {
      opidx = 1;
    } else if (MI->getOpcode() == ARM::BR_JTm_rs ||
               MI->getOpcode() == ARM::BR_JTm_i12) {
      opidx = 3;
    } else {
      assert(0 && "Unreachable");
      return -1;
    }
    assert(MI->getOperand(opidx).isJTI() && "Expected jump table index");
    return MI->getOperand(opidx).getIndex();
  } else {
    assert(arch == Triple::ArchType::riscv32);
    // TODO riscv ???
    assert(0 && "unreachable");
    return 0;
  }
}

bool isPrefetchARM(const MachineInstr *MI) {
  auto arch =
      TimingAnalysisMain::getTargetMachine().getTargetTriple().getArch();
  if (arch == Triple::ArchType::arm) {
    switch (MI->getOpcode()) {
    // ARM Cache Prefetching
    case ARM::PLIi12:
    case ARM::PLIrs:
    case ARM::PLDi12:
    case ARM::PLDrs:
    case ARM::PLDWi12:
    case ARM::PLDWrs:
      return true;
    }
    assert(!(MI->mayLoad() && MI->mayStore()) &&
           "Only prefetch instructions load and store");
    return false;
  } else {
    // RISCV doesn't support prefetching yet.
    assert(!(MI->mayLoad() && MI->mayStore()) &&
           "Only prefetch instructions load and store");
    return false;
  }
}

std::ostream &operator<<(std::ostream &stream, const BranchOutcome &bo) {
  if (bo.btaken) {
    stream << "Executed";
    if (bo.target) {
      stream << " to target BB" << bo.target.get()->getNumber();
    }
  } else {
    stream << "Not executed";
  }
  return stream;
}

bool isPredicated(const MachineInstr *I) {
  int predOpId = I->findFirstPredOperandIdx();
  auto arch =
      TimingAnalysisMain::getTargetMachine().getTargetTriple().getArch();
  return (predOpId != -1 && (arch == Triple::ArchType::arm &&
                             I->getOperand(predOpId).getImm() != ARMCC::AL));
}

std::string getMachineInstrIdentifier(const MachineInstr *I) {
  return I->getParent()->getParent()->getName().str() + "_BB" +
         std::to_string(I->getParent()->getNumber()) + "_I" +
         std::to_string(StaticAddrProvider->Ins2posinbb.at(I));
}

std::string getBasicBlockIdentifier(const MachineBasicBlock *MBB) {
  return MBB->getParent()->getName().str() + "_BB" +
         std::to_string(MBB->getNumber());
}

bool instrptrcomp::operator()(const MachineInstr *const lhs,
                              const MachineInstr *const rhs) const {
  if (lhs->getParent()->getParent()->getFunctionNumber() !=
      rhs->getParent()->getParent()->getFunctionNumber()) {
    return lhs->getParent()->getParent()->getFunctionNumber() <
           rhs->getParent()->getParent()->getFunctionNumber();
  }
  if (lhs->getParent()->getNumber() != rhs->getParent()->getNumber()) {
    return lhs->getParent()->getNumber() < rhs->getParent()->getNumber();
  }
  return StaticAddrProvider->Ins2posinbb.at(lhs) <
         StaticAddrProvider->Ins2posinbb.at(rhs);
}

bool mbbComp::operator()(const MachineBasicBlock *const lhs,
                         const MachineBasicBlock *const rhs) const {
  if (lhs->getParent()->getFunctionNumber() !=
      rhs->getParent()->getFunctionNumber()) {
    return lhs->getParent()->getFunctionNumber() <
           rhs->getParent()->getFunctionNumber();
  }
  return lhs->getNumber() < rhs->getNumber();
}

bool mbbedgecomp::operator()(const MBBedge &lhs, const MBBedge &rhs) const {
  mbbComp lessmbb;
  if (lhs.first->getParent()->getFunctionNumber() ==
          rhs.first->getParent()->getFunctionNumber() &&
      lhs.first->getNumber() == rhs.first->getNumber()) {
    return lessmbb(lhs.second, rhs.second);
  }
  return lessmbb(lhs.first, rhs.first);
}

bool machfunccomp::operator()(const MachineFunction *const lhs,
                              const MachineFunction *const rhs) const {
  return lhs->getFunctionNumber() < rhs->getFunctionNumber();
}

bool glvarcomp::operator()(const GlobalVariable *const lhs,
                           const GlobalVariable *const rhs) const {
  // -1 less than, 0 equal, 1 greater than
  return lhs->getName().compare(rhs->getName()) == -1;
}

bool isBasicBlockEmpty(const MachineBasicBlock *MBB) {
  for (auto currInstr = MBB->begin(); currInstr != MBB->end(); ++currInstr) {
    if (!currInstr->isTransient()) {
      return false;
    }
  }
  return true;
}

const MachineInstr *getFirstInstrInBB(const MachineBasicBlock *MBB) {
  for (auto &currInstr : *MBB) {
    if (currInstr.isTransient()) {
      continue;
    }
    return &currInstr;
  }
  assert(0 && "Non-empty basic block contains only transient instructions");
}

const MachineInstr *getLastInstrInBB(const MachineBasicBlock &MBB) {
  for (auto currInstrIt = MBB.rbegin(); currInstrIt != MBB.rend();
       ++currInstrIt) {
    if ((*currInstrIt).isTransient()) {
      continue;
    }
    return &*currInstrIt;
  }
  assert(0 && "Non-empty basic block contains only transient instructions");
}

const MachineInstr *
getFirstInstrInFunction(const MachineFunction *MF,
                        std::list<MBBedge> &initialedgelist) {
  const MachineBasicBlock *currMBB = &(MF->front());
  assert(currMBB->getNumber() == 0 && currMBB->pred_empty() &&
         "Violated internal assumption");
  while (true) {
    for (auto &currInstr : *currMBB) {
      if (!currInstr.isTransient()) {
        return &currInstr;
      }
    }
    assert(currMBB->succ_size() == 1 &&
           "Expected empty BB to have one successor");
    initialedgelist.push_back(std::make_pair(currMBB, *currMBB->succ_begin()));
    currMBB = *currMBB->succ_begin();
  }
}

bool isEndInstr(const MachineBasicBlock &mbb, const MachineInstr *mi) {
  if (mi->isBranch() || mi->isReturn() || mi == getLastInstrInBB(mbb))
    return true;
  return false;
}

std::vector<const MachineInstr *>
getAllEndInstrInMBB(const MachineBasicBlock *mbb) {
  // Collect all basic block end instructions
  std::vector<const MachineInstr *> endInstr;
  for (auto &currInstr : *mbb) {
    if (isEndInstr(*mbb, &currInstr)) {
      endInstr.push_back(&currInstr);
    }
  }
  return endInstr;
}

std::set<std::list<MBBedge>> *getEdgesBetween(const MachineBasicBlock *MBB1,
                                              const MachineBasicBlock *MBB2) {
  assert(MBB1 != MBB2 &&
         "Cannot get the edges between the same single basic block");

  std::set<std::list<MBBedge>> *result = nullptr;

  for (auto succit = MBB1->succ_begin(); succit < MBB1->succ_end(); ++succit) {
    // next basic block is not empty and not the final state, so ignore
    if (!(isBasicBlockEmpty(*succit)) && ((*succit) != MBB2)) {
      continue;
    }
    std::set<std::list<MBBedge>> *edgesSet = nullptr;
    // We reached our final block
    if (*succit == MBB2) {
      edgesSet = new std::set<std::list<MBBedge>>();
      edgesSet->insert(std::list<MBBedge>());
    } else {
      // We have not reached final block, keep on looking from current empty
      // block
      assert(isBasicBlockEmpty(*succit));
      edgesSet = getEdgesBetween(*succit, MBB2);
    }
    // If we found a path from succit to final basic block
    if (edgesSet != nullptr) {
      if (result == nullptr) {
        result = new std::set<std::list<MBBedge>>();
      }
      for (auto list : *edgesSet) {
        list.push_front(std::make_pair(MBB1, *succit));
        result->insert(list);
      }
      // Finally we do not need the intermediate result anymore
      delete edgesSet;
    }
  }
  return result;
}

std::set<MachineBasicBlock *>
getNonEmptySuccessorBasicBlocks(const MachineBasicBlock &mbb) {
  std::set<MachineBasicBlock *> result;
  for (auto succIt = mbb.succ_begin(); succIt != mbb.succ_end(); ++succIt) {
    if (!isBasicBlockEmpty(*succIt)) {
      result.insert(*succIt);
    } else {
      auto succSet = getNonEmptySuccessorBasicBlocks(**succIt);
      for (auto succ : succSet) {
        result.insert(succ);
      }
    }
  }
  return result;
}

const MachineBasicBlock *
getNonEmptySuccessorBasicBlock(const MachineBasicBlock *mbb) {
  assert(isBasicBlockEmpty(mbb) && "MBB should be empty");
  assert(mbb->succ_size() == 1 && "Empty MBB can only have one successor");
  const MachineBasicBlock *succ = *mbb->succ_begin();
  if (isBasicBlockEmpty(succ))
    return getNonEmptySuccessorBasicBlock(succ);
  else
    return succ;
}

std::set<const MachineBasicBlock *, mbbComp>
getNonEmptyPredecessorBasicBlocks(const MachineBasicBlock *mbb) {
  std::set<const MachineBasicBlock *, mbbComp> result;
  for (auto predIt = mbb->pred_begin(); predIt != mbb->pred_end(); ++predIt) {
    if (!isBasicBlockEmpty(*predIt)) {
      result.insert(*predIt);
    } else {
      // Empty Basic Block
      // We are at the end of the function
      if ((*predIt)->pred_size() == 0) {
        assert((*predIt)->getNumber() == 0 &&
               "Non first basic block has no predecessors?");
        for (auto callsite :
             CallGraph::getGraph().getCallSites((*predIt)->getParent())) {
          assert(!isBasicBlockEmpty(callsite->getParent()) &&
                 "MBB with callsite cannot be empty");
          result.insert(callsite->getParent());
        }
      } else {
        const auto &predSet = getNonEmptyPredecessorBasicBlocks(*predIt);
        for (auto pred : predSet) {
          result.insert(pred);
        }
      }
    }
  }
  return result;
}

bool isFunctionPotentiallyReachableFrom(
    const MachineFunction *target,
    const std::vector<const MachineBasicBlock *> &basicBlocks) {
  // find directly reachable functions
  std::set<const MachineFunction *> reachableFunctions;
  for (auto currMBB : basicBlocks) {
    for (auto callSite : CallGraph::getGraph().getCallSitesInMBB(currMBB)) {
      for (auto currPotCallee :
           CallGraph::getGraph().getPotentialCallees(callSite)) {
        if (currPotCallee == target) {
          return true;
        }
        reachableFunctions.insert(currPotCallee);
      }
    }
  }

  // find indirectly reachable ones
  std::list<const MachineFunction *> workList(reachableFunctions.begin(),
                                              reachableFunctions.end());
  while (!workList.empty()) {
    auto currFunc = workList.front();
    for (auto callSite : CallGraph::getGraph().getCallSites(currFunc)) {
      for (auto currPotCallee :
           CallGraph::getGraph().getPotentialCallees(callSite)) {
        if (currPotCallee == target) {
          return true;
        }
        if (reachableFunctions.count(currPotCallee) == 0) {
          workList.push_back(currPotCallee);
          reachableFunctions.insert(currPotCallee);
        }
      }
    }
    workList.pop_front();
  }

  return false;
}

std::ostream &operator<<(std::ostream &stream,
                         const std::set<const MachineBasicBlock *> set) {
  stream << "{";
  for (auto it = set.begin(); it != set.end(); ++it) {
    stream << "BB" << (*it)->getNumber();
    if (std::distance(it, set.end()) > 1) {
      stream << ",";
    }
  }
  stream << "}";
  return stream;
}

llvm::raw_ostream &printHex(llvm::raw_ostream &stream, unsigned value,
                            unsigned width) {
  /* we need to add 2 to width since the width also includes the 0x prefix */
  return stream << format_hex(value, width + 2);
}

std::ostream &printHex(std::ostream &stream, unsigned value, unsigned width) {
  /* std::ostream formatting is braindead, so we use boost::format here to
   * get printf-like semantics */
  std::string width_str = std::to_string(width);
  return stream << boost::format("0x%0" + width_str + "x") % value;
}

/////////////////////////////
/// Loop Helper Functions ///
/////////////////////////////

std::set<MBBedge> getIncomingEdgesOfLoop(const llvm::MachineLoop *loop) {
  std::set<MBBedge> res;
  auto header = loop->getHeader();
  for (auto srcit = header->pred_begin(); srcit != header->pred_end();
       ++srcit) {
    if (!loop->contains(*srcit)) {
      res.insert(std::make_pair(*srcit, header));
    }
  }
  return res;
}

std::set<MBBedge> getExitingEdgesOfLoop(const llvm::MachineLoop *loop) {
  std::set<MBBedge> res;
  for (auto loopBB : loop->getBlocks()) {
    for (auto destit = loopBB->succ_begin(); destit != loopBB->succ_end();
         ++destit) {
      if (!loop->contains(*destit)) {
        res.insert(std::make_pair(loopBB, *destit));
      }
    }
  }
  return res;
}

std::set<MBBedge> getBackEdgesOfLoop(const MachineLoop *loop) {
  std::set<MBBedge> res;
  auto header = loop->getHeader();
  for (auto srcit = header->pred_begin(); srcit != header->pred_end();
       ++srcit) {
    if (loop->contains(*srcit)) {
      res.insert(std::make_pair(*srcit, header));
    }
  }
  return res;
}

std::string getFilenameFromDebugLoc(const llvm::DebugLoc &dbgLoc) {
  std::string filename = cast<DIScope>(dbgLoc.getScope())->getFilename().str();
  auto slashidx = filename.find_last_of("/");
  if (std::string::npos != slashidx) {
    filename.erase(0, slashidx + 1);
  }
  return filename;
}

#if defined(__linux__) || defined(__linux) || defined(linux)
#include <sys/resource.h>
#include <unistd.h>

long getPeakRSS() {
  struct rusage rusage;
  getrusage(RUSAGE_SELF, &rusage);
  return (long)rusage.ru_maxrss / 1024.0;
}

std::string exec(std::string Command) {
  char Buffer[128];
  std::string Result = "";

  // Open pipe to file
  FILE *Pipe = popen(Command.c_str(), "r");
  if (!Pipe) {
    return "popen failed!";
  }
  // read till end of process:
  while (!feof(Pipe)) {
    // use buffer to read and add to result
    if (fgets(Buffer, 128, Pipe) != NULL)
      Result += Buffer;
  }
  pclose(Pipe);
  return Result;
}

#else
#include <limits>

long getPeakRSS() { return 0; }

#endif

} // namespace TimingAnalysisPass
