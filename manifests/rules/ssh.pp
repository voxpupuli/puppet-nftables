# manage in ssh
class nftables::rules::ssh(
  Array[Integer,1]
    $ports = [22],
) {
  nftables::rule{
    'default_in-ssh':
      content => "tcp dport {${join($ports,', ')}} accept",
  }
}
