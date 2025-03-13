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

#ifndef ANALYSISINFORMATION_H
#define ANALYSISINFORMATION_H

#include <iostream>
#include <map>

#include "llvm/Support/raw_ostream.h"

#include "AnalysisFramework/CallGraph.h"
#include "LLVMPasses/MachineFunctionCollector.h"
#include "PartitionUtil/DirectiveHeuristics.h"
#include "Util/Options.h"

namespace TimingAnalysisPass {

template <class Info> struct InfoInOut {
  InfoInOut(Info in, Info out) : in(in), out(out){};
  Info in;
  Info out;
};

////////////////////////////////////////////////
/// Analysis Information - General Interface ///
////////////////////////////////////////////////

/**
 * Template class representing analysis information of type AnaDom at
 * granularity Granularity. There is analysis information valid before and after
 * a specific program location.
 */
template <class AnaDom, typename Granularity> class AnalysisInformation {};

/**
 * Specilization for the case of Granularity = MachineInstr.
 */
template <class AnaDom> class AnalysisInformation<AnaDom, MachineInstr> {
public:
  virtual ~AnalysisInformation() {}
  /**
   * Return the analysis information valid before MI.
   */
  virtual bool hasAnaInfoBefore(const MachineInstr *MI) const = 0;
  virtual const AnaDom &getAnaInfoBefore(const MachineInstr *MI) const = 0;
  /**
   * Return the analysis information valid after MI.
   */
  virtual bool hasAnaInfoAfter(const MachineInstr *MI) const = 0;
  virtual const AnaDom &getAnaInfoAfter(const MachineInstr *MI) const = 0;
  /**
   * Return the analysis information valid after MI where MI is a branch with
   * outcome bo. It uses the guard function on top of getAnaInfoAfter.
   */
  virtual const AnaDom getAnaInfoAfterGuarded(const MachineInstr *MI,
                                              BranchOutcome bo) const = 0;

  /**
   * Returns dependencies information for the analysis.
   */
  virtual typename AnaDom::AnaDeps getAnaDepsInfo() const = 0;

  /**
   * Dump the analysis information on MachineInstr Granularity
   */
  virtual void dump(std::ostream &mystream) const {
    mystream << "##########################\n"
             << "## Analysis Information ##\n"
             << "##########################\n";
    for (auto currFunc : machineFunctionCollector->getAllMachineFunctions()) {
      mystream << "#### Function: " << currFunc->getName().str() << "\n";
      for (auto currBB = currFunc->begin(); currBB != currFunc->end();
           ++currBB) {
        mystream << "### Basic Block: " << currBB->getNumber() << "\n";
        for (auto &currInstr : *currBB) {
          if (currInstr.isTransient()) {
            continue;
          }
          std::string instrdesc;
          raw_string_ostream llvmstr(instrdesc);
          currInstr.print(llvmstr);
          mystream << "## Instruction: " << llvmstr.str();
          mystream << "# Before:\n";
          if (hasAnaInfoBefore(&currInstr)) {
            mystream << getAnaInfoBefore(&currInstr).print() << "\n";
          } else {
            mystream << "not available\n";
          }
          mystream << "# After:\n";
          if (hasAnaInfoAfter(&currInstr)) {
            mystream << getAnaInfoAfter(&currInstr).print() << "\n";
          } else {
            mystream << "not available\n";
          }
        }
      }
    }
  }
};

#if 0
// TODO Do it on Machine Basic Block granularity
#endif

//////////////////////////////////////////////////
/// Analysis Information - Precomputed Results ///
//////////////////////////////////////////////////

/**
 * Template class implementing AnalysisInformation.
 * This is the general case for analysis information that holds precomputed
 * analysis results. This trades-off shorter lookup time versus higher memory
 * consumption.
 */
template <class AnaDom, typename Granularity>
class AnalysisInformationPrecomputed
    : public AnalysisInformation<AnaDom, Granularity> {};

/**
 * Provides analysis information in a precomputed manner for instruction-level
 * granularity. This class is not copy-constructible due to the unique_ptr.
 */
template <class AnaDom>
class AnalysisInformationPrecomputed<AnaDom, MachineInstr>
    : public AnalysisInformation<AnaDom, MachineInstr> {
public:
  // Make AnaDeps visible again
  typedef typename AnaDom::AnaDeps AnaDeps;

  /**
   * Constructor with computed analysis information provided
   */
  AnalysisInformationPrecomputed(
      std::unique_ptr<std::map<const MachineInstr *, AnaDom>> in,
      std::unique_ptr<std::map<const MachineInstr *, AnaDom>> out,
      AnaDeps &anaInfo)
      : anaInfoIn(std::move(in)), anaInfoOut(std::move(out)),
        depAnalysisResults(anaInfo) {}

  virtual ~AnalysisInformationPrecomputed() {
    // unique_ptr are deleted automatically
  }

  virtual bool hasAnaInfoBefore(const MachineInstr *MI) const {
    // Either we precomputed everything, or only partially
    return AnaInfoPol == AnaInfoPolicy::PRECOMPALL || anaInfoIn->count(MI) > 0;
  }

  virtual const AnaDom &getAnaInfoBefore(const MachineInstr *MI) const {
    assert(anaInfoIn->count(MI) > 0 &&
           "We could not find information for the given g");
    return anaInfoIn->find(MI)->second;
  }

  virtual bool hasAnaInfoAfter(const MachineInstr *MI) const {
    // Either we precomputed everything, or only partially
    return AnaInfoPol == AnaInfoPolicy::PRECOMPALL || anaInfoOut->count(MI) > 0;
  }

  virtual const AnaDom &getAnaInfoAfter(const MachineInstr *MI) const {
    assert(anaInfoOut->count(MI) > 0 &&
           "We could not find information for the given g");
    return anaInfoOut->find(MI)->second;
  }

  virtual const AnaDom getAnaInfoAfterGuarded(const MachineInstr *MI,
                                              BranchOutcome bo) const {
    assert((MI->isConditionalBranch() || isJumpTableBranch(MI) ||
            MI->isReturn()) &&
           "Cannot have guarded analysis info for non-cond. branch");
    assert(anaInfoOut->count(MI) > 0 &&
           "We could not find information for the given g");
    AnaDom anaInfoAfter(anaInfoOut->find(MI)->second);
    AnaDeps guardAnaDeps(depAnalysisResults);
    anaInfoAfter.guard(MI, guardAnaDeps, bo);
    return anaInfoAfter;
  }

  virtual AnaDeps getAnaDepsInfo() const { return depAnalysisResults; }

private:
  /**
   * Analysis information valid before program location.
   * (TODO memory space optimisation: if count == 0 -> top??)
   */
  std::unique_ptr<std::map<const MachineInstr *, AnaDom>> anaInfoIn;
  /**
   * Analysis information valid after program location.
   * (TODO memory space optimisation: if count == 0 -> top??)
   */
  std::unique_ptr<std::map<const MachineInstr *, AnaDom>> anaInfoOut;

  AnaDeps depAnalysisResults;
};

// TODO: We currently do not support the below memory-optimized version.
// First of all, it breaks with the reference-returning interface, and
// Second it is slow as hell: one would need some caching method to make it
// half-way fast.
#if 0

///////////////////////////////////////////////
/// Analysis Information - Memory Optimized ///
///////////////////////////////////////////////

/**
 * Template class implementing AnalysisInformation.
 * This is the general case for analysis information that holds only necessary analysis results.
 * Individual results are recomputed on-the-fly.
 * This trades-off lower memory consumption for slightly higher lookup times.
 */
template <class AnaDom, typename Granularity>
class AnalysisInformationMemOpt : public AnalysisInformation<AnaDom, Granularity>
{ };

/**
 * Provides analysis information in a memory-optimized manner for instruction-level granularity.
 * This class is not copy-constructible due to the unique_ptr.
 * Instruction-level information is recomputed based on basicblock-level information.
 */
template <class AnaDom>
class AnalysisInformationMemOpt<AnaDom, MachineInstr>
		: public AnalysisInformation<AnaDom, MachineInstr>
{
	public:
	// Make AnaDeps visible again
	typedef typename AnaDom::AnaDeps AnaDeps;
	
	/**
	 * Constructor with computed analysis information provided
	 */
	AnalysisInformationMemOpt(std::unique_ptr<std::map<const MachineBasicBlock*, AnaDom>> bbinfo,
											std::unique_ptr<std::map<const MachineFunction*, InfoInOut<AnaDom>>> funcinfo,
											AnaDeps& anaInfo) 
		: anaInfoBBIn(std::move(bbinfo)), anaInfoFunc(std::move(funcinfo)), depAnalysisResults(anaInfo)
	{ }

	virtual ~AnalysisInformationMemOpt() {
		// unique_ptrs are deleted automatically
	}

	virtual const AnaDom getAnaInfoBefore(const MachineInstr* MI) const
	{
		auto currBB = MI->getParent();
		AnaDom res(anaInfoBBIn->find(currBB)->second);
		for (auto currInstr = currBB->begin(); currInstr != currBB->end(); ++currInstr) {
			if (((const MachineInstr*) currInstr) == MI) {
				return res;
			}
			if (!currInstr->isTransient()) {
				analyseInstruction(currInstr, res);
				handleBranchInstruction(currInstr, res);
			}
		}
		assert (0 && "Could not find instruction in its basic block");
		return res;
	}
	
	virtual const AnaDom getAnaInfoAfter(const MachineInstr* MI) const
	{
		auto currBB = MI->getParent();
		AnaDom res(anaInfoBBIn->find(currBB)->second);
		for (auto currInstr = currBB->begin(); currInstr != currBB->end(); ++currInstr) {
			if (!currInstr->isTransient()) {
				analyseInstruction(currInstr, res);
			}
			if (((const MachineInstr*) currInstr) == MI) {
				return res;
			}
			if (!currInstr->isTransient()) {
				handleBranchInstruction(currInstr, res);
			}
		}
		assert (0 && "Could not find instruction in its basic block");
		return res;
	}
	
	virtual const AnaDom getAnaInfoAfterGuarded(const MachineInstr* MI, BranchOutcome bo) const
	{
		assert ((MI->isConditionalBranch() || isJumpTableBranch(MI) || MI->isReturn())
		         && "Cannot have guarded analysis info for non-branches");
		AnaDom res = getAnaInfoAfter(MI);
		res.guard(MI, depAnalysisResults, bo);
		return res;
	}

	virtual AnaDeps getAnaDepsInfo() const
	{
		return depAnalysisResults;
	}

	virtual void dump(std::ostream& mystream) const {
		mystream 	<< "##########################\n"
							<< "## Analysis Information ##\n"
							<< "##########################\n";
		for (auto currFunc : machineFunctionCollector->getAllMachineFunctions()) {
			mystream << "#### Function: " << currFunc->getName().str() << "\n";
			for (auto& currBB : *currFunc) {
				mystream << "### Basic Block: " << currBB.getNumber() << "\n";
				AnaDom bbinfo(anaInfoBBIn->find(&currBB)->second);
				for (auto currInstr = currBB.begin(); currInstr != currBB.end(); ++currInstr) {
					std::string instrdesc;
					raw_string_ostream llvmstr(instrdesc);
					currInstr->print(llvmstr);
					mystream << "## Instruction: " << llvmstr.str();
					mystream << "# Before:\n";
					mystream << bbinfo.print() << "\n";
					if (!currInstr->isTransient()) {
						analyseInstruction(currInstr, bbinfo);
					}
					mystream << "# After:\n";
					mystream << bbinfo.print() << "\n";
					if (!currInstr->isTransient()) {
						handleBranchInstruction(currInstr, bbinfo);
					}
				}
			}
		}
	}

	private:
	/**
	 * Analysis information valid at basicblock entry.
	 */
	std::unique_ptr<std::map<const MachineBasicBlock*, AnaDom>> anaInfoBBIn;
	/**
	 * Analysis information valid at function entries and exits.
	 */
	std::unique_ptr<std::map<const MachineFunction*, InfoInOut<AnaDom>>> anaInfoFunc;
	/**
	 * Analysis results of dependent analyses
	 */
	AnaDeps depAnalysisResults;

	// Recompute information on-the-fly
	void analyseInstruction(const MachineInstr* currentInstr, AnaDom& ad) const;
	void handleBranchInstruction(const MachineInstr* branchInstr, AnaDom& ad) const;
};


template <class AnaDom>
void AnalysisInformationMemOpt<AnaDom, MachineInstr>::analyseInstruction(
		const MachineInstr* currentInstr, AnaDom& ad) const
{
	// Directives before the instruction
	if (directiveHeuristicsPass->hasDirectiveBeforeInstr(currentInstr)) {
		ad.updateContexts(directiveHeuristicsPass->getDirectiveBeforeInstr(currentInstr));
	}
	
	// We don't have a call
	if (!currentInstr->isCall()) {
		// Abstract transfer function
		ad.transfer(currentInstr, this->depAnalysisResults);
	} else {
		// Call handling (also if call is unreachable)
		auto& cg = CallGraph::getGraph();
		
		AnaDom preCallInfo(ad);
		// Unreachable calls
		if (preCallInfo.isBottom())
		{
			ad = AnaDom(AnaDomInit::BOTTOM);
		} 
		else if (cg.callsExternal(currentInstr))
		{
			AnaDom notneeded(AnaDomInit::BOTTOM); // Discarded anyway
			// Do a transfer call with external function.
			// The out out-information from external callee is ignored,
			// as well as the callee in-information.
			ad.transferCall(currentInstr, this->depAnalysisResults,
														nullptr, notneeded, notneeded);
		}
		else
		{
			// Only analyzable calls
			// Set current analysis information to bottom
			ad = AnaDom(AnaDomInit::BOTTOM);
			// For each potential callee do
			for (auto callee : cg.getPotentialCallees(currentInstr)) {
				AnaDom afterCallInfo(preCallInfo);
				bool changed = afterCallInfo.transferCall(currentInstr, this->depAnalysisResults, callee, 
											anaInfoFunc->find(callee)->second.out, anaInfoFunc->find(callee)->second.in);
				assert (!changed && "Nothing should change during analysis information lookup");
				ad.join(afterCallInfo);
			}
		}
	}

	// Directives after the instruction
	if (directiveHeuristicsPass->hasDirectiveAfterInstr(currentInstr)) {
		ad.updateContexts(directiveHeuristicsPass->getDirectiveAfterInstr(currentInstr));
	}
}

template <class AnaDom>
void AnalysisInformationMemOpt<AnaDom, MachineInstr>::handleBranchInstruction(
		const MachineInstr* branchInstr, AnaDom& ad) const
{
	if (branchInstr->isBranch()) {
		if (branchInstr->isConditionalBranch()) {
			// We stay within this basic block, do according guard
			ad.guard(branchInstr, this->depAnalysisResults, BranchOutcome::nottaken());
		} else {
			assert (branchInstr->isUnconditionalBranch() && "Expected non-conditional branch");
			// unconditional, set unreachable
			ad = AnaDom(AnaDomInit::BOTTOM);
		}
	}
	if (branchInstr->isReturn()) {
		// Nothing is reachable after a (non-predicated) return
		if (isPredicated(branchInstr)) {
			ad.guard(branchInstr, this->depAnalysisResults, BranchOutcome::nottaken());
		} else {
			// Non-predicated return, set unreachable
			ad = AnaDom(AnaDomInit::BOTTOM);
		}
	}
}
#endif

///////////////////////////////////////////////
/// Analysis Information - Caching Strategy ///
///////////////////////////////////////////////

// TODO, cache (around) the latest values looked up. Trade-off between the above
// policies.

} // namespace TimingAnalysisPass

#endif
