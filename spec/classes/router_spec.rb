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

      context 'as router' do
        let(:pre_condition) do
          '
          # inet-filter-chain-default_fwd
          nftables::rule{
            \'default_fwd-out\':
              order   => \'20\',
              content => \'iifname eth1 oifname eth0 accept\';
            \'default_fwd-drop\':
              order   => \'90\',
              content => \'iifname eth0 drop\';
          }

          nftables::rules::masquerade{
            \'masquerade\':
              order => \'20\',
              oif   => \'eth0\';
          }
          '
        end

        it { is_expected.to compile }

        it {
          expect(subject).to contain_concat('nftables-inet-filter-chain-default_fwd').with(
            path: '/etc/nftables/puppet-preflight/inet-filter-chain-default_fwd.nft',
            owner: 'root',
            group: 'root',
            mode: nft_mode,
            ensure_newline: true
          )
        }

        it {
          expect(subject).to contain_concat__fragment('nftables-inet-filter-chain-default_fwd-header').with(
            target: 'nftables-inet-filter-chain-default_fwd',
            content: %r{^chain default_fwd \{$},
            order: '00'
          )
        }

        it {
          expect(subject).to contain_concat__fragment('nftables-inet-filter-chain-default_fwd-rule-out').with(
            target: 'nftables-inet-filter-chain-default_fwd',
            content: %r{^  iifname eth1 oifname eth0 accept$},
            order: '20-nftables-inet-filter-chain-default_fwd-rule-out-b'
          )
        }

        it {
          expect(subject).to contain_concat__fragment('nftables-inet-filter-chain-default_fwd-rule-drop').with(
            target: 'nftables-inet-filter-chain-default_fwd',
            content: %r{^  iifname eth0 drop$},
            order: '90-nftables-inet-filter-chain-default_fwd-rule-drop-b'
          )
        }

        it {
          expect(subject).to contain_concat__fragment('nftables-inet-filter-chain-default_fwd-footer').with(
            target: 'nftables-inet-filter-chain-default_fwd',
            content: %r{^\}$},
            order: '99'
          )
        }

        it {
          expect(subject).to contain_concat('nftables-ip-nat-chain-PREROUTING').with(
            path: '/etc/nftables/puppet-preflight/ip-nat-chain-PREROUTING.nft',
            owner: 'root',
            group: 'root',
            mode: nft_mode,
            ensure_newline: true
          )
        }

        it {
          expect(subject).to contain_concat__fragment('nftables-ip-nat-chain-PREROUTING-header').with(
            target: 'nftables-ip-nat-chain-PREROUTING',
            content: %r{^chain PREROUTING \{$},
            order: '00'
          )
        }

        it {
          expect(subject).to contain_concat__fragment('nftables-ip-nat-chain-PREROUTING-rule-type').with(
            target: 'nftables-ip-nat-chain-PREROUTING',
            content: %r{^  type nat hook prerouting priority -100$},
            order: '01-nftables-ip-nat-chain-PREROUTING-rule-type-b'
          )
        }

        it {
          expect(subject).to contain_concat__fragment('nftables-ip-nat-chain-PREROUTING-rule-policy').with(
            target: 'nftables-ip-nat-chain-PREROUTING',
            content: %r{^  policy accept$},
            order: '02-nftables-ip-nat-chain-PREROUTING-rule-policy-b'
          )
        }

        it {
          expect(subject).to contain_concat__fragment('nftables-ip-nat-chain-PREROUTING-footer').with(
            target: 'nftables-ip-nat-chain-PREROUTING',
            content: %r{^\}$},
            order: '99'
          )
        }

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
          expect(subject).to contain_concat__fragment('nftables-ip-nat-chain-POSTROUTING-rule-masquerade').with(
            target: 'nftables-ip-nat-chain-POSTROUTING',
            content: %r{^  oifname eth0 masquerade$},
            order: '20-nftables-ip-nat-chain-POSTROUTING-rule-masquerade-b'
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
