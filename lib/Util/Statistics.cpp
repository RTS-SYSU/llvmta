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

#include "Util/Statistics.h"

#include "sys/resource.h"
#include "sys/time.h"

#include "llvm/Support/Debug.h"

#include <cassert>
#include <iomanip>

namespace TimingAnalysisPass {

Statistics &Statistics::getInstance() {
  static Statistics stats;
  return stats;
}

void Statistics::startMeasurement(std::string identifier) {
  assert(measurements.count(identifier) == 0 &&
         "Measurement is already started.");
  struct timeval timer;
  Measurement &meas = measurements[identifier];

  startTimer(&timer);
  std::get<1>(meas) = timer;
  // We are not final yet
  std::get<2>(meas) = false;
}

void Statistics::stopMeasurement(std::string identifier) {
  assert(measurements.count(identifier) > 0 &&
         "Cannot stop unknown measurement");
  assert(!std::get<2>(measurements.at(identifier)) &&
         "Cannot stop final measurement");

  struct timeval stopTime;
  stopTimer(&stopTime);

  checkMemoryUsage(identifier);

  Measurement &meas = measurements[identifier];
  struct timeval startTime = std::get<1>(meas);

  struct timeval diff;
  timersub(&stopTime, &startTime, &diff);

  std::get<1>(meas) = diff;
  // We are final now
  std::get<2>(meas) = true;
}

void Statistics::dump(std::ostream &stream) {
  for (auto &m : measurements) {
    stream << "<measurement>\n";

    stream << "<id>" << m.first << "</id>\n";

    Measurement mea = m.second;
    stream << "<memory>" << std::get<0>(mea) << "</memory>\n";
    struct timeval diff = std::get<1>(mea);
    stream << "<time>" << diff.tv_sec << ".";
    stream << std::setw(6) << std::setfill('0') << diff.tv_usec;
    stream << "</time>\n";

    stream << "</measurement>\n";
  }
}

unsigned Statistics::getCurrentMemoryUsage() {
  struct rusage usage;

  getrusage(RUSAGE_SELF, &usage);

  return usage.ru_maxrss;
}

void Statistics::startTimer(struct timeval *timer) {
  struct rusage usage;

  getrusage(RUSAGE_SELF, &usage);
  timeradd(&usage.ru_stime, &usage.ru_utime, timer);
}

void Statistics::stopTimer(struct timeval *timer) {
  struct rusage usage;

  getrusage(RUSAGE_SELF, &usage);
  timeradd(&usage.ru_stime, &usage.ru_utime, timer);
}

void Statistics::checkMemoryUsage(std::string identifier) {
  Measurement &meas = measurements[identifier];
  unsigned currMem = getCurrentMemoryUsage();
  if (std::get<0>(meas) < currMem) {
    std::get<0>(meas) = currMem;
  }
}

} // namespace TimingAnalysisPass
