#!/bin/bash

debuerreotype-init \
  --non-debian \
  --arch armhf \
  --keyring /usr/share/keyrings/raspbian-archive-keyring.gpg \
  --debootstrap qemu-debootstrap \
  --no-merged-usr \
  rootfs bullseye http://raspbian.raspberrypi.org/raspbian

debuerreotype-minimizing-config rootfs
debuerreotype-apt-get rootfs update -qq
debuerreotype-apt-get rootfs dist-upgrade -yqq

debuerreotype-slimify rootfs

debuerreotype-tar rootfs /output/rootfs.tar.xz
