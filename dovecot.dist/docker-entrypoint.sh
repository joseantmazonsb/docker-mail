#!/bin/bash

# Functions

function fresh_start {
    cp -a $TMP_PATH/* $INSTALL_PATH
    rm -rf $TMP_PATH
}

function start_server {
    echo "[INFO] Starting server..."
    exec "$@"
}
chown -R vmail:dovecot $INSTALL_PATH
chmod -R o-rwx $INSTALL_PATH
# Check if install path empty
if [ -z "$(ls -A $INSTALL_PATH)" ]; then
    fresh_start
fi
start_server