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

#include "PartitionUtil/PartitionToken.h"
#include "Util/Util.h"

#include <sstream>

using namespace llvm;

namespace TimingAnalysisPass {

std::ostream &operator<<(std::ostream &stream, const PartitionToken &pt) {
  stream << pt.print();
  return stream;
}

void PartitionToken::setEnclosingDirective(Directive *d) { this->direc = d; }

Directive *PartitionToken::getEnclosingDirective() const { return this->direc; }

/// Partition Token None

PartitionTokenNone *PartitionTokenNone::instance = nullptr;

PartitionTokenNone::PartitionTokenNone() {}

PartitionTokenNone *PartitionTokenNone::getInstance() {
  if (instance == nullptr) {
    instance = new PartitionTokenNone();
  }
  return instance;
}

PartitionTokenType PartitionTokenNone::getType() const {
  return PartitionTokenType::NONE;
}

std::string PartitionTokenNone::print() const { return "None"; }

std::string PartitionTokenNone::serialize() const { return ":0"; }

bool PartitionTokenNone::equals(const PartitionToken &pt) const {
  return pt.getType() == PartitionTokenType::NONE;
}

bool PartitionTokenNone::less(const PartitionToken &pt) const {
  return PartitionTokenType::NONE < pt.getType();
}

/// Partition Token If

PartitionTokenIf::PartitionTokenIf(std::string branchInstrID, bool assumeTaken)
    : branchInstrID(branchInstrID), assumeTaken(assumeTaken) {}

PartitionTokenType PartitionTokenIf::getType() const {
  return PartitionTokenType::IF;
}

std::string PartitionTokenIf::print() const {
  std::stringstream ss;
  ss << "If (Branching) at instruction " << branchInstrID << " is ";
  if (!assumeTaken) {
    ss << "not ";
  }
  ss << "taken";
  return ss.str();
}

std::string PartitionTokenIf::serialize() const {
  std::stringstream ss;
  ss << ":IF_";
  if (!assumeTaken) {
    ss << "!";
  }
  ss << branchInstrID;
  return ss.str();
}

bool PartitionTokenIf::equals(const PartitionToken &pt) const {
  return pt.getType() == PartitionTokenType::IF;
}

bool PartitionTokenIf::less(const PartitionToken &pt) const {
  return PartitionTokenType::IF < pt.getType();
}

/// Partition Token LoopPeel

PartitionTokenLoopPeel::PartitionTokenLoopPeel(const MachineLoop *l,
                                               std::set<MBBedge> be, unsigned t)
    : loop(l), backedges(be), taken(t) {}

PartitionTokenType PartitionTokenLoopPeel::getType() const {
  return PartitionTokenType::LOOPPEEL;
}

unsigned PartitionTokenLoopPeel::backedgeTakenCount() const { return taken; }

bool PartitionTokenLoopPeel::hasBackedge(MBBedge edge) const {
  return backedges.count(std::make_pair(edge.first, edge.second)) > 0;
}

std::set<MBBedge> PartitionTokenLoopPeel::getBackedges() const {
  return backedges;
}

const MachineLoop *PartitionTokenLoopPeel::getLoop() const { return loop; }

std::string PartitionTokenLoopPeel::print() const {
  std::stringstream ss;
  ss << "Loop Peeling: Backedges {";
  for (auto it = backedges.begin(); it != backedges.end(); ++it) {
    ss << "(BB" << it->first->getNumber() << ", BB" << it->second->getNumber()
       << ")";
  }
  ss << "} in function "
     << backedges.begin()->first->getParent()->getName().str() << " taken "
     << taken << " times";
  return ss.str();
}

std::string PartitionTokenLoopPeel::serialize() const {
  std::stringstream ss;
  ss << ":LPEEL_{";
  for (auto it = backedges.begin(); it != backedges.end(); ++it) {
    ss << "(BB" << it->first->getNumber() << ", BB" << it->second->getNumber()
       << ")";
  }
  ss << "}_in_" << backedges.begin()->first->getParent()->getName().str() << "_"
     << taken;
  return ss.str();
}

bool PartitionTokenLoopPeel::equals(const PartitionToken &pt) const {
  if (pt.getType() != PartitionTokenType::LOOPPEEL)
    return false;
  auto &tok = dynamic_cast<const PartitionTokenLoopPeel &>(pt);
  return tok.taken == this->taken && tok.backedges == this->backedges;
}

bool PartitionTokenLoopPeel::less(const PartitionToken &pt) const {
  if (PartitionTokenType::LOOPPEEL != pt.getType()) {
    return PartitionTokenType::LOOPPEEL < pt.getType();
  }
  auto &tok = dynamic_cast<const PartitionTokenLoopPeel &>(pt);
  if (this->taken != tok.taken) {
    return this->taken < tok.taken;
  }
  if (this->backedges.size() != tok.backedges.size()) {
    return this->backedges.size() < tok.backedges.size();
  }
  auto thisbeit = this->backedges.begin();
  auto tokbeit = tok.backedges.begin();
  mbbedgecomp lessedge;
  while (thisbeit != this->backedges.end()) {
    if (lessedge(*thisbeit, *tokbeit) || lessedge(*tokbeit, *thisbeit)) {
      return lessedge(*thisbeit, *tokbeit);
    }
    ++thisbeit;
    ++tokbeit;
  }
  return false; // Are obviously equal
}

/// Partition Token LoopIter

PartitionTokenLoopIter::PartitionTokenLoopIter(const MachineLoop *l,
                                               std::set<MBBedge> be, unsigned t)
    : loop(l), backedges(be), taken(t) {}

PartitionTokenType PartitionTokenLoopIter::getType() const {
  return PartitionTokenType::LOOPITER;
}

unsigned PartitionTokenLoopIter::backedgeLeastTakenCount() const {
  return taken;
}

bool PartitionTokenLoopIter::hasBackedge(MBBedge edge) const {
  return backedges.count(std::make_pair(edge.first, edge.second)) > 0;
}

std::set<MBBedge> PartitionTokenLoopIter::getBackedges() const {
  return backedges;
}

const MachineLoop *PartitionTokenLoopIter::getLoop() const { return loop; }

std::string PartitionTokenLoopIter::print() const {
  std::stringstream ss;
  ss << "Loop Iteration: Backedges {";
  for (auto it = backedges.begin(); it != backedges.end(); ++it) {
    ss << "(BB" << it->first->getNumber() << ", BB" << it->second->getNumber()
       << ")";
  }
  ss << "} in function "
     << backedges.begin()->first->getParent()->getName().str()
     << " taken at least " << taken << " times";
  return ss.str();
}

std::string PartitionTokenLoopIter::serialize() const {
  std::stringstream ss;
  ss << ":LITER_{";
  for (auto it = backedges.begin(); it != backedges.end(); ++it) {
    ss << "(BB" << it->first->getNumber() << ", BB" << it->second->getNumber()
       << ")";
  }
  ss << "}_in_" << backedges.begin()->first->getParent()->getName().str() << "_"
     << taken;
  return ss.str();
}

bool PartitionTokenLoopIter::equals(const PartitionToken &pt) const {
  if (pt.getType() != PartitionTokenType::LOOPITER)
    return false;
  auto &tok = dynamic_cast<const PartitionTokenLoopIter &>(pt);
  return tok.taken == this->taken && tok.backedges == this->backedges;
}

bool PartitionTokenLoopIter::less(const PartitionToken &pt) const {
  if (PartitionTokenType::LOOPITER != pt.getType()) {
    return PartitionTokenType::LOOPITER < pt.getType();
  }
  auto &tok = dynamic_cast<const PartitionTokenLoopIter &>(pt);
  if (this->taken != tok.taken) {
    return this->taken < tok.taken;
  }
  if (this->backedges.size() != tok.backedges.size()) {
    return this->backedges.size() < tok.backedges.size();
  }
  auto thisbeit = this->backedges.begin();
  auto tokbeit = tok.backedges.begin();
  mbbedgecomp lessedge;
  while (thisbeit != this->backedges.end()) {
    if (lessedge(*thisbeit, *tokbeit) || lessedge(*tokbeit, *thisbeit)) {
      return lessedge(*thisbeit, *tokbeit);
    }
    ++thisbeit;
    ++tokbeit;
  }
  return false; // Are obviously equal
}

/// Partition Token CallSite

PartitionTokenCallSite::PartitionTokenCallSite(const MachineInstr *location)
    : callInstr(location) {}

PartitionTokenType PartitionTokenCallSite::getType() const {
  return PartitionTokenType::CALLSITE;
}

const MachineInstr *PartitionTokenCallSite::getCallSite() const {
  return this->callInstr;
}

std::string PartitionTokenCallSite::print() const {
  return "Function call at location " +
         getMachineInstrIdentifier(this->callInstr);
}

std::string PartitionTokenCallSite::serialize() const {
  return ":CSITE_" + getMachineInstrIdentifier(this->callInstr);
}

bool PartitionTokenCallSite::equals(const PartitionToken &pt) const {
  if (pt.getType() != PartitionTokenType::CALLSITE)
    return false;
  auto &tok = dynamic_cast<const PartitionTokenCallSite &>(pt);
  return tok.callInstr == this->callInstr;
}

bool PartitionTokenCallSite::less(const PartitionToken &pt) const {
  if (PartitionTokenType::CALLSITE != pt.getType()) {
    return PartitionTokenType::CALLSITE < pt.getType();
  }
  auto &tok = dynamic_cast<const PartitionTokenCallSite &>(pt);
  instrptrcomp lessinstr;
  return lessinstr(this->callInstr, tok.callInstr);
}

/// Partition Token FunCallee

PartitionTokenFunCallee::PartitionTokenFunCallee(
    const llvm::MachineFunction *func)
    : function(func) {}

PartitionTokenType PartitionTokenFunCallee::getType() const {
  return PartitionTokenType::FUNCALLEE;
}

std::string PartitionTokenFunCallee::print() const {
  return "Call of function " + this->function->getName().str();
}

std::string PartitionTokenFunCallee::serialize() const {
  return ":FUNCALL_" + this->function->getName().str();
}

bool PartitionTokenFunCallee::equals(const PartitionToken &pt) const {

  if (pt.getType() != PartitionTokenType::FUNCALLEE)
    return false;
  auto &tok = dynamic_cast<const PartitionTokenFunCallee &>(pt);
  return tok.function == this->function;
}

bool PartitionTokenFunCallee::less(const PartitionToken &pt) const {
  if (PartitionTokenType::FUNCALLEE != pt.getType()) {
    return PartitionTokenType::FUNCALLEE < pt.getType();
  }
  auto &tok = dynamic_cast<const PartitionTokenFunCallee &>(pt);
  return this->function->getFunctionNumber() <
         tok.function->getFunctionNumber();
}

} // end namespace TimingAnalysisPass
