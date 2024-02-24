#!/bin/bash

status="0"

tmpfile=$(mktemp /tmp/tfile.XXXXXX)


if ./app.exe < "$1" > "$tmpfile"; then
	status=1
else
	status=0
fi

exit $status