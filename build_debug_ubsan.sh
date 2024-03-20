#!/bin/bash

if ! clang-17 -c -std=c99 -Weverything \
	-Wno-used-but-marked-unused \
	-fcolor-diagnostics \
	-Wno-declaration-after-statement \
	-Wno-unsafe-buffer-usage \
	-Wno-missing-prototypes \
	-DDEBUG -fsanitize=undefined -fno-omit-frame-pointer -g ./*.c; then
	exit 1
fi


if ! clang -fsanitize=undefined ./*.o -o app.exe; then
	exit 1
fi

exit 0
