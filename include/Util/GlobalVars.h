#ifndef __G10bAL_vARs__
#define __G10bAL_vARs__

#include "Memory/Classification.h"
#include "PreprocessingAnalysis/AddressInformation.h"
#include "Util/PersistenceScope.h"
#include "muticoreinfo.h"
#include "llvm/CodeGen/MachineInstr.h"
#include "llvm/TableGen/Record.h"
#include <ios>
#include <iostream>
#include <ostream>
#include <string>
#include <vector>

extern Multicoreinfo mcif;
extern bool isBCET;
extern std::vector<std::string> conflicFunctions;
extern int IMISS;
extern int DMISS;
extern int STBUS;
extern int L2MISS;
extern int BOUND;

class functionaddr {
public:
  functionaddr(std::string f) { this->functionname = f; }
  std::string functionname;
  std::set<unsigned> addrlist;
  // 打印函数
  void print() const {
    std::cout << "Function Name: " << functionname << "\n";
    std::cout << "Addresses: ";
    for (const auto &addr : addrlist) {
      std::cout << addr << " ";
    }
    std::cout << "\n";
  }
  void print(std::ostream& out) const {
    out << "Function Name: " << functionname << "\n";
    out << "Addresses: ";
    for (const auto &addr : addrlist) {
        out << addr << " ";
    }
    out << "\n";
  }
};


extern std::map<std::string, std::set<functionaddr *>> functiontofs;
extern std::map<std::string, functionaddr *> getfunctionaddr;
extern std::map<std::string, unsigned> func2corenum;
// 记录已经分析过执行次数的块
extern std::set<const MachineBasicBlock *> mylist;

extern TimingAnalysisPass::AddressInformation *glAddrInfo;

unsigned getbound(const MachineBasicBlock *MBB,
                  const TimingAnalysisPass::Context &ctx);

void celectaddr(const MachineBasicBlock *MBB,
                const TimingAnalysisPass::Context &ctx);
#endif