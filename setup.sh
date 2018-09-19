#!/bin/sh
. /opt/farm/scripts/init


echo "preparing ssh key"
FULLKEY=`/opt/farm/ext/keys/get-ssh-management-key-content.sh $HOST`

if [ ! -f /root/.ssh/authorized_keys ] || ! grep -q "$FULLKEY" /root/.ssh/authorized_keys; then
	echo "setting up root ssh key"
	mkdir -p /root/.ssh
	echo "$FULLKEY" >>/root/.ssh/authorized_keys
fi


# TODO: Ubuntu 14.04 LTS and newer has Samba installed and group sambashare
# created right after fresh install. Detect similar cases, change GID of this
# group and chgrp directories previously group-owned by sambashare group.

/opt/farm/scripts/setup/extension.sh sf-passwd-utils
echo "checking custom system groups"
/opt/farm/ext/passwd-utils/create-group.sh mfs 140
/opt/farm/ext/passwd-utils/create-group.sh sambashare 150
/opt/farm/ext/passwd-utils/create-group.sh imapusers 160
# RHEL registered GIDs: 170 avahi-autoipd, 190 systemd-journal


# you can put your custom logic here
/opt/farm/scripts/setup/extension.sh sf-mc-black
