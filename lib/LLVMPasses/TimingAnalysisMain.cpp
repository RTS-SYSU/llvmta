////////////////////////////////////////////////////////////////////////////////
//
//   LLVMTA - Timing Analyser performing worst-case execution time analysis
//     using the LLVM backend intermediate representation
//
// Copyright (C) 2013-2022  Saarland University
// Copyright (C) 2014-2015  Claus Faymonville
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

#include "LLVMPasses/TimingAnalysisMain.h"
#include "AnalysisFramework/AnalysisDriver.h"
#include "AnalysisFramework/AnalysisResults.h"
#include "AnalysisFramework/CallGraph.h"
#include "LLVMPasses/DispatchFixedLatency.h"
#include "LLVMPasses/DispatchInOrderPipeline.h"
#include "LLVMPasses/DispatchMemory.h"
#include "LLVMPasses/DispatchOutOfOrderPipeline.h"
#include "LLVMPasses/DispatchPretPipeline.h"
#include "LLVMPasses/MachineFunctionCollector.h"
#include "LLVMPasses/StaticAddressProvider.h"
#include "Memory/PersistenceScopeInfo.h"
#include "PartitionUtil/DirectiveHeuristics.h"
#include "PathAnalysis/LoopBoundInfo.h"
#include "PreprocessingAnalysis/AddressInformation.h"
#include "PreprocessingAnalysis/ConstantValueDomain.h"

#include "Util/GlobalVars.h"
#include "Util/Options.h"
#include "Util/Statistics.h"

#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/Passes.h"
#include "llvm/Support/Format.h"

#include "llvm/Support/Error.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/JSON.h"
#include "llvm/Support/MemoryBuffer.h"
#include <cmath>
#include <fstream>
#include <iostream>
#include <limits>
#include <list>
#include <sstream>
#include <string>
#include <type_traits>
#include <utility>

using namespace llvm;
using namespace std;

namespace TimingAnalysisPass {

unsigned getInitialStackPointer() { return InitialStackPointer; }

unsigned getInitialLinkRegister() { return InitialLinkRegister; }

MachineFunction *getAnalysisEntryPoint() {
  auto *Res = machineFunctionCollector->getFunctionByName(AnalysisEntryPoint);
  assert(Res && "Invalid entry point specified");
  return Res;
}

void TimingAnalysisMain::parseCoreInfo(const std::string &FileName) {
  mcif.setSize(CoreNums);
  // Using llvm::json to parse the core information
  llvm::ErrorOr<std::unique_ptr<llvm::MemoryBuffer>> FileOrErr =
      llvm::MemoryBuffer::getFile(FileName);
  if (std::error_code EC = FileOrErr.getError()) {
    llvm::errs() << "Error happened when trying to open the file: " << FileName
                 << "\n";
    llvm::errs() << "Error message: " << EC.message() << "\n";
    exit(1);
  }

  llvm::Expected<llvm::json::Value> JsonVal =
      llvm::json::parse(FileOrErr.get()->getBuffer());
  // Check if Error happened
  if (auto Err = JsonVal.takeError()) {
    llvm::errs() << "Error happened when trying to parse the json file: "
                 << FileName << "\n";
    llvm::errs() << "Error message: " << llvm::toString(std::move(Err)) << "\n";
    exit(1);
  }
  // Check if the json file is valid
  if (!JsonVal) {
    llvm::errs() << "Error happened when trying to parse the json file: "
                 << FileName << "\n";
    llvm::errs() << "Error message: " << llvm::toString(JsonVal.takeError())
                 << "\n";
    exit(1);
  }
  // Convert the json value to a json object
  auto *JsonArr = JsonVal->getAsArray();
  if (!JsonArr) {
    llvm::errs() << "Error happened when trying to convert the json value to "
                    "a json array\n";
    exit(1);
  }

  // Iterate the json array
  for (auto it = JsonArr->begin(); it != JsonArr->end(); ++it) {
    auto *Obj = it->getAsObject();
    if (!Obj) {
      llvm::errs() << "Error happened when trying to convert the json value to "
                      "a json object\n";
      exit(1);
    }

    // Get the core number
    auto CoreNum = Obj->get("core")->getAsInteger();
    auto *tasks = Obj->get("tasks")->getAsArray();

    if (!CoreNum) {
      llvm::errs() << "Core number cannot be found\n";
      exit(1);
    }
    if (!tasks) {
      llvm::errs() << "Tasks cannot be found\n";
      exit(1);
    }

    if (this->taskMap.find(CoreNum.getValue()) == this->taskMap.end()) {
      // Create a new entry
      this->taskMap[CoreNum.getValue()] = std::vector<std::string>();
    }

    auto &CurrentCore = this->taskMap[CoreNum.getValue()];

    // llvm::outs() << "Core number: " << CoreNum.getValue() << "\n";
    // Iterate the tasks
    for (auto TaskIt = tasks->begin(); TaskIt != tasks->end(); ++TaskIt) {
      auto *TaskObj = TaskIt->getAsObject();
      if (!TaskObj) {
        llvm::errs() << "Error happened when trying to convert the json value "
                        "to a json object\n";
        exit(1);
      }

      auto TaskName = TaskObj->get("function")->getAsString();
      if (!TaskName) {
        llvm::errs() << "Function name cannot be found\n";
        exit(1);
      }

      // llvm::outs() << "Task name: " << TaskName.getValue() << "\n";
      CurrentCore.push_back(TaskName.getValue().str());
      mcif.addTask(CoreNum.getValue(), TaskName.getValue().str());
    }
  }
}

char TimingAnalysisMain::ID = 0;
TargetMachine *TimingAnalysisMain::TargetMachineInstance = nullptr;

TimingAnalysisMain::TimingAnalysisMain(TargetMachine &TM)
    : MachineFunctionPass(ID) {
  TargetMachineInstance = &TM;
}

TargetMachine &TimingAnalysisMain::getTargetMachine() {
  return *TargetMachineInstance;
}

bool TimingAnalysisMain::runOnMachineFunction(MachineFunction &MF) {
  bool Changed = false;
  return Changed;
}

bool TimingAnalysisMain::doFinalization(Module &M) {
  parseCoreInfo(CoreInfo);

  if (AnaType.getBits() == 0) {
    AnaType.addValue(AnalysisType::TIMING);
  }
  if (MulCType == MultiCoreType::LiangY) {
    for (auto Clist : taskMap) {
      CurrentCore = Clist.first;
      for (string entry : Clist.second) {
        AnalysisEntryPoint = entry;
        outs() << "Address Analysis for entry point: " << entry << "\n";
        auto Arch = getTargetMachine().getTargetTriple().getArch();
        std::tuple<> NoDep;
        if (Arch == Triple::ArchType::arm) {
          AnalysisDriverInstr<ConstantValueDomain<Triple::ArchType::arm>>
              ConstValAna(entry, NoDep);
          auto CvAnaInfo = ConstValAna.runAnalysis();
          AddressInformationImpl<ConstantValueDomain<Triple::ArchType::arm>>
              AddrInfo(*CvAnaInfo);
          ofstream Myfile;
          if (!QuietMode) {
            Myfile.open("AddressInformation.txt", ios_base::trunc);
            AddrInfo.dump(Myfile);
            Myfile.close();
          }

          functiontofs.emplace(entry, std::set<functionaddr *>());

          CallGraph &cg = CallGraph::getGraph();
          for (auto *currFunc :
               machineFunctionCollector->getAllMachineFunctions()) {
            string funcName = currFunc->getName().str();
            if (!cg.reachableFromEntryPoint(currFunc)) {
              continue;
            }
            if (getfunctionaddr.find(funcName) == getfunctionaddr.end()) {
              functionaddr *f = new functionaddr(funcName);
              getfunctionaddr[funcName] = f;
            }
            functiontofs[entry].emplace(getfunctionaddr[funcName]);

            for (auto currBB = currFunc->begin(); currBB != currFunc->end();
                 ++currBB) {
              for (auto currMI = currBB->begin(); currMI != currBB->end();
                   ++currMI) {
                // 指令地址
                if (StaticAddrProvider->Ins2addr.find(&*currMI) !=
                    StaticAddrProvider->Ins2addr.end()) {
                  getfunctionaddr[funcName]->addrlist.emplace(
                      StaticAddrProvider->Ins2addr[&*currMI] &
                      ~(L2linesize - 1));
                }
                // 数据地址
                if (currMI->mayLoad() || currMI->mayStore()) {
                  auto list = AddrInfo.getvalueaddr(&*currMI);
                  for (unsigned addr : list) {
                    getfunctionaddr[funcName]->addrlist.emplace(
                        addr & ~(L2linesize - 1));
                  }
                }
              }
            }
          }

        } else if (Arch == Triple::ArchType::riscv32) {
          AnalysisDriverInstr<ConstantValueDomain<Triple::ArchType::riscv32>>
              ConstValAna(entry, NoDep);
          auto CvAnaInfo = ConstValAna.runAnalysis();
          AddressInformationImpl<ConstantValueDomain<Triple::ArchType::riscv32>>
              AddrInfo(*CvAnaInfo);

        } else {
          assert(0 && "Unsupported ISA for LLVMTA");
        }
      }
    }
  }

  for (auto Clist : taskMap) {
    outs() << "Timing Analysis for Core: " << Clist.first << "\n";
    CurrentCore = Clist.first;
    for (string entry : Clist.second) {
      AnalysisEntryPoint = entry;
      func2corenum[entry] = CurrentCore;
      if (!machineFunctionCollector->hasFunctionByName(AnalysisEntryPoint)) {
        outs() << "No Timing Analysis Run. There is no entry point: "
               << AnalysisEntryPoint << "\n";
        // exit(1);
      }

      ofstream Myfile;

      // Statistics &Stats = Statistics::getInstance();
      // Stats.startMeasurement("Complete Analysis");

      if (CoRunnerSensitive) {
        for (int I = 0; I <= UntilIterationMeasurement; ++I) {
          std::string MeasurementId = "Until Iteration ";
          MeasurementId += std::to_string(I);
          // Stats.startMeasurement(MeasurementId);
        }
      }

      if (OutputExtFuncAnnotationFile) {
        Myfile.open("ExtFuncAnnotations.csv", ios_base::trunc);
        CallGraph::getGraph().dumpUnknownExternalFunctions(Myfile);
        Myfile.close();
        return false;
      }
      if (!QuietMode) {
        Myfile.open("AnnotatedHeuristics.txt", ios_base::trunc);
        DirectiveHeuristicsPassInstance->dump(Myfile);
        Myfile.close();

        Myfile.open("PersistenceScopes.txt", ios_base::trunc);
        PersistenceScopeInfo::getInfo().dump(Myfile);
        Myfile.close();

        Myfile.open("CallGraph.txt", ios_base::trunc);
        CallGraph::getGraph().dump(Myfile);
        Myfile.close();
      }
      VERBOSE_PRINT(" -> Finished Preprocessing Phase\n");

      outs() << "Timing Analysis for entry point: " << AnalysisEntryPoint
             << "\n";
      // Dispatch the value analysis
      auto Arch = getTargetMachine().getTargetTriple().getArch();
      if (Arch == Triple::ArchType::arm) {
        dispatchValueAnalysis<Triple::ArchType::arm>();
      } else if (Arch == Triple::ArchType::riscv32) {
        dispatchValueAnalysis<Triple::ArchType::riscv32>();
      } else {
        assert(0 && "Unsupported ISA for LLVMTA");
      }
      PersistenceScopeInfo::deletper();
    }
  }

  return false;
}

template <Triple::ArchType ISA>
void TimingAnalysisMain::dispatchValueAnalysis() {
  ofstream Myfile;

  std::tuple<> NoDep;
  AnalysisDriverInstr<ConstantValueDomain<ISA>> ConstValAna(
      AnalysisEntryPoint, NoDep);
  auto CvAnaInfo = ConstValAna.runAnalysis();

  LoopBoundInfo->computeLoopBoundFromCVDomain(*CvAnaInfo);

  if (OutputLoopAnnotationFile) {
    ofstream Myfile2;
    Myfile.open("CtxSensLoopAnnotations.csv", ios_base::trunc);
    Myfile2.open("LoopAnnotations.csv", ios_base::trunc);
    LoopBoundInfo->dumpNonUpperBoundLoops(Myfile, Myfile2);
    Myfile2.close();
    Myfile.close();
    return;
  }

  for (auto BoundsFile : ManualLoopBounds) {
    LoopBoundInfo->parseManualUpperLoopBounds(BoundsFile.c_str());
  }
  // jjy:循环下界
  if (ParallelPrograms) {
    for (auto BoundsFile : ManuallowerLoopBounds) {
      LoopBoundInfo->parseManualLowerLoopBounds(BoundsFile.c_str());
    }
  }

  if (!QuietMode) {
    Myfile.open("LoopBounds.txt", ios_base::trunc);
    LoopBoundInfo->dump(Myfile);
    Myfile.close();

    Myfile.open("ConstantValueAnalysis.txt", ios_base::trunc);
    CvAnaInfo->dump(Myfile);
    Myfile.close();
  }

  AddressInformationImpl<ConstantValueDomain<ISA>> AddrInfo(*CvAnaInfo);

  if (!QuietMode) {
    Myfile.open("AddressInformation.txt", ios_base::trunc);
    AddrInfo.dump(Myfile);
    Myfile.close();
  }

  VERBOSE_PRINT(" -> Finished Value & Address Analysis\n");

  // Set and check the parameters of the instruction and data cache
  icacheConf.LINE_SIZE = Ilinesize;
  icacheConf.ASSOCIATIVITY = Iassoc;
  icacheConf.N_SETS = Insets;
  icacheConf.LEVEL = 1;
  icacheConf.checkParams();

  dcacheConf.LINE_SIZE = Dlinesize;
  dcacheConf.ASSOCIATIVITY = Dassoc;
  dcacheConf.N_SETS = Dnsets;
  dcacheConf.WRITEBACK = DataCacheWriteBack;
  dcacheConf.WRITEALLOCATE = DataCacheWriteAllocate;
  dcacheConf.LEVEL = 1;
  dcacheConf.checkParams();

  dcacheConf.LINE_SIZE = L2linesize;
  l2cacheConf.LINE_SIZE = Dlinesize;
  l2cacheConf.N_SETS = NN_SET;
  l2cacheConf.ASSOCIATIVITY = L2assoc;
  l2cacheConf.LATENCY = L2Latency;
  l2cacheConf.LEVEL = 2;
  l2cacheConf.checkParams();

  // WCET
  // Select the analysis to execute
  dispatchAnalysisType(AddrInfo);

  // No need for constant value information
  delete CvAnaInfo;

  // // Release the call graph instance
  // CallGraph::getGraph().releaseInstance();

  // Write results and statistics
  // Statistics &Stats = Statistics::getInstance();
  // AnalysisResults &Ar = AnalysisResults::getInstance();

  // Stats.stopMeasurement("Complete Analysis");

  Myfile.open("Statistics.txt", ios_base::trunc);
  // Stats.dump(Myfile);
  Myfile.close();

  Myfile.open("TotalBound.xml", ios_base::trunc);
  // Ar.dump(Myfile);
  Myfile.close();
}

void TimingAnalysisMain::dispatchAnalysisType(AddressInformation &
                                              AddressInfo) {
  AnalysisResults &Ar = AnalysisResults::getInstance();
  // Timing & CRPD calculation need normal muarch analysis first
  if (AnaType.isSet(AnalysisType::TIMING) ||
      AnaType.isSet(AnalysisType::CRPD)) {
    auto Bound = dispatchTimingAnalysis(AddressInfo);
    // Ar.registerResult("total", Bound);
    if (Bound) {
      outs() << "Calculated Timing Bound: "
              << llvm::format("%-20.0f", Bound.get().ub) << "\n";
    } else {
      outs() << "Calculated Timing Bound: infinite\n";
    }
  }
  if (AnaType.isSet(AnalysisType::L1ICACHE)) {
    auto Bound = dispatchCacheAnalysis(AnalysisType::L1ICACHE, AddressInfo);
    // Ar.registerResult("icache", Bound);
    if (Bound) {
      outs() << "Calculated " << "Instruction Cache Miss Bound: "
              << llvm::format("%-20.0f", Bound.get().ub) << "\n";
    } else {
      outs() << "Calculated " << "Instruction Cache Miss Bound: infinite\n";
    }
  }
  if (AnaType.isSet(AnalysisType::L1DCACHE)) {
    auto Bound = dispatchCacheAnalysis(AnalysisType::L1DCACHE, AddressInfo);
    // Ar.registerResult("dcache", Bound);
    if (Bound) {
      outs() << "Calculated " << "Data Cache Miss Bound: "
              << llvm::format("%-20.0f", Bound.get().ub) << "\n";
    } else {
      outs() << "Calculated " << "Data Cache Miss Bound: infinite\n";
    }
  }
}

///////////////////////////////////////////////////////////////////////////////
/// Timing Analysis
/// ///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

boost::optional<BoundItv> TimingAnalysisMain::dispatchTimingAnalysis(
    AddressInformation & AddressInfo) {
  switch (MuArchType) {
  case MicroArchitecturalType::FIXEDLATENCY:
    assert(MemTopType == MemoryTopologyType::NONE &&
            "Fixed latency has no external memory");
    return dispatchFixedLatencyTimingAnalysis();
  case MicroArchitecturalType::PRET:
    return dispatchPretTimingAnalysis(AddressInfo);
  case MicroArchitecturalType::INORDER:
  case MicroArchitecturalType::STRICTINORDER:
    return dispatchInOrderTimingAnalysis(AddressInfo);
  case MicroArchitecturalType::OUTOFORDER:
    return dispatchOutOfOrderTimingAnalysis(AddressInfo);
  default:
    errs() << "No known microarchitecture chosen.\n";
    return boost::none;
  }
}

boost::optional<BoundItv> TimingAnalysisMain::dispatchCacheAnalysis(
      AnalysisType Anatype, AddressInformation & AddressInfo) {
    switch (MuArchType) {
    case MicroArchitecturalType::INORDER:
    case MicroArchitecturalType::STRICTINORDER:
      return dispatchInOrderCacheAnalysis(Anatype, AddressInfo);
    default:
      errs() << "Unsupported microarchitecture for standalone cache "
                "analysis.\n";
      return boost::none;
    }
  }

} // namespace TimingAnalysisPass

FunctionPass *llvm::createTimingAnalysisMain(TargetMachine &TM) {
  return new TimingAnalysisPass::TimingAnalysisMain(TM);
}
