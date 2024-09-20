#!/bin/bash

DEVOPS_UID=${DEVOPS_UID:-$(id -u)}
DEVOPS_GID=${DEVOPS_GID:-$(id -g)}

if [ ${DEVOPS_UID} -eq 0 ]; then

    if [[ -f "/root/.zsh_history" ]] && [[ ! -f "/root/.bash_history" ]]; then
        sed 's/^: \([0-9]*\):\w;\(.*\)$/\2/' </root/.zsh_history > /root/.bash_history
    fi

    if [ ! -v "${PS1}" ]; then
        export PS1="\[\033[1;35m\][\u \W] $ \[\033[0;00m\]"
        echo 'export PS1="\[\033[1;35m\][\u \W] $ \[\033[0;00m\]"' >> /root/.bash_profile
    fi

    if [ -z "$1" -o "$1" == "/bin/bash" -o "$1" == "/bin/sh" ] && [ -z "$2" ]; then
        cat /etc/motd
        echo ""
    fi

    rm -f /entrypoint.sh

    exec "$@"

else 
    if [ "${DEVOPS_GID}" -ne 0 ]; then
        # sed -i "/:${DEVOPS_GID}:/d" /etc/group
        sed -i "s/:x:${DEVOPS_GID}:/:x:79${DEVOPS_GID}:/g" /etc/group
    fi

    addgroup --gid ${DEVOPS_GID} devops >/dev/null 2>&1

    adduser --uid ${DEVOPS_UID} --gid ${DEVOPS_GID} --home /home/devops --system --disabled-password --shell /bin/bash devops >/dev/null 2>&1

    usermod -a -G sudo,devops devops >/dev/null 2>&1

    if [ ! -v "${SSH_AUTH_SOCK}" ]; then
        chown devops:devops ${SSH_AUTH_SOCK}
    fi

    if [ -S "/var/run/docker.sock" ]; then
        chown devops:devops /var/run/docker.sock
        # usermod -a -G docker devops
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
        export PS1="\[\033[0;33m\][\u \W] $ \[\033[0;00m\]"
        echo 'export PS1="\[\033[0;33m\][\u \W] $ \[\033[0;00m\]"' >> /home/devops/.bashrc
        echo 'export PS1="\[\033[1;35m\][\u \W] $ \[\033[0;00m\]"' >> /root/.bash_profile
    fi

    if [ -f "/home/devops/.bashrc" ]; then
        chown devops:devops /home/devops/.bashrc
    fi

    if [ -z "$1" -o "$1" == "/bin/bash" -o "$1" == "/bin/sh" ] && [ -z "$2" ]; then
        cat /etc/motd
        echo ""
    fi

   rm -f /entrypoint.sh

    exec sudo -E -u devops "$@"
fi