# manage out ospf3
class nftables::rules::out::ospf3 {
  nftables::rule{
    'default_out-ospf3':
      content => 'ip6 saddr fe80::/64 ip6 daddr { ff02::5, ff02::6 } meta l4proto ospf accept',
  }
}
