require 'spec_helper_acceptance'

describe 'nftables class' do
  context 'configure all nftables rules' do
    it 'works idempotently with no errors' do
      pp = <<-EOS
      # default mask of firewalld service fails if service is not installed.
      # https://tickets.puppetlabs.com/browse/PUP-10814
      # Disable all default rules and include below explicitly
      class { 'nftables':
        firewalld_enable => false,
        out_ntp          => false,
        out_http         => false,
        out_https        => false,
        out_icmp         => false,
        in_ssh           => false,
        in_icmp          => false,
      }
      include nftables::rules::icmp
      include nftables::rules::dns
      include nftables::rules::node_exporter
      include nftables::rules::nfs3
      include nftables::rules::ssh
      include nftables::rules::dhcpv6_client
      include nftables::rules::afs3_callback
      include nftables::rules::ospf
      include nftables::rules::http
      include nftables::rules::puppet
      include nftables::rules::icinga2
      include nftables::rules::tor
      include nftables::rules::ospf3
      include nftables::rules::ceph_mon
      include nftables::rules::smtp_submission
      include nftables::rules::https
      include nftables::rules::nfs
      include nftables::rules::smtps
      include nftables::rules::smtp
      include nftables::rules::ceph
      include nftables::rules::samba
      include nftables::rules::activemq
      include nftables::rules::docker_ce
      include nftables::rules::out::postgres
      include nftables::rules::out::icmp
      include nftables::rules::out::dns
      include nftables::rules::out::nfs3
      include nftables::rules::out::ssh
      include nftables::rules::out::kerberos
      include nftables::rules::out::dhcpv6_client
      include nftables::rules::out::ospf
      include nftables::rules::out::openafs_client
      include nftables::rules::out::http
      include nftables::rules::out::ssh::remove
      class{'nftables::rules::out::puppet':
        puppetserver => '127.0.0.1',
      }
      include nftables::rules::out::all
      include nftables::rules::out::tor
      include nftables::rules::out::ospf3
      include nftables::rules::out::mysql
      include nftables::rules::out::ceph_client
      include nftables::rules::out::https
      include nftables::rules::out::dhcp
      include nftables::rules::out::nfs
      include nftables::rules::out::smtp
      include nftables::rules::out::smtp_client
      include nftables::rules::out::imap
      include nftables::rules::out::pop3
      include nftables::rules::out::chrony
      include nftables::rules::out::wireguard
      include nftables::rules::wireguard
      include nftables::services::dhcpv6_client
      include nftables::services::openafs_client
      # nftables cannot be started in docker so replace service with a validation only.
      systemd::dropin_file{"zzz_docker_nft.conf":
        ensure  => present,
        unit    => "nftables.service",
        content => [
          "[Service]",
          "ExecStart=",
          "ExecStart=/sbin/nft -c -I /etc/nftables/puppet -f /etc/sysconfig/nftables.conf",
          "ExecReload=",
          "ExecReload=/sbin/nft -c -I /etc/nftables/puppet -f /etc/sysconfig/nftables.conf",
          "",
          ].join("\n"),
        notify  => Service["nftables"],
      }
      # Puppet 5 only to ensure ordering.
      Class['systemd::systemctl::daemon_reload'] -> Service['nftables']
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

    describe file('/etc/nftables/puppet.nft') do
      it { is_expected.to be_file }
    end

    describe file('/etc/systemd/system/nftables.service.d/puppet_nft.conf') do
      it { is_expected.to be_file }
    end

    describe file('/etc/nftables/puppet') do
      it { is_expected.to be_directory }
    end
  end
end
