require 'spec_helper'

describe 'nftables::simplerule' do
  let(:pre_condition) { 'include nftables' }

  let(:title) { 'my_default_rule_name' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      describe 'minimum instantiation' do
        it { is_expected.to compile }
        it {
          is_expected.to contain_nftables__rule('default_in-my_default_rule_name').with(
            content: 'accept',
            order: '50',
          )
        }
      end

      describe 'port without protocol' do
        let(:params) do
          {
            dport: 333,
          }
        end

        it { is_expected.not_to compile }
      end

      describe 'all parameters provided' do
        let(:title) { 'my_big_rule' }
        let(:params) do
          {
            action: 'accept',
            comment: 'this is my rule',
            counter: true,
            dport: 333,
            proto: 'udp',
            chain: 'default_out',
            daddr: '2001:1458::/32',
          }
        end

        it { is_expected.to compile }
        it {
          is_expected.to contain_nftables__rule('default_out-my_big_rule').with(
            content: 'udp dport 333 ip6 daddr 2001:1458::/32 counter accept comment "this is my rule"',
            order: '50',
          )
        }
      end

      describe 'port range' do
        let(:params) do
          {
            dport: '333-334',
            proto: 'tcp',
          }
        end

        it { is_expected.to compile }
        it {
          is_expected.to contain_nftables__rule('default_in-my_default_rule_name').with(
            content: 'tcp dport 333-334 accept',
          )
        }
      end

      describe 'port array' do
        let(:params) do
          {
            dport: [333, 335],
            proto: 'tcp',
          }
        end

        it { is_expected.to compile }
        it {
          is_expected.to contain_nftables__rule('default_in-my_default_rule_name').with(
            content: 'tcp dport {333, 335} accept',
          )
        }
      end

      describe 'only IPv4 TCP traffic' do
        let(:params) do
          {
            dport: 333,
            proto: 'tcp4',
          }
        end

        it { is_expected.to compile }
        it {
          is_expected.to contain_nftables__rule('default_in-my_default_rule_name').with(
            content: 'ip version 4 tcp dport 333 accept',
          )
        }
      end

      describe 'only IPv6 UDP traffic' do
        let(:params) do
          {
            dport: 33,
            proto: 'udp6',
          }
        end

        it { is_expected.to compile }
        it {
          is_expected.to contain_nftables__rule('default_in-my_default_rule_name').with(
            content: 'ip version 6 udp dport 33 accept',
          )
        }
      end

      describe 'with an IPv4 CIDR as daddr' do
        let(:params) do
          {
            daddr: '192.168.0.1/24',
            dport: 33,
            proto: 'tcp',
          }
        end

        it { is_expected.to compile }
        it {
          is_expected.to contain_nftables__rule('default_in-my_default_rule_name').with(
            content: 'tcp dport 33 ip daddr 192.168.0.1/24 accept',
          )
        }
      end

      describe 'with an IPv6 address as daddr' do
        let(:params) do
          {
            daddr: '2001:1458::1',
          }
        end

        it { is_expected.to compile }
        it {
          is_expected.to contain_nftables__rule('default_in-my_default_rule_name').with(
            content: 'ip6 daddr 2001:1458::1 accept',
          )
        }
      end

      describe 'with an IPv6 set as daddr, default set_type' do
        let(:params) do
          {
            daddr: '@my6_set',
          }
        end

        it { is_expected.to compile }
        it {
          is_expected.to contain_nftables__rule('default_in-my_default_rule_name').with(
            content: 'ip6 daddr @my6_set accept',
          )
        }
      end

      describe 'with a IPv4 set as daddr' do
        let(:params) do
          {
            daddr: '@my4_set',
            set_type: 'ip',
          }
        end

        it { is_expected.to compile }
        it {
          is_expected.to contain_nftables__rule('default_in-my_default_rule_name').with(
            content: 'ip daddr @my4_set accept',
          )
        }
      end

      describe 'with counter enabled' do
        let(:params) do
          {
            counter: true,
          }
        end

        it { is_expected.to compile }
        it {
          is_expected.to contain_nftables__rule('default_in-my_default_rule_name').with(
            content: 'counter accept',
          )
        }
      end
    end
  end
end
