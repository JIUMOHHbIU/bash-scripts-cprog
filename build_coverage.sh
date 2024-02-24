#!/bin/bash

status="0"

# DEFAULT
main_compile_args=("-std=c99" "-Wall" "-Werror" "-Wpedantic" "-Wextra")

# ADD FP
# main_compile_args+=("-Wfloat-equal" "-Wfloat-conversion")

# ADD VLA
# main_compile_args+=("-Wvla")
if ! gcc "${main_compile_args[@]}" -g -DDEBUG -c -fprofile-arcs -ftest-coverage main.c; then
	status="1"
fi

if [ $status == "0" ]; then
	if ! gcc -O0 -fprofile-arcs -ftest-coverage -o app.exe main.o -lm; then
		status="1"
	fi
fi

exit $status
