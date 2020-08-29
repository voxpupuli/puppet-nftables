# manage a filter chain rule
# Name should be:
#   CHAIN_NAME-rulename
define nftables::filter::chain::rule(
  Enum['present','absent']
    $ensure = 'present',
  Pattern[/^[a-z0-9_]+\-[0-9a-z]+$/]
    $rulename = $title,
  Pattern[/^\d\d$/]
    $order = '50',
  Optional[String]
    $content = undef,
  Optional[Variant[String,Array[String,1]]]
    $source = undef,
){
  if $ensure == 'present' {
    $data = split($rulename,'-')
    concat::fragment{
      "nftables-filter-chain-rule-${rulename}":
        order  => $order,
        target => "nftables-chain-filter-${data[0]}",
    }

    if $content {
      Concat::Fragment["nftables-filter-chain-rule-${rulename}"]{
        content => "  ${content}",
      }
    } else {
      Concat::Fragment["nftables-filter-chain-rule-${rulename}"]{
        source => $source,
      }
    }
  }
}
