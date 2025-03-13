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

#ifndef TIMINGANALYSIS_UTIL_H
#define TIMINGANALYSIS_UTIL_H

#include "ARM.h"
#include "ARMMachineFunctionInfo.h"
#include "MCTargetDesc/ARMBaseInfo.h"
#include "llvm/CodeGen/MachineLoopInfo.h"
#include "llvm/Support/Format.h"
#include <boost/format.hpp>

#include <iostream>
#include <list>
#include <map>
#include <set>
#include <sstream>
#include <unordered_set>

#include <boost/numeric/interval.hpp>
#include <boost/optional/optional.hpp>

using namespace llvm;

// Forward declaration
namespace TimingAnalysisPass {
class Context;
}
namespace std {
template <> struct hash<TimingAnalysisPass::Context>;
}

#define VERBOSE_PRINT(X)                                                       \
  do {                                                                         \
    if (!QuietMode) {                                                          \
      outs() << X;                                                             \
    }                                                                          \
  } while (0)
namespace TimingAnalysisPass {

extern unsigned debugDumpNo;

/**
 * An edge describes the connection between two vertices in the graph given by
 * their ids.
 */
typedef std::pair<unsigned, unsigned> GraphEdge;

/**
 * Own version of boost::hash_combine to work with std::hash
 */
template <class T>
inline void hash_combine(
    typename std::enable_if<!std::is_enum<T>::value, std::size_t>::type &seed,
    const T &v) {
  std::hash<T> hasher;
  seed ^= hasher(v) + 0x9e3779b9 + (seed << 6) + (seed >> 2);
}

template <class T>
inline void hash_combine(
    typename std::enable_if<std::is_enum<T>::value, std::size_t>::type &seed,
    const T &v) {
  std::hash<typename std::underlying_type<T>::type> hasher;
  seed ^= hasher(v) + 0x9e3779b9 + (seed << 6) + (seed >> 2);
}

template <class T>
inline void hash_combine_hashcode(std::size_t &seed, const T &v) {
  seed ^= v.hashcode() + 0x9e3779b9 + (seed << 6) + (seed >> 2);
}

/**
 * Different possibilities to initialize an element of an analysis domain.
 * BOTTOM, TOP for bottom and top element of the lattice or
 * START to get the start value of the overall analysis (analysis-entrypoint).
 */
enum class AnaDomInit {
  BOTTOM, /// Bottom element aka not reachable
  TOP,    /// Top element aka everything is possible
  START   /// Start element, the initial value the analysis should start with
};

/**
 * Returns the operand that corresponds to the target basic block of the given
 * branch.
 */
const MachineOperand &getBranchTargetOperand(const MachineInstr *MI);

/**
 * Is the given instruction MI a branch to a jumptable entry.
 */
bool isJumpTableBranch(const MachineInstr *MI);

/**
 * Return the index of the jump table of jumptable instructions.
 */
int getJumpTableIndex(const MachineInstr *MI);

/**
 * Is the given instruction a prefetch instruction.
 */
bool isPrefetch(const MachineInstr *MI);

/**
 * A class describing the different outcomes of a branch
 */
class BranchOutcome {
public:
  static BranchOutcome nottaken() {
    BranchOutcome bo;
    return bo;
  }
  static BranchOutcome taken(const MachineBasicBlock *target) {
    BranchOutcome bo;
    bo.btaken = true;
    bo.target = target;
    return bo;
  }
  static BranchOutcome taken() {
    BranchOutcome bo;
    bo.btaken = true;
    return bo;
  }

private:
  BranchOutcome() : btaken(false), target(boost::none) {}

public:
  bool btaken;
  boost::optional<const MachineBasicBlock *> target;

  bool operator==(const BranchOutcome &bo) const {
    return btaken == bo.btaken && target == bo.target;
  }
};

/// Output for branch outcome
std::ostream &operator<<(std::ostream &stream, const BranchOutcome &bo);

/**
 * There are several types of caches.
 */
enum class CacheType {
  INSTRUCTION, /// This is an instruction cache
  DATA,        /// This is a data cache
  UNIFIED,     /// This is a unified instruction and data cache
};

/**
 * Possible memory access types.
 */
enum class AccessType {
  LOAD, /// Load something from memory
  STORE /// Store something to memory
};

template <typename streamtype>
streamtype &operator<<(streamtype &stream, const AccessType type) {
  switch (type) {
  case AccessType::LOAD:
    stream << "LOAD";
    break;
  case AccessType::STORE:
    stream << "STORE";
    break;
  }
  return stream;
}

// Mapping from instruction of existing contexts at that point
typedef std::map<const MachineInstr *, std::unordered_set<Context>>
    InstrContextMapping;

typedef std::pair<const MachineBasicBlock *, const MachineBasicBlock *> MBBedge;
typedef std::set<const MachineBasicBlock *> MBBset;

/**
 * Give a unique identifier string for the given instruction.
 * The identifier is of form functionName_basicBlockNumber_positionInBasicBlock.
 */
std::string getMachineInstrIdentifier(const MachineInstr *I);
/**
 * Return true if we have a predicated instruction. False, otherwise.
 */
bool isPredicated(const MachineInstr *I);

/// The bits indicating whether we have offset, pre-, or post-indexed addressing
static inline unsigned getIndexMode(const MachineInstr *MI) {
  return (MI->getDesc().TSFlags & ARMII::IndexModeMask) >>
         ARMII::IndexModeShift;
}

/**
 * Give a unique identifier string for the given machine basic block.
 * The identifier is of form functionName_basicBlockNumber.
 */
std::string getBasicBlockIdentifier(const MachineBasicBlock *MBB);

/// Keep the maps below in good order
struct instrptrcomp {
  bool operator()(const MachineInstr *const lhs,
                  const MachineInstr *const rhs) const;
};

struct mbbComp {
  bool operator()(const MachineBasicBlock *const lhs,
                  const MachineBasicBlock *const rhs) const;
};
struct mbbedgecomp {
  bool operator()(const MBBedge &lhs, const MBBedge &rhs) const;
};
struct machfunccomp {
  bool operator()(const MachineFunction *const lhs,
                  const MachineFunction *const rhs) const;
};
struct glvarcomp {
  bool operator()(const GlobalVariable *const lhs,
                  const GlobalVariable *const rhs) const;
};

/**
 * Returns true if an instruction is a pseudo instruction, i.e. is eliminated
 * during output or degenerates to different ARM instructions.
 */
inline bool isPseudoInstruction(const MachineInstr *MI) {
  return (MI->getDesc().TSFlags & ARMII::FormMask) == ARMII::Pseudo;
}

/**
 * Returns true if the basic block is empty, i.e. does not contain any real
 * instruction (but might have debug instructions)
 */
bool isBasicBlockEmpty(const MachineBasicBlock *MBB);

/**
 * Return the first/last non-transient instruction in given basic block.
 */
const MachineInstr *getFirstInstrInBB(const MachineBasicBlock *MBB);
const MachineInstr *getLastInstrInBB(const MachineBasicBlock &MBB);
/**
 * Return the first non-transient instruction in the given function.
 */
const MachineInstr *
getFirstInstrInFunction(const MachineFunction *MF,
                        std::list<MBBedge> &initialedgelist);

bool isEndInstr(const MachineBasicBlock &mbb, const MachineInstr *mi);

std::vector<const MachineInstr *>
getAllEndInstrInMBB(const MachineBasicBlock *mbb);

/**
 * Returns a set of lists of edges between the given basic blocks.
 * If there is more than one element in the set, there are multiple paths with
 * empty BB between the two. Any Basic Blocks in between the given ones have to
 * be empty.
 */
std::set<std::list<MBBedge>> *getEdgesBetween(const MachineBasicBlock *MBB1,
                                              const MachineBasicBlock *MBB2);
/**
 * Returns all non-empty successors of a basic block
 */
std::set<MachineBasicBlock *>
getNonEmptySuccessorBasicBlocks(const MachineBasicBlock &mbb);
/**
 * Returns the non-empty successor of an empty basic-block
 */
const MachineBasicBlock *
getNonEmptySuccessorBasicBlock(const MachineBasicBlock *mbb);
/**
 * Returns the non-empty predecessors of a basic-block
 */
std::set<const MachineBasicBlock *, mbbComp>
getNonEmptyPredecessorBasicBlocks(const MachineBasicBlock *mbb);
/**
 * Finds out if a function is reachable from a given set of basic blocks.
 */
bool isFunctionPotentiallyReachableFrom(
    const MachineFunction *target,
    const std::vector<const MachineBasicBlock *> &basicBlocks);

/**
 * Outputs a set of MachineBasicBlocks
 */
std::ostream &operator<<(std::ostream &stream,
                         const std::set<const MachineBasicBlock *> set);

/**
 * Outputs sets/multisets of global variables.
 * TODO this should be generalized (I was not able to do so)
 * ALso, this should be written as operator<<, but doing so only gave me
 * >1000 error messages(!)
 */

static inline void printSet(std::ostream &stream,
                            std::set<const GlobalVariable *> set) {
  stream << "{";
  bool first = true;
  for (const GlobalVariable *entry : set) {
    if (!first) {
      stream << ", ";
    }
    stream << entry->getName().str();
    first = false;
  }
  stream << "}";
}
static inline void printMultiSet(std::ostream &stream,
                                 std::multiset<const GlobalVariable *> set) {
  stream << "{";
  bool first = true;
  for (const GlobalVariable *entry : set) {
    if (!first) {
      stream << ", ";
    }
    stream << entry->getName().str();
    first = false;
  }
  stream << "}";
}

/* stream-specific hex printing function. Prints value as a hexadecimal number
 * without prefixing and (if necessary) extended to WIDTH. values longer than
 * the width are printed in full anyway */
llvm::raw_ostream &printHex(llvm::raw_ostream &stream, unsigned value,
                            unsigned width = 1);
std::ostream &printHex(std::ostream &stream, unsigned value,
                       unsigned width = 1);

///////////////////////////////////////////////
// Helper Functions for llvm_loop operations //
///////////////////////////////////////////////
/**
 * Get the incoming edges of the loop, i.e. edges starting outside the loop and
 * ending inside
 */
std::set<MBBedge> getIncomingEdgesOfLoop(const llvm::MachineLoop *loop);
/**
 * Get the exiting edges of the loop, i.e. edges starting inside the loop and
 * ending outside
 */
std::set<MBBedge> getExitingEdgesOfLoop(const llvm::MachineLoop *loop);
/**
 * Get the Backedges for a given loop
 */
std::set<MBBedge> getBackEdgesOfLoop(const llvm::MachineLoop *loop);

/**
 * Extract the filename from a debug location.
 */
std::string getFilenameFromDebugLoc(const llvm::DebugLoc &dbgLoc);

//////////////////////
// System functions //
//////////////////////

/**
 * Get peak Memory Usage up to now
 */
long getPeakRSS();

/**
 * @brief executes a shell command and returns its output
 *
 * @param Command
 * @return std::string
 */
std::string exec(std::string Command);
} // namespace TimingAnalysisPass

#endif
