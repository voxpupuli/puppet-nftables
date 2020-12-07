# manage in tor
class nftables::rules::tor (
  Array[Integer,1]
  $ports = [9001],
) {
  nftables::rule {
    'default_in-tor':
      content => "tcp dport {${join($ports,', ')}} accept",
  }
}
