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

#include "Util/AbstractAddress.h"
#include "LLVMPasses/StaticAddressProvider.h"
#include "Util/Options.h"

namespace TimingAnalysisPass {
/* constructors */
AbstractAddress::AbstractAddress(Address addr) {
  this->value.interval = AddressInterval(addr, addr);
  this->type = AddressType::INTERVAL;
}

AbstractAddress::AbstractAddress(AddressInterval itv) {
  this->value.interval = itv;
  this->type = AddressType::INTERVAL;
}

AbstractAddress::AbstractAddress(const GlobalVariable *gv) {
  assert(gv);
  if (!ArrayAnalysis) {
    *this = AbstractAddress::getUnknownAddress();
    return;
  }
  this->value.array = gv;
  this->type = AddressType::ARRAY;
}

AbstractAddress AbstractAddress::getUnknownAddress() {
  AbstractAddress addr(AddressInterval(0, 0xffffffff));
  return addr;
}

/* accessors */
bool AbstractAddress::isArray() const { return type == AddressType::ARRAY; }
bool AbstractAddress::isPrecise() const {
  return this->type == AddressType::INTERVAL &&
         value.interval.lower() == value.interval.upper();
}

const GlobalVariable *AbstractAddress::getArray() const {
  if (!this->isArray()) {
    return nullptr;
  }
  return value.array;
}

AddressInterval AbstractAddress::getAsInterval() const {
  switch (this->type) {
  case AddressType::INTERVAL:
    return value.interval;
  case AddressType::ARRAY: {
    unsigned base = StaticAddrProvider->getGlobalVarAddress(value.array);
    unsigned size = StaticAddrProvider->getArraySize(value.array);
    return AddressInterval(base, base + size - 4);
  }
  default:
    assert(0 && "UNREACHABLE");
  }
}

/* Comparisons */
bool AbstractAddress::isSameInterval(const AbstractAddress other) const {
  AddressInterval this_itv = this->getAsInterval();
  AddressInterval other_itv = other.getAsInterval();
  return this_itv.lower() == other_itv.lower() &&
         this_itv.upper() == other_itv.upper();
}

} // namespace TimingAnalysisPass
