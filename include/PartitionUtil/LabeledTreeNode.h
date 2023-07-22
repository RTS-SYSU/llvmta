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

#ifndef LABELEDTREENODE_H
#define LABELEDTREENODE_H

#include "PartitionUtil/LabeledTree.h"

#include <map>
#include <sstream>

namespace TimingAnalysisPass {

/**
 * Class implementing an internal node of a labeled tree.
 * It has a list of children subtrees. Each edge to a child tree is labeled.
 * The labeling has to be unique, i.e. for a given label there is only one
 * subtree.
 */
template <typename LabelType, typename LeafType>
class LabeledTreeNode : public LabeledTree<LabelType, LeafType> {
public:
  /// To keep it short
  typedef LabeledTree<LabelType, LeafType> Tree;

  /**
   * Creates an internal node without children and no parent set.
   * The parent link is set automatically when added to a larger tree.
   */
  LabeledTreeNode() {}

  LabeledTreeNode(const LabeledTreeNode &other) {
    for (auto lt : other.lab2tree) {
      Tree *subtree = lt.second->clone();
      this->lab2tree[lt.first] = subtree;
      this->tree2lab[subtree] = lt.first;
    }
  }
  LabeledTreeNode &operator=(const LabeledTreeNode &other) {
    for (auto lt : this->lab2tree) {
      delete lt.second;
    }

    for (auto lt : other.lab2tree) {
      Tree *subtree = lt.second->clone();
      this->lab2tree[lt.first] = subtree;
      this->tree2lab[subtree] = lt.first;
    }
  }
  /**
   * Virtual destructor
   */
  virtual ~LabeledTreeNode() {
    // release subtrees
    for (auto it = lab2tree.begin(); it != lab2tree.end(); ++it) {
      delete it->second;
    }
    // maps itself are automatically freed
  }

  // see superclass
  Tree *clone() const {
    Node *res = new LabeledTreeNode();
    for (auto it = lab2tree.begin(); it != lab2tree.end(); ++it) {
      res->addChild(it->first, it->second->clone());
    }
    return res;
  }

  // see superclass
  bool equals(const Tree *t) const {
    if (const Node *node = dynamic_cast<const Node *>(t)) {
      // For each own label, same subtree in node?
      for (auto it = lab2tree.begin(); it != lab2tree.end(); ++it) {
        if (node->lab2tree.count(it->first) == 0)
          return false;
        if (!it->second->equals(node->lab2tree.find(it->first)->second))
          return false;
      }
      // For each label in node, same subtree in our map?
      for (auto it = node->lab2tree.begin(); it != node->lab2tree.end(); ++it) {
        if (lab2tree.count(it->first) == 0)
          return false;
        if (!it->second->equals(lab2tree.find(it->first)->second))
          return false;
      }
      // No conflicts found, must be identical
      return true;
    }
    return false;
  }

  // see superclass
  Tree *walk(std::function<Tree *(Tree *)> action) {
    for (auto &child : lab2tree) {
      auto const tr = child.second;
      auto const res = tr->walk(action);
      // Should child tree be replaced, if so, change for this label
      if (res != tr) {
        child.second = res;
        tree2lab.erase(tr);
        tree2lab.insert(std::make_pair(res, child.first));
        res->setParent(this);
        delete tr;
      }
    }
    // Apply action to this tree, maybe this will be replaced
    Tree *restree = action(this);
    if (restree != this && this->parent == nullptr) {
      // we do not need ourself any more as we get replaced and no upper node
      // remembers us
      delete this;
    }
    return restree;
  }

  // see superclass
  std::string print(unsigned ident) const {
    std::stringstream ss;
    for (unsigned i = 0; i < ident; ++i) {
      ss << "  ";
    }
    ss << "[\n";
    for (auto it = lab2tree.begin(); it != lab2tree.end(); ++it) {
      for (unsigned i = 0; i < ident; ++i) {
        ss << "  ";
      }
      ss << " " << *(it->first) << " |->\n";
      ss << it->second->print(ident + 1) << "\n";
      if (std::distance(it, lab2tree.end()) > 1) {
        ss << "\n";
      }
    }
    for (unsigned i = 0; i < ident; ++i) {
      ss << "  ";
    }
    ss << "]";
    return ss.str();
  }

  /**
   * Adds a new child tree to this node. The corresponding edge should be
   * labeled by lab. The parent link of the child is set appropriately.
   */
  void addChild(LabelType *lab, Tree *tr) {
    assert(tree2lab.count(tr) == 0 && "Multiple times, same subtree");
    assert(lab2tree.count(lab) == 0 && "Multiple children for one label");
    tr->setParent(this);
    tree2lab.insert(std::make_pair(tr, lab));
    lab2tree.insert(std::make_pair(lab, tr));
  }

  /**
   * Removes the given tree tr if any. (Checked by getLabel)
   * The subtree will be freed in memory.
   */
  void removeChild(Tree *tr) {
    LabelType *lab = getLabel(tr);
    tree2lab.erase(tr);
    lab2tree.erase(lab);
    // We do not need this subtree anymore
    delete tr;
  }

  /**
   * Get child by label
   */
  Tree *getChild(LabelType *lab) { return lab2tree[lab]; }

  /**
   * Get child with equal label
   */
  Tree *getChildWithEqualLabel(LabelType *lab) {
    for (auto ele : lab2tree) {
      if (ele.first->equals(*lab)) {
        return ele.second;
      }
    }
    return nullptr;
  }

  /**
   * Get Label of a subtree
   */
  LabelType *getLabel(const Tree *tr) {
    assert(tree2lab.count(tr) > 0 && "No Label for non-existing subtrees");
    return tree2lab[tr];
  }

  /**
   * Returns a list of all labels that this node has children for
   */
  std::set<LabelType *> getLabels() {
    std::set<LabelType *> res;
    for (auto ele : lab2tree) {
      res.insert(ele.first);
    }
    return res;
  }

  /**
   * Returns a list of children
   */
  std::list<Tree *> getChildren() {
    std::list<Tree *> res;
    for (auto ele : lab2tree) {
      res.push_back(ele.second);
    }
    return res;
  }

private:
  /// Keep the map used for output in a nice order
  struct labelcomp {
    bool operator()(const LabelType *const lhs,
                    const LabelType *const rhs) const {
      return lhs->less(*rhs);
    }
  };
  /**
   * Mapping edge labels to corresponding subtrees.
   */
  std::map<const Tree *, LabelType *> tree2lab;
  std::map<LabelType *, Tree *, labelcomp> lab2tree;

  typedef LabeledTreeLeaf<LabelType, LeafType> Leaf;
  typedef LabeledTreeNode<LabelType, LeafType> Node;
};

} // namespace TimingAnalysisPass

#endif
