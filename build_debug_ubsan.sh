#!/bin/bash

status="0"

if ! clang -DDEBUG -fsanitize=undefined -fno-omit-frame-pointer -g ./*.c -o app.exe; then
	status="1"
fi

exit $status
