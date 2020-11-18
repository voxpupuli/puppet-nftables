require 'spec_helper'

describe 'nftables' do
  let(:pre_condition) { 'Exec{path => "/bin"}' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with dnat' do
        let(:pre_condition) do
          '
          # inet-filter-chain-ingoing
          nftables::chain{ \'ingoing\':
            inject     => \'20-default_fwd\',
            inject_iif => \'eth0\',
            inject_oif => \'eth1\';
          }

          # inet-filter-chain-default_fwd
          nftables::rules::dnat4{
            \'http\':
              order => \'10\',
              chain => \'ingoing\',
              daddr => \'192.0.2.2\',
              port  => \'http\';
            \'https\':
              order => \'10\',
              chain => \'ingoing\',
              daddr => \'192.0.2.2\',
              port  => \'https\';
            \'http_alt\':
              order => \'10\',
              chain => \'ingoing\',
              iif   => \'eth0\',
              daddr => \'192.0.2.2\',
              proto => \'tcp\',
              port  => 8080,
              dport => 8000;
            \'wireguard\':
              order => \'10\',
              chain => \'ingoing\',
              iif   => \'eth0\',
              daddr => \'192.0.2.3\',
              proto => \'udp\',
              port  => \'51820\';
          }
          '
        end

        it { is_expected.to compile }

        it {
          is_expected.to contain_concat('nftables-inet-filter-chain-default_fwd').with(
            path:           '/etc/nftables/puppet/inet-filter-chain-default_fwd.nft',
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
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_fwd-rule-jump_ingoing').with(
            target:  'nftables-inet-filter-chain-default_fwd',
            content: %r{^  iifname eth0 oifname eth1 jump ingoing$},
            order:   '20nftables-inet-filter-chain-default_fwd-rule-jump_ingoingb',
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-default_fwd-footer').with(
            target:  'nftables-inet-filter-chain-default_fwd',
            content: %r{^\}$},
            order:   '99',
          )
        }

        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-ingoing-header').with(
            target:  'nftables-inet-filter-chain-ingoing',
            content: %r{^chain ingoing \{$},
            order:   '00',
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-ingoing-rule-http').with(
            target:  'nftables-inet-filter-chain-ingoing',
            content: %r{^  ip daddr 192.0.2.2 tcp dport http accept$},
            order:   '10nftables-inet-filter-chain-ingoing-rule-httpb',
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-ingoing-rule-https').with(
            target:  'nftables-inet-filter-chain-ingoing',
            content: %r{^  ip daddr 192.0.2.2 tcp dport https accept$},
            order:   '10nftables-inet-filter-chain-ingoing-rule-httpsb',
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-ingoing-rule-http_alt').with(
            target:  'nftables-inet-filter-chain-ingoing',
            content: %r{^  iifname eth0 ip daddr 192.0.2.2 tcp dport 8000 accept$},
            order:   '10nftables-inet-filter-chain-ingoing-rule-http_altb',
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-ingoing-rule-wireguard').with(
            target:  'nftables-inet-filter-chain-ingoing',
            content: %r{^  iifname eth0 ip daddr 192.0.2.3 udp dport 51820 accept$},
            order:   '10nftables-inet-filter-chain-ingoing-rule-wireguardb',
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-ingoing-footer').with(
            target:  'nftables-inet-filter-chain-ingoing',
            content: %r{^\}$},
            order:   '99',
          )
        }

        it {
          is_expected.to contain_concat('nftables-ip-nat-chain-PREROUTING').with(
            path:           '/etc/nftables/puppet/ip-nat-chain-PREROUTING.nft',
            owner:          'root',
            group:          'root',
            mode:           '0640',
            ensure_newline: true,
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-ip-nat-chain-PREROUTING-header').with(
            target:  'nftables-ip-nat-chain-PREROUTING',
            content: %r{^chain PREROUTING \{$},
            order:   '00',
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-ip-nat-chain-PREROUTING-rule-type').with(
            target:  'nftables-ip-nat-chain-PREROUTING',
            content: %r{^  type nat hook prerouting priority -100$},
            order:   '01nftables-ip-nat-chain-PREROUTING-rule-typeb',
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-ip-nat-chain-PREROUTING-rule-policy').with(
            target:  'nftables-ip-nat-chain-PREROUTING',
            content: %r{^  policy accept$},
            order:   '02nftables-ip-nat-chain-PREROUTING-rule-policyb',
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-ip-nat-chain-PREROUTING-rule-http').with(
            target:  'nftables-ip-nat-chain-PREROUTING',
            content: %r{^  tcp dport http dnat to 192.0.2.2$},
            order:   '10nftables-ip-nat-chain-PREROUTING-rule-httpb',
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-ip-nat-chain-PREROUTING-rule-https').with(
            target:  'nftables-ip-nat-chain-PREROUTING',
            content: %r{^  tcp dport https dnat to 192.0.2.2$},
            order:   '10nftables-ip-nat-chain-PREROUTING-rule-httpsb',
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-ip-nat-chain-PREROUTING-rule-http_alt').with(
            target:  'nftables-ip-nat-chain-PREROUTING',
            content: %r{^  iifname eth0 tcp dport 8080 dnat to 192.0.2.2:8000$},
            order:   '10nftables-ip-nat-chain-PREROUTING-rule-http_altb',
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-ip-nat-chain-PREROUTING-rule-wireguard').with(
            target:  'nftables-ip-nat-chain-PREROUTING',
            content: %r{^  iifname eth0 udp dport 51820 dnat to 192.0.2.3$},
            order:   '10nftables-ip-nat-chain-PREROUTING-rule-wireguardb',
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-ip-nat-chain-PREROUTING-footer').with(
            target:  'nftables-ip-nat-chain-PREROUTING',
            content: %r{^\}$},
            order:   '99',
          )
        }
      end
    end
  end
end
