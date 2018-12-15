#!/bin/sh
. /opt/farm/scripts/init

/opt/farm/scripts/setup/extension.sh sf-passwd-utils

key=`/opt/farm/ext/keys/get-ssh-management-key-content.sh $HOST`
/opt/farm/ext/passwd-utils/add-key.sh root inline "$key"


# TODO: Ubuntu 14.04 LTS and newer has Samba installed and group sambashare
# created right after fresh install. Detect similar cases, change GID of this
# group and chgrp directories previously group-owned by sambashare group.

/opt/farm/ext/passwd-utils/create-group.sh mfs 140
/opt/farm/ext/passwd-utils/create-group.sh sambashare 150
/opt/farm/ext/passwd-utils/create-group.sh imapusers 160
# RHEL registered GIDs: 170 avahi-autoipd, 190 systemd-journal


# you can put your custom logic here
/opt/farm/scripts/setup/extension.sh sf-mc-black
