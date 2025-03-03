#!/bin/bash

curl -L https://github.com/projectcalico/calico/releases/download/v3.29.2/calicoctl-linux-$(dpkg --print-architecture) -o /usr/local/bin/calicoctl

chmod a+x /usr/local/bin/calicoctl
