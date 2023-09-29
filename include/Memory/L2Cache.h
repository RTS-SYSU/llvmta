#ifndef __L2_CACHE__
#define __L2_CACHE__

#include "Util/AbstractAddress.h"

#include <utility>

namespace l2cache {
// <BCET, WCET>
typedef std::pair<unsigned, unsigned> accessTime;

/// @brief Check if two access times are overlapped
/// @param t1
/// @param t2
/// @return true if overlapped
/// @return false if not overlapped
inline bool isOverlapped(accessTime t1, accessTime t2) {
  return !(t1.first > t2.second || t2.first > t1.second);
}

class CacheMissRecord {
private:
  accessTime _accessTime;
  TimingAnalysisPass::AbstractAddress _address;

public:
  CacheMissRecord() : _accessTime(0, 0), _address(0u) {}

  CacheMissRecord(unsigned WCET, TimingAnalysisPass::AbstractAddress address)
      : _accessTime(0, WCET), _address(address) {}

  inline void setAccessAddress(TimingAnalysisPass::AbstractAddress address) {
    _address = address;
  }

  inline void updateBCET(unsigned bcet) { _accessTime.first = bcet; }

  inline void updateWCET(unsigned wcet) { _accessTime.second = wcet; }

  inline accessTime getAccessTime() const { return _accessTime; }

  inline TimingAnalysisPass::AbstractAddress getAccessAddress() const {
    return _address;
  }
};

} // namespace l2cache

#endif