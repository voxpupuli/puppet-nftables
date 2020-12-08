require 'spec_helper'

describe 'nftables::rules::out::puppet' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        { puppetserver: '1.2.3.4' }
      end

      context 'default options' do
        it { is_expected.to compile }
        it { is_expected.to contain_nftables__rule('default_out-puppet-0').with_content('ip daddr 1.2.3.4 tcp dport 8140 accept') }
      end
      context 'with different port' do
        let(:params) do
          super().merge({ puppetserver_port: 8141 })
        end

        it { is_expected.to compile }
        it { is_expected.to contain_nftables__rule('default_out-puppet-0').with_content('ip daddr 1.2.3.4 tcp dport 8141 accept') }
      end
      context 'with ipv6 address' do
        let(:params) do
          { puppetserver: 'fe80::1' }
        end

        it { is_expected.to compile }
        it { is_expected.to contain_nftables__rule('default_out-puppet-0').with_content('ip6 daddr fe80::1 tcp dport 8140 accept') }
      end
      context 'with ipv6 & ipv4 address' do
        let(:params) do
          { puppetserver: ['fe80::1', '1.2.3.4'] }
        end

        it { is_expected.to compile }
        it { is_expected.to contain_nftables__rule('default_out-puppet-0').with_content('ip6 daddr fe80::1 tcp dport 8140 accept') }
        it { is_expected.to contain_nftables__rule('default_out-puppet-1').with_content('ip daddr 1.2.3.4 tcp dport 8140 accept') }
      end
    end
  end
end
