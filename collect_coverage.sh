#!/bin/bash

# @id=746d86d2838ef6e29e24abba8a8cdbf1

status="0"

# Check options
tabs=''
if [ $# -gt 0 ]; then
	if eval echo "$1" | grep -Eo "^	*$"; then
		tabs="$tabs""$1"
	else
		echo >&2 Неправильный параметр 1: "$1"
		status="160"
	fi
fi

##########################################
# Call gcov on all .c files; 90% to pass #
##########################################
if [ $status == "0" ]; then
	for source_file in *.c; do
		coverage=$(gcov "$source_file" | grep -Eom 1 '[0-9]+\.[0-9]+%')
		coverage_int=$(echo "$coverage" | grep -Eo '^[0-9]+')
		if [ "$coverage_int" -gt "90" ]; then
			echo -e "$tabs""$source_file": "\033[1;32mCoverage ratio $coverage\033[0m"
		else
			status="1"
			echo -e "$tabs""$source_file": "\033[1;31mCoverage ratio $coverage\033[0m"
		fi
	done
fi

exit $status
