# manage out tor
class nftables::rules::out::tor {
  nftables::filter::chain::rule{
    'default_out-tor':
      content => 'tcp dport 9001 accept',
  }
}
