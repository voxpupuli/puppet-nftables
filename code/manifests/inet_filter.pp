# manage basic chains in table inet filter
class nftables::inet_filter inherits nftables {

  nftables::config{
    'inet-filter':
      source => 'puppet:///modules/nftables/config/puppet-inet-filter.nft';
  }

  nftables::chain{
    [
      'INPUT',
      'OUTPUT',
      'FORWARD',
    ]:;
  }

  nftables::chain{
    'default_in':
      inject => '10-INPUT';
    'default_out':
      inject => '10-OUTPUT';
    'default_fwd':
      inject => '10-FORWARD';
  }

  # inet-filter-chain-INPUT
  nftables::rule{
    'INPUT-type':
      order   => '01',
      content => 'type filter hook input priority 0';
    'INPUT-policy':
      order   => '02',
      content => 'policy drop';
    'INPUT-lo':
      order   => '03',
      content => 'iifname lo accept';
    'INPUT-jump_global':
      order   => '04',
      content => 'jump global';
    'INPUT-log_rejected':
      order   => '98',
      content => 'log prefix "[nftables] INPUT Rejected: " flags all counter reject with icmpx type port-unreachable';
  }

  # inet-filter-chain-OUTPUT
  nftables::rule{
    'OUTPUT-type':
      order   => '01',
      content => 'type filter hook output priority 0';
    'OUTPUT-policy':
      order   => '02',
      content => 'policy drop';
    'OUTPUT-lo':
      order   => '03',
      content => 'oifname lo accept';
    'OUTPUT-jump_global':
      order   => '04',
      content => 'jump global';
    'OUTPUT-log_rejected':
      order   => '98',
      content => 'log prefix "[nftables] OUTPUT Rejected: " flags all counter reject with icmpx type port-unreachable';
  }

  # inet-filter-chain-FORWARD
  nftables::rule{
    'FORWARD-type':
      order   => '01',
      content => 'type filter hook forward priority 0';
    'FORWARD-policy':
      order   => '02',
      content => 'policy drop';
    'FORWARD-jump_global':
      order   => '03',
      content => 'jump global';
    'FORWARD-log_rejected':
      order   => '98',
      content => 'log prefix "[nftables] FORWARD Rejected: " flags all counter reject with icmpx type port-unreachable';
  }

  # basic ingoing rules
  if $nftables::in_ssh {
    include nftables::rules::ssh
  }
}
