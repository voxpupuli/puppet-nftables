require 'spec_helper'

describe 'nftables' do
  let(:pre_condition) {
    <<-EOS
    Exec{path => "/bin"}
    EOS
  }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      it { is_expected.to contain_file('/etc/nftables/puppet/filter.nft').with(
        :ensure => 'file',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0640',
      )}

      context "chain input" do
        it { is_expected.to contain_file('/etc/nftables/puppet/filter-input-chains-50-default_in.nft').with(
          :ensure => 'file',
          :owner  => 'root',
          :group  => 'root',
          :mode   => '0640',
        )}
        it { is_expected.to contain_file('/etc/nftables/puppet/filter-input-chains-50-default_in.nft').with_content(
          /^jump default_in$/
        )}
      end

      context "chain forward" do
        it { is_expected.to contain_file('/etc/nftables/puppet/filter-forward-chains-50-default_fwd.nft').with(
          :ensure => 'file',
          :owner  => 'root',
          :group  => 'root',
          :mode   => '0640',
        )}
        it { is_expected.to contain_file('/etc/nftables/puppet/filter-forward-chains-50-default_fwd.nft').with_content(
          /^jump default_fwd$/
        )}
      end

      context "chain output" do
        it { is_expected.to contain_file('/etc/nftables/puppet/filter-output-chains-50-default_out.nft').with(
          :ensure => 'file',
          :owner  => 'root',
          :group  => 'root',
          :mode   => '0640',
        )}
        it { is_expected.to contain_file('/etc/nftables/puppet/filter-output-chains-50-default_out.nft').with_content(
          /^jump default_out$/
        )}
      end
    end
  end
end
