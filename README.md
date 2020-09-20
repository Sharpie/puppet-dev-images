puppet-dev-images
=================

Dockerfiles for building various and sundry Docker images for Puppet testing
and development. These images contain software and services needed to build,
run, and test Puppet software. They are not intended for production use.

The images in this repo aim for compatibility with [Puppet Litmus][litmus],
[Vanagon][vanagon], and [Beaker Docker][beaker-docker].

For containers designed to run Puppet software in production environments,
see the [Pupperware][pupperware] project.

[litmus]: https://github.com/puppetlabs/puppet_litmus
[vanagon]: https://github.com/puppetlabs/vanagon
[beaker-docker]: https://github.com/puppetlabs/beaker-docker
[pupperware]: https://github.com/puppetlabs/pupperware


Using the images
----------------

Tags pushed to this repository are built and tested by a GitHub Actions pipeline
and pushed to a registry. Images are currently hosted at ghcr.io.

image | docker command
----- | --------------
![debian-10-amd64 build status](https://github.com/Sharpie/puppet-dev-images/workflows/Build%20debian-10-amd64/badge.svg) | `docker pull ghcr.io/sharpie/debian-10-amd64`
![centos-7-x86_64 build status](https://github.com/Sharpie/puppet-dev-images/workflows/Build%20centos-7-x86_64/badge.svg) | `docker pull ghcr.io/sharpie/centos-7-x86_64`
![raspbian-10-armhf build status](https://github.com/Sharpie/puppet-dev-images/workflows/Build%20raspbian-10-armhf/badge.svg) | `docker pull ghcr.io/sharpie/raspbian-10-armhf`
![ubuntu-2004-arm64 build status](https://github.com/Sharpie/puppet-dev-images/workflows/Build%20ubuntu-2004-arm64/badge.svg) | `docker pull ghcr.io/sharpie/ubuntu-2004-arm64`

These images are configured to run SystemD as a full init system, which
requries additional arguments to be passed to `docker run`:

    --tmpfs=/run --tmpfs /run/lock --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro
