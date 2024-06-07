#!/bin/bash

cd /tmp

PRODUCT=$1
VERSION=$2

CPU=`uname -m`

if [ "${CPU}" == "x86_64" ]; then
    CPU="amd64"
elif [ "${CPU}" == "aarch64" ]; then
    CPU="arm64"
fi

wget https://releases.hashicorp.com/${PRODUCT}/${VERSION}/${PRODUCT}_${VERSION}_linux_${CPU}.zip
wget https://releases.hashicorp.com/${PRODUCT}/${VERSION}/${PRODUCT}_${VERSION}_SHA256SUMS
wget https://releases.hashicorp.com/${PRODUCT}/${VERSION}/${PRODUCT}_${VERSION}_SHA256SUMS.sig

wget -qO- https://www.hashicorp.com/.well-known/pgp-key.txt | gpg --import

gpg --verify ${PRODUCT}_${VERSION}_SHA256SUMS.sig ${PRODUCT}_${VERSION}_SHA256SUMS

grep ${PRODUCT}_${VERSION}_linux_${CPU}.zip ${PRODUCT}_${VERSION}_SHA256SUMS | sha256sum -c

unzip /tmp/${PRODUCT}_${VERSION}_linux_${CPU}.zip -d /tmp

mv /tmp/${PRODUCT} /usr/local/bin/${PRODUCT}

rm -f /tmp/${PRODUCT}_${VERSION}_linux_${CPU}.zip ${PRODUCT}_${VERSION}_SHA256SUMS ${VERSION}/${PRODUCT}_${VERSION}_SHA256SUMS.sig
