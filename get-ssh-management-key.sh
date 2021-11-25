#!/bin/bash

server=$1
external=`/opt/farm/config/get-external-domain.sh`
type="adm"

if [ "$server" == "" ]; then
	domain="default"
elif [[ $server == *"amazonaws.com" ]]; then
	domain="ec2"
elif [[ $server == *"bc.googleusercontent.com" ]]; then
	domain="gce"
elif [[ $server == *"cloudapp.azure.com" ]]; then
	domain="azure"
elif [[ $server == *"e24cloud.com" ]]; then
	domain="e24"
elif [[ $server == *"linode.com" ]]; then
	domain="linode"
elif [[ $server == *"ecs-"* ]]; then
	domain="ecs"
elif [[ $server == *"lxc-"* ]]; then
	domain="lxc"
elif [[ $server == *".gw.$external" ]]; then
	domain="${server%%.*}"
	type="gw"
elif [[ $server =~ ^[0-9]+[.][0-9]+[.][0-9]+[.][0-9]+$ ]]; then
	domain="ip"
else
	domain="${server##*.}"
	type="ext"
fi

if [ "$domain" == "pl" ] || [ "$domain" == "com" ] || [ "$domain" == "net" ] || [ "$domain" == "dev" ]; then
	tmp="${server%.*}"
	domain="${tmp##*.}"
fi

key="$HOME/.serverfarmer/ssh/id_${type}_${domain}"

if [ -f $key ] || [ -h $key ]; then
	echo $key
else
	/opt/farm/ext/keys/get-ssh-dedicated-key.sh $server root
fi
