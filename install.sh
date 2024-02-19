#!/bin/bash

cd /tmp

KUBECTL_VERSION=`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`
HELMFILE_VERSION=`curl -s -I https://github.com/helmfile/helmfile/releases/latest | perl -p -e 's/\r//g' | grep 'location:' | sed -e 's/.*tag\/v//'`

if [ `uname -m` == "x86_64" ]; then
    curl -f -L https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl
    curl -s -L https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_linux_amd64.tar.gz | tar -xvzf - helmfile
else
    curl -f -L https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/arm64/kubectl -o /usr/local/bin/kubectl
    curl -s -L https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_linux_arm64.tar.gz | tar -xvzf - helmfile
fi

curl -f -L https://raw.githubusercontent.com/rabbitmq/rabbitmq-management/v3.7.8/bin/rabbitmqadmin -o /usr/local/bin/rabbitmqadmin

mv helmfile /usr/local/bin
chown root:root /usr/local/bin/rabbitmqadmin
chown root:root /usr/local/bin/kubectl
chown root:root /usr/local/bin/helmfile
chmod +x /usr/local/bin/rabbitmqadmin
chmod +x /usr/local/bin/kubectl
chmod +x /usr/local/bin/helmfile
