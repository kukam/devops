#!/bin/bash

DEVOPS_UID=${DEVOPS_UID:-$(id -u)}
DEVOPS_GID=${DEVOPS_GID:-$(id -g)}

if [ ${DEVOPS_UID} -eq 0 ]; then

    exec "$@"

else 
    if [ "${DEVOPS_GID}" -ne 0 ]; then
        # sed -i "/:${DEVOPS_GID}:/d" /etc/group
        sed -i "s/:x:${DEVOPS_GID}:/:x:79${DEVOPS_GID}:/g" /etc/group
    fi

    addgroup -g ${DEVOPS_GID} devops

    adduser -u ${DEVOPS_UID} -g devops -h /home/devops -S -D -s /bin/bash devops

    usermod -a -G wheel,devops devops

    chown devops:devops /run/host-services/ssh-auth.sock

    if [ -f "/home/devops/.zsh_history" ]; then
        sed 's/^: \([0-9]*\):\w;\(.*\)$/\2/' </home/devops/.zsh_history > /home/devops/.bash_history
    fi

    chown devops:devops /home/devops/.bash_history

    rm -f /entrypoint.sh

    exec sudo -E -u devops "$@"
fi