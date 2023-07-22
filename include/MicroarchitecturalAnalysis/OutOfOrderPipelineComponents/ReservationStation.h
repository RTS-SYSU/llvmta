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

#ifndef RESERVATIONSTATION_H
#define RESERVATIONSTATION_H

#include "LLVMPasses/StaticAddressProvider.h"
#include "MicroarchitecturalAnalysis/OutOfOrderPipelineComponents/CommonDataBus.h"
#include "MicroarchitecturalAnalysis/OutOfOrderPipelineComponents/FunctionalUnit.h"
#include "MicroarchitecturalAnalysis/OutOfOrderPipelineComponents/ReOrderBuffer.h"
#include "MicroarchitecturalAnalysis/OutOfOrderPipelineComponents/RegisterStatusTable.h"

#include <boost/circular_buffer.hpp>

namespace TimingAnalysisPass {

/**
 * reorder buffer tag, Busy, Sources
 * Sources contain indices of the reorder buffer (tags), as long as the source
 is not ready
 * If sources are empty, every operand is ready.
 * Elements are preserved in the reservation station until they finished
 execution.
 // TODO(SH) as already written at other point: There might be up to 16 sources
 and up to 16 destination registers
 // Introduce a bitmap (e.g. an unsigned) to store whether operands are
 available or not?
 */
typedef std::tuple<unsigned, bool, std::unordered_set<unsigned>>
    ReservationStationElement;

void outputReservationStationElement(std::ostream &stream,
                                     const ReservationStationElement &rse,
                                     const ReOrderBuffer *rob);

/**
 * Reservation Station
 * Buffers instructions to dispatch them to functional units when they are free.
 * Buffers until instructions are finished.
 * Stores reorder buffer tags that contains values of operands.
 * Also includes the functional units which it serves.
 */
class ReservationStation {

public:
  /**
   * Constructor
   */
  ReservationStation(unsigned size);

  ReservationStation(const ReservationStation &rs);

  bool operator==(const ReservationStation &rs) const;

  size_t hashcode() const;

  friend std::ostream &operator<<(std::ostream &stream,
                                  const ReservationStation &rs);

  void reassignPointers(std::vector<FunctionalUnit *> fu, ReOrderBuffer *rob,
                        CommonDataBus *cdb);

  /**
   * Method to determine whether this type of MachineInstruction can be executed
   * by any of the functional unit.
   */
  bool canExecuteInstruction(const MachineInstr *mi) const;

  /**
   * Returns whether or not there is free space to dispatch the given
   * instruction.
   */
  bool isFull() const;

  /**
   * Issues an instruction.
   * Takes the tag of the reorder buffer to determine where operands are coming
   * from.
   */
  void issueInstruction(unsigned robTag, std::unordered_set<unsigned> sources);

  void cycle();

  void flush();

  /**
   * Returns the rob tags that are currently executing in this reservation
   * station.
   */
  std::set<unsigned> getExecutingRobTags() const;

private:
  /**
   * Number of maximum elements in this reservation station
   */
  unsigned resStationSize;

  /**
   * Vector containing the reservation station elements
   */
  std::vector<ReservationStationElement> reservationStation;

  /**
   * Vector with pointers to all functional units belonging to this reservation
   * station
   */
  std::vector<FunctionalUnit *> funcUnits;

  ReOrderBuffer *rob;

  CommonDataBus *cdb;
};

} // namespace TimingAnalysisPass

#endif /* RESERVATIONSTATION_H */
