#!/bin/bash

_validate_get_open_command_sorting() {
    path="$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)/open-anything.sh"
    file_is="$(mktemp)"
    file_ought="$(mktemp)"

    \grep --color=none -E "^\s+[a-z0-9]+) _first_valid_command" "$path" > "$file_is"
    sort "$file_is" > "$file_ought"

    if ! cmp -s "$file_is" "$file_ought"; then
        echo "Sorting not as expected. Ought to be:"
        cat "$file_ought" | \grep -oE "\S+)"
    fi

    rm "$file_is"
    rm "$file_ought"
}

_get_extension() {
    path="$1"
    filename=$(basename -- "$path")
    echo "${filename##*.}"
}

_first_valid_command() {
    for commandline in "$@"; do
        used_command="${commandline%% *}"
        command -v "$used_command" >/dev/null 2>&1 && echo "$commandline" && return
    done
}

_get_open_command() {
    extension="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
    is_directory="$2"
    if [ ! -z $is_directory ];  then
        _first_valid_command \
        'nautilus "<path>"'
        return
    fi

    case $extension in
        csv) _first_valid_command \
        'column -ts "," "<path>" | less -S' \
        'less -S "<path>"'
        ;;

        json) _first_valid_command \
        'python3.10 -m json.tool "<path>" | less'
        ;;

        pdf)
        _first_valid_command \
        '/usr/bin/evince "<path>" > /dev/null'
        ;;

        tsv)
        _first_valid_command \
        'column -ts "	" "<path>" | less -S' \
        'less -S "<path>"'
        ;;

        txt)
        _first_valid_command \
        'less "<path>"'
        ;;

        xopp)
        _first_valid_command \
        'xournalpp "<path>"'
        ;;

        *)
        echo "unknown file extension '$extension'" > /dev/stderr
        ;;
    esac
}

_insert_path_in_command() {
    open_command="$1"
    path="$2"
    echo "${open_command/<path>/$path}"
}

anyopen() {
    path="$1"
    if [ ! -f "$path" ] && [ ! -d "$path" ]; then
        echo "cannot access '$path': No such file or directory" > /dev/stderr
        return
    fi

    extension="$(_get_extension "$path")"
    open_command="$(_get_open_command "$extension" "$(test -d "$path" && echo "TRUE")")"
    completed_open_command="$(_insert_path_in_command "$open_command" "$path")"
    echo "$completed_open_command"
    /usr/bin/bash -c "$completed_open_command"
}
