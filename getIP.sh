#!/bin/sh

. "./configuration.sh"

if [ -z "$1" ]; then
        echo "ERROR: You have to specify the name of the instance."
        echo "Usage: source restoreSnapshot.sh <instance_name> <command>"
        return 1
fi

network=`cat /tmp/servers.list | grep $1 | sed -n 's/.*\=\([^|]*\).*/\1/p'`
IFS=', ' read -ra addresses <<< "$network"

if [ ${#addresses[@]} -lt 1 ]; then
	echo "Cannot found the address IP of the instance $1"
	return
fi

echo ${addresses[0]}
