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
std::set<const MachineBasicBlock *> mylist;

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

void celectaddr(const MachineBasicBlock *MBB,
                const TimingAnalysisPass::Context &ctx) {
  if (mylist.count(MBB) == 0) {
    if (SPersistenceA && L2CachePersType == PersistenceType::ELEWISE) {
      // jjy：持久性内存块争用分析
      int time = getbound(MBB, ctx);
      // int time = 1;
      //   mcif.addaddress(AnalysisEntryPoint, addrIlist, time);
    } else {
      // jjy：普通争用分析
      //   for (auto &al : addrIlist) {
      //     mcif.addaddress(AnalysisEntryPoint, al);
      //   }
    }
    mylist.insert(MBB);
  }
}