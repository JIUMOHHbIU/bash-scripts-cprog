#!/bin/bash

status="0"

test_in="$1"
test_out="$2"
verbose_opt="$3"

testing_folder="__tmp_testing"

application_out="$testing_folder"/my_$(basename "${test_out}")
appication_rc=${application_out//out/rc}

comparator_output=""
ASAN_OPTIONS="color=always" MSAN_OPTIONS="color=always" UBSAN_OPTIONS="color=always" ./app.exe < "$test_in" > "$application_out" 2>&1
rc="$?"
echo "$rc" > "$appication_rc"
if ! [ $rc == "0" ]; then
    if [ -f "$test_out" ]; then
        comparator_output=$(./func_tests/scripts/comparator.sh "$test_out" "$application_out" "$verbose_opt" 2>&1)
        status="$?"
    else
        status=0
    fi
else
    status=1
fi

if [ "$verbose_opt" == '-v' ]; then
    if [ -f "$test_out" ]; then
        echo -e "$comparator_output"
    fi
fi

exit $status
