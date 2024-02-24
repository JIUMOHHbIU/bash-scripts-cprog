#!/bin/bash

status="0"

# DEFAULT
main_compile_args=("-std=c99" "-Wall" "-Werror" "-Wpedantic" "-Wextra")

# ADD FP
# main_compile_args+=("-Wfloat-equal" "-Wfloat-conversion")

# ADD VLA
# main_compile_args+=("-Wvla")
if ! clang "${main_compile_args[@]}" -DDEBUG -fsanitize=memory -fno-omit-frame-pointer -fPIE -pie -g main.c -o app.exe; then
	status="1"
fi

exit $status
