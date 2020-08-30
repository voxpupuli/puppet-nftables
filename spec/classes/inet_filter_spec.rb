require 'spec_helper'

describe 'nftables' do
  let(:pre_condition) { 'Exec{path => "/bin"}' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      it { is_expected.to contain_file('/etc/nftables/puppet/inet-filter.nft').with(
        :ensure => 'file',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0640',
      )}

      context 'chain input' do
        it { is_expected.to contain_concat('nftables-inet-filter-chain-INPUT').with(
          :path           => '/etc/nftables/puppet/inet-filter-chain-INPUT.nft',
          :owner          => 'root',
          :group          => 'root',
          :mode           => '0640',
          :ensure_newline => true,
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-INPUT-header').with(
          :target  => 'nftables-inet-filter-chain-INPUT',
          :content => /^chain INPUT {$/,
          :order   => '00',
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-INPUT-rule-type').with(
          :target  => 'nftables-inet-filter-chain-INPUT',
          :content => /^  type filter hook input priority 0$/,
          :order   => '01',
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-INPUT-rule-policy').with(
          :target  => 'nftables-inet-filter-chain-INPUT',
          :content => /^  policy drop$/,
          :order   => '02',
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-INPUT-rule-lo').with(
          :target  => 'nftables-inet-filter-chain-INPUT',
          :content => /^  iifname lo accept$/,
          :order   => '03',
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-INPUT-rule-jump_global').with(
          :target  => 'nftables-inet-filter-chain-INPUT',
          :content => /^  jump global$/,
          :order   => '04',
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-INPUT-rule-jump_default_in').with(
          :target  => 'nftables-inet-filter-chain-INPUT',
          :content => /^  jump default_in$/,
          :order   => '10',
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-INPUT-rule-log_rejected').with(
          :target  => 'nftables-inet-filter-chain-INPUT',
          :content => /^  log prefix \"\[nftables\] INPUT Rejected: \" flags all counter reject with icmpx type port-unreachable$/,
          :order   => '98',
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-INPUT-footer').with(
          :target  => 'nftables-inet-filter-chain-INPUT',
          :content => /^}$/,
          :order   => '99',
        )}

        it { is_expected.to contain_concat('nftables-inet-filter-chain-default_in').with(
          :path           => '/etc/nftables/puppet/inet-filter-chain-default_in.nft',
          :owner          => 'root',
          :group          => 'root',
          :mode           => '0640',
          :ensure_newline => true,
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_in-header').with(
          :target  => 'nftables-inet-filter-chain-default_in',
          :content => /^chain default_in {$/,
          :order   => '00',
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_in-footer').with(
          :target  => 'nftables-inet-filter-chain-default_in',
          :content => /^}$/,
          :order   => '99',
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_in-rule-ssh').with(
          :target  => 'nftables-inet-filter-chain-default_in',
          :content => /^  tcp dport \{22\} accept$/,
          :order   => '50',
        )}
      end

      context 'chain output' do
        it { is_expected.to contain_concat('nftables-inet-filter-chain-OUTPUT').with(
          :path           => '/etc/nftables/puppet/inet-filter-chain-OUTPUT.nft',
          :owner          => 'root',
          :group          => 'root',
          :mode           => '0640',
          :ensure_newline => true,
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-OUTPUT-header').with(
          :target  => 'nftables-inet-filter-chain-OUTPUT',
          :content => /^chain OUTPUT {$/,
          :order   => '00',
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-OUTPUT-rule-type').with(
          :target  => 'nftables-inet-filter-chain-OUTPUT',
          :content => /^  type filter hook output priority 0$/,
          :order   => '01',
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-OUTPUT-rule-policy').with(
          :target  => 'nftables-inet-filter-chain-OUTPUT',
          :content => /^  policy drop$/,
          :order   => '02',
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-OUTPUT-rule-lo').with(
          :target  => 'nftables-inet-filter-chain-OUTPUT',
          :content => /^  oifname lo accept$/,
          :order   => '03',
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-OUTPUT-rule-jump_global').with(
          :target  => 'nftables-inet-filter-chain-OUTPUT',
          :content => /^  jump global$/,
          :order   => '04',
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-OUTPUT-rule-jump_default_out').with(
          :target  => 'nftables-inet-filter-chain-OUTPUT',
          :content => /^  jump default_out$/,
          :order   => '10',
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-OUTPUT-rule-log_rejected').with(
          :target  => 'nftables-inet-filter-chain-OUTPUT',
          :content => /^  log prefix \"\[nftables\] OUTPUT Rejected: \" flags all counter reject with icmpx type port-unreachable$/,
          :order   => '98',
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-OUTPUT-footer').with(
          :target  => 'nftables-inet-filter-chain-OUTPUT',
          :content => /^}$/,
          :order   => '99',
        )}

        it { is_expected.to contain_concat('nftables-inet-filter-chain-default_out').with(
          :path           => '/etc/nftables/puppet/inet-filter-chain-default_out.nft',
          :owner          => 'root',
          :group          => 'root',
          :mode           => '0640',
          :ensure_newline => true,
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_out-header').with(
          :target  => 'nftables-inet-filter-chain-default_out',
          :content => /^chain default_out {$/,
          :order   => '00',
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_out-footer').with(
          :target  => 'nftables-inet-filter-chain-default_out',
          :content => /^}$/,
          :order   => '99',
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_out-rule-dnsudp').with(
          :target  => 'nftables-inet-filter-chain-default_out',
          :content => /^  udp dport 53 accept$/,
          :order   => '50',
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_out-rule-dnstcp').with(
          :target  => 'nftables-inet-filter-chain-default_out',
          :content => /^  tcp dport 53 accept$/,
          :order   => '50',
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_out-rule-chrony').with(
          :target  => 'nftables-inet-filter-chain-default_out',
          :content => /^  udp dport 123 accept$/,
          :order   => '50',
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_out-rule-http').with(
          :target  => 'nftables-inet-filter-chain-default_out',
          :content => /^  tcp dport 80 accept$/,
          :order   => '50',
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_out-rule-https').with(
          :target  => 'nftables-inet-filter-chain-default_out',
          :content => /^  tcp dport 443 accept$/,
          :order   => '50',
        )}
      end

      context 'chain forward' do
        it { is_expected.to contain_concat('nftables-inet-filter-chain-FORWARD').with(
          :path           => '/etc/nftables/puppet/inet-filter-chain-FORWARD.nft',
          :owner          => 'root',
          :group          => 'root',
          :mode           => '0640',
          :ensure_newline => true,
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-FORWARD-header').with(
          :target  => 'nftables-inet-filter-chain-FORWARD',
          :content => /^chain FORWARD {$/,
          :order   => '00',
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-FORWARD-rule-type').with(
          :target  => 'nftables-inet-filter-chain-FORWARD',
          :content => /^  type filter hook forward priority 0$/,
          :order   => '01',
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-FORWARD-rule-policy').with(
          :target  => 'nftables-inet-filter-chain-FORWARD',
          :content => /^  policy drop$/,
          :order   => '02',
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-FORWARD-rule-jump_global').with(
          :target  => 'nftables-inet-filter-chain-FORWARD',
          :content => /^  jump global$/,
          :order   => '03',
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-FORWARD-rule-jump_default_fwd').with(
          :target  => 'nftables-inet-filter-chain-FORWARD',
          :content => /^  jump default_fwd$/,
          :order   => '10',
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-FORWARD-rule-log_rejected').with(
          :target  => 'nftables-inet-filter-chain-FORWARD',
          :content => /^  log prefix \"\[nftables\] FORWARD Rejected: \" flags all counter reject with icmpx type port-unreachable$/,
          :order   => '98',
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-FORWARD-footer').with(
          :target  => 'nftables-inet-filter-chain-FORWARD',
          :content => /^}$/,
          :order   => '99',
        )}

        it { is_expected.to contain_concat('nftables-inet-filter-chain-default_fwd').with(
          :path           => '/etc/nftables/puppet/inet-filter-chain-default_fwd.nft',
          :owner          => 'root',
          :group          => 'root',
          :mode           => '0640',
          :ensure_newline => true,
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_fwd-header').with(
          :target  => 'nftables-inet-filter-chain-default_fwd',
          :content => /^chain default_fwd {$/,
          :order   => '00',
        )}
        it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_fwd-footer').with(
          :target  => 'nftables-inet-filter-chain-default_fwd',
          :content => /^}$/,
          :order   => '99',
        )}
      end
    end
  end
end
