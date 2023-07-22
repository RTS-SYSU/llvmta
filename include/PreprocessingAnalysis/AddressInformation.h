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

#ifndef ADDRESSINFORMATION_H
#define ADDRESSINFORMATION_H

#include "AnalysisFramework/AnalysisResults.h"
#include "AnalysisFramework/ContextAwareAnalysisDomain.h"
#include "LLVMPasses/MachineFunctionCollector.h"
#include "LLVMPasses/StaticAddressProvider.h"
#include "LLVMPasses/TimingAnalysisMain.h"
#include "PreprocessingAnalysis/ConstantValueDomain.h"
#include "Util/AbstractAddress.h"

#include "ARM.h"
#include "ARMMachineFunctionInfo.h"
#include "ARMTargetMachine.h"

#include "RISCV.h"

#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_os_ostream.h"

#include <boost/numeric/interval.hpp>

#include <tuple>
#include <unordered_set>

namespace TimingAnalysisPass {

/**
 * Class representing the interface for address information.
 * Provides access to the addresses of instructions as well as to the data
 * addresses accessed by given instruction.
 */
class AddressInformation {
public:
  /**
   * Return the address of the instruction that is statically known exactly.
   */
  Address getInstructionAddress(const MachineInstr *MI) const {
    return StaticAddrProvider->getAddr(MI);
  }

  /**
   * Helper function for getNumOfDataAccesses.
   */
  template <llvm::Triple::ArchType ARCH>
  static unsigned getNumOfDataAccessesIn(const MachineInstr *MI);

  /**
   * How many data memory accesses does the given instruction MI perform?
   */
  static unsigned getNumOfDataAccesses(const MachineInstr *MI);

  /**
   * Which addresses are used by the pos-th access of instruction MI?
   */
  virtual AbstractAddress getDataAccessAddress(const MachineInstr *MI,
                                               Context *currCtx,
                                               unsigned pos = 0) const = 0;

  /**
   * Dump all information we have about addresses.
   */
  void dump(std::ostream &mystream) const;

protected:
  virtual std::unordered_set<Context>
  getAddressContexts(const MachineInstr *MI) const = 0;
};

/**
 * Implement the AddressInformation interface.
 * It takes analysis information of several analyses AnalysisDoms and computes
 * valid and precise data access address intervals.
 * A specialized variant is provided in case AnalysisDoms is solely one
 * analysis.
 */
template <class... AnalysisDoms>
class AddressInformationImpl : public AddressInformation {
public:
  /**
   * Constructor
   */
  AddressInformationImpl(typename AnalysisDoms::AnalysisInfo const &...aai)
      : iaddrinfo(AddressInformationImpl<AnalysisDoms>(aai)...),
        anainfo(aai...) {}

  /**
   * See superclass.
   * Return the data access addresses as computable by the given analyses.
   * It meets the sound address intervals of each analysis to obtain precise
   * results.
   */
  AbstractAddress getDataAccessAddress(const MachineInstr *MI, Context *currCtx,
                                       unsigned pos = 0) const {
    return getDataAccessAddress_helper<
        decltype(iaddrinfo),
        std::tuple_size<decltype(iaddrinfo)>::value>::addr(iaddrinfo, MI,
                                                           currCtx, pos);
  }

protected:
  std::unordered_set<Context> getAddressContexts(const MachineInstr *MI) const {
    std::unordered_set<Context> myset;
    getAddressContexts_helper<
        decltype(anainfo),
        std::tuple_size<decltype(anainfo)>::value>::get(anainfo, MI, myset);
    return myset;
  }

private:
  /**
   * Helper functions to "iterate" over the tuple of analysis information.
   */
  template <typename T_Tuple, size_t size> struct getDataAccessAddress_helper {
    static AbstractAddress addr(const T_Tuple &t, const MachineInstr *MI,
                                Context *ctx, unsigned pos) {
      auto itv1 =
          getDataAccessAddress_helper<T_Tuple, size - 1>::addr(t, MI, ctx, pos);
      auto itv2 = std::get<size - 1>(t).getDataAccessAddress(MI, ctx, pos);
      return boost::numeric::intersect(itv1, itv2);
    }
  };
  template <typename T_Tuple> struct getDataAccessAddress_helper<T_Tuple, 0> {
    static AbstractAddress addr(const T_Tuple &t, const MachineInstr *MI,
                                Context *ctx, unsigned pos) {
      return AbstractAddress::getUnknownAddress();
    }
  };

  /**
   * Helper functions to "iterate" over the tuple of analysis information.
   */
  template <typename T_Tuple, size_t size> struct getAddressContexts_helper {
    static void get(const T_Tuple &t, const MachineInstr *MI,
                    std::unordered_set<Context> &res) {
      getAddressContexts_helper<T_Tuple, size - 1>::get(t, MI, res);
      if (!std::get<size - 1>(t).getAnaInfoBefore(MI).isBottom()) {
        for (auto ctx2ana : std::get<size - 1>(t)
                                .getAnaInfoBefore(MI)
                                .getAnalysisInfoPerContext()) {
          res.insert(ctx2ana.first);
        }
      }
    }
  };
  template <typename T_Tuple> struct getAddressContexts_helper<T_Tuple, 0> {
    static void get(const T_Tuple &t, const MachineInstr *MI,
                    std::unordered_set<Context> &res) {}
  };

  /**
   * The AddressInformation each individual analysis can provide.
   */
  std::tuple<AddressInformationImpl<AnalysisDoms>...> iaddrinfo;
  std::tuple<typename AnalysisDoms::AnalysisInfo const &...> anainfo;
};

/**
 * Specialized variant of AddressInformationImpl for the case of solely one
 * analysis.
 */
template <class AnalysisDom>
class AddressInformationImpl<AnalysisDom> : public AddressInformation {
public:
  typedef typename AnalysisDom::AnalysisInfo AddressAnalysisInfo;

  /**
   * Constructor
   */
  AddressInformationImpl(typename AnalysisDom::AnalysisInfo const &aai)
      : addressAnaInfo(aai) {}

  /**
   * How to obtain address information from a concrete value analysis?
   * This is again realised by specialisation.
   */
  AbstractAddress getDataAccessAddress(const MachineInstr *MI, Context *currCtx,
                                       unsigned pos = 0) const {
    static_assert(!std::is_class<AnalysisDom>::value,
                  "There is no generic getDataAccessAddress that is valid for "
                  "any domain. "
                  "Use specialization for your AnalysisDom to use it as "
                  "AddressInformation.");
    return AbstractAddress((unsigned) 0);
  }

protected:
  std::unordered_set<Context> getAddressContexts(const MachineInstr *MI) const {
    std::unordered_set<Context> myset;
    if (!addressAnaInfo.getAnaInfoBefore(MI).isBottom()) {
      for (auto ctx2ana :
           addressAnaInfo.getAnaInfoBefore(MI).getAnalysisInfoPerContext()) {
        myset.insert(ctx2ana.first);
      }
    }
    return myset;
  }

private:
  /**
   * The analysis result from which we should derive address information
   */
  const AddressAnalysisInfo &addressAnaInfo;
};

template <>
AbstractAddress
AddressInformationImpl<ConstantValueDomain<llvm::Triple::ArchType::arm>>::
    getDataAccessAddress(const MachineInstr *MI, Context *currCtx,
                         unsigned pos) const;
template <>
AbstractAddress
AddressInformationImpl<ConstantValueDomain<llvm::Triple::ArchType::riscv32>>::
    getDataAccessAddress(const MachineInstr *MI, Context *currCtx,
                         unsigned pos) const;

} // namespace TimingAnalysisPass

#endif
