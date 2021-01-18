# manage in samba/ctdb
class nftables::rules::samba {
  nftables::rule {
    'default_in-netbios_tcp':
      content => 'tcp dport {139,445} accept',
  }

  nftables::rule {
    'default_in-netbios_udp':
      content => 'udp dport {137,138} accept',
  }

  nftables::rule {
    'default_in-ctdb':
      content => 'tcp dport 4379 accept',
  }
}
