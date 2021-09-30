import sys
import json

# Expects a json from bjobs with the following fields
# > jobid stat  time_left runtimelimit name
#

NA = "N/A"

def minutes_as_hours_and_minutes(minutes):
    hours = int(minutes / 60)
    minutesOfHour = int(minutes % 60)
    return { "hours": hours, "minutes": minutesOfHour }


def minutes_as_hours_and_minutes_as_string(minutes, hour_padding=3):
    if minutes == None:
        return NA
    res = minutes_as_hours_and_minutes(minutes)
    return '{h: >{hpad}}:{m:0>2}'.format(hpad=hour_padding, h=res['hours'], m=res['minutes'])


stdin = sys.stdin.read()

bjobs_json = json.loads(stdin)

output_format = "{0: <8}  {1: <4}  {2: <6}  {3: <6}  {4: <7}  {5: <5}  {6}"

header = output_format.format("JOBID", "STAT", "T_LEFT", "T_LEFT", "T_PER_%", "RUN_T", "JOB_NAME")

content = []

for bjob in bjobs_json["RECORDS"]:
    job_name = bjob["JOB_NAME"]
    raw_time_left = bjob["TIME_LEFT"]
    time_left = None
    if raw_time_left:
        values = raw_time_left[0:-2].split(":")
        hours_left = int(values[0])
        minutes_of_hour_left = int(values[1])
        time_left = hours_left * 60 + minutes_of_hour_left

    walltime_left_in_hours_and_minutes = minutes_as_hours_and_minutes_as_string(time_left)

    raw_time_available = bjob["RUNTIMELIMIT"]
    try:
        time_available = int(float(raw_time_available))
    except ValueError:
        time_available = None

    one_percent_of_walltime = minutes_as_hours_and_minutes_as_string(int(time_available / 100), 0)

    walltime_left_percent = NA
    if time_left and time_available:
        walltime_left_percent = "{0: >4.0%}".format(time_left / time_available)

    raw_run_time = bjob["RUN_TIME"]
    run_time_in_seconds = int(raw_run_time.split(" ")[0])
    run_time = minutes_as_hours_and_minutes_as_string(run_time_in_seconds/60)

    #line_content = output_format.format(bjob["JOBID"], bjob["STAT"], walltime_left_percent, walltime_left_in_hours_and_minutes, one_percent_of_walltime)
    sort_key = walltime_left_percent
    line_content = [sort_key, bjob["JOBID"], bjob["STAT"], walltime_left_percent, walltime_left_in_hours_and_minutes, one_percent_of_walltime, run_time, job_name]
    content.append(line_content)


def sort_function(val):
    return val[0]

content.sort(key = sort_function)

# build and print output
print(header)
for line_content in content:
    print(output_format.format(*line_content[1:]))

