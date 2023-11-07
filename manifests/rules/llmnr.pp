#
# @summary allow incoming Link-Local Multicast Name Resolution
#
# @param ipv4 Allow LLMNR over IPv4
# @param ipv6 Allow LLMNR over IPv6
#
# @see https://datatracker.ietf.org/doc/html/rfc4795
#
class nftables::rules::llmnr (
  Boolean $ipv4 = true,
  Boolean $ipv6 = true,
) {
  if $ipv4 {
    nftables::rule { 'default_in-llmnr_v4':
      content => 'ip daddr 224.0.0.252 udp dport 5355 accept comment "allow LLMNR"',
    }
  }
  if $ipv6 {
    nftables::rule { 'default_in-llmnr_v6':
      content => 'ip6 daddr ff02::1:3 udp dport 5355 accept comment "allow LLMNR"',
    }
  }
}
