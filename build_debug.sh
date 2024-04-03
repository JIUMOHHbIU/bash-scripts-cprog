#!/bin/bash

# @id=ca88af60f876ce55f959cafa0a6e0b13

gcc_compile_args=("-std=c99" "-Wall" "-Werror" "-Wpedantic" "-Wextra" "-Wfloat-equal" "-Wfloat-conversion" "-Wvla" "-fdiagnostics-color")

if ! gcc "${gcc_compile_args[@]}" -g -DDEBUG -c -fprofile-arcs -ftest-coverage -O0 ./*.c; then
	exit 1
fi

if ! gcc -fprofile-arcs -o app.exe ./*.o -lm; then
	exit 1
fi

exit 0
