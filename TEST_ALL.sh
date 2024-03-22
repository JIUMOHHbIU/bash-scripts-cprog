#!/bin/bash

status="0"

passed="\033[1;32m(PASSED)\033[0m"
failed="\033[1;31m(FAILED)\033[0m"

# Check options
tabs=""
verbose_opt=""
parallel=""
if [ $# -gt 3 ]; then
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

script_python="\
import sys
lines = sys.stdin.read().split('\n')
for line in lines:
	if len(line) > 0 and line[0] == '*':
		print(line.split(' ')[1].strip())
"

t=$(git branch | python3 -c "$script_python")
if [ -n "$parallel" ]; then
	t_output=$(parallel -k --bar ./TEST_SINGULAR.sh ::: "$tabs" ::: "$verbose_opt" ::: "$parallel" ::: $t*/test_junk.sh)
	status="$?"

	echo "$t_output"
else
	for test_path in $t*/test_junk.sh; do
		if [[ -f "$test_path" ]]; then
			./TEST_SINGULAR.sh "$tabs" "$verbose_opt" "$parallel" "$test_path"
			rc="$?"
			if [ $status == "0" ]; then
				status="$rc"
			fi
		fi
	done
fi

echo
prefix="verdict:"
if [ $status == "0" ]; then
	echo -e "$tabs""$prefix" "$passed"
else
	echo -e "$tabs""$prefix" "$failed"
fi

exit $status
