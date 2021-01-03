#!/bin/bash

function set_conf {
    shopt -s dotglob # Consider hidden files (.files)
    cp -rn $INNER_PATH/* $EXPORTED_PATH
    rm -rf $INNER_PATH
    ln -sf $EXPORTED_PATH $INNER_PATH
}

function set_permissions {
    chmod -R o-rwx $INNER_PATH
    chown -R vmail:vmail /var/mail
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

    file="$INNER_PATH/dovecot-sql.conf.ext"

    regex="(dbname=)\S+"
    replace_by_regex $regex $mysql_db $file

    regex="(user=)\S+"
    replace_by_regex $regex $mysql_user $file

    regex="(password=)\S+"
    replace_by_regex $regex $mysql_pwd $file
}

function set_new_domain_name {    
    old_name="example.com"
    domain_file="$EXPORTED_PATH/.domain_name"
    if [ -f $domain_file ]; then
        contents=$(cat $domain_file)
        if [ "$contents" != "" ]; then
            old_name="$contents"
        fi
    fi

    new_name="$DOMAIN_NAME"

    files_affected=("$EXPORTED_PATH/dovecot-sql.conf.ext" "$EXPORTED_PATH/conf.d/10-mail.conf")
    for file in "${files_affected[@]}"
    do
        sed -i "s/$old_name/$new_name/g" $file
    done
    echo $new_name > $domain_file
}

function set_logs {
    if [ ! -d $LOGS_FOLDER ]; then
        mkdir -p $LOGS_FOLDER
    fi
}

function start {
    echo "[INFO] Starting server..."
    set_secrets
    set_logs
    set_conf
    set_permissions
    set_new_domain_name
    dovecot -F    
}

start
