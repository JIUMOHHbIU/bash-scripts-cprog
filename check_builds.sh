#!/bin/bash

status="0"

pass="\033[1;32mPASS\033[0m"
fail="\033[1;31mFAIL\033[0m"

# Check options
tabs=""
verbose_opt=""
if [ $# -gt 2 ]; then
	echo >&2 Неправильное число параметров
	status="160"
fi

if [ $# -gt 0 ]; then
	if [ "$1" == '-v' ]; then
		verbose_opt='-v'
	else
		if eval echo "$1" | grep -Eo "^	*$"; then
			tabs="$tabs""$1"
		else
			echo >&2 Неправильный параметр 1: "$1"
			status="160"
		fi
	fi
fi

if [ $# -gt 1 ]; then
	if [ "$2" == '-v' ]; then
		verbose_opt='-v'
	else
		if eval echo "$2" | grep -Eo "^	*$"; then
			tabs="$tabs""$2"
		else
			echo >&2 Неправильный параметр 2: "$2"
			status="160"
		fi
	fi
fi

prefix="build"
builds=("release" "debug" "debug_asan" "debug_msan" "debug_ubsan" "coverage")
for build in "${builds[@]}"; do
	if [ $status == "0" ]; then
		./clean.sh
		if t_output=$(./build_"$build".sh "$tabs""	"); then
			echo -e "$tabs""$prefix" "$build": "$pass"
		else
			status="1"
			echo -e "$tabs""$prefix" "$build": "$fail"
		fi

		if [ "$verbose_opt" == '-v' ]; then
			if [ -z "$t_output" ]; then
				echo "$t_output"
			fi
		fi
	fi
done

./clean.sh

exit $status
