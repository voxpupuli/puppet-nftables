#
# @summary manage outgoing DNS responses from a DNS server
#
# @param dns_servers optional list of local ip addresses from the DNS server
#
class nftables::rules::out::dnsserver (
  Array[Stdlib::IP::Address] $dns_servers = [],
) {
  unless empty($dns_servers) {
    $dns_servers.each |$index,$dns| {
      $content = $dns ? {
        Stdlib::IP::Address::V6 => "ip6 saddr ${dns}",
        Stdlib::IP::Address::V4 => "ip saddr ${dns}",
      }
      nftables::rule { "default_out-dnsservertcp-${index}":
        content => "${content} tcp sport 53 accept",
      }
      nftables::rule { "default_out-dnsserverudp-${index}":
        content => "${content} udp sport 53 accept",
      }
    }
  } else {
    nftables::rule {
      'default_out-dnsserverudp':
        content => 'udp sport 53 accept';
      'default_out-dnsservertcp':
        content => 'tcp sport 53 accept';
    }
  }
}
