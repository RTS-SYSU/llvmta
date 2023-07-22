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

#ifndef PARTITIONINGDOMAIN_H
#define PARTITIONINGDOMAIN_H

#include "ARM.h"

#include "PartitionUtil/Context.h"
#include "PartitionUtil/Directive.h"
#include "PartitionUtil/LabeledTree.h"
#include "PartitionUtil/LabeledTreeLeaf.h"
#include "PartitionUtil/LabeledTreeNode.h"
#include "Util/Util.h"

#include "llvm/Support/Debug.h"

#include <iostream>
#include <unordered_map>

using namespace llvm;

namespace TimingAnalysisPass {

/**
 * Class implementing the partitioning domain.
 * It takes a context-insensitive analysis and makes it context-sensitive by
 * employing trace partitioning.
 *
 * - AnalysisDom is the type of the underlying analysis
 * - Granularity this analysis (i.e. the transfer function) operates on
 */
template <class AnalysisDom, typename Granularity> class PartitioningDomain {
public:
  /**
   * Constructor for an element of this domain.
   * It represents bottom if bottom=true, and top otherwise.
   */
  explicit PartitioningDomain(AnaDomInit init);
  /**
   * Copy constructor. Creates an identical copy of the given
   * partitioning-domain element.
   */
  PartitioningDomain(const PartitioningDomain &pd);
  /**
   * Assignment operator
   */
  PartitioningDomain &operator=(const PartitioningDomain &other) {
    if (this->partitionedAnalysisInfo) {
      delete this->partitionedAnalysisInfo;
    }
    if (other.partitionedAnalysisInfo == nullptr) {
      this->partitionedAnalysisInfo = nullptr;
    } else {
      this->partitionedAnalysisInfo = other.partitionedAnalysisInfo->clone();
    }
    return *this;
  }

  /**
   * Destructor
   */
  ~PartitioningDomain() {
    if (this->partitionedAnalysisInfo) {
      delete this->partitionedAnalysisInfo;
    }
  }

  // Make AnaDeps visible again
  typedef typename AnalysisDom::AnaDeps AnaDeps;

  /**
   * Update the set of contexts that is represented by the tree-like data
   * structure. This means on ::CREATE directives:
   *  - Replace leaves by a 1-high subtree, propagate the analysis information
   * This means on ::MERGE directives:
   *  - Replace corresponding 1-high subtrees by leaves again, join available
   * analysis information.
   */
  void updateContexts(Directive *direc);

  /**
   * Join two partitioned analysis domain elements.
   * Do point-wise merge of our labeled context tree.
   */
  void join(const PartitioningDomain &pd);

  /**
   * Transfer function for partitioned analysis for step g of granularity
   * Granularity. For each dependent analysis for AnalysisDom, information is
   * provided by anaInfo.
   */
  void transfer(const Granularity *g, AnaDeps &anaInfo);

  /**
   * Guard function for partitioned analysis. Guards that branch MI has outcome
   * bo. Do it piece-wise for each leaf in the context-tree.
   */
  void guard(const MachineInstr *MI, AnaDeps &anaInfo, BranchOutcome bo);

  /**
   * Handles call instructions. It calls transferCall for each leaf in the tree.
   * Furthermore it pushes reduced analysis information to calleeIn.
   * The result after calling callee with this information, can be obtained
   * using calleeOut. This is an in-place update. NOTE: In case callee is a
   * nullptr, this is an external call. In this case, calleeOut is ignored and
   * assumed to be top, calleeIn won't be modified.
   */
  bool transferCall(const MachineInstr *callInstr, AnaDeps &anaInfo,
                    const MachineFunction *callee,
                    PartitioningDomain &calleeOut,
                    PartitioningDomain &calleeIn);

  /**
   * Transfer function for entering the basic block mbb.
   */
  void enterBasicBlock(const MachineBasicBlock *mbb);

  /**
   * Transfer function for partitioned analysis for taking edge edge.
   * If we have partition tokens in our context-tree that partition on the count
   * of taking backedges, we have to shift information on these leaves.
   */
  void transferEdge(
      const std::pair<const MachineBasicBlock *, const MachineBasicBlock *>
          edge);

  /**
   * Returns a list of pairs of context (a list of partition tokens) and
   * corresponding analysis information. This is the serialized version of our
   * context tree.
   */
  std::unordered_map<Context, AnalysisDom> getAnalysisInfoPerContext() const;

  /**
   * Adds analysis information ana for the given context ctx into out context
   * tree. Returns true, if something has changed by adding this.
   */
  bool addContext(Context &ctx, AnalysisDom &ana);

  /**
   * Set the analysis information at all _reachable_ (i.e. non-bottom) leaves
   * to elements corresponding to init.
   */
  void setAnalysisInfo(const AnaDomInit info);

  /**
   * Find corresponding analysis information for the given context in the tree.
   */
  AnalysisDom findAnalysisInfo(const Context &ctx) const;
  /**
   * A relaxed variant of findAnalysisInfo as not all contexts are built up,
   * fully. Thus a matching is not always possible. In such cases, bottom is
   * returned.
   */
  AnalysisDom findAnalysisInfoEarly(const Context &ctx) const;

  /**
   * Checks whether this analysis element describe the same information as pd.
   * I.e. same tree structure (with same labels on the edges)
   * and same information (AnalysisDom) at the leaves.
   */
  bool equals(const PartitioningDomain *pd) const;

  /**
   * Returns true, if this analysis information denotes bottom (unreachable).
   */
  bool isBottom() const;

  /**
   * Dump analysis information.
   */
  std::string print() const {
    if (partitionedAnalysisInfo == nullptr) {
      return "bot";
    } else {
      return partitionedAnalysisInfo->print();
    }
  }

private:
  /// typedefs as short notation for context trees
  typedef LabeledTree<PartitionToken, AnalysisDom> ContextTree;
  typedef LabeledTreeLeaf<PartitionToken, AnalysisDom> ContextTreeLeaf;
  typedef LabeledTreeNode<PartitionToken, AnalysisDom> ContextTreeNode;
  /**
   * Partitioned analysis information is represented as labeled trees,
   * where the labels at internal tree nodes are individual PartitionTokens, and
   * the tree leafs hold analysis information for the context it represents.
   * The context of a leaf is the concatenation of all labels from this leaf to
   * the root of the tree. If null, it respresents bottom.
   */
  ContextTree *partitionedAnalysisInfo;
};

template <class AnalysisDom, typename Granularity>
PartitioningDomain<AnalysisDom, Granularity>::PartitioningDomain(
    AnaDomInit init)
    : partitionedAnalysisInfo(nullptr) {
  if (init == AnaDomInit::TOP) { // TOP
    AnalysisDom topElement(AnaDomInit::TOP);
    partitionedAnalysisInfo =
        new LabeledTreeLeaf<PartitionToken, AnalysisDom>(topElement);
  } else if (init == AnaDomInit::START) { // Analysis Start
    AnalysisDom startElement(AnaDomInit::START);
    partitionedAnalysisInfo =
        new LabeledTreeLeaf<PartitionToken, AnalysisDom>(startElement);
  }
  // bottom: nothing to initialize
}

template <class AnalysisDom, typename Granularity>
PartitioningDomain<AnalysisDom, Granularity>::PartitioningDomain(
    const PartitioningDomain &pd)
    : partitionedAnalysisInfo(nullptr) {
  if (pd.partitionedAnalysisInfo != nullptr) {
    partitionedAnalysisInfo = pd.partitionedAnalysisInfo->clone();
  }
}

template <class AnalysisDom, typename Granularity>
void PartitioningDomain<AnalysisDom, Granularity>::updateContexts(
    Directive *direc) {
  if (partitionedAnalysisInfo ==
      nullptr) { // no context updates on bottom elements
    return;
  }
  // Save this tree, then empty it, and build it up again with updated contexts
  auto oldTree = this->partitionedAnalysisInfo;
  this->partitionedAnalysisInfo = nullptr;

  auto const handleDirec = [this, direc](ContextTree *tr) -> ContextTree * {
    if (tr->isLeaf()) {
      // On each leaf, get corresponding context and handle the context update
      ContextTreeLeaf *leaf = dynamic_cast<ContextTreeLeaf *>(tr);
      AnalysisDom anaElement = leaf->getValueCopy();
      auto currPath = tr->getPathFromRoot();
      if (direc->getType() == DirectiveType::CREATE) { // Create Directive
        for (auto token : direc->getPartitionTokens()) {
          currPath.push_back(token.get());
          Context currCtx(currPath);
          currPath.pop_back();
          switch (token->getType()) {
          case PartitionTokenType::LOOPPEEL: {
            auto tokenPeel =
                dynamic_cast<PartitionTokenLoopPeel *>(token.get());
            if (tokenPeel->backedgeTakenCount() == 0) {
              this->addContext(currCtx, anaElement);
            } else {
              AnalysisDom anaBot(AnaDomInit::BOTTOM);
              this->addContext(currCtx, anaBot);
            }
            break;
          }
          case PartitionTokenType::LOOPITER: {
            auto tokenIter =
                dynamic_cast<PartitionTokenLoopIter *>(token.get());
            if (tokenIter->backedgeLeastTakenCount() == 0) {
              this->addContext(currCtx, anaElement);
            } else {
              AnalysisDom anaBot(AnaDomInit::BOTTOM);
              this->addContext(currCtx, anaBot);
            }
            break;
          }
          case PartitionTokenType::CALLSITE:
          case PartitionTokenType::FUNCALLEE: {
            this->addContext(currCtx, anaElement);
            break;
          }
          case PartitionTokenType::IF:
          case PartitionTokenType::NONE:
            assert(0 && "Unsupported directive found (IF or NONE)");
          }
        }
      } else { // Merge Directive
        Context currCtx(currPath);
        currCtx.update(direc);
        this->addContext(currCtx, anaElement);
      }
    }
    return tr;
  };
  // Walk on tree and create/merge partitions, the this->tree is updated
  // accordingly
  oldTree->walk(handleDirec);
  // Finally, we do not need oldTree anymore, so free it
  delete oldTree;
}

template <class AnalysisDom, typename Granularity>
void PartitioningDomain<AnalysisDom, Granularity>::join(
    const PartitioningDomain &pd) {
  // Join with bottom
  if (pd.partitionedAnalysisInfo == nullptr) {
    return;
  }
  // Join of bottom with something
  if (this->partitionedAnalysisInfo == nullptr) {
    partitionedAnalysisInfo = pd.partitionedAnalysisInfo->clone();
    return;
  }
  // Join of two non-empty trees.
  auto const handleJoin = [this](ContextTree *tr) -> ContextTree * {
    if (tr->isLeaf()) {
      // On each leaf, get corresponding context and handle the context update
      ContextTreeLeaf *leaf = dynamic_cast<ContextTreeLeaf *>(tr);
      AnalysisDom anaElement = leaf->getValueCopy();
      Context currCtx(tr->getPathFromRoot());
      // For each leaf in the tree to join, add its context and analysis
      // information to this tree
      this->addContext(currCtx, anaElement);
    }
    return tr;
  };
  pd.partitionedAnalysisInfo->walk(handleJoin);
}

template <class AnalysisDom, typename Granularity>
void PartitioningDomain<AnalysisDom, Granularity>::transfer(
    const Granularity *g, AnaDeps &anaInfo) {
  if (partitionedAnalysisInfo == nullptr) { // bottom
    return;
  }
  // Build a lambda function that should call AnalysisDom::transfer on each Leaf
  // in the tree.
  auto const transferAction = [g, &anaInfo](ContextTree *tr) -> ContextTree * {
    if (!tr->isLeaf())
      return tr;
    ContextTreeLeaf *leaf = dynamic_cast<ContextTreeLeaf *>(tr);
    AnalysisDom &anaElement = leaf->getValue();
    Context ctx(tr->getPathFromRoot());
    anaElement.transfer(g, &ctx, anaInfo);
    return tr;
  };
  // Walk on our contexttree and do analysis transfers (walk should not modify
  // the tree)
  partitionedAnalysisInfo->walk(transferAction);
}

template <class AnalysisDom, typename Granularity>
void PartitioningDomain<AnalysisDom, Granularity>::guard(const MachineInstr *MI,
                                                         AnaDeps &anaInfo,
                                                         BranchOutcome bo) {
  if (partitionedAnalysisInfo == nullptr) { // bottom
    return;
  }
  // Build a lambda function that should call AnalysisDom::guard on each Leaf in
  // the tree.
  auto const guardAction = [MI, &anaInfo,
                            bo](ContextTree *tr) -> ContextTree * {
    if (!tr->isLeaf())
      return tr;
    ContextTreeLeaf *leaf = dynamic_cast<ContextTreeLeaf *>(tr);
    AnalysisDom &anaElement = leaf->getValue();
    Context ctx(tr->getPathFromRoot());
    anaElement.guard(MI, &ctx, anaInfo, bo);
    return tr;
  };
  // Walk on our contexttree and do analysis guards (walk should not modify the
  // tree)
  partitionedAnalysisInfo->walk(guardAction);
}

template <class AnalysisDom, typename Granularity>
bool PartitioningDomain<AnalysisDom, Granularity>::transferCall(
    const MachineInstr *callInstr, AnaDeps &anaInfo,
    const MachineFunction *callee, PartitioningDomain &calleeOut,
    PartitioningDomain &calleeIn) {
  if (partitionedAnalysisInfo == nullptr) { // bottom
    return false;
  }
  bool changed = false;

  // Do the transferCall on each leaf
  auto const transferCallAction = [callInstr, &anaInfo, callee, &calleeOut,
                                   &calleeIn,
                                   &changed](ContextTree *tr) -> ContextTree * {
    if (!tr->isLeaf()) {
      return tr;
    }
    // On each leaf, get corresponding context and handle the call instruction
    ContextTreeLeaf *leaf = dynamic_cast<ContextTreeLeaf *>(tr);
    AnalysisDom &anaElement = leaf->getValue();
    // If this program point in this context is unreachable, we do not do
    // anything
    if (anaElement.isBottom()) {
      return tr;
    }
    Context ctx(tr->getPathFromRoot());
    Context reducedCtx(ctx);
    reducedCtx.reduceOnCall();

    /* call transferCall:
       - It extracts the correct information from calleeOutInfo to afterCallInfo
                     (doing filtering on return) or is top when calling external
             - It updates anaElement in-place to become relevant calleeIn
       information (doing filtering on call)
     */
    AnalysisDom calleeOutInfo =
        (callee == nullptr) ? AnalysisDom(AnaDomInit::TOP)
                            : calleeOut.findAnalysisInfoEarly(reducedCtx);
    AnalysisDom afterCallInfo = anaElement.transferCall(
        callInstr, &ctx, anaInfo, callee, calleeOutInfo);
    if (callee != nullptr) {
      // The new callein analysis information enters a new basicblock
      const MachineBasicBlock *calleeBeginBB = &*callee->begin();
      assert(calleeBeginBB->getNumber() == 0 &&
             "The first basic block of a function should have number 0");
      anaElement.enterBasicBlock(calleeBeginBB);

      // In non-external cases, add the computed callee-in-info to the calleeIn
      // object
      changed |= calleeIn.addContext(reducedCtx, anaElement);
    }
    // set anaElement to afterCallInfo
    anaElement = afterCallInfo;
    return tr;
  };
  // Walk on contexttree (tree structure is not modified, only leaf values)
  partitionedAnalysisInfo->walk(transferCallAction);

  return changed;
}

template <class AnalysisDom, typename Granularity>
void PartitioningDomain<AnalysisDom, Granularity>::enterBasicBlock(
    const MachineBasicBlock *mbb) {
  if (partitionedAnalysisInfo == nullptr) { // bottom
    return;
  }
  // Build a lambda function that calls AnalysisDom::enterBasicBlock on each
  // leaf in the tree
  auto const enterBasicBlockAction = [mbb](ContextTree *tr) -> ContextTree * {
    if (!tr->isLeaf()) {
      return tr;
    }
    ContextTreeLeaf *leaf = dynamic_cast<ContextTreeLeaf *>(tr);
    AnalysisDom &anaElement = leaf->getValue();
    anaElement.enterBasicBlock(mbb);
    return tr;
  };
  // Walk on contexttree (tree structure not modified)
  partitionedAnalysisInfo->walk(enterBasicBlockAction);
}

template <class AnalysisDom, typename Granularity>
void PartitioningDomain<AnalysisDom, Granularity>::transferEdge(
    const std::pair<const MachineBasicBlock *, const MachineBasicBlock *>
        edge) {
  if (partitionedAnalysisInfo == nullptr) { // bottom
    return;
  }
  // Build lambda function that does the analysis information shifting
  auto const edgeTransferAction = [edge](ContextTree *tr) -> ContextTree * {
    if (tr->isLeaf())
      return tr;
    ContextTreeNode *node = dynamic_cast<ContextTreeNode *>(tr);
    ContextTreeNode *resultnode =
        dynamic_cast<ContextTreeNode *>(node->clone());
    auto labels = resultnode->getLabels();
    for (auto lab : labels) {
      switch (lab->getType()) {
      case PartitionTokenType::LOOPPEEL: {
        auto labPeel = dynamic_cast<PartitionTokenLoopPeel *>(lab);
        if (labPeel->hasBackedge(edge)) {
          auto leaf =
              dynamic_cast<ContextTreeLeaf *>(resultnode->getChild(labPeel));
          assert(leaf && "Only top level loop partitionings allowed here.");
          if (labPeel->backedgeTakenCount() == 0) {
            AnalysisDom botElement(AnaDomInit::BOTTOM);
            leaf->setValue(botElement);
          } else {
            PartitionTokenLoopPeel depLab(labPeel->getLoop(),
                                          labPeel->getBackedges(),
                                          labPeel->backedgeTakenCount() - 1);
            auto depLeaf = dynamic_cast<ContextTreeLeaf *>(
                node->getChildWithEqualLabel(&depLab));
            assert(depLeaf &&
                   "Dependent tree leaf does not exist or is no leaf.");
            leaf->setValue(depLeaf->getValue());
          }
        }
        break;
      }
      case PartitionTokenType::LOOPITER: {
        auto labIter = dynamic_cast<PartitionTokenLoopIter *>(lab);
        if (labIter->hasBackedge(edge)) {
          auto leaf =
              dynamic_cast<ContextTreeLeaf *>(resultnode->getChild(labIter));
          assert(leaf && "Only top level loop partitionings allowed here.");
          AnalysisDom newValue(leaf->getValue());
          if (labIter->backedgeLeastTakenCount() > 0) {
            PartitionTokenLoopPeel depLab(
                labIter->getLoop(), labIter->getBackedges(),
                labIter->backedgeLeastTakenCount() - 1);
            auto depLeaf = dynamic_cast<ContextTreeLeaf *>(
                node->getChildWithEqualLabel(&depLab));
            assert(depLeaf &&
                   "Dependent tree leaf does not exist or is no leaf.");
            newValue.join(depLeaf->getValue());
          }
          leaf->setValue(newValue);
        }
        break;
      }
      default:
        break;
      }
    }
    return resultnode;
  };
  // Walk the above function, a pointer to a new tree might be returned!
  partitionedAnalysisInfo = partitionedAnalysisInfo->walk(edgeTransferAction);
}

template <class AnalysisDom, typename Granularity>
std::unordered_map<Context, AnalysisDom>
PartitioningDomain<AnalysisDom, Granularity>::getAnalysisInfoPerContext()
    const {
  assert(this->partitionedAnalysisInfo != nullptr &&
         "No context->anainfo for unreachable parts");

  std::unordered_map<Context, AnalysisDom> ctx2anadom;

  auto const setAction = [&ctx2anadom](ContextTree *tr) -> ContextTree * {
    if (!tr->isLeaf())
      return tr;
    auto leaf = dynamic_cast<ContextTreeLeaf *>(tr);
    Context ctx(leaf->getPathFromRoot());
    AnalysisDom anaElement = leaf->getValueCopy();
    // This should always be false as no NONE-tokens can be within a tree
    // (within a context)
    assert(ctx2anadom.count(ctx) == 0 &&
           "Saw the same context twice in the tree when gathering information");
    ctx2anadom.insert(std::make_pair(ctx, anaElement));
    return tr;
  };
  // No change in tree
  partitionedAnalysisInfo->walk(setAction);

  return ctx2anadom;
}

template <class AnalysisDom, typename Granularity>
bool PartitioningDomain<AnalysisDom, Granularity>::addContext(
    Context &ctx, AnalysisDom &ana) {
  if (this->partitionedAnalysisInfo == nullptr) { // was bottom until now
    const auto &tmp = ctx.getTokenList();
    this->partitionedAnalysisInfo = ContextTree::makeLabeledTree(tmp, ana);
    return true;
  }
  // Add path to an already existing tree
  auto labels = ctx.getTokenList();
  auto currentTreePosition = this->partitionedAnalysisInfo;
  while (true) {
    if (currentTreePosition->isLeaf()) {
      auto leaf = dynamic_cast<ContextTreeLeaf *>(currentTreePosition);
      if (labels.empty()) { // we are a leaf, and we want to add information
                            // here, do so
        AnalysisDom oldcopy(leaf->getValue());
        leaf->getValue().join(ana);
        // If nothing changed, signal this to outer calling funtions
        return !(oldcopy.lessequal(leaf->getValue()) &&
                 leaf->getValue().lessequal(oldcopy));
      }
      // we are leaf but want to still append something context-sensitivity
      auto res = new ContextTreeNode();
      res->addChild(PartitionTokenNone::getInstance(),
                    currentTreePosition->clone());
      auto label = labels.front();
      labels.pop_front();
      auto subtree = ContextTree::makeLabeledTree(labels, ana);
      res->addChild(label, subtree);
      if (currentTreePosition->getParent() == nullptr) {
        // We are overwriting our current tree, so free the old one
        delete this->partitionedAnalysisInfo;
        this->partitionedAnalysisInfo = res;
      } else {
        auto parent =
            dynamic_cast<ContextTreeNode *>(currentTreePosition->getParent());
        auto label = parent->getLabel(currentTreePosition);
        parent->removeChild(currentTreePosition);
        parent->addChild(label, res);
      }
      break;
    }
    // We see an internal node
    auto internalNode = dynamic_cast<ContextTreeNode *>(currentTreePosition);
    if (labels.empty()) { // Want to join something here, add it to the
                          // NONE-subtree
      auto noneTree = internalNode->getChildWithEqualLabel(
          PartitionTokenNone::getInstance());
      if (noneTree == nullptr) {
        internalNode->addChild(PartitionTokenNone::getInstance(),
                               new ContextTreeLeaf(ana));
      } else {
        auto noneLeaf = dynamic_cast<ContextTreeLeaf *>(noneTree);
        assert(noneLeaf && "Subtree with label NONE should be leaf!");
        AnalysisDom oldnoneleaf(noneLeaf->getValue());
        noneLeaf->getValue().join(ana);
        // If nothing changed, signal this to outer calling funtions
        return !(oldnoneleaf.lessequal(noneLeaf->getValue()) &&
                 noneLeaf->getValue().lessequal(oldnoneleaf));
      }
      break;
    } else {
      // Push it to the subtree with same topmost label, or add new one
      auto topmost = labels.front();
      labels.pop_front();
      auto subtree = internalNode->getChildWithEqualLabel(topmost);
      if (subtree == nullptr) {
        internalNode->addChild(topmost,
                               ContextTree::makeLabeledTree(labels, ana));
        break;
      } else {
        currentTreePosition = subtree;
      }
    }
  }
  return true;
}

template <class AnalysisDom, typename Granularity>
void PartitioningDomain<AnalysisDom, Granularity>::setAnalysisInfo(
    const AnaDomInit info) {
  auto const setAction = [info](ContextTree *tr) -> ContextTree * {
    if (!tr->isLeaf())
      return tr;
    auto leaf = dynamic_cast<ContextTreeLeaf *>(tr);
    if (!leaf->getValue().lessequal(
            AnalysisDom(AnaDomInit::BOTTOM))) { // If reachable, i.e. not bot
      return new ContextTreeLeaf(AnalysisDom(info));
    }
    return tr;
  };
  partitionedAnalysisInfo = partitionedAnalysisInfo->walk(setAction);
}

template <class AnalysisDom, typename Granularity>
AnalysisDom PartitioningDomain<AnalysisDom, Granularity>::findAnalysisInfo(
    const Context &ctx) const {
  // If unreachable, then return the bottom element of AnalysisDom
  if (this->partitionedAnalysisInfo == nullptr) {
    return AnalysisDom(AnaDomInit::BOTTOM);
  }
  auto currentTreePosition = partitionedAnalysisInfo;
  auto tokenList = ctx.getTokenList();
  // Walk down the tree according to the context until a leaf is reached
  while (!currentTreePosition->isLeaf()) {
    auto node = dynamic_cast<ContextTreeNode *>(currentTreePosition);
    // When context is used up, check for NONE-Child
    if (tokenList.size() == 0) {
      auto nonechild =
          node->getChildWithEqualLabel(PartitionTokenNone::getInstance());
      assert(nonechild != nullptr &&
             "Context empty but internal node without none child");
      auto noneleaf = dynamic_cast<ContextTreeLeaf *>(nonechild);
      assert(noneleaf != nullptr && "None child of tree is not a leaf");
      return noneleaf->getValueCopy();
    }
    auto topmost = tokenList.front();
    tokenList.pop_front();
    currentTreePosition = node->getChildWithEqualLabel(topmost);
    // No subtree found for this context, something is wrong
    assert(currentTreePosition != nullptr &&
           "There is no information for the given context!");
  }
  // Return the information found at the leaf
  assert(tokenList.empty() &&
         "Could not find information, leaf but context left");
  auto leaf = dynamic_cast<ContextTreeLeaf *>(currentTreePosition);
  return leaf->getValueCopy();
}

template <class AnalysisDom, typename Granularity>
AnalysisDom PartitioningDomain<AnalysisDom, Granularity>::findAnalysisInfoEarly(
    const Context &ctx) const {
  // If unreachable, then return the bottom element of AnalysisDom
  if (this->partitionedAnalysisInfo == nullptr) {
    return AnalysisDom(AnaDomInit::BOTTOM);
  }
  auto currentTreePosition = partitionedAnalysisInfo;
  auto tokenList = ctx.getTokenList();
  // Walk down the tree according to the context until a leaf is reached
  while (!currentTreePosition->isLeaf()) {
    auto node = dynamic_cast<ContextTreeNode *>(currentTreePosition);
    // When context is used up, check for NONE-Child
    if (tokenList.size() == 0) {
      auto nonechild =
          node->getChildWithEqualLabel(PartitionTokenNone::getInstance());
      assert(nonechild != nullptr &&
             "Context empty but internal node without none child");
      auto noneleaf = dynamic_cast<ContextTreeLeaf *>(nonechild);
      assert(noneleaf != nullptr && "None child of tree is not a leaf");
      return noneleaf->getValueCopy();
    }
    auto topmost = tokenList.front();
    tokenList.pop_front();
    currentTreePosition = node->getChildWithEqualLabel(topmost);
    // No subtree found for this context (as we are just building up contexts
    // during iteration) Thus it is not reachable yet and will get reachable
    // later in during the iteration
    if (currentTreePosition == nullptr) {
      return AnalysisDom(AnaDomInit::BOTTOM);
    }
  }
  // We reached a leaf but are still searching for a non-NONE context
  if (!tokenList.empty()) {
    assert(tokenList.front()->getType() != PartitionTokenType::NONE &&
           "Expected non-NONE token here");
    // Obviously we have not yet visited this context before
    return AnalysisDom(AnaDomInit::BOTTOM);
  }
  // Return the information found at the leaf
  assert(tokenList.empty() &&
         "Could not find information, leaf but context left");
  auto leaf = dynamic_cast<ContextTreeLeaf *>(currentTreePosition);
  return leaf->getValueCopy();
}

template <class AnalysisDom, typename Granularity>
bool PartitioningDomain<AnalysisDom, Granularity>::equals(
    const PartitioningDomain *pd) const {
  // bottom equals bottom
  if (this->partitionedAnalysisInfo == nullptr &&
      pd->partitionedAnalysisInfo == nullptr) {
    return true;
  }
  // bottom != not bottom
  if (this->partitionedAnalysisInfo == nullptr ||
      pd->partitionedAnalysisInfo == nullptr) {
    return false;
  }
  // two non-bottom analysis domain elements
  return this->partitionedAnalysisInfo->equals(pd->partitionedAnalysisInfo);
}

template <class AnalysisDom, typename Granularity>
bool PartitioningDomain<AnalysisDom, Granularity>::isBottom() const {
  return this->partitionedAnalysisInfo == nullptr;
}

} // namespace TimingAnalysisPass

#endif
