#!/bin/sh

. "./configuration.sh"

if [ -z "$1" ]; then
	echo "ERROR: You have to specify a list of Snapshot IDs separate by a comma."
	echo "Usage: source restoreSnapshot.sh <id1,id2,idn>"
	return 1
fi

IFS=',' read -a snapshots <<< "$1"
FLAVOR=baaba9ad-9ee5-4f1d-a7a1-dd4b55c18b63
NETWORK_ID=685a78ae-602e-4b80-9b54-97bdfcef5c2f

for ID in $snapshots
do
	echo "Restoring and starting $ID ..."

	nova boot --flavor=$FLAVOR --image=$ID --nic net-id=$NETWORK_ID $ID
done
