#!/bin/bash

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

export bashrc_sources="${HOME}/.bashrc-sources/"
export file_template_dir="${HOME}/file-templates/"

source "${bashrc_sources}/.exports"
source "${bashrc_sources}/.aliases"

# source all the scripts from this directory
for f in ${bashrc_sources}/to-source/*; do
    source $f
done

# check and update terminal window size after each command
shopt -s checkwinsize

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/data/${USER}/sdkman"
[[ -s "/data/${USER}/sdkman/bin/sdkman-init.sh" ]] && source "/data/${USER}/sdkman/bin/sdkman-init.sh"

