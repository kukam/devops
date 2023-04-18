#!/bin/bash

if [ ${GID:-1000} -ne "1000" ]; then
    sudo groupmod devops -g ${GID:-1000}
fi

if [ ${UID:-1000} -ne "1000" ]; then
    sudo usermod devops -u ${UID:-1000} -g devops
fi

sudo chown -R ${UID:-1000}:${GID:-1000} /home/devops

$@
