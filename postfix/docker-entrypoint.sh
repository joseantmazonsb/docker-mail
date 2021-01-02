#!/bin/bash

function set_conf {
    shopt -s dotglob # Consider hidden files (.files)
    cp -rn $INNER_PATH/* $EXPORTED_PATH
    rm -rf $INNER_PATH
    ln -sf $EXPORTED_PATH $INNER_PATH
}

function replace_host {
    look_for=$1
    replace_with=$(cat /etc/hosts | grep $look_for | xargs | cut -d " " -f 1)
    find $INNER_PATH -type f -exec sed -i "s/$look_for/$replace_with/g" {} \;
}

function replace_hosts {
    # Postfix implementation is ridiculous and won't resolve hosts present in /etc/hosts.
    # This little hack makes thing possible:
    replace_host "db_host"
    replace_host "dovecot_host"
    replace_host "opendkim_host"
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

    readarray -d '' files_affected < <(find "$INNER_PATH/sql" -type f -print0)
    suffix="[[:space:]]+=).+"
    
    for file in "${files_affected[@]}"
    do
        regex="(user${suffix}"
        replace_by_regex $regex " $mysql_user" $file

        regex="(password${suffix}"
        replace_by_regex $regex " $mysql_pwd" $file

        regex="(dbname${suffix}"
        replace_by_regex $regex " $mysql_db" $file
    done

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

    files_affected=("$EXPORTED_PATH/main.cf")
    for file in "${files_affected[@]}"; do
        sed -i "s/$old_name/$new_name/g" $file
    done
    echo $new_name > $domain_file
}

function start {
    echo "[INFO] Starting server..."
    set_secrets
    replace_hosts
    set_conf
    set_new_domain_name
    cp /etc/resolv.conf /var/spool/postfix/etc/resolv.conf
    cp /etc/services /var/spool/postfix/etc/services
    postfix start-fg
}

start
