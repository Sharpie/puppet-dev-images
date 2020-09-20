FROM scratch

# === Set up emulation for ARM binaries ===
# Requires /proc/sys/fs/binfmt_misc/qemu-arm to be configured
# with `interpreter /usr/bin/qemu-arm-static` the Docker host.
# Either by installing the right package or running a
# Docker container:
#
#     docker run --rm --privileged multiarch/qemu-user-static:register
#
# This allows the container to execute on both x86 and ARM hosts.

ADD rootfs.tar.xz /


# === Install Basic Utilities ===

RUN (DEBIAN_FRONTEND=noninteractive; \
     apt-get update; \
     apt-get install -y --no-install-recommends \
       apt-transport-https \
       ca-certificates \
       curl \
       iproute2 \
       net-tools\
       rsync \
       vim-tiny \
       wget; \
     rm -rf /var/lib/apt/lists/*)

# Installing ca-certificates triggers a hash of all certs under /etc/ssl/certs.
# These hashes are used by tools, like curl, to locate the right CA certificate
# to validate remote servers against.
#
# For some reason, this is broken when running Debian 10 ARM 32 under QEMU,
# so we have to use the old c_rehash script to make things work.
#
#   https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=923479
RUN c_rehash


# === Install SystemD ===

# NOTE: Could use a smaller init system, like tini, but by rigging up
#       systemd, we can use this image in Beaker tests that manipulate
#       services.
RUN (DEBIAN_FRONTEND=noninteractive && \
     apt-get update && \
     apt-get install -y --no-install-recommends systemd systemd-sysv && \
     rm -rf /var/lib/apt/lists/*)

# Install a patched copy of qemu-arm-static
#
# Debian 10 has a lot of change compared to Debian 9. New kernel,
# new libc, updated systemd. Turns out systemd is making SELinux-related
# system calls that QEMU doesn't emulate. This copies in `qemu-arm-static`
# from the QEMU 5.1 build for Debian Bullseye to fix some bugs:
#
#   https://bugs.launchpad.net/qemu/+bug/1823790
run curl -L \
      -o /tmp/qemu-arm-static \
      'https://dl.bintray.com/sharpie/puppet-agent-bin/qemu-arm-static/5.1+dfsg-4/qemu-arm-static' && \
    chmod +x /tmp/qemu-arm-static && \
    mv /tmp/qemu-arm-static /usr/bin

# Remove units that are not strictly required to operate a container.
# Improves systemd boot time and reduces errors from starting services
# that are managed by the host OS.
#
# Cribbed from the CentOS 7 image:
#   https://hub.docker.com/r/centos/systemd/dockerfile
RUN find /lib/systemd/system/sysinit.target.wants/ \
      -not -type d \
      -not -name systemd-tmpfiles-setup.service \
      -delete; \
    rm -f /lib/systemd/system/multi-user.target.wants/*; \
    rm -f /etc/systemd/system/*.wants/*; \
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*; \
    rm -f /etc/machine-id


# === Install RSyslog ===

RUN (DEBIAN_FRONTEND=noninteractive; \
     apt-get update && \
     apt-get install -y --no-install-recommends \
       rsyslog; \
     rm -rf /var/lib/apt/lists/*)

# Populate /var/log/syslog from journald
RUN systemctl enable rsyslog.service


# === Install OpenSSH ===

RUN (DEBIAN_FRONTEND=noninteractive && \
     apt-get update && \
     apt-get install -y --no-install-recommends openssh-server openssh-client && \
     rm -rf /var/lib/apt/lists/*)

RUN sed -ri'' -e 's/^#?PermitRootLogin .*/PermitRootLogin yes/' \
      -e 's/^#?PasswordAuthentication .*/PasswordAuthentication yes/' \
      -e 's/^#?UseDNS .*/UseDNS no/' \
      /etc/ssh/sshd_config

# FIXME: Make key configurable
RUN mkdir -p /root/.ssh && \
    curl -G https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub \
      -o /root/.ssh/authorized_keys

# FIXME: Debian 10 uses socket activation for SSH. We mask that in order
#        to run the "traditional" service since ServerSpec "port listening"
#        tests don't work that well with Docker containers at the moment.
RUN systemctl mask ssh.socket && systemctl enable ssh.service

# Java installation fails if man1 does not exist
#   https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=863199
RUN mkdir -p /usr/share/man/man1


# === Runtime Configuration ===
# NOTE: Compacting a debian-slim image via COPY seems to bloat the final
#       image by ~75 MB instead of reducing it.

# NOTE: Technically, should also have `--tmpfs /tmp:exec`. But, tools
#       that use the Docker API to upload files, such as Bolt, can't write
#       content to a mount.
#       https://developers.redhat.com/blog/2016/09/13/running-systemd-in-a-non-privileged-container/
LABEL docker-run-args="--tmpfs=/run --tmpfs /run/lock --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro"
LABEL org.opencontainers.image.source="https://github.com/Sharpie/puppet-dev-images"
ENV container docker
STOPSIGNAL SIGRTMIN+3
VOLUME [ "/sys/fs/cgroup", "/tmp", "/run" ]
EXPOSE 22

CMD [ "/sbin/init" ]
