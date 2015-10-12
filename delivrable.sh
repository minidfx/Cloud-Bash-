#!/bin/sh

SERVER1="MongoDB"
SERVER2="RESTClient"
SERVER3="RESTServer"
SERVERS="$SERVER1,$SERVER2,$SERVER3"

./restoreSnapshots.sh $SERVERS

SERVER1_IP=`./getIP.sh $SERVER1`

./executeCommand.sh $SERVER2 'python ~/Downloads/pyClient.py $SERVER1_IP &'
./executeCommand.sh $SERVER3

echo ""
echo "Enter A to abort the script and deleting the VMs previously created."

read INPUT

while [ "$INPUT" != "A" ]
do
       read -a INPUT
done

IFS=',' read -a snapshots <<< "$1"

for ID in $snapshots
do
	source deleteVM.sh $ID
done
