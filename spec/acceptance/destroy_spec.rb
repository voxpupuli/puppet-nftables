# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'nftables class' do
  context 'configure defaults destroyed nftables service' do
    it 'works idempotently with no errors' do
      pp = <<-EOS
      # default mask of firewalld service fails if service is not installed.
      # https://tickets.puppetlabs.com/browse/PUP-10814
      class { 'nftables':
        firewalld_enable       => false,
        clobber_default_config => true,
      }
      $config_path = $facts['os']['family'] ? {
        'Archlinux' => '/etc/nftables.conf',
        'Debian' => '/etc/nftables.conf',
        default => '/etc/sysconfig/nftables.conf',
      }
      $nft_path = $facts['os']['family'] ? {
        'Archlinux' => '/usr/bin/nft',
        default => '/usr/sbin/nft',
      }
      # nftables cannot be started in docker so replace service with a validation only.
      systemd::dropin_file{"zzz_docker_nft.conf":
        ensure  => present,
        unit    => "nftables.service",
        content => [
          "[Service]",
          "ExecStart=",
          "ExecStart=${nft_path} -c -I /etc/nftables/puppet -f ${config_path}",
          "ExecReload=",
          "ExecReload=${nft_path} -c -I /etc/nftables/puppet -f ${config_path}",
          "",
          ].join("\n"),
        notify  => Service["nftables"],
      }
      EOS
      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe package('nftables') do
      it { is_expected.to be_installed }
    end

    describe service('nftables') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe file('/etc/nftables/puppet.nft', '/etc/systemd/system/nftables.service.d/puppet_nft.conf') do
      it { is_expected.to be_file }
    end

    describe file('/etc/nftables/puppet') do
      it { is_expected.to be_directory }
    end
  end
end
