#!/bin/bash

# @id=72c828e6a6052726de6278dfa6217415

status="0"

pass="\033[1;32mPASS\033[0m"
fail="\033[1;31mFAIL\033[0m"

one_level_tab="    "

# Check options
tabs=""
verbose_opt=""
if [ $# -gt 4 ]; then
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

build="$3"
dir_path=__tmp_out_"$build"
if [ $status == "0" ]; then
	if [ ! -d "$dir_path" ]; then
		mkdir "$dir_path"
	fi

	if [ -f ./"$dir_path"/clean.sh ]; then
	# Remove all cache
		cd "$dir_path" || exit 1
		./clean.sh
		cd .. || exit 1
	fi

# Remove all links
	find ./"$dir_path"/ -maxdepth 3 -type l -delete

# Setup dirs
	mkdir -p "$dir_path"/func_tests/data/ "$dir_path"/func_tests/scripts/

# Create links
	find . -maxdepth 1 -name "*.c" -exec ln -srt "$dir_path" {} +
	find . -maxdepth 1 -name "*.h" -exec ln -srt "$dir_path" {} +
	find ./func_tests/scripts/ -name "*.sh" -exec ln -srt "$dir_path"/func_tests/scripts/ {} +
	find ./func_tests/data/ -name "*.txt" -exec ln -srt "$dir_path"/func_tests/data/ {} +
	ln -sr build_"$build".sh collect_coverage.sh clean.sh "$dir_path"/

	cd "$dir_path" || exit 1
	prefix="build"
	if t_output=$(./build_"$build".sh 2>&1); then
		if [ "$verbose_opt" == '-v' ]; then
			echo -e "$tabs""$prefix" "$build": "$pass"
		fi
	else
		status="1"
		echo -e "$tabs""$prefix" "$build": "$fail"
	fi

	if [ -n "$t_output" ]; then
		echo
		while IFS= read -r line; do
			echo -e "$tabs""$one_level_tab""$line"
		done <<< "$t_output"
		echo
	fi
fi

exit $status
