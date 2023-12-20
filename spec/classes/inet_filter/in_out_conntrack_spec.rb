# frozen_string_literal: true

require 'spec_helper'

describe 'nftables::inet_filter::in_out_conntrack' do
  on_supported_os.each do |os, os_facts|
    let :pre_condition do
      'include nftables'
    end
    context "on #{os}" do
      let :facts do
        os_facts
      end

      it { is_expected.to compile.with_all_deps }

      it {
        expect(subject).to contain_concat__fragment('nftables-inet-filter-chain-INPUT-rule-accept_established_related').with(
          target: 'nftables-inet-filter-chain-INPUT',
          content: %r{^  ct state established,related accept$},
          order: '05-nftables-inet-filter-chain-INPUT-rule-accept_established_related-b'
        )
      }

      it {
        expect(subject).to contain_concat__fragment('nftables-inet-filter-chain-OUTPUT-rule-accept_established_related').with(
          target: 'nftables-inet-filter-chain-OUTPUT',
          content: %r{^  ct state established,related accept$},
          order: '05-nftables-inet-filter-chain-OUTPUT-rule-accept_established_related-b'
        )
      }

      it { is_expected.not_to contain_concat__fragment('nftables-inet-filter-chain-OUTPUT-rule-drop_invalid') }
      it { is_expected.not_to contain_concat__fragment('nftables-inet-filter-chain-INPUT-rule-drop_invalid') }

      context 'with in_out_drop_invalid=true' do
        let :pre_condition do
          'class { "nftables": in_out_drop_invalid => true}'
        end

        it {
          expect(subject).to contain_concat__fragment('nftables-inet-filter-chain-INPUT-rule-drop_invalid').with(
            target: 'nftables-inet-filter-chain-INPUT',
            content: %r{^  ct state invalid drop$},
            order: '06-nftables-inet-filter-chain-INPUT-rule-drop_invalid-b'
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
end
