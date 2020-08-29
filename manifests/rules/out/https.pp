# manage out https
class nftables::rules::out::https {
  nftables::filter::chain::rule{
    'default_out-https':
      content => 'tcp dport 443 accept';
  }
}
