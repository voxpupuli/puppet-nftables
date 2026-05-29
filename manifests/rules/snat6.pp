# @summary manage a ipv6 snat rule
define nftables::rules::snat6 (
  # lint:ignore:parameter_documentation
  String[1] $snat,
  Pattern[/^[a-zA-Z0-9_]+$/] $rulename = $title,
  Pattern[/^\d\d$/] $order = '70',
  String[1] $chain = 'POSTROUTING6',
  Optional[String[1]] $oif = undef,
  Optional[String[1]] $saddr = undef,
  Optional[Enum['tcp','udp']] $proto = undef,
  Optional[Variant[String,Stdlib::Port]] $dport = undef,
  Enum['present','absent'] $ensure = 'present',
  # lint:endignore
) {
  $oifname = $oif ? {
    undef   => '',
    default => "oifname ${oif} ",
  }
  $src = $saddr ? {
    undef   => '',
    default => "ip6 saddr ${saddr} ",
  }

  if $proto and $dport {
    $protocol = ''
    $port     = "${proto} dport ${dport} "
  } elsif $proto {
    $protocol = "${proto} "
    $port     = ''
  } elsif $dport {
    $protocol = ''
    $port     = "tcp dport ${dport} "
  } else {
    $protocol = ''
    $port     = ''
  }

  nftables::rule {
    "${chain}-${rulename}":
      ensure  => $ensure,
      table   => "ip6-${nftables::nat_table_name}",
      order   => $order,
      content => "${oifname}${src}${protocol}${port}snat ${snat}";
  }
}
