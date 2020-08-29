# manage out ntp
class nftables::rules::out::ntp {
  nftables::filter::chain::rule{
    'default_out-ntp':
      content => 'udp sport 123 udp dport 123 accept';
  }
}
