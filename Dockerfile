FROM mcr.microsoft.com/azure-cli:latest

COPY kubectl.sh /kubectl.sh

RUN set -x \
    && apk add --no-cache \
        bash subversion wget make git python3 py3-pip python3-dev libffi-dev \
        make musl-dev curl tar gcc build-base gnupg mc ca-certificates rsync \
        openssh-client busybox-extras mariadb-client mariadb-connector-c \
        sshpass socat py3-mysqlclient py3-pymysql openssl helm sudo shadow

RUN set -x \
    && pip3 install --upgrade pip

RUN set -x \
    && pip3 install 'ansible==2.10.7' netaddr jmespath zabbix-api six poetry kubernetes \
    && helm repo add calico https://projectcalico.docs.tigera.io/charts \
    && helm repo add csi-charts https://ceph.github.io/csi-charts \
    && helm repo add bitnami https://charts.bitnami.com/bitnami \
    && helm plugin install https://github.com/databus23/helm-diff \
    && ansible-galaxy collection install kubernetes.core

RUN set -x \
    && /kubectl.sh

RUN set -x \
    && az upgrade \
    && az aks install-cli

RUN set -x \
    && mkdir -p /home/devops \
    && sed -i /etc/passwd -e 's/^root:x:0:0:root:\/root:/root:x:0:0:root:\/home\/devops:/'

WORKDIR /DEVOPS

CMD [ "/bin/bash" ]
