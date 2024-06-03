#!/bin/bash

status="0"

tabs="$1"
t_output="$2"
if [ -n "$t_output" ]; then
    while IFS= read -r line; do
        echo -e "$tabs""$line"
    done <<< "$t_output"
fi

exit $status
