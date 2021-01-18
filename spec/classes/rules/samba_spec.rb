require 'spec_helper'

describe 'nftables::rules::samba' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'default options' do
        it { is_expected.to compile }
        it { is_expected.to contain_nftables__rule('default_in-netbios_tcp').with_content('tcp dport {139,445} accept') }
        it { is_expected.to contain_nftables__rule('default_in-netbios_udp').with_content('udp dport {137,138} accept') }
      end
    end
  end
end
