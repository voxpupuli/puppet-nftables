# frozen_string_literal: true

RSpec.configure do |c|
  c.before do
    # select the systemd service provider even when on docker
    # https://tickets.puppetlabs.com/browse/PUP-11167
    allow(Puppet::FileSystem).to receive(:exist?).and_call_original
    allow(Puppet::FileSystem).to receive(:exist?).with('/proc/1/comm').and_return(true)
    allow(Puppet::FileSystem).to receive(:read).and_call_original
    allow(Puppet::FileSystem).to receive(:read).with('/proc/1/comm').and_return(['systemd'])
  end
end
