# frozen_string_literal: true

require 'spec_helper'

describe 'nftables::rules::out::ceph_client' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'default options' do
        it { is_expected.to compile }
        it { is_expected.to contain_nftables__rule('default_out-ceph_client').with_content('tcp dport { 3300, 6789, 6800-7300 } accept comment "Accept Ceph MON, OSD, MDS, MGR"') }
      end

      context 'with ports set' do
        let(:params) do
          {
            ports: [3300, 6790],
          }
        end

        it { is_expected.to compile }
        it { is_expected.to contain_nftables__rule('default_out-ceph_client').with_content('tcp dport { 3300, 6790, 6800-7300 } accept comment "Accept Ceph MON, OSD, MDS, MGR"') }
      end
    end
  end
end
