# manage basic chains in table ip nat
class nftables::ip_nat inherits nftables {

  nftables::config{
    'ip-nat':
      source => 'puppet:///modules/nftables/config/puppet-ip-nat.nft';
  }

  nftables::chain{
    [
      'PREROUTING',
      'POSTROUTING',
    ]:
      table => 'ip-nat';
  }

  # ip-nat-chain-PREROUTING
  nftables::rule{
    default:
      table   => 'ip-nat';
    'PREROUTING-type':
      order   => '01',
      content => 'type nat hook prerouting priority -100';
    'PREROUTING-policy':
      order   => '02',
      content => 'policy accept';
  }

  # ip-nat-chain-POSTROUTING
  nftables::rule{
    default:
      table   => 'ip-nat';
    'POSTROUTING-type':
      order   => '01',
      content => 'type nat hook postrouting priority 100';
    'POSTROUTING-policy':
      order   => '02',
      content => 'policy accept';
  }
}
