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

#ifndef MEMORYTOPOLOGYINTERFACE_H
#define MEMORYTOPOLOGYINTERFACE_H

#include "Memory/PersistenceScopeInfo.h"
#include "Util/AbstractAddress.h"
#include "Util/Util.h"

#include <boost/optional/optional.hpp>
#include <boost/type_traits.hpp>

#include <list>

namespace TimingAnalysisPass {

template <class DerivedMemoryTopology> class MemoryTopologyInterface {
public:
  /**
   * Defines an access.
   * Contains an id, an Interval, the AccessType (Load/Store) and the width in
   * words.
   */
  struct Access {
    unsigned id;
    AbstractAddress addr;
    AccessType load_store;
    unsigned numWords;
    Access(unsigned _id, AbstractAddress _addr, AccessType _load_store,
           unsigned _numWords)
        : id(_id), addr(_addr), load_store(_load_store), numWords(_numWords) {}
  };

  /**
   * Accesses an instruction in the memory. Returns a unique id which identifies
   * the access.
   */
  virtual boost::optional<unsigned> accessInstr(unsigned addr,
                                                unsigned numWords) = 0;

  /**
   * Accesses an instruction in the memory. Returns a unique id which identifies
   * the access.
   */
  virtual boost::optional<unsigned> accessData(AbstractAddress addr,
                                               AccessType load_store,
                                               unsigned numWords) = 0;

  /**
   * Performs a cycle on the memory architecture. Non-in-place. The original
   * memory should not be changed.
   *
   * The bool parameter says whether there are potential data misses pending
   * between the fetch and memory phase. A strictly in-order pipeline requires
   * stalling fetch misses.
   */
  virtual std::list<DerivedMemoryTopology>
  cycle(bool potentialDataMissesPending) const = 0;

  /**
   * Returns true if the pipeline (and memory topologies) should stall while
   * waiting for the background memory.
   *
   * This is determined after the memory already performed the cycle in which
   * the pipeline might be stalled. This is necessary, because the background
   * memory has to freedom to stop a stalling activity directly and perform
   * something else. For an example, see the BlockingCyclingMemory and how it
   * performs the split on bus blocking/non-blocking.
   */
  virtual bool shouldPipelineStall() const = 0;

  /**
   * Checks whether the given instruction access was finished.
   * If so, reset the associated finished access field.
   */
  virtual bool finishedInstrAccess(unsigned accessId) = 0;

  /**
   * Checks whether the given data access was finished.
   * If so, reset the associated finished access field.
   */
  virtual bool finishedDataAccess(unsigned accessId) = 0;

  /**
   * Enter a scope. By default do nothing.
   */
  virtual void enterScope(const PersistenceScope &scope){};
  /**
   * Leave a scope. By default do nothing.
   */
  virtual void leaveScope(const PersistenceScope &scope){};

  /**
   * Checks whether there are some unfinished accesses left in the memory.
   */
  virtual bool hasUnfinishedAccesses() const = 0;

  /**
   * Equality operator.
   */
  // TODO create join function for later use
  virtual bool operator==(const DerivedMemoryTopology &mt2) const = 0;

  /**
   * Hashes this topology.
   */
  virtual size_t hashcode() const = 0;

  /**
   * Is the memory topology waiting to be joined with similar topologies?
   *
   * The default value is false if not overwritten by something else.
   */
  virtual bool isWaitingForJoin() const { return false; }

  /**
   * Checks whether the given topology is similar enough to join it.
   */
  virtual bool isJoinable(const DerivedMemoryTopology &mt) const {
    return false;
  }

  /**
   * Joins the given topology with this one.
   */
  virtual void join(const DerivedMemoryTopology &mt) {
    assert(isJoinable(mt) && "Cannot join non-joinable memory topologies.");
  }

  /**
   * Is the memory topology currently performing an instruction access?
   */
  virtual bool isBusyAccessingInstr() const = 0;

  /**
   * Is the memory topology currently performing a data access?
   */
  virtual bool isBusyAccessingData() const = 0;

  /**
   * Fast-forwarding of the memory topology.
   */
  virtual std::list<DerivedMemoryTopology> fastForward() const = 0;

  static void outputAccess(std::ostream &stream, const Access &accessElem,
                           bool instruction, unsigned currentId) {

    int relId = accessElem.id - currentId;

    if (instruction) {
      // instruction access
      stream << "(Instruction, relative id: " << relId
             << ", Address: " << accessElem.addr << ")\n";
    } else {
      // data access
      stream << "(Data, relative id: " << relId
             << ", Address: " << accessElem.addr
             << ", Type: " << accessElem.load_store
             << ", numWords: " << accessElem.numWords << ")\n";
    }
  }

  static void hash_access(std::size_t &seed, const Access &ac,
                          unsigned currentId) {
    hash_combine(seed, ac.id - (currentId));
    AddressInterval addrItv = ac.addr.getAsInterval();
    hash_combine(seed, addrItv.lower());
    hash_combine(seed, addrItv.upper());
    hash_combine(seed, (int)(ac.load_store));
  }

  static bool areAccessIdsEqual(unsigned firstId, unsigned secondId,
                                unsigned firstCurrentId,
                                unsigned secondCurrentId) {
    return (firstId == 0 && secondId == 0) ||
           ((firstId != 0 && secondId != 0) &&
            (firstId - firstCurrentId) == (secondId - secondCurrentId));
  }

  /**
   * Returns whether queues of this object and the given objects are equal.
   */
  static bool areQueuesEqual(const std::list<Access> &queue1,
                             const std::list<Access> &queue2, unsigned id1,
                             unsigned id2) {
    // TODO this only works for single element queues
    return queue1.size() == queue2.size() &&
           (queue1.size() == 0 ||
            areAccessesEqual(queue1.front(), queue2.front(), id1, id2));
  }

  /**
   * Returns whether the given access optionals with respect to relative ids are
   * equal.
   */
  static bool areAccessElementsEqual(const boost::optional<Access> ac1,
                                     const boost::optional<Access> ac2,
                                     unsigned id1, unsigned id2) {
    return (!ac1 && !ac2) ||
           (ac1 && ac2 && areAccessesEqual(*ac1, *ac2, id1, id2));
  }

  /**
   * Returns whether the given access elements with respect to relative ids are
   * equal.
   */
  static bool areAccessesEqual(const Access ac1, const Access ac2, unsigned id1,
                               unsigned id2) {
    bool relIdEqual = ac1.id - id1 == ac2.id - id2;
    bool addrEqual = ac1.addr.isSameInterval(ac2.addr);
    bool typeEqual = ac1.load_store == ac2.load_store;
    bool numWordsEqual = ac1.numWords == ac2.numWords;

    return relIdEqual && addrEqual && typeEqual && numWordsEqual;
  }
};

/**
 * Class wrapping the hashcode() function, that each micorarchitectural state
 * class has to implement, to be used with unordered_(set|map|...). It
 * statically asserts that T must be a subclass of MemoryTopologyInterface.
 */
template <class T> class MemoryTopologyHash {
  BOOST_STATIC_ASSERT_MSG(
      (boost::is_base_of<MemoryTopologyInterface<T>, T>::value),
      "T must be a descendant of MemoryTopologyInterface");

public:
  size_t operator()(const T &t) const { return t.hashcode(); }
};

} // namespace TimingAnalysisPass

#endif
