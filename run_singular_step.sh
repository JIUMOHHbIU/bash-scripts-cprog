#!/bin/bash

# id=dcc092a92b94901bf0bba0fdd0efe317

status="0"

passed="\033[1;32m(PASSED)\033[0m"
failed="\033[1;31m(FAILED)\033[0m"

one_level_tab="    "

# Check options
tabs=""
verbose_opt=""
parallel=""
if [ $# -gt 5 ]; then
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

prefix="$4"
step="$5"
if [ $status == "0" ]; then
	echo -n "$tabs""$prefix"
	if t_output=$("$step" "$tabs""$one_level_tab" "$verbose_opt" "$parallel" 2>&1); then
		echo -e " $passed"
	else
		status="1"
		echo -e " $failed"
	fi

	if [ -n "$t_output" ]; then
		echo -e "$t_output"
	fi
fi

exit $status
