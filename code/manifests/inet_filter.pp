# manage basic chains in table inet filter
class nftables::inet_filter inherits nftables {

  $_reject_rule = epp('nftables/reject_rule.epp',
    {
      'log_prefix' => sprintf($nftables::log_prefix, { 'chain' => '%<chain>s', 'comment' => 'Rejected: ' }),
      'log_limit'  => $nftables::log_limit
    }
  )

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
    'INPUT-log_discarded':
      order   => '97',
      content => sprintf($_reject_rule, { 'chain' => 'INPUT' }),
  }
  if $nftables::reject_with {
    nftables::rule{
      'INPUT-reject':
        order   => '98',
        content => "reject with ${$nftables::reject_with}";
    }
  }
  if $nftables::in_out_conntrack {
    nftables::rule{
      'INPUT-accept_established_related':
        order   => '05',
        content => 'ct state established,related accept';
      'INPUT-drop_invalid':
        order   => '06',
        content => 'ct state invalid drop';
    }
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
    'OUTPUT-log_discarded':
      order   => '97',
      content => sprintf($_reject_rule, { 'chain' => 'OUTPUT' }),
  }
  if $nftables::reject_with {
    nftables::rule{
      'OUTPUT-reject':
        order   => '98',
        content => "reject with ${$nftables::reject_with}";
    }
  }
  if $nftables::in_out_conntrack {
    nftables::rule{
      'OUTPUT-accept_established_related':
        order   => '05',
        content => 'ct state established,related accept';
      'OUTPUT-drop_invalid':
        order   => '06',
        content => 'ct state invalid drop';
    }
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
    'FORWARD-log_discarded':
      order   => '97',
      content => sprintf($_reject_rule, { 'chain' => 'FORWARD' }),
  }
  if $nftables::reject_with {
    nftables::rule{
      'FORWARD-reject':
        order   => '98',
        content => "reject with ${$nftables::reject_with}";
    }
  }

  # basic outgoing rules
  if $nftables::out_all {
    include nftables::rules::out::all
  } else {
    if $nftables::out_ntp {
      include nftables::rules::out::chrony
    }
    if $nftables::out_dns {
      include nftables::rules::out::dns
    }
    if $nftables::out_http {
      include nftables::rules::out::http
    }
    if $nftables::out_https {
      include nftables::rules::out::https
    }
    if $nftables::out_icmp {
      include nftables::rules::out::icmp
    }
  }

  # allow forwarding traffic on bridges
  include nftables::bridges

  # basic ingoing rules
  if $nftables::in_ssh {
    include nftables::rules::ssh
  }
  if $nftables::in_icmp {
    include nftables::rules::icmp
  }
}
