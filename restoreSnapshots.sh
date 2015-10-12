#!/bin/bash

. "./configuration.sh"

FLAVOR=baaba9ad-9ee5-4f1d-a7a1-dd4b55c18b63
NETWORK_ID=685a78ae-602e-4b80-9b54-97bdfcef5c2f
SECURITY_GROUP=anywhere

echo -n "Restoring and starting MongoDB ... "
nova boot --flavor=$FLAVOR --image=MongoDB --nic net-id=$NETWORK_ID --security-groups $SECURITY_GROUP MongoDB > /dev/null
nova floating-ip-associate MongoDB 86.119.33.239
echo "Done".

./cacheServerList.sh

MongoDB_IP=`./getIP.sh MongoDB`

# Create the startup script the RESTClient
echo -e "#\!/bin/bash\n\n\pyhton restclient.py $MongoDB_IP &" > restClient.sh
# Create the startup script for the RESTServer
echo -e "#\!/bin/bash\n\n\pyhton restserver.py $MongoDB_IP &" > restServer.sh

echo -n "Restoring and starting RESTServer ... "
nova boot --user-data=./restServer.sh --flavor=$FLAVOR --image=RESTServer --nic net-id=$NETWORK_ID --security-groups $SECURITY_GROUP RESTServer > /dev/null
nova floating-ip-associate RESTServer 86.119.33.32
echo "Done".

echo -n "Restoring and starting RESTClient ... "
nova boot --user-data=./restClient.sh --flavor=$FLAVOR --image=RESTClient --nic net-id=$NETWORK_ID --security-groups $SECURITY_GROUP RESTClient > /dev/null
nova floating-ip-associate RESTClient 86.119.33.34
echo "Done".

rm restClient.sh
rm restServer.sh

echo -n "Waiting 15 seconds for servers are started ... "
sleep 15
echo "Done."

./cacheServerList.sh

if [ ! -f "/tmp/servers.list" ]; then
			echo "The cache server doesn't exist."
			exit 1
fi

for arg in "MongoDB" "RESTServer" "RESTClient"
do
	network=`cat /tmp/servers.list | grep $arg | sed -n 's/.*\=\([^|]*\).*/\1/p'`
	IFS=', ' read -ra addresses <<< "$network"

	if [ ${#addresses[@]} -lt 1 ]; then
		echo "ERROR: The server $arg isn't started!"
	else
		echo -n "Checking whether the server $arg (${addresses[0]}) is running ... "

		# I send an empty string because the nc block when no data is sent.
		result=`echo "" | nc ${addresses[0]} 22 | grep --color=never SSH`

		if [ -z "$result" ]; then
			echo "ERROR: The server is not reachable over SSH."
		else
			echo "Done."
		fi
	fi
done
