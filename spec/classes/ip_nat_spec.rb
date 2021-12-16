# frozen_string_literal: true

require 'spec_helper'

describe 'nftables' do
  let(:pre_condition) { 'Exec{path => "/bin"}' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      it {
        expect(subject).to contain_concat('nftables-ip-nat').with(
          path: '/etc/nftables/puppet-preflight/ip-nat.nft',
          ensure: 'present',
          owner: 'root',
          group: 'root',
          mode: '0640'
        )
      }

      it {
        expect(subject).to contain_concat__fragment('nftables-ip-nat-header').with(
          target: 'nftables-ip-nat',
          content: %r{^table ip nat \{$},
          order: '00'
        )
      }

      it {
        expect(subject).to contain_concat__fragment('nftables-ip-nat-body').with(
          target: 'nftables-ip-nat',
          content: %r{^\s+include "ip-nat-chain-\*\.nft"$},
          order: '98'
        )
      }

      it {
        expect(subject).to contain_concat__fragment('nftables-ip-nat-footer').with(
          target: 'nftables-ip-nat',
          content: %r{^\}$},
          order: '99'
        )
      }

      it {
        expect(subject).to contain_concat('nftables-ip6-nat').with(
          path: '/etc/nftables/puppet-preflight/ip6-nat.nft',
          ensure: 'present',
          owner: 'root',
          group: 'root',
          mode: '0640'
        )
      }

      it {
        expect(subject).to contain_concat__fragment('nftables-ip6-nat-header').with(
          target: 'nftables-ip6-nat',
          content: %r{^table ip6 nat \{$},
          order: '00'
        )
      }

      it {
        expect(subject).to contain_concat__fragment('nftables-ip6-nat-body').with(
          target: 'nftables-ip6-nat',
          content: %r{^\s+include "ip6-nat-chain-\*\.nft"$},
          order: '98'
        )
      }

      it {
        expect(subject).to contain_concat__fragment('nftables-ip6-nat-footer').with(
          target: 'nftables-ip6-nat',
          content: %r{^\}$},
          order: '99'
        )
      }

      context 'table ip nat chain prerouting' do
        it {
          expect(subject).to contain_concat('nftables-ip-nat-chain-PREROUTING').with(
            path: '/etc/nftables/puppet-preflight/ip-nat-chain-PREROUTING.nft',
            owner: 'root',
            group: 'root',
            mode: '0640',
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
      end

      context 'table ipv4 nat chain postrouting' do
        it {
          expect(subject).to contain_concat('nftables-ip-nat-chain-POSTROUTING').with(
            path: '/etc/nftables/puppet-preflight/ip-nat-chain-POSTROUTING.nft',
            owner: 'root',
            group: 'root',
            mode: '0640',
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
          expect(subject).to contain_concat__fragment('nftables-ip-nat-chain-POSTROUTING-footer').with(
            target: 'nftables-ip-nat-chain-POSTROUTING',
            content: %r{^\}$},
            order: '99'
          )
        }
      end

      context 'table ip6 nat chain prerouting' do
        it {
          expect(subject).to contain_concat('nftables-ip6-nat-chain-PREROUTING6').with(
            path: '/etc/nftables/puppet-preflight/ip6-nat-chain-PREROUTING6.nft',
            owner: 'root',
            group: 'root',
            mode: '0640',
            ensure_newline: true
          )
        }

        it {
          expect(subject).to contain_concat__fragment('nftables-ip6-nat-chain-PREROUTING6-header').with(
            target: 'nftables-ip6-nat-chain-PREROUTING6',
            content: %r{^chain PREROUTING6 \{$},
            order: '00'
          )
        }

        it {
          expect(subject).to contain_concat__fragment('nftables-ip6-nat-chain-PREROUTING6-rule-type').with(
            target: 'nftables-ip6-nat-chain-PREROUTING6',
            content: %r{^  type nat hook prerouting priority -100$},
            order: '01-nftables-ip6-nat-chain-PREROUTING6-rule-type-b'
          )
        }

        it {
          expect(subject).to contain_concat__fragment('nftables-ip6-nat-chain-PREROUTING6-rule-policy').with(
            target: 'nftables-ip6-nat-chain-PREROUTING6',
            content: %r{^  policy accept$},
            order: '02-nftables-ip6-nat-chain-PREROUTING6-rule-policy-b'
          )
        }

        it {
          expect(subject).to contain_concat__fragment('nftables-ip6-nat-chain-PREROUTING6-footer').with(
            target: 'nftables-ip6-nat-chain-PREROUTING6',
            content: %r{^\}$},
            order: '99'
          )
        }
      end

      context 'table ipv6 nat chain postrouting' do
        it {
          expect(subject).to contain_concat('nftables-ip6-nat-chain-POSTROUTING6').with(
            path: '/etc/nftables/puppet-preflight/ip6-nat-chain-POSTROUTING6.nft',
            owner: 'root',
            group: 'root',
            mode: '0640',
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
          expect(subject).to contain_concat__fragment('nftables-ip6-nat-chain-POSTROUTING6-footer').with(
            target: 'nftables-ip6-nat-chain-POSTROUTING6',
            content: %r{^\}$},
            order: '99'
          )
        }
      end

      context 'custom ip nat table name' do
        let(:params) do
          {
            'nat_table_name' => 'mycustomtablename',
          }
        end

        it { is_expected.to compile }

        it {
          expect(subject).to contain_concat('nftables-ip-mycustomtablename').with(
            path: '/etc/nftables/puppet-preflight/ip-mycustomtablename.nft',
            ensure: 'present',
            owner: 'root',
            group: 'root',
            mode: '0640'
          )
        }
      end

      context 'all nat tables disabled' do
        let(:params) do
          {
            'nat' => false,
          }
        end

        it { is_expected.not_to contain_class('nftables::ip_nat') }
        it { is_expected.not_to contain_nftables__config('ip-nat') }
        it { is_expected.not_to contain_nftables__config('ip6-nat') }
        it { is_expected.not_to contain_nftables__chain('PREROUTING') }
        it { is_expected.not_to contain_nftables__chain('POSTROUTING') }
        it { is_expected.not_to contain_nftables__chain('PREROUTING6') }
        it { is_expected.not_to contain_nftables__chain('POSTROUTING6') }
      end
    end
  end
end
