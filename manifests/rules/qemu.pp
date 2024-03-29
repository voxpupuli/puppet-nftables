# @summary Bridged network configuration for qemu/libvirt
#
# This class configures the typical firewall setup that libvirt
# creates. Depending on your requirements you can switch on and off
# several aspects, for instance if you don't do DHCP to your guests
# you can disable the rules that accept DHCP traffic on the host or if
# you don't want your guests to talk to hosts outside you can disable
# forwarding and/or masquerading for IPv4 traffic.
#
# @param interface
#   Interface name used by the bridge.
#
# @param network_v4
#   The IPv4 network prefix used in the virtual network.
#
# @param network_v6
#   The IPv6 network prefix used in the virtual network.
#
# @param dns
#   Allow DNS traffic from the guests to the host.
#
# @param dhcpv4
#   Allow DHCPv4 traffic from the guests to the host.
#
# @param forward_traffic
#   Allow forwarded traffic (out all, in related/established)
#   generated by the virtual network.
#
# @param internal_traffic
#   Allow guests in the virtual network to talk to each other.
#
# @param masquerade
#   Do NAT masquerade on all IPv4 traffic generated by guests
#   to external networks.
class nftables::rules::qemu (
  String[1]                               $interface         = 'virbr0',
  Stdlib::IP::Address::V4::CIDR           $network_v4        = '192.168.122.0/24',
  Optional[Stdlib::IP::Address::V6::CIDR] $network_v6        = undef,
  Boolean                                 $dns               = true,
  Boolean                                 $dhcpv4            = true,
  Boolean                                 $forward_traffic   = true,
  Boolean                                 $internal_traffic  = true,
  Boolean                                 $masquerade        = true,
) {
  if $dns {
    nftables::rule {
      'default_in-qemu_udp_dns':
        content => "iifname \"${interface}\" udp dport 53 accept";
      'default_in-qemu_tcp_dns':
        content => "iifname \"${interface}\" tcp dport 53 accept";
    }
  }

  if $dhcpv4 {
    nftables::rule {
      'default_in-qemu_dhcpv4':
        content => "iifname \"${interface}\" meta l4proto udp udp dport 67 accept";
      # The rule below is created by libvirt. It should not be necessary here
      # as it should be accepted by the conntrack rules in OUTPUT.
      #'default_out-qemu_dhcpv4':
      #  content => "oifname \"${interface}\" meta l4proto udp udp dport 68 accept";
    }
  }

  if $forward_traffic {
    nftables::rule {
      'default_fwd-qemu_oip_v4':
        content => "oifname \"${interface}\" ip daddr ${network_v4} ct state related,established accept";
      'default_fwd-qemu_iip_v4':
        content => "iifname \"${interface}\" ip saddr ${network_v4} accept";
    }
    if $network_v6 {
      nftables::rule {
        'default_fwd-qemu_oip_v6':
          content => "oifname \"${interface}\" ip6 daddr ${network_v6} ct state related,established accept";
        'default_fwd-qemu_iip_v6':
          content => "iifname \"${interface}\" ip6 saddr ${network_v6} accept";
      }
    }
  }

  if $internal_traffic {
    nftables::rule {
      'default_fwd-qemu_io_internal':
        content => "iifname \"${interface}\" oifname \"${interface}\" accept",
    }
  }

  # Libvirt rejects all the remaining forwarded traffic passing
  # through the virtual interface. This is not necessary here because
  # of the default policy in default_fwd.

  if $masquerade {
    nftables::rule {
      'POSTROUTING-qemu_ignore_multicast':
        table   => "ip-${nftables::nat_table_name}",
        content => "ip saddr ${network_v4} ip daddr 224.0.0.0/24 return";
      'POSTROUTING-qemu_ignore_broadcast':
        table   => "ip-${nftables::nat_table_name}",
        content => "ip saddr ${network_v4} ip daddr 255.255.255.255 return";
      'POSTROUTING-qemu_masq_tcp':
        table   => "ip-${nftables::nat_table_name}",
        content => "meta l4proto tcp ip saddr ${network_v4} ip daddr != ${network_v4} masquerade to :1024-65535";
      'POSTROUTING-qemu_masq_udp':
        table   => "ip-${nftables::nat_table_name}",
        content => "meta l4proto udp ip saddr ${network_v4} ip daddr != ${network_v4} masquerade to :1024-65535";
      'POSTROUTING-qemu_masq_ip':
        table   => "ip-${nftables::nat_table_name}",
        content => "ip saddr ${network_v4} ip daddr != ${network_v4} masquerade";
    }
  }
}
