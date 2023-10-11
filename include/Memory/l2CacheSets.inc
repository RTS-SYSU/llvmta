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