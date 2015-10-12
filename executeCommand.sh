#!/bin/sh

. "./configuration.sh"

if [ -z "$1" ]; then
        echo "ERROR: You have to specify the ID of the server to run a command into it."
        echo "Usage: source $0 <id> <command>"
        exit 1
fi

if [ -z "$2" ]; then
        echo "ERROR: You have to specify a command that will be passed to the server $1."
        echo "Usage: source $0 <id> <command>"
        exit 1
fi

IP=`./getIP.sh $1`

if [ -z "$IP" ] || [ $? != 0 ]; then
        echo "Cannot found the IP address of the server $1."
        exit $?
fi

echo -n "Executing the command $2 on on the SSH server $1 ... "
echo "ssh $IP $2"
#ssh $IP "$2"
echo "Done."
