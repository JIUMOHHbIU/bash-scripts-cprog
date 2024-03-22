#!/bin/bash

# id=aa9cd4a29a736179bcfbcfdcde40c16c

# Substring comparator

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

grep < "$file_1" -oz 'string:.*' | sed 's/\x00//g' > "$tmpfile1"
grep < "$file_2" -oz 'string:.*' | sed 's/\x00//g' > "$tmpfile2"

if [ "$(wc -c < "$tmpfile1")" == "0" ]; then
	echo >&2 'Входной файл 1 не содержат подстрок вида "«Result: "'
	rm -f tmpfile1 tmpfile2
	exit 160
fi 

if [ "$(wc -c < "$tmpfile2")" == "0" ]; then
	echo >&2 'Входной файл 2 не содержат подстрок вида "«Result: "'
	rm -f tmpfile1 tmpfile2
	exit 160
fi 

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
