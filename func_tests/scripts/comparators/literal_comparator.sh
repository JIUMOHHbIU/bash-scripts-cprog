#!/bin/bash

# Literal comparator

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


tmpfile1=$(mktemp /tmp/tfile1.XXXXXX)
tmpfile2=$(mktemp /tmp/tfile2.XXXXXX)

for word in $(cat "$file_1"); do
    echo "$word" >> "$tmpfile1"
done

for word in $(cat "$file_2"); do
    echo "$word" >> "$tmpfile2"
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
