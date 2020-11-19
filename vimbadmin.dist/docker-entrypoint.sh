#!/bin/bash

# Functions

function start_server {
    echo "[INFO] Starting server..."
    exec "$@"
}

function fresh_start {
    cp -a $TMP_PATH/* $INSTALL_PATH/
    rm -rf $TMP_PATH
    # Start
    MAX_TRIES=3
    times_tried=0
    while [ "$times_tried" -lt "$MAX_TRIES" ]; do
        $INSTALL_PATH/bin/doctrine2-cli.php orm:schema-tool:create
        if [[ "$?" -eq 0 ]]; then
            return
        fi
        let "times_tried++"
        sleep 5
    done
    echo "[ERROR] Unable to connect to DB."
    exit 1
}

chown www-data $INSTALL_PATH
# Check if install path empty
if [ -z "$(ls -A $INSTALL_PATH)" ]; then
    fresh_start
fi
start_server
