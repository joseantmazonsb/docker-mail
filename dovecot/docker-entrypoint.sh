#!/bin/bash

# Copy current configuration (without overwriting) to mounted directory
cp -rn $TARGET_PATH/* $INSTALL_PATH
# Delete current configuration
rm -rf $TARGET_PATH
# Link configuration located in mounted directory
ln -sf $INSTALL_PATH $TARGET_PATH

# Set permissions

groupadd -g $VMAIL_GID $VMAIL_GROUP
useradd -g $VMAIL_GROUP -u $VMAIL_UID $VMAIL_USER -d /var/mail
chown -R $VMAIL_USER:$VMAIL_GROUP /var/mail
chmod -R o-rwx $TARGET_PATH

dovecot -F
