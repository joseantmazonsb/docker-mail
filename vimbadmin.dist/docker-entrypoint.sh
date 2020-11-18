#!/bin/bash

MAX_TRIES=3
times_tried=0
while [ "$times_tried" -lt "$MAX_TRIES" ]; do
    $INSTALL_PATH/bin/doctrine2-cli.php orm:schema-tool:create
    if [[ "$?" -eq 0 ]]; then
        echo "[INFO] Starting web server..."
        exec "$@"
    fi
    let "times_tried++"
    sleep 5
done
echo "[ERROR] Unable to connect to DB."
exit 1
