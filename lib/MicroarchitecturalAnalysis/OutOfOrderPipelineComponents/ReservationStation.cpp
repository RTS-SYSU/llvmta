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

#include "MicroarchitecturalAnalysis/OutOfOrderPipelineComponents/ReservationStation.h"

namespace TimingAnalysisPass {

void outputReservationStationElement(std::ostream &stream,
                                     const ReservationStationElement &rse,
                                     const ReOrderBuffer *rob) {
  stream << rob->getRelativeToHead(std::get<0>(rse));
  stream << " | ";
  if (std::get<1>(rse)) {
    stream << "Busy";
  } else {
    stream << "Not busy";
  }
  stream << " | Operands: ";
  for (auto &op : std::get<2>(rse)) {
    stream << rob->getRelativeToHead(op) << ", ";
  }
  stream << "\n";
}

ReservationStation::ReservationStation(unsigned size)
    : resStationSize(size),
      reservationStation(std::vector<ReservationStationElement>()),
      funcUnits(std::vector<FunctionalUnit *>()), rob(nullptr), cdb(nullptr) {}

ReservationStation::ReservationStation(const ReservationStation &rs)
    : resStationSize(rs.resStationSize),
      reservationStation(rs.reservationStation),
      funcUnits(std::vector<FunctionalUnit *>()), rob(nullptr), cdb(nullptr) {}

bool ReservationStation::operator==(const ReservationStation &rs) const {
  unsigned entries = reservationStation.size();
  if (entries != rs.reservationStation.size())
    return false;

  for (unsigned i = 0; i < entries; i++) {
    auto &rse = reservationStation.at(i);
    auto &rsRse = rs.reservationStation.at(i);

    // check all parts of the tuple
    if (std::get<1>(rse) != std::get<1>(rsRse))
      return false;

    // need to account for relative position to the reorder buffer
    if (rob->getRelativeToHead(std::get<0>(rse)) !=
        rs.rob->getRelativeToHead(std::get<0>(rsRse)))
      return false;
    auto &rseSet = std::get<2>(rse);
    auto &rsRseSet = std::get<2>(rsRse);

    // check that both wait for the same number of operands
    if (rseSet.size() != rsRseSet.size())
      return false;

    // create relative source list for second sources operand
    std::set<unsigned> rsRelSources;
    for (auto src : rsRseSet) {
      rsRelSources.insert(rs.rob->getRelativeToHead(src));
    }

    // check if each source is in the relative sources set
    for (auto &src : rseSet) {
      if (rsRelSources.find(rob->getRelativeToHead(src)) == rsRelSources.end())
        return false;
    }
  }

  return true;
}

size_t ReservationStation::hashcode() const {
  size_t result = 0;

  for (auto &rse : reservationStation) {
    hash_combine(result, rob->getRelativeToHead(std::get<0>(rse)));
    hash_combine(result, std::get<1>(rse));
    for (auto src : std::get<2>(rse)) {
      hash_combine(result, rob->getRelativeToHead(src));
    }
  }

  return result;
}

std::ostream &operator<<(std::ostream &stream, const ReservationStation &rs) {
  stream << "Reservation Station: {\n";

  for (auto &rse : rs.reservationStation) {
    outputReservationStationElement(stream, rse, rs.rob);
  }

  // output functional units here
  for (auto fup : rs.funcUnits) {
    stream << "FU : " << *fup << "\n";
  }

  stream << "}\n";
  return stream;
}

void ReservationStation::reassignPointers(std::vector<FunctionalUnit *> fu,
                                          ReOrderBuffer *robu,
                                          CommonDataBus *cdbu) {
  funcUnits = fu;
  rob = robu;
  cdb = cdbu;
}

bool ReservationStation::canExecuteInstruction(const MachineInstr *mi) const {
  // if one functional unit can execute it, return true
  for (auto fu : funcUnits) {
    if (fu->canExecuteInstruction(mi))
      return true;
  }
  return false;
}

bool ReservationStation::isFull() const {
  // check if there is something free
  return reservationStation.size() == resStationSize;
}

void ReservationStation::cycle() {
  for (auto rsElemIt = reservationStation.begin();
       rsElemIt != reservationStation.end();) {
    bool deleted = false;
    // check if already busy/dispatched
    if (!std::get<1>(*rsElemIt)) {
      // not dispatched yet, check for remaining sources
      auto &sources = std::get<2>(*rsElemIt);
      for (auto opIt = sources.begin(); opIt != sources.end();) {
        // check whether the operand is currently on the cdb
        if (cdb->isSet() && cdb->getCdb() == *opIt) {
          // delete from awaited operands
          opIt = sources.erase(opIt);
        } else {
          // iterate without erasing
          ++opIt;
        }
      }

      // if all operands are ready, try to assign to a functional unit
      if (sources.size() == 0) {
        const MachineInstr *mi = StaticAddrProvider->getMachineInstrByAddr(
            rob->getExecutionElementForRobTag(std::get<0>(*rsElemIt)).first);
        for (auto fu : funcUnits) {
          if (fu->canExecuteInstruction(mi) && fu->isFree()) {
            std::get<1>(*rsElemIt) = true;
            fu->executeInstruction(std::get<0>(*rsElemIt));
            // clear reservation station
            rsElemIt = reservationStation.erase(rsElemIt);
            deleted = true;
            break;
          }
        }
      }
    }
    // iterate further if not done yet
    if (!deleted) {
      ++rsElemIt;
    }
  }
}

void ReservationStation::flush() { reservationStation.clear(); }

std::set<unsigned> ReservationStation::getExecutingRobTags() const {
  std::set<unsigned> res;
  for (auto &ele : reservationStation) {
    res.insert(std::get<0>(ele));
  }
  return res;
}

void ReservationStation::issueInstruction(
    unsigned robTag, std::unordered_set<unsigned> sources) {
  assert(!isFull() &&
         "Tried issuing an instruction without prior check. Station is full.");

  ReservationStationElement rse = std::make_tuple(robTag, false, sources);

  // assign to the next free station
  reservationStation.push_back(rse);
}

} // namespace TimingAnalysisPass
