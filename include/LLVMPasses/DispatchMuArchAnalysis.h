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

#ifndef DISPATCHMUARCHANALYSIS_H
#define DISPATCHMUARCHANALYSIS_H

#include "AnalysisFramework/AnalysisDriver.h"
#include "AnalysisFramework/PartitioningDomain.h"
#include "LLVMPasses/DispatchPathAnalysis.h"
#include "MicroarchitecturalAnalysis/StateExplorationDomain.h"

#include <fstream>

namespace TimingAnalysisPass {

template <class MuArchDomain, class Deps>
AnalysisInformation<PartitioningDomain<MuArchDomain, MachineInstr>,
                    MachineInstr> *
doMuArchTimingAnalysis(Deps deps) {
  VERBOSE_PRINT(" -> Starting Microarchitectural Analysis:\n"
                << typeid(MuArchDomain).name() << "\n");

  AnalysisDriverInstrContextMapping<MuArchDomain> microArchAna(
      AnalysisEntryPoint, deps);
  auto microArchAnaInfo = microArchAna.runAnalysis();

  if (!QuietMode) {
    std::ofstream myfile;
    myfile.open("MicroArchAnalysis.txt", std::ios_base::trunc);
    microArchAnaInfo->dump(myfile);
    myfile.close();
  }

  VERBOSE_PRINT(" -> Finished Microarchitectural Analysis\n");

  return microArchAnaInfo;
}

template <class MuState, class Deps>
boost::optional<BoundItv> dispatchTimingAnalysisJoin(Deps deps) {
  if (MuJoinEnabled) {
    typedef StateExplorationWithJoinDomain<MuState> MuArchDomain;

    Statistics &stats = Statistics::getInstance();
    stats.startMeasurement("Timing MuArch Analysis");
    auto res = doMuArchTimingAnalysis<MuArchDomain>(deps);
    // Res deleted at the end of state graph construction
    stats.stopMeasurement("Timing MuArch Analysis");
    boost::optional<BoundItv> bound;

    assert(AnaType.isSet(AnalysisType::CRPD) ||
           AnaType.isSet(AnalysisType::TIMING));
    // Switch whether actual WCET analysis or CRPD
    if (AnaType.isSet(AnalysisType::CRPD)) {
      dispatchCRPDPathAnalysis<MuArchDomain>(*res, TplSpecial());
    }
    if (AnaType.isSet(AnalysisType::TIMING)) {
      stats.startMeasurement("Timing Stategraph Generation");
      bound = dispatchTimingPathAnalysis<MuArchDomain>(*res);
      stats.stopMeasurement("Timing Path Analysis");
    }
    return bound;
  } // else
  typedef StateExplorationDomain<MuState> MuArchDomain;
  auto res = doMuArchTimingAnalysis<MuArchDomain>(deps);
  auto bound = dispatchTimingPathAnalysis<MuArchDomain>(*res);
  // Res deleted at the end of state graph construction
  return bound;
}

template <class MuState, class Deps>
boost::optional<BoundItv> dispatchCacheAnalysisJoin(Deps deps,
                                                    std::string prefix) {
  if (MuJoinEnabled) {
    typedef StateExplorationWithJoinDomain<MuState> MuArchDomain;
    Statistics &stats = Statistics::getInstance();
    stats.startMeasurement(prefix + "Cache MuArch Analysis");
    auto res = doMuArchTimingAnalysis<MuArchDomain>(deps);
    stats.stopMeasurement(prefix + "Cache MuArch Analysis");
    // TODO split the next measuremtn in two for stategraph and ILP
    stats.startMeasurement(prefix + "Cache Path Analysis");
    // Res deleted at the end of state graph construction
    auto bound = dispatchCachePathAnalysis<MuArchDomain>(*res);
    stats.stopMeasurement(prefix + "Cache Path Analysis");
    return bound;
  } // else
  typedef StateExplorationDomain<MuState> MuArchDomain;
  auto res = doMuArchTimingAnalysis<MuArchDomain>(deps);
  auto bound = dispatchCachePathAnalysis<MuArchDomain>(*res);
  // Res deleted at the end of state graph construction
  return bound;
}

} // namespace TimingAnalysisPass

#endif
