# @summary Default firewall configuration for Docker-CE
#
# The configuration distributed in this class represents the default firewall
# configuration done by docker-ce when the iptables integration is enabled.
#
# This class is needed as the default docker-ce rules added to ip-filter conflict
# with the inet-filter forward rules set by default in this module.
#
# When using this class 'docker::iptables: false' should be set.
#
# @param docker_interface
#   Interface name used by docker. It defaults to docker0.
# @param docker_prefix
#   The address space used by docker. It defaults to 172.17.0.0/16.
#
class nftables::rules::docker_ce (
  String[1]                     $docker_interface = 'docker0',
  Stdlib::IP::Address::V4::CIDR $docker_prefix    = '172.17.0.0/16',
) {
  #
  # inet-filter
  #

  nftables::chain {
    'DOCKER': ;
    'DOCKER_ISOLATION_STAGE_1': ;
    'DOCKER_ISOLATION_STAGE_2': ;
    'DOCKER_USER': ;
  }

  nftables::rule {
    'DOCKER_ISOLATION_STAGE_1-iifname':
      order   => '01',
      content => "iifname \"${docker_interface}\" oifname != \"${docker_interface}\" counter jump DOCKER_ISOLATION_STAGE_2";
    'DOCKER_ISOLATION_STAGE_1-counter':
      order   => '02',
      content => 'counter return';
    'DOCKER_ISOLATION_STAGE_2-drop':
      order   => '01',
      content => "oifname \"${docker_interface}\" counter drop";
    'DOCKER_ISOLATION_STAGE_2-counter':
      order   => '02',
      content => 'counter return';
    'DOCKER_USER-counter':
      order   => '01',
      content => 'counter return',
  }

  nftables::rule {
    'default_fwd-jump_docker_user':
      order   => '40',
      content => 'counter jump DOCKER_USER';
    'default_fwd-jump_docker_isolation_stage_1':
      order   => '41',
      content => 'counter jump DOCKER_ISOLATION_STAGE_1';
    'default_fwd-out_docker_accept':
      order   => '42',
      content => "oifname \"${docker_interface}\" ct state established,related counter accept";
    'default_fwd-jump_docker':
      order   => '43',
      content => "oifname \"${docker_interface}\" counter jump DOCKER";
    'default_fwd-idocker_onot_accept':
      order   => '44',
      content => "iifname \"${docker_interface}\" oifname != \"${docker_interface}\" counter accept";
    'default_fwd-idocker_odocker_accept':
      order   => '45',
      content => "iifname \"${docker_interface}\" oifname \"${docker_interface}\" counter accept";
  }

  #
  # ip-nat
  #

  nftables::chain {
    'DOCKER-nat':
      table => 'ip-nat',
      chain => 'DOCKER';
    'OUTPUT-nat':
      table => 'ip-nat',
      chain => 'OUTPUT';
    'INPUT-nat':
      table => 'ip-nat',
      chain => 'INPUT';
  }

  nftables::rule {
    'POSTROUTING-docker':
      table   => 'ip-nat',
      content => "oifname != \"${docker_interface}\" ip saddr ${docker_prefix} counter masquerade";
    'PREROUTING-docker':
      table   => 'ip-nat',
      content => 'fib daddr type local counter jump DOCKER';
    'OUTPUT-jump_docker@ip-nat':
      rule_name => 'OUTPUT-jump_docker',
      table     => 'ip-nat',
      content   => 'ip daddr != 127.0.0.0/8 fib daddr type local counter jump DOCKER';
    'DOCKER-counter':
      table   => 'ip-nat',
      content => "iifname \"${docker_interface}\" counter return";
    'INPUT-type@ip-nat':
      rulename => 'INPUT-type',
      table    => 'ip-nat',
      order    => '01',
      content  => 'type nat hook input priority 100';
    'INPUT-policy@ip-nat':
      rulename => 'INPUT-policy',
      table    => 'ip-nat',
      order    => '02',
      content  => 'policy accept';
  }
}
