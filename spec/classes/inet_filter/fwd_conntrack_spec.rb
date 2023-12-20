# frozen_string_literal: true

require 'spec_helper'

describe 'nftables::inet_filter::fwd_conntrack' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let :pre_condition do
        'include nftables'
      end
      let :facts do
        os_facts
      end

      it { is_expected.to compile.with_all_deps }

      it {
        expect(subject).to contain_concat__fragment('nftables-inet-filter-chain-FORWARD-rule-accept_established_related').with(
          target: 'nftables-inet-filter-chain-FORWARD',
          content: %r{^  ct state established,related accept$},
          order: '05-nftables-inet-filter-chain-FORWARD-rule-accept_established_related-b'
        )
      }

      it { is_expected.not_to contain_concat__fragment('nftables-inet-filter-chain-FORWARD-rule-drop_invalid') }

      context 'with fwd_drop_invalid=true' do
        let :pre_condition do
          'class { "nftables": fwd_drop_invalid => true}'
        end

        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-FORWARD-rule-drop_invalid').with(
            target: 'nftables-inet-filter-chain-FORWARD',
            content: %r{^  ct state invalid drop$},
            order: '06-nftables-inet-filter-chain-FORWARD-rule-drop_invalid-b'
          )
        }
      end
    end
  end
end
