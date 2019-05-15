FROM amd64/debian:9-slim

# === Install ARM emulation for x86 ===

RUN (DEBIAN_FRONTEND=noninteractive && \
     apt-get update && \
     apt-get install -y --no-install-recommends \
       qemu-user-static)


FROM arm32v7/debian:9-slim


# === Set up emulation for ARM binaries ===
# Requires /proc/sys/fs/binfmt_misc/qemu-arm to be configured
# with `interpreter /usr/bin/qemu-arm-static` the Docker host.
# Either by installing the right package or running a
# Docker container:
#
#     docker run --rm --privileged multiarch/qemu-user-static:register
#
# This allows the container to execute on both x86 and ARM hosts.

COPY --from=0 /usr/bin/qemu-arm-static /usr/bin/


# === Install Basic Utilities ===

RUN (DEBIAN_FRONTEND=noninteractive; \
     apt-get update; \
     apt-get install -y --no-install-recommends \
       apt-transport-https \
       ca-certificates \
       curl \
       vim-tiny \
       wget; \
     rm -rf /var/lib/apt/lists/*)


# === Install SystemD ===

# NOTE: Could use a smaller init system, like tini, but by rigging up
#       systemd, we can use this image in Beaker tests that manipulate
#       services.
RUN (DEBIAN_FRONTEND=noninteractive && \
     apt-get update && \
     apt-get install -y --no-install-recommends systemd systemd-sysv && \
     rm -rf /var/lib/apt/lists/*)

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

RUN systemctl enable ssh.service


# === Runtime Configuration ===

ENV container docker
STOPSIGNAL SIGRTMIN+3
VOLUME [ "/sys/fs/cgroup", "/tmp", "/run" ]
EXPOSE 22

CMD [ "/sbin/init" ]
