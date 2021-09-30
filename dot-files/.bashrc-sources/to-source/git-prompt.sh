#!/bin/bash

download_link="https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh"

cache_directory="${HOME}/.cache/"
cached_file="$cache_directory/git-prompt.sh"

mkdir -p "$cache_directory"

# download the file if it isn't already available
if ! [ -f "$cached_file" ]; then
    echo "No cached git-prompt file could be found at ${cached_file}. Downloading now:"
    curl "$download_link" > "$cached_file"
fi

source "$cached_file"

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWCOLORHINTS=1
