#
# @summary allow incoming multicast DNS
#
class nftables::rules::mdns {
  nftables::rule { 'default_in-mdns1':
    content => 'ip daddr 224.0.0.251 accept',
  }
  nftables::rule { 'default_in-mdns2':
    content => 'udp sport 5353 udp dport 5353 accept',
  }
}
