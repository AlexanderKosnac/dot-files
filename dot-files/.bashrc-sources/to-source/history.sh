#!/bin/bash

# append to the history file, don't overwrite it
shopt -s histappend

# no duplicates, no lines starting with a space
export HISTCONTROL=ignoredups:ignorespace

# number of lines stored in memory during the session
export HISTSIZE=-1  # = infinite
# number of lines stored on disk in the HISTFILE
export HISTFILESIZE=100000
