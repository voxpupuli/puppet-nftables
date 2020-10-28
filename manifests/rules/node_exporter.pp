# manage in node exporter
class nftables::rules::node_exporter(
  Variant[String,Array[String,1]]
    $prometheus,
  Integer
    $port = 9100,
) {
  nftables::rule{
    'default_in-node_exporter':
      content => "ip saddr ${prometheus} tcp dport ${port} accept",
  }
}
