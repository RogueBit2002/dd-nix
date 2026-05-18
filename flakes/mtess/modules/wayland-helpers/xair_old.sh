#!/bin/sh


while getopts "p:u:" opt
do
    case "$opt" in
        p)
            pid="$OPTARG"
			case "$pid" in
    			''|*[!0-9]*)
        			echo "Invalid PID: $pid"
        			exit 1
        		;;
			esac
            ;;
		u)
			unit="$OPTARG"
			;;
        *)
			echo "Error: invalid options"
            exit 1
            ;;
    esac
done

shift $((OPTIND - 1))

if [ -n "$unit" ] && [ -n "$pid" ]; then
	echo "Error: -u(nit) and -p(id) are mutually exclusive" 
	exit 1
fi

if [ "$1" = "--" ]; then
    shift
fi

if [ "$#" -eq 0 ]; then
	echo "Error: no pid"
	exit 1
fi	

if [ -n "$pid" ]; then
	cgroup="/proc/$pid/cgroup"
	if ! [ -r "$cgroup" ]; then
		echo "Error: failed to read $cgroup"
		exit 1
	fi

	unit=$(grep -oE '[^/]+\.(service|scope)' "$cgroup" 2>/dev/null | tail -n1)

	if [ -z "$unit" ]; then
		echo "Error: failed to find a parent service or scope for $pid"
		exit 1
	fi
fi

if [ -n "$unit" ]; then
	if ! systemctl --user --quiet is-active "$unit"; then
		echo "Error: unit ${unit} is not active"
		exit 1
	fi
fi

name=$(systemd-escape "xair-app-$$.scope")

if ! [ -n "$unit" ]; then
	busctl call --user org.freedesktop.systemd1 /org/freedesktop/systemd1 \
    	org.freedesktop.systemd1.Manager StartTransientUnit 'ssa(sv)a(sa(sv))' \
		"$name" fail 2 PIDs au 1 $$ Description s "$description" 0 &
else
	busctl call --user org.freedesktop.systemd1 /org/freedesktop/systemd1 \
		org.freedesktop.systemd1.Manager StartTransientUnit 'ssa(sv)a(sa(sv))' \
		"$name" fail 4 PIDs au 1 $$ Description s "$description" After as 1 "$unit" PartOf as 1 "$unit" 0 &
fi

exec "$@"
