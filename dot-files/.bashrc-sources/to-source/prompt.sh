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

function relative_root {
    repo_path="$(git rev-parse --show-prefix 2> /dev/null)"
    is_git="$?"
    if [ $is_git = 0 ]; then
        toplevel="$(basename $(git rev-parse --show-toplevel))"
        echo "$toplevel/$repo_path"
    else
        pwd
    fi
}

function __setprompt {
    ec=$?;  # has to be at top
    prompt=""  # clear PS1

    # user and host
    prompt+="${p_user}${p_at}${p_host} "

    # timestamp
    prompt+="${p_time} "

    # exit code of last command
    prompt+="$(prompt_exit_code $ec)"

    prompt+="${p_colon} "

    prompt+="${blue}$(relative_root)${def}"
    prompt+="${def}"

    # the git-prompt, but used this waz it can not output color
    #prompt+="$(__git_ps1)"
    #prompt+="\n\$ "

    # print out prompt so we can use it with __git_ps1
    # git-prompt does not allow use of colors
    echo "$prompt"

    # PS1 for default prompt
    #PS1="$prompt"

	# PS2 for prompt when writing multiline commands
	#PS2=""

	# PS3 for prompt when asking for input
	#PS3=""

	# PS4 for prompt when tracing script in debug mode
	#PS4=""
}
export PROMPT_COMMAND='__git_ps1 "$(__setprompt)" "\n\$ "'
