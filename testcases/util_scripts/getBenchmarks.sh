#!/bin/bash

set -e
set -o pipefail
set -u

# This is a convenience script to get a list of all the benchmarks. It goes
# through all the directories in Benchmarks/ trying to identify if it contains
# a valid testcase or not.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/blacklist.sh"

# Functions to prevent any spurious pushd/popd output
pushd() {
	command pushd "$1" >/dev/null
}

popd() {
	command popd >/dev/null
}

# If the user passed a single parameter, interpret it as the test prefix. Only
# Testcases matching this prefix (and not blacklisted)
test_prefix=
if [[ $# -eq 1 ]]; then
	test_prefix="$1"
	test_prefix="${test_prefix%/}/"
fi

# This loop generates a list of all the leaf directories within Benchmarks/.
array=()
while IFS=  read -r -d $'\0'; do
	if [[ $REPLY == Benchmarks/$test_prefix* ]]; then
		array+=("$REPLY")
	fi
done < <(find Benchmarks -type d -links 2 -print0)

# This is the magic to identify a benchmark directory from other directories
# Starting from the leaf directory find the first directory that contains a
# ".c" file. If the search hits the Benchmarks/ directory (root), then that
# leaf directory does not contain any benchmark applications.
tmplist=()
PWD_OLD=$PWD
for dir in "${array[@]}"; do
	pushd .
	cd "$dir"
	while true; do
		if [ "$PWD" == "$PWD_OLD" ]; then
			echo "Leaf directory $dir is useless" >&2
			exit 1;
		elif [ "$(find . -maxdepth 1 -regex ".*\.c[p]*")" ]; then
			TESTDIR="${PWD#*Benchmarks/}"
			if [[ ! "${BLACKLIST[*]}" =~ $TESTDIR ]]; then
				tmplist+=("$TESTDIR")
			fi
			break;
		else
			cd ../
		fi
	done
	popd
done

# Sort and return only unique directory paths. This is because certain
# testcases are returned multiple times from the above analysis
IFS=$'\n' sorted=($(sort -u <<<"${tmplist[*]}"))
for d in "${sorted[@]}"; do
	echo "$d"
done
