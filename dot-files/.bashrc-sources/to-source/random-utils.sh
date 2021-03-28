
function random_char() {
    if [ $# -ne 1 ]; then
      echo "random_char <char_list>"
      return
    fi
    chars="$1"
    echo -n "${chars:$(( RANDOM % ${#chars} )):1}"
}

function random_string() {
    if [ $# -ne 2 ]; then
      echo "random_string <char_list> <string_length>"
      return
    fi
    chars="$1"
    length="$2"
    for i in `seq 1 $length`; do
        random_char "$chars"
    done
}

function random_text() {
    if [ $# -ne 3 ]; then
      echo "random_text <char_list> <string_length> <n_lines>"
      return
    fi
    chars="$1"
    length="$2"
    lines="$3"
    for i in `seq 1 $lines`; do
        random_string "$chars" "$length"
        echo ""
    done
}
