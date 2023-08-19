#
# @summary allow incoming multicast DNS
#
# @param ipv4
#   Allow mdns over IPv4
# @param ipv6
#   Allow mdns over IPv6
class nftables::rules::mdns (
  Boolean $ipv4 = true,
  Boolean $ipv6 = true,
) {
  if $ipv4 {
    nftables::rule { 'default_in-mdns_v4':
      content => 'ip daddr 224.0.0.251 udp dport 5353 accept',
    }
  }
  if $ipv6 {
    nftables::rule { 'default_in-mdns_v6':
      content => 'ip6 daddr ff02::fb udp dport 5353 accept',
    }
  }
}
