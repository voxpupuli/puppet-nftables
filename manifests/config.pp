# manage a config snippet
define nftables::config (
  Optional[String] $content = undef,
  Optional[Variant[String,Array[String,1]]] $source = undef,
) {
  $concat_name = "nftables-${name}"

  Package['nftables'] -> concat {
    $concat_name:
      path           => "/etc/nftables/puppet-preflight/${name}.nft",
      ensure_newline => true,
      owner          => root,
      group          => root,
      mode           => '0640',
  } ~> Exec['nft validate'] -> file {
    "/etc/nftables/puppet/${name}.nft":
      ensure => file,
      source => "/etc/nftables/puppet-preflight/${name}.nft",
      owner  => root,
      group  => root,
      mode   => '0640',
  } ~> Service['nftables']

  $data = split($name, '-')

  concat::fragment {
    "${concat_name}-header":
      target  => $concat_name,
      order   => '00',
      content => "table ${data[0]} ${data[1]} {",
  }

  if $source {
    concat::fragment {
      "${concat_name}-body":
        target => $concat_name,
        order  => 98,
        source => $source,
    }
  } else {
    concat::fragment {
      "${concat_name}-body":
        target  => $concat_name,
        order   => '98',
        content => $content,
    }
  }

  concat::fragment {
    "${concat_name}-footer":
      target  => $concat_name,
      order   => '99',
      content => '}',
  }
}
