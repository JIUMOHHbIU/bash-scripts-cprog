#!/bin/bash

status="0"

pass="\033[1;32mPASS\033[0m"
fail="\033[1;31mFAIL\033[0m"

one_level_tab="    "

# Check options
tabs=""
verbose_opt=""
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

group="$3"
test_in="$4"

filename="${test_in//"func_tests/data/"/""}"
test_out="${test_in//in/out}"

testing_folder="__tmp_testing"
application_out="$testing_folder"/my_$(basename "${test_out}")
appication_rc="${application_out//out/rc}"

if t_output=$(./func_tests/scripts/"$group"_case.sh "$test_in" "$test_out" "$verbose_opt"); then
	successful=$((successful+1))
	if [ "$verbose_opt" == '-v' ]; then
		echo -e "$tabs""$group" "$filename": "$pass"
	fi
else
	status="1"
	echo -e "$tabs""$group" "$filename": "$fail" "|" rc: "$(cat "$appication_rc")"

	echo

	# Print input file
	echo -e "$tabs""$one_level_tab"input:
	while IFS= read -r line; do
		echo -e "$tabs""$one_level_tab""$one_level_tab""$line"
	done <<< "$(cat "${test_in}")"

	# Print ref output file
	echo -e "$tabs""$one_level_tab"expected:
	if [ -f "$test_out" ]; then
		while IFS= read -r line; do
			echo -e "$tabs""$one_level_tab""$one_level_tab""$line"
		done <<< "$(cat "$test_out")"
	else
		echo "$tabs""$one_level_tab""$one_level_tab""<EMPTY FILE>"
	fi

	# Print application output
	echo -e "$tabs""$one_level_tab"got:
	if [ -f "$application_out" ]; then
		while IFS= read -r line; do
			echo -e "$tabs""$one_level_tab""$one_level_tab""$line"
		done <<< "$(cat "$application_out")"
	else
		echo "$tabs""$one_level_tab""$one_level_tab""<EMPTY FILE>"
	fi

	if [ "$verbose_opt" == '-v' ]; then
		# Print comparator view
		echo -e "$tabs""$one_level_tab"comparator output:
		if [ -n "$t_output" ]; then
			while IFS= read -r line; do
				echo -e "$tabs""$one_level_tab""$one_level_tab""$line"
			done <<< "$t_output"
		else
			echo "$tabs""$one_level_tab""$one_level_tab""<EMPTY FILE>"
		fi
	fi

	echo
fi

exit $status
