FILE="${HOME}/.cargo/env"
# Repository: https://github.com/dom96/choosenim
# Install via:
#     curl https://nim-lang.org/choosenim/init.sh -sSf | sh

export PATH=${HOME}/.nimble/bin:$PATH

nimcache="${HOME}/.nimcache"
mkdir -p $nimcache
export nimcache
