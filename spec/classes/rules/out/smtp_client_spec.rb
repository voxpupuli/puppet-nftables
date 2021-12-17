# frozen_string_literal: true

require 'spec_helper'

describe 'nftables::rules::out::smtp_client' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'default options' do
        it { is_expected.to compile }
        it { is_expected.to contain_nftables__rule('default_out-smtp_client').with_content('tcp dport {465, 587} accept') }
      end
    end
  end
end
