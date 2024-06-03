#!/bin/bash

status="0"

run_step() {
    rc="0"

    passed="\033[1;32m(PASSED)\033[0m"
    failed="\033[1;31m(FAILED)\033[0m"

    one_level_tab=$(./tab_size.sh)

    tabs="$1"
    verbose_opt="$2"
    parallel="$3"
    step="$4"
    prefix="$5"

    echo -n "$tabs""$prefix"
    if t_output=$("$step" "$tabs""$one_level_tab" "$verbose_opt" "$parallel" 2>&1); then
        echo -e " $passed"
    else
        rc="1"
        echo -e " $failed"
    fi

    if [ -n "$t_output" ]; then
        echo -e "$t_output"
    fi

    return $rc
}
export -f run_step

tabs="$1"
verbose_opt="$2"
parallel="$3"

prefixes=("CODESTYLE" "SHELLCHECK" "BUILD")
steps=("./check_codestyle.sh" "./check_scripts.sh" "./check_builds.sh")
if [ -n "$parallel" ]; then
    parallel -k --link run_step ::: "$tabs" ::: "$verbose_opt" ::: "$parallel" ::: "${steps[@]}" ::: "${prefixes[@]}"
    rc=$?
    if [ $status == "0" ]; then
        status="$rc"
    fi
else
    for (( i=0; i<${#steps[*]}; ++i)); do
        run_step "$tabs" "$verbose_opt" "$parallel" "${steps[$i]}" "${prefixes[$i]}"
        rc=$?
        if [ $status == "0" ]; then
            status="$rc"
        fi
    done
fi

if [ $status == "0" ]; then
    # Run functional_tests
    prefix="FUNCTIONAL TESTS"
    step="./check_functional_tests.sh"
    run_step "$tabs" "$verbose_opt" "$parallel" "$step" "$prefix"
    rc=$?
    if [ $status == "0" ]; then
        status="$rc"
    fi
fi

if [ $status == "0" ]; then
    # Collect coverage
    cd __tmp_out_debug || exit 1

    prefix="COVERAGE"
    step="./collect_coverage.sh"
    run_step "$tabs" "$verbose_opt" "$parallel" "$step" "$prefix"
    rc=$?
    if [ $status == "0" ]; then
        status="$rc"
    fi

    cd ..
fi

exit $status
