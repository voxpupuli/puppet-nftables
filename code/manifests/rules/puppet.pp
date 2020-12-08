# manage in puppet
class nftables::rules::puppet (
  Array[Integer,1] $ports = [8140],
) {
  nftables::rule {
    'default_in-puppet':
      content => "tcp dport {${join($ports,', ')}} accept",
  }
}
