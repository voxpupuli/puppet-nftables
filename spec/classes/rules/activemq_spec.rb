# frozen_string_literal: true

require 'spec_helper'

describe 'nftables::rules::activemq' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'default options' do
        it { is_expected.to contain_nftables__rule('default_in-activemq_tcp').with_content('tcp dport 61616 accept') }
        it { is_expected.to contain_nftables__rule('default_in-activemq_udp').with_content('udp dport 61616 accept') }
      end

      context 'with tcp set to false' do
        let(:params) do
          {
            tcp: false,
          }
        end

        it { is_expected.not_to contain_nftables__rule('default_in-activemq_tcp').with_content('tcp dport 61616 accept') }
        it { is_expected.to contain_nftables__rule('default_in-activemq_udp').with_content('udp dport 61616 accept') }
      end

      context 'with udp set to false' do
        let(:params) do
          {
            udp: false,
          }
        end

        it { is_expected.to contain_nftables__rule('default_in-activemq_tcp').with_content('tcp dport 61616 accept') }
        it { is_expected.not_to contain_nftables__rule('default_in-activemq_udp').with_content('udp dport 61616 accept') }
      end
    end
  end
end
