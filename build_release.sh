#!/bin/bash

status="0"

gcc_compile_args=("-std=c99" "-Wall" "-Werror" "-Wpedantic" "-Wextra" "-Wfloat-equal" "-Wfloat-conversion" "-Wvla")
if ! gcc "${gcc_compile_args[@]}" -O2 -c ./*.c; then
	status="1"
fi

if ! gcc -o app.exe ./*.o -lm; then
	status="1"
fi

exit $status
