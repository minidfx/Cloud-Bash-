#!/bin/bash

# file: start_OS_VMs.sh
# date: 24.09.13
# description: starts 2 virtual machines on the OpenStack HepiaCloud

# add the configuration from Switch
. "./benjamin.burgy@master.hes-so.ch-openrc.sh"

# set environment for OpenStack command-line tool
export OS_USERNAME=benjamin.burgy@master.hes-so.ch
export OS_TENANT_NAME="Tuto OpenStack"
export OS_AUTH_URL="https://keystone.cloud.switch.ch:5000/v2.0"
export OS_REGION_NAME=ZH

# set OpenStack VM variables
export IMAGE=SNAPSHOT_ID
export FLAVOR=1
export KEY=student-key

