#!/bin/bash

status="0"

pass="\033[1;32mPASS\033[0m"
fail="\033[1;31mFAIL\033[0m"

one_level_tab=$(./tab_size.sh)

tabs="$1"
verbose_opt="$2"
parallel="$3"

builds=("release" "debug" "debug_asan" "debug_msan" "debug_ubsan")
for build in "${builds[@]}"; do
    cd __tmp_out_"$build" || exit 1

    t_output=$(./func_tests/scripts/func_tests.sh "$tabs" "$verbose_opt" "$parallel" 2>&1)
    status="$?"

    prefix="functional tests on"
    if [ $status == "0" ]; then
        echo -e "$tabs""$prefix" "$build": "$pass"
    else
        status="1"
        echo -e "$tabs""$prefix" "$build": "$fail"
    fi
    ./tabulate.sh "$one_level_tab" "$t_output"

    cd ..
done

exit $status
