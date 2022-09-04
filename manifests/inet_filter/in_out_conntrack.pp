# @summary manage input & output conntrack
class nftables::inet_filter::in_out_conntrack {
  nftables::rule {
    'INPUT-accept_established_related':
      order   => '05',
      content => 'ct state established,related accept';
    'INPUT-drop_invalid':
      order   => '06',
      content => 'ct state invalid drop';
    'OUTPUT-accept_established_related':
      order   => '05',
      content => 'ct state established,related accept';
    'OUTPUT-drop_invalid':
      order   => '06',
      content => 'ct state invalid drop';
  }
}
