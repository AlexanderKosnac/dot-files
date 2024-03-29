#!/bin/bash

CONFIG_DIRECTORY="${HOME}/.config/prompt/"
PROMPT_STORAGE_FILE="${CONFIG_DIRECTORY}/prompt_type"

mkdir -p "$CONFIG_DIRECTORY"
if [ ! -f "$PROMPT_STORAGE_FILE" ]; then
    echo -n "git-prompt" > "$PROMPT_STORAGE_FILE"
fi

export A_GIT_PROMPT_TYPE="$(head -n 1 "$PROMPT_STORAGE_FILE")"

git_prompt_type=(
    "basic"
    "git-prompt"
    "with git branch"
)

export VIRTUAL_ENV_DISABLE_PROMPT=1

def="${S_RESET}${DEF_FG}${DEF_BG}"
blue="$(color-rgb-fg 0 133 251)"
yellow="$(color-rgb-fg 255 208 0)"
red="$(color-rgb-fg 255 110 110)"
green="$(color-rgb-fg 89 255 114)"
gray="$(color-rgb-fg 200 200 200)"

function hash_based_color {
    hash="$(echo "$1" | md5sum)"
    hash_value="$(printf "scale=0;360 * %d/16^4\n" 0x${hash:0:4} | bc -l)"
    hash_color="$(hsv2rgb "$hash_value" 0.4 0.99)"
    echo "$(color-rgb 0 0 0 $hash_color)"
}

user_color="$(hash_based_color "$USER")"
host_color="$(hash_based_color "$(hostname)")"
at_color="$(color-rgb 0 0 0 240 240 240)"

venv_color="$(color-rgb 0 0 0 89 255 114)"
conda_color="$(color-rgb 255 255 255 67 176 42)"

p_user="${user_color}\u${def}"
p_at="${at_color}@${def}"
p_host="${host_color}\H${def}"
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

function virtual_env_name {
    if [ ! -z "$VIRTUAL_ENV" ]; then
        echo " ${venv_color}${VIRTUAL_ENV##*/}${def}"
    fi
}

function conda_env_name {
    if [ ! -z "$CONDA_DEFAULT_ENV" ] && [ "$CONDA_DEFAULT_ENV" != "base" ]; then
        echo " ${conda_color}${CONDA_DEFAULT_ENV}${def}"
    fi
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

function prompt_select {
    for i in ${!git_prompt_type[@]}; do
        echo "$((i+1)). ${git_prompt_type[$i]}"
    done
    read -p "Select prompt type: " -r num
    case $num in
        1 | 2 | 3)
        prompt_type_string="${git_prompt_type[$((num-1))]}"
        export A_GIT_PROMPT_TYPE="$prompt_type_string"
        echo -n "$prompt_type_string" > "$PROMPT_STORAGE_FILE"
        ;;
        *) echo "Unhandled prompt type '${var}'." > /dev/stderr;;
    esac
    __export_prompt
}

function __setprompt {
    ec=$?;  # has to be at top
    prompt="${def}"  # clear PS1

    # user and host
    prompt+="${p_user}${p_at}${p_host} "

    # timestamp
    prompt+="${p_time} "

    # exit code of last command
    prompt+="$(prompt_exit_code $ec)"

    # the name of the active python virtual environment
    prompt+="$(virtual_env_name)"

    # the name of the active conda environment
    prompt+="$(conda_env_name)"

    prompt+="${p_colon} "

    prompt+="${blue}$(relative_root)${def}"
    prompt+="${def}"

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

function __prompt_basic {
    PS1="$(__setprompt)\n\$ "
    export PROMPT_COMMAND=''
}

function __prompt_git-prompt {
    PS1="$(__setprompt)\n\$ "
    export PROMPT_COMMAND='__git_ps1 "$(__setprompt)" "\n\$ "'
}

function __prompt_with_git_branch {
    repo_path="$(git rev-parse --show-prefix 2> /dev/null)"
    is_git="$?"
    git_branch_prompt=""
    if [ $is_git = 0 ]; then
        git_branch="$(git rev-parse --abbrev-ref HEAD)"
        git_branch_prompt="[${git_branch}]"
    fi
    PS1="$(__setprompt) $git_branch_prompt\n\$ "
    export PROMPT_COMMAND=''
}

function __export_prompt {
    $(echo "__prompt_$A_GIT_PROMPT_TYPE" | tr " " "_")
}

__export_prompt

