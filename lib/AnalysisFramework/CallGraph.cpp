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

#include "AnalysisFramework/CallGraph.h"

#include "LLVMPasses/MachineFunctionCollector.h"
#include "LLVMPasses/TimingAnalysisMain.h"
#include "Util/Options.h"
#include "Util/Util.h"

#include "llvm/Support/Debug.h"

#include <boost/tokenizer.hpp>
#include <fstream>
#include <iostream>
#include <vector>

using namespace llvm;

namespace TimingAnalysisPass {

CallGraph *CallGraph::instance = nullptr;

CallGraph &CallGraph::getGraph() {
  if (instance == nullptr) {
    instance = new CallGraph();
    instance->recomputeCallGraph();
    if (ExtFuncAnnotations != "") {
      instance->parseAnnotationsExternalFunctions(ExtFuncAnnotations.c_str());
    }
  }
  return *instance;
}

void CallGraph::releaseInstance() { delete instance; }

std::string
CallGraph::getCalleeNameFromOperand(const MachineOperand &mo) const {
  if (mo.getType() == MachineOperand::MO_GlobalAddress) {
    // We have a call to a global target with this translation unit
    const Value *val = (const Value *)mo.getGlobal();
    return val->getName().str();
  } else if (mo.isSymbol()) {
    // External symbol, e.g. such as division, floating point stuff
    return mo.getSymbolName();
  } else {
    errs() << "[CallGraph Warning] Unknown type of call target operand: " << mo
           << "\n";
    assert(0 && "Illegal call target");
    return "ILLEGAL";
  }
}

void CallGraph::recomputeCallGraph() {
  // Fill the maps func->callsites, and callsites->callee
  for (auto currFunc : machineFunctionCollector->getAllMachineFunctions()) {
    for (auto currBB = currFunc->begin(); currBB != currFunc->end(); ++currBB) {
      for (auto currMI = currBB->begin(); currMI != currBB->end(); ++currMI) {
        if (currMI->isCall()) {
          callsitesPerMBB[&*currBB].push_back(&*currMI);

          // Get the call target operand
          MachineOperand &callTarget = currMI->getOperand(0);

          if (callTarget.getType() == MachineOperand::MO_GlobalAddress) {
            // We have a call to a global target with this translation unit
            const Value *val = (const Value *)currMI->getOperand(0).getGlobal();
            std::string functionName = val->getName().str();
            // If we have a definition for this function, it is okay
            if (machineFunctionCollector->hasFunctionByName(functionName)) {
              // Callee start block
              auto callee =
                  machineFunctionCollector->getFunctionByName(functionName);
              potentialCallSites[callee].push_back(&*currMI);
              potentialCallees[&*currMI].push_back(callee);
            } else {
              // We have an external library call. Only declaration via header.
              potentialExtCallSites[functionName].push_back(&*currMI);
            }
          } else if (callTarget.isSymbol()) {
            // External symbol, e.g. such as division, floating point stuff
            std::string funcName = callTarget.getSymbolName();
            // If there is a function for the external symbol (because we
            // llvm-linked the respective library), we treat it as normal
            // function
            if (machineFunctionCollector->hasFunctionByName(funcName)) {
              // Get callee and set the hooks
              auto callee =
                  machineFunctionCollector->getFunctionByName(funcName);
              potentialCallSites[callee].push_back(&*currMI);
              potentialCallees[&*currMI].push_back(callee);
            } else {
              potentialExtCallSites[funcName].push_back(&*currMI);
            }
          } else {
            errs()
                << "[CallGraph Warning] Possibly incorrect handling of call at "
                << getMachineInstrIdentifier(&*currMI) << "\n";
          }
        }
      }
    }
  }
}

bool CallGraph::reachableFromEntryPoint(const llvm::MachineFunction *MF) const {
  std::set<const llvm::MachineFunction *> reachableFunctions;
  std::set<const llvm::MachineFunction *> visited;
  std::set<const llvm::MachineFunction *> worklist;

  worklist.insert(getAnalysisEntryPoint());

  while (!worklist.empty()) {
    auto func = *worklist.begin();
    worklist.erase(worklist.begin());

    reachableFunctions.insert(func);
    visited.insert(func);
    for (auto &currMBB : *func) {
      for (auto callinstr : getCallSitesInMBB(&currMBB)) {
        for (auto callee : getPotentialCallees(callinstr)) {
          if (visited.count(callee) == 0) {
            worklist.insert(callee);
          }
        }
      }
    }
  }
  return reachableFunctions.count(MF) > 0;
}

void CallGraph::dumpUnknownExternalFunctions(std::ostream &mystream) const {
  for (auto ef : getAllExternalFunctions()) {
    mystream << ef << "|"
             << "<start address>"
             << "|"
             << "<max cycles/accesses/hits/misses>"
             << "\n";
  }
}

void CallGraph::parseAnnotationsExternalFunctions(const char *filename) {
  typedef boost::tokenizer<boost::escaped_list_separator<char>> Tokenizer;
  boost::escaped_list_separator<char> sep('\\', '|', '"');
  std::ifstream file(filename);
  if (!file.good()) {
    errs() << filename << "File could not be opened!\n";
    return;
  }
  for (std::string line; getline(file, line);) {
    std::vector<std::string> vect;
    Tokenizer token(line, sep);
    vect.assign(token.begin(), token.end());
    assert(vect.size() == 3 && "CSV file was corrupted!");
    std::string functionName = vect[0];
    unsigned startaddress, bound = 0;
    try {
      startaddress = std::stoi(vect[1], 0, 16); // hex number
      bound = std::stoi(vect[2]);
    } catch (const std::invalid_argument &e) {
      assert(0 && "CSV file was corrupted!");
    }
    VERBOSE_PRINT(functionName << " " << startaddress << " " << bound << "\n");
    extFunc2addr.insert(std::make_pair(functionName, startaddress));
    extFunc2bound.insert(std::make_pair(functionName, bound));
  }
}

bool CallGraph::callsExternal(const llvm::MachineInstr *MI) const {
  assert(MI->isCall() && "Calling instruction does not call anything!");
  const MachineOperand &callTarget = MI->getOperand(0);

  if (callTarget.isGlobal()) {
    // We have a call to a global target with this translation unit
    const Value *val = (const Value *)callTarget.getGlobal();
    std::string functionName = val->getName().str();
    return !machineFunctionCollector->hasFunctionByName(functionName);
  } else if (callTarget.isSymbol()) {
    // External symbol, e.g. such as division, floating point stuff
    std::string funcName = callTarget.getSymbolName();
    // If there is a function for the external symbol (because we llvm-linked
    // the respective library), we treat it as normal function
    return !machineFunctionCollector->hasFunctionByName(funcName);
  }

  assert(0 && "unreachable code reached");
  return false;
}

bool CallGraph::callsExternal(const MachineFunction *MF) const {
  std::set<const MachineFunction *> visited;
  std::set<const MachineFunction *> toVisit;
  toVisit.insert(MF);
  while (!toVisit.empty()) {
    const MachineFunction *func = *toVisit.begin();
    toVisit.erase(func);
    visited.insert(func);
    for (auto currMBB = func->begin(); currMBB != func->end(); ++currMBB) {
      for (auto &currMI : *currMBB) {
        if (currMI.isCall()) {
          if (callsExternal(&currMI)) {
            return true;
          } else {
            for (auto &callee : getPotentialCallees(&currMI)) {
              if (visited.count(callee) == 0) {
                toVisit.insert(callee);
              }
            }
          }
        }
      }
    }
  }
  return false;
}

bool CallGraph::callsNestedFunctions(const llvm::MachineInstr *MI,
                                     int d) const {
  assert(MI->isCall() && "Cannot ask for call depth for non-call instruction");
  if (d <
      0) { // If negative, unbounded callstrings, call depth is never exceeded
    return false;
  }
  if (d == 0) {
    return true; // No context sensitivity, one call is already to much
  }
  for (auto &callee : this->getPotentialCallees(MI)) {
    for (auto currMBB = callee->begin(); currMBB != callee->end(); ++currMBB) {
      for (auto &currMI : *currMBB) {
        if (currMI.isCall()) {
          if (d <= 1 || callsNestedFunctions(&currMI, d - 1)) {
            return true;
          }
        }
      }
    }
  }
  return false;
}

std::string
CallGraph::getExternalCalleeName(const llvm::MachineInstr *MI) const {
  assert(callsExternal(MI) && "There is no external callee");
  auto &callTarget = MI->getOperand(0);

  if (callTarget.isGlobal()) {
    // We have a call to a global target with this translation unit
    const Value *val = (const Value *)callTarget.getGlobal();
    std::string functionName = val->getName().str();
    return functionName;

  } else {
    assert(callTarget.isSymbol() && "No valid external function type");
    std::string functionName = callTarget.getSymbolName();
    return functionName;
  }
}

std::list<const MachineInstr *>
CallGraph::getCallSites(const MachineFunction *MF) const {
  std::list<const MachineInstr *> result;
  if (potentialCallSites.count(MF) > 0) { // We have callsites registered
    result = potentialCallSites.find(MF)->second;
  }
  return result;
}

std::list<const llvm::MachineInstr *>
CallGraph::getCallSitesInMBB(const llvm::MachineBasicBlock *MBB) const {
  std::list<const MachineInstr *> result;
  if (callsitesPerMBB.count(MBB) > 0) {
    result = callsitesPerMBB.find(MBB)->second;
  }
  return result;
}

std::list<const MachineFunction *>
CallGraph::getPotentialCallees(const MachineInstr *MI) const {
  std::list<const MachineFunction *> result;
  if (potentialCallees.count(MI) > 0) { // We have callees registered
    result = potentialCallees.find(MI)->second;
  }
  return result;
}

unsigned CallGraph::getExtFuncStartAddress(std::string ef) const {
  auto extFuncAddr = extFunc2addr.find(ef);

  if (extFuncAddr == extFunc2addr.end()) {
    errs() << "No start address for external function \"" << ef << "\" found\n";
    if (ExtFuncAnnotations == "") {
      errs() << "Use --ta-output-unknown-extfuncs to autogenerate a suitable "
                "annotations file\n";
    }
    abort();
  }
  return extFuncAddr->second;
}

std::list<const llvm::MachineInstr *>
CallGraph::getExtFuncCallSites(std::string ef) const {
  if (potentialExtCallSites.count(ef) > 0) { // We have callsites registered
    return potentialExtCallSites.find(ef)->second;
  }
  std::list<const MachineInstr *> result;
  return result;
}

std::list<std::string> CallGraph::getAllExternalFunctions() const {
  std::list<std::string> result;
  for (auto &ef2cs : potentialExtCallSites) {
    result.push_back(ef2cs.first);
  }
  return result;
}

unsigned CallGraph::getExtFuncBound(std::string ef) const {
  auto extFuncBound = extFunc2bound.find(ef);
  if (extFuncBound == extFunc2bound.end()) {
    errs() << "No bound for external function \"" << ef << "\" found\n";
    abort();
  }
  return extFuncBound->second;
}

void CallGraph::dump(std::ostream &mystream) const {
  mystream << "Call Graph for analysed program\n"
           << "-------------------------------\n\n";
  for (auto it = potentialCallees.begin(); it != potentialCallees.end(); ++it) {
    mystream << "From callsite " << getMachineInstrIdentifier(it->first)
             << " potentially calling ";
    mystream << "{";
    for (auto it2 = it->second.begin(); it2 != it->second.end(); ++it2) {
      mystream << (*it2)->getName().str();
      if (std::distance(it2, it->second.end()) > 1) {
        mystream << ", ";
      }
    }
    mystream << "}\n";
  }

  mystream << "\n";

  for (auto it = potentialCallSites.begin(); it != potentialCallSites.end();
       ++it) {
    mystream << "Callee " << it->first->getName().str()
             << " can be called from (and return to) ";
    mystream << "{";
    for (auto it2 = it->second.begin(); it2 != it->second.end(); ++it2) {
      mystream << getMachineInstrIdentifier(*it2);
      if (std::distance(it2, it->second.end()) > 1) {
        mystream << ", ";
      }
    }
    mystream << "}\n";
  }

  mystream << "\n";

  for (auto it = potentialExtCallSites.begin();
       it != potentialExtCallSites.end(); ++it) {
    mystream << "External Callee " << it->first
             << " can be called from (and return to) ";
    mystream << "{";
    for (auto it2 = it->second.begin(); it2 != it->second.end(); ++it2) {
      mystream << getMachineInstrIdentifier(*it2);
      if (std::distance(it2, it->second.end()) > 1) {
        mystream << ", ";
      }
    }
    mystream << "}\n";
  }
}

} // namespace TimingAnalysisPass
