set -u

source "$DIRPATH/util_scripts/pretty_print.sh"
source "$DIRPATH/util_scripts/OptionHandler.sh"

# Please use the $PARALLEL variable to add any extra parameters that are
# required for the particular job

export -f print_info
export -f getTestcases

run_parallel() {
	func="$1" && shift

	count=0
	getTestcases "$@" || count=$?
	shift $count

	export -f mutex_lock
	export -f mutex_unlock

	partmpdir="$(mktemp -d -p "$DIRPATH" tmpparallel.XXXXXXXXXX)"
	printf '%s\n' "${TESTCASES[@]}" | parallel --tmpdir "$partmpdir" --joblog out.log --will-cite	--progress --bar $func {} "$@" || true
	rm -r "$partmpdir"

	print_info "Tests that failed:"
	awk -F ' ' '$7>0' < out.log | cut  -f7- | column
}

run_parallel_halt() {
	func="$1" && shift

	count=0
	getTestcases "$@" || count=$?
	shift $count

	partmpdir="$(mktemp -d -p "$DIRPATH" tmpparallel.XXXXXXXXXX)"
	printf '%s\n' "${TESTCASES[@]}" | parallel --tmpdir "$partmpdir" --halt-on-error 2 --will-cite --progress --bar "$func" {} "$@"
	rm -r "$partmpdir"
}

mutex_lock() {
	lockdir="$1"
	locked=false

	while [ $locked != true ]; do
		if command mkdir "$lockdir"; then
			locked=true
		else
			sleep 1
		fi
	done

	return 0
}

mutex_unlock() {
	lockdir="$1"
	rmdir "$lockdir"
}
