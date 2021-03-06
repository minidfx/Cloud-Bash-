#!/bin/bash

# The read command with the argument -r works only with Bash shell.i
CURRENT_SHELL=`ps -hp $$ | awk '{ print $5 }'`

if [ $CURRENT_SHELL != "/bin/bash" ]; then
      echo "The script supports only bash as shell."
      exit 1
fi

# To use an Openstack cloud you need to authenticate against keystone, which
# returns a **Token** and **Service Catalog**.  The catalog contains the
# endpoint for all services the user/tenant has access to - including nova,
# glance, keystone, swift.
#
# *NOTE*: Using the 2.0 *auth api* does not mean that compute api is 2.0.  We
# will use the 1.1 *compute api*
export OS_AUTH_URL=https://keystone.cloud.switch.ch:5000/v2.0

# With the addition of Keystone we have standardized on the term **tenant**
# as the entity that owns the resources.
export OS_TENANT_ID=43303a8189a04df387c58c7499ced0bc
export OS_TENANT_NAME="benjamin.burgy@master.hes-so.ch"

# In addition to the owning entity (tenant), openstack stores the entity
# performing the action as the **user**.
export OS_USERNAME="benjamin.burgy@master.hes-so.ch"

# With Keystone you pass the keystone password.
echo "Please type your OpenStack Password and press <Enter>"
read -sr OS_PASSWORD_INPUT
export OS_PASSWORD=$OS_PASSWORD_INPUT

# If your configuration has multiple regions, we set that information here.
# OS_REGION_NAME is optional and only valid in certain environments.
export OS_REGION_NAME="ZH"

# Don't leave a blank variable, unset it if it was empty
if [ -z "$OS_REGION_NAME" ]; then unset OS_REGION_NAME; fi
