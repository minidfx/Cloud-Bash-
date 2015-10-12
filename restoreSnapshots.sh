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
	echo -n "Restoring and starting $ID ... "
	nova boot --flavor=$FLAVOR --image=$ID --nic net-id=$NETWORK_ID $ID > /dev/null
	echo "Done".
done

./cacheServerList.sh

echo -n "Waiting 7 seconds ... "
sleep 7
echo "Done."

for ID in $snapshots
do
	network=`cat /tmp/servers.list | grep $ID | sed -n 's/.*\=\([^|]*\).*/\1/p'`
	IFS=', ' read -ra addresses <<< "$network"

	if [ ${#addresses[@]} -lt 1 ]; then
		echo "ERROR: The server $ID isn't started!"
	else
		echo -n "Checking whether the server $ID (${addresses[0]}) is running ... "

		# I send an empty string because the nc block when no data is sent.
		result=`echo "" | nc ${addresses[0]} 22 | grep --color=never SSH`
		
		if [ -z "$result" ]; then
			echo "ERROR: The server is not reachable over SSH."
		else
			echo "Done."
		fi
	fi
done
