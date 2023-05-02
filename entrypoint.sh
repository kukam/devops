#!/bin/bash

D_UID=${D_UID:-$(id -u)}
D_GID=${D_GID:-$(id -g)}

if [ "${D_GID}" -ne 1000 ]; then
    cp /etc/group /tmp/group
    sed -i "/:${D_GID}:/d" /tmp/group
    sed -i "s/devops:x:1000:/devops:x:${D_GID}:/" /tmp/group
    cat /tmp/group > /etc/group
fi

if [ "${D_UID}" -ne 1000 ]; then
    cp /etc/passwd /tmp/passwd
    sed -i "s/devops:x:1000:/devops:x:${D_UID}:/" /tmp/passwd
    cat /tmp/passwd > /etc/passwd
fi

sudo chown devops:devops /home/devops
sudo chmod o-w,g-w /etc/passwd /etc/group
sudo chown devops:devops /run/host-services/ssh-auth.sock

exec $@

# if [[ "${USER_UID}" -eq 0 ]] && [[ "${D_GID}" -eq 0 ]];then
#     exec $@
# else
#     if [ "${USER_GID}" -ne 1000 ]; then
#         sed -i "/:${USER_GID}:/d" /etc/group
#     fi

#     addgroup -g ${USER_GID} devops
#     adduser -u ${USER_UID} -g devops -h /home/devops -S -D devops
#     usermod -a -G wheel,devops devops

#     # if [ -f "/home/devops/.zsh_history" ]; then
#     #     sed 's/^: \([0-9]*\):\w;\(.*\)$/\2/' </home/devops/.zsh_history >/home/devops/.bash_history
#     # fi

#     # rm -f /entrypoint.sh

#     exec sudo -E -u devops $@

# fi
