FROM mcr.microsoft.com/azure-cli:latest

COPY install/ /install/
COPY motd /etc/motd

# https://pkgs.alpinelinux.org/packages
RUN set -x \
    && apk add --no-cache \
        bash subversion wget make git python3 py3-pip python3-dev libffi-dev \
        make musl-dev curl tar gcc build-base gnupg mc vim ca-certificates rsync \
        openssh-client busybox-extras mariadb-client mariadb-connector-c docker \
        sshpass socat py3-mysqlclient py3-pymysql py3-yaml openssl redis helm sudo \
        shadow libpq-dev postgresql15-client coreutils kcat

RUN set -x \
    && /install/helmfile.sh \
    && /install/kubectl.sh \
    && /install/rabbitmqadmin.sh \
    && /install/hashicorp.sh terraform 1.7.5 \
    && rm -fr /install \
    && rm -fr /tmp/*

RUN set -x \
    && pip3 install --upgrade pip

RUN set -x \
    && pip3 install 'ansible==2.10.7' netaddr jmespath zabbix-api six poetry kubernetes pip_search psycopg2-binary

RUN set -x \
    && az upgrade \
    && az aks install-cli

COPY ansible.cfg /etc/ansible/ansible.cfg

ENV HELM_CACHE_HOME "/opt/helm/.cache/helm"
ENV HELM_CONFIG_HOME "/opt/helm/.config/helm"
ENV HELM_DATA_HOME "/opt/helm/.local/share/helm"
ENV HELM_PLUGINS "/opt/helm/.local/share/helm/plugins"
ENV HELM_REGISTRY_CONFIG "/opt/helm/.config/helm/registry/config.json"
ENV HELM_REPOSITORY_CACHE "/opt/helm/.cache/helm/repository"
ENV HELM_REPOSITORY_CONFIG "/opt/helm/.config/helm/repositories.yaml"

RUN set -x \
    && mkdir -p /opt/helm \
    && mkdir -p /opt/ansible/collections \
    && helm repo add calico https://projectcalico.docs.tigera.io/charts \
    && helm repo add csi-charts https://ceph.github.io/csi-charts \
    && helm repo add bitnami https://charts.bitnami.com/bitnami \
    && helm plugin install https://github.com/databus23/helm-diff \
    && ansible-galaxy collection install kubernetes.core \
    && chmod -R a+rwx /opt/ansible \
    && chmod -R a+rwx /opt/helm \
    && ansible-galaxy collection install community.postgresql \
    && ansible-galaxy collection install kubernetes.core

RUN set -x \
    && echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/devops \
    && echo "net.ipv4.ping_group_range = 0 2147483647" >> /etc/sysctl.conf \
    && usermod --shell /bin/bash root

COPY entrypoint.sh /entrypoint.sh

ENV HOME /home/devops

WORKDIR /DEVOPS

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "/bin/bash" ]
