#!/bin/bash

# Only applied when used in Windows Subsystem for Linux (WSL)

# check if we are inside WSL
grep -iq "microsoft" /proc/version
if [[ $! -ne 0 ]]; then
    return
fi

# The native git in WSL is very slow while working on a Windows mount. Instead
# use git.exe, when operating on the C: mount.
# Taken from: https://markentier.tech/posts/2020/10/faster-git-under-wsl2/
function git() {
  if $(pwd -P | grep -q "^/mnt/c/*"); then
    git.exe "$@"
  else
    command git "$@"
  fi
}
