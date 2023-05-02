FROM mcr.microsoft.com/azure-cli:latest

COPY install.sh /install.sh
RUN set -x \
    && /install.sh \
    && rm -f /install.sh

RUN set -x \
    && apk add --no-cache \
        bash subversion wget make git python3 py3-pip python3-dev libffi-dev \
        make musl-dev curl tar gcc build-base gnupg mc ca-certificates rsync \
        openssh-client busybox-extras mariadb-client mariadb-connector-c zsh \
        sshpass socat py3-mysqlclient py3-pymysql openssl helm sudo shadow

RUN set -x \
    && pip3 install --upgrade pip \
    && pip3 install 'ansible==2.10.7' netaddr jmespath zabbix-api six poetry kubernetes

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
    && mkdir -p /opt/ansible_collections \
    && helm repo add calico https://projectcalico.docs.tigera.io/charts \
    && helm repo add csi-charts https://ceph.github.io/csi-charts \
    && helm repo add bitnami https://charts.bitnami.com/bitnami \
    && helm plugin install https://github.com/databus23/helm-diff \
    && ansible-galaxy collection install kubernetes.core -p /opt/ansible_collections \
    && chmod -R a+rwx /opt/ansible_collections \
    && chmod -R a+rwx /opt/helm

RUN set -x \
    && addgroup -g 1000 devops \
    && adduser -u 1000 -g devops -h /home/devops -S -D -s /bin/zsh devops \
    && usermod -a -G wheel,devops devops \
    && chmod a+w /etc/passwd \
    && chmod a+w /etc/group

RUN set -x \
    && echo 'root ALL=(ALL) ALL' > /etc/sudoers.d/devops \
    && echo 'devops ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/devops \
    && echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/devops

ENV HOME /home/devops

WORKDIR /DEVOPS

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "/bin/zsh" ]
