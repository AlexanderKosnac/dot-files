#!/bin/bash

# Automatically parses a makefile and provides autocompletion.
# https://stackoverflow.com/a/38415982/6921511

complete -W "\`grep -oE '^[a-zA-Z0-9_.-]+:([^=]|$)' ?akefile | sed 's/[^a-zA-Z0-9_.-]*$//'\`" make
