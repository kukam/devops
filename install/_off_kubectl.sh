#!/bin/bash

cd /tmp

KUBECTL_VERSION=`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`
CPU=`uname -m`

if [ "${CPU}" == "x86_64" ]; then
    CPU="amd64"
elif [ "${CPU}" == "aarch64" ]; then
    CPU="arm64"
fi

curl -f -L https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/${CPU}/kubectl -o /usr/local/bin/kubectl

chown root:root /usr/local/bin/kubectl
chmod +x /usr/local/bin/kubectl
