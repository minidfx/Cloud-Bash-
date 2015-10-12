#!/bin/bash

. "./configuration.sh"

if [ -z "$1" ]; then
        echo "ERROR: You have to specify the name of the instance."
        echo "Usage: $0 <instance_name> <command>"
        exit 1
fi

if [ ! -f "/tmp/servers.list" ]; then
        echo "Cache of servers doesn't exist."
        exit 1
fi

network=`cat /tmp/servers.list | grep $1 | sed -n 's/.*\=\([^|]*\).*/\1/p'`
IFS=', ' read -ra addresses <<< "$network"

if [ ${#addresses[@]} -lt 1 ]; then
	echo "Cannot found the address IP of the instance $1"
	exit 1
fi

echo ${addresses[0]}
