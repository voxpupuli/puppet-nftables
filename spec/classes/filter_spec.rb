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

        it { is_expected.to contain_concat('nftables-chain-filter-default_in').with(
          :path           => "/etc/nftables/puppet/filter-chains-default_in.nft",
          :owner          => 'root',
          :group          => 'root',
          :mode           => '0644',
          :ensure_newline => true,
        )}
        it { is_expected.to contain_concat__fragment('filter@default_in-header').with(
          :target  => 'nftables-chain-filter-default_in',
          :content => /^chain default_in {$/,
          :order   => '00',
        )}
        it { is_expected.to contain_concat__fragment('filter@default_in-footer').with(
          :target  => 'nftables-chain-filter-default_in',
          :content => /^}$/,
          :order   => '99',
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

        it { is_expected.to contain_concat('nftables-chain-filter-default_fwd').with(
          :path           => "/etc/nftables/puppet/filter-chains-default_fwd.nft",
          :owner          => 'root',
          :group          => 'root',
          :mode           => '0644',
          :ensure_newline => true,
        )}
        it { is_expected.to contain_concat__fragment('filter@default_fwd-header').with(
          :target  => 'nftables-chain-filter-default_fwd',
          :content => /^chain default_fwd {$/,
          :order   => '00',
        )}
        it { is_expected.to contain_concat__fragment('filter@default_fwd-footer').with(
          :target  => 'nftables-chain-filter-default_fwd',
          :content => /^}$/,
          :order   => '99',
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

        it { is_expected.to contain_concat('nftables-chain-filter-default_out').with(
          :path           => "/etc/nftables/puppet/filter-chains-default_out.nft",
          :owner          => 'root',
          :group          => 'root',
          :mode           => '0644',
          :ensure_newline => true,
        )}
        it { is_expected.to contain_concat__fragment('filter@default_out-header').with(
          :target  => 'nftables-chain-filter-default_out',
          :content => /^chain default_out {$/,
          :order   => '00',
        )}
        it { is_expected.to contain_concat__fragment('filter@default_out-footer').with(
          :target  => 'nftables-chain-filter-default_out',
          :content => /^}$/,
          :order   => '99',
        )}
      end
    end
  end
end
