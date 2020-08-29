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
      owner  => 'root',
      group  => 'root',
      mode   => '0640';
    '/etc/nftables/puppet.nft':
      source => 'puppet:///modules/nftables/config/puppet.nft';
    '/etc/nftables/puppet':
      ensure  => directory,
      purge   => true,
      force   => true,
      recurse => true;
  } ~> service{'nftables':
    ensure    => running,
    enable    => true,
  }

  nftables::config{
    'filter':
      source => 'puppet:///modules/nftables/config/puppet-filter.nft';
    'ip-nat':
      source => 'puppet:///modules/nftables/config/puppet-ip-nat.nft';
  }

  nftables::filter::chain{
    [
      'forward-default_fwd',
      'output-default_out',
      'input-default_in',
    ]:;
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
