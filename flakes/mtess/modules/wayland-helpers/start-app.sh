#!/bin/sh
set -eu

if [ $# -eq 0 ]; then
	echo "No command provided"
	exit 1
fi


here=$(dirname $0)
pid=$($here/get-pid.sh)

unit=$(cat /proc/"$pid"/cgroup | grep -o '[^/]*\.service$')

echo $unit

name="cmd-$(date +%s%N)"

systemd-run \
	--scope \
	--user \
	--quiet \
	--collect \
	--unit="$name" \
	--property=After="${unit}" \
	--property=BindsTo="${unit}" \
	--property=PartOf="${unit}" \
	--description="Scope for: $*" \
	-- "$@"
