#!/bin/bash

FILE="${HOME}/.cargo/env"
if [ -f "$FILE" ]; then
    source "$FILE"
fi
