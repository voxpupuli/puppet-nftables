require 'spec_helper'

describe 'nftables' do
  let(:pre_condition) { 'Exec{path => "/bin"}' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      it { is_expected.to contain_file('/etc/nftables/puppet/ip-nat.nft').with(
        :ensure => 'file',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0640',
      )}

      context 'chain prerouting' do
        it { is_expected.to contain_concat('nftables-ip-nat-chain-PREROUTING').with(
          :path           => '/etc/nftables/puppet/ip-nat-chain-PREROUTING.nft',
          :owner          => 'root',
          :group          => 'root',
          :mode           => '0640',
          :ensure_newline => true,
        )}
        it { is_expected.to contain_concat__fragment('nftables-ip-nat-chain-PREROUTING-header').with(
          :target  => 'nftables-ip-nat-chain-PREROUTING',
          :content => /^chain PREROUTING {$/,
          :order   => '00',
        )}
        it { is_expected.to contain_concat__fragment('nftables-ip-nat-chain-PREROUTING-rule-type').with(
          :target  => 'nftables-ip-nat-chain-PREROUTING',
          :content => /^  type filter hook prerouting priority -100$/,
          :order   => '01',
        )}
        it { is_expected.to contain_concat__fragment('nftables-ip-nat-chain-PREROUTING-footer').with(
          :target  => 'nftables-ip-nat-chain-PREROUTING',
          :content => /^}$/,
          :order   => '99',
        )}
      end

      context 'chain output' do
        it { is_expected.to contain_concat('nftables-ip-nat-chain-POSTROUTING').with(
          :path           => '/etc/nftables/puppet/ip-nat-chain-POSTROUTING.nft',
          :owner          => 'root',
          :group          => 'root',
          :mode           => '0640',
          :ensure_newline => true,
        )}
        it { is_expected.to contain_concat__fragment('nftables-ip-nat-chain-POSTROUTING-header').with(
          :target  => 'nftables-ip-nat-chain-POSTROUTING',
          :content => /^chain POSTROUTING {$/,
          :order   => '00',
        )}
        it { is_expected.to contain_concat__fragment('nftables-ip-nat-chain-POSTROUTING-rule-type').with(
          :target  => 'nftables-ip-nat-chain-POSTROUTING',
          :content => /^  type filter hook postrouting priority 100$/,
          :order   => '01',
        )}
        it { is_expected.to contain_concat__fragment('nftables-ip-nat-chain-POSTROUTING-footer').with(
          :target  => 'nftables-ip-nat-chain-POSTROUTING',
          :content => /^}$/,
          :order   => '99',
        )}
      end
    end
  end
end
