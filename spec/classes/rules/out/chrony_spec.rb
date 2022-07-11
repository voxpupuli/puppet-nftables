# frozen_string_literal: true

require 'spec_helper'

describe 'nftables::rules::out::chrony' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'default options' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_nftables__rule('default_out-chrony').with_content('udp dport 123 accept') }
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_out-rule-chrony') }
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_out-rule-chrony_header') }
      end

      context 'with two IPv4 addresses as array' do
        let(:params) do
          { servers: ['1.2.3.4', '5.6.7.8'] }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_nftables__rule('default_out-chrony_v4').with_content('ip daddr {1.2.3.4,5.6.7.8} udp dport 123 accept') }
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_out-rule-chrony_v4') }
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_out-rule-chrony_v4_header') }
      end

      context 'with ipv6 & ipv4 address as array' do
        let(:params) do
          { servers: ['fe80::1', '1.2.3.4'] }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_nftables__rule('default_out-chrony_v4').with_content('ip daddr {1.2.3.4} udp dport 123 accept') }
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_out-rule-chrony_v4') }
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_out-rule-chrony_v4_header') }
        it { is_expected.to contain_nftables__rule('default_out-chrony_v6').with_content('ip6 daddr {fe80::1} udp dport 123 accept') }
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_out-rule-chrony_v6') }
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_out-rule-chrony_v6_header') }
      end
    end
  end
end
