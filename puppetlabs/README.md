Docker Containers for Puppet tooling
====================================

The containers under this directory are designed to integrate with Puppet Inc.
build and test tools. Namely [Vanagon][vanagon] and [Beaker][beaker-docker].
The container builds here have some common characteristics:

  - Run an init system such as SystemD.

  - Run a SSH server that allows access to the root user via accepts a
    well-known key.

The above allows the containers to function as "light-weight VMs" and satisfy
various assumptions made by the tools. The [Vagrant SSH key][vagrant-keys] is
used as the well-known key for SSH access. This configuration is inherently
insecure and thus the containers should never be run in a setting where they
are exposed to uncontrolled network traffic.

  [vanagon]: https://github.com/puppetlabs/vanagon
  [beaker-docker]: https://github.com/puppetlabs/beaker-docker
  [vagrant-keys]: https://github.com/hashicorp/vagrant/tree/master/keys
