# manage nftables
class nftables (
  Boolean $in_ssh    = true,
  Boolean $out_ntp   = true,
  Boolean $out_dns   = true,
  Boolean $out_http  = true,
  Boolean $out_https = true,
  Boolean $out_all   = false,
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

  service{'firewalld':
    ensure => stopped,
    enable => mask,
  }

  include nftables::inet_filter
  include nftables::ip_nat
}
