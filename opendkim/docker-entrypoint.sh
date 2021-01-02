#!/bin/bash

filename="opendkim.conf"

function set_conf {
    cp -rn $INNER_PATH/$filename $EXPORTED_PATH
    rm -f $INNER_PATH/$filename
    ln -sf $EXPORTED_PATH/$filename $INNER_PATH
    chown -R opendkim:opendkim /etc/dkimkeys/
    find /etc/dkimkeys -type f -exec chmod 0600 {} \;
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

    sed -i "s/$old_name/$new_name/g" "$EXPORTED_PATH/$filename"
    echo $new_name > $domain_file
}

function start {
    echo "[INFO] Starting server..."
    set_conf
    set_new_domain_name
    opendkim -f
}

start
