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

      context 'with snat6' do
        let(:pre_condition) do
          '
          nftables::rules::snat6{
            \'static\':
              order => \'60\',
              snat  => \'cafe::babe\',
              oif   => \'eth0\';
            \'1_1\':
              order => \'61\',
              saddr => \'cafe::babe\',
              snat  => \'cafe::babe\',
              oif   => \'eth0\';
            \'1_1_smtp\':
              saddr => \'cafe::babe\',
              snat  => \'cafe::babe\',
              dport => \'25\';
            \'1_1_wireguard\':
              saddr => \'cafe::babe\',
              snat  => \'cafe::babe\',
              proto => \'udp\',
              dport => \'51820\';
          }
          '
        end

        it { is_expected.to compile }

        it {
          expect(subject).to contain_concat('nftables-ip6-nat-chain-POSTROUTING6').with(
            path: '/etc/nftables/puppet-preflight/ip6-nat-chain-POSTROUTING6.nft',
            owner: 'root',
            group: 'root',
            mode: nft_mode,
            ensure_newline: true
          )
        }

        it {
          expect(subject).to contain_concat__fragment('nftables-ip6-nat-chain-POSTROUTING6-header').with(
            target: 'nftables-ip6-nat-chain-POSTROUTING6',
            content: %r{^chain POSTROUTING6 \{$},
            order: '00'
          )
        }

        it {
          expect(subject).to contain_concat__fragment('nftables-ip6-nat-chain-POSTROUTING6-rule-type').with(
            target: 'nftables-ip6-nat-chain-POSTROUTING6',
            content: %r{^  type nat hook postrouting priority 100$},
            order: '01-nftables-ip6-nat-chain-POSTROUTING6-rule-type-b'
          )
        }

        it {
          expect(subject).to contain_concat__fragment('nftables-ip6-nat-chain-POSTROUTING6-rule-policy').with(
            target: 'nftables-ip6-nat-chain-POSTROUTING6',
            content: %r{^  policy accept$},
            order: '02-nftables-ip6-nat-chain-POSTROUTING6-rule-policy-b'
          )
        }

        it {
          expect(subject).to contain_concat__fragment('nftables-ip6-nat-chain-POSTROUTING6-rule-static').with(
            target: 'nftables-ip6-nat-chain-POSTROUTING6',
            content: %r{^  oifname eth0 snat cafe::babe$},
            order: '60-nftables-ip6-nat-chain-POSTROUTING6-rule-static-b'
          )
        }

        it {
          expect(subject).to contain_concat__fragment('nftables-ip6-nat-chain-POSTROUTING6-rule-1_1').with(
            target: 'nftables-ip6-nat-chain-POSTROUTING6',
            content: %r{^  oifname eth0 ip6 saddr cafe::babe snat cafe::babe$},
            order: '61-nftables-ip6-nat-chain-POSTROUTING6-rule-1_1-b'
          )
        }

        it {
          expect(subject).to contain_concat__fragment('nftables-ip6-nat-chain-POSTROUTING6-rule-1_1_smtp').with(
            target: 'nftables-ip6-nat-chain-POSTROUTING6',
            content: %r{^  ip6 saddr cafe::babe tcp dport 25 snat cafe::babe$},
            order: '70-nftables-ip6-nat-chain-POSTROUTING6-rule-1_1_smtp-b'
          )
        }

        it {
          expect(subject).to contain_concat__fragment('nftables-ip6-nat-chain-POSTROUTING6-rule-1_1_wireguard').with(
            target: 'nftables-ip6-nat-chain-POSTROUTING6',
            content: %r{^  ip6 saddr cafe::babe udp dport 51820 snat cafe::babe$},
            order: '70-nftables-ip6-nat-chain-POSTROUTING6-rule-1_1_wireguard-b'
          )
        }

        it {
          expect(subject).to contain_concat__fragment('nftables-ip6-nat-chain-POSTROUTING6-footer').with(
            target: 'nftables-ip6-nat-chain-POSTROUTING6',
            content: %r{^\}$},
            order: '99'
          )
        }
      end
    end
  end
end
