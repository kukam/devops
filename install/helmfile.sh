#!/bin/bash

cd /tmp

HELMFILE_VERSION=`curl -s -I https://github.com/helmfile/helmfile/releases/latest | perl -p -e 's/\r//g' | grep 'location:' | sed -e 's/.*tag\/v//'`

CPU=`uname -m`

if [ "${CPU}" == "x86_64" ]; then
    CPU="amd64"
elif [ "${CPU}" == "aarch64" ]; then
    CPU="arm64"
fi

curl -s -L https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_linux_${CPU}.tar.gz | tar -xvzf - helmfile

mv helmfile /usr/local/bin
chown root:root /usr/local/bin/helmfile
chmod +x /usr/local/bin/helmfile
