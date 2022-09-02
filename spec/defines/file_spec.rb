# frozen_string_literal: true

require 'spec_helper'

describe 'nftables::file' do
  let(:pre_condition) { 'include nftables' }
  let(:title) { 'FOO' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with source and content both unset' do
        it { is_expected.to compile }
        it { is_expected.to contain_file('/etc/nftables/puppet-preflight/file-FOO.nft').without_source }
        it { is_expected.to contain_file('/etc/nftables/puppet-preflight/file-FOO.nft').without_content }
        it { is_expected.to contain_file('/etc/nftables/puppet/file-FOO.nft').without_source }
        it { is_expected.to contain_file('/etc/nftables/puppet/file-FOO.nft').without_content }
        it { is_expected.to contain_exec('nft validate') }
        it { is_expected.to contain_service('nftables') }
        it { is_expected.to contain_package('nftables').that_comes_before('File[/etc/nftables/puppet-preflight/file-FOO.nft]') }
        it { is_expected.to contain_file('/etc/nftables/puppet-preflight/file-FOO.nft').that_notifies('Exec[nft validate]') }
        it { is_expected.to contain_exec('nft validate').that_comes_before('File[/etc/nftables/puppet/file-FOO.nft]') }
        it { is_expected.to contain_file('/etc/nftables/puppet/file-FOO.nft').that_notifies('Service[nftables]') }
      end

      context 'with source set only' do
        let(:params) do
          { source: 'puppet:///module/foobar.nft' }
        end

        it { is_expected.to contain_file('/etc/nftables/puppet-preflight/file-FOO.nft').without_content }
        it { is_expected.to contain_file('/etc/nftables/puppet-preflight/file-FOO.nft').with_source('puppet:///module/foobar.nft') }
        it { is_expected.to contain_file('/etc/nftables/puppet/file-FOO.nft').without_content }
        it { is_expected.to contain_file('/etc/nftables/puppet/file-FOO.nft').with_source('puppet:///module/foobar.nft') }
      end

      context 'with content set only' do
        let(:params) do
          { content: '# my rules' }
        end

        it { is_expected.to contain_file('/etc/nftables/puppet-preflight/file-FOO.nft').without_source }
        it { is_expected.to contain_file('/etc/nftables/puppet-preflight/file-FOO.nft').with_content('# my rules') }
        it { is_expected.to contain_file('/etc/nftables/puppet/file-FOO.nft').without_source }
        it { is_expected.to contain_file('/etc/nftables/puppet/file-FOO.nft').with_content('# my rules') }
      end

      context 'with content and source set' do
        let(:params) do
          { content: '# my rules', source: 'puppet:///modules/foobar.nft' }
        end

        it { is_expected.not_to compile }
      end
    end
  end
end
