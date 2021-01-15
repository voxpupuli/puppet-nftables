require 'spec_helper'

describe 'nftables::rules::out::imap' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'default options' do
        it { is_expected.to compile }
        it { is_expected.to contain_nftables__rule('default_out-imap').with_content('tcp dport {143, 993} accept') }
      end
    end
  end
end
