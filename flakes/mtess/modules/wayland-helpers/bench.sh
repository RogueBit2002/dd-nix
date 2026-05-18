#!/bin/sh


bench-it() {
	time_a=$(date +%s%N)
	i=1
	while [ "$i" -le 10 ]; do
    	$@ >/dev/null 2>&1
    	i=$((i + 1))
	done
	time_b=$(date +%s%N)

	diff=$(($time_b - $time_a))
	echo "duration: $(($diff / 1000)) microseconds"
	echo "duration: $(($diff / 1000 / 1000)) milliseconds"
}

echo "Benching app2unit"
bench-it app2unit -- kitty -e sleep 0.4

sleep 3
echo "Benching xair-app"
bench-it ./xair-app.sh -- kitty -e sleep 0.4
