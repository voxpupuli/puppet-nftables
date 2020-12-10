require 'spec_helper'

describe 'nftables::config' do
  let(:pre_condition) { 'include nftables' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:title) { 'FOO-BAR' }
      let(:facts) do
        facts
      end

      context 'with source and content both unset' do
        it { is_expected.to compile }
        it { is_expected.to contain_concat('nftables-FOO-BAR') }
        it {
          is_expected.to contain_concat('nftables-FOO-BAR').with(
            path: '/etc/nftables/puppet-preflight/FOO-BAR.nft',
            ensure_newline: true,
            mode: '0640',
          )
        }
        it { is_expected.to contain_file('/etc/nftables/puppet/FOO-BAR.nft') }
        it {
          is_expected.to contain_file('/etc/nftables/puppet/FOO-BAR.nft').with(
            ensure: 'file',
            source: '/etc/nftables/puppet-preflight/FOO-BAR.nft',
            mode: '0640',
          )
        }
        it { is_expected.to contain_concat_fragment('nftables-FOO-BAR-header') }
        it {
          is_expected.to contain_concat_fragment('nftables-FOO-BAR-header').with(
            target: 'nftables-FOO-BAR',
            order: '00',
            content: 'table FOO BAR {',
          )
        }
        it {
          is_expected.to contain_concat_fragment('nftables-FOO-BAR-body').with(
            target: 'nftables-FOO-BAR',
            order: '98',
            content: '  include "FOO-BAR-chain-*.nft"',
          )
        }
      end

      context 'with a non hyphenated title' do
        let(:title) { 'STRING' }

        it { is_expected.not_to compile }
      end

      context 'with source and content both set' do
        let(:params) do
          {
            source: 'foo',
            content: 'puppet:///modules/foo/bar',
          }
        end

        it {
          pending('Setting source and content should be made to fail')
          is_expected.not_to compile
        }
      end
      context 'with content set' do
        let(:params) do
          {
            content: 'strange content',
          }
        end

        it { is_expected.to compile }
        it { is_expected.to contain_concat('nftables-FOO-BAR') }
        it {
          is_expected.to contain_concat('nftables-FOO-BAR').with(
            path: '/etc/nftables/puppet-preflight/FOO-BAR.nft',
            ensure_newline: true,
            mode: '0640',
          )
        }
        it { is_expected.to contain_file('/etc/nftables/puppet/FOO-BAR.nft') }
        it {
          is_expected.to contain_file('/etc/nftables/puppet/FOO-BAR.nft').with(
            ensure: 'file',
            source: '/etc/nftables/puppet-preflight/FOO-BAR.nft',
            mode: '0640',
          )
        }
        it { is_expected.to contain_concat_fragment('nftables-FOO-BAR-header') }
        it {
          is_expected.to contain_concat_fragment('nftables-FOO-BAR-header').with(
            target: 'nftables-FOO-BAR',
            order: '00',
            content: 'table FOO BAR {',
          )
        }
        it {
          is_expected.to contain_concat_fragment('nftables-FOO-BAR-body').with(
            target: 'nftables-FOO-BAR',
            order: '98',
            content: 'strange content',
          )
        }
      end
      context 'with content set' do
        let(:params) do
          {
            source: 'puppet:///modules/foo',
          }
        end

        it {
          is_expected.to contain_concat_fragment('nftables-FOO-BAR-body').with(
            target: 'nftables-FOO-BAR',
            order: '98',
            source: 'puppet:///modules/foo',
          )
        }
      end
    end
  end
end
