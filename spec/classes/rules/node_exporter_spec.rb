require 'spec_helper'

describe 'nftables::rules::node_exporter' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'default options' do
        it { is_expected.to compile }
        it { is_expected.to contain_nftables__rule('default_in-node_exporter').with_content('tcp dport 9100 accept') }
      end

      context 'with port set' do
        let(:params) do
          {
            port: 100,
          }
        end

        it { is_expected.to compile }
        it { is_expected.to contain_nftables__rule('default_in-node_exporter').with_content('tcp dport 100 accept') }
        context 'with prometheus_server set' do
          let(:params) do
            super().merge({ prometheus_server: ['127.0.0.1', '::1'] })
          end

          it { is_expected.to contain_nftables__rule('default_in-node_exporter-0').with_content('ip saddr 127.0.0.1 tcp dport 100 accept') }
          it { is_expected.to contain_nftables__rule('default_in-node_exporter-1').with_content('ip6 saddr ::1 tcp dport 100 accept') }
        end
      end
    end
  end
end
