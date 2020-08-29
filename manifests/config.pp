# manage a config snippet
define nftables::config(
  Optional[String]
    $content = undef,
  Optional[Variant[String,Array[String,1]]]
    $source = undef,
){
  Package['nftables'] -> file{
    "/etc/nftables/puppet/${name}.nft":
      owner => root,
      group => root,
      mode  => '0640',
  } ~> Service['nftables']

  if $source {
    File["/etc/nftables/puppet/${name}.nft"]{
      source => $source,
    }
  } else {
    File["/etc/nftables/puppet/${name}.nft"]{
      content => $content,
    }
  }
}
