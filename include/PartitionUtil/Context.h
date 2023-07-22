////////////////////////////////////////////////////////////////////////////////
//
//   LLVMTA - Timing Analyser performing worst-case execution time analysis
//     using the LLVM backend intermediate representation
//
// Copyright (C) 2013-2022  Saarland University
// Copyright (C) 2014-2015 Claus Faymonville
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

#ifndef CONTEXT_H
#define CONTEXT_H

#include "PartitionUtil/PartitionToken.h"
#include "Util/Options.h"
#include "Util/SharedStorage.h"
#include "Util/Util.h"

#include "llvm/Support/CommandLine.h"

#include <list>

namespace TimingAnalysisPass {

/**
 * Class representing a context in the partitioning setting.
 * A context is a list of partition tokens.
 */
class Context {
public:
  /**
   * Constructor
   */
  explicit Context(const std::list<PartitionToken *> &ctx);
  /**
   * Constructor: Empty context
   */
  Context();
  /**
   * Copy constructor
   */
  Context(const Context &ctx);
  /**
   * Assignment operator
   */
  Context &operator=(const Context &other);

  /**
   * Update this context in-place according to the directive direc.
   * This will usually add a new partition token on top of this context.
   */
  void update(const Directive *direc);
  /**
   * Update this context on taking the given edge.
   * In case edge is a backedge, this means for topmost loop tokens that they
   * are adjusted, e.g. from iteration i to iteration i + 1, or nothing for
   * cumulative iterations.
   */
  void transfer(MBBedge edge);

  /**
   * Reduce a context by removing all loop related tokens till the top of
   * current function.
   *
   * This will essentially reduce the context to a state that it would be in
   * at the top of the current function.
   */
  void cleanToFunCall();

  /**
   * Reduce this context as it is done on function invocation. This comprises
   * two parts:
   * - Remove non-call tokens
   * - Shrink the resulting string to not exceed a certain length
   */
  void reduceOnCall();

  /**
   * Returns an ordered list of partition token: older tokens first, newer ones
   * later.
   */
  const std::list<PartitionToken *> &getTokenList() const;

  /**
   * Returns whether the TokenList is empty or not
   */
  bool isEmpty() const;

  /**
   * Checks for equality of this context with the given ctx
   */
  bool operator==(const Context &ctx) const;

  /**
   * Output operator
   */
  friend std::ostream &operator<<(std::ostream &stream, const Context &ctx);
  /**
   * Hash operator
   */
  friend std::hash<Context>;
  /**
   * Serialize the context into a single line
   */
  std::string serialize() const;

private:
  /**
   * List of Partition Tokens forms a context.
   */
  typedef std::list<PartitionToken *> TokListType;
  typedef util::SharedStorage<TokListType> SharedStorage;
  typedef typename SharedStorage::SharedPtr SharedPtr;

  /**
   * We have a storage for contexts shared among all context instances.
   */
  static SharedStorage contextStorage;
  /**
   * Pointer to a TokListType is our context.
   */
  SharedPtr context;

  /**
   * Eliminate tokens in this context of type contained in tok that are older
   * than length. At max, length tokens of this sort are kept.
   */
  void clearTokensOlderThan(std::set<PartitionTokenType> tok, unsigned length);

  /**
   * Shrink this context to the given size. At max, context has lenght size
   * afterwards.
   */
  void shrinkTo(unsigned size);
};

struct ctxcomp {
  bool operator()(const Context &lhs, const Context &rhs) const;
};

} // namespace TimingAnalysisPass

/**
 * Hashing functionality for contexts.
 */
namespace std {
template <> struct hash<TimingAnalysisPass::Context> {
  size_t operator()(const TimingAnalysisPass::Context &ctx) const {
    size_t val{0};
    TimingAnalysisPass::hash_combine(val, ctx.context->size());
    for (auto tok : *ctx.context) {
      TimingAnalysisPass::hash_combine(val, *tok);
    }
    return val;
  }
};
} // namespace std

#endif
