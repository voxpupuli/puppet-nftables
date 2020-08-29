# manage out chrony
class nftables::rules::out::chrony {
  nftables::filter::chain::rule{
    'default_out-chrony':
      content => 'udp dport 123 accept',
  }
}
