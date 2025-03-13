message(STATUS "Found Memory LIB")

add_llvm_library(llvmtaMemory
AbstractCache.cpp
AbstractCyclingMemory.cpp
BlockingCyclingMemoryConfig.cpp
Classification.cpp
FixedLatencyCyclingMemoryConfig.cpp
PersistenceScopeInfo.cpp
SimpleSDRAMCyclingMemory.cpp
CacheUtils.cpp
DEPENDS LLVMAnalysis LLVMCodeGen LLVMCore LLVMSupport LLVMTarget
)

add_subdirectory(crpd)

