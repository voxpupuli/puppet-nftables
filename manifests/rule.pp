# manage a chain rule
# Name should be:
#   CHAIN_NAME-rulename
define nftables::rule(
  Enum['present','absent']
    $ensure = 'present',
  Pattern[/^[a-zA-Z0-9_]+-[a-zA-Z0-9_]+(-\d+)?$/]
    $rulename = $title,
  Pattern[/^\d\d$/]
    $order = '50',
  Optional[String]
    $table = 'inet-filter',
  Optional[String]
    $content = undef,
  Optional[Variant[String,Array[String,1]]]
    $source = undef,
){

  if $ensure == 'present' {
    $data = split($rulename, '-')

    concat::fragment{
      "nftables-${table}-chain-${data[0]}-rule-${data[1]}":
        order  => $order,
        target => "nftables-${table}-chain-${data[0]}",
    }

    if $content {
      Concat::Fragment["nftables-${table}-chain-${data[0]}-rule-${data[1]}"]{
        content => "  ${content}",
      }
    } else {
      Concat::Fragment["nftables-${table}-chain-${data[0]}-rule-${data[1]}"]{
        source => $source,
      }
    }
  }
}
