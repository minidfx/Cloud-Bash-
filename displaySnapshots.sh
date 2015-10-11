#!/bin/sh

. "./configuration.sh"

echo "Snapshots available for $OS_USERNAME"

nova volume-snapshot-list
