# frozen_string_literal: true

require 'spec_helper'

describe 'nftables::inet_filter::in_out_conntrack' do
  let(:pre_condition) { 'Exec{path => "/bin"}' }

  on_supported_os.each do |os, _os_facts|
    context "on #{os}" do
      it {
        expect(subject).to contain_concat__fragment('nftables-inet-filter-chain-INPUT-rule-accept_established_related').with(
          target: 'nftables-inet-filter-chain-INPUT',
          content: %r{^  ct state established,related accept$},
          order: '05-nftables-inet-filter-chain-INPUT-rule-accept_established_related-b'
        )
      }

      it {
        expect(subject).to contain_concat__fragment('nftables-inet-filter-chain-INPUT-rule-drop_invalid').with(
          target: 'nftables-inet-filter-chain-INPUT',
          content: %r{^  ct state invalid drop$},
          order: '06-nftables-inet-filter-chain-INPUT-rule-drop_invalid-b'
        )
      }

      it {
        expect(subject).to contain_concat__fragment('nftables-inet-filter-chain-OUTPUT-rule-accept_established_related').with(
          target: 'nftables-inet-filter-chain-OUTPUT',
          content: %r{^  ct state established,related accept$},
          order: '05-nftables-inet-filter-chain-OUTPUT-rule-accept_established_related-b'
        )
      }

      it {
        expect(subject).to contain_concat__fragment('nftables-inet-filter-chain-OUTPUT-rule-drop_invalid').with(
          target: 'nftables-inet-filter-chain-OUTPUT',
          content: %r{^  ct state invalid drop$},
          order: '06-nftables-inet-filter-chain-OUTPUT-rule-drop_invalid-b'
        )
      }
    end
  end
end
