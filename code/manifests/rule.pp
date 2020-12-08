# manage a chain rule
# Name should be:
#   CHAIN_NAME-rulename
define nftables::rule (
  Enum['present','absent'] $ensure = 'present',
  Pattern[/^[a-zA-Z0-9_]+-[a-zA-Z0-9_]+(-\d+)?$/] $rulename = $title,
  Pattern[/^\d\d$/] $order = '50',
  Optional[String] $table = 'inet-filter',
  Optional[String] $content = undef,
  Optional[Variant[String,Array[String,1]]] $source = undef,
) {
  if $ensure == 'present' {
    $data = split($rulename, '-')

    if $data[2] {
      $fragment = "nftables-${table}-chain-${data[0]}-rule-${data[1]}-${data[2]}"
    } else {
      $fragment = "nftables-${table}-chain-${data[0]}-rule-${data[1]}"
    }

    concat::fragment { "${fragment}_header":
      content => "#   Start of fragment order:${order} rulename:${rulename}",
      order   => "${order}-${fragment}-a",
      target  => "nftables-${table}-chain-${data[0]}",
    }

    concat::fragment {
      $fragment:
        order  => "${order}-${fragment}-b",
        target => "nftables-${table}-chain-${data[0]}",
    }

    if $content {
      Concat::Fragment[$fragment] {
        content => "  ${content}",
      }
    } else {
      Concat::Fragment[$fragment] {
        source => $source,
      }
    }
  }
}
