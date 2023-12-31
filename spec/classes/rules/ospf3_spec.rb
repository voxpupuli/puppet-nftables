# frozen_string_literal: true

require 'spec_helper'

describe 'nftables::rules::ospf3' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let :facts do
        os_facts
      end

      context 'default options' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_nftables__rule('default_in-ospf3').with_content('ip6 saddr fe80::/64 ip6 daddr { ff02::5, ff02::6 } meta l4proto 89 accept') }
      end

      context 'with input interfaces set' do
        let :params do
          {
            iifname: %w[docker0 eth0],
          }
        end

        it { is_expected.to compile }

        str = 'iifname { "docker0", "eth0" } ip6 saddr fe80::/64 ip6 daddr { ff02::5, ff02::6 } meta l4proto 89 accept'
        it { is_expected.to contain_nftables__rule('default_in-ospf3').with_content(str) }
      end
    end
  end
end
