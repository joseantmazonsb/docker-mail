#!/bin/bash

# Copy current configuration (without overwriting) to mounted directory
cp -rn $TARGET_PATH/* $INSTALL_PATH
# Delete current configuration
rm -rf $TARGET_PATH
# Link configuration located in mounted directory
ln -sf $INSTALL_PATH $TARGET_PATH

chown -R opendkim:opendkim $TARGET_PATH

opendkim -f
