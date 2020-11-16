# @summary Configure nftables
#
# @example
#   class{'nftables:
#     out_ntp = false,
#     out_dns = true,
#   }
#
# @param out_all
#   Allow all outbound connections. If `true` then all other
#   out parameters `out_ntp`, `out_dns`, ... will be assuemed
#   false.
#
# @param out_ntp
#   Allow outbound to ntp servers.
#
# @param out_http
#   Allow outbound to http servers.
#
# @param out_https
#   Allow outbound to https servers.
#
# @param out_https
#   Allow outbound to https servers.
#
# @param in_ssh
#   Allow inbound to ssh servers.
#
class nftables (
  Boolean $in_ssh    = true,
  Boolean $out_ntp   = true,
  Boolean $out_dns   = true,
  Boolean $out_http  = true,
  Boolean $out_https = true,
  Boolean $out_all   = false,
  Hash $rules        = {},
  String $log_prefix = '[nftables] %<chain>s Rejected: ',
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

  # inject custom rules e.g. from hiera
  $rules.each |$n,$v| {
    nftables::rule{
      $n:
        * => $v
    }
  }
}
