#!/bin/bash

status="0"

if ! clang -DDEBUG -fsanitize=memory -fno-omit-frame-pointer -fPIE -pie -g ./*.c -o app.exe; then
	status="1"
fi

exit $status
