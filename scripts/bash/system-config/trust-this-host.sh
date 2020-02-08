#!/bin/bash
set -e

# Quick function that will configure a remote host for passwordless ssh from
# current host

PK="${HOME}/.ssh/id_rsa.pub"

Use()
{
   echo ""
   echo "USE: ${0} -h RemoteHost -u RemoteUser -p RemotePassword"
   echo -e "REQUIRED"
   echo -e "\t-h The remote host to configure"
   echo -e "\t-u The user to connect with on the remote host"
   echo -e "OPTIONAL"
   echo -e "\t-k The public key to use for remote authentication. Default: ${PK}"
   exit 1
}

while getopts "h:u:p:k:" opt
do
   case "$opt" in
      h ) REMOTE_HOST="$OPTARG" ;;
      u ) REMOTE_USER="$OPTARG" ;;
      k) PUBLIC_KEY="$OPTARG" ;;
      ? ) Use ;;
   esac
done

if [ -z "$REMOTE_HOST" ] || [ -z "$REMOTE_USER" ]
then
   echo "One or more missing paramaters missing!";
   Use
   exit 1
fi

if [ ! -z "${PUBLIC_KEY}" ]; then
    PK="${PUBLIC_KEY}"
fi

if [ ! -f "${PK}" ]; then
    echo "Unable to locate public key!"
    echo "File not found: ${PK}"
    exit 1
fi

echo "Transfering public key and configuring trust. You WILL be prompted for your password..."
ssh ${REMOTE_USER}@${REMOTE_HOST} "mkdir -p ~/.ssh"
cat "${PK}" | ssh ${REMOTE_USER}@${REMOTE_HOST} 'cat >> ~/.ssh/authorized_keys'
ssh ${REMOTE_USER}@${REMOTE_HOST} "chmod 700 ~/.ssh; chmod 640 ~/.ssh/authorized_keys"

echo "Done!"
