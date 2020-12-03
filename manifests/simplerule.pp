# @summary Provides a simplified interface to nftables::rule for basic use cases
#
# @example allow incoming traffic on port 543 TCP to a given IP range and count packets
#   nftables::simplerule{'my_service_in':
#     action  => 'accept',
#     comment => 'allow traffic to port 543',
#     counter => true,
#     proto   => 'tcp',
#     dport   => 543,
#     daddr   => '2001:1458::/32',
#   }

define nftables::simplerule(
  Enum['present','absent']
    $ensure = 'present',
  Pattern[/^[-a-zA-Z0-9_]+$/]
    $rulename = $title,
  Pattern[/^\d\d$/]
    $order = '50',
  String
    $chain  = 'default_in',
  String
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
  Boolean
    $counter = false,
){

  if $dport and !$proto {
    fail('Specifying a transport protocol via $proto is mandatory when passing a $dport')
  }

  if $ensure == 'present' {
    nftables::rule{"${chain}-${rulename}":
      content => epp('nftables/simplerule.epp',
        {
          'action'   => $action,
          'comment'  => $comment,
          'counter'  => $counter,
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
