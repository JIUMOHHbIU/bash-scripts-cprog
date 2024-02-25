#!/bin/bash

status="0"

# Check options
verbose_opt=""
if [ $# -gt 3 ]; then
	echo >&2 Неправильное число параметров
	exit 160
fi

if [ -n "$3" ]; then
	if [ ! "$3" == '-v' ]; then
		echo >&2 Неправильный 3 параметр
		exit 160
	fi
	verbose_opt='-v'
fi

comparator_output=""
if [ $status == "0" ]; then
	ASAN_OPTIONS="color=always" MSAN_OPTIONS="color=always" UBSAN_OPTIONS="color=always" ./app.exe < "$1" > __tmp_out.txt 2>&1
	rc="$?"
	echo "$rc" > __tmp_rc.txt
	if [ $rc == "0" ]; then
		comparator_output=$(./func_tests/scripts/comparator.sh "$2" __tmp_out.txt "$verbose_opt" 2>&1)
		status="$?"
	else
		status=1
	fi
fi

if [ "$verbose_opt" == '-v' ]; then
	echo -e "$comparator_output"
fi

exit $status
