# manage out chrony
class nftables::rules::out::chrony {
  nftables::rule{
    'default_out-chrony':
      content => 'udp dport 123 accept',
  }
}
