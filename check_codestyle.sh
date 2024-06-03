#!/bin/bash

status="0"

tabs="$1"

if [ -f "CodeChecker.exe" ]; then
    # Run codestyle check
    # https://git.iu7.bmstu.ru/IU7-Projects/CodeChecker
    for file in *.c; do
        t_output=$(./CodeChecker.exe "$file" 2>&1)
        # rc="$?"
        # if [ $status == "0" ]; then
        #   status="$rc"
        # fi
        ./tabulate.sh "$tabs" "$t_output"
    done
fi

exit $status
