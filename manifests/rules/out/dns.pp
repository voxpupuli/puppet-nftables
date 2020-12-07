# manage out dns
class nftables::rules::out::dns (
  Optional[Variant[String,Array[String,1]]]
  $dns_server = undef,
) {
  if $dns_server {
    any2array($dns_server).each |$index,$dns| {
      nftables::rule {
        "default_out-dnsudp-${index}":
      }
      if $dns =~ /:/ {
        Nftables::Rule["default_out-dnsudp-${index}"] {
          content => "ip6 daddr ${dns} udp dport 53 accept",
        }
      } else {
        Nftables::Rule["default_out-dnsudp-${index}"] {
          content => "ip daddr ${dns} udp dport 53 accept",
        }
      }

      nftables::rule {
        "default_out-dnstcp-${index}":
      }
      if $dns =~ /:/ {
        Nftables::Rule["default_out-dnstcp-${index}"] {
          content => "ip6 daddr ${dns} tcp dport 53 accept",
        }
      } else {
        Nftables::Rule["default_out-dnstcp-${index}"] {
          content => "ip daddr ${dns} tcp dport 53 accept",
        }
      }
    }
  } else {
    nftables::rule {
      'default_out-dnsudp':
        content => 'udp dport 53 accept';
      'default_out-dnstcp':
        content => 'tcp dport 53 accept';
    }
  }
}
