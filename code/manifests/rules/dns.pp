# manage in dns
class nftables::rules::dns (
  Array[Integer,1] $ports = [53],
) {
  nftables::rule {
    'default_in-dns_tcp':
      content => "tcp dport {${join($ports,', ')}} accept";
    'default_in-dns_udp':
      content => "udp dport {${join($ports,', ')}} accept";
  }
}
