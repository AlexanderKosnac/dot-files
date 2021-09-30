#!/bin/bash

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

