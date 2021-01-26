# manage a chain rule
# Name should be:
#   CHAIN_NAME-rulename
define nftables::rule (
  # lint:ignore:parameter_documentation
  Enum['present','absent'] $ensure = 'present',
  Nftables::RuleName $rulename = $title,
  Pattern[/^\d\d$/] $order = '50',
  Optional[String] $table = 'inet-filter',
  Optional[String] $content = undef,
  Optional[Variant[String,Array[String,1]]] $source = undef,
  # lint:endignore
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
