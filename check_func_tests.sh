#!/bin/bash

status="0"

pass="\033[1;32mPASS\033[0m"
fail="\033[1;31mFAIL\033[0m"

# Check options
tabs=''
if [ $# -gt 1 ]; then
	echo >&2 Неправильное число параметров
	status="1"
fi

if [ $# -gt 0 ]; then
	if eval echo "$1" | grep -Eo "^	*$"; then
		tabs="$tabs""$1"
	else
		echo >&2 Неправильный параметр 1: "$1"
		status="1"
	fi
fi

prefix="testing on"
if [ $status == "0" ]; then
	builds=("debug_asan" "debug_msan" "debug_ubsan")
	for build in "${builds[@]}"; do
		./clean.sh
		./build_"$build".sh
		if t_output=$(./func_tests/scripts/func_tests.sh "$tabs""	"); then
			echo -e "$tabs""$prefix" "$build": "$pass"
		else
			status="1"
			echo -e "$tabs""$prefix" "$build": "$fail"
		fi
		if [ -n "$t_output" ]; then
			echo "$t_output"
		fi
	done
fi

./clean.sh

exit $status
