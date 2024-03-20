#!/bin/bash

obj_suffix=".debug_msan.o"
for source_file in *.c; do
	o_file="${source_file//.c/$obj_suffix}"
	if [ -f "$o_file" ]; then
		o_modification_date=$(date -r "$o_file" +%s)
		c_modification_date=$(date -r "$source_file" +%s)
		last_modification_date="$c_modification_date"

		h_file="${source_file//.c/.h}"
		if [ -f "$h_file" ]; then
			h_modification_date=$(date -r "$h_file" +%s)

			if [ "$h_modification_date" -gt "$last_modification_date" ]; then
				last_modification_date="$h_modification_date"
			fi
		fi

		if [ "$last_modification_date" -lt "$o_modification_date" ]; then
			continue
		fi
	fi

	if ! clang-17 -c -std=c99 -Weverything \
		-Wno-used-but-marked-unused \
		-fcolor-diagnostics \
		-Wno-declaration-after-statement \
		-Wno-unsafe-buffer-usage \
		-Wno-missing-prototypes \
		-DDEBUG -fsanitize=memory -fno-omit-frame-pointer -fno-optimize-sibling-calls -O1 -fPIE -g "$source_file" -o "$o_file"; then
		exit 1
	fi
done

if ! clang -fsanitize=memory -pie ./*"$obj_suffix" -o app.exe; then
	exit 1
fi

exit 0
