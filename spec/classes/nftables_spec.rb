require 'spec_helper'

describe 'nftables' do
  let(:pre_condition) { 'Exec{path => "/bin"}' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      it { is_expected.to contain_package('nftables') }

      it { is_expected.to contain_file('/etc/nftables/puppet.nft').with(
        :ensure => 'file',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0640',
        :source => 'puppet:///modules/nftables/config/puppet.nft',
      )}

      it { is_expected.to contain_file('/etc/nftables/puppet').with(
        :ensure  => 'directory',
        :owner   => 'root',
        :group   => 'root',
        :mode    => '0750',
        :purge   => true,
        :force   => true,
        :recurse => true,
      )}

      it { is_expected.to contain_service('nftables').with(
        :ensure => 'running',
        :enable => true,
      )}

      it { is_expected.to contain_service('firewalld').with(
        :ensure => 'stopped',
        :enable => 'mask',
      )}
    end
  end
end
