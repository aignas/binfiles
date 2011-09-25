#!/bin/bash

if [ ! "x${UID}"=="x0" ]; then
   echo 'This script can only be run by root.'
   exit 1
fi

cd /usr/src
for I in linux-*
do
    echo "Symlinking $1 with linux"
    ln -sfn $I linux
    module-rebuild rebuild
done

echo -e "Success"
exit 0
