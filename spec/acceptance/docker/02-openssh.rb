require 'spec_helper_docker'

context 'OpenSSH Server' do
  describe service('ssh') do
    it 'is enabled' do
      expect(subject).to be_enabled
    end

    it 'is running' do
      expect(subject).to be_running
    end
  end

  describe port(22) do
    it 'is listening' do
      expect(subject).to be_listening
    end
  end
end
