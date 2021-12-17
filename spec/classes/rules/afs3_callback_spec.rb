# frozen_string_literal: true

require 'spec_helper'

describe 'nftables::rules::afs3_callback' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'default options' do
        it { is_expected.to compile }
        it { is_expected.to contain_nftables__rule('default_in-afs3_callback') }
        it { is_expected.to contain_nftables__rule('default_in-afs3_callback').with_content('ip saddr { 0.0.0.0/0 } udp dport 7001 accept') }
      end

      context 'with saddr set' do
        let(:params) do
          {
            saddr: ['192.168.0.0/16', '1.2.3.4'],
          }
        end

        it { is_expected.to compile }
        it { is_expected.to contain_nftables__rule('default_in-afs3_callback') }
        it { is_expected.to contain_nftables__rule('default_in-afs3_callback').with_content('ip saddr { 192.168.0.0/16, 1.2.3.4 } udp dport 7001 accept') }
      end
    end
  end
end
