# manage a ipv4 dnat rule
define nftables::rules::dnat4 (
  Pattern[/^[12]?\d{1,2}\.[12]?\d{1,2}\.[12]?\d{1,2}\.[12]?\d{1,2}$/]
  $daddr,
  Variant[String,Integer[1,65535]]
  $port,
  Pattern[/^[a-zA-Z0-9_]+$/]
  $rulename = $title,
  Pattern[/^\d\d$/]
  $order = '50',
  String[1]
  $chain = 'default_fwd',
  Optional[String[1]]
  $iif = undef,
  Enum['tcp','udp']
  $proto = 'tcp',
  Optional[Variant[String,Integer[1,65535]]]
  $dport = '',
  Enum['present','absent']
  $ensure = 'present',
) {
  $iifname = $iif ? {
    undef   => '',
    default => "iifname ${iif} ",
  }
  $filter_port = $dport ? {
    ''      => $port,
    default => $dport,
  }
  $nat_port = $dport ? {
    ''      => '',
    default => ":${dport}",
  }

  nftables::rule {
    default:
      ensure => $ensure,
      order  => $order;
    "${chain}-${rulename}":
      content => "${iifname}ip daddr ${daddr} ${proto} dport ${filter_port} accept";
    "PREROUTING-${rulename}":
      table   => 'ip-nat',
      content => "${iifname}${proto} dport ${port} dnat to ${daddr}${nat_port}";
  }
}
