#!/bin/sh
. /opt/farm/scripts/init

add_root_key() {
	key=`/opt/farm/ext/keys/get-ssh-management-key-content.sh $1`
	/opt/farm/ext/passwd-utils/add-key.sh root inline "$key"
}


add_root_key $HOST

# actual server hostname can differ from configured one
current=`hostname`
if [ "$HOST" != "$current" ]; then
	add_root_key $current
fi


# TODO: detect also Microsoft Azure and Google Cloud (and only these)

# detect Amazon EC2/ECS and install also keys for one of these
if [ -f /etc/image-id ] && grep -q ami-ecs /etc/image-id; then
	add_root_key ecs-null
elif [ -d /sys/class/dmi/id ] && grep -qi amazon /sys/class/dmi/id/* 2>/dev/null; then
	add_root_key .amazonaws.com
fi


# TODO: Ubuntu 14.04 LTS and newer has Samba installed and group sambashare
# created right after fresh install. Detect similar cases, change GID of this
# group and chgrp directories previously group-owned by sambashare group.

/opt/farm/ext/passwd-utils/create-group.sh mfs 140
/opt/farm/ext/passwd-utils/create-group.sh sambashare 150
/opt/farm/ext/passwd-utils/create-group.sh imapusers 160
# RHEL registered GIDs: 170 avahi-autoipd, 190 systemd-journal


# you can put your custom logic here
/opt/farm/scripts/setup/extension.sh sf-mc-black
