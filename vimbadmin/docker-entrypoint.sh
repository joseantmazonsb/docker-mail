#!/bin/bash

function create_tables {
    MAX_TRIES=5
    times_tried=0
    while [ "$times_tried" -lt "$MAX_TRIES" ]; do
        echo -n "[INFO] Creating DB tables..."
        result=$($INNER_PATH/bin/doctrine2-cli.php orm:schema-tool:create 2>&1)
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

function set_conf {
    shopt -s dotglob # Consider hidden files (.files)
    cp -rn $INNER_PATH/* $EXPORTED_PATH
    rm -rf $INNER_PATH
    ln -sf $EXPORTED_PATH $INNER_PATH
    chown -R www-data: $INNER_PATH/var
}

function replace_by_regex {
    regex=$1
    new_text=$2
    file=$3
    sed -i -E "s;$regex;\1$new_text;g" $file
}

function set_secrets {
    secrets_path="/run/secrets"

    mysql_db_file="$secrets_path/mysql_db"
    mysql_user_file="$secrets_path/mysql_user"
    mysql_pwd_file="$secrets_path/mysql_pwd"

    mysql_db=$(cat $mysql_db_file | head -1)
    mysql_user=$(cat $mysql_user_file | head -1)
    mysql_pwd=$(cat $mysql_pwd_file | head -1)

    file="$INNER_PATH/application/configs/application.ini"

    prefix="resources.doctrine2.connection.options."
    suffix="[[:space:]]+=).+"
    regex="(${prefix}dbname${suffix}"
    replace_by_regex $regex "'$mysql_db'" $file

    regex="(${prefix}user${suffix}"
    replace_by_regex $regex "'$mysql_user'" $file

    regex="(${prefix}password${suffix}"
    replace_by_regex $regex "'$mysql_pwd'" $file
}

function set_new_domain_name {    
    old_name="example.com"
    domain_file="$INNER_PATH/.domain_name"
    if [ -f $domain_file ]; then
        contents=$(cat $domain_file)
        if [ "$contents" != "" ]; then
            old_name="$contents"
        fi
    fi

    new_name="$DOMAIN_NAME"

    files=("$INNER_PATH/application/configs/application.ini" "/etc/apache2/sites-available/vimbadmin.conf")
    for file in "${files[@]}"
    do
        sed -i "s/$old_name/$new_name/g" $file
    done
    echo $new_name > $domain_file
}

function start {
    echo "[INFO] Starting server..."
    set_new_domain_name
    set_secrets
    set_conf
    # Check if install path contains flag
    flag_file="$INNER_PATH/.times_started"
    if [ ! -f "$flag_file" ]; then
        fresh_start
        echo 1 > $flag_file
    else 
        times_started=$(cat $flag_file)
        let "times_started++"
        echo $times_started > $flag_file
    fi
    apachectl -DFOREGROUND
}

start
