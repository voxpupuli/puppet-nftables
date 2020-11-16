# manage a named set
define nftables::set(
  Enum['present','absent']
    $ensure = 'present',
  Pattern[/^[a-zA-Z0-9_]+$/]
    $setname = $title,
  Pattern[/^\d\d$/]
    $order = '10',
  Optional[Enum['ipv4_addr', 'ipv6_addr', 'ether_addr', 'inet_proto', 'inet_service', 'mark']]
    $type = undef,
  String
    $table = 'inet-filter',
  Array[Enum['constant', 'dynamic', 'interval', 'timeout'], 0, 4]
    $flags = [],
  Optional[Integer]
    $timeout = undef,
  Optional[Integer]
    $gc_interval = undef,
  Optional[Array[String]]
    $elements = undef,
  Optional[Integer]
    $size = undef,
  Optional[Enum['performance', 'memory']]
    $policy = undef,
  Boolean
    $auto_merge = false,
  Optional[String]
    $content = undef,
  Optional[Variant[String,Array[String,1]]]
    $source = undef,
){

  if $size and $elements {
    if length($elements) > $size {
      fail("Max size of set ${setname} of ${size} is not being respected")
    }
  }

  if $ensure == 'present' {
    concat::fragment{
      "nftables-${table}-set-${setname}":
        order  => $order,
        target => "nftables-${table}",
    }

    if $content {
      Concat::Fragment["nftables-${table}-set-${setname}"]{
        content => "  ${content}",
      }
    } elsif $source {
      Concat::Fragment["nftables-${table}-set-${setname}"]{
        source => $source,
      }
    } else {
      if $type == undef {
        fail('The way the resource is configured must have a type set')
      }
      Concat::Fragment["nftables-${table}-set-${setname}"]{
        content => epp('nftables/set.epp',
          {
            'name'        => $setname,
            'type'        => $type,
            'flags'       => $flags,
            'timeout'     => $timeout,
            'gc_interval' => $gc_interval,
            'elements'    => $elements,
            'size'        => $size,
            'policy'      => $policy,
            'auto_merge'  => $auto_merge,
          }
        )
      }
    }
  }
}
