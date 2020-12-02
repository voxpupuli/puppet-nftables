require 'spec_helper'

describe 'nftables::rules::nfs' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'default options' do
        it { is_expected.to compile }
        it { is_expected.to contain_nftables__rule('default_in-nfs4').with_content('tcp dport nfs accept comment "Accept NFS4"') }
      end
    end
  end
end
