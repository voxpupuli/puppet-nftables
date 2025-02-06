

# We need to have a /etc/services file to avoid:
# `Servname not supported for ai_socktype` during nft validate
# maybe module itself should install this package
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=995343

if $facts['os']['name'] == 'Ubuntu' and $facts['os']['release']['major'] == '20.04' {
  package{'netbase':
    ensure => present,
  }
}
