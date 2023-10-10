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

#include "Memory/AbstractCache.h"
#include "LLVMPasses/DispatchMemory.h"
#include "Memory/CacheTraits.h"
#include "Memory/CompositionalAbstractCache.h"
#include "Memory/ConditionalMustPersistence.h"
#include "Memory/DirtinessAnalysis.h"
#include "Memory/ElementWiseCountingPersistence.h"
#include "Memory/LruMaxAgeAbstractCache.h"
#include "Memory/LruMaxAgeArrayAwareCache.h"
#include "Memory/LruMinAgeAbstractCache.h"
#include "Memory/MultiScopePersistence.h"
#include "Memory/SetWiseCountingPersistence.h"
#include "Memory/UpdateReports.h"
#include "Memory/crpd/ConstrainedAges.h"
#include "Memory/crpd/DCUsefulCacheBlocks.h"
#include "Memory/crpd/EvictingCacheBlocks.h"
#include "Util/SharedStorage.h"
#include "Util/Util.h"
#include <vector>

namespace TimingAnalysisPass {

namespace dom {
namespace cache {

// add static member variables
template <CacheTraits *T, class C>
std::vector<typename util::_SharedStorage<C>::SharedPtr>
    AbstractCacheImpl<T, C>::L2cacheSets = {};

template <>
std::vector<typename util::_SharedStorage<
    LruMaxAgeAbstractCache<&icacheConf>>::SharedPtr>
    AbstractCacheImpl<&icacheConf,
                      LruMaxAgeAbstractCache<&icacheConf>>::L2cacheSets = {};

template <>
std::vector<typename util::_SharedStorage<
    LruMaxAgeAbstractCache<&dcacheConf>>::SharedPtr>
    AbstractCacheImpl<&dcacheConf,
                      LruMaxAgeAbstractCache<&dcacheConf>>::L2cacheSets = {};
template <>
std::vector<typename util::_SharedStorage<
    LruMinAgeAbstractCache<&icacheConf>>::SharedPtr>
    AbstractCacheImpl<&icacheConf,
                      LruMinAgeAbstractCache<&icacheConf>>::L2cacheSets = {};

template <>
std::vector<typename util::_SharedStorage<
    LruMinAgeAbstractCache<&dcacheConf>>::SharedPtr>
    AbstractCacheImpl<&dcacheConf,
                      LruMinAgeAbstractCache<&dcacheConf>>::L2cacheSets = {};
template <>
std::vector<typename util::_SharedStorage<
    DirtinessAnalysis<&icacheConf, LruMaxAgeArrayAwareCache<&icacheConf>,
                      LruMinAgeAbstractCache<&icacheConf>>>::SharedPtr>
    AbstractCacheImpl<
        &icacheConf,
        DirtinessAnalysis<&icacheConf, LruMaxAgeArrayAwareCache<&icacheConf>,
                          LruMinAgeAbstractCache<&icacheConf>>>::L2cacheSets =
        {};

template <>
std::vector<typename util::_SharedStorage<
    DirtinessAnalysis<&dcacheConf, LruMaxAgeArrayAwareCache<&dcacheConf>,
                      LruMinAgeAbstractCache<&dcacheConf>>>::SharedPtr>
    AbstractCacheImpl<
        &dcacheConf,
        DirtinessAnalysis<&dcacheConf, LruMaxAgeArrayAwareCache<&dcacheConf>,
                          LruMinAgeAbstractCache<&dcacheConf>>>::L2cacheSets =
        {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    DirtinessAnalysis<&icacheConf, LruMaxAgeArrayAwareCache<&icacheConf>,
                      LruMinAgeAbstractCache<&icacheConf>>,
    MultiScopePersistence<SetWiseCountingPersistence<&icacheConf>>>>::SharedPtr>
    AbstractCacheImpl<
        &icacheConf,
        CompositionalAbstractCache<
            DirtinessAnalysis<&icacheConf,
                              LruMaxAgeArrayAwareCache<&icacheConf>,
                              LruMinAgeAbstractCache<&icacheConf>>,
            MultiScopePersistence<SetWiseCountingPersistence<&icacheConf>>>>::
        L2cacheSets = {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    DirtinessAnalysis<&icacheConf, LruMaxAgeArrayAwareCache<&icacheConf>,
                      LruMinAgeAbstractCache<&icacheConf>>,
    CompositionalAbstractCache<
        MultiScopePersistence<SetWiseCountingPersistence<&icacheConf>>,
        MultiScopePersistence<ElementWiseCountingPersistence<&icacheConf>>>>>::
                SharedPtr>
    AbstractCacheImpl<
        &icacheConf,
        CompositionalAbstractCache<
            DirtinessAnalysis<&icacheConf,
                              LruMaxAgeArrayAwareCache<&icacheConf>,
                              LruMinAgeAbstractCache<&icacheConf>>,
            CompositionalAbstractCache<
                MultiScopePersistence<SetWiseCountingPersistence<&icacheConf>>,
                MultiScopePersistence<ElementWiseCountingPersistence<
                    &icacheConf>>>>>::L2cacheSets = {};

template <>
std::vector<util::_SharedStorage<CompositionalAbstractCache<
    DirtinessAnalysis<&icacheConf, LruMaxAgeArrayAwareCache<&icacheConf>,
                      LruMinAgeAbstractCache<&icacheConf>>,
    MultiScopePersistence<ElementWiseCountingPersistence<&icacheConf>>>>::
                SharedPtr>
    AbstractCacheImpl<
        &icacheConf, CompositionalAbstractCache<
                         DirtinessAnalysis<
                             &icacheConf, LruMaxAgeArrayAwareCache<&icacheConf>,
                             LruMinAgeAbstractCache<&icacheConf>>,
                         MultiScopePersistence<ElementWiseCountingPersistence<
                             &icacheConf>>>>::L2cacheSets = {};

template <>
std::vector<util::_SharedStorage<CompositionalAbstractCache<
    DirtinessAnalysis<&icacheConf, LruMaxAgeArrayAwareCache<&icacheConf>,
                      LruMinAgeAbstractCache<&icacheConf>>,
    CompositionalAbstractCache<
        MultiScopePersistence<SetWiseCountingPersistence<&icacheConf>>,
        MultiScopePersistence<ConditionalMustPersistence<&icacheConf>>>>>::
                SharedPtr>
    AbstractCacheImpl<
        &icacheConf,
        CompositionalAbstractCache<
            DirtinessAnalysis<&icacheConf,
                              LruMaxAgeArrayAwareCache<&icacheConf>,
                              LruMinAgeAbstractCache<&icacheConf>>,
            CompositionalAbstractCache<
                MultiScopePersistence<SetWiseCountingPersistence<&icacheConf>>,
                MultiScopePersistence<
                    ConditionalMustPersistence<&icacheConf>>>>>::L2cacheSets =
        {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    DirtinessAnalysis<&icacheConf, LruMaxAgeArrayAwareCache<&icacheConf>,
                      LruMinAgeAbstractCache<&icacheConf>>,
    MultiScopePersistence<ConditionalMustPersistence<&icacheConf>>>>::SharedPtr>
    AbstractCacheImpl<
        &icacheConf,
        CompositionalAbstractCache<
            DirtinessAnalysis<&icacheConf,
                              LruMaxAgeArrayAwareCache<&icacheConf>,
                              LruMinAgeAbstractCache<&icacheConf>>,
            MultiScopePersistence<ConditionalMustPersistence<&icacheConf>>>>::
        L2cacheSets = {};

template <>
std::vector<typename util::_SharedStorage<
    CompositionalAbstractCache<LruMaxAgeArrayAwareCache<&icacheConf>,
                               LruMinAgeAbstractCache<&icacheConf>>>::SharedPtr>
    AbstractCacheImpl<&icacheConf,
                      CompositionalAbstractCache<
                          LruMaxAgeArrayAwareCache<&icacheConf>,
                          LruMinAgeAbstractCache<&icacheConf>>>::L2cacheSets =
        {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    CompositionalAbstractCache<LruMaxAgeArrayAwareCache<&icacheConf>,
                               LruMinAgeAbstractCache<&icacheConf>>,
    MultiScopePersistence<SetWiseCountingPersistence<&icacheConf>>>>::SharedPtr>
    AbstractCacheImpl<
        &icacheConf,
        CompositionalAbstractCache<
            CompositionalAbstractCache<LruMaxAgeArrayAwareCache<&icacheConf>,
                                       LruMinAgeAbstractCache<&icacheConf>>,
            MultiScopePersistence<SetWiseCountingPersistence<&icacheConf>>>>::
        L2cacheSets = {};

template <>
std::vector<
    typename util::_SharedStorage<ConstrainedAges<&icacheConf>>::SharedPtr>
    AbstractCacheImpl<&icacheConf, ConstrainedAges<&icacheConf>>::L2cacheSets =
        {};

template <>
std::vector<
    typename util::_SharedStorage<DCUsefulCacheBlocks<&icacheConf>>::SharedPtr>
    AbstractCacheImpl<&icacheConf,
                      DCUsefulCacheBlocks<&icacheConf>>::L2cacheSets = {};
template <>
std::vector<
    typename util::_SharedStorage<EvictingCacheBlocks<&icacheConf>>::SharedPtr>
    AbstractCacheImpl<&icacheConf,
                      EvictingCacheBlocks<&icacheConf>>::L2cacheSets = {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    CompositionalAbstractCache<LruMaxAgeArrayAwareCache<&icacheConf>,
                               LruMinAgeAbstractCache<&icacheConf>>,
    CompositionalAbstractCache<
        MultiScopePersistence<SetWiseCountingPersistence<&icacheConf>>,
        MultiScopePersistence<ElementWiseCountingPersistence<&icacheConf>>>>>::
                SharedPtr>
    AbstractCacheImpl<
        &icacheConf,
        CompositionalAbstractCache<
            CompositionalAbstractCache<LruMaxAgeArrayAwareCache<&icacheConf>,
                                       LruMinAgeAbstractCache<&icacheConf>>,
            CompositionalAbstractCache<
                MultiScopePersistence<SetWiseCountingPersistence<&icacheConf>>,
                MultiScopePersistence<ElementWiseCountingPersistence<
                    &icacheConf>>>>>::L2cacheSets = {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    CompositionalAbstractCache<LruMaxAgeArrayAwareCache<&icacheConf>,
                               LruMinAgeAbstractCache<&icacheConf>>,
    MultiScopePersistence<ElementWiseCountingPersistence<&icacheConf>>>>::
                SharedPtr>
    AbstractCacheImpl<
        &icacheConf,
        CompositionalAbstractCache<
            CompositionalAbstractCache<LruMaxAgeArrayAwareCache<&icacheConf>,
                                       LruMinAgeAbstractCache<&icacheConf>>,
            MultiScopePersistence<
                ElementWiseCountingPersistence<&icacheConf>>>>::L2cacheSets =
        {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    CompositionalAbstractCache<LruMaxAgeArrayAwareCache<&icacheConf>,
                               LruMinAgeAbstractCache<&icacheConf>>,
    CompositionalAbstractCache<
        MultiScopePersistence<SetWiseCountingPersistence<&icacheConf>>,
        MultiScopePersistence<ConditionalMustPersistence<&icacheConf>>>>>::
                SharedPtr>
    AbstractCacheImpl<
        &icacheConf,
        CompositionalAbstractCache<
            CompositionalAbstractCache<LruMaxAgeArrayAwareCache<&icacheConf>,
                                       LruMinAgeAbstractCache<&icacheConf>>,
            CompositionalAbstractCache<
                MultiScopePersistence<SetWiseCountingPersistence<&icacheConf>>,
                MultiScopePersistence<
                    ConditionalMustPersistence<&icacheConf>>>>>::L2cacheSets =
        {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    CompositionalAbstractCache<LruMaxAgeArrayAwareCache<&icacheConf>,
                               LruMinAgeAbstractCache<&icacheConf>>,
    MultiScopePersistence<ConditionalMustPersistence<&icacheConf>>>>::SharedPtr>
    AbstractCacheImpl<
        &icacheConf,
        CompositionalAbstractCache<
            CompositionalAbstractCache<LruMaxAgeArrayAwareCache<&icacheConf>,
                                       LruMinAgeAbstractCache<&icacheConf>>,
            MultiScopePersistence<ConditionalMustPersistence<&icacheConf>>>>::
        L2cacheSets = {};

template <>
std::vector<typename util::_SharedStorage<
    DirtinessAnalysis<&icacheConf, LruMaxAgeAbstractCache<&icacheConf>,
                      LruMinAgeAbstractCache<&icacheConf>>>::SharedPtr>
    AbstractCacheImpl<
        &icacheConf,
        DirtinessAnalysis<&icacheConf, LruMaxAgeAbstractCache<&icacheConf>,
                          LruMinAgeAbstractCache<&icacheConf>>>::L2cacheSets =
        {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    DirtinessAnalysis<&icacheConf, LruMaxAgeAbstractCache<&icacheConf>,
                      LruMinAgeAbstractCache<&icacheConf>>,
    MultiScopePersistence<SetWiseCountingPersistence<&icacheConf>>>>::SharedPtr>
    AbstractCacheImpl<
        &icacheConf,
        CompositionalAbstractCache<
            DirtinessAnalysis<&icacheConf, LruMaxAgeAbstractCache<&icacheConf>,
                              LruMinAgeAbstractCache<&icacheConf>>,
            MultiScopePersistence<SetWiseCountingPersistence<&icacheConf>>>>::
        L2cacheSets = {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    DirtinessAnalysis<&icacheConf, LruMaxAgeAbstractCache<&icacheConf>,
                      LruMinAgeAbstractCache<&icacheConf>>,
    CompositionalAbstractCache<
        MultiScopePersistence<SetWiseCountingPersistence<&icacheConf>>,
        MultiScopePersistence<ElementWiseCountingPersistence<&icacheConf>>>>>::
                SharedPtr>
    AbstractCacheImpl<
        &icacheConf,
        CompositionalAbstractCache<
            DirtinessAnalysis<&icacheConf, LruMaxAgeAbstractCache<&icacheConf>,
                              LruMinAgeAbstractCache<&icacheConf>>,
            CompositionalAbstractCache<
                MultiScopePersistence<SetWiseCountingPersistence<&icacheConf>>,
                MultiScopePersistence<ElementWiseCountingPersistence<
                    &icacheConf>>>>>::L2cacheSets = {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    DirtinessAnalysis<&icacheConf, LruMaxAgeAbstractCache<&icacheConf>,
                      LruMinAgeAbstractCache<&icacheConf>>,
    MultiScopePersistence<ElementWiseCountingPersistence<&icacheConf>>>>::
                SharedPtr>
    AbstractCacheImpl<
        &icacheConf,
        CompositionalAbstractCache<
            DirtinessAnalysis<&icacheConf, LruMaxAgeAbstractCache<&icacheConf>,
                              LruMinAgeAbstractCache<&icacheConf>>,
            MultiScopePersistence<
                ElementWiseCountingPersistence<&icacheConf>>>>::L2cacheSets =
        {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    DirtinessAnalysis<&icacheConf, LruMaxAgeAbstractCache<&icacheConf>,
                      LruMinAgeAbstractCache<&icacheConf>>,
    CompositionalAbstractCache<
        MultiScopePersistence<SetWiseCountingPersistence<&icacheConf>>,
        MultiScopePersistence<ConditionalMustPersistence<&icacheConf>>>>>::
                SharedPtr>
    AbstractCacheImpl<
        &icacheConf,
        CompositionalAbstractCache<
            DirtinessAnalysis<&icacheConf, LruMaxAgeAbstractCache<&icacheConf>,
                              LruMinAgeAbstractCache<&icacheConf>>,
            CompositionalAbstractCache<
                MultiScopePersistence<SetWiseCountingPersistence<&icacheConf>>,
                MultiScopePersistence<
                    ConditionalMustPersistence<&icacheConf>>>>>::L2cacheSets =
        {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    DirtinessAnalysis<&icacheConf, LruMaxAgeAbstractCache<&icacheConf>,
                      LruMinAgeAbstractCache<&icacheConf>>,
    MultiScopePersistence<ConditionalMustPersistence<&icacheConf>>>>::SharedPtr>
    AbstractCacheImpl<
        &icacheConf,
        CompositionalAbstractCache<
            DirtinessAnalysis<&icacheConf, LruMaxAgeAbstractCache<&icacheConf>,
                              LruMinAgeAbstractCache<&icacheConf>>,
            MultiScopePersistence<ConditionalMustPersistence<&icacheConf>>>>::
        L2cacheSets = {};

template <>
std::vector<typename util::_SharedStorage<
    CompositionalAbstractCache<LruMaxAgeAbstractCache<&icacheConf>,
                               LruMinAgeAbstractCache<&icacheConf>>>::SharedPtr>
    AbstractCacheImpl<&icacheConf,
                      CompositionalAbstractCache<
                          LruMaxAgeAbstractCache<&icacheConf>,
                          LruMinAgeAbstractCache<&icacheConf>>>::L2cacheSets =
        {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    CompositionalAbstractCache<LruMaxAgeAbstractCache<&icacheConf>,
                               LruMinAgeAbstractCache<&icacheConf>>,
    MultiScopePersistence<SetWiseCountingPersistence<&icacheConf>>>>::SharedPtr>
    AbstractCacheImpl<
        &icacheConf,
        CompositionalAbstractCache<
            CompositionalAbstractCache<LruMaxAgeAbstractCache<&icacheConf>,
                                       LruMinAgeAbstractCache<&icacheConf>>,
            MultiScopePersistence<SetWiseCountingPersistence<&icacheConf>>>>::
        L2cacheSets = {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    CompositionalAbstractCache<LruMaxAgeAbstractCache<&icacheConf>,
                               LruMinAgeAbstractCache<&icacheConf>>,
    CompositionalAbstractCache<
        MultiScopePersistence<SetWiseCountingPersistence<&icacheConf>>,
        MultiScopePersistence<ElementWiseCountingPersistence<&icacheConf>>>>>::
                SharedPtr>
    AbstractCacheImpl<
        &icacheConf,
        CompositionalAbstractCache<
            CompositionalAbstractCache<LruMaxAgeAbstractCache<&icacheConf>,
                                       LruMinAgeAbstractCache<&icacheConf>>,
            CompositionalAbstractCache<
                MultiScopePersistence<SetWiseCountingPersistence<&icacheConf>>,
                MultiScopePersistence<ElementWiseCountingPersistence<
                    &icacheConf>>>>>::L2cacheSets = {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    CompositionalAbstractCache<LruMaxAgeAbstractCache<&icacheConf>,
                               LruMinAgeAbstractCache<&icacheConf>>,
    MultiScopePersistence<ElementWiseCountingPersistence<&icacheConf>>>>::
                SharedPtr>
    AbstractCacheImpl<
        &icacheConf,
        CompositionalAbstractCache<
            CompositionalAbstractCache<LruMaxAgeAbstractCache<&icacheConf>,
                                       LruMinAgeAbstractCache<&icacheConf>>,
            MultiScopePersistence<
                ElementWiseCountingPersistence<&icacheConf>>>>::L2cacheSets =
        {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    CompositionalAbstractCache<LruMaxAgeAbstractCache<&icacheConf>,
                               LruMinAgeAbstractCache<&icacheConf>>,
    CompositionalAbstractCache<
        MultiScopePersistence<SetWiseCountingPersistence<&icacheConf>>,
        MultiScopePersistence<ConditionalMustPersistence<&icacheConf>>>>>::
                SharedPtr>
    AbstractCacheImpl<
        &icacheConf,
        CompositionalAbstractCache<
            CompositionalAbstractCache<LruMaxAgeAbstractCache<&icacheConf>,
                                       LruMinAgeAbstractCache<&icacheConf>>,
            CompositionalAbstractCache<
                MultiScopePersistence<SetWiseCountingPersistence<&icacheConf>>,
                MultiScopePersistence<
                    ConditionalMustPersistence<&icacheConf>>>>>::L2cacheSets =
        {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    CompositionalAbstractCache<LruMaxAgeAbstractCache<&icacheConf>,
                               LruMinAgeAbstractCache<&icacheConf>>,
    MultiScopePersistence<ConditionalMustPersistence<&icacheConf>>>>::SharedPtr>
    AbstractCacheImpl<
        &icacheConf,
        CompositionalAbstractCache<
            CompositionalAbstractCache<LruMaxAgeAbstractCache<&icacheConf>,
                                       LruMinAgeAbstractCache<&icacheConf>>,
            MultiScopePersistence<ConditionalMustPersistence<&icacheConf>>>>::
        L2cacheSets = {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    CompositionalAbstractCache<LruMaxAgeAbstractCache<&icacheConf>,
                               LruMinAgeAbstractCache<&icacheConf>>,
    MultiScopePersistence<ConditionalMustPersistence<&icacheConf>>>>::SharedPtr>
    AbstractCacheImpl<
        &dcacheConf,
        CompositionalAbstractCache<
            CompositionalAbstractCache<LruMaxAgeAbstractCache<&icacheConf>,
                                       LruMinAgeAbstractCache<&icacheConf>>,
            MultiScopePersistence<ConditionalMustPersistence<&icacheConf>>>>::
        L2cacheSets = {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    DirtinessAnalysis<&dcacheConf, LruMaxAgeArrayAwareCache<&dcacheConf>,
                      LruMinAgeAbstractCache<&dcacheConf>>,
    MultiScopePersistence<SetWiseCountingPersistence<&dcacheConf>>>>::SharedPtr>
    AbstractCacheImpl<
        &dcacheConf,
        CompositionalAbstractCache<
            DirtinessAnalysis<&dcacheConf,
                              LruMaxAgeArrayAwareCache<&dcacheConf>,
                              LruMinAgeAbstractCache<&dcacheConf>>,
            MultiScopePersistence<SetWiseCountingPersistence<&dcacheConf>>>>::
        L2cacheSets = {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    DirtinessAnalysis<&dcacheConf, LruMaxAgeArrayAwareCache<&dcacheConf>,
                      LruMinAgeAbstractCache<&dcacheConf>>,
    CompositionalAbstractCache<
        MultiScopePersistence<SetWiseCountingPersistence<&dcacheConf>>,
        MultiScopePersistence<ElementWiseCountingPersistence<&dcacheConf>>>>>::
                SharedPtr>
    AbstractCacheImpl<
        &dcacheConf,
        CompositionalAbstractCache<
            DirtinessAnalysis<&dcacheConf,
                              LruMaxAgeArrayAwareCache<&dcacheConf>,
                              LruMinAgeAbstractCache<&dcacheConf>>,
            CompositionalAbstractCache<
                MultiScopePersistence<SetWiseCountingPersistence<&dcacheConf>>,
                MultiScopePersistence<ElementWiseCountingPersistence<
                    &dcacheConf>>>>>::L2cacheSets = {};

template <>
std::vector<
    typename util::_SharedStorage<ConstrainedAges<&dcacheConf>>::SharedPtr>
    AbstractCacheImpl<&dcacheConf, ConstrainedAges<&dcacheConf>>::L2cacheSets =
        {};

template <>
std::vector<
    typename util::_SharedStorage<DCUsefulCacheBlocks<&dcacheConf>>::SharedPtr>
    AbstractCacheImpl<&dcacheConf,
                      DCUsefulCacheBlocks<&dcacheConf>>::L2cacheSets = {};

template <>
std::vector<
    typename util::_SharedStorage<EvictingCacheBlocks<&dcacheConf>>::SharedPtr>
    AbstractCacheImpl<&dcacheConf,
                      EvictingCacheBlocks<&dcacheConf>>::L2cacheSets = {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    DirtinessAnalysis<&dcacheConf, LruMaxAgeArrayAwareCache<&dcacheConf>,
                      LruMinAgeAbstractCache<&dcacheConf>>,
    MultiScopePersistence<ElementWiseCountingPersistence<&dcacheConf>>>>::
                SharedPtr>
    AbstractCacheImpl<
        &dcacheConf, CompositionalAbstractCache<
                         DirtinessAnalysis<
                             &dcacheConf, LruMaxAgeArrayAwareCache<&dcacheConf>,
                             LruMinAgeAbstractCache<&dcacheConf>>,
                         MultiScopePersistence<ElementWiseCountingPersistence<
                             &dcacheConf>>>>::L2cacheSets = {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    CompositionalAbstractCache<LruMaxAgeAbstractCache<&dcacheConf>,
                               LruMinAgeAbstractCache<&dcacheConf>>,
    MultiScopePersistence<ConditionalMustPersistence<&dcacheConf>>>>::SharedPtr>
    AbstractCacheImpl<
        &dcacheConf,
        CompositionalAbstractCache<
            CompositionalAbstractCache<LruMaxAgeAbstractCache<&dcacheConf>,
                                       LruMinAgeAbstractCache<&dcacheConf>>,
            MultiScopePersistence<ConditionalMustPersistence<&dcacheConf>>>>::
        L2cacheSets = {};

template <>
std::vector<typename util::SharedStorage<CompositionalAbstractCache<
    CompositionalAbstractCache<LruMaxAgeAbstractCache<&dcacheConf>,
                               LruMinAgeAbstractCache<&dcacheConf>>,
    CompositionalAbstractCache<
        MultiScopePersistence<SetWiseCountingPersistence<&dcacheConf>>,
        MultiScopePersistence<ConditionalMustPersistence<&dcacheConf>>>>>::
                SharedPtr>
    AbstractCacheImpl<
        &dcacheConf,
        CompositionalAbstractCache<
            CompositionalAbstractCache<LruMaxAgeAbstractCache<&dcacheConf>,
                                       LruMinAgeAbstractCache<&dcacheConf>>,
            CompositionalAbstractCache<
                MultiScopePersistence<SetWiseCountingPersistence<&dcacheConf>>,
                MultiScopePersistence<
                    ConditionalMustPersistence<&dcacheConf>>>>>::L2cacheSets =
        {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    CompositionalAbstractCache<LruMaxAgeAbstractCache<&dcacheConf>,
                               LruMinAgeAbstractCache<&dcacheConf>>,
    MultiScopePersistence<ElementWiseCountingPersistence<&dcacheConf>>>>::
                SharedPtr>
    AbstractCacheImpl<
        &dcacheConf,
        CompositionalAbstractCache<
            CompositionalAbstractCache<LruMaxAgeAbstractCache<&dcacheConf>,
                                       LruMinAgeAbstractCache<&dcacheConf>>,
            MultiScopePersistence<
                ElementWiseCountingPersistence<&dcacheConf>>>>::L2cacheSets =
        {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    CompositionalAbstractCache<LruMaxAgeAbstractCache<&dcacheConf>,
                               LruMinAgeAbstractCache<&dcacheConf>>,
    CompositionalAbstractCache<
        MultiScopePersistence<SetWiseCountingPersistence<&dcacheConf>>,
        MultiScopePersistence<ElementWiseCountingPersistence<&dcacheConf>>>>>::
                SharedPtr>
    AbstractCacheImpl<
        &dcacheConf,
        CompositionalAbstractCache<
            CompositionalAbstractCache<LruMaxAgeAbstractCache<&dcacheConf>,
                                       LruMinAgeAbstractCache<&dcacheConf>>,
            CompositionalAbstractCache<
                MultiScopePersistence<SetWiseCountingPersistence<&dcacheConf>>,
                MultiScopePersistence<ElementWiseCountingPersistence<
                    &dcacheConf>>>>>::L2cacheSets = {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    CompositionalAbstractCache<LruMaxAgeAbstractCache<&dcacheConf>,
                               LruMinAgeAbstractCache<&dcacheConf>>,
    MultiScopePersistence<SetWiseCountingPersistence<&dcacheConf>>>>::SharedPtr>
    AbstractCacheImpl<
        &dcacheConf,
        CompositionalAbstractCache<
            CompositionalAbstractCache<LruMaxAgeAbstractCache<&dcacheConf>,
                                       LruMinAgeAbstractCache<&dcacheConf>>,
            MultiScopePersistence<SetWiseCountingPersistence<&dcacheConf>>>>::
        L2cacheSets = {};

template <>
std::vector<typename util::_SharedStorage<
    CompositionalAbstractCache<LruMaxAgeAbstractCache<&dcacheConf>,
                               LruMinAgeAbstractCache<&dcacheConf>>>::SharedPtr>
    AbstractCacheImpl<&dcacheConf,
                      CompositionalAbstractCache<
                          LruMaxAgeAbstractCache<&dcacheConf>,
                          LruMinAgeAbstractCache<&dcacheConf>>>::L2cacheSets =
        {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    DirtinessAnalysis<&dcacheConf, LruMaxAgeAbstractCache<&dcacheConf>,
                      LruMinAgeAbstractCache<&dcacheConf>>,
    MultiScopePersistence<ConditionalMustPersistence<&dcacheConf>>>>::SharedPtr>
    AbstractCacheImpl<
        &dcacheConf,
        CompositionalAbstractCache<
            DirtinessAnalysis<&dcacheConf, LruMaxAgeAbstractCache<&dcacheConf>,
                              LruMinAgeAbstractCache<&dcacheConf>>,
            MultiScopePersistence<ConditionalMustPersistence<&dcacheConf>>>>::
        L2cacheSets = {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    DirtinessAnalysis<&dcacheConf, LruMaxAgeAbstractCache<&dcacheConf>,
                      LruMinAgeAbstractCache<&dcacheConf>>,
    CompositionalAbstractCache<
        MultiScopePersistence<SetWiseCountingPersistence<&dcacheConf>>,
        MultiScopePersistence<ConditionalMustPersistence<&dcacheConf>>>>>::
                SharedPtr>
    AbstractCacheImpl<
        &dcacheConf,
        CompositionalAbstractCache<
            DirtinessAnalysis<&dcacheConf, LruMaxAgeAbstractCache<&dcacheConf>,
                              LruMinAgeAbstractCache<&dcacheConf>>,
            CompositionalAbstractCache<
                MultiScopePersistence<SetWiseCountingPersistence<&dcacheConf>>,
                MultiScopePersistence<
                    ConditionalMustPersistence<&dcacheConf>>>>>::L2cacheSets =
        {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    DirtinessAnalysis<&dcacheConf, LruMaxAgeAbstractCache<&dcacheConf>,
                      LruMinAgeAbstractCache<&dcacheConf>>,
    MultiScopePersistence<ElementWiseCountingPersistence<&dcacheConf>>>>::
                SharedPtr>
    AbstractCacheImpl<
        &dcacheConf,
        CompositionalAbstractCache<
            DirtinessAnalysis<&dcacheConf, LruMaxAgeAbstractCache<&dcacheConf>,
                              LruMinAgeAbstractCache<&dcacheConf>>,
            MultiScopePersistence<
                ElementWiseCountingPersistence<&dcacheConf>>>>::L2cacheSets =
        {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    DirtinessAnalysis<&dcacheConf, LruMaxAgeAbstractCache<&dcacheConf>,
                      LruMinAgeAbstractCache<&dcacheConf>>,
    CompositionalAbstractCache<
        MultiScopePersistence<SetWiseCountingPersistence<&dcacheConf>>,
        MultiScopePersistence<ElementWiseCountingPersistence<&dcacheConf>>>>>::
                SharedPtr>
    AbstractCacheImpl<
        &dcacheConf,
        CompositionalAbstractCache<
            DirtinessAnalysis<&dcacheConf, LruMaxAgeAbstractCache<&dcacheConf>,
                              LruMinAgeAbstractCache<&dcacheConf>>,
            CompositionalAbstractCache<
                MultiScopePersistence<SetWiseCountingPersistence<&dcacheConf>>,
                MultiScopePersistence<ElementWiseCountingPersistence<
                    &dcacheConf>>>>>::L2cacheSets = {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    DirtinessAnalysis<&dcacheConf, LruMaxAgeAbstractCache<&dcacheConf>,
                      LruMinAgeAbstractCache<&dcacheConf>>,
    MultiScopePersistence<SetWiseCountingPersistence<&dcacheConf>>>>::SharedPtr>
    AbstractCacheImpl<
        &dcacheConf,
        CompositionalAbstractCache<
            DirtinessAnalysis<&dcacheConf, LruMaxAgeAbstractCache<&dcacheConf>,
                              LruMinAgeAbstractCache<&dcacheConf>>,
            MultiScopePersistence<SetWiseCountingPersistence<&dcacheConf>>>>::
        L2cacheSets = {};

template <>
std::vector<typename util::_SharedStorage<
    DirtinessAnalysis<&dcacheConf, LruMaxAgeAbstractCache<&dcacheConf>,
                      LruMinAgeAbstractCache<&dcacheConf>>>::SharedPtr>
    AbstractCacheImpl<
        &dcacheConf,
        DirtinessAnalysis<&dcacheConf, LruMaxAgeAbstractCache<&dcacheConf>,
                          LruMinAgeAbstractCache<&dcacheConf>>>::L2cacheSets =
        {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    CompositionalAbstractCache<LruMaxAgeArrayAwareCache<&dcacheConf>,
                               LruMinAgeAbstractCache<&dcacheConf>>,
    MultiScopePersistence<ConditionalMustPersistence<&dcacheConf>>>>::SharedPtr>
    AbstractCacheImpl<
        &dcacheConf,
        CompositionalAbstractCache<
            CompositionalAbstractCache<LruMaxAgeArrayAwareCache<&dcacheConf>,
                                       LruMinAgeAbstractCache<&dcacheConf>>,
            MultiScopePersistence<ConditionalMustPersistence<&dcacheConf>>>>::
        L2cacheSets = {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    CompositionalAbstractCache<LruMaxAgeArrayAwareCache<&dcacheConf>,
                               LruMinAgeAbstractCache<&dcacheConf>>,
    CompositionalAbstractCache<
        MultiScopePersistence<SetWiseCountingPersistence<&dcacheConf>>,
        MultiScopePersistence<ConditionalMustPersistence<&dcacheConf>>>>>::
                SharedPtr>
    AbstractCacheImpl<
        &dcacheConf,
        CompositionalAbstractCache<
            CompositionalAbstractCache<LruMaxAgeArrayAwareCache<&dcacheConf>,
                                       LruMinAgeAbstractCache<&dcacheConf>>,
            CompositionalAbstractCache<
                MultiScopePersistence<SetWiseCountingPersistence<&dcacheConf>>,
                MultiScopePersistence<
                    ConditionalMustPersistence<&dcacheConf>>>>>::L2cacheSets =
        {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    CompositionalAbstractCache<LruMaxAgeArrayAwareCache<&dcacheConf>,
                               LruMinAgeAbstractCache<&dcacheConf>>,
    MultiScopePersistence<ElementWiseCountingPersistence<&dcacheConf>>>>::
                SharedPtr>
    AbstractCacheImpl<
        &dcacheConf,
        CompositionalAbstractCache<
            CompositionalAbstractCache<LruMaxAgeArrayAwareCache<&dcacheConf>,
                                       LruMinAgeAbstractCache<&dcacheConf>>,
            MultiScopePersistence<
                ElementWiseCountingPersistence<&dcacheConf>>>>::L2cacheSets =
        {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    CompositionalAbstractCache<LruMaxAgeArrayAwareCache<&dcacheConf>,
                               LruMinAgeAbstractCache<&dcacheConf>>,
    CompositionalAbstractCache<
        MultiScopePersistence<SetWiseCountingPersistence<&dcacheConf>>,
        MultiScopePersistence<ElementWiseCountingPersistence<&dcacheConf>>>>>::
                SharedPtr>
    AbstractCacheImpl<
        &dcacheConf,
        CompositionalAbstractCache<
            CompositionalAbstractCache<LruMaxAgeArrayAwareCache<&dcacheConf>,
                                       LruMinAgeAbstractCache<&dcacheConf>>,
            CompositionalAbstractCache<
                MultiScopePersistence<SetWiseCountingPersistence<&dcacheConf>>,
                MultiScopePersistence<ElementWiseCountingPersistence<
                    &dcacheConf>>>>>::L2cacheSets = {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    CompositionalAbstractCache<LruMaxAgeArrayAwareCache<&dcacheConf>,
                               LruMinAgeAbstractCache<&dcacheConf>>,
    MultiScopePersistence<SetWiseCountingPersistence<&dcacheConf>>>>::SharedPtr>
    AbstractCacheImpl<
        &dcacheConf,
        CompositionalAbstractCache<
            CompositionalAbstractCache<LruMaxAgeArrayAwareCache<&dcacheConf>,
                                       LruMinAgeAbstractCache<&dcacheConf>>,
            MultiScopePersistence<SetWiseCountingPersistence<&dcacheConf>>>>::
        L2cacheSets = {};

template <>
std::vector<typename util::_SharedStorage<
    CompositionalAbstractCache<LruMaxAgeArrayAwareCache<&dcacheConf>,
                               LruMinAgeAbstractCache<&dcacheConf>>>::SharedPtr>
    AbstractCacheImpl<&dcacheConf,
                      CompositionalAbstractCache<
                          LruMaxAgeArrayAwareCache<&dcacheConf>,
                          LruMinAgeAbstractCache<&dcacheConf>>>::L2cacheSets =
        {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    DirtinessAnalysis<&dcacheConf, LruMaxAgeArrayAwareCache<&dcacheConf>,
                      LruMinAgeAbstractCache<&dcacheConf>>,
    MultiScopePersistence<ConditionalMustPersistence<&dcacheConf>>>>::SharedPtr>
    AbstractCacheImpl<
        &dcacheConf,
        CompositionalAbstractCache<
            DirtinessAnalysis<&dcacheConf,
                              LruMaxAgeArrayAwareCache<&dcacheConf>,
                              LruMinAgeAbstractCache<&dcacheConf>>,
            MultiScopePersistence<ConditionalMustPersistence<&dcacheConf>>>>::
        L2cacheSets = {};

template <>
std::vector<typename util::_SharedStorage<CompositionalAbstractCache<
    DirtinessAnalysis<&dcacheConf, LruMaxAgeArrayAwareCache<&dcacheConf>,
                      LruMinAgeAbstractCache<&dcacheConf>>,
    CompositionalAbstractCache<
        MultiScopePersistence<SetWiseCountingPersistence<&dcacheConf>>,
        MultiScopePersistence<ConditionalMustPersistence<&dcacheConf>>>>>::
                SharedPtr>
    AbstractCacheImpl<
        &dcacheConf,
        CompositionalAbstractCache<
            DirtinessAnalysis<&dcacheConf,
                              LruMaxAgeArrayAwareCache<&dcacheConf>,
                              LruMinAgeAbstractCache<&dcacheConf>>,
            CompositionalAbstractCache<
                MultiScopePersistence<SetWiseCountingPersistence<&dcacheConf>>,
                MultiScopePersistence<
                    ConditionalMustPersistence<&dcacheConf>>>>>::L2cacheSets =
        {};

std::ostream &operator<<(std::ostream &os, const AbstractCache &x) {
  return x.dump(os);
}

} // namespace cache
} // namespace dom
} // namespace TimingAnalysisPass
