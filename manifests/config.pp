# manage a config snippet
define nftables::config (
  Pattern[/^\w+-\w+$/] $tablespec = $title,
  Optional[String] $content = undef,
  Optional[Variant[String,Array[String,1]]] $source = undef,
) {
  if $content and $source {
    fail('Please pass only $content or $source, not both.')
  }

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
    if $content {
      $_content = $content
    } else {
      $_content = "  include \"${name}-chain-*.nft\""
    }
    concat::fragment {
      "${concat_name}-body":
        target  => $concat_name,
        order   => '98',
        content => $_content,
    }
  }

  concat::fragment {
    "${concat_name}-footer":
      target  => $concat_name,
      order   => '99',
      content => '}',
  }
}
