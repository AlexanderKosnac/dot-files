# Only keep specific lines
# Format:
# - single lines as a simple number 'n'
# - line ranges separated by a '-', like 'n-m'
# - multiple at once separated by ','
#
# Example:
# cat file | lines 1,2,5-7,10
function lines {
    local ranges="$1"
    OIFS=$IFS
    IFS=','
    sed_string=""
    for range in $ranges; do
        sed_string="${sed_string}$(echo "${range}p;" | tr "-" ",")"
    done
    echo "$sed_string"
    sed -n "$sed_string"
    IFS=$OIFS
}
