#!/bin/sh


bench-it() {
	time_a=$(date +%s%N)
	i=1
	while [ "$i" -le 10 ]; do
    	#$@ >/dev/null 2>&1
    	$@ 
    	i=$((i + 1))
	done
	time_b=$(date +%s%N)

	diff=$(($time_b - $time_a))
	echo "duration: $(($diff / 1000)) microseconds"
	echo "duration: $(($diff / 1000 / 1000)) milliseconds"
}

echo "Benching app2unit"
bench-it app2unit -- sleep 0.1

sleep 3

echo "Benching xair-app"
bench-it ./result/bin/xair-app -- sleep 0.1

sleep 2

echo "Benching xair-app --defer"
bench-it ./result/bin/xair-app --defer -- sleep 0.1
