# frozen_string_literal: true

require 'spec_helper'

describe 'nftables::rules::out::pxp_agent' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        { broker: '1.2.3.4' }
      end

      context 'default options' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_nftables__rule('default_out-pxpagent-0').with_content('ip daddr 1.2.3.4 tcp dport 8142 accept') }
      end

      context 'with different port' do
        let(:params) do
          super().merge({ broker_port: 8141 })
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_nftables__rule('default_out-pxpagent-0').with_content('ip daddr 1.2.3.4 tcp dport 8141 accept') }
      end

      context 'with ipv6 address' do
        let(:params) do
          { broker: 'fe80::1' }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_nftables__rule('default_out-pxpagent-0').with_content('ip6 daddr fe80::1 tcp dport 8142 accept') }
      end

      context 'with ipv6 & ipv4 address' do
        let(:params) do
          { broker: ['fe80::1', '1.2.3.4'] }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_nftables__rule('default_out-pxpagent-0').with_content('ip6 daddr fe80::1 tcp dport 8142 accept') }
        it { is_expected.to contain_nftables__rule('default_out-pxpagent-1').with_content('ip daddr 1.2.3.4 tcp dport 8142 accept') }
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_out-rule-pxpagent-0') }
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_out-rule-pxpagent-0_header') }
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_out-rule-pxpagent-1') }
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_out-rule-pxpagent-1_header') }
      end
    end
  end
end
