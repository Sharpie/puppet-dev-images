require 'spec_helper_acceptance'

describe 'systemd' do
  it 'systemctl status returns sucessfully' do
    result = run_shell('systemctl status')
    expect(result.exit_code).to eq(0)
  end

  # TODO: Add check for "degraded" state.
end
