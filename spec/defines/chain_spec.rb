# frozen_string_literal: true

require 'spec_helper'

describe 'nftables::chain' do
  let(:title) { 'MYCHAIN' }
  let(:pre_condition) { 'include nftables' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile }

      it { is_expected.to contain_concat('nftables-inet-filter-chain-MYCHAIN').that_notifies('Exec[nft validate]') }
      it { is_expected.to contain_exec('nft validate').that_comes_before('File[/etc/nftables/puppet/inet-filter-chain-MYCHAIN.nft]') }
      it { is_expected.to contain_file('/etc/nftables/puppet/inet-filter-chain-MYCHAIN.nft').that_comes_before('Service[nftables]') }

      it {
        expect(subject).to contain_concat('nftables-inet-filter-chain-MYCHAIN').with(
          path: '/etc/nftables/puppet-preflight/inet-filter-chain-MYCHAIN.nft',
          owner: 'root',
          group: 'root',
          mode: '0640',
          ensure_newline: true
        )
      }

      it {
        expect(subject).to contain_file('/etc/nftables/puppet/inet-filter-chain-MYCHAIN.nft').with(
          ensure: 'file',
          source: '/etc/nftables/puppet-preflight/inet-filter-chain-MYCHAIN.nft',
          mode: '0640',
          owner: 'root',
          group: 'root'
        )
      }

      it {
        expect(subject).to contain_concat__fragment('nftables-inet-filter-chain-MYCHAIN-header').with(
          order: '00',
          content: "# Start of fragment order:00 MYCHAIN header\nchain MYCHAIN {",
          target: 'nftables-inet-filter-chain-MYCHAIN'
        )
      }

      it {
        expect(subject).to contain_concat__fragment('nftables-inet-filter-chain-MYCHAIN-footer').with(
          order: '99',
          content: "# Start of fragment order:99 MYCHAIN footer\n}",
          target: 'nftables-inet-filter-chain-MYCHAIN'
        )
      }

      context('with table set to ip6-foo') do
        let(:params) do
          {
            table: 'ip6-foo',
          }
        end

        it {
          expect(subject).to contain_concat('nftables-ip6-foo-chain-MYCHAIN').with(
            path: '/etc/nftables/puppet-preflight/ip6-foo-chain-MYCHAIN.nft',
            owner: 'root',
            group: 'root',
            mode: '0640',
            ensure_newline: true
          )
        }

        it {
          expect(subject).to contain_file('/etc/nftables/puppet/ip6-foo-chain-MYCHAIN.nft').with(
            ensure: 'file',
            source: '/etc/nftables/puppet-preflight/ip6-foo-chain-MYCHAIN.nft',
            mode: '0640',
            owner: 'root',
            group: 'root'
          )
        }

        it {
          expect(subject).to contain_concat__fragment('nftables-ip6-foo-chain-MYCHAIN-header').with(
            order: '00',
            content: "# Start of fragment order:00 MYCHAIN header\nchain MYCHAIN {",
            target: 'nftables-ip6-foo-chain-MYCHAIN'
          )
        }

        it {
          expect(subject).to contain_concat__fragment('nftables-ip6-foo-chain-MYCHAIN-footer').with(
            order: '99',
            content: "# Start of fragment order:99 MYCHAIN footer\n}",
            target: 'nftables-ip6-foo-chain-MYCHAIN'
          )
        }
      end

      context 'with inject set to 22-foobar' do
        let(:params) do
          {
            inject: '22-foobar',
          }
        end

        it { is_expected.to contain_nftables__rule('foobar-jump_MYCHAIN') }

        it {
          expect(subject).to contain_nftables__rule('foobar-jump_MYCHAIN').with(
            order: '22',
            content: 'jump MYCHAIN'
          )
        }

        context 'with inject_oif set to alpha and inject_oif set to beta' do
          let(:params) do
            super().merge(inject_iif: 'alpha', inject_oif: 'beta')
          end

          it {
            expect(subject).to contain_nftables__rule('foobar-jump_MYCHAIN').with(
              order: '22',
              content: 'iifname alpha oifname beta jump MYCHAIN'
            )
          }
        end
      end
    end
  end
end
