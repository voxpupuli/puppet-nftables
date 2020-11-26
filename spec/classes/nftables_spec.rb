require 'spec_helper'

describe 'nftables' do
  let(:pre_condition) { 'Exec{path => "/bin"}' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      it { is_expected.to contain_package('nftables') }

      it {
        is_expected.to contain_file('/etc/nftables/puppet.nft').with(
          ensure: 'file',
          owner:  'root',
          group:  'root',
          mode:   '0640',
          source: 'puppet:///modules/nftables/config/puppet.nft',
        )
      }

      it {
        is_expected.to contain_file('/etc/nftables/puppet').with(
          ensure:  'directory',
          owner:   'root',
          group:   'root',
          mode:    '0750',
          purge:   true,
          force:   true,
          recurse: true,
        )
      }

      it {
        is_expected.to contain_file('/etc/nftables/puppet-preflight.nft').with(
          ensure: 'file',
          owner:  'root',
          group:  'root',
          mode:   '0640',
          source: 'puppet:///modules/nftables/config/puppet.nft',
        )
      }

      it {
        is_expected.to contain_file('/etc/nftables/puppet-preflight').with(
          ensure:  'directory',
          owner:   'root',
          group:   'root',
          mode:    '0750',
          purge:   true,
          force:   true,
          recurse: true,
        )
      }

      it {
        is_expected.to contain_exec('nft validate').with(
          refreshonly: true,
          command: %r{^/usr/sbin/nft -I /etc/nftables/puppet-preflight -c -f /etc/nftables/puppet-preflight.nft.*},
        )
      }

      it {
        is_expected.to contain_service('nftables').with(
          ensure: 'running',
          enable: true,
          hasrestart: true,
          restart: %r{/usr/bin/systemctl reload nft.*},
        )
      }

      it {
        is_expected.to contain_service('firewalld').with(
          ensure: 'stopped',
          enable: 'mask',
        )
      }
      it { is_expected.to contain_class('nftables::rules::out::http') }
      it { is_expected.to contain_class('nftables::rules::out::https') }
      it { is_expected.to contain_class('nftables::rules::out::dns') }
      it { is_expected.to contain_class('nftables::rules::out::chrony') }
      it { is_expected.not_to contain_class('nftables::rules::out::all') }
      it { is_expected.not_to contain_nftables__rule('default_out-all') }

      context 'with out_all set true' do
        let(:params) do
          {
            out_all: true,
          }
        end

        it { is_expected.to contain_class('nftables::rules::out::all') }
        it { is_expected.not_to contain_class('nftables::rules::out::http') }
        it { is_expected.not_to contain_class('nftables::rules::out::https') }
        it { is_expected.not_to contain_class('nftables::rules::out::dns') }
        it { is_expected.not_to contain_class('nftables::rules::out::chrony') }
        it { is_expected.to contain_nftables__rule('default_out-all').with_content('accept') }
        it { is_expected.to contain_nftables__rule('default_out-all').with_order('90') }
      end

      context 'with custom rules' do
        let(:params) do
          {
            rules: {
              'INPUT-web_accept' => {
                order: '50',
                content: 'iifname eth0 tcp dport { 80, 443 } accept',
              },
            },
          }
        end

        it {
          is_expected.to contain_concat__fragment('nftables-inet-filter-chain-INPUT-rule-web_accept').with(
            target:  'nftables-inet-filter-chain-INPUT',
            content: %r{^  iifname eth0 tcp dport \{ 80, 443 \} accept$},
            order:   '50-nftables-inet-filter-chain-INPUT-rule-web_accept-b',
          )
        }
      end

      context 'without masking firewalld' do
        let(:params) do
          {
            'firewalld_enable' => false,
          }
        end

        it {
          is_expected.to contain_service('firewalld').with(
            ensure: 'stopped',
            enable: false,
          )
        }
      end
    end
  end
end
