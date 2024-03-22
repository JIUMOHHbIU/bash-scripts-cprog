#!/bin/bash

# id=f9ce99ffd27a005c51d7a74c86d5100c

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

testing_folder="__tmp_testing"

test_in="$1"
test_out="$2"

application_out="$testing_folder"/my_$(basename "${test_out}")
appication_rc=${application_out//out/rc}

comparator_output=""
if [ $status == "0" ]; then
	ASAN_OPTIONS="color=always" MSAN_OPTIONS="color=always" UBSAN_OPTIONS="color=always" ./app.exe < "$test_in" > "$application_out" 2>&1
	rc="$?"
	echo "$rc" > "$appication_rc"
	if ! [ $rc == "0" ]; then
		# Check neg out, if possible
		if [ -f "$test_out" ]; then
			comparator_output=$(./func_tests/scripts/comparator.sh "$test_out" "$application_out" "$verbose_opt" 2>&1)
			status="$?"
		else
			status=0
		fi
	else
		status=1
	fi
fi

if [ "$verbose_opt" == '-v' ]; then
	if [ -f "$test_out" ]; then
		echo -e "$comparator_output"
	fi
fi

exit $status
