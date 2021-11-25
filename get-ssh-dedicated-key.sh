#!/bin/sh

if [ "$2" != "" ]; then
	host=$1
	user=$2
	echo "$HOME/.serverfarmer/ssh/key-$user@$host"
else
	echo "-"
fi
