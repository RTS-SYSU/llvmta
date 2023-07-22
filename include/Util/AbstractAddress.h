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

#ifndef TIMINGANALYSIS_ADDRESS_H
#define TIMINGANALYSIS_ADDRESS_H

#include "llvm/IR/GlobalVariable.h"
#include <boost/numeric/interval.hpp>
#include <boost/optional/optional.hpp>

#include <iostream>

#include "Util/Util.h"

using namespace llvm;
namespace TimingAnalysisPass {

/* concrete addresses are just unsigned integers */
typedef unsigned Address;

typedef boost::numeric::interval_lib::policies<
    boost::numeric::interval_lib::rounded_arith_exact<Address>,
    boost::numeric::interval_lib::checking_base<Address>>
    itv_policies;
typedef boost::numeric::interval<Address, itv_policies> AddressInterval;

class AbstractAddress {
private:
  /* Possible kinds of addresses. Usually you would want inheritance for
   * this, but this would demand passing pointers to addresses around,
   * worrying about memory allocation and doubling the memory footprint.
   * Instead we just do this C-style, with a union and an enum describing
   * which field is valid. This should NOT be exposed to the outside
   * world */
  enum class AddressType { INTERVAL, ARRAY } type;
  // TODO (gcc-8) Convert it to a std::variant or a struct
  union AddressValue {
    AddressInterval interval;
    const GlobalVariable *array;

    /* we need this constructor in order to make the
     * copy-constructor of AbstractAddress work. */
    AddressValue() : array(nullptr) {}
  } value;

public:
  explicit AbstractAddress(Address);
  explicit AbstractAddress(AddressInterval);
  explicit AbstractAddress(const GlobalVariable *);
  AbstractAddress(const AbstractAddress &other) {
    this->type = other.type;
    memmove(&this->value, &other.value, sizeof(this->value));
  }
  AbstractAddress &operator=(AbstractAddress other) {
    this->type = other.type;
    memmove(&this->value, &other.value, sizeof(this->value));
    return *this;
  }

  /* pseudo-constructor that doesn't fit well into the constructor scheme */
  static AbstractAddress getUnknownAddress();

  /* Returns true if the AbstractAddress describes an array as opposed to an
   * interval */
  bool isArray() const;
  /* Returns true if the address is precise, i.e. describes to a single
   * concrete address */
  bool isPrecise() const;

  /* Returns the global variable the address is inside of or NULL if the
   * address is not inside of any global array */
  const GlobalVariable *getArray() const;
  /* Returns the AbstractAddress as an interval of numeric addresses */
  AddressInterval getAsInterval() const;

  operator AddressInterval() { return this->getAsInterval(); };

  /* Returns true if both addresses describe the same address interval. */
  bool isSameInterval(const AbstractAddress) const;
  /* Returns true if both addresses are equal (of same type and of same
   * value). Note that an array is not equal to the interval
   * covering the array (since the former contains more
   * information */
  bool operator==(const AbstractAddress &other) const {
    if (this->type != other.type)
      return false;

    switch (type) {
    case AddressType::INTERVAL:
      return this->isSameInterval(other);
    case AddressType::ARRAY:
      return this->value.array == other.value.array;
    }

    assert(0 && "UNREACHABLE");
  }

  /* Artificial less-than operator for inclusion in maps etc. */
  bool operator<(const AbstractAddress &other) const {
    if (this->type != other.type) {
      return this->type < other.type;
    }

    switch (this->type) {
    case AddressType::INTERVAL:
      if (this->value.interval.lower() != other.value.interval.lower()) {
        return this->value.interval.lower() < other.value.interval.lower();
      }
      return this->value.interval.upper() < other.value.interval.upper();
    case AddressType::ARRAY:
      return std::less<const GlobalVariable *>()(this->value.array,
                                                 other.value.array);
    }
    assert(0 && "UNREACHABLE");
  }
  template <typename streamtype>
  friend streamtype &operator<<(streamtype &stream, AbstractAddress addr);
};

template <typename streamtype>
streamtype &operator<<(streamtype &stream, AbstractAddress addr) {
  typedef AbstractAddress::AddressType AddressType;
  switch (addr.type) {
  case AddressType::ARRAY:
    stream << "Array " << addr.value.array->getName().str();
    break;
  case AddressType::INTERVAL:
    break;
  default:
    assert(0 && "UNREACHABLE");
  }

  Address lower = addr.getAsInterval().lower();
  Address upper = addr.getAsInterval().upper();
  if (addr.isPrecise()) {
    printHex(stream, lower);
    return stream;
  }
  stream << "[";
  printHex(stream, lower, 8) << ", ";
  printHex(stream, upper, 8) << "]";
  return stream;
}

} // namespace TimingAnalysisPass
#endif
