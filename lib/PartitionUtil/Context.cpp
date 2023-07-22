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

#include "PartitionUtil/Context.h"
#include "PartitionUtil/Directive.h"

using namespace std;
using namespace llvm;

namespace TimingAnalysisPass {

// Definition of our shared storage
Context::SharedStorage Context::contextStorage;

Context::Context(const std::list<PartitionToken *> &ctx)
    : context(contextStorage.insert(ctx)) {
  // First, get rid of any NONE-Tokens
  std::set<PartitionTokenType> cleartok;
  cleartok.insert(PartitionTokenType::NONE);
  this->clearTokensOlderThan(cleartok, 0);
}

Context::Context() : context(contextStorage.insert(TokListType())) {}

Context::Context(const Context &ctx) { context = ctx.context; }

Context &Context::operator=(const Context &other) {
  context = other.context;
  return *this;
}

void Context::update(const Directive *direc) {
  TokListType toklist(*this->context);
  switch (direc->getType()) {
  // Create directive
  case DirectiveType::CREATE: {
    for (auto token : direc->getPartitionTokens()) {
      switch (token->getType()) {
      case PartitionTokenType::LOOPPEEL: {
        auto tokenPeel = dynamic_cast<PartitionTokenLoopPeel *>(token.get());
        // We want to peel the loop, then the updated context has peel iteration
        // 0 on top
        if (tokenPeel->backedgeTakenCount() == 0) {
          toklist.push_back(tokenPeel);
          this->context = contextStorage.insert(toklist);
          return;
        }
        // We are not iteration 0, continue
        break;
      }
      case PartitionTokenType::LOOPITER: {
        auto tokenIter = dynamic_cast<PartitionTokenLoopIter *>(token.get());
        // We want to consider cumulative contexts for >= 0 taken backedges, put
        // this on top
        if (tokenIter->backedgeLeastTakenCount() == 0) {
          toklist.push_back(tokenIter);
          this->context = contextStorage.insert(toklist);
          return;
        }
        // We are not iteration 0, continue
        break;
      }
      case PartitionTokenType::CALLSITE:
      case PartitionTokenType::FUNCALLEE: {
        // These should be single token directives, put them on top
        toklist.push_back(token.get());
        this->context = contextStorage.insert(toklist);
        return;
      }
      case PartitionTokenType::IF:
      case PartitionTokenType::NONE:
        assert(0 && "Unsupported directive found (IF or NONE)");
      }
    }
    break;
  }
  case DirectiveType::MERGE: {
    assert(toklist.size() > 0 &&
           "We found a merge directive for an empty context");
    // Our topmost token should get merged
    auto labelsToMerge = direc->getPartitionTokens();
    for (auto &label : labelsToMerge) {
      if (label.get() == toklist.back()) {
        toklist.pop_back();
        this->context = contextStorage.insert(toklist);
        return;
      }
    }
    break;
  }
  }
}

void Context::transfer(MBBedge edge) {
  if (!this->context->empty()) {
    auto topMost = this->context->back();
    if (topMost->getType() == PartitionTokenType::LOOPPEEL) {
      auto topMostPeel = dynamic_cast<PartitionTokenLoopPeel *>(topMost);
      auto backedges = topMostPeel->getBackedges();
      if (backedges.count(edge) > 0) {
        // We have to update, as we have a loop peeling token topMost whose
        // backedge is taken
        TokListType toklist(*this->context);
        toklist.pop_back();
        unsigned iteration = topMostPeel->backedgeTakenCount();
        Directive *direc = topMostPeel->getEnclosingDirective();
        for (auto token : direc->getPartitionTokens()) {
          if (token->getType() == PartitionTokenType::LOOPPEEL) {
            auto peelToken =
                dynamic_cast<PartitionTokenLoopPeel *>(token.get());
            if (peelToken->backedgeTakenCount() == (iteration + 1)) {
              toklist.push_back(peelToken);
              this->context = contextStorage.insert(toklist);
              return;
            }
          }
          if (token->getType() == PartitionTokenType::LOOPITER) {
            auto iterToken =
                dynamic_cast<PartitionTokenLoopIter *>(token.get());
            if (iterToken->backedgeLeastTakenCount() == (iteration + 1)) {
              toklist.push_back(iterToken);
              this->context = contextStorage.insert(toklist);
              return;
            }
          }
        }
        assert(0 &&
               "Could not find the successor context for loop peeling token");
      }
    }
  }
}

void Context::reduceOnCall() {
  unsigned maxSize = 0;
  std::set<PartitionTokenType> tok;
  // Clear all IF and NONE tokens from context
  tok.insert(PartitionTokenType::IF);
  tok.insert(PartitionTokenType::NONE);
  this->clearTokensOlderThan(tok, 0);
  tok.clear();
  // Throw away old loop tokens, if not unlimited
  if (NumberLoopTokens >= 0) {
    tok.insert(PartitionTokenType::LOOPPEEL);
    tok.insert(PartitionTokenType::LOOPITER);
    this->clearTokensOlderThan(tok, NumberLoopTokens);
    tok.clear();
    maxSize += NumberLoopTokens;
  }
  // Throw away old funcallee tokens, if not unlimited
  if (NumberCalleeTokens >= 0) {
    tok.insert(PartitionTokenType::FUNCALLEE);
    this->clearTokensOlderThan(tok, NumberCalleeTokens);
    tok.clear();
    maxSize += NumberCalleeTokens;
  }
  // Throw away old callsite tokens
  if (NumberCallsiteTokens >= 0) {
    tok.insert(PartitionTokenType::CALLSITE);
    this->clearTokensOlderThan(tok, NumberCallsiteTokens);
    tok.clear();
    maxSize += NumberCallsiteTokens;
  }
  // TODO if wanted later: Shrink to overall total size
  // this->shrinkTo(0);
  assert((NumberLoopTokens < 0 || NumberCalleeTokens < 0 ||
          NumberCallsiteTokens < 0 || this->context->size() <= maxSize) &&
         "Reduced context should be small enough");
}

void Context::cleanToFunCall() {
  TokListType newcontext;
  bool doneRemoving = false;
  for (auto it = context->rbegin(); it != context->rend(); ++it) {
    auto type = (*it)->getType();
    if (doneRemoving) {
      newcontext.push_front(*it);
    } else if (type == PartitionTokenType::IF ||
               type == PartitionTokenType::NONE ||
               type == PartitionTokenType::LOOPPEEL ||
               type == PartitionTokenType::LOOPITER) {
      continue;
    } else {
      // Set the doneRemoving flag.
      // Do not forget to push this token to the context. Else, one token
      // will be missing
      newcontext.push_front(*it);
      doneRemoving = true;
    }
  }
  this->context = contextStorage.insert(newcontext);
}

void Context::clearTokensOlderThan(std::set<PartitionTokenType> tok,
                                   unsigned length) {
  TokListType newcontext;
  unsigned found = 0;
  for (auto it = context->rbegin(); it != context->rend(); ++it) {
    if (tok.count((*it)->getType()) == 0 || found < length) {
      newcontext.push_front(*it);
    }
    if (tok.count((*it)->getType()) > 0) {
      ++found;
    }
  }
  this->context = contextStorage.insert(newcontext);
}

void Context::shrinkTo(unsigned size) {
  TokListType newcontext;
  unsigned count = 0;
  for (auto it = context->rbegin(); it != context->rend(); ++it) {
    if (count < size) {
      newcontext.push_front(*it);
      ++count;
    }
  }
  this->context = contextStorage.insert(newcontext);
}

const std::list<PartitionToken *> &Context::getTokenList() const {
  return *this->context;
}

bool Context::isEmpty() const { return (context->size() == 0); }

bool Context::operator==(const Context &ctx) const {
  if (this->context->size() != ctx.context->size())
    return false;
  auto it_this = this->context->begin();
  auto it_ctx = ctx.context->begin();
  for (; it_this != this->context->end(); ++it_this, ++it_ctx) {
    assert((*it_this)->getType() != PartitionTokenType::NONE &&
           "Should not see any NONE token in a context");
    if (!(*it_this)->equals(**it_ctx))
      return false;
  }
  return true;
}

bool ctxcomp::operator()(const Context &lhs, const Context &rhs) const {
  if (lhs.getTokenList().size() != rhs.getTokenList().size()) {
    return lhs.getTokenList().size() < rhs.getTokenList().size();
  }
  const auto &lhscontext = lhs.getTokenList();
  const auto &rhscontext = rhs.getTokenList();
  auto it_lhs = lhscontext.begin();
  auto it_rhs = rhscontext.begin();
  for (; it_lhs != lhscontext.end(); ++it_lhs, ++it_rhs) {
    if (!(*it_lhs)->equals(**it_rhs)) {
      return (*it_lhs)->less(**it_rhs);
    }
  }
  return false;
}

std::ostream &operator<<(std::ostream &stream, const Context &ctx) {
  stream << "[";
  unsigned i = 0;
  for (auto it = ctx.context->begin(); it != ctx.context->end(); ++it, ++i) {
    stream << i << ": " << **it;
    if (std::distance(it, ctx.context->end()) > 1)
      stream << "\n    ";
  }
  stream << "]";
  return stream;
}

std::string Context::serialize() const {
  std::stringstream ss;
  for (auto it = this->context->begin(); it != this->context->end(); ++it) {
    ss << (*it)->serialize();
  }
  return ss.str();
}

} // namespace TimingAnalysisPass
