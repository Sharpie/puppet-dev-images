FROM amd64/centos:7


# === Install Basic Utilities ===

RUN yum -y --setopt=tsflags=nodocs update; \
    yum -y --setopt=tsflags=nodocs install \
      curl \
      cronie \
      initscripts \
      vim-minimal \
      wget; \
    yum clean all


# === Install SystemD ===

# Remove units that are not strictly required to operate a container.
# Improves systemd boot time and reduces errors from starting services
# that are managed by the host OS.
#
# Cribbed from the CentOS 7 image:
#   https://hub.docker.com/r/centos/systemd/dockerfile
RUN find /lib/systemd/system/sysinit.target.wants/ \
      -not -type d \
      -not -name systemd-tmpfiles-setup.service \
      -delete ; \
    rm -f /lib/systemd/system/multi-user.target.wants/*; \
    rm -f /etc/systemd/system/*.wants/*; \
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*; \
    rm -f /lib/systemd/system/anaconda.target.wants/*; \
    rm -f /etc/machine-id


# === Install RSyslog ===

RUN yum -y --setopt=tsflags=nodocs update && \
    yum -y --setopt=tsflags=nodocs install \
      rsyslog; \
    yum clean all

# Populate /var/log/messages from journald
RUN systemctl enable rsyslog.service


# === Install OpenSSH ===

RUN yum -y --setopt=tsflags=nodocs update; \
    yum -y --setopt=tsflags=nodocs install \
      openssh-server \
      passwd; \
    yum clean all

RUN sed -ri'' -e 's/^#?PermitRootLogin .*/PermitRootLogin yes/' \
      -e 's/^#?PasswordAuthentication .*/PasswordAuthentication yes/' \
      -e 's/^#?UseDNS .*/UseDNS no/' \
      /etc/ssh/sshd_config

# FIXME: Make key configurable
RUN mkdir -p /root/.ssh && \
    curl -G https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub \
      -o /root/.ssh/authorized_keys

RUN systemctl enable sshd.service


# === Runtime Container ===
# Copying everything fromt the build container as a single layer
# reduces the final image size by ~50 MB.
FROM amd64/centos:7
COPY --from=0 / /

ENV container docker
STOPSIGNAL SIGRTMIN+3
VOLUME [ "/sys/fs/cgroup", "/tmp", "/run" ]
EXPOSE 22

CMD [ "/sbin/init" ]
