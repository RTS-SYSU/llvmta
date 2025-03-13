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

class Multicoreinfo {
private:
  // CoreNum -> <Earlest Start, Latest Stop>list
  std::vector<std::vector<std::pair<unsigned, unsigned>>> schedule;
  // CoreNum -> <BCET, WCET>list
  std::vector<std::vector<std::pair<unsigned, unsigned>>> BWtime;

  // CoreNum -> map<function, index>
  // BTW, this is actually core order (orz)
  std::vector<std::map<std::string, unsigned>> coreOrz;

public:
  // // function->address of Instruction->地址的执行次数   //不用地址，用block
  std::map<std::string, std::map<unsigned, unsigned>> addressinfowithtime;
  std::map<std::string, std::set<unsigned>> addressinfo;
  // CoreNum -> vector of function
  std::vector<std::vector<std::string>> coreinfo;
  Multicoreinfo();
  // Make all constructor and destructor to be default
  Multicoreinfo(unsigned coreNum)
      : schedule(coreNum), BWtime(coreNum), coreinfo(coreNum),
        coreOrz(coreNum){};
  ~Multicoreinfo() = default;
  Multicoreinfo(const Multicoreinfo &) = default;

  void setSize(unsigned core) {
    schedule.resize(core);
    BWtime.resize(core);
    coreinfo.resize(core);
    // addressinfo.resize(core);
    coreOrz.resize(core);
  }

  void addaddress(std::string function, unsigned addressLINE) {
    addressinfo.at(function).insert(addressLINE);
  }

  void addaddress(std::string function, std::vector<unsigned> &addrlist,
                  int time) {
    for (auto &addressLINE : addrlist) {
      addressinfowithtime.at(function)[addressLINE] += time;
      addressinfo.at(function).insert(addressLINE);
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
    coreinfo[num].emplace_back(function);
    //对没有分析过的函数进行访存信息收集
    if (addressinfo.find(function) == addressinfo.end()) {
      addressinfowithtime.insert(
          std::make_pair(function, std::map<unsigned, unsigned>{}));
      addressinfo.insert(std::make_pair(function, std::set<unsigned>{}));
    }
    coreOrz[num].insert(std::make_pair(function, coreinfo[num].size() - 1));
    schedule[num].emplace_back(std::make_pair(0, 0));
    BWtime[num].emplace_back(std::make_pair(0, 0));
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

  bool updateTaskTime(unsigned core, const std::string &function,
                      unsigned early = 0, unsigned latest = 0) {
    if (coreOrz[core].count(function) == 0) {
      fprintf(stderr, "Function %s can not found on core %u\n",
              function.c_str(), core);
      return false;
    }
    bool changed = false;
    unsigned taskNum = coreOrz[core][function];
    if (BWtime[core][taskNum].first != early ||
        BWtime[core][taskNum].second != latest) {
      changed = true;
      //更新 执行时间
      BWtime[core][taskNum].first = early;
      BWtime[core][taskNum].second =latest;
    }
    //更新生命周期
    if (taskNum == 0) {
      schedule[core][taskNum].second = 0u + latest;
    } else {
      schedule[core][taskNum].second =
          schedule[core][taskNum - 1].second + latest;
    }
    if (taskNum != schedule[core].size() - 1) {
      schedule[core][taskNum + 1].first = schedule[core][taskNum].first + early;
    }
    return changed;
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