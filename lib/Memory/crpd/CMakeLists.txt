message(STATUS "Found Cache-Related Preemption Delay LIB")

add_llvm_library(llvmtacrpd
CacheRelatedPreemptionDelay.cpp
DEPENDS LLVMAnalysis LLVMCodeGen LLVMCore LLVMSupport LLVMTarget
)

