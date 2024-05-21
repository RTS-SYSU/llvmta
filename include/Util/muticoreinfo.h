#ifndef MUTICORE_INFORMATION
#define MUTICORE_INFORMATION

#include "Util/AbstractAddress.h"
#include "Util/Options.h"
#include <cstddef>
#include <map>
#include <set>
#include <string>
#include <utility>
#include <vector>

// namespace {
// #define CHECK_CORE_VALIE(CORE) \
//   if () {                                                     \
//     fprintf(stderr, "Error: CoreNum(%u) is out of range(%u)\n", (CORE), \
//             CoreNums.getValue()); \
//     return NULL; \
//   }
//   assert((CORE)<=CoreNums,"Error: CoreNum is out of range\n")
// } // namespace

class Multicoreinfo {
private:
  // CoreNum -> <Earlest Start, Latest Stop>
  std::vector<std::vector<std::pair<unsigned, unsigned>>> schedule;

  // CoreNum -> map<function, index>
  // BTW, this is actually core order (orz)
  std::vector<std::map<std::string, unsigned>> coreOrz;

public:
  bool change;
  // // function->address of Instruction->地址的执行次数   //不用地址，用block
  std::map<std::string, std::map<unsigned, unsigned>> addressinfowithtime;
  std::map<std::string, std::set<unsigned>> addressinfo;
  // CoreNum -> vector of function
  std::vector<std::vector<std::string>> coreinfo;
  Multicoreinfo();
  // Make all constructor and destructor to be default
  Multicoreinfo(unsigned coreNum)
      : schedule(coreNum), coreinfo(coreNum), coreOrz(coreNum), change(true){};
  ~Multicoreinfo() = default;
  Multicoreinfo(const Multicoreinfo &) = default;

  void setSize(unsigned core) {
    schedule.resize(core);
    coreinfo.resize(core);
    // addressinfo.resize(core);
    coreOrz.resize(core);
  }

  void addaddress(std::string function, unsigned addressLINE, int time) {
    if (SPersistenceA) {
      addressinfowithtime.at(function)[addressLINE] += time;
    }
    addaddress(function, addressLINE);
  }

  void addaddress(std::string function, unsigned addressLINE) {
    addressinfo.at(function).insert(addressLINE);
  }

  void addaddress(std::string function, std::vector<unsigned> &addrlist,
                  int time) {
    for (auto &addr : addrlist) {
      addaddress(function, addr, time);
    }
  }
  // void addaddress(std::string function,
  //                 TimingAnalysisPass::AbstractAddress &addr, int time) {
  //   //未知的地址不管
  //   if (addr.isSameInterval(
  //           TimingAnalysisPass::AbstractAddress::getUnknownAddress())) {
  //     return;
  //   }
  //   //数组的地址会转换为地址范围
  //   unsigned lowAligned = addr.getAsInterval().lower() & ~(Dlinesize - 1);
  //   unsigned upAligned = addr.getAsInterval().upper() & ~(Dlinesize - 1);
  //   while (lowAligned <= upAligned) {
  //     addaddress(function, lowAligned, time);
  //     lowAligned += Dlinesize;
  //   }
  // }

  void addTask(unsigned num, const std::string &function) {
    // if (num > CoreNums) {
    //   fprintf(stderr, "Error: CoreNum(%u) is out of range(%u)", num,
    //           CoreNums.getValue());
    //   return;
    // }
    // Don't you think this is cool?
    // CHECK_CORE_VALIE(num)

    coreinfo[num].emplace_back(function);
    //对没有分析过的函数进行访存信息收集
    if (addressinfo.find(function) == addressinfo.end()) {
      addressinfowithtime.insert(
          std::make_pair(function, std::map<unsigned, unsigned>{}));
      addressinfo.insert(std::make_pair(function, std::set<unsigned>{}));
    }
    coreOrz[num].insert(std::make_pair(function, coreinfo[num].size() - 1));
    schedule[num].emplace_back(std::make_pair(0, 0));
  }

  void setTaskTime(unsigned core, const std::string &function,
                   unsigned early = 0, unsigned latest = 0) {
    // CHECK_CORE_VALIE(core)

    if (coreOrz[core].count(function) == 0) {
      fprintf(stderr, "Function %s can not found on core %u\n",
              function.c_str(), core);
      return;
    }

    schedule[core][coreOrz[core][function]].first = early;
    schedule[core][coreOrz[core][function]].second = latest;
  }

  void updateTaskTime(unsigned core, const std::string &function,
                      unsigned early = 0, unsigned latest = 0) {
    // CHECK_CORE_VALIE(core)

    if (coreOrz[core].count(function) == 0) {
      fprintf(stderr, "Function %s can not found on core %u\n",
              function.c_str(), core);
      return;
    }

    unsigned taskNum = coreOrz[core][function];
    unsigned preLend = schedule[core][taskNum].second;
    bool changed = false;
    if (taskNum == 0) {
      schedule[core][taskNum].second = 0u + latest;
    } else {
      schedule[core][taskNum].second =
          schedule[core][taskNum - 1].second + latest;
    }
    if (preLend != schedule[core][taskNum].second) {
      changed = true;
    }
    if (taskNum != schedule[core].size() - 1) {
      unsigned pre = schedule[core][taskNum + 1].first;
      schedule[core][taskNum + 1].first = schedule[core][taskNum].first + early;
      if (pre != schedule[core][taskNum + 1].first) {
        changed = true;
      }
    }
    this->change = changed;
  }

  std::vector<std::string> getConflictFunction(unsigned core,
                                               const std::string &function) {
    std::vector<std::string> list;
    auto liftime = schedule[core][coreOrz[core][function]];
    // if (liftime.first == 0 || liftime.second == 0) {
    //   list.emplace_back("ALL");
    //   return list;
    // }
    for (int i = 0; i < schedule.size(); i++) {
      if (i == core) {
        continue;
      }
      for (int j = 0; j < schedule[i].size(); j++) {
        auto &tlifetime = schedule[i][j];
        if (tlifetime.second > liftime.first &&
                tlifetime.second < liftime.second ||
            tlifetime.first >= liftime.first &&
                tlifetime.first < liftime.second ||
            liftime.first >= tlifetime.first &&
                liftime.second <= tlifetime.second) {
          list.emplace_back(coreinfo[i][j]);
        }
      }
    }
    return list;
  }
  std::pair<unsigned, unsigned> getlifetime(unsigned core,
                                            const std::string &function) {
    return schedule[core][coreOrz[core][function]];
  }

  std::pair<unsigned, unsigned> getPreTask(unsigned core,
                                           const std::string &function) {
    // CHECK_CORE_VALIE(core)

    int pre = coreOrz[core][function] - 1;
    if (pre >= 0) {
      return schedule[core][pre];
    }
    return std::make_pair(0u, 0u);
  }
};

#endif