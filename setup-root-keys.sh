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

# detect if the current host is a cloud instance with its own public hostname
# TODO: detect Microsoft Azure
if [ -f /etc/image-id ] && grep -q ami-ecs /etc/image-id; then
	add_root_key ecs
elif [ -d /sys/class/dmi/id ] && grep -qi amazon /sys/class/dmi/id/* 2>/dev/null; then
	add_root_key ec2
elif [ -d /sys/class/dmi/id ] && grep -qi google /sys/class/dmi/id/* 2>/dev/null; then
	add_root_key gce
fi
