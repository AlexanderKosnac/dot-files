#!/bin/bash

as-filename() {
    # if many arguments, split them into single argument calls
    if [ "$#" -gt 1 ]; then
        for var in "$@"; do
            as-filename "$var"
        done
        return
    fi

    text=""
    if [ "$#" -eq 1 ]; then
        text="$1"
    else
        text="$(cat)"
    fi

    echo "$text" \
    | tr '[:upper:]' '[:lower:]' \
    | sed 's/ä/ae/g' \
    | sed 's/ö/oe/g' \
    | sed 's/ü/ue/g' \
    | sed 's/ß/ss/g' \
    | sed 's/  / /g' \
    | tr " _/':" "-" \
    | tr "<>()[]{}" "-" \
    | tr "|?!*" "-" \
    | tr '\\' "-" \
    | tr '"' "-"
}

# test string
# echo "A B  C DEF Ghi_/<>:|\?\!*\(\)[]{}\\\"\'ßöäü" | as-filename
# a-b-c-----------------------ssoeaeue
