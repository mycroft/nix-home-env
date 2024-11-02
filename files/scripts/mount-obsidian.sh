#!/bin/sh

# this script is used to mount the obsidian vault

pass Personal/obsidian | \
    head -1 | \
    tr -d '\n' | \
    gocryptfs ${HOME}/.sync/vault.obsidian/ ${HOME}/.obsidian
