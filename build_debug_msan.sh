#!/bin/bash

if ! clang -c -std=c99 -DDEBUG -fcolor-diagnostics -fsanitize=memory -fno-omit-frame-pointer -fno-optimize-sibling-calls -O1 -fPIE -g ./*.c; then
	exit 1
fi

if ! clang -fsanitize=memory -pie -g ./*.o -o app.exe; then
	exit 1
fi

exit 0
