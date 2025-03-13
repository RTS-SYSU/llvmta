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

#ifndef DIRECTIVE_H
#define DIRECTIVE_H

// LLVM Headers
#include "ARM.h"
// Standard Headers
#include <iostream>
#include <set>
// Timing Analyser Header
#include "PartitionUtil/PartitionToken.h"

namespace TimingAnalysisPass {

/**
 * Enum describing the possible activities described by a directive
 */
enum DirectiveType {
  CREATE, ///< Create new partitions
  MERGE   ///< Merge existing partitions
};

/**
 * Class describing a partition directive.
 * These are operations that are associated at specific program points and state
 * what is done (create or merge) on which partitions (described by a set of
 * partition tokens).
 */
class Directive {
private:
  ///< The type of this directive
  DirectiveType direcType;
  ///< The set of tokens to do the operation @{direcType} for
  std::set<std::shared_ptr<PartitionToken>> partitions;

public:
  ///< The constructor
  Directive(DirectiveType dt, std::set<std::shared_ptr<PartitionToken>> p);
  Directive(const Directive &) = delete;
  void operator=(const Directive &) = delete;

  /**
   * Returns the type of this directive (either ::CREATE or ::MERGE)
   */
  DirectiveType getType() const;
  /**
   * Returns a reference on the set of partition tokens
   */
  const std::set<std::shared_ptr<PartitionToken>> &getPartitionTokens() const;
  ///< Output operation
  friend std::ostream &operator<<(std::ostream &stream, const Directive &d);
};

} // namespace TimingAnalysisPass

#endif
