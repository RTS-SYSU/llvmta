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

#ifndef SEPARATEMEMORIESTOPOLOGY_H
#define SEPARATEMEMORIESTOPOLOGY_H

#include "llvm/Support/Debug.h"

#include "Memory/MemoryTopologyInterface.h"
#include <list>

namespace TimingAnalysisPass {

/**
 * Class representing a memory topology with two separate memories for
 * instructions and data.
 *
 * The template value parameters makeInstrMem and makeDataMem are pointers to
 * functions that create an object of a class inheriting from
 * AbstractCyclingMemory on the heap and that return a pointer to the created
 * object.
 */
template <AbstractCyclingMemory *(*makeInstrMem)(),
          AbstractCyclingMemory *(*makeDataMem)()>
class SeparateMemoriesTopology
    : public MemoryTopologyInterface<
          SeparateMemoriesTopology<makeInstrMem, makeDataMem>> {
public:
  SeparateMemoriesTopology();

  SeparateMemoriesTopology(const SeparateMemoriesTopology &smt2);

  SeparateMemoriesTopology &operator=(const SeparateMemoriesTopology &smt2);

  ~SeparateMemoriesTopology();

  /**
   * Container used to make the local metrics of this class
   * available to the world outside.
   */
  struct LocalMetrics {
    // the fields added to the local metrics used as base
    typename AbstractCyclingMemory::LocalMetrics *instructionMemory;
    typename AbstractCyclingMemory::LocalMetrics *dataMemory;

    /**
     * Creates the local metrics based on the
     * outer class' content.
     */
    LocalMetrics(const SeparateMemoriesTopology &outerClassInstance)
        : instructionMemory(
              outerClassInstance.instructionMemory->getLocalMetrics()),
          dataMemory(outerClassInstance.dataMemory->getLocalMetrics()) {}

    ~LocalMetrics() {
      delete instructionMemory;
      delete dataMemory;
    }

    /**
     * Checks for equality between local metrics.
     */
    bool operator==(const LocalMetrics &anotherInstance) {
      return instructionMemory->equals(*anotherInstance.instructionMemory) &&
             dataMemory->equals(*anotherInstance.dataMemory);
    }
  };

  /**
   * Resets the local metrics to their initial values.
   */
  void resetLocalMetrics() {
    instructionMemory->resetLocalMetrics();
    dataMemory->resetLocalMetrics();
  }

  /**
   * Tells the memory topology to access an instruction.
   * Returns the id for that instruction or none, if something is already
   * accessed.
   */
  virtual boost::optional<unsigned> accessInstr(unsigned addr,
                                                unsigned numWords);

  /**
   * Tells the memory topology to access an instruction.
   * Returns the id for that instruction or none, if something is already
   * accessed.
   */
  virtual boost::optional<unsigned>
  accessData(AbstractAddress addr, AccessType load_store, unsigned numWords);

  /**
   * Cycle method for the memory topology.
   * This method should be called by the pipeline.
   *
   * The bool parameter says whether there are potential data misses pending
   * between the fetch and memory phase. A strictly in-order pipeline requires
   * stalling fetch misses.
   *
   * Returns a list of resulting memory topology states.
   */
  virtual std::list<SeparateMemoriesTopology>
  cycle(bool potentialDataMissesPending) const;

  /// Not supported
  virtual bool shouldPipelineStall() const;

  /**
   * Returns whether a given ID (instruction access) has been finished.
   */
  virtual bool finishedInstrAccess(unsigned accessId);

  /**
   * Returns whether a given ID (data access) has been finished.
   */
  virtual bool finishedDataAccess(unsigned accessId);

  virtual bool hasUnfinishedAccesses() const;

  virtual bool operator==(const SeparateMemoriesTopology &smt2) const;

  virtual size_t hashcode() const;

  virtual bool isJoinable(const SeparateMemoriesTopology &smt2) const;

  virtual void join(const SeparateMemoriesTopology &smt2);

  /**
   * Is the memory topology currently performing an instruction access?
   */
  virtual bool isBusyAccessingInstr() const;

  /**
   * Is the memory topology currently performing a data access?
   */
  virtual bool isBusyAccessingData() const;

  /**
   * Fast-forwarding of the memory topology.
   */
  virtual std::list<SeparateMemoriesTopology> fastForward() const;

  template <AbstractCyclingMemory *(*makeInstrMemf)(),
            AbstractCyclingMemory *(*makeDataMemf)()>
  friend std::ostream &
  operator<<(std::ostream &stream,
             const SeparateMemoriesTopology<makeInstrMemf, makeDataMemf> &smt2);

private:
  /**
   * Increments the current ID.
   * Skips 0.
   */
  void incrementCurrentId();

  typedef
      typename MemoryTopologyInterface<SeparateMemoriesTopology>::Access Access;

  typedef MemoryTopologyInterface<
      SeparateMemoriesTopology<makeInstrMem, makeDataMem>>
      Super;

  /**
   * Accesses the memory with the given element.
   * Returns a list of resulting memory topology states.
   */
  std::list<SeparateMemoriesTopology>
  accessInstrMemory(Access accessElement) const;

  /**
   * Accesses the memory with the given element.
   * Returns a list of resulting memory topology states.
   */
  std::list<SeparateMemoriesTopology>
  accessDataMemory(Access accessElement) const;

  /**
   * Finishes the current access, i.e. make it available for the pipeline.
   */
  void finishInstrAccess();

  /**
   * Finishes the current access, i.e. make it available for the pipeline.
   */
  void finishDataAccess();

  // Reference to the instruction memory
  AbstractCyclingMemory *instructionMemory;

  // Reference to the data memory
  AbstractCyclingMemory *dataMemory;

  /**
   * Queue to store all incoming instruction accesses.
   */
  std::list<Access> instructionQueue;

  /**
   * Queue to store all incoming data accesses.
   */
  std::list<Access> dataQueue;

  /**
   * Counter to provide a new identifier for each access.
   * Starts counting with 1, cf. currentIdAccessed.
   */
  unsigned currentId;

  /**
   * Stores the id currently being accessed by the topology.
   * 0 means there is currently no access being processed.
   */
  unsigned currentInstrIdAccessed;

  /**
   * Stores the id currently being accessed by the topology.
   * 0 means there is currently no access being processed.
   */
  unsigned currentDataIdAccessed;

  /**
   * Stores the ID of the access which finished in the last cycle.
   */
  unsigned finishedInstrAccessId;

  /**
   * Stores the ID of the access which finished in the last cycle.
   */
  unsigned finishedDataAccessId;
};

template <AbstractCyclingMemory *(*makeInstrMem)(),
          AbstractCyclingMemory *(*makeDataMem)()>
SeparateMemoriesTopology<makeInstrMem, makeDataMem>::SeparateMemoriesTopology()
    : instructionMemory(makeInstrMem()), dataMemory(makeDataMem()),
      currentId(1), // Skip 0 here.
      currentInstrIdAccessed(0), currentDataIdAccessed(0),
      finishedInstrAccessId(0), finishedDataAccessId(0) {}

template <AbstractCyclingMemory *(*makeInstrMem)(),
          AbstractCyclingMemory *(*makeDataMem)()>
SeparateMemoriesTopology<makeInstrMem, makeDataMem>::SeparateMemoriesTopology(
    const SeparateMemoriesTopology &smt2)
    : instructionMemory(smt2.instructionMemory->clone()),
      dataMemory(smt2.dataMemory->clone()),
      instructionQueue(smt2.instructionQueue), dataQueue(smt2.dataQueue),
      currentId(smt2.currentId),
      currentInstrIdAccessed(smt2.currentInstrIdAccessed),
      currentDataIdAccessed(smt2.currentDataIdAccessed),
      finishedInstrAccessId(smt2.finishedInstrAccessId),
      finishedDataAccessId(smt2.finishedDataAccessId) {}
template <AbstractCyclingMemory *(*makeInstrMem)(),
          AbstractCyclingMemory *(*makeDataMem)()>
SeparateMemoriesTopology<makeInstrMem,
                         makeDataMem>::~SeparateMemoriesTopology() {
  delete instructionMemory;
  delete dataMemory;
}

template <AbstractCyclingMemory *(*makeInstrMem)(),
          AbstractCyclingMemory *(*makeDataMem)()>
SeparateMemoriesTopology<makeInstrMem, makeDataMem> &
SeparateMemoriesTopology<makeInstrMem, makeDataMem>::operator=(
    const SeparateMemoriesTopology &smt2) {
  delete instructionMemory;
  instructionMemory = smt2.instructionMemory->clone();
  delete dataMemory;
  dataMemory = smt2.dataMemory->clone();
  instructionQueue = smt2.instructionQueue;
  dataQueue = smt2.dataQueue;
  currentId = smt2.currentId;
  currentInstrIdAccessed = smt2.currentInstrIdAccessed;
  currentDataIdAccessed = smt2.currentDataIdAccessed;
  finishedInstrAccessId = smt2.finishedInstrAccessId;
  finishedDataAccessId = smt2.finishedDataAccessId;

  return *this;
}

template <AbstractCyclingMemory *(*makeInstrMem)(),
          AbstractCyclingMemory *(*makeDataMem)()>
boost::optional<unsigned>
SeparateMemoriesTopology<makeInstrMem, makeDataMem>::accessInstr(
    unsigned addr, unsigned numWords) {
  // Override any preceding access here
  if (instructionQueue.size() > 0) {
    instructionQueue.pop_front();
  }
  unsigned resId = currentId;
  // create access element
  instructionQueue.push_back(
      Access(resId, AbstractAddress(addr), AccessType::LOAD, numWords));
  incrementCurrentId();
  return boost::optional<unsigned>(resId);
}

template <AbstractCyclingMemory *(*makeInstrMem)(),
          AbstractCyclingMemory *(*makeDataMem)()>
boost::optional<unsigned>
SeparateMemoriesTopology<makeInstrMem, makeDataMem>::accessData(
    AbstractAddress addr, AccessType load_store, unsigned numWords) {
  unsigned resId;
  if (dataQueue.size() == 0) {
    resId = currentId;
    dataQueue.push_back(Access(resId, addr, load_store, numWords));
    incrementCurrentId();
    return boost::optional<unsigned>(resId);
  } else {
    return boost::none;
  }
}

template <AbstractCyclingMemory *(*makeInstrMem)(),
          AbstractCyclingMemory *(*makeDataMem)()>
void SeparateMemoriesTopology<makeInstrMem, makeDataMem>::incrementCurrentId() {
  currentId++;
  if (currentId == 0) { // prevent zero from begin used!
    currentId++;
  }
}

template <AbstractCyclingMemory *(*makeInstrMem)(),
          AbstractCyclingMemory *(*makeDataMem)()>
std::list<SeparateMemoriesTopology<makeInstrMem, makeDataMem>>
SeparateMemoriesTopology<makeInstrMem, makeDataMem>::cycle(
    bool potentialDataMissesPending) const {
  //	std::cout << "::cycle()" << std::endl;
  //	std::cout << (*this) << std::endl;

  std::list<SeparateMemoriesTopology<makeInstrMem, makeDataMem>> res;

  res.push_back(*this);

  // get next element from the instruction queue
  if (currentInstrIdAccessed == 0) { // nothing is currently being accessed
    if (!instructionQueue.empty()) {
      res = accessInstrMemory(instructionQueue.front());
      for (auto &r : res) {
        r.instructionQueue.pop_front();
      }
    }
  }

  // get next element from the data queue
  std::list<SeparateMemoriesTopology<makeInstrMem, makeDataMem>> res2;
  if (currentDataIdAccessed == 0) { // nothing is currently being accessed
    if (!dataQueue.empty()) {
      for (auto &r : res) {
        std::list<SeparateMemoriesTopology<makeInstrMem, makeDataMem>> tempRes =
            r.accessDataMemory(dataQueue.front());
        for (auto &tR : tempRes) {
          tR.dataQueue.pop_front();
          res2.push_back(tR);
        }
      }
    }
  }
  if (res2.empty()) {
    res2 = res;
  }

  std::list<SeparateMemoriesTopology<makeInstrMem, makeDataMem>> res3;
  for (auto &r : res2) {
    // cycle
    auto cycledInstrMems = r.instructionMemory->cycle();
    auto cycledDataMems = r.dataMemory->cycle();
    for (auto cIM : cycledInstrMems) {
      for (auto cDM : cycledDataMems) {
        SeparateMemoriesTopology<makeInstrMem, makeDataMem> newInst(r);
        delete newInst.instructionMemory;
        newInst.instructionMemory = cIM->clone();
        delete newInst.dataMemory;
        newInst.dataMemory = cDM->clone();

        newInst.finishedInstrAccessId = 0;
        newInst.finishedDataAccessId = 0;

        // check if an instruction access finished
        if (newInst.currentInstrIdAccessed > 0 &&
            !newInst.instructionMemory->isBusy()) {
          newInst.finishInstrAccess();
        }

        // check if a data access finished
        if (newInst.currentDataIdAccessed > 0 &&
            !newInst.dataMemory->isBusy()) {
          newInst.finishDataAccess();
        }

        res3.push_back(newInst);
      }
    }
    for (auto cIM : cycledInstrMems) {
      delete cIM;
    }
    for (auto cDM : cycledDataMems) {
      delete cDM;
    }
  }
  return res3;
}

template <AbstractCyclingMemory *(*makeInstrMem)(),
          AbstractCyclingMemory *(*makeDataMem)()>
bool SeparateMemoriesTopology<makeInstrMem, makeDataMem>::shouldPipelineStall()
    const {
  assert(StallOnLocalWorstType.getBits() == 0 &&
         "Stalling not supported yet with Seperate Memories");
  return false;
}

template <AbstractCyclingMemory *(*makeInstrMem)(),
          AbstractCyclingMemory *(*makeDataMem)()>
bool SeparateMemoriesTopology<makeInstrMem, makeDataMem>::finishedInstrAccess(
    unsigned id) {
  bool res = finishedInstrAccessId == id;
  if (res) {
    finishedInstrAccessId = 0;
  }
  return res;
}

template <AbstractCyclingMemory *(*makeInstrMem)(),
          AbstractCyclingMemory *(*makeDataMem)()>
bool SeparateMemoriesTopology<makeInstrMem, makeDataMem>::finishedDataAccess(
    unsigned id) {
  bool res = finishedDataAccessId == id;
  if (res) {
    finishedDataAccessId = 0;
  }
  return res;
}

template <AbstractCyclingMemory *(*makeInstrMem)(),
          AbstractCyclingMemory *(*makeDataMem)()>
bool SeparateMemoriesTopology<makeInstrMem,
                              makeDataMem>::hasUnfinishedAccesses() const {
  return currentInstrIdAccessed != 0 || currentDataIdAccessed != 0;
}

template <AbstractCyclingMemory *(*makeInstrMem)(),
          AbstractCyclingMemory *(*makeDataMem)()>
std::list<SeparateMemoriesTopology<makeInstrMem, makeDataMem>>
SeparateMemoriesTopology<makeInstrMem, makeDataMem>::accessInstrMemory(
    Access accessElement) const {
  // access memory
  auto accessResults = instructionMemory->announceAccess(
      accessElement.addr, accessElement.load_store, accessElement.numWords);

  // build result list
  // set new memory
  std::list<SeparateMemoriesTopology> result;
  for (auto aR : accessResults) {
    SeparateMemoriesTopology altMT = SeparateMemoriesTopology(*this);
    altMT.currentInstrIdAccessed = accessElement.id;
    delete altMT.instructionMemory;
    altMT.instructionMemory = aR;
    result.push_back(altMT);
  }
  return result;
}

template <AbstractCyclingMemory *(*makeInstrMem)(),
          AbstractCyclingMemory *(*makeDataMem)()>
std::list<SeparateMemoriesTopology<makeInstrMem, makeDataMem>>
SeparateMemoriesTopology<makeInstrMem, makeDataMem>::accessDataMemory(
    Access accessElement) const {
  // access memory
  auto accessResults = dataMemory->announceAccess(
      accessElement.addr, accessElement.load_store, accessElement.numWords);

  // build result list
  // set new memory
  std::list<SeparateMemoriesTopology> result;
  for (auto aR : accessResults) {
    SeparateMemoriesTopology altMT = SeparateMemoriesTopology(*this);
    altMT.currentDataIdAccessed = accessElement.id;
    delete altMT.dataMemory;
    altMT.dataMemory = aR;
    result.push_back(altMT);
  }
  return result;
}

template <AbstractCyclingMemory *(*makeInstrMem)(),
          AbstractCyclingMemory *(*makeDataMem)()>
void SeparateMemoriesTopology<makeInstrMem, makeDataMem>::finishInstrAccess() {
  finishedInstrAccessId = currentInstrIdAccessed;
  currentInstrIdAccessed = 0;
}

template <AbstractCyclingMemory *(*makeInstrMem)(),
          AbstractCyclingMemory *(*makeDataMem)()>
void SeparateMemoriesTopology<makeInstrMem, makeDataMem>::finishDataAccess() {
  finishedDataAccessId = currentDataIdAccessed;
  currentDataIdAccessed = 0;
}

// TODO == operator | is similar/joinable
template <AbstractCyclingMemory *(*makeInstrMem)(),
          AbstractCyclingMemory *(*makeDataMem)()>
bool SeparateMemoriesTopology<makeInstrMem, makeDataMem>::operator==(
    const SeparateMemoriesTopology &smt2) const {
  return instructionMemory->equals(*smt2.instructionMemory) &&
         dataMemory->equals(*smt2.dataMemory) &&
         Super::areQueuesEqual(instructionQueue, smt2.instructionQueue,
                               currentId, smt2.currentId) &&
         Super::areQueuesEqual(dataQueue, smt2.dataQueue, currentId,
                               smt2.currentId) &&
         Super::areAccessIdsEqual(currentInstrIdAccessed,
                                  smt2.currentInstrIdAccessed, currentId,
                                  smt2.currentId) &&
         Super::areAccessIdsEqual(finishedInstrAccessId,
                                  smt2.finishedInstrAccessId, currentId,
                                  smt2.currentId) &&
         Super::areAccessIdsEqual(currentDataIdAccessed,
                                  smt2.currentDataIdAccessed, currentId,
                                  smt2.currentId) &&
         Super::areAccessIdsEqual(finishedDataAccessId,
                                  smt2.finishedDataAccessId, currentId,
                                  smt2.currentId);
}

template <AbstractCyclingMemory *(*makeInstrMem)(),
          AbstractCyclingMemory *(*makeDataMem)()>
size_t SeparateMemoriesTopology<makeInstrMem, makeDataMem>::hashcode() const {
  size_t res = 0;
  hash_combine_hashcode(res, *this->instructionMemory);
  hash_combine_hashcode(res, *this->dataMemory);
  // TODO hash queue content
  if (currentInstrIdAccessed != 0) {
    hash_combine(res, (this->currentInstrIdAccessed - this->currentId));
  }
  if (finishedInstrAccessId != 0) {
    hash_combine(res, this->finishedInstrAccessId - this->currentId);
  }
  if (currentDataIdAccessed != 0) {
    hash_combine(res, (this->currentDataIdAccessed - this->currentId));
  }
  if (finishedDataAccessId != 0) {
    hash_combine(res, this->finishedDataAccessId - this->currentId);
  }
  return res;
}

template <AbstractCyclingMemory *(*makeInstrMem)(),
          AbstractCyclingMemory *(*makeDataMem)()>
bool SeparateMemoriesTopology<makeInstrMem, makeDataMem>::isJoinable(
    const SeparateMemoriesTopology &smt2) const {
  return instructionMemory->isJoinable(*smt2.instructionMemory) &&
         dataMemory->isJoinable(*smt2.dataMemory) &&
         Super::areQueuesEqual(instructionQueue, smt2.instructionQueue,
                               currentId, smt2.currentId) &&
         Super::areQueuesEqual(dataQueue, smt2.dataQueue, currentId,
                               smt2.currentId) &&
         Super::areAccessIdsEqual(currentInstrIdAccessed,
                                  smt2.currentInstrIdAccessed, currentId,
                                  smt2.currentId) &&
         Super::areAccessIdsEqual(finishedInstrAccessId,
                                  smt2.finishedInstrAccessId, currentId,
                                  smt2.currentId) &&
         Super::areAccessIdsEqual(currentDataIdAccessed,
                                  smt2.currentDataIdAccessed, currentId,
                                  smt2.currentId) &&
         Super::areAccessIdsEqual(finishedDataAccessId,
                                  smt2.finishedDataAccessId, currentId,
                                  smt2.currentId);
}

template <AbstractCyclingMemory *(*makeInstrMem)(),
          AbstractCyclingMemory *(*makeDataMem)()>
void SeparateMemoriesTopology<makeInstrMem, makeDataMem>::join(
    const SeparateMemoriesTopology &smt2) {
  assert(isJoinable(smt2) && "Cannot join non-joinable topologies.");

  // Everything id related is just kept, as it is equal (relative to the
  // absolute id) anyway. Not that this makes the join non-symmetric w.r.t.
  // absolute id's but to relative id's.

  // Join the subcomponent
  instructionMemory->join(*smt2.instructionMemory);
  dataMemory->join(*smt2.dataMemory);
}

template <AbstractCyclingMemory *(*makeInstrMem)(),
          AbstractCyclingMemory *(*makeDataMem)()>
bool SeparateMemoriesTopology<makeInstrMem, makeDataMem>::isBusyAccessingInstr()
    const {
  return !instructionQueue.empty() || currentInstrIdAccessed > 0;
}

template <AbstractCyclingMemory *(*makeInstrMem)(),
          AbstractCyclingMemory *(*makeDataMem)()>
bool SeparateMemoriesTopology<makeInstrMem, makeDataMem>::isBusyAccessingData()
    const {
  return !dataQueue.empty() || currentDataIdAccessed > 0;
}

template <AbstractCyclingMemory *(*makeInstrMem)(),
          AbstractCyclingMemory *(*makeDataMem)()>
std::list<SeparateMemoriesTopology<makeInstrMem, makeDataMem>>
SeparateMemoriesTopology<makeInstrMem, makeDataMem>::fastForward() const {
  std::list<SeparateMemoriesTopology> res;

  if (isBusyAccessingInstr() && isBusyAccessingData()) {
    // We would not know which of the background
    // memories to fast-forward. Our interface is
    // still too simple and always fast-forwards
    // each background memory to the max...
    // This would lead to "forgetting" all the
    // possibilities in which one of the
    // background memories might finish a
    // particular number of cycles before the
    // other one.
    res.emplace(res.end(), *this);
    return res;
  }

  if (isBusyAccessingInstr()) {
    if (instructionMemory->isBusy()) {
      assert(currentInstrIdAccessed > 0);
      // fast-forward the instruction memory, then return
      for (auto forwardedInnerMem : instructionMemory->fastForward()) {
        auto copy = res.emplace(res.end(), *this);
        delete copy->instructionMemory;
        copy->instructionMemory = forwardedInnerMem;
      }
      return res;
    }
  }

  if (isBusyAccessingData()) {
    if (dataMemory->isBusy()) {
      assert(currentDataIdAccessed > 0);
      // fast-forward the data memory, then return
      for (auto forwardedInnerMem : dataMemory->fastForward()) {
        auto copy = res.emplace(res.end(), *this);
        delete copy->dataMemory;
        copy->dataMemory = forwardedInnerMem;
      }
      return res;
    }
  }

  // return an unchanged copy
  res.emplace(res.end(), *this);
  return res;
}

template <AbstractCyclingMemory *(*makeInstrMemf)(),
          AbstractCyclingMemory *(*makeDataMemf)()>
std::ostream &
operator<<(std::ostream &stream,
           const SeparateMemoriesTopology<makeInstrMemf, makeDataMemf> &smt2) {
  stream << "[ SeparateMemoriesTopology \n"; //| CurrentId: " << smt2.currentId
                                             //<< "\n";
  // Instruction Queue
  if (smt2.instructionQueue.size() > 0) {
    stream << " Instruction element in queue: ";
    MemoryTopologyInterface<SeparateMemoriesTopology<
        makeInstrMemf, makeDataMemf>>::outputAccess(stream,
                                                    smt2.instructionQueue
                                                        .front(),
                                                    true, smt2.currentId);
  } else {
    stream << " Instruction queue empty.\n";
  }
  // Data Queue
  if (smt2.dataQueue.size() > 0) {
    stream << " Data element in queue: ";
    MemoryTopologyInterface<SeparateMemoriesTopology<
        makeInstrMemf, makeDataMemf>>::outputAccess(stream,
                                                    smt2.dataQueue.front(),
                                                    false, smt2.currentId);
  } else {
    stream << " Data queue empty.\n";
  }
  stream << "Current relative Instruction Access ID: ";
  if (smt2.currentInstrIdAccessed == 0) {
    stream << "Nothing accessed, ";
  } else {
    stream << (int)(smt2.currentInstrIdAccessed - smt2.currentId) << ", ";
  }
  stream << (*smt2.instructionMemory) << "\n";
  if (smt2.finishedInstrAccessId == 0) {
    stream << " No instruction access finished just now. \n";
  } else {
    stream << " Instruction access finished, relative ID: "
           << (int)(smt2.finishedInstrAccessId - smt2.currentId) << " \n";
  }
  stream << "Current relative Data Access ID: ";
  if (smt2.currentDataIdAccessed == 0) {
    stream << "Nothing accessed, ";
  } else {
    stream << (int)(smt2.currentDataIdAccessed - smt2.currentId) << ", ";
  }
  stream << (*smt2.dataMemory) << "\n";
  if (smt2.finishedDataAccessId == 0) {
    stream << " No data access finished just now. \n";
  } else {
    stream << " Data access finished, relative ID: "
           << (int)(smt2.finishedDataAccessId - smt2.currentId) << " \n";
  }
  stream << "]\n";
  stream << "]\n";
  return stream;
}

} // namespace TimingAnalysisPass

#endif
