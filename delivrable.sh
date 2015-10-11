#!/bin/sh

source ./restoreSnapshots.sh $1

read INPUT

while [ "$INPUT" != "A" ]
do
       read -a INPUT     
done

IFS=',' read -a snapshots <<< "$1"

for ID in $snapshots
do
	echo "Deleting the servere $ID ..." 
       #source deleteVM.sh $ID
done

