#!/bin/bash

# id=a22834900edca25b4ee04d8118386f40

gcc_compile_args=("-std=c99" "-Wall" "-Werror" "-Wpedantic" "-Wextra" "-Wfloat-equal" "-Wfloat-conversion" "-Wvla" "-fdiagnostics-color")

if ! gcc "${gcc_compile_args[@]}" -O2 -c ./*.c; then
	exit 1
fi

if ! gcc -o app.exe ./*.o -lm; then
	exit 1
fi

exit 0
