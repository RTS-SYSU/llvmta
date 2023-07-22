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

#include "Util/PersistenceScope.h"

#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_os_ostream.h"

using namespace llvm;

namespace TimingAnalysisPass {

unsigned PersistenceScope::globalScopeId = 0;

PersistenceScope::PersistenceScope(const llvm::MachineLoop *loop)
    : scopeId(globalScopeId++), loop(loop) {}

PersistenceScope::PersistenceScope(const PersistenceScope &scope)
    : scopeId(scope.scopeId), loop(scope.loop) {}

unsigned PersistenceScope::getId() const { return this->scopeId; }

std::list<const llvm::MachineBasicBlock *>
PersistenceScope::getEntryBasicBlocks() const {
  std::list<const MachineBasicBlock *> result;
  result.push_back(loop->getHeader());
  return result;
}

bool PersistenceScope::containsBasicBlock(
    const llvm::MachineBasicBlock *mbb) const {
  return loop->contains(mbb);
}

bool PersistenceScope::operator<(const PersistenceScope &scope) const {
  return this->scopeId < scope.scopeId;
}

bool PersistenceScope::operator==(const PersistenceScope &scope) const {
  return this->scopeId == scope.scopeId;
}

std::ostream &operator<<(std::ostream &stream, const PersistenceScope &scope) {
  raw_os_ostream llvmstream(stream);
  llvmstream << scope;
  llvmstream.flush();
  return stream;
}

llvm::raw_ostream &operator<<(llvm::raw_ostream &stream,
                              const PersistenceScope &scope) {
  stream << scope.scopeId << " in function "
         << scope.loop->getHeader()->getParent()->getName() << ": "
         << *scope.loop;
  return stream;
}

} // namespace TimingAnalysisPass
