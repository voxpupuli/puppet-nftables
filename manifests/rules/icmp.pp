class nftables::rules::icmp (
  Optional[Array[String]] $v4_types = undef,
  Optional[Array[String]] $v6_types = undef,
  String $order                     = '10',
) {
  if $v4_types {
    $v4_types.each | String $icmp_type | {
      nftables::rule{
        "default_in-accept_icmpv4_${regsubst(split($icmp_type, ' ')[0], '-', '_', 'G')}":
          content => "ip protocol icmp icmp type ${icmp_type} accept",
          order   => $order,
      }
    }
  } else {
    nftables::rule{
      'default_in-accept_icmpv4':
        content => 'ip protocol icmp accept',
        order   => $order,
      }
  }

  if $v6_types {
    $v6_types.each | String $icmp_type | {
      nftables::rule{
        "default_in-accept_icmpv6_${regsubst(split($icmp_type, ' ')[0], '-', '_', 'G')}":
          content => "ip6 nexthdr ipv6-icmp icmpv6 type ${icmp_type} accept",
          order   => $order,
      }
    }
  } else {
    nftables::rule{
      'default_in-accept_icmpv6':
        content => 'ip6 nexthdr ipv6-icmp accept',
        order   => $order,
      }
  }
}
