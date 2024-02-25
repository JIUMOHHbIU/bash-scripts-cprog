#!/bin/bash

status="0"

# Check options
verbose_opt=""
if [ $# -gt 3 ]; then
	echo >&2 Неправильное число параметров
	exit 160
fi

if [ -n "$3" ]; then
	if [ ! "$3" == '-v' ]; then
		echo >&2 Неправильный 3 параметр
		exit 160
	fi
	verbose_opt='-v'
fi

if [ $status == "0" ]; then
	tmpfile=$(mktemp /tmp/tfile.XXXXXX)

	if ASAN_OPTIONS="color=always" MSAN_OPTIONS="color=always" UBSAN_OPTIONS="color=always" ./app.exe < "$1" > "$tmpfile" 2>&1; then
		./func_tests/scripts/comparator.sh "$tmpfile" "$2" "$verbose_opt"
		status="$?"
	else
		status=1
	fi
fi

if [ $status == "1" ] && [ "$verbose_opt" == '-v' ]; then
	cat "$tmpfile"
fi

rm -f "$tmpfile"

exit $status
