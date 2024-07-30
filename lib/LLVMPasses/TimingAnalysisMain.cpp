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
#include "Memory/PersistenceScopeInfo.h"
#include "PartitionUtil/DirectiveHeuristics.h"
#include "PathAnalysis/LoopBoundInfo.h"
#include "PreprocessingAnalysis/AddressInformation.h"
#include "PreprocessingAnalysis/ConstantValueDomain.h"
#include "Util/GlobalVars.h"
#include "Util/Options.h"
#include "Util/Statistics.h"
#include "Util/Util.h"

#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/Passes.h"
#include "llvm/DebugInfo/Symbolize/SymbolizableModule.h"
#include "llvm/Support/Format.h"

#include "llvm/Support/JSON.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/raw_ostream.h"

#include <Util/StatisticOutput.h>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <fstream>
#include <limits>
#include <list>
#include <map>
#include <queue>
#include <sstream>
#include <string>
#include <system_error>
#include <type_traits>
#include <utility>

using namespace llvm;
using namespace std;

namespace TimingAnalysisPass {

TimingAnalysisMain **MultiCorePasses = nullptr;

unsigned getInitialStackPointer() { return InitialStackPointer; }

unsigned getInitialLinkRegister() { return InitialLinkRegister; }

MachineFunction *getAnalysisEntryPoint() {
  auto *Res = machineFunctionCollector->getFunctionByName(AnalysisEntryPoint);
  assert(Res && "Invalid entry point specified");
  return Res;
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

void TimingAnalysisMain::parseCoreInfo(const std::string &fileName) {
  // TODO
  mcif.setSize(CoreNums.getValue());
  auto jsonfile = MemoryBuffer::getFile(fileName, true);
  if (!jsonfile) {
    fprintf(stderr, "Unable to open file %s, exit.", fileName.c_str());
    exit(1);
  }
  auto jsondata = json::parse(jsonfile.get()->getBuffer());
  if (!jsondata) {
    fprintf(stderr, "Unable to parse json file %s, exit.", fileName.c_str());
    exit(1);
  }

  json::Array *cores = jsondata->getAsArray();
  if (!cores) {
    fprintf(stderr, "File should be an array of cores, exit.",
            fileName.c_str());
    exit(1);
  }
  for (json::Value &e : *cores) {
    json::Object *obj = e.getAsObject();
    if (!obj) {
      fprintf(stderr, "Core info shoule be an object, exit.", fileName.c_str());
      exit(1);
    }
    int64_t core = obj->getInteger("core").getValue();

    json::Array *functions = obj->getArray("tasks");
    if (!functions) {
      fprintf(stderr, "Unable to get tasks for core %lu, exit.", core);
      exit(1);
    }

    for (json::Value &task : *functions) {
      auto taskName = task.getAsObject()->get("function")->getAsString();
      if (!taskName) {
        fprintf(stderr, "Unable to get task name for core %lu, exit.", core);
        exit(1);
      }
      mp[core].push(taskName.getValue().str());
      // NOTICE: blabla
      mcif.addTask(core, taskName.getValue().str());
    }
  }
}

boost::optional<std::string>
TimingAnalysisMain::getNextFunction(unsigned int core) {
  auto it = mp.find(core);

  if (it == mp.end()) {
    return boost::none;
  }

  if (it->second.empty())
    return boost::none;

  std::string functionName = it->second.front();
  it->second.pop();

  return functionName;
}

bool TimingAnalysisMain::doFinalization(Module &M) {
  // do File parsing
  parseCoreInfo(coreInfo);

  ofstream Myfile;

  // Default analysis type: timing
  if (AnaType.getBits() == 0) {
    AnaType.addValue(AnalysisType::TIMING);
  }

  Statistics &Stats = Statistics::getInstance();
  Stats.startMeasurement("Complete Analysis");

  if (CoRunnerSensitive) {
    for (int I = 0; I <= UntilIterationMeasurement; ++I) {
      std::string MeasurementId = "Until Iteration ";
      MeasurementId += std::to_string(I);
      Stats.startMeasurement(MeasurementId);
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

    // jjy: I put this back, after we know the function name that we ananysis
    // Myfile.open("PersistenceScopes.txt", ios_base::trunc);
    // PersistenceScopeInfo::getInfo().dump(Myfile);
    // Myfile.close();

    Myfile.open("CallGraph.txt", ios_base::trunc);
    CallGraph::getGraph().dump(Myfile);
    Myfile.close();
  }

  VERBOSE_PRINT(" -> Finished Preprocessing Phase\n");
  // Create a json array
  llvm::json::Array arr;
  std::map<std::string, size_t> vec;

  uint64_t im = 0, dm = 0, l2m = 0, tm = 0;

  StatisticOutput output_data = StatisticOutput(COL_LEN);
  bool ETchage = true;
  int ET = 0;
  char buf[10];
  memset(buf, 0, sizeof(buf));
  while (ET < 1 && ETchage) {
    ET++;
    ETchage = false;
    for (unsigned i = 0; i < CoreNums; ++i) {
      outs() << "Timing Analysis for core: " << i;
      Core = i;
      for (std::string &functionName : mcif.coreinfo[i]) {
        outs() << " entry point: " << functionName << '\n';
        AnalysisEntryPoint = functionName;
        if (!QuietMode) {
          // 持久域收集
          Myfile.open("PersistenceScopes.txt", ios_base::trunc);
          PersistenceScopeInfo::getInfo().dump(Myfile);
          Myfile.close();
        }
        // Dispatch the value analysis
        auto Arch = getTargetMachine().getTargetTriple().getArch();
        if (Arch == Triple::ArchType::arm) {
          dispatchValueAnalysis<Triple::ArchType::arm>();
          // pair of 2 u
          ETchage =
              ETchage || mcif.updateTaskTime(Core, AnalysisEntryPoint,
                                             this->BCETtime, this->WCETtime);
        } else if (Arch == Triple::ArchType::riscv32) {
          dispatchValueAnalysis<Triple::ArchType::riscv32>();
          ETchage =
              ETchage || mcif.updateTaskTime(Core, AnalysisEntryPoint,
                                             this->BCETtime, this->WCETtime);
        } else {
          assert(0 && "Unsupported ISA for LLVMTA");
        }

        // jjy:收集各个任务的WCET信息
        if (vec.count(functionName) == 0) {
          llvm::json::Object obj{{"function", std::string(functionName)},
                                 {"WCET", this->WCETtime},
                                 {"BCET", this->BCETtime}};
          arr.push_back(std::move(obj));
          vec[functionName] = arr.size() - 1;
        } else {
          auto *ptr = arr[vec[functionName]].getAsObject();
          (*ptr)["WCET"] = this->WCETtime;
          (*ptr)["BCET"] = this->BCETtime;
        }
        output_data.update(functionName, "BCET", this->BCETtime);
        output_data.update(functionName, "WCET", this->WCETtime);
        output_data.update(functionName, "I-MISS", IMISS - im);
        output_data.update(functionName, "D-MISS", DMISS - dm);
        output_data.update(functionName, "L2-MISS", L2MISS - l2m);
        im = IMISS;
        dm = DMISS;
        l2m = L2MISS;
      }
      outs() << " No next analyse point for this core.\n";
    }
    outs() << "---------------------------------The " << ET
           << " iteration is over----------------------------------\n";
    // std::ofstream myfile;
    // std::string fileName = "MISSC.txt";
    // myfile.open(fileName, std::ios_base::trunc);
    // myfile << "IMISS : " << ::IMISS << '\n'
    //        << "DMISS : " << ::DMISS << '\n'
    //        << "L2MISS : " << ::L2MISS << '\n';
    // myfile.close();
    IMISS = DMISS = L2MISS = 0; // RESET
  }
  output_data.dump("output_information.txt", "a");
  // Release the call graph instance
  CallGraph::getGraph().releaseInstance();
  // Dump the json array to file
  std::error_code EC;
  llvm::raw_fd_ostream OS("WCET.json", EC);
  llvm::json::Value val(std::move(arr));
  OS << llvm::formatv("{0:4}", val) << '\n';
  OS.flush();
  OS.close();

  return false;
}

template <Triple::ArchType ISA>
void TimingAnalysisMain::dispatchValueAnalysis() {
  ofstream Myfile;

  std::tuple<> NoDep;
  AnalysisDriverInstr<ConstantValueDomain<ISA>> ConstValAna(NoDep);
  auto CvAnaInfo = ConstValAna.runAnalysis();

  LoopBoundInfo->computeLoopBoundFromCVDomain(*CvAnaInfo);

  if (OutputLoopAnnotationFile) {
    ofstream Myfile2;
    Myfile.open("CtxSensLoopAnnotations.csv", ios_base::app);
    Myfile2.open("LoopAnnotations.csv", ios_base::app);
    LoopBoundInfo->dumpNonUpperBoundLoops(Myfile, Myfile2);
    Myfile2.close();
    Myfile.close();
    return;
  }
  for (auto BoundsFile : ManuallowerLoopBounds) {
    LoopBoundInfo->parseManualLowerLoopBounds(BoundsFile.c_str());
  }
  for (auto BoundsFile : ManualLoopBounds) {
    LoopBoundInfo->parseManualUpperLoopBounds(BoundsFile.c_str());
  }

  if (!QuietMode) {
    //持久分析改动标记
    // Myfile.open("PersistenceScopes.txt", ios_base::trunc);
    // PersistenceScopeInfo::getInfo().dump(Myfile);
    // Myfile.close();

    Myfile.open("LoopBounds.txt", ios_base::trunc);
    LoopBoundInfo->dump(Myfile);
    Myfile.close();

    Myfile.open("ConstantValueAnalysis.txt", ios_base::app);
    CvAnaInfo->dump(Myfile);
    Myfile.close();
  }

  AddressInformationImpl<ConstantValueDomain<ISA>> AddrInfo(*CvAnaInfo);
  ::glAddrInfo = &AddrInfo;

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
  // Release the call graph instance
  // CallGraph::getGraph().releaseInstance();

  // Write results and statistics
  Statistics &Stats = Statistics::getInstance();
  AnalysisResults &Ar = AnalysisResults::getInstance();

  // Stats.stopMeasurement("Complete Analysis");

  Myfile.open(std::to_string(this->coreNum) + "_" + AnalysisEntryPoint +
                  "_Statistics.txt",
              ios_base::app);
  Stats.dump(Myfile);
  Myfile.close();

  Myfile.open(std::to_string(this->coreNum) + "_" + AnalysisEntryPoint +
                  "_TotalBound.xml",
              ios_base::app);
  Ar.dump(Myfile);
  Myfile.close();
  // BCET
  ::isBCET = true;
  dispatchAnalysisType(AddrInfo);
  // Write results and statistics
  Statistics &Stats1 = Statistics::getInstance();
  AnalysisResults &Ar1 = AnalysisResults::getInstance();
  Myfile.open(std::to_string(this->coreNum) + "_" + AnalysisEntryPoint +
                  "_TotalBound.xml",
              ios_base::app);
  Ar1.dump(Myfile);
  Myfile.close();
  ::isBCET = false;
  // No need for constant value information
  delete CvAnaInfo;
  PersistenceScopeInfo::deletper();
}

void TimingAnalysisMain::dispatchAnalysisType(AddressInformation &AddressInfo) {
  AnalysisResults &Ar = AnalysisResults::getInstance();
  // Timing & CRPD calculation need normal muarch analysis first
  if (AnaType.isSet(AnalysisType::TIMING) ||
      AnaType.isSet(AnalysisType::CRPD)) {
    auto Bound = dispatchTimingAnalysis(AddressInfo);
    Ar.registerResult("total", Bound);
    if (Bound) {
      if (!isBCET) {
        outs() << std::to_string(Core)
               << "-Core:   " + AnalysisEntryPoint +
                      "_Calculated WCET Timing Bound: "
               << llvm::format("%-20.0f", Bound.get().ub) << "\n";
        this->WCETtime = Bound.get().ub;
      } else {
        outs() << std::to_string(Core)
               << "-Core:   " + AnalysisEntryPoint +
                      "_Calculated BCET Timing Bound: "
               << llvm::format("%-20.0f", Bound.get().lb) << "\n";
        this->BCETtime = Bound.get().lb;
      }
    } else {
      outs() << std::to_string(Core)
             << "-Core:   " + AnalysisEntryPoint +
                    "_Calculated Timing Bound: infinite\n";
      // set wcet and bcet to 0
      this->WCETtime = 0;
      this->BCETtime = 0;
    }
  }
  if (AnaType.isSet(AnalysisType::L1ICACHE)) {
    auto Bound = dispatchCacheAnalysis(AnalysisType::L1ICACHE, AddressInfo);
    Ar.registerResult("icache", Bound);
    if (Bound) {
      outs() << "Calculated "
             << "Instruction Cache Miss Bound: "
             << llvm::format("%-20.0f", Bound.get().ub) << "\n";
    } else {
      outs() << "Calculated "
             << "Instruction Cache Miss Bound: infinite\n";
    }
  }
  if (AnaType.isSet(AnalysisType::L1DCACHE)) {
    auto Bound = dispatchCacheAnalysis(AnalysisType::L1DCACHE, AddressInfo);
    Ar.registerResult("dcache", Bound);
    if (Bound) {
      outs() << "Calculated "
             << "Data Cache Miss Bound: "
             << llvm::format("%-20.0f", Bound.get().ub) << "\n";
    } else {
      outs() << "Calculated "
             << "Data Cache Miss Bound: infinite\n";
    }
  }
}

///////////////////////////////////////////////////////////////////////////////
/// Timing Analysis ///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

boost::optional<BoundItv>
TimingAnalysisMain::dispatchTimingAnalysis(AddressInformation &AddressInfo) {
  // Note, we no longer need this, this functionName will get check before enter
  // if (!functionName) {
  //   fprintf(stderr, "You should not come here");
  //   exit(10);
  // }
  switch (MuArchType) {
  case MicroArchitecturalType::FIXEDLATENCY:
    assert(MemTopType == MemoryTopologyType::NONE &&
           "Fixed latency has no external memory");
    return dispatchFixedLatencyTimingAnalysis(Core);
  case MicroArchitecturalType::PRET:
    return dispatchPretTimingAnalysis(AddressInfo, Core);
  case MicroArchitecturalType::INORDER:
  case MicroArchitecturalType::STRICTINORDER:
    return dispatchInOrderTimingAnalysis(AddressInfo, Core);
  case MicroArchitecturalType::OUTOFORDER:
    return dispatchOutOfOrderTimingAnalysis(AddressInfo, Core);
  default:
    errs() << "No known microarchitecture chosen.\n";
    return boost::none;
  }
}

boost::optional<BoundItv>
TimingAnalysisMain::dispatchCacheAnalysis(AnalysisType Anatype,
                                          AddressInformation &AddressInfo) {
  switch (MuArchType) {
  case MicroArchitecturalType::INORDER:
  case MicroArchitecturalType::STRICTINORDER:
    return dispatchInOrderCacheAnalysis(Anatype, AddressInfo);
  default:
    errs() << "Unsupported microarchitecture for standalone cache analysis.\n";
    return boost::none;
  }
}

} // namespace TimingAnalysisPass

FunctionPass *llvm::createTimingAnalysisMain(TargetMachine &TM) {
  return new TimingAnalysisPass::TimingAnalysisMain(TM);
}
