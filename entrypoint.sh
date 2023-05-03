#!/bin/bash

DEVOPS_UID=${DEVOPS_UID:-$(id -u)}
DEVOPS_GID=${DEVOPS_GID:-$(id -g)}

if [ "${DEVOPS_GID}" -ne 1000 ]; then
    cp /etc/group /tmp/group
    sed -i "/:${DEVOPS_GID}:/d" /tmp/group
    sed -i "s/devops:x:1000:/devops:x:${DEVOPS_GID}:/" /tmp/group
    cat /tmp/group > /etc/group
fi

if [ "${DEVOPS_UID}" -ne 1000 ]; then
    cp /etc/passwd /tmp/passwd
    sed -i "s/devops:x:1000:/devops:x:${DEVOPS_UID}:/" /tmp/passwd
    cat /tmp/passwd > /etc/passwd
fi

sudo chown devops:devops /home/devops
sudo chmod o-w,g-w /etc/passwd /etc/group
sudo chown devops:devops /run/host-services/ssh-auth.sock

exec "$@"
