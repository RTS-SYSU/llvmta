////////////////////////////////////////////////////////////////////////////////
//
//   LLVMTA - Timing Analyser performing worst-case execution time analysis
//     using the LLVM backend intermediate representation
//
// Copyright (C) 2013-2022  Saarland University
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

#include "Memory/crpd/CacheRelatedPreemptionDelay.h"
#include "LLVMPasses/DispatchMemory.h"
#include "Memory/crpd/DCUsefulCacheBlocks.h"
#include "Memory/crpd/EvictingCacheBlocks.h"

#include "AnalysisFramework/AnalysisResults.h"
#include "AnalysisFramework/GraphIterator.h"

#include "boost/algorithm/string/predicate.hpp"
#include "boost/algorithm/string/trim.hpp"
#include "boost/lexical_cast.hpp"
#include <fstream>
#include <iostream>
#include <numeric>

namespace TimingAnalysisPass {

using namespace dom::cache;

template <CacheTraits *CacheConfig>
auto CacheRelatedPreemptionDelay<CacheConfig>::runResilienceAnalysis(
    const ECBInfo &ECBs, unsigned CRT) const -> unsigned {

  DEBUG_WITH_TYPE("res", { std::cout << "Computing UCBs..." << std::endl; });

  auto UCBs = computeUCBsPerPP();

  DEBUG_WITH_TYPE("res", {
    std::cout << "Computed UCBs.\nComputing Resilience..." << std::endl;
  });

  auto Resilience = computeResiliencePerPP(UCBs);

  DEBUG_WITH_TYPE("res", { std::cout << "Computed Resilience." << std::endl; });

  unsigned crpd = 0;

  // Look at the UCBs for each program point
  for (const auto &kv : UCBs) {

    unsigned crpdPP = 0;

    auto ResPP = Resilience.at(kv.first);
    // ... at each cache set
    for (unsigned i = 0; i < N_SETS; ++i) {

      unsigned NumECBs = ECBs.at(i);
      const auto &ResSet = ResPP.at(i);
      const auto &UCBSet = kv.second.at(i);

      // Check for all useful cache blocks if the resilience is big enough
      for (const auto &Elem : UCBSet) {
        assert(ResSet.find(Elem) != ResSet.end());
        unsigned Res = ResSet.find(Elem)->second;

        // Count the elements that will not be useful any more after the
        // preemption
        if (Res < NumECBs) {
          crpdPP += 1;
        }
      }
    }

    // Take only the crpd of the most costly preemption point
    crpd = std::max(crpd, crpdPP);
  }

  DEBUG_WITH_TYPE("res", {
    std::cout << "CRPD (Resilience based): " << crpd
              << " with cache reload time: " << CRT * crpd << std::endl;
  });

  return CRT * crpd;
}

template <CacheTraits *CacheConfig>
auto CacheRelatedPreemptionDelay<CacheConfig>::computeUCBsPerSet() const
    -> UCBInfo {

  // Compute program point sensitive information for UCBs
  const auto &Info = computeUCBsPerPP();

  // Find the maximale number of UCBs of a set over all program points
  UCBInfo MaxUCBsForSet(N_SETS);
  auto sum = 0;
  for (const auto &kv : Info) {
    const auto &Sets = kv.second;
    auto ssum = 0;
    for (unsigned i = 0; i < N_SETS; ++i) {
      // The size of Set is always smaller than the ASSOCIATIVITY
      auto UCBsInSet = std::min((unsigned)Sets.at(i).size(), ASSOCIATIVITY);
      MaxUCBsForSet[i] = std::max(MaxUCBsForSet.at(i), UCBsInSet);
      ssum += UCBsInSet;
    }
    sum = (sum > ssum) ? sum : ssum;
  }
  AnalysisResults &result = AnalysisResults::getInstance();
  result.registerResult("MaxUCBsAtAnyProgramPoint", sum);
  return MaxUCBsForSet;
}

template <CacheTraits *CacheConfig>
auto CacheRelatedPreemptionDelay<CacheConfig>::computeDCUCBsPerSet() const
    -> UCBInfo {

  // Compute program point sensitive information for UCBs
  const auto &Info = computeDCUCBsPerPP();

  // Find the maximale number of UCBs of a set over all program points
  UCBInfo MaxDCUCBsForSet(N_SETS);
  auto sum = 0;
  for (const auto &kv : Info) {
    const auto &Sets = kv.second;
    auto ssum = 0;
    for (unsigned i = 0; i < N_SETS; ++i) {
      // The size of Set is always smaller than the ASSOCIATIVITY
      auto DCUCBsInSet = std::min((unsigned)Sets.at(i).size(), ASSOCIATIVITY);
      MaxDCUCBsForSet[i] = std::max(MaxDCUCBsForSet.at(i), DCUCBsInSet);
      ssum += DCUCBsInSet;
    }
    sum = (sum > ssum) ? sum : ssum;
  }
  AnalysisResults &result = AnalysisResults::getInstance();
  result.registerResult("MaxDCUCBsAtAnyProgramPoint", sum);
  return MaxDCUCBsForSet;
}

template <CacheTraits *CacheConfig>
auto CacheRelatedPreemptionDelay<CacheConfig>::computeResiliencePerPP(
    const UCBsPerPP &UCBs) const -> ResInfo {

  DEBUG_WITH_TYPE(
      "res", { std::cout << "Computing ua analysis results..." << std::endl; });

  // Compute unconstrained ages
  auto uaForwards = computeUnconstrainedAges(false);

  auto uaBackwards = computeUnconstrainedAges(true);

  DEBUG_WITH_TYPE("res", {
    std::cout << "Computed ua analysis results.\nComputing UCBs..."
              << std::endl;
  });

  DEBUG_WITH_TYPE("res", {
    std::cout << "Computed UCBs.\nComputing constrained ages..." << std::endl;
  });

  // Compute constrained ages
  auto caForwards = computeConstrainedAges(UCBs, false, std::move(uaForwards));

  auto caBackwards = computeConstrainedAges(UCBs, true, std::move(uaBackwards));

  DEBUG_WITH_TYPE("res",
                  { std::cout << "Computed constrained ages." << std::endl; });

  // Compute the resilience information pre program point
  ResInfo Res;
  for (const auto &KV : *caForwards) {

    // Collect all information for the current program point
    auto PP = KV.first;
    auto caFPP = KV.second;
    auto caBPP = caBackwards->at(PP);
    auto UCBPP = UCBs.at(PP);

    auto caFSets = caFPP.getCacheSets();
    auto caBSets = caBPP.getCacheSets();

    // Look at each cache set
    std::vector<std::map<TagType, unsigned>> SetWise(N_SETS);

    unsigned SetNum = 0;
    for (const auto &Set : UCBPP) {

      auto caFSet = caFSets.at(SetNum);
      auto caBSet = caBSets.at(SetNum);

      std::map<TagType, unsigned> ResMap;
      // Iterate over the UCBs
      for (const auto &Elem : Set) {
        unsigned AgeF = caFSet->getConstrainedAge(Elem);
        unsigned AgeB = caBSet->getConstrainedAge(Elem);

        // Compute the actual resilience
        // maxAge(m) = min {caForwards(m) + caBackwards(m), ASSOC - 1}
        // res(m) = (k-1) - maxAge(m)
        unsigned res =
            (ASSOCIATIVITY - 1) - std::min(AgeF + AgeB, ASSOCIATIVITY - 1);
        ResMap.insert(std::pair<TagType, unsigned>(Elem, res));
      }

      SetWise[SetNum] = ResMap;

      SetNum++;
    }

    Res[PP] = SetWise;
  }

  return Res;
}

template <CacheTraits *CacheConfig>
auto CacheRelatedPreemptionDelay<CacheConfig>::computeResiliencePerSet(
    const UCBsPerPP &UCBs) const -> std::vector<std::map<TagType, unsigned>> {

  auto ResPerPP = computeResiliencePerPP(UCBs);

  std::vector<std::map<TagType, unsigned>> ResSet(N_SETS);

  // Look at each program point
  for (const auto &KV : ResPerPP) {
    const auto &Sets = KV.second;
    // ...and cache set
    for (unsigned i = 0; i < N_SETS; ++i) {
      const auto &Set = Sets.at(i);
      auto &ResSingleSet = ResSet.at(i);

      // for every resilience information find out if we already have an entry
      // in the result map, add it or update the resilience value
      for (const auto &Entry : Set) {
        auto Tag = Entry.first;
        unsigned Age = Entry.second;

        if (ResSingleSet.find(Tag) != ResSingleSet.end()) {
          ResSingleSet[Tag] = std::min(Age, ResSingleSet[Tag]);
        } else {
          ResSingleSet[Tag] = Entry.second;
        }
      }
    }
  }

  return ResSet;
}

template <CacheTraits *CacheConfig>
auto CacheRelatedPreemptionDelay<CacheConfig>::computeTagsForResilience(
    const UCBsPerPP &UCBs) const -> std::map<unsigned, ImplicitSet<TagType>> {

  std::map<unsigned, ImplicitSet<TagType>> ResInSen;

  auto ResSet = computeResiliencePerSet(UCBs);

  for (const auto &Map : ResSet) {

    for (const auto &KV : Map) {
      auto Tag = KV.first;
      auto Age = KV.second;

      // Make a lookup of the value in the result map
      bool found = false;
      for (auto &Entry : ResInSen) {

        // Check if tag is contained
        if (Entry.second.find(Tag) != Entry.second.end()) {
          found = true;
          if (Entry.first >= Age) {
            // We found a smaller age of this block
            if (ResInSen.find(Age) != ResInSen.end()) {
              ResInSen[Age].insert(Tag);
            } else {
              ResInSen[Age] =
                  ImplicitSet<TagType>(Tag); // TODO check that this does not
                                             // call the bool constructor
            }
            Entry.second.erase(Tag);
            break;
          }
        }
      }
      if (!found) {
        // This is a new element, insert it
        if (ResInSen.find(Age) != ResInSen.end()) {
          ResInSen[Age].insert(Tag);
        } else {
          ResInSen[Age] = ImplicitSet<TagType>(Tag);
        }
      }
    }
  }

  return ResInSen;
}

//------------------------------ECB related methods--------------------------//

template <CacheTraits *CacheConfig>
auto CacheRelatedPreemptionDelay<CacheConfig>::computeECBsPerSet() const
    -> ECBInfo {

  using ECBType = dom::cache::AbstractCacheImpl<
      CacheConfig, dom::cache::EvictingCacheBlocks<CacheConfig>>;
  ECBType ECB{};
  GraphIterator<ECBType> CacheAnalysis(SimpleGraph, Provider);
  CacheAnalysis.runSimpleAccumulatedEdgeEffectAnalysis(ECB);

  const auto &Sets = ECB.getCacheSets();

  ECBInfo ECBS(N_SETS);

  for (unsigned i = 0; i < N_SETS; ++i) {
    const auto &S = Sets.at(i);
    if (S->isTop()) {
      ECBS[i] = ASSOCIATIVITY;
    } else {
      const auto &Blocks = S->getAccessedTags();
      ECBS[i] = Blocks.size();
    }
  }

  DEBUG_WITH_TYPE("ecb", {
    std::cout << "ECBS:\n";
    for (unsigned i = 0; i < N_SETS; ++i) {
      std::cout << "Set: " << i << " #ECBs: " << ECBS.at(i) << "\n";
    }
  });

  return ECBS;
}

template <CacheTraits *CacheConfig>
auto CacheRelatedPreemptionDelay<CacheConfig>::computeECBs() const -> unsigned {
  auto ECBsSet = computeECBsPerSet();
  return std::accumulate(ECBsSet.begin(), ECBsSet.end(), 0);
}

//------------------------------UCB related methods--------------------------//

template <CacheTraits *CacheConfig>
auto CacheRelatedPreemptionDelay<CacheConfig>::computeDCUCBsPerPP() const
    -> UCBsPerPP {

  // Apply a regular forward and backward may analysis (program point sensitive)
  // Intersection of the results are the UCBs of the program point
  GraphIterator<LRUMust> ForwardCacheAnalysis(SimpleGraph, Provider);
  GraphIterator<dom::cache::AbstractCacheImpl<
      CacheConfig, dom::cache::DCUsefulCacheBlocks<CacheConfig>>>
      BackwardCacheAnalysis(SimpleGraph, Provider);

  auto CacheStatesForwards = ForwardCacheAnalysis.runFixpointAnalysis(nullptr);

  // Information for a cache set: must information
  using SingleInfoType = std::tuple<const LRUMaxAge &>;
  // Type for information for whole cache
  using AddInfoType = std::vector<SingleInfoType *>;
  // Program point sensitive information
  using AddInfoTypePP = std::map<unsigned, AddInfoType *>;

  AddInfoTypePP AddInfo;
  for (const auto &KV : *CacheStatesForwards) {
    unsigned PP = KV.first;
    // This is an AbsCacheimpl
    auto LRUMustInfo = KV.second;
    // Take the set wise information out
    auto LRUMustSets = LRUMustInfo.getCacheSets();

    // Repack the information
    AddInfoType *Info = new AddInfoType(N_SETS);
    unsigned i = 0;
    for (const auto &cs2idx : LRUMustSets) {
      (*Info)[i] = new SingleInfoType(*cs2idx);
      ++i;
    }
    AddInfo[PP] = Info;
  }

  auto CacheStatesBackwards =
      BackwardCacheAnalysis.runFixpointAnalysis(&AddInfo, true);

  GraphIterator<dom::cache::TrackLastAccess<CacheConfig>> LastAccessAnalysis(
      SimpleGraph, Provider);
  auto LastAccessForwards = LastAccessAnalysis.runFixpointAnalysis(nullptr);

  DEBUG_WITH_TYPE("dcucb", {
    for (const auto &kv : *CacheStatesForwards) {
      auto F = kv.second;
      auto B = CacheStatesBackwards->at(kv.first);
      std::cout << "State: " << kv.first << "\nFoward (Must): " << F
                << "Backwards (DCUCB): " << B << std::endl;
    }
  });

  UCBsPerPP UCBsPerProgramPoint;

  // Look at the information at every program point
  for (const auto &E1 : *CacheStatesBackwards) {
    unsigned PP = E1.first;

    // Get the cache sets for the current program point
    auto Sets = E1.second.getCacheSets();
    std::vector<ImplicitSet<TagType>> temp(N_SETS);
    for (unsigned i = 0; i < N_SETS; ++i) {
      temp[i] = Sets.at(i)->getDCUsefulBlocks();
    }

    const auto &LastAccessState = LastAccessForwards->at(PP);
    const auto &LastAccess = LastAccessState.getLastAccess();

    if (UCBClever) {
      if (LastAccess) {
        /*std::cerr << "We have a last access at PP: " << PP << " : ";
        printHex(std::cerr, LastAccess.get());
        std::cerr << "\n";*/
        unsigned tag, index;
        boost::tie(tag, index) =
            LastAccessState.getTagAndIndex(LastAccess.get());
        // std::cerr << "Before: " << temp.at(index) << "\n";
        temp.at(index).erase(tag);
        // std::cerr << "After: " << temp.at(index) << "\n";
      } /* else {
               std::cerr << "No access at PP: " << PP << "\n";
       }*/
    }

    UCBsPerProgramPoint[PP] = temp;
  }

  DEBUG_WITH_TYPE("dcucb", {
    std::cout << "DCUCBs:" << std::endl;
    for (const auto &kv : UCBsPerProgramPoint) {
      std::cout << "PP: " << kv.first << " ";
      for (const auto &E : kv.second) {
        std::cout << E << "\t";
      }
      std::cout << std::endl;
    }
  });

  return UCBsPerProgramPoint;
}

template <CacheTraits *CacheConfig>
auto CacheRelatedPreemptionDelay<CacheConfig>::computeUCBsPerPP() const
    -> UCBsPerPP {

  // Apply a regular forward and backward may analysis (program point sensitive)
  // Intersection of the results are the UCBs of the program point
  GraphIterator<LRUMay> CacheAnalysis(SimpleGraph, Provider);

  auto CacheStatesForwards = CacheAnalysis.runFixpointAnalysis(nullptr);
  auto CacheStatesBackwards = CacheAnalysis.runFixpointAnalysis(nullptr, true);

  GraphIterator<dom::cache::TrackLastAccess<CacheConfig>> LastAccessAnalysis(
      SimpleGraph, Provider);
  auto LastAccessForwards = LastAccessAnalysis.runFixpointAnalysis(nullptr);

  DEBUG_WITH_TYPE("ucb", {
    for (const auto &kv : *CacheStatesForwards) {
      auto F = kv.second;
      auto B = CacheStatesBackwards->at(kv.first);
      std::cout << "State: " << kv.first << "\nFoward: " << F
                << "Backwards: " << B << std::endl;
    }
  });

  UCBsPerPP UCBsPerProgramPoint;

  // Look at the information at every program point
  for (const auto &E1 : *CacheStatesForwards) {
    unsigned PP = E1.first;
    const auto &E2 = CacheStatesBackwards->at(PP);

    const auto &LastAccessState = LastAccessForwards->at(PP);
    const auto &LastAccess = LastAccessState.getLastAccess();

    auto temp = computeCommonElements(E1.second, E2);

    if (UCBClever) {
      if (LastAccess) {
        /*std::cerr << "We have a last access at PP: " << PP << " : ";
        printHex(std::cerr, LastAccess.get());
        std::cerr << "\n";*/
        unsigned tag, index;
        boost::tie(tag, index) =
            LastAccessState.getTagAndIndex(LastAccess.get());
        // std::cerr << "Before: " << temp.at(index) << "\n";
        temp.at(index).erase(tag);
        // std::cerr << "After: " << temp.at(index) << "\n";
      } /* else {
               std::cerr << "No access at PP: " << PP << "\n";
       }*/
    }

    UCBsPerProgramPoint[PP] = temp;
  }

  DEBUG_WITH_TYPE("ucb", {
    std::cout << "UCBs:" << std::endl;
    for (const auto &kv : UCBsPerProgramPoint) {
      std::cout << "PP: " << kv.first << " ";
      for (const auto &E : kv.second) {
        std::cout << E << "\t";
      }
      std::cout << std::endl;
    }
  });

  return UCBsPerProgramPoint;
}

template <CacheTraits *CacheConfig>
auto CacheRelatedPreemptionDelay<CacheConfig>::computeUCBsSetWise() const
    -> UCBsSetWise {

  auto UCBs = computeUCBsPerPP();

  UCBsSetWise Result(N_SETS);

  // Look at each program point
  for (const auto &KV : UCBs) {
    // ...and each cache set
    for (unsigned i = 0; i < N_SETS; ++i) {
      const auto &UCBsSet = KV.second.at(i);
      // Collect all blocks that have been useful at some point
      Result.at(i).insert(UCBsSet.begin(), UCBsSet.end());
    }
  }

  return Result;
}

template <CacheTraits *CacheConfig>
auto CacheRelatedPreemptionDelay<CacheConfig>::computeUCBs() const
    -> UsefulBlocks {

  auto UCBs = computeUCBsSetWise();

  UsefulBlocks Result{};

  for (unsigned i = 0; i < N_SETS; ++i) {
    Result.insert(UCBs.at(i).begin(), UCBs.at(i).end());
  }

  return Result;
}
//-------------------------------IO stuff-------------------------------------//

template <CacheTraits *CacheConfig>
void CacheRelatedPreemptionDelay<CacheConfig>::dumpUCBs(
    UCBInfo UCBs, std::string prefix) const {
  AnalysisResults &result = AnalysisResults::getInstance();
  int i = 0;

  // dump the data
  for (const auto &Elem : UCBs) {
    std::string tag = prefix + " set=\"" + std::to_string(i) + "\"";
    result.registerResult(tag, Elem);
    i++;
  }
}

template <CacheTraits *CacheConfig>
void CacheRelatedPreemptionDelay<CacheConfig>::dumpECBs(std::string filename,
                                                        ECBInfo ECBs) const {
  std::ofstream ECBfile;
  AnalysisResults &result = AnalysisResults::getInstance();
  int i = 0;

  if (!boost::ends_with(filename, ".csv")) {
    filename += ".csv";
  }

  // open the file
  ECBfile.open(filename.c_str());

  if (!ECBfile.is_open()) {
    std::cout << "Failed to open file!" << std::endl;
    return;
  }

  // dump the data
  for (const auto &Elem : ECBs) {
    std::string tag = "ECB set=\"" + std::to_string(i) + "\"";
    result.registerResult(tag, Elem);
    ECBfile << Elem << "\n";
    i++;
  }

  // close the file again
  ECBfile.close();
  if (ECBfile.is_open()) {
    std::cout << "Failed to close file!" << std::endl;
  }
}

template <CacheTraits *CacheConfig>
auto CacheRelatedPreemptionDelay<CacheConfig>::readECBs(
    std::string filename) const -> ECBInfo {

  if (!boost::ends_with(filename, ".csv")) {
    filename += ".csv";
  }

  // open the file
  std::ifstream ECBfile(filename.c_str());

  if (!ECBfile.is_open()) {
    std::cout << "Unable to open file " << filename << std::endl;
    return {};
  }

  // read the ecbs
  ECBInfo ECBs(N_SETS);

  std::string line;
  for (unsigned i = 0; i < N_SETS; ++i) {
    bool ok = (bool) std::getline(ECBfile, line);

    if (!ok) {
      std::cout << "File does not have " << N_SETS << " lines!" << std::endl;
      return {};
    }

    boost::trim(line);
    unsigned NumECBs = 0;
    try {
      NumECBs = boost::lexical_cast<unsigned>(line);
    } catch (const boost::bad_lexical_cast &e) {
      std::cout << e.what() << std::endl;
      return {};
    }

    ECBs[i] = NumECBs;
  }

  // close the file again
  ECBfile.close();
  if (ECBfile.is_open()) {
    std::cout << "Failed to close file!" << std::endl;
  }

  DEBUG_WITH_TYPE("ecb", {
    std::cout << "ECBs read: " << std::endl;
    for (unsigned i = 0; i < N_SETS; ++i) {
      std::cout << ECBs.at(i) << std::endl;
    }
  });

  return ECBs;
}

//--------------------------------private--------------------------------------//

template <CacheTraits *CacheConfig>
auto CacheRelatedPreemptionDelay<CacheConfig>::computeUnconstrainedAges(
    bool backwards) const -> std::unique_ptr<std::map<unsigned, LRUMust>> {

  GraphIterator<LRUMust> CacheAnalysis(SimpleGraph, Provider);
  std::unique_ptr<std::map<unsigned, LRUMust>> CacheStates =
      CacheAnalysis.runFixpointAnalysis(nullptr, backwards);

  return std::move(CacheStates);
}

template <CacheTraits *CacheConfig>
auto CacheRelatedPreemptionDelay<CacheConfig>::computeConstrainedAges(
    const UCBsPerPP &UCBs, bool backwards,
    std::unique_ptr<std::map<unsigned, LRUMust>> UnconstrainedAges) const
    -> std::unique_ptr<std::map<unsigned, ConstrainedAgeType>> {

  DEBUG_WITH_TYPE("ca", {
    std::cout << "Given UCBs:" << std::endl;
    for (const auto &PP : UCBs) {

      std::cout << "Program point: " << PP.first << std::endl;
      for (const auto &Elem : PP.second) {
        std::cout << Elem << std::endl;
      }
    }
    std::cout << "End UCBs." << std::endl;
  });

  // Zip the given information together to make it fit into the graph iterator

  using SingleInfoType =
      std::tuple<const ImplicitSet<TagType> &, const LRUMaxAge &>;
  // Type for information of UCBs + Unconstrained for one cache
  using AddInfoType = std::vector<SingleInfoType *>;
  // Program point sensitive information
  using AddInfoTypePP = std::map<unsigned, AddInfoType *>;

  DEBUG_WITH_TYPE(
      "ca", { std::cout << "Computing Additional Infos..." << std::endl; });

  AddInfoTypePP AddInfo;
  for (const auto &KV : UCBs) {
    unsigned PP = KV.first;

    // This is an AbsCacheimpl
    auto LRUMustInfo = UnconstrainedAges->at(PP);
    // Take the set wise information out
    auto LRUMustSets = LRUMustInfo.getCacheSets();

    // Zip the information for UCBs and unconstrained ages for each set/PP
    // together
    AddInfoType *ZippedInfo = new AddInfoType(N_SETS);
    unsigned i = 0;
    for (const auto &UCBsAtPPSet : KV.second) {
      // TODO should this be a copy?
      const LRUMaxAge LRUMustSet = *LRUMustSets.at(i);
      SingleInfoType *P = new SingleInfoType(UCBsAtPPSet, LRUMustSet);
      (*ZippedInfo)[i] = P;
      ++i;
    }
    AddInfo[PP] = ZippedInfo;
  }

  DEBUG_WITH_TYPE("ca",
                  { std::cout << "Computed Additional Info." << std::endl; });

  // Compute the actual constrained ages
  GraphIterator<ConstrainedAgeType> ConstrainedAgeAnalysis(SimpleGraph,
                                                           Provider);

  std::unique_ptr<std::map<unsigned, ConstrainedAgeType>> CacheStates =
      ConstrainedAgeAnalysis.runFixpointAnalysis(&AddInfo, backwards);

  // Free additional info
  for (const auto &KV : AddInfo) {
    for (const auto &Entry : *KV.second) {
      delete (Entry);
    }
    delete (KV.second);
  }

  DEBUG_WITH_TYPE("ca",
                  { std::cout << "Computed Constrained Ages." << std::endl; });

  DEBUG_WITH_TYPE("ca", {
    std::cout << "Constrained ages results:" << std::endl;
    for (const auto kv : *CacheStates) {
      std::cout << "PP: " << kv.first << "\n" << kv.second << std::endl;
    }
    std::cout << "End contrained age results." << std::endl;
  });

  return std::move(CacheStates);
}

template <CacheTraits *CacheConfig>
auto CacheRelatedPreemptionDelay<CacheConfig>::computeCommonElements(
    const LRUMay &LRU1, const LRUMay &LRU2) const
    -> std::vector<ImplicitSet<TagType>> {

  // Get the cache sets for the current program point
  auto Sets1 = LRU1.getCacheSets();
  auto Sets2 = LRU2.getCacheSets();

  std::vector<ImplicitSet<TagType>> CommonElems(N_SETS);

  // Compute the common elements of the different cache sets and add the
  // information to the result
  for (unsigned i = 0; i < N_SETS; ++i) {
    auto S1 = Sets1.at(i)->getTagsWithMaxMinAge(ASSOCIATIVITY - 1);
    auto S2 = Sets2.at(i)->getTagsWithMaxMinAge(ASSOCIATIVITY - 1);
    DEBUG_WITH_TYPE("ucb", std::cout << "S1: " << S1 << " S2: " << S2 << "\n";);

    CommonElems[i] = ImplicitSet<TagType>::intersect(S1, S2);

    DEBUG_WITH_TYPE("ucb",
                    std::cout << "Intersection: " << CommonElems[i] << "\n";);
  }

  return CommonElems;
}

// List of instantiations of CRPD

template class CacheRelatedPreemptionDelay<&icacheConf>;
template class CacheRelatedPreemptionDelay<&dcacheConf>;

} // namespace TimingAnalysisPass
