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

      describe 'all parameters provided' do
        let(:title) { 'my_big_rule' }
        let(:params) do
          {
            action: 'accept',
            comment: 'this is my rule',
            dport: 333,
            proto: 'udp',
            chain: 'default_out',
          }
        end

        it { is_expected.to compile }
        it {
          is_expected.to contain_nftables__rule('default_out-my_big_rule').with(
            content: 'udp dport 333 comment "this is my rule" accept',
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
    end
  end
end
