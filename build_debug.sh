#!/bin/bash

status="0"

gcc_compile_args=("-std=c99" "-Wall" "-Werror" "-Wpedantic" "-Wextra" "-Wfloat-equal" "-Wfloat-conversion" "-Wvla")
if ! gcc "${gcc_compile_args[@]}" -g -DDEBUG -c -fprofile-arcs -ftest-coverage -O0 ./*.c; then
	status="1"
fi

if ! gcc -fprofile-arcs -ftest-coverage -o app.exe ./*.o -lm; then
	status="1"
fi

exit $status
