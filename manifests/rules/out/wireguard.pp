# manage out wireguard
class nftables::rules::out::wireguard (
  Array[Integer,1]
    $ports = [51820],
) {
  nftables::filter::chain::rule{
    'default_out-wireguard':
      content => "udp dport {${join($ports,', ')}} accept",
  }
}
