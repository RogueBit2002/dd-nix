#!/bin/sh

pid=$$

split=0
for arg in "$@"; do
	if [ "$arg" = "--" ]; then
		found=1
		break
	fi
	split=$((split+1))
done

if ! [ -n "$found" ]; then
	echo "no -- command segment"
	exit 1
fi

(
	total="$#"
	for i in $(seq 1 "$split")
	do
		eval "arg=\${$i}"
		#arg=$(eval "\${$i}")
		set -- "$@" "$arg"
	done

	shift "$total"
	./xair.sh "$@"
) &

shift "$(($split + 1))"

exec "$@"
