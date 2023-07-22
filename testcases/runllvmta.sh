#!/usr/bin/env bash

# Runs llvmta for given tetscase
# Expects to be passed the absolute path to a directory that contains exactly 1
# testcase within it. It first checks the directory for an executable called
# "build.sh", if it exists, it hands over the task of building the `.ll` file
# to this script.
#
# This script calls LLVM/Clang and llvmta from a temporary directory, allowing
# files to be created without any issues. On successful completion, it moves
# the entire directory to the directory containing the testcase with the name,
# "build". If unsuccessful, the temporary directory remains and the name is
# printed to stderr to allow manual inspection.

set -e
set -o pipefail
set -u

cleanup() {
	# rm -rf would do the job as well, but I hate using rm -rf in a script with
	# variables. Hence, this workaround which is _slightly_ safer
	rm -r "${TEST_BUILD_DIR:?}" 2>/dev/null || true
	mkdir -p "${TEST_BUILD_DIR}"
	mv -t "$TEST_BUILD_DIR" "$WORKDIR"/*
	rmdir "$WORKDIR"
}

ensure_mif_prereqs() {
	pushd "$MIF_UTILS"
	if [[ ! -f "init.o" ]]; then
		echo "===> Building init.o" >&2
		arm-none-eabi-as init.s -o init.o
	fi
	if [[ ! -f "hex_to_mif/hex2mif" ]]; then
		pushd "hex_to_mif"
		echo "===> Building hex2mif binary" >&2
		"${CXX:-g++}" -std=c++11 hex2mif.cpp -o hex2mif
		popd
	fi
	popd
}


# Set defaults for variables handled by the option parsing code
enable_optimizations=false
enable_hard_floatingpoint=true
concise_resource_stats=false
procmask="FF"
build_mif=false
build_dir=""
limit_mem=false
entry_point=""
isa_type="arm"

########################################
# Option Parsing code                  #
########################################

if [ $# -lt 1 ]; then
	echo "Usage: $0 TESTCASE_DIR [options] -- [llvmta options]" >&2
	exit 1
fi
# The first argument *MUST* always exist, handle it first
readonly TESTCASE_DIR="$1"
shift

while [ $# -gt 0 ]; do

	if [[ "$1" =~ ^(-+[a-z-]*)[=\ ]?(.*) ]]; then
		opt=${BASH_REMATCH[1]}
		if [[ -z ${BASH_REMATCH[2]} ]]; then
			# If the script fails with an unbound variable here, then it
			# usually imples that runllvmta.sh was not given enough
			# parameters. llvmta must *always* be sent some parameters so this
			# can only be triggered, when someone forgot to pass them
			val="$2"
		else
			val=${BASH_REMATCH[2]}
		fi

		case $opt in
			"--enable-optimizations") enable_optimizations=true;;
			"--disable-hard-floatingpoint") enable_hard_floatingpoint=false;;
			"--llvmta-concise-resource-stats") concise_resource_stats=true;;
			"--llvmta-fixed-procs") procmask="$val";;
			"--llvmta-build-mif") build_mif=true;;
			"--llvmta-build-dir") build_dir=$val;;
			"--llvmta-entry-point") entry_point=$val;;
			"--llvmta-limit-memory") limit_mem=true;;
			"--llvmta-isa") isa_type=$val;;
			"--") shift; break;;
			*) echo "Unknown Option: $opt" >&2; exit 1;;
		esac

	fi
	shift
done

readonly TEST_BUILD_DIR=${build_dir:-${TESTCASE_DIR}/build}
readonly LLVMTA_USER_OPTS=( "$@" )
echo "${LLVMTA_USER_OPTS[@]}"

########################################

# Define variables
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly UNOPTIMIZEDLL="unoptimized.ll"
readonly BUILD_SCRIPT="build.sh"
readonly WORKDIR="$(mktemp -d -p "$SCRIPT_DIR")"
readonly MIF_UTILS="$SCRIPT_DIR/mif_utils"
readonly LIB_PATH="$SCRIPT_DIR/libraries"

clangSpOptions="${TESTCASE_DIR}/ClangSpecialOptions.txt"

if [ $isa_type == "riscv" ]; then
	llvm_link_libraries=( "$LIB_PATH/riscv/builtininteger.ll" "$LIB_PATH/riscv/builtinstd.ll" )
else
	llvm_link_libraries=( "$LIB_PATH/arm/builtininteger.ll" "$LIB_PATH/arm/builtinstd.ll" )
fi

# -march=armv4t will generate only simply ARM instructions supported by our
# FPGA prototype
clangopts=( "-w" "-S" "-gline-tables-only"
			"-O0" "-Xclang" "-disable-O0-optnone" "-fno-builtin")

if [ $isa_type == "riscv" ]; then
	clangopts+=("-target" "riscv32")
else
	clangopts+=("-target" "arm" "-march=armv4t")
fi

if [ -d "$TESTCASE_DIR/include" ]; then
	clangopts+=( "-I${TESTCASE_DIR}/include" )
fi

if [ -f "$clangSpOptions" ]; then
	readarray -t spOptions < "$clangSpOptions"
	clangopts+=( "${spOptions[@]}" )
fi

# Set the options that will be passed to llvmta
# -mattr=+hwdiv-arm enables dedicated division instructions without allowing
# all later ARM instructions
llvmtaopts=( "-disable-tail-calls" )

if [ $isa_type == "riscv" ]; then
	if [ "$enable_hard_floatingpoint" = true ]; then
		clangopts+=( "-march=rv32imfd" "-mfloat-abi=hard" )
		llvmtaopts+=( "-mattr=+m,+f,+d" "-float-abi=hard" )
	else
		llvm_link_libraries+=( "$LIB_PATH/riscv/builtinfloat.ll" )
		clangopts+=( "-march=rv32im" "-mfloat-abi=soft" )
		llvmtaopts+=( "-mattr=+m" "-float-abi=soft" )
	fi
else
	if [ "$enable_hard_floatingpoint" = true ]; then
		clangopts+=( "-mfloat-abi=hard" )
		llvmtaopts+=( "-float-abi=hard" "-mattr=-neon,+vfp2" )
	else
		llvm_link_libraries+=( "$LIB_PATH/arm/builtinfloat.ll" )
		clangopts+=( "-mfloat-abi=soft" )
		llvmtaopts+=( "-float-abi=soft" )
	fi
fi

if [ "$enable_optimizations" = false ]; then
	llvmtaopts+=("-O0 -disable-O0-optnone")
else
	# Note: if conversion can unfortunately not be disabled completely.
	# One would need to comment the call to createIfConversion to stop if-conversion completely.
	#
	# Disable tail duplication as this can transform reducible loops into irreducible ones,
	# which are then no longer recognised as loops by LLVM
	wcetcompopti=( "-O2" "-disable-lsr" "-disable-early-ifcvt"
					"-disable-ifcvt-diamond" "-disable-ifcvt-simple"
					"-disable-ifcvt-simple-false" "-disable-ifcvt-triangle"
					"-disable-ifcvt-triangle-false" "-disable-ifcvt-triangle-false-rev"
					"-disable-ifcvt-triangle-rev" "-tail-dup-placement=false" )

	llvmtaopts+=( ${wcetcompopti[@]} )
fi

entryPoints="${TESTCASE_DIR}/EntryPoints.txt"
llvmta_entry=()
if [[ -n $entry_point ]]; then
	llvmta_entry=( "$entry_point" )
elif [[ -f "$entryPoints" ]]; then
	readarray -t llvmta_entry < "$entryPoints"
elif [[ $TESTCASE_DIR == *Benchmarks/taclebench/* ]]; then
	llvmta_entry=( "$(basename "$TESTCASE_DIR")_main" )
else
	llvmta_entry=( "main" )
fi

if [ "$concise_resource_stats" = true ]; then
	timearg="-fRuntime/Memory: %U\t%M"
else
	timearg="-v"
fi

llvmtacommand="llvmta"
if [[ "$limit_mem" = true ]]; then
	llvmtacommand="../../memlimitllvmta"
fi

trap cleanup EXIT
pushd "$WORKDIR"
clang "${clangopts[@]}" -emit-llvm "$TESTCASE_DIR"/*.c
llvm-link $(LC_COLLATE=C ls ./*.ll) "${llvm_link_libraries[@]}" -o $UNOPTIMIZEDLL
# Provide definitions of used library functions, e.g. integer division

# Optimize LLVM IR, e.g. do -mem2reg, -instcombine, -loop-simplify, -indvars to find loop bounds
opt -S $UNOPTIMIZEDLL -mem2reg -indvars -loop-simplify -instcombine -globaldce -dce -o optimized.ll

# Run WCET Analysis itself
for entrypoint in "${llvmta_entry[@]}"; do
	mkdir "$entrypoint"
	cp optimized.ll "$entrypoint"
	pushd "$entrypoint"
	/usr/bin/time "$timearg" taskset "$procmask" "$llvmtacommand" \
		"${llvmtaopts[@]}" \
		--ta-analysis-entry-point="$entrypoint" \
		"${LLVMTA_USER_OPTS[@]}" \
		optimized.ll
	popd
done

# Convert the compiled binary to a FPGA compatible .mif file
if [[ "$build_mif" = true ]]; then
	# First ensure that all the required compiled files exist
	ensure_mif_prereqs

	cp "$MIF_UTILS/init.o" "$MIF_UTILS/hex_to_mif/hex2mif" "$MIF_UTILS/minimal.ld" .
	arm-none-eabi-as "${llvmta_entry[0]}/optimized.s" -o optimized.o
	arm-none-eabi-ld -Tminimal.ld  init.o optimized.o -o final_binary -static -L/usr/lib/gcc/arm-none-eabi/7.2.0 -lgcc
	arm-none-eabi-objcopy -O ihex --reverse-bytes=4 final_binary final_binary.hex
	"$MIF_UTILS"/hex_to_mif/hex2mif final_binary
fi
popd
