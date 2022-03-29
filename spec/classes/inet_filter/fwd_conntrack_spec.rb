# frozen_string_literal: true

require 'spec_helper'

describe 'nftables::inet_filter::fwd_conntrack' do
  on_supported_os.each do |os, _os_facts|
    context "on #{os}" do
      it {
        expect(subject).to contain_concat__fragment('nftables-inet-filter-chain-FORWARD-rule-accept_established_related').with(
          target: 'nftables-inet-filter-chain-FORWARD',
          content: %r{^  ct state established,related accept$},
          order: '05-nftables-inet-filter-chain-FORWARD-rule-accept_established_related-b'
        )
      }

      it {
        expect(subject).to contain_concat__fragment('nftables-inet-filter-chain-FORWARD-rule-drop_invalid').with(
          target: 'nftables-inet-filter-chain-FORWARD',
          content: %r{^  ct state invalid drop$},
          order: '06-nftables-inet-filter-chain-FORWARD-rule-drop_invalid-b'
        )
      }
    end
  end
end
