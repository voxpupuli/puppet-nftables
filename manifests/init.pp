# manage nftables
class nftables {
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
    'nat':
      source => 'puppet:///modules/nftables/config/puppet-nat.nft';
  }

  nftables::filter::chain{
    [
      'forward-default_fwd',
      'output-default_out',
      'input-default_in',
    ]:;
  }
  # basic outgoing rules
  nftables::filter::chain::rule{
    'default_out-dnsudp':
      content => 'udp dport 53 accept';
    'default_out-dnstcp':
      content => 'tcp dport 53 accept';
    'default_out-web':
      content => 'tcp dport {80, 443} accept';
  }
}
