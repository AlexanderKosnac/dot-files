ROOT_DIRECTORY="../dot-files"
DOT_FILES_DIRECTORY="${ROOT_DIRECTORY}/dot-files/"

FILES="$(cd "${DOT_FILES_DIRECTORY}"; find . -type f)"
DIRS="$(cd "${DOT_FILES_DIRECTORY}"; find . -type d)"
