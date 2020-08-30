# manage a chain
define nftables::chain(
  Pattern[/^(ip|ip6|inet)-[a-zA-Z0-9_]+$/]
    $table = 'inet-filter',
  Pattern[/^[a-zA-Z0-9_]+$/]
    $chain = $title,
  Optional[Pattern[/^\d\d-[a-zA-Z0-9_]+$/]]
    $inject = undef,
){
  $concat_name = "nftables-${table}-chain-${chain}"

  concat{
    $concat_name:
      path           => "/etc/nftables/puppet/${table}-chain-${chain}.nft",
      owner          => root,
      group          => root,
      mode           => '0640',
      ensure_newline => true,
      require        => Package['nftables'],
      notify         => Service['nftables'],
  }

  concat::fragment{
    default:
      target => $concat_name;
    "${concat_name}-header":
      order   => '00',
      content => "chain ${chain} {";
    "${concat_name}-footer":
      order   => '99',
      content => '}';
  }

  if $inject {
    $data = split($inject, '-')
    nftables::rule{ "${data[1]}-jump_${chain}":
      order   => $data[0],
      content => "jump ${chain}",
    }
  }
}
