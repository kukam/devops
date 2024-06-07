#!/bin/bash

cd /tmp

curl -f -L https://raw.githubusercontent.com/rabbitmq/rabbitmq-management/v3.7.8/bin/rabbitmqadmin -o /usr/local/bin/rabbitmqadmin

chown root:root /usr/local/bin/rabbitmqadmin
chmod +x /usr/local/bin/rabbitmqadmin
