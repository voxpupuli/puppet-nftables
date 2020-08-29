# manage out dns
class nftables::rules::out::dns {
  nftables::filter::chain::rule{
    'default_out-dnsudp':
      content => 'udp dport 53 accept';
    'default_out-dnstcp':
      content => 'tcp dport 53 accept';
  }
}
