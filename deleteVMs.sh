#!/bin/sh

. "./configuration.sh"

if [ -z "$1" ]; then
        echo "ERROR: You have to specify a list of Snapshot IDs separate by a comma."
        echo "Usage: source deleteVMs.sh <id1,id2,idn>"
        return 1
fi

IFS=',' read -a servers <<< "$1"

for ID in $servers
do
        echo "Deleting server $ID ..."

        nova delete $ID
done

