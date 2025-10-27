# frozen_string_literal: true

require 'spec_helper'

describe 'nftables::rules::mosh' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'default options' do
        it { is_expected.to compile }
        it { is_expected.to contain_nftables__rule('default_in-mosh').with_content('udp dport 60000-61000 accept') }
      end

      context 'with ports set' do
        let(:params) do
          {
            ports: '60000-60010',
          }
        end

        it { is_expected.to compile }
        it { is_expected.to contain_nftables__rule('default_in-mosh').with_content('udp dport 60000-60010 accept') }
      end
    end
  end
end
