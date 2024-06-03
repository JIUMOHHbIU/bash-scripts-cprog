#!/bin/bash

status="0"

tabs="$1"

threshold="60"
if ! t_output=$(gcov ./*.c); then
    status="1"
else
    readarray -t percentages <<< "$(echo "$t_output" | grep -Eo '[0-9]+\.[0-9]+%' | grep -Eo '^[0-9]+')"
    min=${percentages[0]}
    for i in "${percentages[@]}"; do
      (( i < min )) && min=$i
    done
    (( min < threshold )) && status="1"
fi
./tabulate.sh "$tabs" "$t_output"

exit $status
