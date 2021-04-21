require 'spec_helper_acceptance'

describe 'nftables class' do
  context 'configure default nftables service' do
    it 'works idempotently with no errors' do
      pp = <<-EOS
      # default mask of firewalld service fails if service is not installed.
      # https://tickets.puppetlabs.com/browse/PUP-10814
      class { 'nftables':
        firewalld_enable => false,
      }
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
  context 'with bad invalid nft rules' do
    it 'puppet fails but should leave nft service running' do
      pp = <<-EOS
      class{'nftables':
        firewalld_enable => false,
      }
      nftables::rule{'default_out-junk':
        content => 'A load of junk',
      }
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
      EOS
      apply_manifest(pp, expect_failures: true)
    end
    describe service('nftables') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end
  end
end
