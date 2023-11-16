#include "Util/GlobalVars.h"
#include "LLVMPasses/DispatchMemory.h"
#include "Memory/CacheTraits.h"
#include "Memory/LruMaxAgeAbstractCache.h"
#include "Memory/LruMinAgeAbstractCache.h"
#include "Util/muticoreinfo.h"
#include <string>
#include <vector>

Multicoreinfo mcif(0);

std::vector<std::string> conflicFunctions;

// TimingAnalysisPass::dom::cache::LruMaxAgeAbstractCache<
//     &TimingAnalysisPass::icacheConf>
//     analysis1;
