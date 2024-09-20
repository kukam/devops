#!/bin/bash

curl -sL https://aka.ms/InstallAzureCLIDeb | bash

az upgrade
az aks install-cli
