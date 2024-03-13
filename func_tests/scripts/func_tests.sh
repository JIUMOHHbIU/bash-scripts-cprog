#!/bin/bash

status="0"

pass="\033[1;32mPASS\033[0m"
fail="\033[1;31mFAIL\033[0m"

one_level_tab="    "

# Check options
tabs=""
verbose_opt=""
if [ $# -gt 2 ]; then
	echo >&2 Неправильное число параметров
	status="160"
fi

if [ $# -gt 0 ]; then
	if [ "$1" == '-v' ]; then
		verbose_opt='-v'
	else
		if eval echo "$1" | grep -Eo "^	*$"; then
			tabs="$tabs""$1"
		else
			echo >&2 Неправильный параметр 1: "$1"
			status="160"
		fi
	fi
fi

if [ $# -gt 1 ]; then
	if [ "$2" == '-v' ]; then
		verbose_opt='-v'
	else
		if eval echo "$2" | grep -Eo "^	*$"; then
			tabs="$tabs""$2"
		else
			echo >&2 Неправильный параметр 2: "$2"
			status="160"
		fi
	fi
fi

if [ $status == "0" ]; then
	groups=("pos" "neg")

	for group in "${groups[@]}"; do
		counter=0
		successful=0

		for test_path in func_tests/data/"$group"*in*; do
			if [[ -f "$test_path" ]]; then
				filename="${test_path//"func_tests/data/"/""}"
				
				if t_output=$(./func_tests/scripts/"$group"_case.sh "$test_path" "${test_path//in/out}" "$verbose_opt"); then
					successful=$((successful+1))
					if [ "$verbose_opt" == '-v' ]; then
						echo -e "$tabs""$group" "$filename": "$pass"
					fi
				else
					status="1"
					echo -e "$tabs""$group" "$filename": "$fail" "|" rc: "$(cat __tmp_rc.txt)"

					if [ "$verbose_opt" == '-v' ]; then
						# Print input file
						echo -e "$tabs""$one_level_tab"input:
						while IFS= read -r line; do
							echo -e "$tabs""$one_level_tab""$one_level_tab""$line"
						done <<< "$(cat "${test_path}")"
					fi

					# Print ref output file
					echo -e "$tabs""$one_level_tab"expected:
					if [ -f "${test_path//in/out}" ]; then
						while IFS= read -r line; do
							echo -e "$tabs""$one_level_tab""$one_level_tab""$line"
						done <<< "$(cat "${test_path//in/out}")"
					else
						echo "$tabs""$one_level_tab""$one_level_tab""<EMPTY FILE>"
					fi

					# Print application output
					echo -e "$tabs""$one_level_tab"got:
					if [ -f __tmp_out.txt ]; then
						while IFS= read -r line; do
							echo -e "$tabs""$one_level_tab""$one_level_tab""$line"
						done <<< "$(cat __tmp_out.txt)"
					else
						echo "$tabs""$one_level_tab""$one_level_tab""<EMPTY FILE>"
					fi

					if [ "$verbose_opt" == '-v' ]; then
						# Print comparator view
						echo -e "$tabs""$one_level_tab"comparator output:
						if [ -n "$t_output" ]; then
							while IFS= read -r line; do
								echo -e "$tabs""$one_level_tab""$one_level_tab""$line"
							done <<< "$t_output"
						else
							echo "$tabs""$one_level_tab""$one_level_tab""<EMPTY FILE>"
						fi
					fi
				fi
				counter=$((counter+1))
			fi
		done

		if [ $counter -gt 0 ]; then
			echo -e "$tabs""$((successful*100/counter))"% of "$group" tests passed
		fi
	done
fi

exit $status
