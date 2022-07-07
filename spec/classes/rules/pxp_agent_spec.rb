# frozen_string_literal: true

require 'spec_helper'

describe 'nftables::rules::pxp_agent' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'default options' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_nftables__rule('default_in-pxp_agent').with_content('tcp dport {8142} accept') }
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_in-rule-pxp_agent') }
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_in-rule-pxp_agent_header') }
      end

      context 'with ports set' do
        let(:params) do
          {
            ports: [55, 60],
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_nftables__rule('default_in-pxp_agent').with_content('tcp dport {55, 60} accept') }
      end
    end
  end
end
