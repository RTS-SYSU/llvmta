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

#include "AnalysisFramework/CollectingContextsDomain.h"

#include "ARM.h"
#include "ARMMachineFunctionInfo.h"
#include "ARMTargetMachine.h"

using namespace llvm;

namespace TimingAnalysisPass {

CollectingContextsDomain::CollectingContextsDomain(AnaDomInit init)
    : bot(init == AnaDomInit::BOTTOM) {}

CollectingContextsDomain::CollectingContextsDomain(
    const CollectingContextsDomain &ccd)
    : bot(ccd.bot) {}

CollectingContextsDomain &
CollectingContextsDomain::operator=(const CollectingContextsDomain &other) {
  this->bot = other.bot;
  return *this;
}

void CollectingContextsDomain::transfer(const MachineInstr *MI,
                                        std::tuple<> &anaInfo) {}

void CollectingContextsDomain::join(const CollectingContextsDomain &element) {
  this->bot = this->bot & element.bot;
}

bool CollectingContextsDomain::lessequal(
    const CollectingContextsDomain &element) const {
  return this->bot || !element.bot;
}

std::string CollectingContextsDomain::print() const {
  return this->bot ? "bot" : "top";
}

bool CollectingContextsDomain::isBottom() const { return this->bot; }

} // namespace TimingAnalysisPass
