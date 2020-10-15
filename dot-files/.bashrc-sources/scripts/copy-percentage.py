import os
import sys


def get_file_size(filepath):
    try:
        return os.path.getsize(filepath)
    except FileNotFoundError:
        return None

assert len(sys.argv) == 3, "The first argument has to be the file to be copied from, the second the file to be copied to"

file_size_from = get_file_size(sys.argv[1])
file_size_to = get_file_size(sys.argv[2])

percentage = "N/A"
if file_size_from is not None and file_size_to is not None:
    percentage = "{0:.0%}".format(file_size_to/file_size_from)

print(str(percentage) + " (" + str(file_size_to) + "/" + str(file_size_from) + ")")

