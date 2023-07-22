message(STATUS "Found Partition Util LIB")

add_llvm_library(llvmtaPartitionUtil
Context.cpp
Directive.cpp
DirectiveHeuristics.cpp
PartitionToken.cpp
DEPENDS LLVMAnalysis LLVMCodeGen LLVMCore LLVMSupport LLVMTarget
)

