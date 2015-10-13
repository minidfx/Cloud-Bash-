#!/bin/bash

. "./configuration.sh"

FLAVOR=baaba9ad-9ee5-4f1d-a7a1-dd4b55c18b63
NETWORK_ID=685a78ae-602e-4b80-9b54-97bdfcef5c2f
SECURITY_GROUP=anywhere

echo -n "Restoring and starting MongoDB ... "
nova boot --flavor=$FLAVOR --key-name switch-engine --image=MongoDB --nic net-id=$NETWORK_ID --security-groups $SECURITY_GROUP,default MongoDB > /dev/null
nova floating-ip-associate MongoDB 86.119.33.239
echo "Done".

./cacheServerList.sh

./waitForServer.sh MongoDB
MongoDB_IP=`./getIP.sh MongoDB`

echo -n "Restoring and starting RESTServer ... "
nova boot --key-name switch-engine --flavor=$FLAVOR --image=RESTServer --nic net-id=$NETWORK_ID --security-groups $SECURITY_GROUP,default RESTServer > /dev/null
nova floating-ip-associate RESTServer 86.119.33.32
echo "Done."

echo -n "Restoring and starting RESTClient ... "
nova boot --key-name switch-engine --flavor=$FLAVOR --image=RESTClient --nic net-id=$NETWORK_ID --security-groups $SECURITY_GROUP,default RESTClient > /dev/null
nova floating-ip-associate RESTClient 86.119.33.34
echo "Done."

for arg in "RESTServer" "RESTClient"
do
	./waitForServer.sh $arg
done

restServer_IP=`./getIP.sh RESTServer`
restClient_IP=`./getIP.sh RESTClient`

# I use SSH instead of nova command with --user-data argument because it doesn't work in my case..
ssh -i ~/.ssh/switch-engine ubuntu@$restServer_IP 'nohup python Downloads/restserver.py $MongoDB_IP &' &
ssh -i ~/.ssh/switch-engine ubuntu@$restClient_IP 'nohup python Downloads/restclient.py $MongoDB_IP &' &
