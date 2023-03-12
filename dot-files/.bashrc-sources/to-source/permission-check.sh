#!/bin/bash

# Check permissions of specific files and warn if they do not match.
# Execute on sourcing, but use a timestamp file to only remind once a day.

TIMESTAMP_FILE="/tmp/$(date +%Y-%m-%d)-permission-check"

function _assert-permissions() {
    file="$1"
    expected="$2"

    if [ ! -f "$FILE" ]; then
        return 0
    fi

    is="$(stat -c %A "$file")"

    if [ "$is" = "$expected" ]; then
        return 0
    fi
    {
        echo "Unexpected permissions found:"
        echo "File:     $file"
        echo "Expected: $expected"
        echo "But is:   $is"
    } > /dev/stderr
    [ -f "$TIMESTAMP_FILE" ] && rm "$TIMESTAMP_FILE"
    return 1
}


if [ -f "$TIMESTAMP_FILE" ]; then
    return 0
fi

touch $TIMESTAMP_FILE

# SSH directory permissions are expected as explained here:
# https://superuser.com/a/215506/883104
# https://superuser.com/a/925859/883104

_assert-permissions "$HOME/" "drwx------"

SSH_ROOT="$HOME/.ssh"
_assert-permissions "$SSH_ROOT/" "drwx------"
_assert-permissions "$SSH_ROOT/authorized_keys" "-rw-r--r--"
_assert-permissions "$SSH_ROOT/known_hosts" "-rw-r--r--"

for key in $(\ls -1 "$SSH_ROOT/"*.pub); do
    if [[ -L "$key" ]]; then
        continue # ignore links
    fi
    _assert-permissions "$key"        "-rw-r--r--"  # public key
    _assert-permissions "${key:0:-4}" "-rw-------"  # private key
done

