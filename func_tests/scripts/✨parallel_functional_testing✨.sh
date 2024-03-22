#!/bin/bash

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
	groups=("pos" "neg")

	if [ ! -d "$testing_folder" ]; then
		mkdir "$testing_folder"
	fi
	for group in "${groups[@]}"; do
		counter=$(find ./func_tests/data/"$group"*_in* 2> /dev/null | wc -l)
		unsuccessful=0
		if [ "$counter" -gt 0 ]; then
			parallel "./func_tests/scripts/✨run_solo_test_case✨.sh" ::: "$tabs" ::: "$verbose_opt" ::: "$group" ::: func_tests/data/"$group"*in*
			unsuccessful=$((unsuccessful + $?))
		fi

		if [ "$counter" -gt 0 ]; then
			echo -e "$tabs""$(((counter-unsuccessful)*100/counter))"% of "$group" tests passed
		else
			echo -e "$tabs""$group": "<NO TEST CASES>"
		fi
	done
fi

exit $status
