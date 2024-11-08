# syntax=docker/dockerfile:1-labs
FROM --platform=${BUILDPLATFORM} debian:12-slim AS rootfs

RUN set -xe \
    && apt update \
    && apt full-upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
       debian-ports-archive-keyring \
       debootstrap \
       gnupg dirmngr \
       git \
       qemu-user-static \
       wget ca-certificates \
       xz-utils

RUN git clone https://github.com/debuerreotype/debuerreotype /opt/debuerreotype && \
    cd /opt/debuerreotype && \
    version=$(git describe --abbrev=0 --tags) && \
    printf 'Using Debuerreotype version: %s\n' "${version}" && \
    git checkout "${version}" && \
    cd scripts && \
    for f in debuerreotype-*; do \
      ln -svL "$PWD/$f" "/usr/local/bin/$f"; \
    done;

RUN wget -O raspbian.deb 'http://raspbian.raspberrypi.com/raspbian/pool/main/r/raspbian-archive-keyring/raspbian-archive-keyring_20120528.2_all.deb' && \
    apt install -y ./raspbian.deb

# debuerreotype commands make use of the "unshare" operation
# which requires privileges.
RUN --security=insecure \
    debuerreotype-init \
      --non-debian \
      --arch armhf \
      --keyring /usr/share/keyrings/raspbian-archive-keyring.gpg \
      rootfs bookworm http://raspbian.raspberrypi.com/raspbian

RUN --security=insecure debuerreotype-minimizing-config rootfs
RUN --security=insecure debuerreotype-apt-get rootfs update -qq
RUN --security=insecure debuerreotype-apt-get rootfs dist-upgrade -yqq


FROM scratch AS build

COPY --from=rootfs /rootfs /
COPY rootfs/ /

RUN set -xe \
    && apt update \
    && apt full-upgrade -y \
    && apt autoremove \
    && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
       apt-transport-https \
       bind9-dnsutils \
       ca-certificates \
       curl \
       file \
       iproute2 \
       iputils-ping \
       netcat-traditional \
       procps \
       rsync \
       vim-tiny \
       wget \
    && update-alternatives --set editor /usr/bin/vim.tiny

RUN set -xe \
    && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
       systemd \
       systemd-sysv \
    && systemctl set-default multi-user.target \
    && systemctl mask \
       getty.target

## === Install Rsyslog ===
## Many Puppet tests interact with /var/log/messages or /var/log/syslog
RUN set -xe \
    && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
       rsyslog \
    && systemctl enable rsyslog.service

## === Install OpenSSH
## SSH is the default control channel used by
## Beaker and Vanagon.
RUN set -xe \
    && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
       openssh-client \
       openssh-server \
    && systemctl enable ssh.service \
    && systemctl mask ssh.socket

RUN sed -ri'' -e 's/^#?PermitRootLogin .*/PermitRootLogin yes/' \
      -e 's/^#?PasswordAuthentication .*/PasswordAuthentication yes/' \
      -e 's/^#?UseDNS .*/UseDNS no/' \
      /etc/ssh/sshd_config

# FIXME: Make key configurable
RUN mkdir -p /root/.ssh \
    && curl -G https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub \
       -o /root/.ssh/authorized_keys

RUN rm -rf /var/lib/apt/lists/*

FROM scratch
COPY --from=build / /

ENV container=docker
ENV locale=C.UTF-8

STOPSIGNAL SIGRTMIN+3
VOLUME ["/tmp", "/run", "/run/lock"]

LABEL docker-run-args="--tty --privileged --tmpfs=/tmp --tmpfs=/run --tmpfs=/run/lock"
LABEL podman-run-args="--tty --systemd=true"

CMD ["/sbin/init"]
