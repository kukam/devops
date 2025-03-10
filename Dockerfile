FROM debian:stable-slim

COPY install/ /install/
COPY motd /etc/motd

RUN set -x \
    && apt-get update \
    && apt-get -y install \
        subversion wget make git python3 python3-pip python3-dev build-essential \
        libffi-dev musl-dev curl tar gcc gnupg mc vim ca-certificates libssl-dev \
        openssh-client mariadb-client mariadb-plugin-connect busybox sshpass jq \
        socat openssl redis sudo libpq-dev postgresql-client-15 coreutils bc \
        iputils-ping tlslookup bind9-host gettext-base inetutils-telnet nmap \
        netcat-traditional rsync kcat python3-venv

#&& /install/hashicorp.sh terraform 1.9.8 \
RUN set -x \
    && /install/azcli.sh \
    && /install/docker.sh \
    && /install/helm.sh \
    && /install/helmfile.sh \
    && /install/terraform.sh \
    && /install/calicoctl.sh \
    && /install/rabbitmqadmin.sh \
    && rm -fr /install \
    && rm -fr /tmp/*

RUN set -x \
    && pip3 install --upgrade pip --break-system-packages

RUN set -x \
    && pip3 install --break-system-packages 'ansible==10.5.0' netaddr jmespath zabbix-api six poetry kubernetes pip_search psycopg2-binary yaml-1.3 pymysql jmespath molecule molecule-docker docker

COPY ansible.cfg /etc/ansible/ansible.cfg

ENV HELM_CACHE_HOME="/opt/helm/.cache/helm"
ENV HELM_CONFIG_HOME="/opt/helm/.config/helm"
ENV HELM_DATA_HOME="/opt/helm/.local/share/helm"
ENV HELM_PLUGINS="/opt/helm/.local/share/helm/plugins"
ENV HELM_REGISTRY_CONFIG="/opt/helm/.config/helm/registry/config.json"
ENV HELM_REPOSITORY_CACHE="/opt/helm/.cache/helm/repository"
ENV HELM_REPOSITORY_CONFIG="/opt/helm/.config/helm/repositories.yaml"

RUN set -x \
    && mkdir -p /opt/ansible/collections \
    && mkdir -p /opt/helm \
    && helm repo add calico https://projectcalico.docs.tigera.io/charts \
    && helm repo add csi-charts https://ceph.github.io/csi-charts \
    && helm repo add bitnami https://charts.bitnami.com/bitnami \
    && helm plugin install https://github.com/databus23/helm-diff \
    && ansible-galaxy collection install zabbix.zabbix \
    && chmod -R a+rwx /opt/ansible \
    && chmod -R a+rwx /opt/helm

RUN set -x \
    && echo '%sudo ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/devops \
    && echo "net.ipv4.ping_group_range = 0 2147483647" >> /etc/sysctl.conf \
    && usermod --shell /bin/bash root

COPY entrypoint.sh /entrypoint.sh

ENV HOME="/home/devops"

WORKDIR /DEVOPS

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "/bin/bash" ]
