#!/bin/bash

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

export bashrc_sources="${HOME}/.bashrc-sources/"

source "${bashrc_sources}/.bash_aliases"
source "${bashrc_sources}/.bash_exports"

source "${bashrc_sources}/.git_prompt"
#source "${bashrc_sources}/.lsf_aliases"

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


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/data/${USER}/sdkman"
[[ -s "/data/${USER}/sdkman/bin/sdkman-init.sh" ]] && source "/data/${USER}/sdkman/bin/sdkman-init.sh"
