require 'spec_helper'

describe 'nftables' do
  let(:pre_condition) { 'Exec{path => "/bin"}' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      it {
        is_expected.to contain_concat('nftables-inet-filter-chain-default_fwd').with(
          path:           '/etc/nftables/puppet-preflight/inet-filter-chain-default_fwd.nft',
          owner:          'root',
          group:          'root',
          mode:           '0640',
          ensure_newline: true,
        )
      }
      it {
        is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_fwd-header').with(
          target:  'nftables-inet-filter-chain-default_fwd',
          content: %r{^chain default_fwd \{$},
          order:   '00',
        )
      }
      it {
        is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_fwd-rule-bridge_br0_br0').with(
          target:  'nftables-inet-filter-chain-default_fwd',
          content: %r{^  iifname br0 oifname br0 accept$},
          order:   '08-nftables-inet-filter-chain-default_fwd-rule-bridge_br0_br0-b',
        )
      }
      it {
        is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_fwd-rule-bridge_br1_br1').with(
          target:  'nftables-inet-filter-chain-default_fwd',
          content: %r{^  iifname br1 oifname br1 accept$},
          order:   '08-nftables-inet-filter-chain-default_fwd-rule-bridge_br1_br1-b',
        )
      }
      it { is_expected.not_to contain_concat__fragment('nftables-inet-filter-chain-default_fwd-bridge_br0_br1') }
      it { is_expected.not_to contain_concat__fragment('nftables-inet-filter-chain-default_fwd-bridge_br1_br0') }
      it {
        is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_fwd-footer').with(
          target:  'nftables-inet-filter-chain-default_fwd',
          content: %r{^\}$},
          order:   '99',
        )
      }
    end
  end
end
