#!/bin/bash

status="0"

one_level_tab="    "

pass="\033[1;32mPASS\033[0m"
failed="\033[1;31mFAILED\033[0m"

# Check options
tabs=''
verbose_opt=''
if [ $# -gt 2 ]; then
	echo >&2 Неправильное число параметров
	status="1"
fi

if [ $# -gt 0 ]; then
	if [ "$1" == '-v' ]; then
		verbose_opt='-v'
	else
		if eval echo "$1" | grep -Eo "^	*$"; then
			tabs="$tabs""$1"
		else
			echo >&2 Неправильный параметр 1: "$1"
			status="1"
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
			status="1"
		fi
	fi
fi

# Full shellcheck, ignore SC2013 https://www.shellcheck.net/wiki/SC2013
sc_opts=("-a" "-C" "-e" "SC2013")

# Only yellow or worse, ignore SC2013
# sc_opts=("--severity=warning" "-a" "-C" "-e" "SC2013")

###############################
# Run shellcheck on .sh files #
###############################
prefix="script"
while IFS= read -r -d '' script
do
	if t_output=$(shellcheck "${sc_opts[@]}" "$script"); then
		echo -e "$tabs""$prefix" "$script": "$pass"
	else
		echo -e "$tabs""$prefix" "$script": "$failed"
		status="1"
	fi

	if [ "$verbose_opt" == '-v' ]; then
		if [ -n "$t_output" ]; then
			while IFS= read -r line; do
				echo -e "$tabs""$one_level_tab""$line"
			done <<< "$t_output"
		fi
	fi
done <   <(find . -name "*.sh" -print0)

exit $status
