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

#ifndef PERSISTENCESCOPE_H
#define PERSISTENCESCOPE_H

#include "ARM.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineLoopInfo.h"

#include <list>

namespace TimingAnalysisPass {

/**
 * Class representing a persistence scope.
 * Scopes are internally numerated uniquely and wrap the actual scope.
 */
class PersistenceScope {
public:
  explicit PersistenceScope(const llvm::MachineLoop *loop);
  PersistenceScope(const PersistenceScope &scope);

  unsigned getId() const;

  /**
   * Returns the set of basic blocks that are within the scope but have incoming
   * edges from outside the scope.
   */
  std::list<const llvm::MachineBasicBlock *> getEntryBasicBlocks() const;

  /**
   * Checks whether the given basic block mbb is part of this scope.
   */
  bool containsBasicBlock(const llvm::MachineBasicBlock *mbb) const;

  bool operator<(const PersistenceScope &scope) const;
  bool operator==(const PersistenceScope &scope) const;

  friend std::ostream &operator<<(std::ostream &stream,
                                  const PersistenceScope &scope);
  friend llvm::raw_ostream &operator<<(llvm::raw_ostream &stream,
                                       const PersistenceScope &scope);

private:
  static unsigned globalScopeId;

  unsigned scopeId;
  const llvm::MachineLoop *loop;
};

} // namespace TimingAnalysisPass

#endif
