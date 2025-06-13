#!/bin/bash

curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft.gpg
echo "deb [arch=$(dpkg --print-architecture)] https://packages.microsoft.com/repos/azure-cli/$(lsb_release -cs) $(lsb_release -cs) main" | tee /usr/share/keyrings/azure-cli.list

apt update
apt install -y azure-cli
