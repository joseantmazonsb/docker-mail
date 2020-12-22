#!/bin/bash

function set_conf {
    # Copy current configuration (without overwriting) to mounted directory
    cp -rn $TARGET_PATH/* $INSTALL_PATH
    # Delete current configuration
    rm -rf $TARGET_PATH
    # Link configuration located in mounted directory
    ln -sf $INSTALL_PATH $TARGET_PATH

    cp -r $INSTALL_PATH/keys/* /etc/dkimkeys/
    chown -R opendkim:opendkim /etc/dkimkeys/
    find /etc/dkimkeys/ -name "*.private" -type f -exec chmod 0600 {} \;
    #chown -R opendkim:opendkim $TARGET_PATH
    mv $TARGET_PATH/opendkim.conf /etc/
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

    files_affected=("$TARGET_PATH/main.cf")
    for file in "${files_affected[@]}"; do
        sed -i "s/$old_name/$new_name/g" $file
    done
    echo $new_name > $domain_file
}

function start {
    set_conf
    set_new_domain_name
    # TODO: change name of keys/example.com
    opendkim -f
}

start
