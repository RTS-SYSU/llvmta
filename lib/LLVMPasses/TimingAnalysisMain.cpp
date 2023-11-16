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
#include "llvm/Support/Format.h"

#include "llvm/Support/JSON.h"
#include "llvm/Support/MemoryBuffer.h"

#include <cmath>
#include <cstdint>
#include <fstream>
#include <limits>
#include <list>
#include <queue>
#include <sstream>
#include <string>
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

// boost::optional<std::string>
// TimingAnalysisMain::getFunctionname(unsigned int core) {
//   auto it = mp.find(core);

//   if (it == mp.end()) {
//     return boost::none;
//   }

//   if (it->second.empty())
//     return boost::none;

//   auto ret = it->second.front();

//   return ret;
// }

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

  // for Debug
  // for (auto &e : mp) {
  //   outs() << "Core: " << e.first << " ";
  //   while (!e.second.empty()) {
  //     outs() << e.second.front() << " ";
  //     e.second.pop();
  //   }
  //   outs() << "\n";
  // }
  // exit(0);

  // if (!machineFunctionCollector->hasFunctionByName(AnalysisEntryPoint)) {
  //   outs() << "No Timing Analysis Run. There is no entry point: "
  //          << AnalysisEntryPoint << "\n";
  //   exit(1);
  // }

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

    Myfile.open("PersistenceScopes.txt", ios_base::trunc);
    PersistenceScopeInfo::getInfo().dump(Myfile);
    Myfile.close();

    Myfile.open("CallGraph.txt", ios_base::trunc);
    CallGraph::getGraph().dump(Myfile);
    Myfile.close();
  }

  VERBOSE_PRINT(" -> Finished Preprocessing Phase\n");
  while (mcif.change) {
    for (unsigned i = 0; i < CoreNums; ++i) {
      outs() << "Timing Analysis for core: " <<i;
      // auto functionName = this->getNextFunction(i);
      Core = i;
      for(std::string &functionName : mcif.coreinfo[i]){
        outs() << " entry point: " << functionName << '\n';
        AnalysisEntryPoint = functionName;
        // Dispatch the value analysis
        auto Arch = getTargetMachine().getTargetTriple().getArch();
        if (Arch == Triple::ArchType::arm) {
          dispatchValueAnalysis<Triple::ArchType::arm>();
        } else if (Arch == Triple::ArchType::riscv32) {
          dispatchValueAnalysis<Triple::ArchType::riscv32>();
        } else {
          assert(0 && "Unsupported ISA for LLVMTA");
        }
        // functionName = this->getNextFunction(i);        
      }
      outs() << " No next analyse point for this core.\n";
    }
  }

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
  // TODO
  icacheConf.L2N_SETS = NN_SET;
  icacheConf.checkParams();

  dcacheConf.LINE_SIZE = Dlinesize;
  dcacheConf.ASSOCIATIVITY = Dassoc;
  dcacheConf.N_SETS = Dnsets;
  dcacheConf.WRITEBACK = DataCacheWriteBack;
  dcacheConf.WRITEALLOCATE = DataCacheWriteAllocate;
  // TODO
  dcacheConf.L2N_SETS = NN_SET;
  dcacheConf.checkParams();

  // Select the analysis to execute
  dispatchAnalysisType(AddrInfo);

  // No need for constant value information
  delete CvAnaInfo;
  // Release the call graph instance
  // CallGraph::getGraph().releaseInstance();

  // Write results and statistics
  Statistics &Stats = Statistics::getInstance();
  AnalysisResults &Ar = AnalysisResults::getInstance();

  // Stats.stopMeasurement("Complete Analysis");

  Myfile.open(std::to_string(this->coreNum) + "_" + AnalysisEntryPoint +
                  "_Statistics.txt",
              ios_base::trunc);
  Stats.dump(Myfile);
  Myfile.close();

  Myfile.open(std::to_string(this->coreNum) + "_" + AnalysisEntryPoint +
                  "_TotalBound.xml",
              ios_base::trunc);
  Ar.dump(Myfile);
  Myfile.close();
}

void TimingAnalysisMain::dispatchAnalysisType(AddressInformation &AddressInfo) {
  AnalysisResults &Ar = AnalysisResults::getInstance();
  // Timing & CRPD calculation need normal muarch analysis first
  if (AnaType.isSet(AnalysisType::TIMING) ||
      AnaType.isSet(AnalysisType::CRPD)) {
    auto Bound = dispatchTimingAnalysis(AddressInfo);
    Ar.registerResult("total", Bound);
    if (Bound) {
      outs() << std::to_string(Core)
             << "-Core:   " + AnalysisEntryPoint + "_Calculated Timing Bound: "
             << llvm::format("%-20.0f", Bound.get().ub) << "\n";
    } else {
      outs() << std::to_string(Core)
             << "-Core:   " + AnalysisEntryPoint +
                    "Calculated Timing Bound: infinite\n";
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
    return dispatchInOrderTimingAnalysis(AddressInfo,
                                         Core); //严格顺序执行
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
