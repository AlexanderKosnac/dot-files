#!/bin/bash

def="${S_RESET}"
blue="$(color-rgb-fg 0 133 251)"
yellow="$(color-rgb-fg 255 208 0)"
red="$(color-rgb-fg 255 110 110)"
green="$(color-rgb-fg 89 255 114)"
gray="$(color-rgb-fg 200 200 200)"

p_user="${yellow}\u${def}"
p_at="${def}@${def}"
p_host="${green}\H${def}"
p_time="${gray}\t${def}"
p_colon="${def}:${def}"
p_pwd="${blue}\W${def}"

function __setprompt
{
    ec=$?;  # has to be at top
    PS1=""  # clear PS1

    # user and host
    PS1+="${p_user}${p_at}${p_host} "

    # timestamp
    PS1+="${p_time}"

    PS1+="${p_colon} "
    PS1+="${p_pwd}"
    PS1+="${def}"
    PS1+="\n"
    PS1+="\$"

	# PS2 for continuing multiline commands
	#PS2=""

	# PS3 for entering a number choice in scripts
	#PS3=""

	# PS4 for tracing in debug mode
	#PS4=""
}
PROMPT_COMMAND='__setprompt'
