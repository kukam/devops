#!/bin/bash

DEVOPS_UID=${DEVOPS_UID:-$(id -u)}
DEVOPS_GID=${DEVOPS_GID:-$(id -g)}

if [ ${DEVOPS_UID} -eq 0 ]; then

    if [[ -f "/root/.zsh_history" ]] && [[ ! -f "/root/.bash_history" ]]; then
        sed 's/^: \([0-9]*\):\w;\(.*\)$/\2/' </root/.zsh_history > /root/.bash_history
    fi

    if [ ! -v "${PS1}" ]; then
        export PS1="\[\033[1;35m\][\u@\h \w]\[\033[0:00m\] \\$ "
        echo 'export PS1="\[\033[1;35m\][\u@\h \w]\[\033[0:00m\] \e[m\\$ "' >> /root/.bash_profile
    fi

    exec "$@"

else 
    if [ "${DEVOPS_GID}" -ne 0 ]; then
        # sed -i "/:${DEVOPS_GID}:/d" /etc/group
        sed -i "s/:x:${DEVOPS_GID}:/:x:79${DEVOPS_GID}:/g" /etc/group
    fi

    addgroup -g ${DEVOPS_GID} devops

    adduser -u ${DEVOPS_UID} -g devops -h /home/devops -S -D -s /bin/bash devops

    usermod -a -G wheel,devops devops

    if [ ! -v "${SSH_AUTH_SOCK}" ]; then
        chown devops:devops ${SSH_AUTH_SOCK}
    fi

    if [[ -f "/home/devops/.zsh_history" ]] && [[ ! -f "/home/devops/.bash_history" ]]; then
        sed 's/^: \([0-9]*\):\w;\(.*\)$/\2/' </home/devops/.zsh_history > /home/devops/.bash_history
    fi

    if [ -f "/home/devops/.bash_history" ]; then
        chown devops:devops /home/devops/.bash_history
    fi

    if [[ -f "/home/devops/.bash_history" ]] && [[ ! -f "/root/.bash_history" ]]; then
        cat /home/devops/.bash_history > /root/.bash_history
    fi

    if [ -d "/home/devops/.ansible" ]; then
        chown devops:devops /home/devops/.ansible
    fi

    if [ ! -v "${PS1}" ]; then
        export PS1="\[\033[0;33m\][\u@\h \w]\[\033[0:00m\] \\$ "
        echo 'export PS1="\[\033[0;33m\][\u@\h \w]\[\033[0:00m\] \e[m\\$ "' >> /home/devops/.bashrc
        echo 'export PS1="\[\033[1;35m\][\u@\h \w]\[\033[0:00m\] \e[m\\$ "' >> /root/.bash_profile
    fi

    rm -f /entrypoint.sh

    exec sudo -E -u devops "$@"
fi