# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'nftables class' do
  context 'with a table that might be flushed' do
    pp = <<-EOS
    class{'nftables':
      firewalld_enable => false,
      inet_filter => false,
      nat => false,
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

    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)

    on hosts, 'nft add table inet inet-example'
    on hosts, 'nft \'add chain inet inet-example input { type filter hook input priority 0 ; }\''
    on hosts, 'nft add rule inet inet-example input tcp dport 1234 accept'

    it 'table should keep existing and have the same rules if member of noflush_tables' do
      pp1 = <<-EOS
      class{'nftables':
        firewalld_enable => false,
        inet_filter => false,
        nat => false,
        noflush_tables => ['inet-example'],
      }
      EOS

      apply_manifest(pp1, catch_failures: true)
      apply_manifest(pp1, catch_changes: true)

      table_contents = shell('nft list table inet inet-example')
      expect(table_contents.exit_code).to eq 0
      expect(table_contents.stdout).to match %r{1234}
    end

    it 'table should disappear if not member of noflush_tables' do
      pp2 = <<-EOS
      class{'nftables':
        firewalld_enable => false,
        inet_filter => false,
        nat => false,
      }
      EOS

      apply_manifest(pp2, catch_failures: true)
      apply_manifest(pp2, catch_changes: true)

      table_contents = shell('nft list table inet inet-example')
      expect(table_contents.exit_code).to eq 1
    end
  end
end