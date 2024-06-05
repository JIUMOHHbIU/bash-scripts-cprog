#!/bin/bash

# Float comparator

status="0"

file_1="$1"
file_2="$2"
verbose_opt="$3"

pattern="^[+-]*(([0-9]+[.]?[0-9]*)|([0-9]*[.]?[0-9]+))([eE][+-]?[0-9]+)?$"

tmpfile1=$(mktemp /tmp/tfile1.XXXXXX)
tmpfile2=$(mktemp /tmp/tfile2.XXXXXX)

while IFS= read -r line; do
    if [[ $line =~ $pattern ]]; then
        echo "$line" >> "$tmpfile1"
    fi
done <<< "$(tr "$file_1" ' ' '\n')"

while IFS= read -r line; do
    if [[ $line =~ $pattern ]]; then
        echo "$line" >> "$tmpfile1"
    fi
done <<< "$(tr "$file_2" ' ' '\n')"


if ! [[ $(md5sum < "$tmpfile1") == $(md5sum < "$tmpfile2") ]]; then
    if [[ "$verbose_opt" == '-v' ]]; then
        echo file 1 filtred:
        if [ -s "$tmpfile1" ]; then
            cat "$tmpfile1"
        else
            echo "<EMPTY FILE>"
        fi
        echo file 2 filtred:
        if [ -s "$tmpfile2" ]; then
            cat "$tmpfile2"
        else
            echo "<EMPTY FILE>"
        fi
        echo
        echo diff on filtred:
        diff "$tmpfile1" "$tmpfile2"
    fi
    status="1"
fi

rm -f "$tmpfile1" "$tmpfile2"

exit $status
