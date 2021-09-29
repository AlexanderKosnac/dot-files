view-json() {
    $python_3_8 -m json.tool $1 | less
}

view-tsv() {
    column -t "$1" | less -S
}

view-pdf() {
    /usr/bin/evince $1 > /dev/null
}

