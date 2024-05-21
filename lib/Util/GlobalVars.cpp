#include "Util/GlobalVars.h"
#include "AnalysisFramework/AnalysisDriver.h"
#include "LLVMPasses/DispatchMemory.h"
#include "Memory/CacheTraits.h"
#include "Memory/LruMaxAgeAbstractCache.h"
#include "Memory/LruMinAgeAbstractCache.h"
#include "PathAnalysis/LoopBoundInfo.h"
#include "PreprocessingAnalysis/AddressInformation.h"
#include "Util/muticoreinfo.h"
#include <string>
#include <vector>

Multicoreinfo mcif(0);
std::vector<std::string> conflicFunctions;
bool isBCET = false;
int IMISS = 0;
int DMISS = 0;
int L2MISS = 0;
int STBUS = 0;
int BOUND = 0;
TimingAnalysisPass::AddressInformation *glAddrInfo = NULL;

unsigned getbound(const MachineBasicBlock *MBB,
                  const TimingAnalysisPass::Context &ctx) {
  for (const MachineLoop *loop :
       TimingAnalysisPass::LoopBoundInfo->getAllLoops()) {
    if (MBB->getParent() == loop->getHeader()->getParent() &&
        loop->contains(MBB)) {
      if (TimingAnalysisPass::LoopBoundInfo->hasUpperLoopBound(
              loop, TimingAnalysisPass::Context())) {
        return TimingAnalysisPass::LoopBoundInfo->getUpperLoopBound(
            loop, TimingAnalysisPass::Context());
      }
    }
  }
  return 1;
}