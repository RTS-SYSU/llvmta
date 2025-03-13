////////////////////////////////////////////////////////////////////////////////
//
//   LLVMTA - Timing Analyser performing worst-case execution time analysis
//     using the LLVM backend intermediate representation
//
// Copyright (C) 2013-2022  Saarland University
// Copyright (C) 2022 Claus Faymonville
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

#ifndef GRAPH_H
#define GRAPH_H

#include "Util/Vertex.h"

#include <iostream>
#include <map>

namespace TimingAnalysisPass {

class Graph {

public:
  Graph();

  Graph(Graph &g2);

  ~Graph();

  unsigned addVertex();

  /**
   * Adds an edge to the graph from the vertex with id start to the vertex with
   * id end.
   */
  void addEdge(unsigned fromVertex, unsigned toVertex);

  void removeVertex(unsigned vertex);

  /**
   * Removes the edge from the vertex with id fromVertex to the vertex with id
   * toVertex from the graph.
   */
  void removeEdge(unsigned fromVertex, unsigned toVertex);

  const std::set<unsigned> getPredecessors(unsigned vertexId) const;

  const std::set<unsigned> getSuccessors(unsigned vertexId) const;

  const std::map<unsigned, Vertex> &getVertices() const;

  bool isFree(unsigned vertex) const;

  bool hasEdge(unsigned fromVertex, unsigned toVertex) const;

  void dump() const;

  friend std::ostream &operator<<(std::ostream &stream, Graph graph);

private:
  /**
   * A counter to give unique identifiers to each vertex.
   */
  unsigned nextVertexId;

  /**
   * The set vertices in the graph.
   * Edges are also contained in this set, each edge has two entries,
   * 	one in the preceding, one in the succeeding vertex.
   */
  std::map<unsigned, Vertex> vertices;
};

} // namespace TimingAnalysisPass

#endif
