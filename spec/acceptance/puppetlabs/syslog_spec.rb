require 'spec_helper_acceptance'

describe service('rsyslog') do
  it 'is enabled' do
    expect(subject).to be_enabled
  end

  it 'is running' do
    expect(subject).to be_running
  end
end
