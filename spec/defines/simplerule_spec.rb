# frozen_string_literal: true

require 'spec_helper'

describe 'nftables::simplerule' do
  let(:pre_condition) { 'include nftables' }

  let(:title) { 'my_default_rule_name' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      describe 'minimum instantiation' do
        it {
          expect(subject).to contain_nftables__rule('default_in-my_default_rule_name').with(
            content: 'accept',
            order: '50'
          )
        }
      end

      describe 'dport without protocol' do
        let(:params) do
          {
            dport: 333,
          }
        end

        it { is_expected.not_to compile }
      end

      describe 'sport without protocol' do
        let(:params) do
          {
            sport: 333,
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
            sport: 444,
            proto: 'udp',
            chain: 'default_out',
            daddr: '2001:1458::/32',
            saddr: '2001:145c::/32',
          }
        end

        it {
          expect(subject).to contain_nftables__rule('default_out-my_big_rule').with(
            content: 'udp sport {444} udp dport {333} ip6 saddr 2001:145c::/32 ip6 daddr 2001:1458::/32 counter accept comment "this is my rule"',
            order: '50'
          )
        }
      end

      describe 'port range' do
        let(:params) do
          {
            dport: '333-334',
            sport: '1-2',
            proto: 'tcp',
          }
        end

        it {
          expect(subject).to contain_nftables__rule('default_in-my_default_rule_name').with(
            content: 'tcp sport {1-2} tcp dport {333-334} accept'
          )
        }
      end

      describe 'port array' do
        let(:params) do
          {
            dport: [333, 335],
            sport: [433, 435],
            proto: 'tcp',
          }
        end

        it {
          expect(subject).to contain_nftables__rule('default_in-my_default_rule_name').with(
            content: 'tcp sport {433, 435} tcp dport {333, 335} accept'
          )
        }
      end

      describe 'only sport TCP traffic' do
        let(:params) do
          {
            sport: 555,
            proto: 'tcp',
          }
        end

        it {
          expect(subject).to contain_nftables__rule('default_in-my_default_rule_name').with(
            content: 'tcp sport {555} accept'
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

        it {
          expect(subject).to contain_nftables__rule('default_in-my_default_rule_name').with(
            content: 'ip version 4 tcp dport {333} accept'
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

        it {
          expect(subject).to contain_nftables__rule('default_in-my_default_rule_name').with(
            content: 'ip6 version 6 udp dport {33} accept'
          )
        }
      end

      describe 'only IPv6 TCP traffic' do
        let(:params) do
          {
            dport: 35,
            proto: 'tcp6',
          }
        end

        it {
          expect(subject).to contain_nftables__rule('default_in-my_default_rule_name').with(
            content: 'ip6 version 6 tcp dport {35} accept'
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

        it {
          expect(subject).to contain_nftables__rule('default_in-my_default_rule_name').with(
            content: 'tcp dport {33} ip daddr 192.168.0.1/24 accept'
          )
        }
      end

      describe 'with an IPv6 address as daddr' do
        let(:params) do
          {
            daddr: '2001:1458::1',
          }
        end

        it {
          expect(subject).to contain_nftables__rule('default_in-my_default_rule_name').with(
            content: 'ip6 daddr 2001:1458::1 accept'
          )
        }
      end

      describe 'with an IPv6 address as saddr' do
        let(:params) do
          {
            saddr: '2001:1458:0000:0000:0000:0000:0000:0003',
          }
        end

        it {
          expect(subject).to contain_nftables__rule('default_in-my_default_rule_name').with(
            content: 'ip6 saddr 2001:1458:0000:0000:0000:0000:0000:0003 accept'
          )
        }
      end

      describe 'with an IPv4 address as saddr' do
        let(:params) do
          {
            saddr: '172.16.1.5',
          }
        end

        it {
          expect(subject).to contain_nftables__rule('default_in-my_default_rule_name').with(
            content: 'ip saddr 172.16.1.5 accept'
          )
        }
      end

      describe 'with an IPv6 set as daddr, default set_type' do
        let(:params) do
          {
            daddr: '@my6_set',
          }
        end

        it {
          expect(subject).to contain_nftables__rule('default_in-my_default_rule_name').with(
            content: 'ip6 daddr @my6_set accept'
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

        it {
          expect(subject).to contain_nftables__rule('default_in-my_default_rule_name').with(
            content: 'ip daddr @my4_set accept'
          )
        }
      end

      describe 'with a IPv6 set as saddr' do
        let(:params) do
          {
            saddr: '@my6_set',
            set_type: 'ip6',
          }
        end

        it {
          expect(subject).to contain_nftables__rule('default_in-my_default_rule_name').with(
            content: 'ip6 saddr @my6_set accept'
          )
        }
      end

      describe 'with counter enabled' do
        let(:params) do
          {
            counter: true,
          }
        end

        it {
          expect(subject).to contain_nftables__rule('default_in-my_default_rule_name').with(
            content: 'counter accept'
          )
        }
      end

      describe 'counter and continue sport' do
        let(:params) do
          {
            proto: 'tcp',
            sport: 80,
            counter: true,
            action: 'continue',
          }
        end

        it {
          expect(subject).to contain_nftables__rule('default_in-my_default_rule_name').with(
            content: 'tcp sport {80} counter continue'
          )
        }
      end
    end
  end
end
