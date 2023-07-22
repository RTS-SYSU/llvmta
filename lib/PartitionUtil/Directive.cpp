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

#include "PartitionUtil/Directive.h"

#include <iterator>

using namespace llvm;

namespace TimingAnalysisPass {

Directive::Directive(DirectiveType dt,
                     std::set<std::shared_ptr<PartitionToken>> p)
    : direcType(dt), partitions(p) {
  // Set enclosing directive for all partitiontokens
  for (auto tok : p) {
    tok->setEnclosingDirective(this);
  }
  // TODO do a real check which token combinations are allowed...
  if (p.size() > 1) {
    std::set<PartitionTokenType> types;
    for (auto tok : p) {
      types.insert(tok->getType());
    }
    // Loop tokens only valid with other loop tokens
    if (types.count(PartitionTokenType::LOOPPEEL) > 0 ||
        types.count(PartitionTokenType::LOOPITER) > 0) {
      types.erase(PartitionTokenType::LOOPPEEL);
      types.erase(PartitionTokenType::LOOPITER);
      assert(types.size() == 0 &&
             "Loop tokens mixed with other tokens in one directive");
    }
  }
}

DirectiveType Directive::getType() const { return direcType; }

const std::set<std::shared_ptr<PartitionToken>> &
Directive::getPartitionTokens() const {
  return partitions;
}

std::ostream &operator<<(std::ostream &stream, const Directive &d) {
  stream << "Directive of Type ";
  switch (d.direcType) {
  case DirectiveType::CREATE:
    stream << "CREATE";
    break;
  case DirectiveType::MERGE:
    stream << "MERGE";
    break;
  }
  stream << " for the following tokens:{\n";
  std::set<std::string> result;
  for (auto part : d.partitions) {
    result.insert(part->print());
  }
  for (auto it = result.begin(); it != result.end(); ++it) {
    stream << "\t" << *it;
    if (std::distance(it, result.end()) > 1) {
      stream << ",\n";
    }
  }
  stream << "}";
  return stream;
}

} // namespace TimingAnalysisPass
