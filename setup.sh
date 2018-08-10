#!/bin/bash
. /opt/farm/scripts/init
. /opt/farm/scripts/functions.custom
. /opt/farm/ext/keys/functions



echo "preparing ssh key"
FULLKEY=`ssh_management_key_string $HOST`

if [ ! -f /root/.ssh/authorized_keys ] || ! grep -q "$FULLKEY" /root/.ssh/authorized_keys; then
	echo "setting up root ssh key"
	mkdir -p /root/.ssh
	echo "$FULLKEY" >>/root/.ssh/authorized_keys
fi

echo "checking custom system groups"
/opt/farm/ext/passwd-utils/create-group.sh mfs 140
/opt/farm/ext/passwd-utils/create-group.sh sambashare 150
/opt/farm/ext/passwd-utils/create-group.sh imapusers 160