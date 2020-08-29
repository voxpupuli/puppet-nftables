# manage out smtp
class nftables::rules::out::smtp {
  nftables::filter::chain::rule{
    'default_out-smtp':
      content => 'tcp dport 25 accept',
  }
}
