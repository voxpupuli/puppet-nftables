# manage in ospf3
class nftables::rules::ospf3 {
  nftables::rule {
    'default_in-ospf3':
      content => 'ip6 saddr fe80::/64 ip6 daddr { ff02::5, ff02::6 } meta l4proto 89 accept',
  }
}
