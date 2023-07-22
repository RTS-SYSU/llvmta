# Blacklist.sh
#
# This file defines the various tests that are blacklisted and the relevant
# reasons for blacklisting them. Use it by sourcing the file into your scripts
# and using the BLACKLIST variable

# LLVMTA does not handle recursion
_recursion=( "taclebench/kernel/bitcount" "taclebench/kernel/bitonic"
	"taclebench/kernel/fac" "taclebench/kernel/quicksort"
	"taclebench/kernel/recursion" "taclebench/sequential/anagram"
	"taclebench/sequential/huff_enc" "wcet_bench/fac" "wcet_bench/recursion"
	)

# Blacklisted for other reasons
#	* taclebench/sequential/ammunition: Temporarily disabled since we don't know
#	why it takes so much time to determine Context Sensitivity
#	* callexamples/computedCall: We don't supported computed calls yet
#	* taclebench/kernel_tosplit/basicmath, fmref, whet: Too long when using
# soft floating point
# * wcet_bench/duff: irreducible loops
_others=( "taclebench/sequential/ammunition" "callexamples/computedCall"
	"taclebench/kernel_tosplit/basicmath" "taclebench/sequential/fmref"
	"wcet_bench/whet" "wcet_bench/duff" "loopexamples/irreducible" )

# External Calls
# These tests call external functions that are not a part of the included
# library
_extfunc=( )

# Multiple Entry Points
_multientry=( "taclebench/parallel/DEBIE"
	"taclebench/parallel/PapeBench/autopilot"
	"taclebench/parallel/PapeBench/fly_by_wire"
	)

# Doesn't compile
_dontcompile=( "wcet_bench/des" "scadetests/cruise_control" )

# Entire Groups that should be Blacklisted (As a prefix)
_groups=( "taclebench/test" "diverse" "diverse/loadStoreTests" "diverse/persistence" "diverse/predication" "diverse/writeback")

_blacklist=( "${_recursion[@]}" "${_others[@]}" "${_multientry[@]}"
	"${_dontcompile[@]}" "${_extfunc[@]}" )

if [[ ! -z "${BLACKLIST_TESTS[*]}" ]]; then
	_blacklist+=( "${BLACKLIST_TESTS[@]}" )
fi

set -e
set -o pipefail
set -u

# Test if the blacklisted testcases actually exist and can be uniquely
# identified. If we can find them, build a new array with the fully resolved
# paths to the testcases for later testing
BLACKLIST=()
for bl_elem in "${_blacklist[@]}"; do
	dir=$(find Benchmarks -type d -wholename "*/$bl_elem")
	if [ ! -d "$dir" ]; then
		echo "Unable to (uniquely) find Blacklisted Testcase \"$bl_elem\"" >&2
		echo -e "Potential testcases found: \n$dir" >&2
		exit 1
	else
		BLACKLIST+=("${dir#*Benchmarks/}")
	fi
done

for bl_group_elem in "${_groups[@]}"; do
	BLACKLIST+=( "$(find "Benchmarks/$bl_group_elem" -maxdepth 1 -mindepth 1 -type d)" )
done

