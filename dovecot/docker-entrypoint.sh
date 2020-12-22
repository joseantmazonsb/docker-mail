#!/bin/bash

function set_conf {
    # Copy current configuration (without overwriting) to mounted directory
    cp -rn $TARGET_PATH/* $INSTALL_PATH
    # Delete current configuration
    rm -rf $TARGET_PATH
    # Link configuration located in mounted directory
    ln -sf $INSTALL_PATH $TARGET_PATH
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

    files_affected=("$TARGET_PATH/dovecot-sql.conf.ext")

    for file in "${files_affected[@]}"; do
        regex="(dbname=)[^\\s]+"
        replace_by_regex $regex $mysql_db $file_affected

        regex="(user=)[^\\s]+"
        replace_by_regex $regex $mysql_user $file_affected

        regex="(password=)[^\\s]+"
        replace_by_regex $regex $mysql_pwd $file_affected
    done
}

function set_new_domain_name {    
    old_name="example.com"
    domain_file="/.domain_name"
    if [ -f $domain_file ]; then
        contents=$(cat $domain_file)
        if [ "$contents" != "" ]; then
            old_name="$contents"
        fi
    fi

    new_name="$DOMAIN_NAME"

    files_affected=("$TARGET_PATH/dovecot-sql.conf.ext" "$TARGET_PATH/conf.d/10-mail.conf")
    for file in "${files_affected[@]}"; do
        sed -i "s/$old_name/$new_name/g" $file
    done
    echo $new_name > $domain_file
}

function start {
    set_conf
    set_secrets
    set_domain_name
    dovecot -F    
}

start
