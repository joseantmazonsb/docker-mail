#!/bin/bash

# Functions

function fresh_start {
    echo "[INFO] Preparing for first start..."
    ln -s $REAL_PATH/* $INSTALL_PATH
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