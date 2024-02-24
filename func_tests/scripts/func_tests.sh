#!/bin/bash

status="0"

pass="\033[1;32mPASS\033[0m"
fail="\033[1;31mFAIL\033[0m"

# Check options
tabs=''
if [ $# -gt 1 ]; then
	echo >&2 Неправильное число параметров
	status="160"
fi

if [ $# -gt 0 ]; then
	if eval echo "$1" | grep -Eo "^	*$"; then
		tabs="$tabs""$1"
	else
		echo >&2 Неправильный параметр 1: "$1"
		status="160"
	fi
fi

if [ $status == "0" ]; then
	groups=("pos" "neg")
	for group in "${groups[@]}"; do
		counter=0
		successful=0

		for test_path in func_tests/data/"$group"*in*; do
			if [[ -f "$test_path" ]]; then
				passed="1"
				if [ "$group" == "pos" ]; then
					./func_tests/scripts/"$group"_case.sh "$test_path" "${test_path//in/out}"
					passed=$?
				else
					./func_tests/scripts/"$group"_case.sh "$test_path"
					passed=$?
				fi
				filename="${test_path//"func_tests/data/"/""}"
				if [ $passed == "0" ]; then
					successful=$((successful+1))
					echo -e "$tabs""$group" "$filename": "$pass"
				else
					status="1"
					echo -e "$tabs""$group" "$filename": "$fail"
				fi
				counter=$((counter+1))
			fi
		done

		if [ $counter -gt 0 ]; then
			echo -e "$tabs""$((successful*100/counter))"% of "$group" tests passed
		fi
	done
fi

exit $status
