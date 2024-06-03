#!/bin/bash

target="app.exe"

clang_compile_args_debug_msan=("-g" "-DDEBUG" "-fsanitize=memory" "-fno-omit-frame-pointer" "-fno-optimize-sibling-calls" "-fPIE" "-O1")
clang_compile_args_default=("-c" "-std=c99" "-Weverything" "-Wno-used-but-marked-unused" "-fcolor-diagnostics" "-Wno-declaration-after-statement" "-Wno-unsafe-buffer-usage" "-Wno-missing-prototypes")

clang_link_args_debug_msan=("-fsanitize=memory" "-pie")

if ! clang-17 "${clang_compile_args_default[@]}" "${clang_compile_args_debug_msan[@]}" -g ./*.c; then
    exit 1
fi

if ! clang-17 "${clang_link_args_debug_msan[@]}" -o "$target" ./*.o; then
    exit 1
fi

exit 0
