#!/bin/sh

. "./configuration.sh"

if [ -z "$1" ]; then
        echo "ERROR: You have to specify the ID of the server to delete."
        echo "Usage: source deleteVM.sh <id>"
        return 1
fi

echo "Deleting the server $ID ..."
nova delete $ID
