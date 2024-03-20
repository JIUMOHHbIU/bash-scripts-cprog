#!/bin/bash

gcc_compile_args=("-std=c99" "-Wall" "-Werror" "-Wpedantic" "-Wextra" "-Wfloat-equal" "-Wfloat-conversion" "-Wvla" "-fdiagnostics-color")

obj_suffix=".o"
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

	if ! gcc "${gcc_compile_args[@]}" -g -DDEBUG -c -fprofile-arcs -ftest-coverage -O0 "$source_file" -o "$o_file"; then
		exit 1
	fi
done

if ! gcc -fprofile-arcs -o app.exe ./*"$obj_suffix" -lm; then
	exit 1
fi

exit 0
