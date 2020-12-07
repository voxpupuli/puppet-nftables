# allow forwarding traffic on bridges
class nftables::bridges (
  Enum['present','absent']
  $ensure = 'present',
  Regexp
  $bridgenames = /^br.+/
) {
  if $ensure == 'present' {
    $interfaces = keys($facts['networking']['interfaces'])
    $bridges = $interfaces.filter |$items| { $items =~ $bridgenames }

    $bridges.each |String $bridge| {
      $bridge_rulename = regsubst($bridge, '-', '_', 'G')
      nftables::rule { "default_fwd-bridge_${bridge_rulename}_${bridge_rulename}":
        order   => '08',
        content => "iifname ${bridge} oifname ${bridge} accept",
      }
    }
  }
}
