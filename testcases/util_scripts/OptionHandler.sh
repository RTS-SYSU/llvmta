#!/usr/bin/env bash

set -e
set -o pipefail
set -u

USEROPTS=()
TESTCASES=()

_get_opt_name() {
	shopt -s extglob
	local rm_suffix="${1%=*}"
	echo "${rm_suffix##+(-)}"
	shopt -u extglob
}

_get_opt_val() {
	shopt -s extglob
	local rm_prefix="${1#*=}"
	echo "$rm_prefix"
	shopt -u extglob
}

optVal() {
	local e
	local teststr
	teststr=$(_get_opt_name "$1")

	for e in "${@:2}"; do
		local elem
		elem=$(_get_opt_name "$e")
		[[ "$elem" == "$teststr" ]] && echo "$(_get_opt_val "$e")" && return 0
	done
	return 1
}

optIn() {
	local e
	# Handle the case where the caller is searching for the separator token
	# (--). This must be handled separately because the rest of the code here
	# removes all leading "-" characters, which would make matching for "--"
	# impossible
	if [[ "$1" == "--" ]]; then
		for e in "${@:2}"; do
			[[ "--" == "$e" ]] && return 0
		done
	fi
	local teststr
	teststr=$(_get_opt_name "$1")

	for e in "${@:2}"; do
		local elem
		elem=$(_get_opt_name "$e")
		[[ "$elem" == "$teststr" ]] && return 0
	done
	return 1
}

# Add a new option. Ensures that the option is unique. If it has been passed
# earlier, then the new one will not be used
add_option() {
	option="$1"
	if ! optIn "$option" "${USEROPTS[@]}"; then
		add_option_multiple "$option"
	fi
}

# Add a new option. Multiple of these may be passed.
# Be careful when using this option since command line overrides will not
# work as expected.
add_option_multiple() {
	option="$1"
	if is_llvmta_option "$option"; then
		USEROPTS+=( "$option" )
	else
		USEROPTS=( "$option" "${USEROPTS[@]}" )
	fi
}

rm_option() {
	local i=0
	local option
	option=$(_get_opt_name "$1")
	for e in "${USEROPTS[@]}"; do
		local elem
		elem=$(_get_opt_name "$e")
		if [[ "$option" == "$elem" ]]; then
			unset USEROPTS[$i]
			break
		fi
		((i+=1))
	done
	USEROPTS=( "${USEROPTS[@]}" )
}

get_option() {
	local e
	local teststr
	teststr=$(_get_opt_name "$1")

	for e in "${USEROPTS[@]}"; do
		local elem
		elem=$(_get_opt_name "$e")
		[[ "$elem" == "$teststr" ]] && echo "$(_get_opt_val "$e")" && return 0
	done
	echo ""
	return 1
}

is_llvmta_option() {
	if [[ "$1" =~ [-]+ta- ]]; then
		return 0
	else
		return 1
	fi
}

# Initialize the Options.
# Accept all the user options and place the option separator for script and
# llvmta options in the right spot.
# This allows the user to simply pass llvmta options without having to
# explicitly pass the separator as well
init_options() {
	local prep=""
	if [[ $# -gt 0 ]] && is_llvmta_option "$1"; then
		prep="--"
	fi
	IFS=' ' read -r -a USEROPTS <<< "$prep $*"
	if ! optIn "--" "${USEROPTS[@]}"; then
		USEROPTS+=( "--" )
	fi
}

getTestcases() {
	count=0
	test_prefix=
	if [[ $# -gt 0 && ! $1 =~ --.* ]]; then
		test_prefix=$1
		shift
		((count=count+1))
	fi

	manual_tests=false

	while [[ $# -gt 0 && $1 =~ --testcase=(.*) ]]; do
		manual_tests=true
		TESTCASES+=( "${BASH_REMATCH[1]}" )
		shift
		((count=count+1))
	done

	if [[ ! $manual_tests == true ]]; then
		# Don't double quote the $test_prefix parameter. With double quoting, an
		# empty argument will be passed to getBenchmarks, we don't want that
		readarray -t TESTCASES <<< "$("$DIRPATH/util_scripts/getBenchmarks.sh" $test_prefix)"
	fi
	return $count
}

llvmta_defaults() {
	add_option "--ta-muarch-type=inorder"
	add_option "--ta-memory-type=separatecaches"
	add_option "--ta-strict=false"
}
