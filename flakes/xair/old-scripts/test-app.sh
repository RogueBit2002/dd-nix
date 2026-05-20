#!/bin/sh
set -eu

if [ $# -eq 0 ]; then
	echo "No command provided"
	exit 1
fi


here=$(dirname $0)

unit="run-p23287-i23288.scope"

echo $unit

name="cmd-$(date +%s%N)"

systemd-run \
	--scope \
	--user \
	--quiet \
	--property=After="${unit}" \
	--property=PartOf="${unit}" \
	--description="Scope for: $*" \
	-- "$@"
