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

#include "Util/Vertex.h"

#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"

#include <sstream>

using namespace llvm;

namespace TimingAnalysisPass {

Vertex::Vertex(unsigned newId) : id(newId), successors(), predecessors() {}

Vertex::Vertex(const Vertex &vt)
    : id(vt.id), successors(vt.successors), predecessors(vt.predecessors) {
  DEBUG_WITH_TYPE("ilp",
                  dbgs() << "copy constructor for vertex " << vt.id << "\n");
}

Vertex::~Vertex() {}

bool Vertex::operator<(const Vertex &vt) const { return this->id < vt.id; }

unsigned Vertex::getId() const { return id; }

const std::set<unsigned> Vertex::getPredecessors() const {
  return predecessors;
}

const std::set<unsigned> Vertex::getSuccessors() const { return successors; }

void Vertex::addSuccessor(unsigned succId) { successors.insert(succId); }

void Vertex::addPredecessor(unsigned predId) { predecessors.insert(predId); }

bool Vertex::deleteSuccessor(unsigned succId) {
  if (successors.count(succId) > 0) {
    successors.erase(succId);
    return true;
  }
  return false;
}

bool Vertex::deletePredecessor(unsigned predId) {
  if (predecessors.count(predId) > 0) {
    predecessors.erase(predId);
    return true;
  }
  return false;
}

bool Vertex::isPredecessor(unsigned predId) const {
  return predecessors.count(predId) > 0;
}

bool Vertex::isSuccessor(unsigned succId) const {
  return successors.count(succId) > 0;
}

bool Vertex::isFree() const {
  return predecessors.size() == 0 && successors.size() == 0;
}

std::string Vertex::getVertexDescr() const {
  std::stringstream ss;
  ss << "Vertex " << id << "\n";
  ss << "Predecessors: { ";
  for (auto it = predecessors.begin(); it != predecessors.end(); ++it) {
    ss << *it;
    if (std::distance(it, predecessors.end()) > 1) {
      ss << ", ";
    }
  }
  ss << "}\n";
  ss << "Successors: { ";
  for (auto it = successors.begin(); it != successors.end(); ++it) {
    ss << *it;
    if (std::distance(it, successors.end()) > 1) {
      ss << ", ";
    }
  }
  ss << "} \n";
  return ss.str();
}

std::ostream &operator<<(std::ostream &stream, Vertex vt) {
  stream << vt.getVertexDescr();
  return stream;
}

} // namespace TimingAnalysisPass
