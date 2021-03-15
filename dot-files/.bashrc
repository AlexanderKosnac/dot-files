#!/bin/bash

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

export bashrc_sources="${HOME}/.bashrc-sources/"
export file_template_dir="${HOME}/file-templates/"

source "${bashrc_sources}/.bash_aliases"
source "${bashrc_sources}/.bash_exports"

source "${bashrc_sources}/.git_prompt"
#source "${bashrc_sources}/.lsf_aliases"

# source all the scripts from this directory
for f in "${bashrc_sources}/to-source/*"; do
    source $f
done

# Prompt
def="$(color-rgb-fg 250 250 250 40 40 40)"
blue="$(color-rgb-fg 0 133 251)"
yellow="$(color-rgb-fg 255 208 0)"
green="$(color-rgb-fg 89 255 114)"
gray="$(color-rgb-fg 200 200 200)"

p_user="${yellow}\u${def}"
p_at="${def}@${def}"
p_host="${green}\H${def}"
p_time="${gray}\t${def}"
p_colon="${def}:${def}"
p_pwd="${blue}\W${def}"

prompt="${p_user}${p_at}${p_host} ${p_time}: ${p_pwd}${def}"
export PROMPT_COMMAND='__git_ps1 "${prompt}" "\n$ "'

# bash history
## don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

## append to the history file, don't overwrite it
shopt -s histappend

## for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check and update terminal window size after each command
shopt -s checkwinsize

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/data/${USER}/sdkman"
[[ -s "/data/${USER}/sdkman/bin/sdkman-init.sh" ]] && source "/data/${USER}/sdkman/bin/sdkman-init.sh"
