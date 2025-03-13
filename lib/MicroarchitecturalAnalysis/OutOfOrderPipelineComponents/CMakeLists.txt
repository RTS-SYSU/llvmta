message(STATUS "Found Muarch OutOfOrder LIB")

add_llvm_library(llvmtaMicroarchitectureOutOfOrder
BranchFunctionalUnit.cpp
CommonDataBus.cpp
FunctionalUnit.cpp
ReOrderBuffer.cpp
RegisterStatusTable.cpp
ReservationStation.cpp
SimpleFunctionalUnit.cpp
DEPENDS LLVMAnalysis LLVMCodeGen LLVMCore LLVMSupport LLVMTarget
)

