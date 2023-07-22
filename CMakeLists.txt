
#building out of llvm sources  is not possible, see:
#https://lists.llvm.org/pipermail/llvm-dev/2019-March/130706.html
message (STATUS "Found tool llvmta")

project("TimingAnalysis")

set(LLVM_LINK_COMPONENTS
  ${LLVM_TARGETS_TO_BUILD}
  Analysis
  AsmPrinter
  CodeGen
  Core
  IRReader
  MC
  MIRParser
  ScalarOpts
  SelectionDAG
  Support
  Target
  TransformUtils
  Vectorize
  )

message (STATUS "${PROJECT_BINARY_DIR}$")
message (STATUS "${PROJECT_SOURCE_DIR}$")

include_directories(include ${LLVM_BINARY_DIR}/lib/Target/ARM ${LLVM_SOURCE_DIR}/lib/Target/ARM ${LLVM_BINARY_DIR}/lib/Target/RISCV ${LLVM_SOURCE_DIR}/lib/Target/RISCV)

add_llvm_tool(llvmta
  llvmta/llvmta.cpp
  )

add_subdirectory(lib)

target_link_libraries(llvmta PRIVATE lpsolve55 gurobi llvmtaLLVMPasses llvmtaUtil llvmtaPathAnalysis llvmtaAnalysisFramework llvmtaPartitionUtil llvmtaPreprocessing llvmtaMemory llvmtaMicroarchitecture llvmtaMicroarchitectureOutOfOrder llvmtacrpd)
