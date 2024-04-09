#!/bin/bash

# @id=ceef39e38edbce19ef299d70d5b00c2e

status="0"

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

build="$4"
if [ $status == "0" ]; then
	if ! ./-_-.sh "$tabs" "$verbose_opt" "$build"; then
		exit 1
	fi

	if  ! ./^_____^.sh "$tabs" "$verbose_opt" "$parallel" "$build"; then
		exit 1
	fi
fi

exit $status
