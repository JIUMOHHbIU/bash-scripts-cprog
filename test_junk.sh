#!/bin/bash

status="0"

passed="\033[1;32m(PASSED)\033[0m"
failed="\033[1;31m(FAILED)\033[0m"

one_level_tab="    "

./clean.sh

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

if [ $status == "0" ]; then
	if [ -f "CodeChecker.exe" ]; then
		# Run codestyle check
		# https://git.iu7.bmstu.ru/IU7-Projects/CodeChecker
		prefix="CODESTYLE"
		for file in *.c; do
			if t_output=$(./CodeChecker.exe "$file" 2>&1); then
				echo -e "$tabs""$prefix" "$passed"
			else
				# since CodeChecker is NOT properly implemented, ignore result
				# status="1"
				echo -e "$tabs""$prefix" "$failed"
			fi
			if [ -n "$t_output" ]; then
				while IFS= read -r line; do
					echo "$tabs""$one_level_tab""$line"
				done <<< "$t_output"
			fi
		done
	fi
fi

if [ $status == "0" ]; then
	# Run sc
	prefix="SHELLCHECK"
	if t_output=$(./check_scripts.sh "$tabs""$one_level_tab" "$verbose_opt" 2>&1); then
		echo -e "$tabs""$prefix" "$passed"
	else
		status="1"
		echo -e "$tabs""$prefix" "$failed"
	fi
	
	if [ -n "$t_output" ]; then
		echo "$t_output"
	fi
fi

# If scripted
if [ $status == "0" ]; then
	# Check builds
	prefix="BUILD"
	if t_output=$(./check_builds.sh "$tabs""$one_level_tab" "$verbose_opt" 2>&1); then
		echo -e "$tabs""$prefix" "$passed"
	else
		status="1"
		echo -e "$tabs""$prefix" "$failed"
	fi

	if [ -n "$t_output" ]; then
		echo "$t_output"
	fi
fi

# If buildable
if [ $status == "0" ]; then
	# Run func_tests on some builds
	prefix="USER FUNC TEST"
	if t_output=$(./check_functional_tests.sh "$tabs""$one_level_tab" "$verbose_opt" 2>&1); then
		echo -e "$tabs""$prefix" "$passed"
	else
		status="1"
		echo -e "$tabs""$prefix" "$failed"
	fi

	if [ -n "$t_output" ]; then
		echo "$t_output"
	fi
fi

# If testable
if [ $status == "0" ]; then
	# Collect coverage
	prefix="COVERAGE"
	if t_output=$(./collect_coverage.sh "$tabs""$one_level_tab" 2>&1); then
		echo -e "$tabs""$prefix" "$passed"
	else
		status="1"
		echo -e "$tabs""$prefix" "$failed"
	fi
	
	if [ -n "$t_output" ]; then
		echo "$t_output"
	fi
fi

rm -f ./*.o

exit $status
