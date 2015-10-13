#!/bin/bash

./restoreSnapshots.sh

echo "Servers up."
echo "Enter A to abort the script and deleting the VMs previously created."

read INPUT

while [ "$INPUT" != "A" ]
do
       read -a INPUT
done

./deleteVM.sh MongoDB RESTServer RESTClient
