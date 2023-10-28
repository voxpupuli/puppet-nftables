# frozen_string_literal: true

require 'spec_helper'

describe 'nftables::rules::dns' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'default options' do
        it { is_expected.to contain_nftables__rule('default_in-dns_tcp').with_content('tcp dport {53} accept') }
        it { is_expected.to contain_nftables__rule('default_in-dns_udp').with_content('udp dport {53} accept') }
      end

      context 'with ports set' do
        let(:params) do
          {
            ports: [55, 60],
          }
        end

        it { is_expected.to contain_nftables__rule('default_in-dns_tcp').with_content('tcp dport {55, 60} accept') }
        it { is_expected.to contain_nftables__rule('default_in-dns_udp').with_content('udp dport {55, 60} accept') }
      end
    end
  end
end
