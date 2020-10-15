# directories
alias data="cd /data/${USER}"
alias usb="cd /run/media/${USER}/"


# ls
alias ls="ls --color=always"
alias ll='ls -la'
alias l='ll'


# grep
alias grep="grep --color -Ei"


# convenience
alias timestamp="date '+%Y%m%d%H%M%S'"
alias time="date '+%H:%M:%S'"
alias untar="tar -zxvf"


# ssh

# creates two aliases: one with the normal name and one with an "ssh_" prefix. This way you
# can simply tab complete "ssh_" to see what exists.
# $1: alias name;  $2: user@host
set_ssh_alias () {
    cmd="ssh $2"
    alias "$1"="echo $2; $cmd"
    alias "ssh_$1"="$cmd"
}
# Example:  set_ssh_alias "example-alias" "user@host"