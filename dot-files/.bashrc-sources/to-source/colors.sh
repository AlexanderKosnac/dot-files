#!/bin/bash

# the most perfect stackoverflow answer on the topic of colors:
# https://stackoverflow.com/questions/4842424/list-of-ansi-color-escape-sequences

# font style
export S_RESET="\033[0m"
export S_BOLD="\033[1m"
export S_BOLD_N="\033[22m"

export S_FAINT="\033[2m"
export S_FAINT_N="\033[22m"

export S_ITALIC="\033[3m"
export S_ITALIC_N="\033[23m"

export S_UNDERLINE="\033[4m"
export S_UNDERLINE_N="\033[24m"

export S_BLINK_SLOW="\033[5m"
export S_BLINK_RAPID="\033[6m"
export S_BLINK_N="\033[25m"

export S_CROSSED="\033[9m"
export S_CROSSED_N="\033[29m"

export S_OVERLINED="\033[53m"
export S_OVERLINED_N="\033[53m"

# color
export C_NC='\e[0m' # No Color
export C_BLACK='\e[0;30m'
export C_GRAY='\e[1;30m'
export C_RED='\e[0;31m'
export C_LIGHT_RED='\e[1;31m'
export C_GREEN='\e[0;32m'
export C_LIGHT_GREEN='\e[1;32m'
export C_BROWN='\e[0;33m'
export C_YELLOW='\e[1;33m'
export C_BLUE='\e[0;34m'
export C_LIGHT_BLUE='\e[1;34m'
export C_PURPLE='\e[0;35m'
export C_LIGHT_PURPLE='\e[1;35m'
export C_CYAN='\e[0;36m'
export C_LIGHT_CYAN='\e[1;36m'
export C_LIGHT_GRAY='\e[0;37m'
export C_WHITE='\e[1;37m'

export DEF_FG="\033[39m"
export DEF_BG="\033[49m"

# parameters are layer (fg=38 ; bg=48) and r, g, b values in this order (0-255)
function _color-rgb() {
    echo -e "\033[$1;2;$2;$3;$4m"
}

# setting fg and bg at once
# r, g, b for fg and then r, g, b for bg in this order
function color-rgb() {
    echo -e "\033[38;2;$1;$2;$3;48;2;$4;$5;$6m"
}

# r, g, b values in this order (0-255)
function color-rgb-fg() {
    _color-rgb 38 $1 $2 $3
}

# r, g, b values in this order (0-255)
function color-rgb-bg() {
    _color-rgb 48 $1 $2 $3
}

function all-colors() {
    for r in {0..255}; do
        for g in {0..255}; do
            for b in {0..255}; do
                color-rgb-bg $r $g $b
                echo "$r $g $b"
            done
        done
    done
}
