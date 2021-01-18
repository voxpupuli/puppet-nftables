# @summary manage Samba, the suite to allow Windows file sharing on Linux resources.
# @param ctdb Enable ctdb-driven clustered Samba setups.
class nftables::rules::samba (
  Boolean $ctdb = false,
) {
  nftables::rule {
    'default_in-netbios_tcp':
      content => 'tcp dport {139,445} accept',
  }

  nftables::rule {
    'default_in-netbios_udp':
      content => 'udp dport {137,138} accept',
  }

  if ($ctdb) {
    nftables::rule {
      'default_in-ctdb':
        content => 'tcp dport 4379 accept',
    }
  }
}
