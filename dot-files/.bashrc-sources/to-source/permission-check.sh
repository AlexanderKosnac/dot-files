#!/bin/bash

# Check permissions of specific files and warn if they do not match.
# Execute on sourcing, but use a timestamp file to only remind once a day.

TMP_DIR="$HOME/tmp/$(date +%F)"
TIMESTAMP_FILE="$TMP_DIR/$(date +%Y-%m-%d)-permission-check"

function _assert-permissions() {
    path="$1"
    expected="$2"

    if [ ! -f "$path" ] && [ ! -d "$path" ]; then
        echo "Checking permissions on '$path', but it does not exist."
        return 0
    fi

    is="$(stat -c %A "$path")"

    if [ "$is" = "$expected" ]; then
        return 0
    fi
    {
        echo "Unexpected permissions found:"
        echo "Path:     $path"
        echo "Expected: $expected"
        echo "But is:   $is"
    } > /dev/stderr
    [ -f "$TIMESTAMP_FILE" ] && rm "$TIMESTAMP_FILE"
    return 1
}


if [ -f "$TIMESTAMP_FILE" ]; then
    return 0
fi

mkdir -p "$TMP_DIR"
touch $TIMESTAMP_FILE

# SSH directory permissions are expected as explained here:
# https://superuser.com/a/215506/883104
# https://superuser.com/a/925859/883104

_assert-permissions "$HOME/" "drwx------"

SSH_ROOT="$HOME/.ssh"
_assert-permissions "$SSH_ROOT/" "drwx------"
_assert-permissions "$SSH_ROOT/authorized_keys" "-rw-r--r--"
_assert-permissions "$SSH_ROOT/known_hosts" "-rw-------"

for key in $(\find "$SSH_ROOT/" -name "*.pub"); do
    if [[ -L "$key" ]]; then
        continue # ignore links
    fi
    _assert-permissions "$key"        "-rw-r--r--"  # public key
    _assert-permissions "${key:0:-4}" "-rw-------"  # private key
done

