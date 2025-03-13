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

#ifndef LABELEDTREELEAF_H
#define LABELEDTREELEAF_H

#include "PartitionUtil/LabeledTree.h"
#include <sstream>

namespace TimingAnalysisPass {

/**
 * Class implementing a leaf node of the labeled tree datastructure.
 * A leaf holds a data object of type LeafType.
 * A leaf has no children.
 */
template <typename LabelType, typename LeafType>
class LabeledTreeLeaf : public LabeledTree<LabelType, LeafType> {
public:
  /// To keep it short
  typedef LabeledTree<LabelType, LeafType> Tree;

  /**
   * Creates a leaf holding the given value v. No parent is set.
   * The parent link is set automatically when added to a larger tree.
   */
  LabeledTreeLeaf(LeafType v) : value(v) {}

  /**
   * Virtual destructor
   */
  virtual ~LabeledTreeLeaf() {
    // value is destructed automatically
  }

  // see superclass
  Tree *clone() const {
    Tree *res = new LabeledTreeLeaf(this->value);
    return res;
  }

  /**
   * Return a reference to the value
   */
  LeafType &getValue() { return value; }

  /**
   * Returns a copy of the value
   */
  LeafType getValueCopy() const { return value; }

  /**
   * Set the value field to the given one
   */
  void setValue(LeafType v) { value = LeafType(v); }

  // see superclass
  bool equals(const Tree *t) const {
    if (const Leaf *leaf = dynamic_cast<const Leaf *>(t)) {
      return this->value.lessequal(leaf->value) &&
             leaf->value.lessequal(this->value);
    }
    return false;
  }

  // see superclass
  Tree *walk(std::function<Tree *(Tree *)> action) {
    // Apply action to this tree, maybe this will be replaced (new subtree is
    // return value)
    Tree *res = action(this);
    if (res != this && this->parent == nullptr) {
      // we do not need ourself any more as we get replaced and no upper node
      // remembers us
      delete this;
    }
    return res;
  }

  bool isLeaf() const { return true; }

  // see superclass
  std::string print(unsigned ident) const {
    std::stringstream ss;
    for (unsigned i = 0; i < ident; ++i) {
      ss << "  ";
    }
    ss << "Leaf:\n" << value;
    return ss.str();
  }

private:
  /**
   * The data object that this leaf describes.
   */
  LeafType value;

  typedef LabeledTreeLeaf<LabelType, LeafType> Leaf;
  typedef LabeledTreeNode<LabelType, LeafType> Node;
};

} // namespace TimingAnalysisPass

#endif
