#!/bin/bash

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
current_hashsum="$4"
if [ $status == "0" ]; then
	if [ ! -d __tmp_out_"$build" ]; then
		mkdir __tmp_out_"$build"
	fi
	cp ./*.c __tmp_out_"$build"/
	cp ./*.h __tmp_out_"$build"/ 2>/dev/null
	cp build_"$build".sh __tmp_out_"$build"/
	cp collect_coverage.sh __tmp_out_"$build"/

	mkdir -p __tmp_out_"$build"/func_tests/data/

	if [ -f __tmp_out_"$build"/tests_hashsum ]; then
		old_hashsum=$(cat __tmp_out_"$build"/tests_hashsum)
		if [ "$current_hashsum" != "$old_hashsum" ]; then
			cp func_tests/data/*.txt __tmp_out_"$build"/func_tests/data/		
			echo "$current_hashsum" > __tmp_out_"$build"/tests_hashsum
		fi
	else
		cp func_tests/data/*.txt __tmp_out_"$build"/func_tests/data/	
		echo "$current_hashsum" > __tmp_out_"$build"/tests_hashsum
	fi
	# cp func_tests/data/*.txt __tmp_out_"$build"/func_tests/data/	
	mkdir -p __tmp_out_"$build"/func_tests/scripts/
	cp func_tests/scripts/*.sh __tmp_out_"$build"/func_tests/scripts/

	cd __tmp_out_"$build" || exit 1
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
