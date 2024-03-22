#!/bin/bash

# id=78cba5a9761be74c367f2d52fe352c60

status="0"

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

##############################
# Run all build_*.sh scripts #
##############################
builds=("release" "debug" "debug_asan" "debug_msan" "debug_ubsan")
if [ $status == "0" ]; then
	current_hashsum=$(find ./func_tests/data/ -name "*.txt" ! -path '*__tmp_out*' -exec md5sum {} + | md5sum | cut -d ' ' -f 1)
	if [ -n "$parallel" ]; then
		parallel -k ./copy_and_test.sh ::: "$tabs" ::: "$verbose_opt" ::: "$parallel" ::: "${builds[@]}" ::: "${current_hashsum[0]}"
		rc=$?
		if [ $status == "0" ]; then
			status="$rc"
		fi
	else
		for build in "${builds[@]}"; do
			./copy_and_test.sh "$tabs" "$verbose_opt" "$parallel" "$build" "$current_hashsum"
			rc=$?
			if [ $status == "0" ]; then
				status="$rc"
			fi
		done
	fi
fi

exit $status
