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

#ifndef PERSISTENCESCOPEINFO_H
#define PERSISTENCESCOPEINFO_H

#include "ARM.h"
#include "llvm/CodeGen/MachineLoopInfo.h"

#include "Util/PersistenceScope.h"
#include "Util/Util.h"

#include <iostream>
#include <list>
#include <map>
#include <set>

namespace TimingAnalysisPass {

/**
 * Machine function pass that extracts information about potential persistence
 * scopes from all machine loops in the program.
 */
class PersistenceScopeInfo {

public:
  /**
   * Provides access to the callgraph
   */
  static PersistenceScopeInfo &getInfo();

  /**
   * Dump the computed scopes with entry and exit points.
   */
  void dump(std::ostream &mystream) const;

  /**
   * Does the given instruction enter/leave a persistence scope?
   */
  bool entersScope(const MBBedge edge) const;
  bool leavesScope(const MBBedge edge) const;

  /**
   * Returns the persistence scope the given instruction enters/leaves - if any.
   */
  std::set<PersistenceScope> getEnteringScopes(const MBBedge edge) const;
  std::set<PersistenceScope> getLeavingScopes(const MBBedge edge) const;

  /**
   * Returns a set of all known persistence scopes.
   */
  std::set<PersistenceScope> getAllPersistenceScopes() const;

private:
  // The normal constructors and assignment operator are private to enforce
  // singleton-property
  PersistenceScopeInfo();
  PersistenceScopeInfo(const PersistenceScopeInfo &); // not implemented
  PersistenceScopeInfo &
  operator=(PersistenceScopeInfo const &); // not implemented

  /**
   * Walk on loop and decide whether this is a good scope or not.
   */
  void walkMachineLoop(const llvm::MachineLoop *loop);

  /**
   * Does an instruction start a new scope?
   */
  std::map<const MBBedge, std::set<PersistenceScope>, mbbedgecomp> startScope;
  /**
   * Does an instruction end a scope?
   */
  std::map<const MBBedge, std::set<PersistenceScope>, mbbedgecomp> endScope;

  /**
   * We have a singleton.
   */
  static PersistenceScopeInfo *persistenceScopeInfo;
};

} // namespace TimingAnalysisPass

#endif
