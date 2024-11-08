require 'serverspec'

# NOTE: The "docker" backend seems like it would be more efficient,
#       but there is some state that does not quite get cleared when
#       switching hosts.
set :backend, 'dockercli'
set :docker_container, 'puppet-dev'
