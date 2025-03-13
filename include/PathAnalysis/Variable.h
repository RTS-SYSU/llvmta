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

#ifndef VARIABLE_H
#define VARIABLE_H

#include <functional>
#include <sstream>
#include <string>

namespace TimingAnalysisPass {

class Variable {

  /**
   * =====================
   * Scope-specific stuff.
   * =====================
   */

private:
  /**
   * The available scope types.
   * A scope type defines to what the value of a variable
   * refers. E.g. to an edge in the graph.
   */
  enum ScopeType : char;

  /**
   * For each scope type, there is a defined way how a variable
   * of that type has to be dealt with when copying, how the stuff
   * which defines the scope is represented in the variable name
   * and how this stuff is compared in order to obtain a total
   * order over all variables of the same type.
   */
  typedef struct {
    std::function<void(const Variable &orig, Variable &copy)> copy;
    std::function<std::string(const Variable &var)> toString;
    std::function<bool(const Variable &left, const Variable &right)> isLess;
  } ScopeTypeInfoEntry;
  static ScopeTypeInfoEntry ScopeTypeInfo[];

  /**
   * A public factory function per scope type.
   */
public:
  enum Type : char; // forward declaration
  static Variable getGlobalVar(Type type);
  static Variable getEdgeVar(Type type, std::pair<unsigned, unsigned> edgeId);
  static Variable getNodeVar(Type type, unsigned nodeId);

  /**
   * =====================
   * Type-specific stuff.
   * =====================
   */
private:
  /**
   * Possible choice for allowed values of a
   * variable of a particular variable type.
   */
  enum AllowedValues : char;

public:
  /**
   * The available variable types.
   */
  enum Type : char {
    timesTaken = 0,
    isStart = 1,
    isEnd = 2,
    timesTakenSub = 3,
    containsProgStart = 4,
    maxTime = 5,
    maxNumRefreshes = 6,
    blockedCycleLoopTimesTaken = 7,
    maxAccessCycles = 8,
    maxBusInterference = 9,
    maxAddInstrMissPreemption = 10,
    maxAddDataMissPreemption = 11,
    // the number of dirtifying stores in the execution trace
    dirtifyingStores = 12,
    // The number of writebacks in the execution trace
    writebacks = 13
    // Feel free to add types.
    // But don't forget to add corresponding entries
    // to Variable::TypeInfo in Variable.cpp!
  };

private:
  /**
   * For each variable type we can define a few things.
   */
  typedef struct {
    const char *namePrefix;
    ScopeType scopeType;
    AllowedValues allowedValues;
  } TypeInfoEntry;
  static TypeInfoEntry TypeInfo[];

  /**
   * =====================
   * Variable-specific stuff.
   * =====================
   */

  /**
   * Construction is only possibly through public factories.
   * Or by copying an existing object.
   */
private:
  Variable();

public:
  Variable(const Variable &var);
  Variable &operator=(const Variable &var);
  ~Variable();

  /**
   * Public member functions.
   */
public:
  std::string getName() const;
  bool operator<(const Variable &var) const;
  bool operator==(const Variable &var) const;
  bool isBinary() const;
  bool isInteger() const;
  bool isFloatingPoint() const;

  std::pair<unsigned, unsigned> getEdgeIds() const;
  unsigned getNodeId() const;

  /**
   * Private member fields.
   */
private:
  Type type;
  union {
    // global = 0
    /* No field needed. */
    // edge = 1
    std::pair<unsigned, unsigned> edgeId;
    // node = 2
    unsigned nodeId;
  };
};

} // namespace TimingAnalysisPass

#endif
