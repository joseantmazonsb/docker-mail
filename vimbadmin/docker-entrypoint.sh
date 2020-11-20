#!/bin/bash

# Functions

function start_server {
    echo "[INFO] Starting server..."
    apachectl -DFOREGROUND
}

function create_tables {
    MAX_TRIES=5
    times_tried=0
    while [ "$times_tried" -lt "$MAX_TRIES" ]; do
        echo -n "[INFO] Creating DB tables..."
        result=$($INSTALL_PATH/bin/doctrine2-cli.php orm:schema-tool:create 2>&1)
        if [[ "$?" -eq 0 ]]; then
            echo " [OK]"
            return
        else
            echo "$result" | grep -q "Connection refused"
            if [[ "$?" -eq 0 ]]; then
                echo " [KO]"
                echo "[WARN] Connection refused. Retrying in 5 seconds..."
                let "times_tried++"
                sleep 5
            else
                echo "$result" | grep -q "already exists"
                if [[ "$?" -eq 0 ]]; then
                    echo " [OK]"
                    echo "[WARN] DB tables already exist."
                    return
                else
                    echo " [KO]"
                    echo "[ERR] Unhandled exception."
                    echo "$result"
                    break
                fi
            fi
        fi
    done
    echo "[FATAL] Unable to connect to DB."
    exit 1
}

function fresh_start {
    echo "[INFO] Preparing for first start..."
    ln -s $REAL_PATH/* $INSTALL_PATH
    create_tables
}

# Check if install path empty
if [ ! "$(ls -A $INSTALL_PATH)" ]; then
    fresh_start
fi
start_server
