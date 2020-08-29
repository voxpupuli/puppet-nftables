# manage in wireguard
class nftables::rules::wireguard(
  Array[Integer,1]
    $ports = [51820],
) {
  nftables::filter::chain::rule{
    'default_in-wireguard':
      content => "udp dport {${join($ports,', ')}} accept",
  }
}
