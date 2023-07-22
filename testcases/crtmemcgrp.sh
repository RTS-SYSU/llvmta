#!/usr/bin/env bash

set -e
set -o pipefail
set -u

if [ $# -lt 2 ]; then
	echo "Usage: $0 memlimit username" >&2
	exit 1
fi

sudo mkdir -p /sys/fs/cgroup/memory/llvmtamem
echo "$1" | sudo tee /sys/fs/cgroup/memory/llvmtamem/memory.limit_in_bytes
sudo chown "$2" /sys/fs/cgroup/memory/llvmtamem/cgroup.procs
