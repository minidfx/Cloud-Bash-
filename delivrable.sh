#!/bin/sh

source ./restoreSnapshots.sh $1

echo ""
echo "Press A to abort the script and deleting the VMs previously created."

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

