message(STATUS "Found Analysis Framework LIB")

add_llvm_library(llvmtaAnalysisFramework
AnalysisResults.cpp
CallGraph.cpp
CollectingContextsDomain.cpp
DEPENDS LLVMAnalysis LLVMCodeGen LLVMCore LLVMSupport LLVMTarget
)

