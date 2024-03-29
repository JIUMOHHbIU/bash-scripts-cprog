#!/bin/bash

# id=416ada327c6e82e7bfa8194c2e12432b

status="0"

passed="\033[1;32m(PASSED)\033[0m"
failed="\033[1;31m(FAILED)\033[0m"

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

test_path="$4"

if [ $status == "0" ]; then
	prefix="${test_path//"/test_junk.sh"/""}"
	cd "$prefix"

	./clean.sh
	if t_output=$(./test_junk.sh "$tabs""$one_level_tab" "$verbose_opt" "$parallel"); then
		echo -e "$tabs""$prefix" "$passed"
	else
		status="1"
		echo -e "$tabs""$prefix" "$failed"
	fi
	echo "$t_output"
	./clean.sh
fi

exit $status
