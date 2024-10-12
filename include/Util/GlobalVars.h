#ifndef __G10bAL_vARs__
#define __G10bAL_vARs__

#include "PreprocessingAnalysis/AddressInformation.h"
#include "muticoreinfo.h"
#include <cstdint>
#include <string>
#include <vector>
extern Multicoreinfo mcif;
extern bool isBCET;
extern std::vector<std::string> conflicFunctions;
extern uint64_t IMISS;
extern uint64_t DMISS;
extern uint64_t STBUS;
extern uint64_t L2MISS;
extern uint64_t BOUND;
extern unsigned currentCore;
extern TimingAnalysisPass::AddressInformation *glAddrInfo;
extern llvm::Module *ModulePtr;

#define COL_LEN 0

unsigned getbound(const MachineBasicBlock *MBB,
                  const TimingAnalysisPass::Context &ctx);
#endif