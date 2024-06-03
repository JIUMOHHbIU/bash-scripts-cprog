#!/bin/bash

status="0"

build_into_tmpdir() {
    rc="0"

    pass="\033[1;32mPASS\033[0m"
    fail="\033[1;31mFAIL\033[0m"

    one_level_tab=$(./tab_size.sh)

    tabs="$1"
    verbose_opt="$2"
    build="$3"

    dir_path=__tmp_out_"$build"
    if [ ! -d "$dir_path" ]; then
        mkdir "$dir_path"
    fi

    if [ -f ./"$dir_path"/clean.sh ]; then
    # Remove all cache
        cd "$dir_path" || return 1
        ./clean.sh
        cd .. || return 1
    fi

# Remove all links
    find ./"$dir_path"/ -maxdepth 3 -type l -delete

# Setup dirs
    mkdir -p "$dir_path"/func_tests/data/ "$dir_path"/func_tests/scripts/

# Create links
    find . -maxdepth 1 -name "*.c" -exec ln -srt "$dir_path" {} +
    find . -maxdepth 1 -name "*.h" -exec ln -srt "$dir_path" {} +
    find . -maxdepth 1 -name "*.sh" -exec ln -srt "$dir_path" {} +
    find ./func_tests/scripts/ -name "*.sh" -exec ln -srt "$dir_path"/func_tests/scripts/ {} +
    find ./func_tests/data/ -name "*.txt" -exec ln -srt "$dir_path"/func_tests/data/ {} +

    cd "$dir_path" || return 1
    prefix="build"
    if t_output=$(./build_"$build".sh 2>&1); then
        if [ "$verbose_opt" == '-v' ]; then
            echo -e "$tabs""$prefix" "$build": "$pass"
        fi
    else
        rc="1"
        echo -e "$tabs""$prefix" "$build": "$fail"
    fi
    ./tabulate.sh "$tabs""$one_level_tab" "$t_output"

    return $rc
}
export -f build_into_tmpdir

tabs="$1"
verbose_opt="$2"
parallel="$3"

builds=("release" "debug" "debug_asan" "debug_msan" "debug_ubsan")
if [ -n "$parallel" ]; then
    parallel -k build_into_tmpdir ::: "$tabs" ::: "$verbose_opt" ::: "${builds[@]}"
    rc=$?
    if [ $status == "0" ]; then
        status="$rc"
    fi
else
    for build in "${builds[@]}"; do
        build_into_tmpdir "$tabs" "$verbose_opt" "$build"
        rc=$?
        if [ $status == "0" ]; then
            status="$rc"
        fi
    done
fi

exit $status
