# manage a chain file
# chain must be:
#   TABLE@chain_name
define nftables::chain_file(
  Pattern[/^[a-z0-9]+@[a-z0-9_]+$/] $chain = $title,
){
  $data = split($chain,'@')
  $concat_name = "nftables-chain-${data[0]}-${data[1]}"
  concat{
    $concat_name:
      path           => "/etc/nftables/puppet/${data[0]}-chains-${data[1]}.nft",
      owner          => root,
      group          => root,
      mode           => '0644',
      ensure_newline => true,
      require        => Package['nftables'],
      notify         => Service['nftables'],
  }
  concat::fragment{
    default:
      target => $concat_name;
    "${chain}-header":
      order   => '00',
      content => "chain ${data[1]} {";
    "${chain}-footer":
      order   => '99',
      content => '}';
  }
}
