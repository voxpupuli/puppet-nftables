# allow forwarding traffic on bridges
class nftables::bridges (
  # lint:ignore:parameter_documentation
  Enum['present','absent'] $ensure = 'present',
  Pattern[/^\^.+/] $bridgenames = '^br.+',
  # lint:endignore
) {
  if $ensure == 'present' {
    $interfaces = keys($facts['networking']['interfaces'])
    $bridges = $interfaces.filter |$items| { $items =~ Regexp($bridgenames) }

    $bridges.each |String $bridge| {
      $bridge_rulename = regsubst($bridge, '-|:', '_', 'G')
      nftables::rule { "default_fwd-bridge_${bridge_rulename}_${bridge_rulename}":
        order   => '08',
        content => "iifname ${bridge} oifname ${bridge} accept",
      }
    }
  }
}
