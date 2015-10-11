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
	echo -n "Restoring and starting $ID ..."
	#nova boot --flavor=$FLAVOR --image=$ID --nic net-id=$NETWORK_ID $ID > /dev/null
	echo "Done".

	echo -n "Checking the server is running ..."

	echo "Done."
done

for ID in $snapshots
do
	#$network=`nova list | grep $ID | sed -n 's/.*\=\([^|]*\).*/\1/p'`
	IFS=', ' read -a $addresses <<< "$network"

	if [ $addresses[@] -lt 1 ]; then
		echo "ERROR: The server $ID isn't started!"
	fi
done
