#!/bin/sh
set -eu

if [ $# -eq 0 ]; then
	echo "No command provided"
	exit 1
fi

here=$(dirname $0)
echo "Searching pid"
pid=$($here/get-pid.sh)
echo "Got PID: $pid"

unit=$(cat /proc/"$pid"/cgroup | grep -oE '[^/]+\.(service|scope)' /proc/$pid/cgroup | tail -n1)
echo $unit
exit 0
name="cmd-$(date +%s%N)"

systemd-run \
	--scope \
	--user \
	--quiet \
	--property=After="${unit}" \
	--property=PartOf="${unit}" \
	--description="Scope for: $*" \
	-- "$@"
