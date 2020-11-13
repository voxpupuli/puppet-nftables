require 'spec_helper'

describe 'nftables' do
  let(:pre_condition) { 'Exec{path => "/bin"}' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      it {
        is_expected.to contain_concat('nftables-ip-nat').with(
          path:   '/etc/nftables/puppet/ip-nat.nft',
          ensure: 'present',
          owner:  'root',
          group:  'root',
          mode:   '0640',
        )
      }

      it {
        is_expected.to contain_concat__fragment('nftables-ip-nat-header').with(
          target:  'nftables-ip-nat',
          content: %r{^table ip nat \{$},
          order:   '00',
        )
      }

      it {
        is_expected.to contain_concat__fragment('nftables-ip-nat-body').with(
          target:  'nftables-ip-nat',
          order:   '98',
        )
      }

      it {
        is_expected.to contain_concat__fragment('nftables-ip-nat-footer').with(
          target:  'nftables-ip-nat',
          content: %r{^\}$},
          order:   '99',
        )
      }

      it {
        is_expected.to contain_concat('nftables-ip6-nat').with(
          path:   '/etc/nftables/puppet/ip6-nat.nft',
          ensure: 'present',
          owner:  'root',
          group:  'root',
          mode:   '0640',
        )
      }

      it {
        is_expected.to contain_concat__fragment('nftables-ip6-nat-header').with(
          target:  'nftables-ip6-nat',
          content: %r{^table ip6 nat \{$},
          order:   '00',
        )
      }

      it {
        is_expected.to contain_concat__fragment('nftables-ip6-nat-body').with(
          target:  'nftables-ip6-nat',
          order:   '98',
        )
      }

      it {
        is_expected.to contain_concat__fragment('nftables-ip6-nat-footer').with(
          target:  'nftables-ip6-nat',
          content: %r{^\}$},
          order:   '99',
        )
      }

      context 'table ip nat chain prerouting' do
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
            order:   '01',
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-ip-nat-chain-PREROUTING-rule-policy').with(
            target:  'nftables-ip-nat-chain-PREROUTING',
            content: %r{^  policy accept$},
            order:   '02',
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

      context 'table ip nat chain postrouting' do
        it {
          is_expected.to contain_concat('nftables-ip-nat-chain-POSTROUTING').with(
            path:           '/etc/nftables/puppet/ip-nat-chain-POSTROUTING.nft',
            owner:          'root',
            group:          'root',
            mode:           '0640',
            ensure_newline: true,
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-ip-nat-chain-POSTROUTING-header').with(
            target:  'nftables-ip-nat-chain-POSTROUTING',
            content: %r{^chain POSTROUTING \{$},
            order:   '00',
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-ip-nat-chain-POSTROUTING-rule-type').with(
            target:  'nftables-ip-nat-chain-POSTROUTING',
            content: %r{^  type nat hook postrouting priority 100$},
            order:   '01',
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-ip-nat-chain-POSTROUTING-rule-policy').with(
            target:  'nftables-ip-nat-chain-POSTROUTING',
            content: %r{^  policy accept$},
            order:   '02',
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-ip-nat-chain-POSTROUTING-footer').with(
            target:  'nftables-ip-nat-chain-POSTROUTING',
            content: %r{^\}$},
            order:   '99',
          )
        }
      end

      context 'table ip6 nat chain prerouting' do
        it {
          is_expected.to contain_concat('nftables-ip6-nat-chain-PREROUTING6').with(
            path:           '/etc/nftables/puppet/ip6-nat-chain-PREROUTING6.nft',
            owner:          'root',
            group:          'root',
            mode:           '0640',
            ensure_newline: true,
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-ip6-nat-chain-PREROUTING6-header').with(
            target:  'nftables-ip6-nat-chain-PREROUTING6',
            content: %r{^chain PREROUTING6 \{$},
            order:   '00',
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-ip6-nat-chain-PREROUTING6-rule-type').with(
            target:  'nftables-ip6-nat-chain-PREROUTING6',
            content: %r{^  type nat hook prerouting priority -100$},
            order:   '01',
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-ip6-nat-chain-PREROUTING6-rule-policy').with(
            target:  'nftables-ip6-nat-chain-PREROUTING6',
            content: %r{^  policy accept$},
            order:   '02',
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-ip6-nat-chain-PREROUTING6-footer').with(
            target:  'nftables-ip6-nat-chain-PREROUTING6',
            content: %r{^\}$},
            order:   '99',
          )
        }
      end

      context 'table ip nat chain postrouting' do
        it {
          is_expected.to contain_concat('nftables-ip6-nat-chain-POSTROUTING6').with(
            path:           '/etc/nftables/puppet/ip6-nat-chain-POSTROUTING6.nft',
            owner:          'root',
            group:          'root',
            mode:           '0640',
            ensure_newline: true,
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-ip6-nat-chain-POSTROUTING6-header').with(
            target:  'nftables-ip6-nat-chain-POSTROUTING6',
            content: %r{^chain POSTROUTING6 \{$},
            order:   '00',
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-ip6-nat-chain-POSTROUTING6-rule-type').with(
            target:  'nftables-ip6-nat-chain-POSTROUTING6',
            content: %r{^  type nat hook postrouting priority 100$},
            order:   '01',
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-ip6-nat-chain-POSTROUTING6-rule-policy').with(
            target:  'nftables-ip6-nat-chain-POSTROUTING6',
            content: %r{^  policy accept$},
            order:   '02',
          )
        }
        it {
          is_expected.to contain_concat__fragment('nftables-ip6-nat-chain-POSTROUTING6-footer').with(
            target:  'nftables-ip6-nat-chain-POSTROUTING6',
            content: %r{^\}$},
            order:   '99',
          )
        }
      end
    end
  end
end
