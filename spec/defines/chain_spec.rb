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

      nft_mode = case facts[:os]['family']
                 when 'RedHat'
                   '0600'
                 else
                   '0640'
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
          mode: nft_mode,
          ensure_newline: true
        )
      }

      it {
        expect(subject).to contain_file('/etc/nftables/puppet/inet-filter-chain-MYCHAIN.nft').with(
          ensure: 'file',
          source: '/etc/nftables/puppet-preflight/inet-filter-chain-MYCHAIN.nft',
          mode: nft_mode,
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

      %w[ip ip6 inet bridge netdev].each do |family|
        context("with table set to #{family}-foo") do
          let(:params) do
            {
              table: "#{family}-foo",
            }
          end

          it {
            expect(subject).to contain_concat("nftables-#{family}-foo-chain-MYCHAIN").with(
              path: "/etc/nftables/puppet-preflight/#{family}-foo-chain-MYCHAIN.nft",
              owner: 'root',
              group: 'root',
              mode: nft_mode,
              ensure_newline: true
            )
          }

          it {
            expect(subject).to contain_file("/etc/nftables/puppet/#{family}-foo-chain-MYCHAIN.nft").with(
              ensure: 'file',
              source: "/etc/nftables/puppet-preflight/#{family}-foo-chain-MYCHAIN.nft",
              mode: nft_mode,
              owner: 'root',
              group: 'root'
            )
          }

          it {
            expect(subject).to contain_concat__fragment("nftables-#{family}-foo-chain-MYCHAIN-header").with(
              order: '00',
              content: "# Start of fragment order:00 MYCHAIN header\nchain MYCHAIN {",
              target: "nftables-#{family}-foo-chain-MYCHAIN"
            )
          }

          it {
            expect(subject).to contain_concat__fragment("nftables-#{family}-foo-chain-MYCHAIN-footer").with(
              order: '99',
              content: "# Start of fragment order:99 MYCHAIN footer\n}",
              target: "nftables-#{family}-foo-chain-MYCHAIN"
            )
          }
        end
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
