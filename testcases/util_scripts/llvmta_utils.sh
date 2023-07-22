#!/usr/bin/env bash

set -e
set -o pipefail
set -u

source "util_scripts/OptionHandler.sh" || true

readonly ALL_OPTS=( ""
	"--enable-optimizations"
	"--disable-hard-floatingpoint"
	"--enable-optimizations --disable-hard-floatingpoint"
	)

get_ctx_flags() {
	local CTX_FLAGS=()

	CTX_FLAGS=( "Arm" )
	if optIn "--llvmta-isa" "$@"; then
		if [ "$(optVal "--llvmta-isa" "$@")" == "riscv" ]; then
			CTX_FLAGS=( "RiscV" )
		fi
	fi

	if optIn "--enable-optimizations" "$@"; then
		CTX_FLAGS+=( "Optimized" )
	else
		CTX_FLAGS+=( "NotOptimized" )
	fi

	if optIn "--disable-hard-floatingpoint" "$@"; then
		CTX_FLAGS+=( "SoftFloat" )
	else
		CTX_FLAGS+=( "HardFloat" )
	fi

	printf -v tmp '%s|' "${CTX_FLAGS[@]}"
	echo "${tmp%?}"
}
