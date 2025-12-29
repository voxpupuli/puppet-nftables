# frozen_string_literal: true

require 'spec_helper'

describe 'nftables::rules::out::choria' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        { brokers: ['1.2.3.4'] }
      end

      context 'default options' do
        it { is_expected.to compile }
        it { is_expected.to contain_nftables__rule('default_out-choria-0').with_content('ip daddr 1.2.3.4 tcp dport 4222 accept') }
        it { is_expected.to contain_nftables__rule('default_out-choriawebsocket-0').with_content('ip daddr 1.2.3.4 tcp dport 4333 accept') }
        it { is_expected.to have_nftables__rule_resource_count(2) }
      end

      context 'with different port' do
        let(:params) do
          super().merge({ choria_port: 8141 })
        end

        it { is_expected.to compile }
        it { is_expected.to contain_nftables__rule('default_out-choria-0').with_content('ip daddr 1.2.3.4 tcp dport 8141 accept') }
        it { is_expected.to contain_nftables__rule('default_out-choriawebsocket-0').with_content('ip daddr 1.2.3.4 tcp dport 4333 accept') }
        it { is_expected.to have_nftables__rule_resource_count(2) }
      end

      context 'with ipv6 address' do
        let(:params) do
          { brokers: ['fe80::1'] }
        end

        it { is_expected.to compile }
        it { is_expected.to contain_nftables__rule('default_out-choria-0').with_content('ip6 daddr fe80::1 tcp dport 4222 accept') }
        it { is_expected.to contain_nftables__rule('default_out-choriawebsocket-0').with_content('ip6 daddr fe80::1 tcp dport 4333 accept') }
        it { is_expected.to have_nftables__rule_resource_count(2) }
      end

      context 'with ipv6 & ipv4 address' do
        let(:params) do
          { brokers: ['fe80::1', '1.2.3.4'] }
        end

        it { is_expected.to compile }
        it { is_expected.to contain_nftables__rule('default_out-choria-0').with_content('ip6 daddr fe80::1 tcp dport 4222 accept') }
        it { is_expected.to contain_nftables__rule('default_out-choria-1').with_content('ip daddr 1.2.3.4 tcp dport 4222 accept') }
        it { is_expected.to contain_nftables__rule('default_out-choriawebsocket-0').with_content('ip6 daddr fe80::1 tcp dport 4333 accept') }
        it { is_expected.to contain_nftables__rule('default_out-choriawebsocket-1').with_content('ip daddr 1.2.3.4 tcp dport 4333 accept') }
        it { is_expected.to have_nftables__rule_resource_count(4) }
      end

      context 'with ipv6 & ipv4 address & without websockets' do
        let(:params) do
          { brokers: ['fe80::1', '1.2.3.4'], enable_websockets: false }
        end

        it { is_expected.to compile }
        it { is_expected.to contain_nftables__rule('default_out-choria-0').with_content('ip6 daddr fe80::1 tcp dport 4222 accept') }
        it { is_expected.to contain_nftables__rule('default_out-choria-1').with_content('ip daddr 1.2.3.4 tcp dport 4222 accept') }
        it { is_expected.to have_nftables__rule_resource_count(2) }
      end

      context 'without IPs' do
        let :params do
          {}
        end

        it { is_expected.to compile }
        it { is_expected.to contain_nftables__rule('default_out-choria-0').with_content('tcp dport 4222 accept') }
        it { is_expected.not_to contain_nftables__rule('default_out-choriawebsocket-0').with_content('tcp dport 4333 accept') }
        it { is_expected.to have_nftables__rule_resource_count(2) }
      end

      context 'without IPs & websockets' do
        let :params do
          { enable_websockets: false }
        end

        it { is_expected.to compile }
        it { is_expected.to contain_nftables__rule('default_out-choria-0').with_content('tcp dport 4222 accept') }
        it { is_expected.to have_nftables__rule_resource_count(1) }
      end
    end
  end
end
