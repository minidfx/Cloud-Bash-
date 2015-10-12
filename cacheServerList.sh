#!/bin/bash

. "./configuration.sh"

echo -n "Retrieving list of servers ... "
nova list > /tmp/servers.list
echo "Done."
