#!/bin/bash

# curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft.gpg
# echo "deb [arch=$(dpkg --print-architecture)] https://packages.microsoft.com/repos/azure-cli/$(lsb_release -cs) $(lsb_release -cs) main" | tee /usr/share/keyrings/azure-cli.list

mkdir -p /etc/apt/keyrings
curl -sLS https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/keyrings/microsoft.gpg > /dev/null
chmod go+r /etc/apt/keyrings/microsoft.gpg

AZ_DIST=$(lsb_release -cs)
echo "Types: deb
URIs: https://packages.microsoft.com/repos/azure-cli/
Suites: ${AZ_DIST}
Components: main
Architectures: $(dpkg --print-architecture)
Signed-by: /etc/apt/keyrings/microsoft.gpg" | tee /etc/apt/sources.list.d/azure-cli.sources

apt update
apt install -y azure-cli

# Install kubelogin
az aks install-cli

# Upgrade
az upgrade -y
