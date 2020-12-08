require 'spec_helper'

describe 'nftables' do
  let(:pre_condition) { 'Exec{path => "/bin"}' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      it {
        is_expected.to contain_concat('nftables-inet-filter').with(
          path:   '/etc/nftables/puppet-preflight/inet-filter.nft',
          ensure: 'present',
          owner:  'root',
          group:  'root',
          mode:   '0640'
        )
      }

      it {
        is_expected.to contain_concat__fragment('nftables-inet-filter-header').with(
          target:  'nftables-inet-filter',
          content: %r{^table inet filter \{$},
          order:   '00'
        )
      }

      it {
        is_expected.to contain_concat__fragment('nftables-inet-filter-body').with(
          target:  'nftables-inet-filter',
          order:   '98'
        )
      }

      it {
        is_expected.to contain_concat__fragment('nftables-inet-filter-footer').with(
          target:  'nftables-inet-filter',
          content: %r{^\}$},
          order:   '99'
        )
      }

      context 'chain input' do
        it {
          is_expected.to contain_concat('nftables-inet-filter-chain-INPUT').with(
            path:           '/etc/nftables/puppet-preflight/inet-filter-chain-INPUT.nft',
            owner:          'root',
            group:          'root',
            mode:           '0640',
            ensure_newline: true
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-INPUT-header').with(
            target:  'nftables-inet-filter-chain-INPUT',
            content: %r{^chain INPUT \{$},
            order:   '00'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-INPUT-rule-type').with(
            target:  'nftables-inet-filter-chain-INPUT',
            content: %r{^  type filter hook input priority 0$},
            order:   '01-nftables-inet-filter-chain-INPUT-rule-type-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-INPUT-rule-policy').with(
            target:  'nftables-inet-filter-chain-INPUT',
            content: %r{^  policy drop$},
            order:   '02-nftables-inet-filter-chain-INPUT-rule-policy-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-INPUT-rule-lo').with(
            target:  'nftables-inet-filter-chain-INPUT',
            content: %r{^  iifname lo accept$},
            order:   '03-nftables-inet-filter-chain-INPUT-rule-lo-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-INPUT-rule-jump_global').with(
            target:  'nftables-inet-filter-chain-INPUT',
            content: %r{^  jump global$},
            order:   '04-nftables-inet-filter-chain-INPUT-rule-jump_global-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-INPUT-rule-accept_established_related').with(
            target:  'nftables-inet-filter-chain-INPUT',
            content: %r{^  ct state established,related accept$},
            order:   '05-nftables-inet-filter-chain-INPUT-rule-accept_established_related-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-INPUT-rule-drop_invalid').with(
            target:  'nftables-inet-filter-chain-INPUT',
            content: %r{^  ct state invalid drop$},
            order:   '06-nftables-inet-filter-chain-INPUT-rule-drop_invalid-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-INPUT-rule-jump_default_in').with(
            target:  'nftables-inet-filter-chain-INPUT',
            content: %r{^  jump default_in$},
            order:   '10-nftables-inet-filter-chain-INPUT-rule-jump_default_in-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-INPUT-rule-log_discarded').with(
            target:  'nftables-inet-filter-chain-INPUT',
            content: %r{^  limit rate 3/minute burst 5 packets log prefix \"\[nftables\] INPUT Rejected: \" flags all counter$},
            order:   '97-nftables-inet-filter-chain-INPUT-rule-log_discarded-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-INPUT-rule-reject').with(
            target:  'nftables-inet-filter-chain-INPUT',
            content: %r{^  reject with icmpx type port-unreachable$},
            order:   '98-nftables-inet-filter-chain-INPUT-rule-reject-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-INPUT-footer').with(
            target:  'nftables-inet-filter-chain-INPUT',
            content: %r{^\}$},
            order:   '99'
          )
        }

        it {
          is_expected.to contain_concat('nftables-inet-filter-chain-default_in').with(
            path:           '/etc/nftables/puppet-preflight/inet-filter-chain-default_in.nft',
            owner:          'root',
            group:          'root',
            mode:           '0640',
            ensure_newline: true
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_in-header').with(
            target:  'nftables-inet-filter-chain-default_in',
            content: %r{^chain default_in \{$},
            order:   '00'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_in-footer').with(
            target:  'nftables-inet-filter-chain-default_in',
            content: %r{^\}$},
            order:   '99'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_in-rule-ssh').with(
            target:  'nftables-inet-filter-chain-default_in',
            content: %r{^  tcp dport \{22\} accept$},
            order:   '50-nftables-inet-filter-chain-default_in-rule-ssh-b'
          )
        }
        it {
          is_expected.to contain_class('nftables::rules::icmp')
        }
      end

      context 'chain output' do
        it {
          is_expected.to contain_concat('nftables-inet-filter-chain-OUTPUT').with(
            path:           '/etc/nftables/puppet-preflight/inet-filter-chain-OUTPUT.nft',
            owner:          'root',
            group:          'root',
            mode:           '0640',
            ensure_newline: true
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-OUTPUT-header').with(
            target:  'nftables-inet-filter-chain-OUTPUT',
            content: %r{^chain OUTPUT \{$},
            order:   '00'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-OUTPUT-rule-type').with(
            target:  'nftables-inet-filter-chain-OUTPUT',
            content: %r{^  type filter hook output priority 0$},
            order:   '01-nftables-inet-filter-chain-OUTPUT-rule-type-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-OUTPUT-rule-policy').with(
            target:  'nftables-inet-filter-chain-OUTPUT',
            content: %r{^  policy drop$},
            order:   '02-nftables-inet-filter-chain-OUTPUT-rule-policy-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-OUTPUT-rule-lo').with(
            target:  'nftables-inet-filter-chain-OUTPUT',
            content: %r{^  oifname lo accept$},
            order:   '03-nftables-inet-filter-chain-OUTPUT-rule-lo-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-OUTPUT-rule-jump_global').with(
            target:  'nftables-inet-filter-chain-OUTPUT',
            content: %r{^  jump global$},
            order:   '04-nftables-inet-filter-chain-OUTPUT-rule-jump_global-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-OUTPUT-rule-accept_established_related').with(
            target:  'nftables-inet-filter-chain-OUTPUT',
            content: %r{^  ct state established,related accept$},
            order:   '05-nftables-inet-filter-chain-OUTPUT-rule-accept_established_related-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-OUTPUT-rule-drop_invalid').with(
            target:  'nftables-inet-filter-chain-OUTPUT',
            content: %r{^  ct state invalid drop$},
            order:   '06-nftables-inet-filter-chain-OUTPUT-rule-drop_invalid-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-OUTPUT-rule-jump_default_out').with(
            target:  'nftables-inet-filter-chain-OUTPUT',
            content: %r{^  jump default_out$},
            order:   '10-nftables-inet-filter-chain-OUTPUT-rule-jump_default_out-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-OUTPUT-rule-log_discarded').with(
            target:  'nftables-inet-filter-chain-OUTPUT',
            content: %r{^  limit rate 3/minute burst 5 packets log prefix \"\[nftables\] OUTPUT Rejected: \" flags all counter$},
            order:   '97-nftables-inet-filter-chain-OUTPUT-rule-log_discarded-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-OUTPUT-rule-reject').with(
            target:  'nftables-inet-filter-chain-OUTPUT',
            content: %r{^  reject with icmpx type port-unreachable$},
            order:   '98-nftables-inet-filter-chain-OUTPUT-rule-reject-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-OUTPUT-footer').with(
            target:  'nftables-inet-filter-chain-OUTPUT',
            content: %r{^\}$},
            order:   '99'
          )
        }

        it {
          is_expected.to contain_concat('nftables-inet-filter-chain-default_out').with(
            path:           '/etc/nftables/puppet-preflight/inet-filter-chain-default_out.nft',
            owner:          'root',
            group:          'root',
            mode:           '0640',
            ensure_newline: true
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_out-header').with(
            target:  'nftables-inet-filter-chain-default_out',
            content: %r{^chain default_out \{$},
            order:   '00'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_out-footer').with(
            target:  'nftables-inet-filter-chain-default_out',
            content: %r{^\}$},
            order:   '99'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_out-rule-dnsudp').with(
            target:  'nftables-inet-filter-chain-default_out',
            content: %r{^  udp dport 53 accept$},
            order:   '50-nftables-inet-filter-chain-default_out-rule-dnsudp-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_out-rule-dnstcp').with(
            target:  'nftables-inet-filter-chain-default_out',
            content: %r{^  tcp dport 53 accept$},
            order:   '50-nftables-inet-filter-chain-default_out-rule-dnstcp-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_out-rule-chrony').with(
            target:  'nftables-inet-filter-chain-default_out',
            content: %r{^  udp dport 123 accept$},
            order:   '50-nftables-inet-filter-chain-default_out-rule-chrony-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_out-rule-http').with(
            target:  'nftables-inet-filter-chain-default_out',
            content: %r{^  tcp dport 80 accept$},
            order:   '50-nftables-inet-filter-chain-default_out-rule-http-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_out-rule-https').with(
            target:  'nftables-inet-filter-chain-default_out',
            content: %r{^  tcp dport 443 accept$},
            order:   '50-nftables-inet-filter-chain-default_out-rule-https-b'
          )
        }
        it {
          is_expected.to contain_class('nftables::rules::out::icmp')
        }
      end

      context 'chain forward' do
        it {
          is_expected.to contain_concat('nftables-inet-filter-chain-FORWARD').with(
            path:           '/etc/nftables/puppet-preflight/inet-filter-chain-FORWARD.nft',
            owner:          'root',
            group:          'root',
            mode:           '0640',
            ensure_newline: true
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-FORWARD-header').with(
            target:  'nftables-inet-filter-chain-FORWARD',
            content: %r{^chain FORWARD \{$},
            order:   '00'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-FORWARD-rule-type').with(
            target:  'nftables-inet-filter-chain-FORWARD',
            content: %r{^  type filter hook forward priority 0$},
            order:   '01-nftables-inet-filter-chain-FORWARD-rule-type-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-FORWARD-rule-policy').with(
            target:  'nftables-inet-filter-chain-FORWARD',
            content: %r{^  policy drop$},
            order:   '02-nftables-inet-filter-chain-FORWARD-rule-policy-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-FORWARD-rule-jump_global').with(
            target:  'nftables-inet-filter-chain-FORWARD',
            content: %r{^  jump global$},
            order:   '03-nftables-inet-filter-chain-FORWARD-rule-jump_global-b'
          )
        }
        it {
          is_expected.not_to contain_concat__fragment('nftables-inet-filter-chain-FORWARD-rule-accept_established_related')
        }
        it {
          is_expected.not_to contain_concat__fragment('nftables-inet-filter-chain-FORWARD-rule-drop_invalid')
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-FORWARD-rule-jump_default_fwd').with(
            target:  'nftables-inet-filter-chain-FORWARD',
            content: %r{^  jump default_fwd$},
            order:   '10-nftables-inet-filter-chain-FORWARD-rule-jump_default_fwd-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-FORWARD-rule-log_discarded').with(
            target:  'nftables-inet-filter-chain-FORWARD',
            content: %r{^  limit rate 3/minute burst 5 packets log prefix \"\[nftables\] FORWARD Rejected: \" flags all counter$},
            order:   '97-nftables-inet-filter-chain-FORWARD-rule-log_discarded-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-FORWARD-rule-reject').with(
            target:  'nftables-inet-filter-chain-FORWARD',
            content: %r{^  reject with icmpx type port-unreachable$},
            order:   '98-nftables-inet-filter-chain-FORWARD-rule-reject-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-FORWARD-footer').with(
            target:  'nftables-inet-filter-chain-FORWARD',
            content: %r{^\}$},
            order:   '99'
          )
        }

        it {
          is_expected.to contain_concat('nftables-inet-filter-chain-default_fwd').with(
            path:           '/etc/nftables/puppet-preflight/inet-filter-chain-default_fwd.nft',
            owner:          'root',
            group:          'root',
            mode:           '0640',
            ensure_newline: true
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_fwd-header').with(
            target:  'nftables-inet-filter-chain-default_fwd',
            content: %r{^chain default_fwd \{$},
            order:   '00'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_fwd-footer').with(
            target:  'nftables-inet-filter-chain-default_fwd',
            content: %r{^\}$},
            order:   '99'
          )
        }
      end

      context 'custom log prefix without variable substitution' do
        let(:pre_condition) { 'class{\'nftables\': log_prefix => "test "}' }

        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-INPUT-rule-log_discarded').with(
            target:  'nftables-inet-filter-chain-INPUT',
            content: %r{^  limit rate 3/minute burst 5 packets log prefix \"test " flags all counter$},
            order:   '97-nftables-inet-filter-chain-INPUT-rule-log_discarded-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-OUTPUT-rule-log_discarded').with(
            target:  'nftables-inet-filter-chain-OUTPUT',
            content: %r{^  limit rate 3/minute burst 5 packets log prefix \"test " flags all counter$},
            order:   '97-nftables-inet-filter-chain-OUTPUT-rule-log_discarded-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-FORWARD-rule-log_discarded').with(
            target:  'nftables-inet-filter-chain-FORWARD',
            content: %r{^  limit rate 3/minute burst 5 packets log prefix \"test " flags all counter$},
            order:   '97-nftables-inet-filter-chain-FORWARD-rule-log_discarded-b'
          )
        }
      end

      context 'custom log prefix with variable substitution' do
        let(:pre_condition) { 'class{\'nftables\': log_prefix => " bar [%<chain>s] "}' }

        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-INPUT-rule-log_discarded').with(
            target:  'nftables-inet-filter-chain-INPUT',
            content: %r{^  limit rate 3/minute burst 5 packets log prefix \" bar \[INPUT\] " flags all counter$},
            order:   '97-nftables-inet-filter-chain-INPUT-rule-log_discarded-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-OUTPUT-rule-log_discarded').with(
            target:  'nftables-inet-filter-chain-OUTPUT',
            content: %r{^  limit rate 3/minute burst 5 packets log prefix \" bar \[OUTPUT\] " flags all counter$},
            order:   '97-nftables-inet-filter-chain-OUTPUT-rule-log_discarded-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-FORWARD-rule-log_discarded').with(
            target:  'nftables-inet-filter-chain-FORWARD',
            content: %r{^  limit rate 3/minute burst 5 packets log prefix \" bar \[FORWARD\] " flags all counter$},
            order:   '97-nftables-inet-filter-chain-FORWARD-rule-log_discarded-b'
          )
        }
      end

      context 'no log limit' do
        let(:params) do
          {
            'log_limit' => false,
          }
        end

        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-INPUT-rule-log_discarded').with(
            target:  'nftables-inet-filter-chain-INPUT',
            content: %r{^  log prefix \"\[nftables\] INPUT Rejected: \" flags all counter$},
            order:   '97-nftables-inet-filter-chain-INPUT-rule-log_discarded-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-OUTPUT-rule-log_discarded').with(
            target:  'nftables-inet-filter-chain-OUTPUT',
            content: %r{^  log prefix \"\[nftables\] OUTPUT Rejected: \" flags all counter$},
            order:   '97-nftables-inet-filter-chain-OUTPUT-rule-log_discarded-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-FORWARD-rule-log_discarded').with(
            target:  'nftables-inet-filter-chain-FORWARD',
            content: %r{^  log prefix \"\[nftables\] FORWARD Rejected: \" flags all counter$},
            order:   '97-nftables-inet-filter-chain-FORWARD-rule-log_discarded-b'
          )
        }
      end

      context 'custom log limit' do
        let(:params) do
          {
            'log_limit' => '5/minute',
          }
        end

        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-INPUT-rule-log_discarded').with(
            target:  'nftables-inet-filter-chain-INPUT',
            content: %r{^  limit rate 5/minute log prefix \"\[nftables\] INPUT Rejected: \" flags all counter$},
            order:   '97-nftables-inet-filter-chain-INPUT-rule-log_discarded-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-OUTPUT-rule-log_discarded').with(
            target:  'nftables-inet-filter-chain-OUTPUT',
            content: %r{^  limit rate 5/minute log prefix \"\[nftables\] OUTPUT Rejected: \" flags all counter$},
            order:   '97-nftables-inet-filter-chain-OUTPUT-rule-log_discarded-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-FORWARD-rule-log_discarded').with(
            target:  'nftables-inet-filter-chain-FORWARD',
            content: %r{^  limit rate 5/minute log prefix \"\[nftables\] FORWARD Rejected: \" flags all counter$},
            order:   '97-nftables-inet-filter-chain-FORWARD-rule-log_discarded-b'
          )
        }
      end

      context 'no reject rule, use chain policy without explicit reject' do
        let(:params) do
          {
            'reject_with' => false,
          }
        end

        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-INPUT-rule-log_discarded')
        }
        it {
          is_expected.not_to contain_concat__fragment('nftables-inet-filter-chain-INPUT-rule-reject')
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-OUTPUT-rule-log_discarded')
        }
        it {
          is_expected.not_to contain_concat__fragment('nftables-inet-filter-chain-OUTPUT-rule-reject')
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-FORWARD-rule-log_discarded')
        }
        it {
          is_expected.not_to contain_concat__fragment('nftables-inet-filter-chain-FORWARD-rule-reject')
        }
      end

      context 'custom reject configuration is allowed' do
        let(:params) do
          {
            'reject_with' => 'tcp reset',
          }
        end

        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-INPUT-rule-reject').with(
            target:  'nftables-inet-filter-chain-INPUT',
            content: %r{^  reject with tcp reset$},
            order:   '98-nftables-inet-filter-chain-INPUT-rule-reject-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-OUTPUT-rule-reject').with(
            target:  'nftables-inet-filter-chain-OUTPUT',
            content: %r{^  reject with tcp reset$},
            order:   '98-nftables-inet-filter-chain-OUTPUT-rule-reject-b'
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-FORWARD-rule-reject').with(
            target:  'nftables-inet-filter-chain-FORWARD',
            content: %r{^  reject with tcp reset$},
            order:   '98-nftables-inet-filter-chain-FORWARD-rule-reject-b'
          )
        }
      end

      context 'fails with unvalid reject with' do
        let(:params) do
          {
            'reject_with' => true,
          }
        end

        it { is_expected.not_to compile }
      end

      context 'without conntrack rules' do
        let(:params) do
          {
            'in_out_conntrack' => false,
            'fwd_conntrack'    => false,
          }
        end

        it {
          is_expected.not_to contain_concat__fragment('nftables-inet-filter-chain-INPUT-rule-accept_established_related')
        }
        it {
          is_expected.not_to contain_concat__fragment('nftables-inet-filter-chain-INPUT-rule-drop_invalid')
        }
        it {
          is_expected.not_to contain_concat__fragment('nftables-inet-filter-chain-OUTPUT-rule-accept_established_related')
        }
        it {
          is_expected.not_to contain_concat__fragment('nftables-inet-filter-chain-OUTPUT-rule-drop_invalid')
        }
        it {
          is_expected.not_to contain_concat__fragment('nftables-inet-filter-chain-FORWARD-rule-accept_established_related')
        }
        it {
          is_expected.not_to contain_concat__fragment('nftables-inet-filter-chain-FORWARD-rule-drop_invalid')
        }
      end

      context 'without ICMP configuration' do
        let(:params) do
          {
            'in_icmp' => false,
            'out_icmp' => false,
          }
        end

        it {
          is_expected.not_to contain_class('nftables::rules::icmp')
        }
        it {
          is_expected.not_to contain_class('nftables::rules::out::icmp')
        }
      end
    end
  end
end
