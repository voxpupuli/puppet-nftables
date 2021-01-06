require 'spec_helper'

describe 'nftables::rules::out::nfs3' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'default options' do
        it { is_expected.to compile }
        it { is_expected.to contain_nftables__rule('default_out-nfs3').with_content('meta l4proto { tcp, udp } th dport nfs accept comment "Accept NFS3"') }
      end
    end
  end
end
