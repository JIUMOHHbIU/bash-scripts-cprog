#!/bin/bash

if ! clang-17 -c -std=c99 -Weverything \
	-Wno-used-but-marked-unused \
	-fcolor-diagnostics \
	-Wno-declaration-after-statement \
	-Wno-unsafe-buffer-usage \
	-Wno-missing-prototypes \
	-DDEBUG -fsanitize=memory -fno-omit-frame-pointer -fno-optimize-sibling-calls -O1 -fPIE -g ./*.c; then
	exit 1
fi

if ! clang -fsanitize=memory -pie ./*.o -o app.exe; then
	exit 1
fi

exit 0
