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

#ifndef CACHE_UTILS_H
#define CACHE_UTILS_H

#include "LLVMPasses/StaticAddressProvider.h"
#include "Memory/CacheTraits.h"
#include "Util/AbstractAddress.h"
#include "Util/Options.h"
#include "Util/Util.h"

namespace TimingAnalysisPass {
template <dom::cache::CacheTraits *CacheConfig>
typename dom::cache::CacheTraits::AddressType
getCachelineAddress(typename dom::cache::CacheTraits::AddressType addr) {
  return addr & ~(CacheConfig->LINE_SIZE - 1);
}

template <dom::cache::CacheTraits *CacheConfig>
typename dom::cache::CacheTraits::TagType
getTag(typename dom::cache::CacheTraits::AddressType addr) {
  return (addr / CacheConfig->LINE_SIZE) / CacheConfig->N_SETS;
}

template <dom::cache::CacheTraits *CacheConfig>
typename dom::cache::CacheTraits::TagType getTag(AbstractAddress addr) {
  AddressInterval itv = addr.getAsInterval();
  assert(getCachelineAddress<CacheConfig>(itv.lower()) ==
         getCachelineAddress<CacheConfig>(itv.upper()));

  return getTag<CacheConfig>(itv.lower());
}

/* returns (in cycles) how long the transfer of a cache line between cache and
 * main memory takes */
unsigned getCachelineMemoryLatency(CacheType type);

template <dom::cache::CacheTraits *CacheConfig>
unsigned getPerSetSize(const GlobalVariable *ds) {
  unsigned size = StaticAddrProvider->getArraySize(ds);
  unsigned base = StaticAddrProvider->getGlobalVarAddress(ds);

  /* If the array is not aligned at cacheline boundaries we have to
   * account for the initial part of the cacheline */
  size += base - getCachelineAddress<CacheConfig>(base);

  unsigned cacheSizePerAssoc = CacheConfig->N_SETS * CacheConfig->LINE_SIZE;

  unsigned perSetSize = size / cacheSizePerAssoc;

  if (size % cacheSizePerAssoc != 0) {
    ++perSetSize;
  }

  return perSetSize;
}

} // namespace TimingAnalysisPass

#endif
