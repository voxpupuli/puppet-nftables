# frozen_string_literal: true

require 'spec_helper'

describe 'nftables::rules::out::pop3' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'default options' do
        it { is_expected.to compile }
        it { is_expected.to contain_nftables__rule('default_out-pop3').with_content('tcp dport {110, 995} accept') }
      end
    end
  end
end
