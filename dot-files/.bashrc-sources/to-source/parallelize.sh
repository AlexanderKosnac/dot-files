# Semaphore based approach to parallelize a list of tasks with a maximum number
# of parallel jobs. Taken from the stack exchange answer:
# https://unix.stackexchange.com/a/216475/261980

# Usage:
# Open semaphore with a given number of slots:
# > open_parallelize_sem <number of parallel slots>
#
# To parallelize function 'task':
# > run_in_parallel task

open_parallelize_sem() {
    mkfifo pipe-$$
    exec 3<>pipe-$$
    ls pipe*
    rm -v pipe-$$
    local i=$1
    for((;i>0;i--)); do
        printf %s 000 >&3
    done
}

run_in_parallel() {
    local x
    read -u 3 -n 3 x && ((0==x)) || exit $x
    (
        ( "$@"; )
        printf '%.3d' $? >&3
    )&
}
