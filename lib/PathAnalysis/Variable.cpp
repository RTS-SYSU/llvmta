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

#include "PathAnalysis/Variable.h"

#include <sstream>
#include <string>

#include <cassert>

namespace TimingAnalysisPass {

/**
 * =====================
 * Scope-specific stuff.
 * =====================
 */

/**
 * The available scope types.
 * A scope type defines to what the value of a variable
 * refers. E.g. to an edge in the graph.
 */
enum Variable::ScopeType : char {
  global = 0,
  edge = 1,
  node = 2
  // Feel free to add scopes
};

/**
 * For each scope type, there is a defined way how a variable
 * of that type has to be dealt with when copying, how the stuff
 * which defines the scope is represented in the variable name
 * and how this stuff is compared in order to obtain a total
 * order over all variables of the same type.
 */
Variable::ScopeTypeInfoEntry Variable::ScopeTypeInfo[] = {
    // global = 0
    {/**
      * Nothing to clone.
      */
     [](const Variable &orig, Variable &copy) {},
     /**
      * There is only one instance for the whole program.
      * No further distinction needed.
      */
     [](const Variable &var) { return ""; },
     /**
      * As there is only one instance, it is always equal to itself.
      */
     [](const Variable &left, const Variable &right) { return false; }},
    // edge = 1
    {/**
      * Copy the edge id.
      */
     [](const Variable &orig, Variable &copy) { copy.edgeId = orig.edgeId; },
     /**
      * Write out start and end id of the edge.
      */
     [](const Variable &var) {
       std::stringstream strstr;
       strstr << "_v" << var.edgeId.first << "_v" << var.edgeId.second;
       return strstr.str();
     },
     /**
      * Compare start and end ids of the edges.
      */
     [](const Variable &left, const Variable &right) {
       return left.edgeId.first < right.edgeId.first ||
              (left.edgeId.first == right.edgeId.first &&
               left.edgeId.second < right.edgeId.second);
     }},
    // node = 2
    {/**
      * Copy the node id.
      */
     [](const Variable &orig, Variable &copy) { copy.nodeId = orig.nodeId; },
     /**
      * Write out the node id.
      */
     [](const Variable &var) {
       std::stringstream strstr;
       strstr << "_v" << var.nodeId;
       return strstr.str();
     },
     /**
      * Compare start and end ids of the edges.
      */
     [](const Variable &left, const Variable &right) {
       return left.nodeId < right.nodeId;
     }}};

/**
 * A public factory function per scope type.
 */
Variable Variable::getGlobalVar(Type type) {
  assert(TypeInfo[type].scopeType == ScopeType::global &&
         "Expected variable type of global scope.");
  Variable var;
  var.type = type;
  return var;
}
Variable Variable::getEdgeVar(Type type, std::pair<unsigned, unsigned> edgeId) {
  assert(TypeInfo[type].scopeType == ScopeType::edge &&
         "Expected variable type of edge scope.");
  Variable var;
  var.type = type;
  var.edgeId = edgeId;
  return var;
}
Variable Variable::getNodeVar(Type type, unsigned nodeId) {
  assert(TypeInfo[type].scopeType == ScopeType::node &&
         "Expected variable type of node scope.");
  Variable var;
  var.type = type;
  var.nodeId = nodeId;
  return var;
}

/**
 * =====================
 * Type-specific stuff.
 * =====================
 */
/**
 * Possible choice for allowed values of a
 * variable of a particular variable type.
 */
enum Variable::AllowedValues : char { binary, integer, floating_point };

/**
 * For each variable type we can define a few things.
 */
Variable::TypeInfoEntry Variable::TypeInfo[] = {
    // timesTaken = 0
    {"timesTaken", ScopeType::edge, AllowedValues::integer},
    // isStart = 1
    {"isStart", ScopeType::edge, AllowedValues::binary},
    // isEnd = 2
    {"isEnd", ScopeType::edge, AllowedValues::binary},
    // timesTakenSub = 3
    {"timesTakenSub", ScopeType::edge, AllowedValues::integer},
    // containsProgStart = 4
    {"containsProgStart", ScopeType::global, AllowedValues::binary},
    // maxTime = 5
    {"maxTime", ScopeType::global, AllowedValues::integer},
    // maxNumRefreshes = 6
    {"maxNumRefreshes", ScopeType::global, AllowedValues::integer},
    // blockedCycleLoopTimesTaken = 7
    {"blockedCycleLoopTimesTaken", ScopeType::global, AllowedValues::integer},
    // maxAccessCycles = 8
    {"maxAccessCycles", ScopeType::global, AllowedValues::integer},
    // maxBusInterference = 9
    {"maxBusInterference", ScopeType::global, AllowedValues::integer},
    // maxAddInstrMissPreemption = 10
    {"maxAddInstrMissPreemption", ScopeType::global, AllowedValues::integer},
    // maxAddDataMissPreemption = 11
    {"maxAddDataMissPreemption", ScopeType::global, AllowedValues::integer},
    // dirtifyingStores = 12
    {"dirtifyingStores", ScopeType::global, AllowedValues::integer},
    // writebacks = 13
    {"writebacks", ScopeType::global, AllowedValues::integer}};

/**
 * =====================
 * Variable-specific stuff.
 * =====================
 */

/**
 * Construction is only possibly through public factories.
 * Or by copying an existing object.
 */
Variable::Variable() {}

Variable::Variable(const Variable &var) {
  // reuse assignment for simplicity
  *this = var;
}

Variable &Variable::operator=(const Variable &var) {
  // the type is always copied
  type = var.type;
  // the remainder depends on the scope
  // type of the right-hand side object
  auto &typeInfo = TypeInfo[type];
  auto &scopeTypeInfo = ScopeTypeInfo[typeInfo.scopeType];
  scopeTypeInfo.copy(var, *this);
  return *this;
}

Variable::~Variable() {}

/**
 * Public member functions.
 */
std::string Variable::getName() const {
  auto &typeInfo = TypeInfo[type];
  auto &scopeTypeInfo = ScopeTypeInfo[typeInfo.scopeType];
  std::stringstream strstr;
  strstr << typeInfo.namePrefix << scopeTypeInfo.toString(*this);
  return strstr.str();
}

bool Variable::operator<(const Variable &var) const {
  if (type < var.type) {
    return true;
  }
  if (type > var.type) {
    return false;
  }
  auto &scopeTypeInfo = ScopeTypeInfo[TypeInfo[type].scopeType];
  return scopeTypeInfo.isLess(*this, var);
}

bool Variable::operator==(const Variable &var) const {
  // Rely on total order operator
  return (!(*this < var)) && (!(var < *this));
}

bool Variable::isBinary() const {
  return TypeInfo[type].allowedValues == AllowedValues::binary;
}

bool Variable::isInteger() const {
  return TypeInfo[type].allowedValues == AllowedValues::integer;
}

bool Variable::isFloatingPoint() const {
  return TypeInfo[type].allowedValues == AllowedValues::floating_point;
}

std::pair<unsigned, unsigned> Variable::getEdgeIds() const {
  assert(TypeInfo[this->type].scopeType == ScopeType::edge);
  return this->edgeId;
}

unsigned Variable::getNodeId() const {
  assert(TypeInfo[this->type].scopeType == ScopeType::node);
  return this->nodeId;
}

} // namespace TimingAnalysisPass
