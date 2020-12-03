# This class is meant to be useful to ease the migration from the Firewall type
# for simple use cases. The coverage of all the casuistry is rather low so for
# any case not covered by nftables::simplerule please just use nftables::rule.
define nftables::simplerule(
  Enum['present','absent']
    $ensure = 'present',
  Pattern[/^[-a-zA-Z0-9_]+$/]
    $setname = $title,
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
  Optional[Integer[1, 65535]]
    $dport  = undef,
  Optional[Enum['tcp', 'udp']]
    $proto  = undef,
){

  if $ensure == 'present' {
    nftables::rule{"${chain}-${title}":
      content => epp('nftables/simplerule.epp',
        {
          'action'  => $action,
          'comment' => $comment,
          'dport'   => $dport,
          'proto'   => $proto,
        }
      ),
      order   => $order,
      table   => $table,
    }
  }
}
