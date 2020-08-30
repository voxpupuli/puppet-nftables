# manage nftables
class nftables (
  Boolean $in_ssh    = true,
  Boolean $out_ntp   = true,
  Boolean $out_dns   = true,
  Boolean $out_http  = true,
  Boolean $out_https = true,
) {

  package{'nftables':
    ensure => installed,
  } -> file_line{
    'enable_nftables':
      line   => 'include "/etc/nftables/puppet.nft"',
      path   => '/etc/sysconfig/nftables.conf',
      notify => Service['nftables'],
  } -> file{
    default:
      owner => 'root',
      group => 'root',
      mode  => '0640';
    '/etc/nftables/puppet.nft':
      ensure => file,
      source => 'puppet:///modules/nftables/config/puppet.nft';
    '/etc/nftables/puppet':
      ensure  => directory,
      mode    => '0750',
      purge   => true,
      force   => true,
      recurse => true;
  } ~> service{'nftables':
    ensure => running,
    enable => true,
  }

  nftables::config{
    'inet-filter':
      source => 'puppet:///modules/nftables/config/puppet-filter.nft';
    'ip-nat':
      source => 'puppet:///modules/nftables/config/puppet-ip-nat.nft';
  }

  nftables::chain{
    [
      'INPUT',
      'OUTPUT',
      'FORWARD',
    ]:;
  }

  nftables::chain{
    [
      'PREROUTING',
      'POSTROUTING',
    ]:
      table => 'ip-nat';
  }

  nftables::chain{
    'default_in':
      inject => '10-INPUT';
    'default_out':
      inject => '10-OUTPUT';
    'default_fwd':
      inject => '10-FORWARD';
  }

  # inet-filter-chain-INPUT
  nftables::rule{
    'INPUT-type':
      order   => '01',
      content => 'type filter hook input priority 0';
    'INPUT-policy':
      order   => '02',
      content => 'policy drop';
    'INPUT-lo':
      order   => '03',
      content => 'iifname lo accept';
    'INPUT-jump_global':
      order   => '04',
      content => 'jump global';
    'INPUT-log_rejected':
      order   => '98',
      content => 'log prefix "[nftables] INPUT Rejected: " flags all counter reject with icmpx type port-unreachable';
  }

  # inet-filter-chain-OUTPUT
  nftables::rule{
    'OUTPUT-type':
      order   => '01',
      content => 'type filter hook output priority 0';
    'OUTPUT-policy':
      order   => '02',
      content => 'policy drop';
    'OUTPUT-lo':
      order   => '03',
      content => 'oifname lo accept';
    'OUTPUT-jump_global':
      order   => '04',
      content => 'jump global';
    'OUTPUT-log_rejected':
      order   => '98',
      content => 'log prefix "[nftables] OUTPUT Rejected: " flags all counter reject with icmpx type port-unreachable';
  }

  # inet-filter-chain-FORWARD
  nftables::rule{
    'FORWARD-type':
      order   => '01',
      content => 'type filter hook forward priority 0';
    'FORWARD-policy':
      order   => '02',
      content => 'policy drop';
    'FORWARD-jump_global':
      order   => '03',
      content => 'jump global';
    'FORWARD-log_rejected':
      order   => '98',
      content => 'log prefix "[nftables] FORWARD Rejected: " flags all counter reject with icmpx type port-unreachable';
  }

  # ip-nat-chain-PREROUTING
  nftables::rule{
    default:
      table   => 'ip-nat';
    'PREROUTING-type':
      order   => '01',
      content => 'type nat hook prerouting priority -100';
    'PREROUTING-policy':
      order   => '02',
      content => 'policy accept';
  }

  # ip-nat-chain-POSTROUTING
  nftables::rule{
    default:
      table   => 'ip-nat';
    'POSTROUTING-type':
      order   => '01',
      content => 'type nat hook postrouting priority 100';
    'POSTROUTING-policy':
      order   => '02',
      content => 'policy accept';
  }

  # basic ingoing rules
  if $in_ssh {
    include nftables::rules::ssh
  }

  # basic outgoing rules
  if $out_ntp {
    include nftables::rules::out::chrony
  }
  if $out_dns {
    include nftables::rules::out::dns
  }
  if $out_http {
    include nftables::rules::out::http
  }
  if $out_https {
    include nftables::rules::out::https
  }
}
