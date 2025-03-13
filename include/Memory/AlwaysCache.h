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

#ifndef ALWAYSHITCACHE_H
#define ALWAYSHITCACHE_H_

#include <ostream>

#include "Memory/AbstractCache.h"
#include "Memory/CacheTraits.h"
#include "Memory/Classification.h"
#include "Memory/progana/Lattice.h"
#include "Util/AbstractAddress.h"
#include "Util/Options.h"
#include "Util/PersistenceScope.h"

namespace TimingAnalysisPass {

namespace dom {
namespace cache {

/**
 * \tparam T Cache traits
 *
 * \brief   Implements cache analysis that returns a fixed value for each
 * access.
 *
 */
template <CacheTraits *T>
class AlwaysCache : public progana::JoinSemiLattice, public AbstractCache {
  typedef AlwaysCache<T> Self;

private:
  CacheReplPolicyType replpol;

public:
  virtual ~AlwaysCache() {}
  AlwaysCache() = delete;
  AlwaysCache(CacheReplPolicyType replpol) : replpol(replpol) {
    assert(replpol == CacheReplPolicyType::ALHIT ||
           replpol == CacheReplPolicyType::ALMISS);
  }
  virtual AlwaysCache *clone() const { return new AlwaysCache(*this); }
  virtual Classification classify(const AbstractAddress &addr) const;
  virtual UpdateReport *
  update(const AbstractAddress &addr, AccessType load_store,
         bool wantReport = false,
         const Classification assumption = dom::cache::CL_UNKNOWN) {
    return wantReport ? new UpdateReport : nullptr;
  }
  virtual void join(const AbstractCache &y) {}
  virtual bool lessequal(const AbstractCache &y) const { return true; }
  virtual void enterScope(const PersistenceScope &scope) {}
  virtual void leaveScope(const PersistenceScope &scope) {}
  virtual std::set<PersistenceScope>
  getPersistentScopes(const AbstractAddress addr) const {
    return std::set<PersistenceScope>();
  }
  virtual bool equals(const AbstractCache &y) const { return true; }
  virtual std::ostream &dump(std::ostream &os) const;

  /**
   * Returns the address aligned to cache linesize
   */
  virtual Address alignToCacheline(const Address addr) const;
  /**
   * Returns the hit latency of this cache
   */
  virtual unsigned getHitLatency() const;
  /**
   * Return the write-policy of the underlying cache
   */
  virtual WritePolicy getWritePolicy() const;
};

template <CacheTraits *T>
Classification AlwaysCache<T>::classify(const AbstractAddress &addr) const {
  if (replpol == CacheReplPolicyType::ALMISS)
    return CL_MISS;
  return CL_HIT;
}

template <CacheTraits *T>
std::ostream &AlwaysCache<T>::dump(std::ostream &os) const {
  if (replpol == CacheReplPolicyType::ALMISS)
    os << "[ ALWAYS MISS ]";
  else
    os << "[ ALWAYS HIT ]";
  return os;
}

template <CacheTraits *T>
Address AlwaysCache<T>::alignToCacheline(const Address addr) const {
  return (addr / Address(T->LINE_SIZE)) * Address(T->LINE_SIZE);
}

template <CacheTraits *T> unsigned AlwaysCache<T>::getHitLatency() const {
  return T->LATENCY;
}

template <CacheTraits *T> WritePolicy AlwaysCache<T>::getWritePolicy() const {
  return WritePolicy{T->WRITEBACK, T->WRITEALLOCATE};
}

} // namespace cache
} // namespace dom

} // namespace TimingAnalysisPass

#endif /*ALWAYSHITCACHE_H_*/
