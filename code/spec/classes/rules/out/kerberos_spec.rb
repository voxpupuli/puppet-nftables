require 'spec_helper'

describe 'nftables::rules::out::kerberos' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'default options' do
        it { is_expected.to compile }
        it { is_expected.to contain_nftables__rule('default_out-kerberos_udp').with_content('udp dport 88 accept') }
        it { is_expected.to contain_nftables__rule('default_out-kerberos_tcp').with_content('tcp dport 88 accept') }
      end
    end
  end
end
