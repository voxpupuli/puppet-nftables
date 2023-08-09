#
# @summary allow incoming multicast DNS
#
class nftables::rules::mdns {
  nftables::rule { 'default_in-mdns':
    content => 'ip daddr 224.0.0.251 accept',
  }
}
