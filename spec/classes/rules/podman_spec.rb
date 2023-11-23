# frozen_string_literal: true

require 'spec_helper'

describe 'nftables::rules::podman' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'default options' do
        it { is_expected.to compile }
        it { is_expected.to contain_nftables__rule('default_fwd-podman_establised').with_content('ip daddr 10.88.0.0/16 ct state related,established accept') }
        it { is_expected.to contain_nftables__rule('default_fwd-podman_accept').with_content('ip saddr 10.88.0.0/16 accept') }
      end
    end
  end
end
