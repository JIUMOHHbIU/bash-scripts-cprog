#!/bin/bash

# id=b9002bc1f61e97bb98a3a282b32d5541

status="0"

# Check options
tabs=""
if [ $# -gt 0 ]; then
	if eval echo "$1" | grep -Eo "^	*$"; then
		tabs="$tabs""$1"
	else
		echo >&2 Неправильный параметр 1: "$1"
		status="160"
	fi
fi

if [ $status == "0" ]; then
	if [ -f "CodeChecker.exe" ]; then
		# Run codestyle check
		# https://git.iu7.bmstu.ru/IU7-Projects/CodeChecker
		for file in *.c; do
			t_output=$(./CodeChecker.exe "$file" 2>&1)
			# rc="$?"
			# if [ $status == "0" ]; then
			# 	status="$rc"
			# fi
			
			if [ -n "$t_output" ]; then
				while IFS= read -r line; do
					echo "$tabs""$line"
				done <<< "$t_output"
			fi
		done
	fi
fi

exit $status
