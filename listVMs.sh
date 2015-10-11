#!/bin/sh

. "./configuration.sh"

echo "VM's available for $OS_USERNAME"

nova image-list
