# frozen_string_literal: true

require 'spec_helper'

describe 'nftables::rules::out::whois' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'default options' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_nftables__rule('default_out-whois').with_content('tcp dport {43, 4321} accept comment "default_out-whois"') }
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_out-rule-whois') }
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_out-rule-whois_header') }
      end
    end
  end
end
