message(STATUS "Found Muarch LIB")

add_llvm_library(llvmtaMicroarchitecture
ExecutionElement.cpp
FixedLatencyState.cpp
ProgramCounter.cpp
DEPENDS LLVMAnalysis LLVMCodeGen LLVMCore LLVMSupport LLVMTarget
)

add_subdirectory(OutOfOrderPipelineComponents)

