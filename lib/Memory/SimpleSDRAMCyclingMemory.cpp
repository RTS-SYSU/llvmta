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

#include "Memory/SimpleSDRAMCyclingMemory.h"

namespace TimingAnalysisPass {

SimpleSDRAMCyclingMemory::SimpleSDRAMCyclingMemory()
    : accessPhase(DRAMPhase::IDLE), timeBlocked(0), justRefreshed(boost::none),
      hasSeenRefresh(false), fastForwardedAccessCycles(0u) {}

SimpleSDRAMCyclingMemory *SimpleSDRAMCyclingMemory::clone() const {
  auto res = new SimpleSDRAMCyclingMemory();
  res->accessPhase = this->accessPhase;
  res->timeBlocked = this->timeBlocked;
  res->justRefreshed = this->justRefreshed;
  res->hasSeenRefresh = this->hasSeenRefresh;
  res->fastForwardedAccessCycles = this->fastForwardedAccessCycles;
  return res;
}

bool SimpleSDRAMCyclingMemory::isBusy() const {
  return accessPhase != DRAMPhase::IDLE;
}

std::list<AbstractCyclingMemory *> SimpleSDRAMCyclingMemory::cycle() const {
  std::list<AbstractCyclingMemory *> res;
  SimpleSDRAMCyclingMemory *r = this->clone();
  // Reset justRefreshed
  r->justRefreshed = boost::none;

  // Process an ongoing refresh or access
  if (r->timeBlocked > 0) {
    assert(r->accessPhase != DRAMPhase::IDLE &&
           "Cannot have remaining time in IDLE");
    r->timeBlocked--;
    // Current access phase finished, then go to
    if (r->accessPhase == DRAMPhase::ACCESS && r->timeBlocked == 0) {
      // If access latency finished, either it is finished and becomes idle, or
      // a refresh will follow. In this case stay in (ACCESS, 0) for this cycle.
      if (!CompAnaType.isSet(CompositionalAnalysisType::DRAMREFRESH) &&
          !hasSeenRefresh) {
        SimpleSDRAMCyclingMemory *ref = r->clone();
        ref->accessPhase = DRAMPhase::REFRESH;
        ref->timeBlocked = DRAMRefreshLatency;
        ref->justRefreshed =
            AbstractAddress::getUnknownAddress(); // TODO at the moment we do
                                                  // not care about the
                                                  // refreshed address
        res.push_back(ref);
      }
      r->accessPhase = DRAMPhase::IDLE;
      r->hasSeenRefresh = false;
    } else if (r->accessPhase == DRAMPhase::REFRESH && r->timeBlocked == 0) {
      // If all refresh budget is used up, we can only go to idle
      r->accessPhase = DRAMPhase::IDLE;
    } else if (r->accessPhase == DRAMPhase::REFRESH) {
      // We cannot be sure how long a refresh takes, so we might already be
      // finished
      if (!CompAnaType.isSet(CompositionalAnalysisType::DRAMREFRESH)) {
        SimpleSDRAMCyclingMemory *endref = r->clone();
        endref->accessPhase = DRAMPhase::IDLE;
        endref->timeBlocked = 0;
        res.push_back(endref);
      }
    }
  }
  res.push_back(r);
  return res;
}

bool SimpleSDRAMCyclingMemory::shouldPipelineStall() const {
  return StallOnLocalWorstType.isSet(LocalWorstCaseType::DRAMREFRESH) &&
         accessPhase == DRAMPhase::REFRESH;
}

bool SimpleSDRAMCyclingMemory::equals(const AbstractCyclingMemory &am2) const {
  auto &gcm2 = dynamic_cast<const SimpleSDRAMCyclingMemory &>(am2);
  return accessPhase == gcm2.accessPhase && timeBlocked == gcm2.timeBlocked &&
         justRefreshed == gcm2.justRefreshed &&
         hasSeenRefresh == gcm2.hasSeenRefresh &&
         fastForwardedAccessCycles == gcm2.fastForwardedAccessCycles;
}

size_t SimpleSDRAMCyclingMemory::hashcode() const {
  size_t res = 0;
  hash_combine(res, (int)accessPhase);
  hash_combine(res, timeBlocked);
  hash_combine_hashcode(res, fastForwardedAccessCycles);
  return res;
}

bool SimpleSDRAMCyclingMemory::isJoinable(
    const AbstractCyclingMemory &am2) const {
  auto &gcm2 = dynamic_cast<const SimpleSDRAMCyclingMemory &>(am2);
  return accessPhase == gcm2.accessPhase && timeBlocked == gcm2.timeBlocked &&
         hasSeenRefresh == gcm2.hasSeenRefresh &&
         fastForwardedAccessCycles.isJoinable(gcm2.fastForwardedAccessCycles);
}

void SimpleSDRAMCyclingMemory::join(const AbstractCyclingMemory &am2) {
  assert(isJoinable(am2) &&
         "Cannot join non-joinable generic cycling memories");
  // the fields accessPhase, timeBlocked are identical anyway as guaranteed by
  // the assert
  auto &gcm2 = dynamic_cast<const SimpleSDRAMCyclingMemory &>(am2);

  // Join the event field
  if (justRefreshed != gcm2.justRefreshed) {
    justRefreshed = boost::none;
  }

  fastForwardedAccessCycles.join(gcm2.fastForwardedAccessCycles);
}

void SimpleSDRAMCyclingMemory::print(std::ostream &stream) const {
  stream << "fastForwardedAccessCycles: [" << fastForwardedAccessCycles.getLb()
         << ", " << fastForwardedAccessCycles.getUb() << "]\n";
  stream << "needs " << timeBlocked << "cycles to in phase "
         << (accessPhase == DRAMPhase::IDLE
                 ? "Idle"
                 : (accessPhase == DRAMPhase::REFRESH ? "Refresh" : "Access"))
         << ".\n";
  stream << "Has Accounted for Refresh Already: "
         << (hasSeenRefresh ? "Yes" : "No");
}

std::list<AbstractCyclingMemory *>
SimpleSDRAMCyclingMemory::announceAccess(AbstractAddress addr, AccessType t,
                                         unsigned numWords) const {
  assert(!isBusy() && "Cannot announce access if busy");
  assert(!hasSeenRefresh && "Internal: Forgot to reset flag");
  assert(numWords <= SDRAMConfig.maxBurstLength);

  std::list<AbstractCyclingMemory *> res;
  // Case: No refresh as we split later (delayed)
  SimpleSDRAMCyclingMemory *noref = this->clone();
  noref->accessPhase = DRAMPhase::ACCESS;
  noref->timeBlocked = Latency + PerWordLatency * numWords;
  res.push_back(noref);
  // Return
  return res;
}

std::list<AbstractCyclingMemory *>
SimpleSDRAMCyclingMemory::fastForward() const {
  assert(this->isBusy() && "One should only fast-forward busy memories!");

  std::list<AbstractCyclingMemory *> res;
  SimpleSDRAMCyclingMemory *r = this->clone();

  // If we are already at the access, fast forward the remaining time up to 1
  if (r->accessPhase == DRAMPhase::ACCESS) {
    assert(r->justRefreshed == boost::none &&
           "During access phase, cannot have refresh event");
    assert(r->timeBlocked > 0 && " Should not forward in backwards direction");
    // If we want the refresh cases
    if (!CompAnaType.isSet(CompositionalAnalysisType::DRAMREFRESH)) {
      SimpleSDRAMCyclingMemory *ref = r->clone();
      decltype(ref->fastForwardedAccessCycles) additionalTime(
          ref->timeBlocked - 1, ref->timeBlocked - 1 + DRAMRefreshLatency);
      ref->fastForwardedAccessCycles += additionalTime;
      ref->justRefreshed = AbstractAddress::getUnknownAddress();
      ref->timeBlocked = 1;
      // Remember that we handled the refresh already
      ref->hasSeenRefresh = true;
      r->hasSeenRefresh = true;
      // Store result
      res.push_back(ref);
    }
    r->fastForwardedAccessCycles += (r->timeBlocked - 1);
    r->timeBlocked = 1;
  } else if (r->accessPhase == DRAMPhase::REFRESH) {
    assert(r->timeBlocked > 0 && "Should not forward in backwards direction");
    // If we are in the refresh phase, fast forward all the refresh,
    // but not the access, because stalling behaviour could be different
    decltype(r->fastForwardedAccessCycles) additionalTime(0,
                                                          r->timeBlocked - 1);
    r->fastForwardedAccessCycles += additionalTime;
    r->timeBlocked = 1;
  } else {
    assert(0 && "Cannot fast forward while being idle");
  }

  res.push_back(r);
  return res;
}

} // namespace TimingAnalysisPass
