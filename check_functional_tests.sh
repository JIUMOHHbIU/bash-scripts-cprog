#!/bin/bash

status="0"

pass="\033[1;32mPASS\033[0m"
fail="\033[1;31mFAIL\033[0m"

one_level_tab="    "

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

#################################
# Run tests on different builds #
#################################
prefix="testing on"
if [ $status == "0" ]; then
	builds=("debug" "debug_asan" "debug_msan" "debug_ubsan" "release")
	for build in "${builds[@]}"; do
		./build_"$build".sh > /dev/null 2>&1
		if t_output=$(./func_tests/scripts/func_tests.sh "$tabs""$one_level_tab" "$verbose_opt" 2>&1); then
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

rm -f __tmp*

exit $status
