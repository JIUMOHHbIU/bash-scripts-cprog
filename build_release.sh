#!/bin/bash

status="0"

# DEFAULT
main_compile_args=("-std=c99" "-Wall" "-Werror" "-Wpedantic" "-Wextra")

# ADD FP
# main_compile_args+=("-Wfloat-equal" "-Wfloat-conversion")

# ADD VLA
# main_compile_args+=("-Wvla")
if ! gcc "${main_compile_args[@]}" -c main.c; then
	status="1"
fi

if [ $status == "0" ]; then
	if ! gcc -o app.exe main.o -lm; then
		status="1"
	fi
fi

exit $status
