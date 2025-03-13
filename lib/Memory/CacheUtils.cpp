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

#include "Memory/util/CacheUtils.h"

namespace TimingAnalysisPass {

unsigned getCachelineMemoryLatency(CacheType type) {
  /* TODO maybe rename the function and return "Latency+PerWordLatency" in
   * case of no cache? */
  assert(MemTopType == MemoryTopologyType::SEPARATECACHES &&
         "This function cannot be used without caches");

  unsigned numWords;
  switch (type) {
  case CacheType::UNIFIED:
    assert(Ilinesize == Dlinesize);
    /* fallthrough */
  case CacheType::INSTRUCTION:
    assert(Ilinesize % 4 == 0);
    numWords = Ilinesize / 4;
    break;
  case CacheType::DATA:
    assert(Dlinesize % 4 == 0);
    numWords = Dlinesize / 4;
    break;
  default:
    assert(0 && "UNREACHABLE");
  }
  return Latency + PerWordLatency * numWords;
}

} // namespace TimingAnalysisPass
