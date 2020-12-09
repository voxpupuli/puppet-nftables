# manage a custom config file as it is
define nftables::custom_file (
  Optional[String] $content = undef,
  Optional[Variant[String,Array[String,1]]] $source = undef,
) {
  Package['nftables'] -> file {
    "/etc/nftables/puppet-preflight/${name}.nft":
      owner => root,
      group => root,
      mode  => '0640',
  } ~> Exec['nft validate'] -> file {
    "/etc/nftables/puppet/${name}.nft":
      ensure => file,
      source => "/etc/nftables/puppet-preflight/${name}.nft",
      owner  => root,
      group  => root,
      mode   => '0640',
  } ~> Service['nftables']

  if $source {
    File["/etc/nftables/puppet-preflight/${name}.nft"]{
      source => $source,
    }
  } else {
    File["/etc/nftables/puppet-preflight/${name}.nft"]{
      content => $content,
    }
  }
}
