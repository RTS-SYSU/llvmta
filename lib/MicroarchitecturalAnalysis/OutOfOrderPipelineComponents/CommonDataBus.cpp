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

#include "MicroarchitecturalAnalysis/OutOfOrderPipelineComponents/CommonDataBus.h"
#include "MicroarchitecturalAnalysis/OutOfOrderPipelineComponents/ReOrderBuffer.h"

namespace TimingAnalysisPass {

CommonDataBus::CommonDataBus() : commonDataBus(boost::none), rob(nullptr) {}

size_t CommonDataBus::hashcode() const {
  size_t result = 0;
  if (isSet()) {
    hash_combine(result, rob->getRelativeToHead(getCdb()));
  }
  return result;
}

bool CommonDataBus::operator==(const CommonDataBus &cdb) const {
  if (isSet() != cdb.isSet()) {
    return false;
  }
  if (isSet()) {
    return (rob->getRelativeToHead(getCdb()) ==
            cdb.rob->getRelativeToHead(cdb.getCdb()));
  }
  return true;
}

void CommonDataBus::reassignPointers(ReOrderBuffer *robu) { rob = robu; }

bool CommonDataBus::isSet() const { return commonDataBus != boost::none; }

void CommonDataBus::reset() { commonDataBus = boost::none; }

void CommonDataBus::set(unsigned tag) { commonDataBus = tag; }

unsigned CommonDataBus::getCdb() const {
  assert(isSet() && "CDB was not set.");
  return commonDataBus.get();
}

} // namespace TimingAnalysisPass
