#!/bin/bash

server=$1

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
else
	domain="${server##*.}"
fi

if [ -s /opt/farm/ext/keys/ssh/id.$domain ]; then
	cat /opt/farm/ext/keys/ssh/id.$domain
else
	cat /opt/farm/ext/keys/ssh/id.default
fi
