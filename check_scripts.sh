#!/bin/bash

status="0"

shellcheck_singular() {
    rc="0"

    one_level_tab=$(./tab_size.sh)

    pass="\033[1;32mPASS\033[0m"
    failed="\033[1;31mFAILED\033[0m"

    tabs="$1"
    verbose_opt="$2"
    parallel="$3"
    script="$4"

    sc_opts=("-a" "-C")
    prefix="script"
    if t_output=$(shellcheck "${sc_opts[@]}" "$script"); then
        if [ "$verbose_opt" == '-v' ]; then
            echo -e "$tabs""$prefix" "$script": "$pass"
        fi
    else
        echo -e "$tabs""$prefix" "$script": "$failed"
        rc="1"

        ./tabulate.sh "$tabs""$one_level_tab" "$t_output"
    fi

    return $rc
}
export -f shellcheck_singular

tabs="$1"
verbose_opt="$2"
parallel="$3"

if [ -n "$parallel" ]; then
    find . -name "*.sh" ! -type l -exec parallel -k shellcheck_singular ::: "$tabs" ::: "$verbose_opt" ::: "$parallel" ::: {} +
    rc=$?
    if [ $status == "0" ]; then
        status="$rc"
    fi
else
    while IFS= read -r -d '' script
    do
        shellcheck_singular "$tabs" "$verbose_opt" "$parallel" "$script"
        rc=$?
        if [ $status == "0" ]; then
            status="$rc"
        fi
    done <   <(find . -name "*.sh" ! -type l -print0)
fi

exit $status
