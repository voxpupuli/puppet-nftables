# manage in nfs3
class nftables::rules::nfs3 {
  nftables::rule {
    'default_in-nfs3':
      # To support nftables >= 0.9.0, but < 0.9.3, `@th,16,16 2049` is used instead of `th dport nfs`
      content => 'meta l4proto { tcp, udp } @th,16,16 2049 accept comment "Accept NFS3"',
  }
}
