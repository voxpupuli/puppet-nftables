# frozen_string_literal: true

require 'spec_helper'

describe 'nftables::rules::llmnr' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let :facts do
        os_facts
      end

      context 'default options' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_nftables__rule('default_in-llmnr_v4').with_content('ip daddr 224.0.0.252 udp dport 5355 accept comment "allow LLMNR"') }
        it { is_expected.to contain_nftables__rule('default_in-llmnr_v6').with_content('ip6 daddr ff02::1:3 udp dport 5355 accept comment "allow LLMNR"') }
      end

      context 'with input interfaces set' do
        let :params do
          {
            iifname: %w[docker0 eth0],
          }
        end

        it { is_expected.to compile }
        it { is_expected.to contain_nftables__rule('default_in-llmnr_v4').with_content('iifname { "docker0", "eth0" } ip daddr 224.0.0.252 udp dport 5355 accept comment "allow LLMNR"') }
        it { is_expected.to contain_nftables__rule('default_in-llmnr_v6').with_content('iifname { "docker0", "eth0" } ip6 daddr ff02::1:3 udp dport 5355 accept comment "allow LLMNR"') }
      end
    end
  end
end
