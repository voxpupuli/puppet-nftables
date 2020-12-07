# manage in icinga2
class nftables::rules::icinga2 (
  Array[Integer,1]
  $ports = [5665],
) {
  nftables::rule {
    'default_in-icinga2':
      content => "tcp dport {${join($ports,', ')}} accept",
  }
}
