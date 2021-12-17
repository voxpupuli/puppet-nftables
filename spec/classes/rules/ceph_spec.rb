# frozen_string_literal: true

require 'spec_helper'

describe 'nftables::rules::ceph' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'default options' do
        it { is_expected.to compile }
        it { is_expected.to contain_nftables__rule('default_in-ceph').with_content('tcp dport 6800-7300 accept comment "Accept Ceph OSD, MDS, MGR"') }
      end
    end
  end
end
