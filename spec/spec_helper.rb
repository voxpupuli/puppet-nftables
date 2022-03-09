# frozen_string_literal: true

# Managed by modulesync - DO NOT EDIT
# https://voxpupuli.org/docs/updating-files-managed-with-modulesync/

RSpec.configure do |c|
  c.before do
    # select the systemd service provider even when on docker
    # https://tickets.puppetlabs.com/browse/PUP-11167
    if defined?(facts) && %w[Archlinux RedHat].include?(facts[:os]['family'])
      allow(Puppet::FileSystem).to receive(:exist?).and_call_original
      allow(Puppet::FileSystem).to receive(:exist?).with('/proc/1/comm').and_return(true)
      allow(Puppet::FileSystem).to receive(:read).and_call_original
      allow(Puppet::FileSystem).to receive(:read).with('/proc/1/comm').and_return(['systemd'])
    end
  end
end

# puppetlabs_spec_helper will set up coverage if the env variable is set.
# We want to do this if lib exists and it hasn't been explicitly set.
ENV['COVERAGE'] ||= 'yes' if Dir.exist?(File.expand_path('../lib', __dir__))

require 'voxpupuli/test/spec_helper'

if File.exist?(File.join(__dir__, 'default_module_facts.yml'))
  facts = YAML.safe_load(File.read(File.join(__dir__, 'default_module_facts.yml')))
  facts&.each do |name, value|
    add_custom_fact name.to_sym, value
  end
end
