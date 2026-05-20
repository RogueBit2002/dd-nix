pid=$$

split=
defer=

i=1
for arg do
	case $arg in
		--defer)
			defer=1
			;;
		--)
			split=$i
			break;
			;;
	esac
	i=$((i+1))
done

if ! [ -n "$split" ]; then
	echo "no -- command segment"
	exit 1
fi

(
	total="$#"
	for i in $(seq 1 "$((split-1))")
	do
		eval "arg=\${$i}"
		set -- "$@" "$arg"
	done

	shift "$total"
	xair-scopify "$@" -- "$pid"
) &

scopify_pid=$!

if ! [ -n "$defer" ]; then
	wait "$scopify_pid"
fi

shift "$split"

exec "$@"
