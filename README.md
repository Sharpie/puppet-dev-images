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
and pushed to a registry. Images are currently hosted at bintray.io, this may
change in the future as GitHub Packages matures.

image | docker command
----- | --------------
![centos-7_x86_64 build status](https://github.com/Sharpie/puppet-dev-images/workflows/Build%20centos-7-x86_64/badge.svg) | `docker pull sharpie-docker-puppet-dev-images.bintray.io/centos-7-x86_64`
