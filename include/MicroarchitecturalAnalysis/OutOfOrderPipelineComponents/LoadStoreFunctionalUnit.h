////////////////////////////////////////////////////////////////////////////////
//
//   LLVMTA - Timing Analyser performing worst-case execution time analysis
//     using the LLVM backend intermediate representation
//
// Copyright (C) 2013-2022  Saarland University
// Copyright (C) 2014-2015 Claus Faymonville
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

#ifndef LOADSTOREFUNCTIONALUNIT_H
#define LOADSTOREFUNCTIONALUNIT_H

#include "MicroarchitecturalAnalysis/OutOfOrderPipelineComponents/FunctionalUnit.h"

#include <boost/optional.hpp>

namespace TimingAnalysisPass {

template <class MemoryTopology>
class LoadStoreFunctionalUnit : public FunctionalUnit {

public:
  LoadStoreFunctionalUnit(MemoryTopology *memt);

  ~LoadStoreFunctionalUnit() {}

  FunctionalUnit *clone() const;

  size_t hashcode() const;

  bool equals(const FunctionalUnit &fu) const;

  void output(std::ostream &stream) const;

  void reassignMemory(MemoryTopology *memt);

  bool canExecuteInstruction(const MachineInstr *mi) const;

  bool isFree() const;

  void executeInstruction(unsigned robTag);

  std::list<FunctionalUnit *>
  cycle(std::tuple<InstrContextMapping &, AddressInformation &> &dep);

  void flush();

  std::set<unsigned> getExecutingRobTags() const;

private:
  LoadStoreFunctionalUnit(const LoadStoreFunctionalUnit &lsfu);

  MemoryTopology *memory;

  /**
   * ROB-Tag of the executing instruction
   * Need the ids of the memory topology when accessing stuff here. These might
   * be multiple ids!
   */
  boost::optional<unsigned> executingInstruction;

  /**
   * Temporary storage of a memory access index of an instruction
   * Used for load/store multiple to keep track of the current access index
   * being executed.
   */
  unsigned currMemoryAccess;

  /**
   * Temporary storage of accessIds for all accesses from the memory
   * instruction. In case of a load/store multiple, this is more than one
   * access.
   */
  std::map<unsigned, unsigned> dataAccessIds;
};

template <class MemoryTopology>
LoadStoreFunctionalUnit<MemoryTopology>::LoadStoreFunctionalUnit(
    MemoryTopology *memt)
    : FunctionalUnit(), memory(memt), executingInstruction(boost::none),
      currMemoryAccess(0), dataAccessIds() {}

template <class MemoryTopology>
LoadStoreFunctionalUnit<MemoryTopology>::LoadStoreFunctionalUnit(
    const LoadStoreFunctionalUnit<MemoryTopology> &dfu)
    : FunctionalUnit(dfu), memory(nullptr),
      executingInstruction(dfu.executingInstruction),
      currMemoryAccess(dfu.currMemoryAccess), dataAccessIds(dfu.dataAccessIds) {
}

template <class MemoryTopology>
FunctionalUnit *LoadStoreFunctionalUnit<MemoryTopology>::clone() const {
  return new LoadStoreFunctionalUnit<MemoryTopology>(*this);
}

template <class MemoryTopology>
bool LoadStoreFunctionalUnit<MemoryTopology>::equals(
    const FunctionalUnit &fu) const {
  const auto &lsfu =
      dynamic_cast<const LoadStoreFunctionalUnit<MemoryTopology> &>(fu);

  // check executing instruction
  if (((bool)executingInstruction) != ((bool)lsfu.executingInstruction)) {
    return false;
  }
  if (executingInstruction) {
    if (this->rob->getRelativeToHead(executingInstruction.get()) !=
        lsfu.rob->getRelativeToHead(lsfu.executingInstruction.get())) {
      return false;
    }
  }

  // check other components
  return FunctionalUnit::equals(fu) &&
         currMemoryAccess == lsfu.currMemoryAccess &&
         dataAccessIds.size() == lsfu.dataAccessIds.size();
}

template <class MemoryTopology>
size_t LoadStoreFunctionalUnit<MemoryTopology>::hashcode() const {
  size_t result = FunctionalUnit::hashcode();

  if (executingInstruction) {
    hash_combine(result,
                 this->rob->getRelativeToHead(executingInstruction.get()));
    hash_combine(result, currMemoryAccess);
  }
  hash_combine(result, dataAccessIds.size());

  return result;
}

template <class MemoryTopology>
void LoadStoreFunctionalUnit<MemoryTopology>::output(
    std::ostream &stream) const {
  stream << "Load/Store Functional Unit: {\n";

  if (executingInstruction) {
    stream << "Instruction access with rob tag: "
           << this->rob->getRelativeToHead(executingInstruction.get()) << "\n";
    stream << "Current memory access: " << currMemoryAccess << "\n";
  } else {
    stream << "No instruction executed right now.\n";
  }

  FunctionalUnit::output(stream);

  stream << "}\n";
}

template <class MemoryTopology>
void LoadStoreFunctionalUnit<MemoryTopology>::reassignMemory(
    MemoryTopology *memt) {
  memory = memt;
}

template <class MemoryTopology>
bool LoadStoreFunctionalUnit<MemoryTopology>::canExecuteInstruction(
    const MachineInstr *mi) const {
  // only accept load/store instructions
  return mi->mayLoad() || mi->mayStore();
}

template <class MemoryTopology>
bool LoadStoreFunctionalUnit<MemoryTopology>::isFree() const {
  return FunctionalUnit::isFree() && executingInstruction == boost::none;
}

template <class MemoryTopology>
void LoadStoreFunctionalUnit<MemoryTopology>::executeInstruction(
    unsigned robTag) {
  assert(isFree() && "Functional Unit was not free!");
  executingInstruction = robTag;
  currMemoryAccess = 0;
}

template <class MemoryTopology>
std::list<FunctionalUnit *> LoadStoreFunctionalUnit<MemoryTopology>::cycle(
    std::tuple<InstrContextMapping &, AddressInformation &> &dep) {
  std::list<FunctionalUnit *> result;
  if (executingInstruction) {
    ExecutionElement execElem =
        rob->getExecutionElementForRobTag(executingInstruction.get());
    auto currInstr = StaticAddrProvider->getMachineInstrByAddr(execElem.first);

    auto &addrInfo = std::get<1>(dep);
    unsigned numDataAccesses = addrInfo.getNumOfDataAccesses(currInstr);

    // dataAccessIds contain only one item
    auto access = std::begin(dataAccessIds);
    while (access != std::end(dataAccessIds)) {
      if (memory->finishedDataAccess(access->second)) {
        access = dataAccessIds.erase(access);
      } else {
        ++access;
      }
    }

    // access data addresses sequentially
    if (dataAccessIds.empty() &&
        !rob->isUnresolvedBranchBefore(executingInstruction.get())) {
      if (currMemoryAccess < numDataAccesses) {
        // check whether there is a branch instruction infront

        AccessType at;
        if (currInstr->mayLoad()) {
          at = AccessType::LOAD;
        } else {
          at = AccessType::STORE;
        }

        auto &currCtx = execElem.second;
        AbstractAddress addr = addrInfo.getDataAccessAddress(
            currInstr, &currCtx, currMemoryAccess);

        boost::optional<unsigned> dataAccess = memory->accessData(addr, at, 1);
        assert(dataAccess &&
               "Data access could not be processed by the memory topology!");
        if (dataAccess) {
          dataAccessIds.insert(
              std::pair<unsigned, unsigned>(currMemoryAccess, *dataAccess));
          currMemoryAccess++;
        }
      } else {
        // all accesses finished
        finishedInstruction = executingInstruction;
        executingInstruction = boost::none;
        currMemoryAccess = 0;
      }
    }
  }
  LoadStoreFunctionalUnit<MemoryTopology> *newLsfu =
      new LoadStoreFunctionalUnit<MemoryTopology>(*this);
  result.push_back(newLsfu);
  return result;
}

template <class MemoryTopology>
void LoadStoreFunctionalUnit<MemoryTopology>::flush() {
  FunctionalUnit::flush();
  executingInstruction = boost::none;
  currMemoryAccess = 0;
}

template <class MemoryTopology>
std::set<unsigned>
LoadStoreFunctionalUnit<MemoryTopology>::getExecutingRobTags() const {
  std::set<unsigned> res;
  if (executingInstruction) {
    res.insert(executingInstruction.get());
  }
  if (this->finishedInstruction) {
    res.insert(this->finishedInstruction.get());
  }
  return res;
}

} // namespace TimingAnalysisPass

#endif /* LOADSTOREFUNCTIONALUNIT_H */
