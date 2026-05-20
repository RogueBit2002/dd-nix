#!/bin/sh

while [ "$#" -gt 0 ]; do
    case "$1" in
        --)
            shift
            break
            ;;
    esac
    shift
done

if [ "$#" -eq 0 ]; then
	echo "No pid provided"
	exit 1
fi

pid="$1"

case "$pid" in
    ''|*[!0-9]*)
    	echo "Invalid PID: $pid"
		exit 1
		;;
esac

if ! [ -d "/proc/$pid" ]; then
	echo "Process with PID "$pid" does not exist"
fi

name=$(systemd-escape "xair-app-"$pid".scope")

busctl call --user org.freedesktop.systemd1 /org/freedesktop/systemd1 \
    	org.freedesktop.systemd1.Manager StartTransientUnit 'ssa(sv)a(sa(sv))' \
		"$name" fail 1 PIDs au 1 "$pid" 0
