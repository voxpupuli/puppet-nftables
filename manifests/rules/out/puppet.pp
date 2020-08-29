# manage outgoing puppet
class nftables::rules::out::puppet(
  Variant[String,Array[String,1]]
    $puppetmaster,
  Integer
    $puppetserver_port = 8140,
) {
  any2array($puppetmaster).each |$index,$pm| {
    nftables::rule{
      "default_out-puppet-${index}":
    }
    if $pm =~ /:/ {
      nftables::rule["default_out-puppet-${index}"]{
        content => "ip6 daddr ${pm} tcp dport ${puppetserver_port} accept",
      }
    } else {
      nftables::rule["default_out-puppet-${index}"]{
        content => "ip daddr ${pm} tcp dport ${puppetserver_port} accept",
      }
    }
  }
}
