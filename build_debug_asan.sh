#!/bin/bash

status="0"

if ! clang -std=c99 -DDEBUG -fcolor-diagnostics -fsanitize=address -fno-omit-frame-pointer -g ./*.c -o app.exe; then
	status="1"
fi

exit $status
