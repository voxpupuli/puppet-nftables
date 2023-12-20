# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'nftables class' do
  context 'configure a simple rule with interface' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-EOS
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
        # just incoming interface
        nftables::simplerule { 'dummyrule_in':
          action  => 'accept',
          iifname => $facts['networking']['primary'],
          comment => 'allow some multicast stuff',
          daddr   => 'ff02::fb',
        }
        # just outgoing interface
        nftables::simplerule { 'dummyrule_out':
          action  => 'accept',
          oifname => $facts['networking']['primary'],
          comment => 'allow some multicast stuff',
          chain   => 'default_out',
          daddr   => 'ff02::fb',
        }
        # outgoing + incoming interface
        nftables::simplerule { 'dummyrule_fwd':
          action  => 'accept',
          iifname => $facts['networking']['primary'],
          oifname => 'lo',
          comment => 'allow some multicast stuff',
          chain   => 'default_fwd',
          daddr   => 'ff02::fb',
        }
        include nftables::rules::ssh
        include nftables::rules::out::dns
        include nftables::rules::out::ssh
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
      end
    end
  end
end
