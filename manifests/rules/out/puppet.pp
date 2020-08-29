# manage outgoing puppet
class nftables::rules::out::puppet(
  Variant[String,Array[String,1]]
    $puppetmaster,
  Integer
    $puppetserver_port = 8140,
) {
  any2array($puppetmaster).each |$index,$pm| {
    nftables::filter::chain::rule{
      "default_out-puppet-${index}":
    }
    if $pm =~ /:/ {
      Nftables::Filter::Chain::Rule["default_out-puppet-${index}"]{
        content => "ip6 daddr ${pm} tcp dport ${puppetserver_port} accept",
      }
    } else {
      Nftables::Filter::Chain::Rule["default_out-puppet-${index}"]{
        content => "ip daddr ${pm} tcp dport ${puppetserver_port} accept",
      }
    }
  }
}
