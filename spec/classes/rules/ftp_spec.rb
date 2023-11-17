# frozen_string_literal: true

require 'spec_helper'

describe 'nftables::rules::ftp' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      # Required for nftables::helper (default_config_mode)
      let(:pre_condition) { 'include nftables' }

      context 'default options' do
        it { is_expected.to contain_nftables__helper('ftp-standard') }
        it { is_expected.to contain_nftables__chain('PRE') }
        it { is_expected.to contain_nftables__rule('PRE-type') }
        it { is_expected.to contain_nftables__rule('PRE-policy') }
        it { is_expected.to contain_nftables__rule('PRE-helper') }
        it { is_expected.to contain_nftables__rule('default_in-ftp') }
        it { is_expected.to contain_nftables__rule('INPUT-ftp').with_content('ct helper "ftp" tcp dport 10090-10100 accept') }
      end

      context 'with passive_ports set' do
        let(:params) { { passive_ports: '12345-23456' } }

        it { is_expected.to contain_nftables__rule('INPUT-ftp').with_content('ct helper "ftp" tcp dport 12345-23456 accept') }
      end

      context 'with passive mode disabled' do
        let(:params) { { enable_passive: false } }

        it { is_expected.to contain_nftables__rule('INPUT-ftp').with_content('ct helper "ftp" accept') }
      end
    end
  end
end
