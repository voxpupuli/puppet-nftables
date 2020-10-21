# Copy this file into code/spec/classes/init_spec.rb
#
# This example includes a basic test to check that
# nftables::init compiles.
#
# See:
# * http://rspec-puppet.com/tutorial/
# * http://rspec-puppet.com/documentation/
# * https://github.com/mcanevet/rspec-puppet-facts
# for learning RSpec Puppet.

require 'spec_helper'


describe 'nftables' do

  let(:hiera_config) { 'spec/hiera.yaml' }
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      case facts[:operatingsystemmajrelease]
      when '5'
        it { is_expected.to compile.with_all_deps }
        # it { is_expected.to contain_file('/tmp/abc') }
      else
        it { is_expected.to compile.with_all_deps }
        # it { is_expected.to contain_file('/tmp/abcd') }
      end
    end
  end
end
