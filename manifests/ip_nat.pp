# manage basic chains in table ip nat
class nftables::ip_nat inherits nftables {
  nftables::config { ['ip-nat', 'ip6-nat']: }

  nftables::chain {
    [
      'PREROUTING',
      'POSTROUTING',
    ]:
      table => 'ip-nat';
  }

  nftables::chain {
    [
      'PREROUTING6',
      'POSTROUTING6',
    ]:
      table => 'ip6-nat';
  }

  # ip-nat-chain-PREROUTING
  nftables::rule {
    'PREROUTING-type':
      table   => 'ip-nat',
      order   => '01',
      content => 'type nat hook prerouting priority -100';
    'PREROUTING-policy':
      table   => 'ip-nat',
      order   => '02',
      content => 'policy accept';
    'PREROUTING6-type':
      table   => 'ip6-nat',
      order   => '01',
      content => 'type nat hook prerouting priority -100';
    'PREROUTING6-policy':
      table   => 'ip6-nat',
      order   => '02',
      content => 'policy accept';
  }

  # ip-nat-chain-POSTROUTING
  nftables::rule {
    'POSTROUTING-type':
      table   => 'ip-nat',
      order   => '01',
      content => 'type nat hook postrouting priority 100';
    'POSTROUTING-policy':
      table   => 'ip-nat',
      order   => '02',
      content => 'policy accept';
    'POSTROUTING6-type':
      table   => 'ip6-nat',
      order   => '01',
      content => 'type nat hook postrouting priority 100';
    'POSTROUTING6-policy':
      table   => 'ip6-nat',
      order   => '02',
      content => 'policy accept';
  }
}
