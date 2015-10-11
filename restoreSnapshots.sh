#!/bin/sh

. "./configuration.sh"

if [ -z "$1" ]; then
	echo "You have to specify a list of Snapshot IDs separate by a comma."
	echo "Usage: $0 <id1,id2,idn>"
	return 1
fi

IFS=',' read -a snapshots <<< "$1"

for ID in $snapshots
do
	echo "Restoring and starting $ID ..."

	nova boot --flavor=1 --image=$ID $ID
done
