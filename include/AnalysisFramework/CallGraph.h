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

#ifndef CALLGRAPH_H
#define CALLGRAPH_H

#include "ARM.h"

#include "Util/Util.h"

#include <map>
#include <set>

namespace TimingAnalysisPass {

/**
 * Class implementing the call graph according to the singleton design pattern.
 * It provides access to information such as potential callees for a callsite
 * and the respective callsites for each callee.
 */
class CallGraph {
public:
  /**
   * Provides access to the callgraph
   */
  static CallGraph &getGraph();
  static void releaseInstance();

  /**
   * Returns true if an external function is called.
   * This is either an external symbol (e.g. for division, floating point) or
   * a declared but not defined library function (from #include).
   */
  bool callsExternal(const llvm::MachineInstr *MI) const;
  bool callsExternal(const llvm::MachineFunction *MF) const;

  /**
   * Given a machine operand that represents the call target, return the
   * callee's name.
   */
  std::string getCalleeNameFromOperand(const llvm::MachineOperand &mo) const;

  /**
   * Retruns the name of the external callee, either a external symbol or a
   * library call.
   */
  std::string getExternalCalleeName(const llvm::MachineInstr *MI) const;

  /**
   * Get all possible call sites that might call the given function.
   */
  std::list<const llvm::MachineInstr *>
  getCallSites(const llvm::MachineFunction *MF) const;

  /**
   * Get all possible call sites per basic block.
   */
  std::list<const llvm::MachineInstr *>
  getCallSitesInMBB(const llvm::MachineBasicBlock *MBB) const;

  /**
   * Does this instruction call a function that leads to a call that is nested
   * more than d?
   */
  bool callsNestedFunctions(const llvm::MachineInstr *MI, int d) const;

  /**
   * Get all potential callees per call site.
   */
  std::list<const llvm::MachineFunction *>
  getPotentialCallees(const llvm::MachineInstr *MI) const;

  /**
   * Get the start address of the given external function.
   */
  unsigned getExtFuncStartAddress(std::string ef) const;
  /**
   * Get the bound on execution time or on number of accesses/hits/misses for
   * given external function.
   */
  unsigned getExtFuncBound(std::string ef) const;

  /**
   * Get all posible call sites of the given external function.
   */
  std::list<const llvm::MachineInstr *>
  getExtFuncCallSites(std::string ef) const;
  /**
   * Returns all external functions that are called in this program.
   */
  std::list<std::string> getAllExternalFunctions() const;

  /**
   * Is the given function reachable (by transitive calls) from the entrypoint?
   */
  bool reachableFromEntryPoint(const llvm::MachineFunction *MF) const;

  /**
   * Dumps unknown external functions calls if desired.
   */
  void dumpUnknownExternalFunctions(std::ostream &mystream) const;

  /**
   * Dump the call graph to the given stream.
   */
  void dump(std::ostream &mystream) const;

private:
  // The normal constructors and assignment operator are private to enforce
  // singleton-property
  CallGraph() {}
  CallGraph(const CallGraph &);
  CallGraph &operator=(CallGraph const &) { return *this; };

  /**
   * (Re-)Computes the call graph from information provided by
   * machineFunctionCollector.
   */
  void recomputeCallGraph();
  /**
   * Parses the annotations provided for external functions.
   */
  void parseAnnotationsExternalFunctions(const char *filename);

  /**
   * The one and only instance
   */
  static CallGraph *instance;

  /**
   * Remember the set of possible callee functions for each callsite.
   */
  std::map<const llvm::MachineInstr *, std::list<const llvm::MachineFunction *>,
           instrptrcomp>
      potentialCallees;
  /**
   * For each function remember the set of possible callsites,
   * i.e. the points this function could return to.
   */
  std::map<const llvm::MachineFunction *, std::list<const llvm::MachineInstr *>,
           machfunccomp>
      potentialCallSites;

  std::map<const llvm::MachineBasicBlock *,
           std::list<const llvm::MachineInstr *>>
      callsitesPerMBB;

  /**
   * For each external function remember the set of possible callsites.
   */
  std::map<const std::string, std::list<const llvm::MachineInstr *>>
      potentialExtCallSites;

  /**
   * Maps external functions to their start address.
   */
  std::map<const std::string, unsigned> extFunc2addr;
  /**
   * Maps external functions to the maximal number of cycles spent inside.
   */
  std::map<const std::string, unsigned> extFunc2bound;
};

} // namespace TimingAnalysisPass

#endif
