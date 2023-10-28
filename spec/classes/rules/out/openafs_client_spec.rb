# frozen_string_literal: true

require 'spec_helper'

describe 'nftables::rules::out::openafs_client' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'default options' do
        it { is_expected.to contain_nftables__rule('default_out-openafs_client').with_content('udp dport {7000, 7002, 7003} accept') }
      end

      context 'with ports set' do
        let(:params) do
          {
            ports: [7000, 7002],
          }
        end

        it { is_expected.to contain_nftables__rule('default_out-openafs_client').with_content('udp dport {7000, 7002} accept') }
      end
    end
  end
end
