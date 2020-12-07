# manage in wireguard
class nftables::rules::wireguard (
  Array[Integer,1] $ports = [51820],
) {
  nftables::rule {
    'default_in-wireguard':
      content => "udp dport {${join($ports,', ')}} accept",
  }
}
