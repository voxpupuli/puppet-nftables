# This class is meant to be useful to ease the migration from the Firewall type
# for simple use cases. The coverage of all the casuistry is rather low so for
# any case not covered by nftables::simplerule please just use nftables::rule.
define nftables::simplerule(
  Enum['present','absent']
    $ensure = 'present',
  Pattern[/^[-a-zA-Z0-9_]+$/]
    $rulename = $title,
  Pattern[/^\d\d$/]
    $order = '50',
  String
    $chain  = 'default_in',
  Optional[String]
    $table = 'inet-filter',
  Enum['accept', 'drop']
    $action = 'accept',
  Optional[String]
    $comment = undef,
  Optional[Variant[Array[Stdlib::Port, 1], Stdlib::Port, Pattern[/\d+-\d+/]]]
    $dport  = undef,
  Optional[Enum['tcp', 'tcp4', 'tcp6', 'udp', 'udp4', 'udp6']]
    $proto  = undef,
  Optional[Variant[Stdlib::IP::Address::V6, Stdlib::IP::Address::V4, Pattern[/^@[-a-zA-Z0-9_]+$/]]]
    $daddr = undef,
  Enum['ip', 'ip6']
    $set_type = 'ip6',
){

  if $dport and !$proto {
    fail('Specifying a transport protocol via $proto is mandatory when passing a port')
  }

  if $ensure == 'present' {
    nftables::rule{"${chain}-${rulename}":
      content => epp('nftables/simplerule.epp',
        {
          'action'   => $action,
          'comment'  => $comment,
          'dport'    => $dport,
          'proto'    => $proto,
          'daddr'    => $daddr,
          'set_type' => $set_type,
        }
      ),
      order   => $order,
      table   => $table,
    }
  }
}
