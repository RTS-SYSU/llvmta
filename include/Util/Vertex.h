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

#ifndef VERTEX_H
#define VERTEX_H

#include <iostream>
#include <set>

namespace TimingAnalysisPass {

class Vertex {
public:
  explicit Vertex(unsigned newId);

  Vertex(const Vertex &vt);

  ~Vertex();

  bool operator<(const Vertex &vt) const;

  unsigned getId() const;

  const std::set<unsigned> getPredecessors() const;

  const std::set<unsigned> getSuccessors() const;

  void addSuccessor(unsigned succId);

  void addPredecessor(unsigned predId);

  bool deleteSuccessor(unsigned succId);

  bool deletePredecessor(unsigned predId);

  bool isPredecessor(unsigned predId) const;

  bool isSuccessor(unsigned succId) const;

  bool isFree() const;

  std::string getVertexDescr() const;

  friend std::ostream &operator<<(std::ostream &stream, Vertex vt);

private:
  /**
   * Stores the id of this vertex.
   */
  unsigned id;

  /**
   * Stores all ids of succeeding vertices.
   */
  std::set<unsigned> successors;

  /**
   * Stores all ids of preceding vertices.
   */
  std::set<unsigned> predecessors;
};

} // namespace TimingAnalysisPass

#endif
