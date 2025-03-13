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

#include "Util/Graph.h"

#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

namespace TimingAnalysisPass {

Graph::Graph() : nextVertexId(0), vertices() {}

Graph::Graph(Graph &g2)
    : nextVertexId(g2.nextVertexId), vertices(g2.vertices) {}

Graph::~Graph() {}

unsigned Graph::addVertex() {
  unsigned currId = nextVertexId;
  nextVertexId++;
  assert(nextVertexId > 0 &&
         "We used all vertex ids for the state graph. Unsigned is not enough!");
  Vertex vt(currId);
  vertices.insert(std::make_pair(currId, vt));
  DEBUG_WITH_TYPE("ilp", dbgs() << "Adding vertex with id " << currId << "\n");
  return currId;
}

void Graph::addEdge(unsigned fromVertex, unsigned toVertex) {
  assert(vertices.count(fromVertex) == 1 && vertices.count(toVertex) == 1 &&
         "Tried adding an edge between non-existent vertices.");
  vertices.at(fromVertex).addSuccessor(toVertex);
  vertices.at(toVertex).addPredecessor(fromVertex);
}

void Graph::removeVertex(unsigned vertex) {
  assert(vertices.at(vertex).isFree() &&
         "Tried to remove a vertex which has an edge connected!");
  vertices.erase(vertex);
}

void Graph::removeEdge(unsigned fromVertex, unsigned toVertex) {
  vertices.at(fromVertex).deleteSuccessor(toVertex);
  vertices.at(toVertex).deletePredecessor(fromVertex);
}

const std::set<unsigned> Graph::getPredecessors(unsigned vertexId) const {
  return vertices.at(vertexId).getPredecessors();
}

const std::set<unsigned> Graph::getSuccessors(unsigned vertexId) const {
  return vertices.at(vertexId).getSuccessors();
}

const std::map<unsigned, Vertex> &Graph::getVertices() const {
  return vertices;
}

bool Graph::isFree(unsigned vertex) const {
  return vertices.at(vertex).isFree();
}

bool Graph::hasEdge(unsigned fromVertex, unsigned toVertex) const {
  return vertices.at(fromVertex).isSuccessor(toVertex);
}

void Graph::dump() const {
  for (const auto &vt : vertices) {
    errs() << vt.second.getVertexDescr();
  }
}

std::ostream &operator<<(std::ostream &stream, Graph graph) {
  for (const auto &vt : graph.getVertices()) {
    stream << vt.second;
  }
  return stream;
}

} // namespace TimingAnalysisPass
