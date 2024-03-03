#!/bin/bash

if ! clang -c -std=c99 -DDEBUG -fcolor-diagnostics -fsanitize=undefined -fno-omit-frame-pointer -g ./*.c; then
	exit 1
fi

if ! clang -fsanitize=undefined ./*.o -o app.exe; then
	exit 1
fi

exit 0
