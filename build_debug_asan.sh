#!/bin/bash

target="app.exe"

clang_compile_args_debug_asan=("-g" "-DDEBUG" "-fsanitize=address" "-fno-omit-frame-pointer" "-fno-optimize-sibling-calls")
clang_compile_args_default=("-c" "-std=c99" "-Weverything" "-Wno-used-but-marked-unused" "-fcolor-diagnostics" "-Wno-declaration-after-statement" "-Wno-unsafe-buffer-usage" "-Wno-missing-prototypes")

clang_link_args_debug_asan=("-fsanitize=address")

if ! clang-17 "${clang_compile_args_default[@]}" "${clang_compile_args_debug_asan[@]}" ./*.c; then
    exit 1
fi

if ! clang-17 "${clang_link_args_debug_asan[@]}" -o "$target" ./*.o; then
    exit 1
fi

exit 0
