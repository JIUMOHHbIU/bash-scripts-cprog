#!/bin/bash

status="0"

tmpfile=$(mktemp /tmp/tfile.XXXXXX)

if ./app.exe < "$1" > "$tmpfile"; then
	./func_tests/scripts/comparator.sh "$tmpfile" "$2"
	status="$?"
else
	status=1
fi

exit $status
