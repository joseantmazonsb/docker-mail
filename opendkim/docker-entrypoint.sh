#!/bin/bash

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

opendkim -f
