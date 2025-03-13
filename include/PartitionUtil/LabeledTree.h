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

#ifndef LABELEDTREE_H
#define LABELEDTREE_H

#include <functional>
#include <list>
#include <set>

namespace TimingAnalysisPass {

// Forward declaration
template <typename LabelType, typename LeafType> class LabeledTreeNode;
// Forward declaration
template <typename LabelType, typename LeafType> class LabeledTreeLeaf;

/**
 * Abstract class describing a labeled tree datastructure.
 * Leaves of the tree hold data of type LeafType.
 * Edges between tree nodes are labeled mit labels of type LabelType.
 */
template <typename LabelType, typename LeafType> class LabeledTree {
public:
  /**
   * Virtual destructor
   */
  virtual ~LabeledTree() { /* Nothing to do*/
  }

  /**
   * Factory function. Creates a tree with one path, labels, with leaf at the
   * end.
   */
  static LabeledTree *makeLabeledTree(const std::list<LabelType *> &labels,
                                      LeafType &leaf) {
    LabeledTree *res = new LabeledTreeLeaf<LabelType, LeafType>(leaf);
    for (auto it = labels.rbegin(); it != labels.rend(); ++it) {
      auto tmp = new LabeledTreeNode<LabelType, LeafType>();
      tmp->addChild(*it, res);
      res = tmp;
    }
    return res;
  }

  /**
   * Virtual copy constructor. Creates an identical copy and returns a pointer
   * to the new copy.
   */
  virtual LabeledTree *clone() const = 0;
  /**
   * Check for equality, i.e. same tree structure, same values at leaves.
   */
  virtual bool equals(const LabeledTree *t) const = 0;

  /**
   * Call the function action on this node.
   * Action returns a pointer to the subtree about to replace this node.
   * If action(t) = t, the tree was not changed, otherwise exchange t by
   * action(t).
   */
  virtual LabeledTree *
  walk(std::function<LabeledTree *(LabeledTree *)> action) = 0;

  /**
   * Return true if this tree is a leaf.
   */
  virtual bool isLeaf() const { return false; }

  /**
   * Pretty-Prints the tree representation.
   */
  virtual std::string print(unsigned ident) const = 0;
  // Simple Wrapper for ident argument...
  std::string print() const { return print(0); }
  /**
   * Each node has a link to its parent node (if any, root has parent nullptr).
   * This function sets the parent link to the given tree node.
   */
  void setParent(LabeledTreeNode<LabelType, LeafType> *p) { parent = p; }
  /**
   * This function gets the parent link to the given tree node.
   */
  LabeledTreeNode<LabelType, LeafType> *getParent() { return parent; }
  /**
   * Collects all labels found on the path from this tree node/leaf to the root.
   * The order is: First labels near the root, last labels near this node/leaf.
   */
  std::list<LabelType *> getPathFromRoot() const {
    std::list<LabelType *> res;
    LabeledTreeNode<LabelType, LeafType> *currentParent = this->parent;
    const LabeledTree *currentNode = this;
    while (currentParent != nullptr) {
      res.push_front(currentParent->getLabel(currentNode));
      currentNode = currentParent;
      currentParent = currentParent->getParent();
    }
    return res;
  }

protected:
  /**
   * Parent link. Each (sub)tree has a parent. If not, its the root of the tree.
   */
  LabeledTreeNode<LabelType, LeafType> *parent = nullptr;
};

} // namespace TimingAnalysisPass

#endif
