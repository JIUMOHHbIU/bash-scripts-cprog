#!/bin/bash

# @id=f8535641c3004508f358dfafce2356bc

status="0"

pass="\033[1;32mPASS\033[0m"
fail="\033[1;31mFAIL\033[0m"

one_level_tab="    "

# Check options
tabs=""
verbose_opt=""
parallel=""
if [ $# -gt 4 ]; then
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
			if [ "$1" == "--parallel" ]; then
				parallel="--parallel"
			else
				echo >&2 Неправильный параметр 1: "$1"
				status="160"
			fi
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
			if [ "$2" == "--parallel" ]; then
				parallel="--parallel"
			else
				echo >&2 Неправильный параметр 2: "$2"
				status="160"
			fi
		fi
	fi
fi

if [ $# -gt 2 ]; then
	if [ "$3" == '-v' ]; then
		verbose_opt='-v'
	else
		if eval echo "$3" | grep -Eo "^	*$"; then
			tabs="$tabs""$3"
		else
			if [ "$3" == "--parallel" ]; then
				parallel="--parallel"
			else
				echo >&2 Неправильный параметр 3: "$3"
				status="160"
			fi
		fi
	fi
fi

build="$4"

prefix="testing on"
if [ $status == "0" ]; then
	cd __tmp_out_"$build" || exit 1
	next_tabs_level="$tabs""$one_level_tab"

	rm ./*.gcda 2> /dev/null

	if [ -n "$parallel" ]; then
		t_output=$("./func_tests/scripts/✨parallel_functional_testing✨.sh" "$next_tabs_level" "$verbose_opt" 2>&1)
		status="$?"
	else
		t_output=$(./func_tests/scripts/func_tests.sh "$next_tabs_level" "$verbose_opt" 2>&1)
		status="$?"
	fi
	if [ $status == "0" ]; then
		echo -e "$tabs""$prefix" "$build": "$pass"
	else
		status="1"
		echo -e "$tabs""$prefix" "$build": "$fail"
	fi
	if [ -n "$t_output" ]; then
		echo "$t_output"
	fi
fi

exit $status
