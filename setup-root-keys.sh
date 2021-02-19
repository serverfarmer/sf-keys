#!/bin/sh
. /opt/farm/scripts/init

if [ "`which lsattr 2>/dev/null`" != "" ] && [ "`lsattr -l ~/.ssh/authorized_keys |grep Immutable`" != "" ]; then
	echo "skipping key setup, authorized_keys file is immutable"
	exit 0
fi

for KEY in `ls /opt/farm/ext/keys/ssh`; do
	/opt/farm/ext/passwd-utils/add-key.sh root file /opt/farm/ext/keys/ssh/$KEY
done
