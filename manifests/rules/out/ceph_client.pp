# Ceph is a distributed object store and file system.
# Enable this to be a client of Ceph's Monitor (MON),
# Object Storage Daemons (OSD), Metadata Server Daemons (MDS),
# and Manager Daemons (MGR).
class nftables::rules::out::ceph_client (
  Array[Integer,1] $ports = [3300, 6789],
) {
  nftables::rule {
    'default_out-ceph_client':
      content => "tcp dport { ${$ports.join(', ')}, 6800-7300 } accept comment \"Accept Ceph MON, OSD, MDS, MGR\"",
  }
}
