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

#ifndef CACHETRAITS_H_
#define CACHETRAITS_H_

#include "Memory/util/StaticHelpers.h"
#include <boost/integer.hpp>

#include <cassert>

namespace TimingAnalysisPass {

namespace dom {
namespace cache {

/**
 * \tparam L  Line size in bytes
 * \tparam A  Associativity
 * \tparam S  Number of sets
 * \tparam W  Width of addresses in bits
 * \tparam LAT Latency of the cache in the hit case
 * \tparam WB The cache is in write-back mode (write-through otherwise)
 * \tparam WA The cache is in write-allocate mode (write-non-allocate otherwise)
 *
 * \brief Defines several traits of a cache with given dimensions.
 */
struct CacheTraits {

  CacheTraits(unsigned L, unsigned A, unsigned S, bool WB, bool WA)
      : LINE_SIZE(16), ASSOCIATIVITY(2), N_SETS(32), WRITEBACK(false),
        WRITEALLOCATE(false) {}

  void checkParams() {
    // If larger values are desired, you just need to adjust the bit width
    // declarations below
    assert(IsPwr2(LINE_SIZE) && LINE_SIZE <= 256 &&
           "Line size must be a power of 2 and smaller than 256");
    assert(IsPwr2(ASSOCIATIVITY) && ASSOCIATIVITY <= 128 &&
           "Associativity must be a power of 2 and smaller than 128");
    assert(IsPwr2(N_SETS) && N_SETS <= 256 &&
           "Number of sets must be a power of 2 and smaller than 256");
    assert((!WRITEBACK || WRITEALLOCATE) &&
           "Cannot have write-back cache without write-allocate");
  }

  unsigned LINE_SIZE;
  unsigned ASSOCIATIVITY;
  unsigned N_SETS;
  bool WRITEBACK;
  bool WRITEALLOCATE;

  static const unsigned LATENCY = 1;

  static const unsigned ADDRESS_BITS = 32;
  static const unsigned OFFSET_BITS_DECL = 8;
  static const unsigned WAY_BITS_DECL = 8;
  static const unsigned INDEX_BITS_DECL = 8;
  static const unsigned TAG_BITS = 32;
  static const unsigned POS_BITS = 8;

  typedef typename boost::uint_t<ADDRESS_BITS>::least AddressType;
  typedef typename boost::uint_t<OFFSET_BITS_DECL>::least OffsetType;
  typedef typename boost::uint_t<WAY_BITS_DECL>::least WayType;
  typedef typename boost::uint_t<INDEX_BITS_DECL>::least IndexType;
  typedef typename boost::uint_t<TAG_BITS>::least TagType;
  typedef typename boost::uint_t<POS_BITS>::least PosType;
};

} // namespace cache
} // namespace dom

} // namespace TimingAnalysisPass

#endif /*CACHETRAITS_H_*/
