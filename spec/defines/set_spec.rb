# frozen_string_literal: true

require 'spec_helper'

describe 'nftables::set' do
  let(:pre_condition) { 'include nftables' }

  let(:title) { 'my_set' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      describe 'minimum instantiation' do
        let(:params) do
          {
            type: 'ipv4_addr',
          }
        end

        it {
          expect(subject).to contain_concat__fragment('nftables-inet-filter-set-my_set').with(
            target: 'nftables-inet-filter',
            content: %r{^  set my_set \{\n    type ipv4_addr\n  \}$}m,
            order: '10'
          )
        }
      end

      describe 'max size exceeding the prepopulated elements' do
        let(:params) do
          {
            type: 'ipv6_addr',
            elements: ['2001:1458::/32', '2001:1458:1::/48'],
            size: 1,
          }
        end

        it { is_expected.not_to compile }
      end

      describe 'invalid type' do
        let(:params) do
          {
            type: 'foo',
          }
        end

        it { is_expected.not_to compile }
      end

      describe 'invalid flags' do
        let(:params) do
          {
            type: 'ipv4_addr',
            flags: ['foo'],
          }
        end

        it { is_expected.not_to compile }
      end

      describe 'ipv6 prepopulated' do
        let(:params) do
          {
            type: 'ipv6_addr',
            elements: ['2001:1458::/32', '2001:1458:1::/48'],
          }
        end

        it {
          expect(subject).to contain_concat__fragment('nftables-inet-filter-set-my_set').with(
            target: 'nftables-inet-filter',
            content: %r{^  set my_set \{\n    type ipv6_addr\n    elements = \{ 2001:1458::/32, 2001:1458:1::/48 \}\n  \}$}m,
            order: '10'
          )
        }
      end

      describe 'using flags and auto-merge' do
        let(:params) do
          {
            type: 'ipv4_addr',
            flags: %w[interval timeout],
            elements: ['192.168.0.1/24'],
            auto_merge: true,
          }
        end

        it {
          expect(subject).to contain_concat__fragment('nftables-inet-filter-set-my_set').with(
            target: 'nftables-inet-filter',
            content: %r{^  set my_set \{\n    type ipv4_addr\n    flags interval, timeout\n    elements = \{ 192.168.0.1/24 \}\n    auto-merge\n  \}$}m,
            order: '10'
          )
        }
      end

      describe 'using ether_addr as type and custom policy' do
        let(:params) do
          {
            type: 'ether_addr',
            elements: ['aa:bb:cc:dd:ee:ff'],
            policy: 'memory',
          }
        end

        it {
          expect(subject).to contain_concat__fragment('nftables-inet-filter-set-my_set').with(
            target: 'nftables-inet-filter',
            content: %r{^  set my_set \{\n    type ether_addr\n    elements = \{ aa:bb:cc:dd:ee:ff \}\n    policy memory\n  \}$}m,
            order: '10'
          )
        }
      end

      describe 'using raw content' do
        let(:params) do
          {
            content: 'set my_set { }',
          }
        end

        it {
          expect(subject).to contain_concat__fragment('nftables-inet-filter-set-my_set').with(
            target: 'nftables-inet-filter',
            content: '  set my_set { }',
            order: '10'
          )
        }
      end

      describe 'fails without a type and not source/content' do
        it { is_expected.not_to compile }
      end

      describe 'set names with dashes are allowed' do
        let(:title) { 'my-set' }
        let(:params) do
          {
            type: 'ether_addr',
          }
        end

        it {
          expect(subject).to contain_concat__fragment('nftables-inet-filter-set-my-set').with(
            target: 'nftables-inet-filter',
            content: %r{^  set my-set \{\n    type ether_addr\n  \}$}m,
            order: '10'
          )
        }
      end

      describe 'default table can be changed' do
        let(:params) do
          {
            type: 'ipv6_addr',
            elements: ['2001:1458::1', '2001:1458:1::2'],
            table: 'ip-nat'
          }
        end

        it {
          expect(subject).to contain_concat__fragment('nftables-ip-nat-set-my_set').with(
            target: 'nftables-ip-nat',
            content: %r{^  set my_set \{\n    type ipv6_addr\n    elements = \{ 2001:1458::1, 2001:1458:1::2 \}\n  \}$}m,
            order: '10'
          )
        }
      end

      describe 'multiple tables no tables' do
        let(:params) do
          {
            type: 'ipv6_addr',
            elements: ['2001:1458::1', '2001:1458:1::2'],
            table: []
          }
        end

        it { is_expected.not_to compile }
      end

      describe 'multiple tables' do
        let(:params) do
          {
            type: 'ipv6_addr',
            elements: ['2001:1458::1', '2001:1458:1::2'],
            table: %w[inet-filter ip-nat]
          }
        end

        it {
          expect(subject).to contain_concat__fragment('nftables-inet-filter-set-my_set').with(
            target: 'nftables-inet-filter',
            content: %r{^  set my_set \{\n    type ipv6_addr\n    elements = \{ 2001:1458::1, 2001:1458:1::2 \}\n  \}$}m,
            order: '10'
          )
          expect(subject).to contain_concat__fragment('nftables-ip-nat-set-my_set').with(
            target: 'nftables-ip-nat',
            content: %r{^  set my_set \{\n    type ipv6_addr\n    elements = \{ 2001:1458::1, 2001:1458:1::2 \}\n  \}$}m,
            order: '10'
          )
        }
      end
    end
  end
end
