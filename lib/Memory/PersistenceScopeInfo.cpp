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

#include "Memory/PersistenceScopeInfo.h"

#include "AnalysisFramework/CallGraph.h"
#include "LLVMPasses/MachineFunctionCollector.h"
#include "PathAnalysis/LoopBoundInfo.h"
#include "Util/Options.h"
#include "Util/Util.h"

#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_os_ostream.h"

using namespace llvm;

namespace TimingAnalysisPass {

PersistenceScopeInfo *PersistenceScopeInfo::persistenceScopeInfo = nullptr;

PersistenceScopeInfo::PersistenceScopeInfo() {
  // If no persistence wanted, skip this part
  if (InstrCachePersType == PersistenceType::NONE &&
      DataCachePersType == PersistenceType::NONE) {
    return;
  }
  CallGraph &cg = CallGraph::getGraph();
  // For all loops, not only the top-level ones
  for (auto loop : LoopBoundInfo->getAllLoops()) {
    if (!cg.reachableFromEntryPoint(loop->getHeader()->getParent())) {
      continue;
    }
    this->walkMachineLoop(loop);
  }
}

PersistenceScopeInfo &PersistenceScopeInfo::getInfo() {
  if (persistenceScopeInfo == nullptr) {
    persistenceScopeInfo = new PersistenceScopeInfo();
  }
  return *persistenceScopeInfo;
}

void PersistenceScopeInfo::walkMachineLoop(const MachineLoop *loop) {
  // TODO filter the loops with the conditionals!!!
  bool isLoopGoodScope = true;

  // If we have an (indirect) external function call in the loop, it is a bad
  // persistence scope
  CallGraph &cg = CallGraph::getGraph();
  for (auto blkit = loop->block_begin(); blkit != loop->block_end(); ++blkit) {
    for (auto &instr : **blkit) {
      if (instr.isCall()) {
        isLoopGoodScope &= !cg.callsExternal(&instr);
        isLoopGoodScope &=
            !cg.callsNestedFunctions(&instr, NumberCallsiteTokens);
        for (auto &callee : cg.getPotentialCallees(&instr)) {
          isLoopGoodScope &= !cg.callsExternal(callee);
        }
      }
    }
    if (!isLoopGoodScope) {
      break;
    }
  }

  if (isLoopGoodScope) {
    // Fill in the scope information
    auto header = loop->getHeader();
    PersistenceScope loopScope(loop);
    const auto &headerPreds = getNonEmptyPredecessorBasicBlocks(header);
    for (auto headerPred : headerPreds) {
      if (!loop->contains(headerPred)) { // Entering edge
        auto enterEdge = std::make_pair(headerPred, loop->getHeader());
        DEBUG_WITH_TYPE("persistence",
                        dbgs() << "Working on the enter edge (BB"
                               << enterEdge.first->getNumber() << ", BB"
                               << enterEdge.second->getNumber() << ")\n");
        assert(!enterEdge.first->empty() && !enterEdge.second->empty() &&
               "Empty edge vertices");
        startScope[enterEdge].insert(loopScope);
      }
    }
    SmallVector<std::pair<llvm::MachineBasicBlock *, llvm::MachineBasicBlock *>,
                0>
        exitEdges;
    loop->getExitEdges(exitEdges);
    for (auto exitEdgeNonConst : exitEdges) {
      MBBedge exitEdge =
          std::make_pair(exitEdgeNonConst.first, exitEdgeNonConst.second);
      if (exitEdge.second->empty()) {
        exitEdge.second = getNonEmptySuccessorBasicBlock(exitEdge.second);
      }
      DEBUG_WITH_TYPE("persistence",
                      dbgs() << "Working on the exit edge (BB"
                             << exitEdge.first->getNumber() << ", BB"
                             << exitEdge.second->getNumber() << ")\n");
      assert(!exitEdge.first->empty() && !exitEdge.second->empty() &&
             "Empty edge vertices");
      endScope[exitEdge].insert(loopScope);
    }
  } else {
    std::cerr << "[Warning] We omitted a potential persistence scope due to "
              << "external function calls/missing context sensitivity.\n";
  }
}

bool PersistenceScopeInfo::entersScope(const MBBedge edge) const {
  return startScope.count(edge) > 0;
}

bool PersistenceScopeInfo::leavesScope(const MBBedge edge) const {
  return endScope.count(edge) > 0;
}

std::set<PersistenceScope>
PersistenceScopeInfo::getEnteringScopes(const MBBedge edge) const {
  assert(entersScope(edge) && "Needs to enter");
  std::set<PersistenceScope> result;
  for (auto &sc : startScope.at(edge)) {
    result.insert(sc);
  }
  return result;
}

std::set<PersistenceScope>
PersistenceScopeInfo::getLeavingScopes(const MBBedge edge) const {
  assert(leavesScope(edge) && "Needs to leave");
  std::set<PersistenceScope> result;
  for (auto &sc : endScope.at(edge)) {
    result.insert(sc);
  }
  return result;
}

std::set<PersistenceScope>
PersistenceScopeInfo::getAllPersistenceScopes() const {
  std::set<PersistenceScope> result;
  for (auto &edge2scopes : startScope) {
    for (auto &sc : edge2scopes.second) {
      result.insert(sc);
    }
  }
  return result;
}

void PersistenceScopeInfo::dump(std::ostream &mystream) const {
  raw_os_ostream llvmstream(mystream);
  // Output the scopes
  llvmstream << "Starting Scopes:\n";
  for (auto &edge2scopes : startScope) {
    for (auto &sc : edge2scopes.second) {
      llvmstream << "We start scope " << sc << " at (BB"
                 << edge2scopes.first.first->getNumber() << ", BB"
                 << edge2scopes.first.second->getNumber() << ")\n";
    }
  }
  llvmstream << "Ending Scopes:\n";
  for (auto &edge2scopes : endScope) {
    for (auto &sc : edge2scopes.second) {
      llvmstream << "We end scope " << sc << " at (BB"
                 << edge2scopes.first.first->getNumber() << ", BB"
                 << edge2scopes.first.second->getNumber() << ")\n";
    }
  }
}

} // namespace TimingAnalysisPass
