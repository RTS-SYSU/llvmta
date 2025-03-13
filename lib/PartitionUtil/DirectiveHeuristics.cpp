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

#include "PartitionUtil/DirectiveHeuristics.h"
#include "PartitionUtil/PartitionToken.h"

#include "LLVMPasses/TimingAnalysisMain.h"

#include "Util/Options.h"

#include <set>
#include <vector>

using namespace llvm;
using namespace std;

namespace TimingAnalysisPass {

DirectiveHeuristicsPass *DirectiveHeuristicsPassInstance;

char DirectiveHeuristicsPass::ID = 0;

DirectiveHeuristicsPass::DirectiveHeuristicsPass() : MachineFunctionPass(ID) {}

void DirectiveHeuristicsPass::getAnalysisUsage(AnalysisUsage &AU) const {
  MachineFunctionPass::getAnalysisUsage(AU);
  AU.setPreservesCFG();
  AU.addRequired<MachineLoopInfo>();
}

////////////////////////////////////////////////////////////////////////////
/// Directive Annotation on Function, Basic Block, and Instruction Level ///
////////////////////////////////////////////////////////////////////////////

bool DirectiveHeuristicsPass::runOnMachineFunction(MachineFunction &MF) {
  // The partitioning on the callee site (added on each call)
  shared_ptr<PartitionToken> PtCallee(new PartitionTokenFunCallee(&MF));
  set<shared_ptr<PartitionToken>> PtsetCallee;
  PtsetCallee.insert(PtCallee);
  Directive *DirecCreateCallee =
      new Directive(DirectiveType::CREATE, PtsetCallee);
  Directive *DirecMergeCallee =
      new Directive(DirectiveType::MERGE, PtsetCallee);
  this->DirectiveBeforeFunc.insert(make_pair(&MF, DirecCreateCallee));
  this->DirectiveAfterFunc.insert(make_pair(&MF, DirecMergeCallee));

  // If Loop Peeling is desired, we do it
  if (LoopPeel > 0) {
    // Iterate over all level 1 loops and let them annotate
    MachineLoopInfo &MLI = getAnalysis<MachineLoopInfo>();
    for (auto *MachineLoop : MLI) {
      annotateLoopDirective(MachineLoop);
    }
  }

  // Derive Directives on Instruction Level (e.g. Function Call)
  for (MachineFunction::iterator MBB = MF.begin(); MBB != MF.end(); ++MBB) {
    this->runOnMachineBasicBlock(*MBB);
  }
  return false; // Nothing is changed, no fixed-point iteration necessary
}

void DirectiveHeuristicsPass::annotateLoopDirective(const MachineLoop *Loop) {
  // Create PartitionTokens
  auto BackedgeSet = getBackEdgesOfLoop(Loop);
  set<shared_ptr<PartitionToken>> Ptset;
  for (unsigned I = 0; I < LoopPeel; ++I) {
    shared_ptr<PartitionToken> PtLoopPeel(
        new PartitionTokenLoopPeel(Loop, BackedgeSet, I));
    Ptset.insert(PtLoopPeel);
  }
  shared_ptr<PartitionToken> PtLoopIter(
      new PartitionTokenLoopIter(Loop, BackedgeSet, LoopPeel));
  Ptset.insert(PtLoopIter);
  // Add create directive at last possible position on incoming edges
  auto IncomingEdges = getIncomingEdgesOfLoop(Loop);
  for (auto Edge : IncomingEdges) {
    if (DirectiveLeaveBBEdge.count(Edge) == 0) {
      list<Directive *> *Newlist = new list<Directive *>();
      DirectiveLeaveBBEdge.insert(make_pair(Edge, Newlist));
    }
    auto *EdgeDirectiveList = DirectiveLeaveBBEdge[Edge];
    Directive *DirecLoopCreate = new Directive(DirectiveType::CREATE, Ptset);
    EdgeDirectiveList->push_back(DirecLoopCreate);
  }
  // Add merge directive at first possible position on outgoing edges
  auto ExitingEdges = getExitingEdgesOfLoop(Loop);
  for (auto Edge : ExitingEdges) {
    if (DirectiveEnterBBEdge.count(Edge) == 0) {
      list<Directive *> *Newlist = new list<Directive *>();
      DirectiveEnterBBEdge.insert(make_pair(Edge, Newlist));
    }
    auto *EdgeDirectiveList = DirectiveEnterBBEdge[Edge];
    Directive *DirecLoopMerge = new Directive(DirectiveType::MERGE, Ptset);
    EdgeDirectiveList->push_front(DirecLoopMerge);
  }
  // Do directive annotations for all nested loops
  for (auto *Subloop : Loop->getSubLoops()) {
    annotateLoopDirective(Subloop);
  }
}

bool DirectiveHeuristicsPass::runOnMachineBasicBlock(MachineBasicBlock &MBB) {
  // We add partitioning directives for function calls around a call
  // instruction.
  for (auto &MI : MBB) {
    // Check if current instruction is a calling instructions
    if (MI.isCall()) { // TODO: how are computed calls handled?
      // Get the call target operand
      MachineOperand &CallTarget = MI.getOperand(0);
      // We do not support offset function calls
      assert(CallTarget.getOffset() == 0 &&
             "No offsets allowed for function calls");

      // Create corresponding directives
      // The partitioning on the caller site here (partitioning on the callee
      // site above)
      shared_ptr<PartitionToken> Pt(new PartitionTokenCallSite(&MI));
      set<shared_ptr<PartitionToken>> Ptset;
      Ptset.insert(Pt);
      Directive *DirecCreate = new Directive(DirectiveType::CREATE, Ptset);
      Directive *DirecMerge = new Directive(DirectiveType::MERGE, Ptset);
      this->DirectiveBeforeInstr.insert(make_pair(&MI, DirecCreate));
      this->DirectiveAfterInstr.insert(make_pair(&MI, DirecMerge));
    }
  }
  return false;
}

///////////////////
/// Output dump ///
///////////////////

void DirectiveHeuristicsPass::dump(std::ostream &Mystream) const {
  Mystream << "##################################\n"
           << "## Directives Machine Functions ##\n"
           << "##################################\n";
  // Before function invocation
  for (auto It = DirectiveBeforeFunc.begin(); It != DirectiveBeforeFunc.end();
       ++It) {
    Mystream << "Before " << It->first->getName().str() << ", " << *(It->second)
             << "\n";
  }
  // After function invocation
  for (auto It = DirectiveAfterFunc.begin(); It != DirectiveAfterFunc.end();
       ++It) {
    Mystream << "After " << It->first->getName().str() << ", " << *(It->second)
             << "\n";
  }

  Mystream << "#############################\n"
           << "## Directives Basic Blocks ##\n"
           << "#############################\n";
  // Entering basic block edge
  for (auto It = DirectiveEnterBBEdge.begin(); It != DirectiveEnterBBEdge.end();
       ++It) {
    Mystream << "Enter (" << getBasicBlockIdentifier(It->first.first) << ", "
             << getBasicBlockIdentifier(It->first.second) << "), [";
    for (auto Listit = It->second->begin(); Listit != It->second->end();
         ++Listit) {
      Mystream << *(*Listit);
      if (distance(Listit, It->second->end()) > 1) {
        Mystream << ",\n";
      }
    }
    Mystream << "]\n";
  }
  // Leaving basic block edge
  for (auto It = DirectiveLeaveBBEdge.begin(); It != DirectiveLeaveBBEdge.end();
       ++It) {
    Mystream << "Leave (" << getBasicBlockIdentifier(It->first.first) << ", "
             << getBasicBlockIdentifier(It->first.second) << "), [";
    for (auto Listit = It->second->begin(); Listit != It->second->end();
         ++Listit) {
      Mystream << *(*Listit);
      if (distance(Listit, It->second->end()) > 1) {
        Mystream << ",\n";
      }
    }
    Mystream << "]\n";
  }

  Mystream << "#############################\n"
           << "## Directives Instructions ##\n"
           << "#############################\n";
  // Directives before machine instructions
  for (auto It = DirectiveBeforeInstr.begin(); It != DirectiveBeforeInstr.end();
       ++It) {
    Mystream << "Before " << getMachineInstrIdentifier(It->first) << ", "
             << *(It->second) << "\n";
  }
  // Directives after machine instructions
  for (auto It = DirectiveAfterInstr.begin(); It != DirectiveAfterInstr.end();
       ++It) {
    Mystream << "After " << getMachineInstrIdentifier(It->first) << ", "
             << *(It->second) << "\n";
  }
}

///////////////////////////////////////
/// Access the resulting directives ///
///////////////////////////////////////

bool DirectiveHeuristicsPass::hasDirectiveBeforeInstr(const MachineInstr *MI) {
  return this->DirectiveBeforeInstr.count(MI) > 0;
}

bool DirectiveHeuristicsPass::hasDirectiveAfterInstr(const MachineInstr *MI) {
  return this->DirectiveAfterInstr.count(MI) > 0;
}

bool DirectiveHeuristicsPass::hasDirectiveOnCall(const MachineFunction *MF) {
  return this->DirectiveBeforeFunc.count(MF) > 0;
}

bool DirectiveHeuristicsPass::hasDirectiveOnReturn(const MachineFunction *MF) {
  return this->DirectiveAfterFunc.count(MF) > 0;
}

bool DirectiveHeuristicsPass::hasDirectiveOnEdgeEnter(
    pair<const MachineBasicBlock *, const MachineBasicBlock *> E) {
  return this->DirectiveEnterBBEdge.count(E) > 0;
}

bool DirectiveHeuristicsPass::hasDirectiveOnEdgeLeave(
    pair<const MachineBasicBlock *, const MachineBasicBlock *> E) {
  return this->DirectiveLeaveBBEdge.count(E) > 0;
}

Directive *
DirectiveHeuristicsPass::getDirectiveBeforeInstr(const MachineInstr *MI) {
  assert(hasDirectiveBeforeInstr(MI) && "No directive found, use proper API.");
  return this->DirectiveBeforeInstr[MI];
}

Directive *
DirectiveHeuristicsPass::getDirectiveAfterInstr(const MachineInstr *MI) {
  assert(hasDirectiveAfterInstr(MI) && "No directive found, use proper API.");
  return this->DirectiveAfterInstr[MI];
}

Directive *
DirectiveHeuristicsPass::getDirectiveOnCall(const MachineFunction *MF) {
  assert(hasDirectiveOnCall(MF) && "No directive found, use proper API.");
  return this->DirectiveBeforeFunc[MF];
}

Directive *
DirectiveHeuristicsPass::getDirectiveOnReturn(const MachineFunction *MF) {
  assert(hasDirectiveOnReturn(MF) && "No directive found, use proper API.");
  return this->DirectiveAfterFunc[MF];
}

list<Directive *> *DirectiveHeuristicsPass::getDirectiveOnEdgeEnter(
    pair<const MachineBasicBlock *, const MachineBasicBlock *> E) {
  assert(hasDirectiveOnEdgeEnter(E) && "No directive found, use proper API.");
  return this->DirectiveEnterBBEdge[E];
}

list<Directive *> *DirectiveHeuristicsPass::getDirectiveOnEdgeLeave(
    pair<const MachineBasicBlock *, const MachineBasicBlock *> E) {
  assert(hasDirectiveOnEdgeLeave(E) && "No directive found, use proper API.");
  return this->DirectiveLeaveBBEdge[E];
}

} // namespace TimingAnalysisPass

namespace llvm {

FunctionPass *createDirectiveHeuristicsPass() {
  TimingAnalysisPass::DirectiveHeuristicsPassInstance =
      new TimingAnalysisPass::DirectiveHeuristicsPass();
  return TimingAnalysisPass::DirectiveHeuristicsPassInstance;
}

} // namespace llvm
