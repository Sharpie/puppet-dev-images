require 'spec_helper_docker'

context 'systemd' do
  describe command('systemctl status') do
    its(:exit_status) { should eq 0 }
  end

  # TODO: Add check for "degraded" state.
end
