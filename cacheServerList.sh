#!/bin/bash

echo -n "Retrieving list of servers ... "
nova list > /tmp/servers.list
echo "Done."
