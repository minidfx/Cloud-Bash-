#!/bin/bash

. "./configuration.sh"

if [ -z "$1" ]; then
        echo "ERROR: You have to specify at least an ID of a server."
        echo "Usage: $0 <id> [id idn]"
        exit 1
fi

for ID in $@
do
        echo  -n "Deleting the server $ID ... "
        nova delete $ID
        echo "Done."
done
