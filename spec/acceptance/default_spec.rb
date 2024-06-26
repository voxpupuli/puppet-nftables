# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'nftables class' do
  context 'configure default nftables service' do
    it 'works idempotently with no errors' do
      pp = <<-EOS

      # Default ArchLinux rules contain "destroy" that requires kernel >= 6.3
      # https://gitlab.archlinux.org/archlinux/packaging/packages/nftables/-/commit/f26a7145b2885d298925819782a5302905332dbe
      # When running on docker this may not be the case.
      if $facts['os']['family'] == 'Archlinux' and versioncmp($facts['kernelrelease'],'6.3') < 0 {
        $_clobber_default_config = true
      } else {
        $_clobber_default_config = undef
      }

      # default mask of firewalld service fails if service is not installed.
      # https://tickets.puppetlabs.com/browse/PUP-10814
      class { 'nftables':
        firewalld_enable => false,
        clobber_default_config => $_clobber_default_config,
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

  context 'with bad invalid nft rules' do
    it 'puppet fails but should leave nft service running' do
      pp = <<-EOS
      if $facts['os']['family'] == 'Archlinux' and versioncmp($facts['kernelrelease'],'6.3') < 0 {
        $_clobber_default_config = true
      } else {
        $_clobber_default_config = undef
      }
      class{'nftables':
        firewalld_enable => false,
        clobber_default_config => $_clobber_default_config,
      }
      nftables::rule{'default_out-junk':
        content => 'A load of junk',
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
          "ExecStart=${nft_path} -c -I /etc/nftables/puppet -f $config_path",
          "ExecReload=",
          "ExecReload=${nft_path} -c -I /etc/nftables/puppet -f $config_path",
          "",
          ].join("\n"),
        notify  => Service["nftables"],
      }
      EOS
      apply_manifest(pp, expect_failures: true)
    end

    describe service('nftables') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end
  end

  context 'with totally empty firewall' do
    it 'no rules validate okay' do
      pp = <<-EOS
      if $facts['os']['family'] == 'Archlinux' and versioncmp($facts['kernelrelease'],'6.3') < 0 {
        $_clobber_default_config = true
      } else {
        $_clobber_default_config = undef
      }
      class{'nftables':
        firewalld_enable => false,
        inet_filter => false,
        nat => false,
        clobber_default_config => $_clobber_default_config,
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
          "ExecStart=${nft_path} -c -I /etc/nftables/puppet -f $config_path",
          "ExecReload=",
          "ExecReload=${nft_path} -c -I /etc/nftables/puppet -f $config_path",
          "",
          ].join("\n"),
        notify  => Service["nftables"],
      }
      EOS
      apply_manifest(pp, catch_failures: true)
    end

    describe service('nftables') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end
  end

  context 'with custom nat_table_name' do
    it 'no rules validate okay' do
      pp = <<-EOS
      if $facts['os']['family'] == 'Archlinux' and versioncmp($facts['kernelrelease'],'6.3') < 0 {
        $_clobber_default_config = true
      } else {
        $_clobber_default_config = undef
      }
      class{'nftables':
        firewalld_enable => false,
        nat => true,
        nat_table_name => 'mycustomtablename',
        clobber_default_config => $_clobber_default_config,
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
          "ExecStart=${nft_path} -c -I /etc/nftables/puppet -f $config_path",
          "ExecReload=",
          "ExecReload=${nft_path} -c -I /etc/nftables/puppet -f $config_path",
          "",
          ].join("\n"),
        notify  => Service["nftables"],
      }
      EOS
      apply_manifest(pp, catch_failures: true)
    end

    describe service('nftables') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end
  end

  context 'with only an empty netdev table' do
    it 'rules validate okay' do
      pp = <<-EOS
      if $facts['os']['family'] == 'Archlinux' and versioncmp($facts['kernelrelease'],'6.3') < 0 {
        $_clobber_default_config = true
      } else {
        $_clobber_default_config = undef
      }
      class{'nftables':
        firewalld_enable => false,
        inet_filter => false,
        nat => false,
        clobber_default_config => $_clobber_default_config,
      }
      nftables::config {
        'netdev-filter':
          prefix => '',
      }
      nftables::chain {
        [
         'INPUT',
         'OUTPUT',
         'FORWARD',
        ]:
          table => 'netdev-filter';
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
          "ExecStart=${nft_path} -c -I /etc/nftables/puppet -f $config_path",
          "ExecReload=",
          "ExecReload=${nft_path} -c -I /etc/nftables/puppet -f $config_path",
          "",
          ].join("\n"),
        notify  => Service["nftables"],
      }
      EOS
      apply_manifest(pp, catch_failures: true)
    end

    describe service('nftables') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end
  end
end
