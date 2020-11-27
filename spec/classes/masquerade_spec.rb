require 'spec_helper'

describe 'nftables' do
  let(:pre_condition) { 'Exec{path => "/bin"}' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with masquerade' do
        let(:pre_condition) do
          '
          nftables::rules::masquerade{
            \'masquerade_eth0\':
              oif => \'eth0\';
            \'masquerade_eth1_vpn\':
              oif   => \'eth1\',
              saddr => \'192.0.2.0/24\';
            \'masquerade_ssh\':
              saddr => \'192.0.2.0/24\',
              daddr => \'198.51.100.2\',
              proto => \'tcp\',
              dport => \'22\';
            \'masquerade_ssh_gitlab\':
              saddr => \'192.0.2.0/24\',
              daddr => \'198.51.100.2\',
              dport => \'22\';
            \'masquerade_wireguard\':
              proto => \'udp\',
              dport => \'51820\';
          }
          '
        end

        it { is_expected.to compile }

        it {
          is_expected.to contain_concat('nftables-ip-nat-chain-POSTROUTING').with(
            path:           '/etc/nftables/puppet-preflight/ip-nat-chain-POSTROUTING.nft',
            owner:          'root',
            group:          'root',
            mode:           '0640',
            ensure_newline: true,
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-ip-nat-chain-POSTROUTING-header').with(
            target:  'nftables-ip-nat-chain-POSTROUTING',
            content: %r{^chain POSTROUTING \{$},
            order:   '00',
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-ip-nat-chain-POSTROUTING-rule-type').with(
            target:  'nftables-ip-nat-chain-POSTROUTING',
            content: %r{^  type nat hook postrouting priority 100$},
            order:   '01-nftables-ip-nat-chain-POSTROUTING-rule-type-b',
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-ip-nat-chain-POSTROUTING-rule-policy').with(
            target:  'nftables-ip-nat-chain-POSTROUTING',
            content: %r{^  policy accept$},
            order:   '02-nftables-ip-nat-chain-POSTROUTING-rule-policy-b',
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-ip-nat-chain-POSTROUTING-rule-masquerade_eth0').with(
            target:  'nftables-ip-nat-chain-POSTROUTING',
            content: %r{^  oifname eth0 masquerade$},
            order:   '70-nftables-ip-nat-chain-POSTROUTING-rule-masquerade_eth0-b',
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-ip-nat-chain-POSTROUTING-rule-masquerade_eth1_vpn').with(
            target:  'nftables-ip-nat-chain-POSTROUTING',
            content: %r{^  oifname eth1 ip saddr 192\.0\.2\.0\/24 masquerade$},
            order:   '70-nftables-ip-nat-chain-POSTROUTING-rule-masquerade_eth1_vpn-b',
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-ip-nat-chain-POSTROUTING-rule-masquerade_ssh').with(
            target:  'nftables-ip-nat-chain-POSTROUTING',
            content: %r{^  ip saddr 192\.0\.2\.0\/24 ip daddr 198.51.100.2 tcp dport 22 masquerade$},
            order:   '70-nftables-ip-nat-chain-POSTROUTING-rule-masquerade_ssh-b',
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-ip-nat-chain-POSTROUTING-rule-masquerade_ssh_gitlab').with(
            target:  'nftables-ip-nat-chain-POSTROUTING',
            content: %r{^  ip saddr 192\.0\.2\.0\/24 ip daddr 198.51.100.2 tcp dport 22 masquerade$},
            order:   '70-nftables-ip-nat-chain-POSTROUTING-rule-masquerade_ssh_gitlab-b',
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-ip-nat-chain-POSTROUTING-rule-masquerade_wireguard').with(
            target:  'nftables-ip-nat-chain-POSTROUTING',
            content: %r{^  udp dport 51820 masquerade$},
            order:   '70-nftables-ip-nat-chain-POSTROUTING-rule-masquerade_wireguard-b',
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-ip-nat-chain-POSTROUTING-footer').with(
            target:  'nftables-ip-nat-chain-POSTROUTING',
            content: %r{^\}$},
            order:   '99',
          )
        }
      end
    end
  end
end
