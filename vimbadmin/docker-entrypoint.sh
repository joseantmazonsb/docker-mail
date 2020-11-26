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
        result=$($TARGET_PATH/bin/doctrine2-cli.php orm:schema-tool:create 2>&1)
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
    create_tables
}

# Copy current configuration (without overwriting) to mounted directory
cp -rn $TARGET_PATH/* $INSTALL_PATH
# Delete current configuration
rm -rf $TARGET_PATH
# Link configuration located in mounted directory
ln -sf $INSTALL_PATH $TARGET_PATH

cd $TARGET_PATH
chown -R www-data: $TARGET_PATH/var


# Check if install path contains flag
flag_file="$INSTALL_PATH/times_started"
if [ ! -f "$flag_file" ]; then
    fresh_start
    echo 1 > $flag_file
else 
    times_started=$(cat $flag_file)
    let "times_started++"
    echo $times_started > $flag_file
fi
start_server
