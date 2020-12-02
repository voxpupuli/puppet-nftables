require 'spec_helper'

describe 'nftables::rules::ceph_mon' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'default options' do
        it { is_expected.to compile }
        it { is_expected.to contain_nftables__rule('default_in-ceph_mon').with_content('tcp dport {3300, 6789} accept comment "Accept Ceph MON"') }
      end

      context 'with ports set' do
        let(:params) do
          {
            ports: [3300, 6790],
          }
        end

        it { is_expected.to compile }
        it { is_expected.to contain_nftables__rule('default_in-ceph_mon').with_content('tcp dport {3300, 6790} accept comment "Accept Ceph MON"') }
      end
    end
  end
end
