#!/bin/sh

if [ "$1" != "" ]; then
	device=$1
	echo "/etc/local/.ssh/id_backup_$device"
else
	echo "-"
fi
