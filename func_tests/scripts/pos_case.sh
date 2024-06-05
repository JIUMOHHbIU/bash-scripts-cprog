#!/bin/bash

status="0"

test_in="../data/$(basename "${1}")"
test_out="../data/$(basename "${2}")"
verbose_opt="$3"

testing_folder="../../__tmp_testing"

application_out="$testing_folder"/my_$(basename "${test_out}")
appication_rc=${application_out//out/rc}

comparator_output=""
ASAN_OPTIONS="color=always" MSAN_OPTIONS="color=always" UBSAN_OPTIONS="color=always" ./../../app.exe < "$test_in" > "$application_out" 2>&1
rc="$?"
echo "$rc" > "$appication_rc"
if [ $rc == "0" ]; then
    comparator_output=$(./comparator.sh "$test_out" "$application_out" "$verbose_opt" 2>&1)
    status="$?"
else
    status=1
fi

if [ "$verbose_opt" == '-v' ]; then
    echo -e "$comparator_output"
fi

exit $status
