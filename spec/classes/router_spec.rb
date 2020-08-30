require 'spec_helper'

describe 'nftables' do
  let(:pre_condition) { 'Exec{path => "/bin"}' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context "as router" do
        let(:pre_condition) {
          """
          # inet-filter-chain-default_fwd
          nftables::rule{
            'default_fwd-out':
              order   => '20',
              content => 'iifname eth1 oifname eth0 accept';
            'default_fwd-drop':
              order   => '90',
              content => 'iifname eth0 drop';
            'POSTROUTING-masquerade':
              table   => 'ip-nat',
              order   => '20',
              content => 'oifname eth0 masquerade';
          }
          """
        }

        it { is_expected.to compile }

        it { is_expected.to contain_concat('nftables-inet-filter-chain-default_fwd').with(
          :path           => '/etc/nftables/puppet/inet-filter-chain-default_fwd.nft',
          :owner          => 'root',
          :group          => 'root',
          :mode           => '0640',
          :ensure_newline => true,
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_fwd-header').with(
          :target  => 'nftables-inet-filter-chain-default_fwd',
          :content => /^chain default_fwd {$/,
          :order   => '00',
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_fwd-rule-out').with(
          :target  => 'nftables-inet-filter-chain-default_fwd',
          :content => /^  iifname eth1 oifname eth0 accept$/,
          :order   => '20',
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_fwd-rule-drop').with(
          :target  => 'nftables-inet-filter-chain-default_fwd',
          :content => /^  iifname eth0 drop$/,
          :order   => '90',
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_fwd-footer').with(
          :target  => 'nftables-inet-filter-chain-default_fwd',
          :content => /^}$/,
          :order   => '99',
        )}

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
          :content => /^  type nat hook prerouting priority -100$/,
          :order   => '01',
        )}
        it { is_expected.to contain_concat__fragment('nftables-ip-nat-chain-PREROUTING-rule-policy').with(
          :target  => 'nftables-ip-nat-chain-PREROUTING',
          :content => /^  policy accept$/,
          :order   => '02',
        )}
        it { is_expected.to contain_concat__fragment('nftables-ip-nat-chain-PREROUTING-footer').with(
          :target  => 'nftables-ip-nat-chain-PREROUTING',
          :content => /^}$/,
          :order   => '99',
        )}

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
          :content => /^  type nat hook postrouting priority 100$/,
          :order   => '01',
        )}
        it { is_expected.to contain_concat__fragment('nftables-ip-nat-chain-POSTROUTING-rule-policy').with(
          :target  => 'nftables-ip-nat-chain-POSTROUTING',
          :content => /^  policy accept$/,
          :order   => '02',
        )}
        it { is_expected.to contain_concat__fragment('nftables-ip-nat-chain-POSTROUTING-rule-masquerade').with(
          :target  => 'nftables-ip-nat-chain-POSTROUTING',
          :content => /^  oifname eth0 masquerade$/,
          :order   => '20',
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
