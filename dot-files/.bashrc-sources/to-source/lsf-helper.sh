#!/bin/bash

# lsf cluster aliases
base_format="jobid:7 stat:5"
first_host="first_host:16"
alias bjobs-walltime="bjobs -ro \"${base_format} time_left:10 job_name\""
alias bjobs-nodes="bjobs -ro \"${base_format} ${first_host} job_name\""
alias bjobs-used-nodes="bjobs -noheader -ro "first_host" | sort | uniq"
alias bjobs-queues="bjobs -o \"${base_format} queue:12 job_name\""
alias bjobs-runtime="bjobs -ro \"${base_format} submit_time:14 start_time:14 run_time:15 finish_time:14 name\""

# call ps on given job IDs
bjobs-ps () {
    if [ $# -eq 0 ]
    then
        bjobs -ro "${base_format} ${first_host} job_name:40 pids"
        return 0
    fi
    for pid in "$@"
    do
        bjobs -noheader -ro "${base_format} ${first_host} job_name:40" $pid
        pids="$(bjobs -noheader -ro "pids" $pid)"
        if [ $pids == "-" ]
        then
            echo "no pids found"
            continue
        fi
        ps o pid,pcpu,cputime,comm --no-headers -p "$pids"
        echo ""
    done
}

# formatted lsload with some explanation
lsload-big() {
    echo "###"
    echo "# Exponentially averaged CPU run queue length:"
    echo "#  - r15s: 15 seconds"
    echo "#  - r1m:  1 minute"
    echo "#  - r15m: 15 minutes"
    echo "# ut: The CPU utilization exponentially averaged over the last minute"
    echo "# pg: The memory paging rate exponentially averaged over the last minute"
    echo "# io: shows the disk I/O rate exponentially averaged over the last minute, in KB per second"
    echo "###"
    lsload -o "HOST_NAME:20 status:8 r15s:5 r1m:5 r15m:5 ut:5 pg:5 io:5"
}

list-walltime-percentage() {
    bjobs -json -ro 'jobid stat run_time time_left runtimelimit name' "$@" | $PYTHON "${SCRIPTS_DIR}/walltime-as-percent.py"
}

