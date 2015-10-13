#!/bin/bash

. "./configuration.sh"

FLAVOR=baaba9ad-9ee5-4f1d-a7a1-dd4b55c18b63
NETWORK_ID=685a78ae-602e-4b80-9b54-97bdfcef5c2f
SECURITY_GROUP=anywhere

echo -n "Restoring and starting MongoDB ... "
nova boot --flavor=$FLAVOR --image=MongoDB --nic net-id=$NETWORK_ID --security-groups $SECURITY_GROUP MongoDB > /dev/null
nova floating-ip-associate MongoDB 86.119.33.239
echo "Done".

./waitForServer.sh MongoDB
MongoDB_IP=`./getIP.sh MongoDB`

# Create the startup script for the RESTClient
echo -e "#\!/bin/bash\n\npython /home/ubuntu/Downloads/restclient.py $MongoDB_IP &" > restClient.sh
# Create the startup script for the RESTServer
echo -e "#\!/bin/bash\n\npython /home/ubuntu/Downloads/restserver.py $MongoDB_IP &" > restServer.sh

echo -n "Restoring and starting RESTServer ... "
nova boot -debug --user-data=./restServer.sh --flavor=$FLAVOR --image=RESTServer --nic net-id=$NETWORK_ID --security-groups $SECURITY_GROUP RESTServer > /dev/null
nova floating-ip-associate RESTServer 86.119.33.32
echo "Done."

exit 1

echo -n "Restoring and starting RESTClient ... "
nova boot --user-data=./restClient.sh --flavor=$FLAVOR --image=RESTClient --nic net-id=$NETWORK_ID --security-groups $SECURITY_GROUP RESTClient > /dev/null
nova floating-ip-associate RESTClient 86.119.33.34
echo "Done."

rm restClient.sh
rm restServer.sh

for arg in "RESTServer" "RESTClient"
do
	./waitForServer.sh $arg
done
