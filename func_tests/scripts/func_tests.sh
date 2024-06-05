#!/bin/bash

status="0"

case_wrapper() {
    rc="0"

    pass="\033[1;32mPASS\033[0m"
    fail="\033[1;31mFAIL\033[0m"

    one_level_tab=$(./tab_size.sh)

    tabs="$1"
    verbose_opt="$2"
    group="$3"
    test_in="$4"

    filename="${test_in//"func_tests/data/"/""}"
    test_out="${test_in//in/out}"

    testing_folder="__tmp_testing"
    application_out="$testing_folder"/my_$(basename "${test_out}")
    appication_rc="${application_out//out/rc}"


    if comparator_output=$(cd ./func_tests/scripts/ && ./"$group"_case.sh "$test_in" "$test_out" "$verbose_opt" && cd ../../); then
        if [ "$verbose_opt" == '-v' ]; then
            echo -e "$tabs""$group" "$filename": "$pass"
        fi
    else
        rc="1"
        echo -e "$tabs""$group" "$filename": "$fail" "|" rc: "$(cat "$appication_rc")"

        # Print input file
        echo -e "$tabs""$one_level_tab"input:
        t_output="<EMPTY FILE>"
        if [ -s "$test_in" ]; then
            t_output=$(cat "$test_in")
        fi
        ./tabulate.sh "$tabs""$one_level_tab""$one_level_tab" "$t_output"

        # Print ref output file
        echo -e "$tabs""$one_level_tab"expected:
        t_output="<EMPTY FILE>"
        if [ -s "$test_out" ]; then
            t_output=$(cat "$test_out")
        fi
        ./tabulate.sh "$tabs""$one_level_tab""$one_level_tab" "$t_output"

        # Print application output
        echo -e "$tabs""$one_level_tab"got:
        t_output="<EMPTY FILE>"
        if [ -s "$application_out" ]; then
            t_output=$(cat "$application_out")
        fi
        ./tabulate.sh "$tabs""$one_level_tab""$one_level_tab" "$t_output"

        # Print comparator view
        echo -e "$tabs""$one_level_tab"comparator output:
        t_output="<EMPTY FILE>"
        if [ -n "$comparator_output" ]; then
            t_output="$comparator_output"
        fi
        ./tabulate.sh "$tabs""$one_level_tab""$one_level_tab" "$t_output"
    fi

    return $rc
}
export -f case_wrapper

tabs="$1"
verbose_opt="$2"
parallel="$3"

testing_folder="__tmp_testing"
if [ ! -d "$testing_folder" ]; then
    mkdir "$testing_folder"
fi

groups=("pos" "neg")
for group in "${groups[@]}"; do
    counter=$(find ./func_tests/data/"$group"*_in* 2> /dev/null | wc -l)
    failed=0
    if [ "$counter" -gt 0 ]; then
        if [ -n "$parallel" ]; then
            parallel case_wrapper ::: "$tabs" ::: "$verbose_opt" ::: "$group" ::: func_tests/data/"$group"*in*
            rc=$?
            if [ $status == "0" ]; then
                status="$rc"
            fi
            failed=$((failed + "$rc"))
        else
            for test_in in func_tests/data/"$group"*in*; do
                if ! case_wrapper "$tabs" "$verbose_opt" "$group" "$test_in"; then
                    failed=$((failed+1))
                    status="1"
                fi
            done
        fi
        echo -e "$tabs""$(((counter-failed)*100/counter))"% of "$group" tests passed
    else
        echo -e "$tabs""$group": "<NO TEST CASES>"
    fi
done

exit $status
