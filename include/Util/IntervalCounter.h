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

#ifndef INTERVALCOUNTER_H
#define INTERVALCOUNTER_H

namespace TimingAnalysisPass {

/**
 * Class implementing an interval counter that will be helpful at several
 * places within the analyses created with this framework.
 *
 * This is the case in which fields for both bounds are needed.
 */
template <bool LowerBoundNeeded, bool UpperBoundNeeded, bool AllowJoin>
class DoubleBoundIntervalCounter {
private:
  // a short-hand typedef
  typedef DoubleBoundIntervalCounter<LowerBoundNeeded, UpperBoundNeeded,
                                     AllowJoin>
      IC;

public:
  explicit DoubleBoundIntervalCounter(const unsigned &initialValue)
      : lb(initialValue), ub(initialValue) {}

  explicit DoubleBoundIntervalCounter(const unsigned &initialLb,
                                      const unsigned &initialUb)
      : lb(initialLb), ub(initialUb) {}

  explicit DoubleBoundIntervalCounter() : DoubleBoundIntervalCounter(0u) {}

  DoubleBoundIntervalCounter(const IC &ic2) : lb(ic2.lb), ub(ic2.ub) {}

  IC &operator=(const unsigned &value) {
    lb = value;
    ub = value;
    return *this;
  }

  IC &operator=(const IC &ic2) {
    lb = ic2.lb;
    ub = ic2.ub;
    return *this;
  }

  IC &operator+=(const unsigned &value) {
    lb += value;
    ub += value;
    return *this;
  }

  IC &operator+=(const IC &ic2) {
    lb += ic2.lb;
    ub += ic2.ub;
    return *this;
  }

  IC &operator++() // <-> += 1u
  {
    return *this += 1;
  }

  bool operator==(const IC &ic2) const { return lb == ic2.lb && ub == ic2.ub; }

  bool isJoinable(const IC &ic2) const {
    if (AllowJoin) {
      return true;
    } else {
      return *this == ic2;
    }
  }

  void join(const IC &ic2) {
    assert(isJoinable(ic2));
    if (lb > ic2.lb) {
      lb = ic2.lb;
    }
    if (ub < ic2.ub) {
      ub = ic2.ub;
    }
  }

  unsigned getLb() const { return lb; }

  unsigned getUb() const { return ub; }

  size_t hashcode() const {
    size_t res = 0;
    hash_combine(res, lb);
    hash_combine(res, ub);
    return res;
  }

  friend std::ostream &operator<<(
      std::ostream &stream,
      const DoubleBoundIntervalCounter<LowerBoundNeeded, UpperBoundNeeded,
                                       AllowJoin> &ic) {
    stream << "[" << ic.getLb() << ", " << ic.getUb() << "]";
    return stream;
  }

private:
  // the lower bound of the interval
  unsigned lb;

  // the upper bound of the interval
  unsigned ub;
};

/**
 * Class implementing an interval counter that will be helpful at several
 * places within the analyses created with this framework.
 *
 * This is the case in which only one member field is needed.
 *
 * We assume that only the following parameter settings will later be
 * specialized:
 * - true,  true,  false
 * - true,  false, *
 * - false, true,  *
 */
template <bool LowerBoundNeeded, bool UpperBoundNeeded, bool AllowJoin>
class SingleBoundIntervalCounter {
private:
  // a short-hand typedef
  typedef SingleBoundIntervalCounter<LowerBoundNeeded, UpperBoundNeeded,
                                     AllowJoin>
      IC;

public:
  explicit SingleBoundIntervalCounter(const unsigned &initialValue)
      : sb(initialValue) {}

  template <bool enableLB =
                LowerBoundNeeded &&
                !UpperBoundNeeded> // MJa: directly using the class template
                                   // parameters does not work here...
                                   explicit SingleBoundIntervalCounter(
                                       typename std::enable_if<
                                           enableLB, const unsigned &>::type
                                           initialLb,
                                       const unsigned &initialUb)
      : sb(initialLb) {}

  template <bool enableUB =
                UpperBoundNeeded> // MJa: directly using the class template
                                  // parameters does not work here...
                                  explicit SingleBoundIntervalCounter(
                                      const unsigned &initialLb,
                                      const unsigned &initialUb,
                                      typename std::enable_if<enableUB>::type
                                          * = nullptr)
      : sb(initialUb) {
    if (UpperBoundNeeded && LowerBoundNeeded) {
      assert(initialLb == initialUb);
    }
  }

  explicit SingleBoundIntervalCounter() : SingleBoundIntervalCounter(0u) {}

  SingleBoundIntervalCounter(const IC &ic2) : sb(ic2.sb) {}

  IC &operator=(const unsigned &value) {
    sb = value;
    return *this;
  }

  IC &operator=(const IC &ic2) {
    sb = ic2.sb;
    return *this;
  }

  IC &operator+=(const unsigned &value) {
    sb += value;
    return (IC &)*this;
  }

  IC &operator+=(const IC &ic2) {
    sb += ic2.sb;
    return *this;
  }

  IC &operator++() // <-> += 1u
  {
    return *this += 1;
  }

  bool operator==(const IC &ic2) const { return sb == ic2.sb; }

  bool isJoinable(const IC &ic2) const {
    if (AllowJoin) {
      return true;
    } else {
      return *this == ic2;
    }
  }

  void join(const IC &ic2) {
    assert(isJoinable(ic2));
    if (AllowJoin) {
      // we know by our assumptions:
      // in case AllowJoin == true, there may only
      // be one of the other template parameters
      // true.

      if (LowerBoundNeeded) {
        // sb is a lower bound
        if (sb > ic2.sb) {
          sb = ic2.sb;
        }
      }

      if (UpperBoundNeeded) {
        // sb is an upper bound
        if (sb < ic2.sb) {
          sb = ic2.sb;
        }
      }
    }
  }

  unsigned getLb() const { return sb; }

  unsigned getUb() const { return sb; }

  size_t hashcode() const {
    size_t res = 0;
    hash_combine(res, sb);
    return res;
  }

  friend std::ostream &operator<<(
      std::ostream &stream,
      const SingleBoundIntervalCounter<LowerBoundNeeded, UpperBoundNeeded,
                                       AllowJoin> &ic) {
    stream << "[" << ic.getLb() << ", " << ic.getUb() << "]";
    return stream;
  }

private:
  // the single bound,
  // whether it is treated as an upper
  // bound or a lower bound depends on
  // the template parameters...
  unsigned sb;
};

/**
 * Class implementing an interval counter that will be helpful at several
 * places within the analyses created with this framework.
 *
 * This is the case in which no data fields are needed at all.
 *
 * We assume that only the following parameter settings will later be
 * specialized:
 * - false, false, *
 */
template <bool LowerBoundNeeded, bool UpperBoundNeeded, bool AllowJoin>
class NoBoundIntervalCounter {
private:
  // a short-hand typedef
  typedef NoBoundIntervalCounter<LowerBoundNeeded, UpperBoundNeeded, AllowJoin>
      IC;

public:
  explicit NoBoundIntervalCounter(const unsigned &initialValue) {}

  explicit NoBoundIntervalCounter(const unsigned &initialLb,
                                  const unsigned &initialUb) {}

  explicit NoBoundIntervalCounter() {}

  NoBoundIntervalCounter(const IC &ic2) {}

  IC &operator=(const unsigned &value) { return *this; }

  IC &operator=(const IC &ic2) { return *this; }

  IC &operator+=(const unsigned &value) { return *this; }

  IC &operator+=(const IC &ic2) { return *this; }

  IC &operator++() // <-> += 1u
  {
    return *this;
  }

  bool operator==(const IC &ic2) const { return true; }

  bool isJoinable(const IC &ic2) const { return true; }

  void join(const IC &ic2) {
    // do nothing
  }

  unsigned getLb() const { return 0; }

  unsigned getUb() const { return 0; }

  size_t hashcode() const {
    size_t res = 0;
    return res;
  }

  friend std::ostream &
  operator<<(std::ostream &stream,
             const NoBoundIntervalCounter<LowerBoundNeeded, UpperBoundNeeded,
                                          AllowJoin> &ic) {
    stream << "[" << ic.getLb() << ", " << ic.getUb() << "]";
    return stream;
  }
};

/**
 * Now we want different specializations of a class IntervalCounter
 * to correspond to different ones of the above mentioned classes.
 *
 * However, doing this with inheritance only makes problems. And after
 * all, we do not really want to inherit here, but to specialize.
 *
 * It seems to not be possible to realize different specializations
 * of a template class as aliases to different other classes.
 * Thus we employed a workaround that is described by the post
 * of user Aotium in the following link:
 *
 * http://stackoverflow.com/questions/7801228/can-i-specialize-a-class-template-with-an-alias-template
 *
 * The trick is to specialize a template struct that only
 * contains the respective type.
 */
template <bool LowerBoundNeeded, bool UpperBoundNeeded, bool AllowJoin>
struct IntervalCounterType {
  typedef DoubleBoundIntervalCounter<LowerBoundNeeded, UpperBoundNeeded,
                                     AllowJoin>
      type;
};

template <bool AllowJoin> struct IntervalCounterType<false, true, AllowJoin> {
  typedef SingleBoundIntervalCounter<false, true, AllowJoin> type;
};

template <bool AllowJoin> struct IntervalCounterType<true, false, AllowJoin> {
  typedef SingleBoundIntervalCounter<true, false, AllowJoin> type;
};

template <> struct IntervalCounterType<true, true, false> {
  typedef SingleBoundIntervalCounter<true, true, false> type;
};

template <bool AllowJoin> struct IntervalCounterType<false, false, AllowJoin> {
  typedef NoBoundIntervalCounter<false, false, AllowJoin> type;
};

template <bool LowerBoundNeeded, bool UpperBoundNeeded, bool AllowJoin>
using IntervalCounter =
    typename IntervalCounterType<LowerBoundNeeded, UpperBoundNeeded,
                                 AllowJoin>::type;

} // namespace TimingAnalysisPass

#endif
