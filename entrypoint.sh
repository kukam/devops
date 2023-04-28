#!/bin/bash

USER_UID=${USER_UID:-$(id -u)}
USER_GID=${USER_GID:-$(id -g)}

if [ "${USER_GID}" -ne 0 ]; then
    sed -i '/:20:/d' /etc/group
fi

addgroup -g ${USER_GID} devops
adduser -u ${USER_UID} -g devops -h /home/devops -S -D devops
usermod -a -G wheel,devops devops

# if [ -f "/home/devops/.zsh_history" ]; then
#     sed 's/^: \([0-9]*\):\w;\(.*\)$/\2/' </home/devops/.zsh_history >/home/devops/.bash_history
# fi

rm -f /entrypoint.sh

exec sudo -E -u devops $@