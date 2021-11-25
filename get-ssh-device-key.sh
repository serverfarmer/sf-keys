#!/bin/sh

if [ "$1" != "" ]; then
	device=$1
	echo "$HOME/.serverfarmer/ssh/id_device_$device"
else
	echo "-"
fi
