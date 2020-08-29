# manage out ssh
class nftables::rules::out::ssh {
  nftables::filter::chain::rule{
    'default_out-ssh':
      content => 'tcp dport 22 accept',
  }
}
