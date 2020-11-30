#!/bin/bash

function replace_host {
    look_for=$1
    replace_with=$(cat /etc/hosts | grep $look_for | xargs | cut -d " " -f 1)
    find $INSTALL_PATH -type f -exec sed -i "s/$look_for/$replace_with/g" {} \;
}

function hook_postfix {
    replace_host "db_host"
    replace_host "dovecot_host"
    replace_host "opendkim_host"
}

# Copy current configuration (without overwriting) to mounted directory
cp -rn $TARGET_PATH/* $INSTALL_PATH
# Delete current configuration
rm -rf $TARGET_PATH
# Link configuration located in mounted directory
ln -sf $INSTALL_PATH $TARGET_PATH

# Postfix implementation is ridiculous and won't resolve hosts present in /etc/hosts.
# This little hack makes thing possible:
hook_postfix

cp /etc/resolv.conf /var/spool/postfix/etc/resolv.conf
cp /etc/services /var/spool/postfix/etc/services
postfix start-fg
