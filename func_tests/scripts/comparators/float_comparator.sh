#!/bin/bash

# Float comparator

status="0"

# Check options
file_1=''
file_2=''
verbose_opt=''
if [ $# -lt 2 ]; then
	echo >&2 Неправильное число параметров
	exit 160
fi

if [ ! -f "$1" ]; then
	echo >&2 Файл 1 не существует
	exit 160
fi

if [ ! -f "$2" ]; then
	echo >&2 Файл 2 не существует
	exit 160
fi

if [ $# -gt 3 ]; then
	echo >&2 Неправильное число параметров
	exit 160
fi

file_1="$1"
file_2="$2"

if [ -n "$3" ]; then
	if [ ! "$3" == '-v' ]; then
		echo >&2 Неправильный 3 параметр
		exit 160
	fi
	verbose_opt='-v'
fi


pattern="^[+-]*(([0-9]+[.]?[0-9]*)|([0-9]*[.]?[0-9]+))([eE][+-]?[0-9]+)?$"

tmpfile1=$(mktemp /tmp/tfile1.XXXXXX)
tmpfile2=$(mktemp /tmp/tfile2.XXXXXX)
echo > "$tmpfile1"
echo > "$tmpfile2"

for word in $(cat "$file_1"); do
    if [[ $word =~ $pattern ]]; then
        echo "$word" >> "$tmpfile1"
    fi
done

for word in $(cat "$file_2"); do
    if [[ $word =~ $pattern ]]; then
        echo "$word" >> "$tmpfile2"
    fi
done

if [[ $(md5sum < "$tmpfile1") == $(md5sum < "$tmpfile2") ]]; then
	if [[ "$verbose_opt" == '-v' ]]; then
		echo "not differ"
	fi
else
	if [[ "$verbose_opt" == '-v' ]]; then
		echo "differ"
	fi
	status="1"
fi

rm -f "$tmpfile1" "$tmpfile2"

exit $status
