#!/bin/bash

# @id=2e991684cae3f331449824bf09655573

status="0"

# Check options
tabs=""
verbose_opt=""
if [ $# -gt 2 ]; then
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

testing_folder="__tmp_testing"
if [ $status == "0" ]; then
	if [ ! -d "$testing_folder" ]; then
		mkdir "$testing_folder"
	fi
	groups=("pos" "neg")

	for group in "${groups[@]}"; do
		counter=0
		successful=0
		for test_in in func_tests/data/"$group"*in*; do
			if [[ -f "$test_in" ]]; then
				if ./func_tests/scripts/~_~.sh "$tabs" "$verbose_opt" "$group" "$test_in"; then
					successful=$((successful+1))
				fi
				counter=$((counter+1))
			fi
		done

		if [ $counter -gt 0 ]; then
			echo -e "$tabs""$((successful*100/counter))"% of "$group" tests passed
		else
			echo -e "$tabs""$group": "<NO TEST CASES>"
		fi
	done
fi

exit $status
