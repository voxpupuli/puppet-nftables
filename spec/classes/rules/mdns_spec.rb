# frozen_string_literal: true

require 'spec_helper'

describe 'nftables::rules::mdns' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let :facts do
        os_facts
      end

      context 'default options' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_nftables__rule('default_in-mdns_v4').with_content('ip daddr 224.0.0.251 udp dport 5353 accept') }
        it { is_expected.to contain_nftables__rule('default_in-mdns_v6').with_content('ip6 daddr ff02::fb udp dport 5353 accept') }
      end

      context 'with input interfaces set' do
        let :params do
          {
            iifname: %w[docker0 eth0],
          }
        end

        it { is_expected.to compile }
        it { is_expected.to contain_nftables__rule('default_in-mdns_v4').with_content('iifname { "docker0", "eth0" } ip daddr 224.0.0.251 udp dport 5353 accept') }
        it { is_expected.to contain_nftables__rule('default_in-mdns_v6').with_content('iifname { "docker0", "eth0" } ip6 daddr ff02::fb udp dport 5353 accept') }
      end
    end
  end
end
