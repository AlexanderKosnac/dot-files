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
# Exit codes are interpreted as layed out here:
# https://tldp.org/LDP/abs/html/exitcodes.html
function exit_code_to_text {
    local ec="$1"
    if [[ $ec == 0 ]]; then
        return 0;
    fi
    if [[ $ec -ge 255 ]]; then
        err="Exit status out of range"
    fi
    case $ec in
        1)   err="General error";;
        2)   err="Missing keyword, or command, or permission problem";;
        126) err="Permission problem or command is not an executable";;
        127) err="Command not found";;
        128) err="Invalid argument to exit";;
        129) err="Fatal error signal 1";;
        130) err="Script terminated by Control-C";;
        131) err="Fatal error signal 3";;
        132) err="Fatal error signal 4";;
        133) err="Fatal error signal 5";;
        134) err="Fatal error signal 6";;
        135) err="Fatal error signal 7";;
        136) err="Fatal error signal 8";;
        137) err="Fatal error signal 9";;
        *)   err="Error code out of defined range";;
    esac
    echo "$err"
}

function prompt_exit_code {
    local ec="$1"
    local prompt=""
    if [[ $ec != 0 ]]; then
        prompt+="${red}"
    fi
    printf -v ec_form "%3s" $ec
    prompt+="${S_BOLD}[$ec_form]${S_BOLD_N}${def}"
    echo -en "$prompt"
}
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
