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

#ifndef CLASSIFICATION_H_
#define CLASSIFICATION_H_

#include "Memory/util/BitstringDomain.h"
#include "llvm/Support/FileSystem.h" // 输出ur-cfg图片
#include "llvm/Support/raw_ostream.h"

namespace TimingAnalysisPass {

namespace dom {
namespace cache {

class Classification;

extern const char *ClassificationNames[14];
extern const Classification CL_BOT, CL_HIT, CL_MISS, CL_UNKNOWN, CL2_HIT,
    CL2_MISS, CL2_UNKNOWN;

/**
 * \brief Implements the lattice {\c hit, \c miss, \c unknown, \c bottom }.
 */
class Classification : public dom::misc::BitstringDomain<unsigned char> {
  typedef dom::misc::BitstringDomain<unsigned char> Super;
  typedef Classification Self;

public:
  explicit Classification(bool initializeAsBottom = false);
  explicit Classification(unsigned char value);

  friend std::ostream &operator<<(std::ostream &os, const Self &x) {
    return os << ClassificationNames[x.value];
  }
  // for ur-cfg debug
  friend llvm::raw_ostream &operator<<(llvm::raw_ostream &os, const Self &x){
    return os << ClassificationNames[x.value];
  }

  bool operator<(const Self &x) const {
    if (this->value < x.value) {
      return true;
    }
    return false;
  }
};

inline Classification::Classification(bool initializeAsBottom)
    : Super(initializeAsBottom ? CL_BOT : CL_UNKNOWN) {}

inline Classification::Classification(unsigned char value) : Super(value) {}

} // namespace cache
} // namespace dom

} // namespace TimingAnalysisPass

#endif /*CLASSIFICATION_H_*/
