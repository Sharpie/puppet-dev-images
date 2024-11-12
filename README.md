puppet-dev-images
=================

Containerfiles for building various and sundry Docker images for Puppet testing
and development. These images contain software and services needed to build,
run, and test Puppet software. They are not intended for production use.

> [!WARNING]
> In particular, these containers run a `ssh` daemon that is configured to trust
> the [insecure Vagrant keys][vagrant-keys].
>
> Do not run these containers anywhere that is exposed to untrusted network traffic.

The images in this repo aim for compatibility with [Puppet Litmus][litmus],
[Vanagon][vanagon], and [Beaker Docker][beaker-docker].

[litmus]: https://github.com/puppetlabs/puppet_litmus
[vanagon]: https://github.com/puppetlabs/vanagon
[beaker-docker]: https://github.com/puppetlabs/beaker-docker
[vagrant-keys]: https://github.com/hashicorp/vagrant/tree/main/keys


Using the images
----------------

Tags pushed to this repository are built and tested by a GitHub Actions pipeline
and pushed to a registry. Images are currently hosted at ghcr.io.

Image | Architecture(s) | Docker Command
----- | --------------- | --------------
![debian-12 build status](https://github.com/Sharpie/puppet-dev-images/workflows/Build%20Debian%2012/badge.svg) | `linux/amd64`, `linux/arm64` | `docker pull ghcr.io/sharpie/puppet-dev-images/debian-12`
![raspbian-12-armhf build status](https://github.com/Sharpie/puppet-dev-images/workflows/Build%20Raspbian%2012/badge.svg) | `linux/arm/v6` | `docker pull ghcr.io/sharpie/puppet-dev-images/raspbian-12`

These images are configured to run SystemD as a full init system, which
requires additional arguments to be passed to `docker run`:

    --tty --privileged --tmpfs /tmp --tmpfs /run
