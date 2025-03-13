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

#ifndef UTIL_SHAREDSTORAGE_H_
#define UTIL_SHAREDSTORAGE_H_

#include <set>

namespace TimingAnalysisPass {

namespace util {

struct DereferenceLess {
  template <typename PtrType> bool operator()(PtrType p1, PtrType p2) const {
    return *p1 < *p2;
  }
};

template <class T> class SharedStorage {
public:
  typedef const T *SharedPtr;
  typedef DereferenceLess less;

private:
  typedef std::set<SharedPtr, DereferenceLess> Storage;

  static Storage *storage;
  static long refcount;

public:
  SharedStorage() {
    if (refcount == 0) {
      storage = new Storage();
    }
    ++refcount;
  }
  SharedStorage(const SharedStorage &ss) { ++refcount; }
  ~SharedStorage() {
    --refcount;
    if (refcount == 0) {
      for (auto ptr : *storage) {
        delete ptr;
      }
      storage->clear();
      delete storage;
    }
  }

  SharedPtr insert(const T &x) const {
    // Copy object on heap
    SharedPtr ptr = new T(x);

    // Try to insert pointer \c ptr into the storage
    std::pair<typename Storage::iterator, bool> pair = storage->insert(ptr);

    // If object was already contained delete the newly constructed one
    if (!pair.second)
      delete ptr;

    return *pair.first;
  }
};

template <class T>
typename SharedStorage<T>::Storage *SharedStorage<T>::storage;

template <class T> long SharedStorage<T>::refcount = 0;

} // namespace util

} // namespace TimingAnalysisPass

#endif /*UTIL_SHAREDSTORAGE_H_*/
