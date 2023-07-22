#!/usr/bin/env bash

set -e
set -o pipefail
set -u

# Usage:
# ./getNormalisedExperimentPath.sh base_directory [options]
#
# This script accepts the "base_directory" as its first parameter. The base
# directory is the directory in which the experiment results are stored and
# where it should find the experiment to directory name mapping.
#
# It then accepts the set of options to be passed to llvmta for analysis. The
# script will parse the options and return the path to a directory where the
# experimental run should be stored. The directory may already exist and it is
# the job of the caller to remove the directory.

DIRPATH="$(dirname "$0")"
source "$DIRPATH/llvmta_utils.sh"

BASE_DIRECTORY="$1" && shift
PARAMETERS="$*"
OPT_MAP="${BASE_DIRECTORY}/.options_map"

# First, we convert the parameter list to a sorted array of parameters. Then,
# we eliminate all the superfluous and redundant characters and turn the array
# into a single | separated string
PARAMETERS=( $(sort <<< "${PARAMETERS// /$'\n'}") )
NormalizedParams=$(sed -E	-e 's/-- //g' \
							-e 's/[[:blank:]]+/|/g' \
							-e 's/[-]+ta/ta/g'		\
							<<< "${PARAMETERS[@]}")

FLAGS=$(get_ctx_flags "${PARAMETERS[@]}")
NormalizedParams="${NormalizedParams}&${FLAGS}"
mkdir -p "$BASE_DIRECTORY"
touch "$OPT_MAP"

# If the MAP file exists, check to see if the current set of options exists has
# been tested for in the past.
EXP_PATH=""
if [ -f "$OPT_MAP" ]; then
	# We do not want to fail when on pipefail here. Instead, we rely on this
	# command returning an empty string
	set +o pipefail
	EXP_PATH=$(grep "^${NormalizedParams}[[:space:]]" "$OPT_MAP" | awk '{print $2}')
	set -o pipefail
fi

# If $EXP_PATH is empty, then either:
#   1. The MAP file does not exist
#   2. The current set of options has not been executed in the past
# In both these cases, we attempt to return the directory name in which the
# experiment should be executed.
if [ -z "$EXP_PATH" ]; then
	# First attempt to find the highest numbered experiment_* directory,
	# defaulting to experiment_0
	# Use "version" sorting here. Version sort sorts by dictionary order _and_
	# numeric in the right places.
	EXP_PATH_LAST=$(awk '{print $2}' < "$OPT_MAP" | sort -V | tail -n1)
	EXP_PATH=${EXP_PATH_LAST:-experiment_0}

	# Increase the experiment number by 1
	if [[ "$EXP_PATH" =~ (.*[^0-9])([0-9]+)$ ]]; then
		EXP_PATH="${BASH_REMATCH[1]}$((BASH_REMATCH[2] + 1))"
	fi

	# Write out the parameter list and the decided directory to the MAP file
	echo -e "$NormalizedParams\t$(basename "$EXP_PATH")" >> "$OPT_MAP"
	# Print the directory name to stdout for other scripts
	echo "$EXP_PATH"

	# Exit with code 1 to signify that the option set was not found in a MAP
	# file.
	exit 1
fi

echo "$EXP_PATH"
