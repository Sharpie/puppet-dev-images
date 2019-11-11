require 'spec_helper_acceptance'

describe 'openssh' do
  # FIXME: Should move this to somewhere central. The `os` facts should be
  #        immutable for an entire test run ;)
  before(:all) do
    facts = run_bolt_task('facts')
    unless facts.exit_code == 0
      raise "Unable to collect facts: #{facts}"
    end

    @service_name = case (family = facts.result['os']['family'])
                    when /redhat/i
                      'sshd'
                    when /debian/i
                      'ssh'
                    else
                      raise "Unknown SSH service name for: #{family}"
                    end
  end

  subject { service(@service_name) }

  it 'is enabled' do
    expect(subject).to be_enabled
  end

  it 'is running' do
    expect(subject).to be_running
  end
end
