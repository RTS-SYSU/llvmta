message(STATUS "Found Preprocessing Analysis LIB")

add_llvm_library(llvmtaPreprocessing
AddressInformation.cpp
ConstantValueDomain.cpp
ConstantValueDomainARM.cpp
ConstantValueDomainRISCV.cpp
DEPENDS LLVMAnalysis LLVMCodeGen LLVMCore LLVMSupport LLVMTarget
)

