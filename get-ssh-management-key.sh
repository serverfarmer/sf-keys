#!/bin/bash
. /opt/farm/scripts/functions.custom

server=$1

if [[ $server == *"amazonaws.com" ]]; then
	domain="ec2"
elif [[ $server == *"bc.googleusercontent.com" ]]; then
	domain="gce"
elif [[ $server == *"cloudapp.azure.com" ]]; then
	domain="azure"
elif [[ $server == *"e24cloud.com" ]]; then
	domain="e24"
elif [[ $server == *"lxc-"* ]]; then
	domain="lxc"
elif [[ $server == *".gw.`external_domain`" ]]; then
	domain="${server%%.*}"
elif [[ $server =~ ^[0-9]+[.][0-9]+[.][0-9]+[.][0-9]+$ ]]; then
	domain="default"
else
	domain="${server##*.}"
fi

if [ "$domain" == "pl" ] || [ "$domain" == "com" ] || [ "$domain" == "net" ]; then
	tmp="${server%.*}"
	domain="${tmp##*.}"
fi

key="/etc/local/.ssh/id_backup_$domain"

if [ -f $key ] || [ -h $key ]; then
	echo $key
else
	/opt/farm/ext/keys/get-ssh-dedicated-key.sh $server root
fi
