# disable outgoing ssh
class nftables::rules::out::ssh::remove inherits nftables::rules::out::ssh {
  Nftables::Filter::Chain::Rule['default_out-ssh']{
    ensure => absent,
  }
}
