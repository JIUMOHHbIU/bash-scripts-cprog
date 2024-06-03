#!/bin/bash

target="app.exe"

gcc_compile_args_release=("-O2")
gcc_compile_args_default=("-c" "-std=c99" "-Wall" "-Werror" "-Wpedantic" "-Wextra" "-Wfloat-equal" "-Wfloat-conversion" "-Wvla" "-fdiagnostics-color")

gcc_link_args_release=()

if ! gcc "${gcc_compile_args_default[@]}" "${gcc_compile_args_release[@]}" ./*.c; then
    exit 1
fi

if ! gcc "${gcc_link_args_release[@]}" -o "$target" ./*.o -lm; then
    exit 1
fi

exit 0
