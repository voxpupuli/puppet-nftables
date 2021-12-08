# @summary Configure nftables
#
# @example allow dns out and do not allow ntp out
#   class{'nftables:
#     out_ntp = false,
#     out_dns = true,
#   }
#
# @example do not flush particular tables, fail2ban in this case
#   class{'nftables':
#     noflush_tables = ['inet-f2b-table'],
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
# @param out_dns
#   Allow outbound to dns servers.
#
# @param out_https
#   Allow outbound to https servers.
#
# @param out_icmp
#   Allow outbound ICMPv4/v6 traffic.
#
# @param in_ssh
#   Allow inbound to ssh servers.
#
# @param in_icmp
#   Allow inbound ICMPv4/v6 traffic.
#
# @param inet_filter
#   Add default tables, chains and rules to process traffic.
#
# @param nat
#   Add default tables and chains to process NAT traffic.
#
# @param purge_unmanaged_rules
#   Prohibits in-memory rules that are not declared in Puppet
#   code. Setting this to true activates a check that reloads nftables
#   if the rules in memory have been modified outwith Puppet.
#
# @param nat_table_name
#   The name of the 'nat' table.
#
# @param inmem_rules_hash_file
#   The name of the file where the hash of the in-memory rules
#   will be stored.
#
# @param sets
#   Allows sourcing set definitions directly from Hiera.
#
# @param log_prefix
#   String that will be used as prefix when logging packets. It can contain
#   two variables using standard sprintf() string-formatting:
#    * chain: Will be replaced by the name of the chain.
#    * comment: Allows chains to add extra comments.
#
# @param log_limit
#  String with the content of a limit statement to be applied
#  to the rules that log discarded traffic. Set to false to
#  disable rate limiting.
#
# @param reject_with
#   How to discard packets not matching any rule. If `false`, the
#   fate of the packet will be defined by the chain policy (normally
#   drop), otherwise the packet will be rejected with the REJECT_WITH
#   policy indicated by the value of this parameter.
#
# @param in_out_conntrack
#   Adds INPUT and OUTPUT rules to allow traffic that's part of an
#   established connection and also to drop invalid packets.
#
# @param fwd_conntrack
#   Adds FORWARD rules to allow traffic that's part of an
#   established connection and also to drop invalid packets.
#
# @param firewalld_enable
#   Configures how the firewalld systemd service unit is enabled. It might be
#   useful to set this to false if you're externaly removing firewalld from
#   the system completely.
#
# @param noflush_tables
#   If specified only other existings tables will be flushed.
#   If left unset all tables will be flushed via a `flush ruleset`
#
# @param rules
#   Specify hashes of `nftables::rule`s via hiera
#
class nftables (
  Boolean $in_ssh = true,
  Boolean $in_icmp = true,
  Boolean $out_ntp = true,
  Boolean $out_dns = true,
  Boolean $out_http = true,
  Boolean $out_https = true,
  Boolean $out_icmp = true,
  Boolean $out_all = false,
  Boolean $in_out_conntrack = true,
  Boolean $fwd_conntrack = false,
  Boolean $inet_filter = true,
  Boolean $nat = true,
  Boolean $purge_unmanaged_rules = false,
  Hash $rules = {},
  Hash $sets = {},
  String $log_prefix = '[nftables] %<chain>s %<comment>s',
  String[1] $nat_table_name = 'nat',
  Stdlib::Unixpath $inmem_rules_hash_file = '/run/puppet-nft-memhash',
  Variant[Boolean[false], String] $log_limit = '3/minute burst 5 packets',
  Variant[Boolean[false], Pattern[/icmp(v6|x)? type .+|tcp reset/]] $reject_with = 'icmpx type port-unreachable',
  Variant[Boolean[false], Enum['mask']] $firewalld_enable = 'mask',
  Optional[Array[Pattern[/^(ip|ip6|inet)-[-a-zA-Z0-9_]+$/],1]] $noflush_tables = undef,
) {
  package { 'nftables':
    ensure => installed,
  } -> file_line {
    'enable_nftables':
      line   => 'include "/etc/nftables/puppet.nft"',
      path   => '/etc/sysconfig/nftables.conf',
      notify => Service['nftables'],
  } -> file {
    default:
      owner => 'root',
      group => 'root',
      mode  => '0640';
    '/etc/nftables/puppet-preflight':
      ensure  => directory,
      mode    => '0750',
      purge   => true,
      force   => true,
      recurse => true;
    '/etc/nftables/puppet-preflight.nft':
      ensure  => file,
      content => epp('nftables/config/puppet.nft.epp', {
          'inet_filter' => $inet_filter,
          'nat'         => $nat,
          'noflush'     => $noflush_tables
        }
      );
  } ~> exec {
    'nft validate':
      refreshonly => true,
      command     => '/usr/sbin/nft -I /etc/nftables/puppet-preflight -c -f /etc/nftables/puppet-preflight.nft || ( /usr/bin/echo "#CONFIG BROKEN" >> /etc/nftables/puppet-preflight.nft && /bin/false)';
  } -> file {
    default:
      owner => 'root',
      group => 'root',
      mode  => '0640';
    '/etc/nftables/puppet.nft':
      ensure  => file,
      content => epp('nftables/config/puppet.nft.epp', {
          'inet_filter' => $inet_filter,
          'nat'         => $nat,
          'noflush'     => $noflush_tables
        }
      );
    '/etc/nftables/puppet':
      ensure  => directory,
      mode    => '0750',
      purge   => true,
      force   => true,
      recurse => true;
  } ~> service { 'nftables':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    restart    => '/usr/bin/systemctl reload nftables',
  }

  if $purge_unmanaged_rules {
    exec { 'Reload nftables if there are un-managed rules':
      command     => '/usr/bin/systemctl reload nftables',
      refreshonly => false,
      unless      => "/usr/bin/test -s ${inmem_rules_hash_file} -a \"$(nft -s list ruleset | sha1sum)\" = \"$(cat ${inmem_rules_hash_file})\"",
      require     => Service['nftables'],
    }

    file { '/usr/local/sbin/nft-hash-ruleset.sh' :
      ensure  => file,
      mode    => '0755',
      content => file('nftables/systemd/nft-hash-ruleset.sh'),
      before  => Systemd::Dropin_file['puppet_nft.conf'],
    }
  } else {
    file { $inmem_rules_hash_file:
      ensure => absent,
    }
  }

  systemd::dropin_file { 'puppet_nft.conf':
    ensure  => present,
    unit    => 'nftables.service',
    content => epp('nftables/systemd/puppet_nft.conf.epp', {
        'purge_unmanaged' => $purge_unmanaged_rules,
        'hash_file'       => $inmem_rules_hash_file,
    }),
    notify  => Service['nftables'],
  }

  # firewalld.enable can be mask or false depending upon if firewalld is installed or not
  # https://tickets.puppetlabs.com/browse/PUP-10814
  service { 'firewalld':
    ensure => stopped,
    enable => $firewalld_enable,
  }

  if $inet_filter {
    include nftables::inet_filter
  }

  if $nat {
    include nftables::ip_nat
  }

  # inject custom rules e.g. from hiera
  $rules.each |$n,$v| {
    nftables::rule {
      $n:
        * => $v,
    }
  }

  # inject custom sets e.g. from hiera
  $sets.each |$n,$v| {
    nftables::set {
      $n:
        * => $v,
    }
  }
}
