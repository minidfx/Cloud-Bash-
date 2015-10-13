#!/bin/bash

. "./configuration.sh"

if [ -z "$1" ]; then
	echo "You have to specify an instance name."
	exit 1
fi

echo -n "Refreshing server list ... "
./cacheServerList.sh
echo "Done."

echo -n "Looking for the address IP of $1 ... "
addressIP=`./getIP.sh $1`

while [ $? != 0 ]
do
	echo -n "Failed! Retrying ... "	
	./cacheServerList.sh
	addressIP=`./getIP.sh $1`
done

echo "Found."
echo -n "Trying to connect to $addressIP ($1) on SSH port ... "

sshVersion=`echo "" | nc -w 3 $addressIP 22 | grep --color=never SSH`

while  [ -z "$sshVersion" ]
do
	echo -n "Failed! Retrying in 2 seconds ... "
	sleep 2

	sshVersion=`echo "" | nc -w 3 $addressIP 22 | grep --color=never SSH`
done

echo "Done."
exit 0
