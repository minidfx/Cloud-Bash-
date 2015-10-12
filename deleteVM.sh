#!/bin/sh

. "./configuration.sh"

if [ -z "$1" ]; then
        echo "ERROR: You have to specify the ID of the server to delete."
        echo "Usage: $0 <id>"
        exit 1
fi

echo "Deleting the server $ID ..."
nova delete $ID
