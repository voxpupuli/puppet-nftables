# frozen_string_literal: true

require 'spec_helper'

describe 'nftables' do
  let(:pre_condition) { 'Exec{path => "/bin"}' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      nft_mode = case os_facts[:os]['family']
                 when 'RedHat'
                   '0600'
                 else
                   '0640'
                 end

      context 'with snat4' do
        let(:pre_condition) do
          '
          nftables::rules::snat4{
            \'static\':
              order => \'60\',
              snat  => \'198.51.100.1\',
              oif   => \'eth0\';
            \'1_1\':
              order => \'61\',
              saddr => \'192.0.2.2\',
              snat  => \'198.51.100.3\',
              oif   => \'eth0\';
            \'1_1_smtp\':
              saddr => \'192.0.2.2\',
              snat  => \'198.51.100.2\',
              dport => \'25\';
            \'1_1_wireguard\':
              saddr => \'192.0.2.2\',
              snat  => \'198.51.100.2\',
              proto => \'udp\',
              dport => \'51820\';
          }
          '
        end

        it { is_expected.to compile }

        it {
          expect(subject).to contain_concat('nftables-ip-nat-chain-POSTROUTING').with(
            path: '/etc/nftables/puppet-preflight/ip-nat-chain-POSTROUTING.nft',
            owner: 'root',
            group: 'root',
            mode: nft_mode,
            ensure_newline: true
          )
        }

        it {
          expect(subject).to contain_concat__fragment('nftables-ip-nat-chain-POSTROUTING-header').with(
            target: 'nftables-ip-nat-chain-POSTROUTING',
            content: %r{^chain POSTROUTING \{$},
            order: '00'
          )
        }

        it {
          expect(subject).to contain_concat__fragment('nftables-ip-nat-chain-POSTROUTING-rule-type').with(
            target: 'nftables-ip-nat-chain-POSTROUTING',
            content: %r{^  type nat hook postrouting priority 100$},
            order: '01-nftables-ip-nat-chain-POSTROUTING-rule-type-b'
          )
        }

        it {
          expect(subject).to contain_concat__fragment('nftables-ip-nat-chain-POSTROUTING-rule-policy').with(
            target: 'nftables-ip-nat-chain-POSTROUTING',
            content: %r{^  policy accept$},
            order: '02-nftables-ip-nat-chain-POSTROUTING-rule-policy-b'
          )
        }

        it {
          expect(subject).to contain_concat__fragment('nftables-ip-nat-chain-POSTROUTING-rule-static').with(
            target: 'nftables-ip-nat-chain-POSTROUTING',
            content: %r{^  oifname eth0 snat 198\.51\.100\.1$},
            order: '60-nftables-ip-nat-chain-POSTROUTING-rule-static-b'
          )
        }

        it {
          expect(subject).to contain_concat__fragment('nftables-ip-nat-chain-POSTROUTING-rule-1_1').with(
            target: 'nftables-ip-nat-chain-POSTROUTING',
            content: %r{^  oifname eth0 ip saddr 192\.0\.2\.2 snat 198\.51\.100\.3$},
            order: '61-nftables-ip-nat-chain-POSTROUTING-rule-1_1-b'
          )
        }

        it {
          expect(subject).to contain_concat__fragment('nftables-ip-nat-chain-POSTROUTING-rule-1_1_smtp').with(
            target: 'nftables-ip-nat-chain-POSTROUTING',
            content: %r{^  ip saddr 192\.0\.2\.2 tcp dport 25 snat 198\.51\.100\.2$},
            order: '70-nftables-ip-nat-chain-POSTROUTING-rule-1_1_smtp-b'
          )
        }

        it {
          expect(subject).to contain_concat__fragment('nftables-ip-nat-chain-POSTROUTING-rule-1_1_wireguard').with(
            target: 'nftables-ip-nat-chain-POSTROUTING',
            content: %r{^  ip saddr 192\.0\.2\.2 udp dport 51820 snat 198\.51\.100\.2$},
            order: '70-nftables-ip-nat-chain-POSTROUTING-rule-1_1_wireguard-b'
          )
        }

        it {
          expect(subject).to contain_concat__fragment('nftables-ip-nat-chain-POSTROUTING-footer').with(
            target: 'nftables-ip-nat-chain-POSTROUTING',
            content: %r{^\}$},
            order: '99'
          )
        }
      end
    end
  end
end
