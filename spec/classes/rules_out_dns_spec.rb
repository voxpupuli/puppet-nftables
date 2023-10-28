# frozen_string_literal: true

require 'spec_helper'

describe 'nftables' do
  let(:pre_condition) { 'Exec{path => "/bin"}' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with standard dns' do
        let(:pre_condition) do
          '
          include nftables::rules::out::dns
          '
        end

        it {
          expect(subject).to contain_concat__fragment('nftables-inet-filter-chain-default_out-rule-dnsudp').with(
            target: 'nftables-inet-filter-chain-default_out',
            content: %r{^  udp dport 53 accept$},
            order: '50-nftables-inet-filter-chain-default_out-rule-dnsudp-b'
          )
        }

        it {
          expect(subject).to contain_concat__fragment('nftables-inet-filter-chain-default_out-rule-dnstcp').with(
            target: 'nftables-inet-filter-chain-default_out',
            content: %r{^  tcp dport 53 accept$},
            order: '50-nftables-inet-filter-chain-default_out-rule-dnstcp-b'
          )
        }
      end

      context 'with custom dns servers' do
        let(:pre_condition) do
          "
          class{'nftables::rules::out::dns':
            dns_server => ['192.0.2.1', '2001:db8::1'],
          }
          "
        end

        it {
          expect(subject).to contain_concat__fragment('nftables-inet-filter-chain-default_out-rule-dnsudp-0').with(
            target: 'nftables-inet-filter-chain-default_out',
            content: %r{^  ip daddr 192.0.2.1 udp dport 53 accept$},
            order: '50-nftables-inet-filter-chain-default_out-rule-dnsudp-0-b'
          )
        }

        it {
          expect(subject).to contain_concat__fragment('nftables-inet-filter-chain-default_out-rule-dnstcp-0').with(
            target: 'nftables-inet-filter-chain-default_out',
            content: %r{^  ip daddr 192.0.2.1 tcp dport 53 accept$},
            order: '50-nftables-inet-filter-chain-default_out-rule-dnstcp-0-b'
          )
        }

        it {
          expect(subject).to contain_concat__fragment('nftables-inet-filter-chain-default_out-rule-dnsudp-1').with(
            target: 'nftables-inet-filter-chain-default_out',
            content: %r{^  ip6 daddr 2001:db8::1 udp dport 53 accept$},
            order: '50-nftables-inet-filter-chain-default_out-rule-dnsudp-1-b'
          )
        }

        it {
          expect(subject).to contain_concat__fragment('nftables-inet-filter-chain-default_out-rule-dnstcp-1').with(
            target: 'nftables-inet-filter-chain-default_out',
            content: %r{^  ip6 daddr 2001:db8::1 tcp dport 53 accept$},
            order: '50-nftables-inet-filter-chain-default_out-rule-dnstcp-1-b'
          )
        }
      end
    end
  end
end
