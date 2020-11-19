#!/bin/bash

# Functions

function fresh_start {
    echo "[INFO] Preparing for first start..."
    cp -rp $TMP_PATH/* $INSTALL_PATH
    rm -rf $TMP_PATH
}

function start_server {
    echo "[INFO] Starting server..."
    tail -f /dev/null
    #postfix start-fg
}

# Check if install path empty
if [ ! "$(ls -A $INSTALL_PATH)" ]; then
    fresh_start
fi
start_server